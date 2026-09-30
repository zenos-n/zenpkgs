{ pkgs, zenosModule, zenDsl }:

let
  python = pkgs.python3.withPackages (p: [ p.pygobject3 ]);
  policyBundle = pkgs.runCommand "zenos-desktop-policy-bundle" { } ''
    mkdir -p "$out/modules/system"
    for module in ${../modules/system/diagnostics.zmdl} ${../modules/system/sharing.zmdl} ${../modules/system/fonts.zmdl} ${../modules/system/audio.zmdl} ${../modules/system/bluetooth.zmdl} ${../modules/system/hardware.zmdl} ${../modules/system/locale.zmdl} ${../modules/system/networking.zmdl} ${../modules/system/packaging.zmdl} ${../modules/system/power.zmdl} ${../modules/system/printing.zmdl} ${../modules/system/security.zmdl} ${../modules/system/storage.zmdl} ${../modules/system/zenfs.zmdl}; do
      name=$(basename "$module")
      cp "$module" "$out/modules/system/''${name#*-}"
    done
    cat > "$out/structure.zstr" <<'ZSTR'
    system._meta.type = (zmdl system);
    ZSTR
    ${zenDsl}/bin/zen-dsl compile-tree --root "$out" --output "$out/bundle.json" --mode interface
  '';
  # Application wrappers normally add their private schemas. The standalone
  # inspection tools need the same pinned schemas, without altering the VM.
  schemas = pkgs.runCommand "zenos-desktop-test-schemas" {
    nativeBuildInputs = [ pkgs.glib ];
  } ''
    mkdir -p "$out"
    for package in ${pkgs.gsettings-desktop-schemas} ${pkgs.gnome-settings-daemon} ${pkgs.mutter} ${pkgs.nautilus} ${pkgs.gnome-text-editor} ${pkgs.gnome-console} ${pkgs.gnome-calculator} ${pkgs.gnome-calendar} ${pkgs.gnome-clocks} ${pkgs.loupe} ${pkgs.papers} ${pkgs.gdm}; do
      find "$package/share/gsettings-schemas" -name '*.xml' -exec cp {} "$out/" \;
    done
    glib-compile-schemas --strict "$out"
  '';
in
pkgs.testers.runNixOSTest {
  name = "zenos-desktop-options";
  node.pkgsReadOnly = false;
  nodes.machine = { lib, ... }: {
    imports = [ zenosModule ];
    boot.consoleLogLevel = lib.mkForce 7;
    boot.initrd.verbose = lib.mkForce true;
    environment.systemPackages = [ pkgs.dconf pkgs.glib python ];
    environment.variables.GI_TYPELIB_PATH = "${pkgs.glib.out}/lib/girepository-1.0";
    zenos = {
      system = {
        networking.computerName = "desktop-options";
        audio = { enable = true; legacyApplications = true; };
        bluetooth = { enable = true; powerOnAtBoot = false; };
        locale = { timeZone = "Europe/Warsaw"; language = "en_US.UTF-8"; };
        security = { firewall = true; respondToPing = false; remoteLogin = false; };
        storage = { removableDrives = true; ssdMaintenance = true; };
        programs.nautilus = { enable = true; singleClickOpen = true; };
      };
      desktops.gnome = {
        enable = true;
        wallpaper.lightImage = "file://${pkgs.gnome-backgrounds}/share/backgrounds/gnome/adwaita-l.jxl";
        wallpaper.darkImage = "file://${pkgs.gnome-backgrounds}/share/backgrounds/gnome/adwaita-d.jxl";
        showBatteryPercentage = false;
        shortcuts = { openCalculator = [ "<Super>c" ]; lockScreen = [ ]; };
        loginScreen = {
          showUsers = false; showPowerButtons = false; message = "Welcome to ZenOS";
          attemptsBeforeUserSelection = 5; textScale = 1.25;
          clockFormat = "12h"; automaticSuspend = false;
        };
        accessibility = { hoverClick = true; hoverClickDelaySeconds = 1.5; flashForBell = true; };
        magnification = { zoom = 2.5; pointerTracking = "centered"; crosshairOpacity = 0.75; };
        touchpad.tapToClick = false;
        keyboard.repeatDelayMilliseconds = 350;
        privacy.rememberRecentFiles = false;
        nightLight = { enable = true; temperature = 4000; };
      };
      users.bob = { };
      users.alice.programs = {
        nautilus = { enable = true; singleClickOpen = false; showHiddenFiles = true; };
        gnome-text-editor = { enable = true; indentWithSpaces = true; tabWidth = 4; };
        gnome-console = { enable = true; scrollbackLines = 5000; };
        gnome-calculator = {
          enable = true; mode = "programming"; numberBase = 16; decimalPlaces = 12;
          suggestionTypes = [ ]; favoriteCurrencies = [ "EUR" "PLN" ];
          exchangeRateRefreshSeconds = 0;
        };
        gnome-calendar = { enable = true; view = "week"; weekZoom = 1.5; };
        gnome-clocks = { enable = true; automaticLocation = false; view = "timer"; };
        loupe = { enable = true; showImageProperties = true; };
        papers = { enable = true; twoPages = true; pageSizing = "custom"; zoomFactor = 1.25; };
        git = {
          enable = true; authorName = "Desktop Test"; authorEmail = "desktop@example.test";
          initialBranch = "main"; requireExplicitIdentity = true;
          pullStrategy = "fast-forward-only"; lineEndings = "normalize";
          highlightMovedLines = true; pruneDeletedRemoteBranches = true;
          signCommits = false; ignoredFiles = [ "*.scratch" ];
        };
        ripgrep = {
          enable = true; searchHiddenFiles = true; caseSensitivity = "smart";
          respectIgnoreFiles = false; literalPatterns = true; lineNumbers = true;
          columnNumbers = false; color = "never"; sortFilesByPath = true;
        };
      };
    };
    users.users.alice = { isNormalUser = true; home = "/Users/alice"; };
    users.users.bob = { isNormalUser = true; home = "/Users/bob"; };
    home-manager.users.alice.home.stateVersion = "26.05";
    home-manager.users.bob.home.stateVersion = "26.05";
    system.stateVersion = "26.05";
    virtualisation = {
      memorySize = 4096;
      diskSize = 12288;
      useBootLoader = true;
      useEFIBoot = true;
      mountHostNixStore = true;
    };
  };
  testScript = ''
    import json
    start_all()
    machine.wait_for_unit("multi-user.target")
    machine.succeed("grep -x ID=zenos /etc/os-release")
    machine.succeed("test $(hostname) = desktop-options")
    machine.succeed("test $(readlink -f /etc/localtime) = ${pkgs.tzdata}/share/zoneinfo/Europe/Warsaw")
    policy_results = json.loads(machine.succeed("nix eval --impure --json --expr 'import ${./desktop-options-policies.nix} { nixpkgsPath = ${pkgs.path}; bundlePath = ${policyBundle}/bundle.json; runtimePath = ${../lib/zstr-runtime.nix}; zenfsRuntimePath = ${../lib/zenfs-runtime.nix}; }'"))
    assert all(policy_results.values()), policy_results
    print("Desktop policy checks:", policy_results)
    machine.wait_for_unit("home-manager-alice.service")
    machine.wait_for_unit("home-manager-bob.service")
    machine.succeed("systemctl is-enabled bluetooth.service")
    machine.succeed("grep -q 'AutoEnable=false' /etc/bluetooth/main.conf")
    machine.fail("systemctl is-enabled sshd.service")

    def setting(user, schema, key, expected):
        result = machine.succeed(f"su - {user} -c 'env GSETTINGS_SCHEMA_DIR=${schemas} dbus-run-session gsettings get {schema} {key}'").strip()
        assert result == expected, (user, schema, key, result, expected)

    def greeter(schema, key, expected):
        result = machine.succeed(f"env DCONF_PROFILE=gdm GSETTINGS_SCHEMA_DIR=${schemas} dbus-run-session gsettings get {schema} {key}").strip()
        assert result == expected, (schema, key, result, expected)

    greeter("org.gnome.login-screen", "disable-user-list", "true")
    greeter("org.gnome.login-screen", "disable-restart-buttons", "true")
    greeter("org.gnome.login-screen", "banner-message-enable", "true")
    greeter("org.gnome.login-screen", "banner-message-text", "'Welcome to ZenOS'")
    greeter("org.gnome.login-screen", "banner-message-source", "'settings'")
    greeter("org.gnome.login-screen", "allowed-failures", "5")
    greeter("org.gnome.desktop.interface", "text-scaling-factor", "1.25")
    greeter("org.gnome.desktop.interface", "clock-format", "'12h'")
    greeter("org.gnome.settings-daemon.plugins.power", "sleep-inactive-ac-type", "'nothing'")
    setting("alice", "org.gnome.desktop.interface", "clock-format", "'24h'")
    setting("alice", "org.gnome.desktop.interface", "show-battery-percentage", "false")
    setting("bob", "org.gnome.desktop.peripherals.touchpad", "tap-to-click", "false")
    setting("alice", "org.gnome.desktop.peripherals.keyboard", "delay", "uint32 350")
    setting("alice", "org.gnome.settings-daemon.plugins.color", "night-light-temperature", "uint32 4000")
    setting("alice", "org.gnome.nautilus.preferences", "click-policy", "'double'")
    setting("bob", "org.gnome.nautilus.preferences", "click-policy", "'single'")
    setting("alice", "org.gnome.nautilus.preferences", "show-hidden-files", "true")
    setting("alice", "org.gnome.TextEditor", "indent-style", "'space'")
    setting("alice", "org.gnome.TextEditor", "tab-width", "uint32 4")
    setting("alice", "org.gnome.Console", "scrollback-lines", "int64 5000")
    setting("alice", "org.gnome.desktop.a11y.mouse", "dwell-click-enabled", "true")
    setting("alice", "org.gnome.desktop.a11y.mouse", "dwell-time", "1.5")
    setting("bob", "org.gnome.desktop.a11y.magnifier", "mag-factor", "2.5")
    setting("bob", "org.gnome.desktop.a11y.magnifier", "mouse-tracking", "'centered'")
    setting("bob", "org.gnome.desktop.a11y.magnifier", "cross-hairs-opacity", "0.75")
    setting("alice", "org.gnome.calculator", "button-mode", "'programming'")
    setting("alice", "org.gnome.calculator", "base", "16")
    setting("alice", "org.gnome.calculator", "accuracy", "12")
    setting("alice", "org.gnome.settings-daemon.plugins.media-keys", "calculator", "['<Super>c']")
    setting("alice", "org.gnome.settings-daemon.plugins.media-keys", "screensaver", "@as []")
    setting("alice", "org.gnome.settings-daemon.plugins.media-keys", "screensaver-static", "['XF86ScreenSaver']")
    setting("alice", "org.gnome.calculator", "enabled-completions", "@as []")
    setting("alice", "org.gnome.calculator", "refresh-interval", "0")
    setting("alice", "org.gnome.calendar", "active-view", "'week'")
    setting("alice", "org.gnome.calendar", "week-view-zoom-level", "1.5")
    setting("alice", "org.gnome.clocks", "geolocation", "false")
    setting("alice", "org.gnome.clocks.state.window", "panel-id", "'timer'")
    setting("alice", "org.gnome.Loupe", "show-properties", "true")
    setting("alice", "org.gnome.Papers.Default", "dual-page", "true")
    setting("alice", "org.gnome.Papers.Default", "sizing-mode", "'free'")
    setting("alice", "org.gnome.Papers.Default", "zoom", "1.25")
    assert machine.succeed("su - alice -c 'git config --get user.name'").strip() == "Desktop Test"
    assert machine.succeed("su - alice -c 'git config --get pull.ff'").strip() == "only"
    assert machine.succeed("su - alice -c 'git config --get pull.rebase'").strip() == "false"
    assert machine.succeed("su - alice -c 'git config --get core.autocrlf'").strip() == "input"
    machine.succeed("su - alice -c 'git init -q /tmp/zen-desktop-git'")
    assert machine.succeed("su - alice -c 'git -C /tmp/zen-desktop-git branch --show-current'").strip() == "main"
    machine.succeed("touch /tmp/zen-desktop-git/ignored.scratch")
    machine.succeed("su - alice -c 'git -C /tmp/zen-desktop-git check-ignore ignored.scratch'")
    machine.succeed("install -d -o alice -g users /tmp/zen-desktop-search")
    machine.succeed("printf 'Needle.*\\n' > /tmp/zen-desktop-search/.hidden")
    matches = machine.succeed("su - alice -c 'rg --no-heading needle /tmp/zen-desktop-search'").strip()
    assert matches == "/tmp/zen-desktop-search/.hidden:1:Needle.*", matches

    print(machine.succeed("su - alice -c 'env GSETTINGS_SCHEMA_DIR=${schemas} dbus-run-session ${python}/bin/python3 ${./check-desktop-settings.py} ${./fixtures/desktop-settings.json}'"))
    machine.succeed("su - alice -c 'env GSETTINGS_SCHEMA_DIR=${schemas} dbus-run-session gsettings set org.gnome.desktop.interface show-battery-percentage true'")
    setting("alice", "org.gnome.desktop.interface", "show-battery-percentage", "true")
    setting("bob", "org.gnome.desktop.interface", "show-battery-percentage", "false")
  '';
}
