{ pkgs, zenosModule, zenDsl, homeManagerPath }:
let
  inherit (pkgs) lib;
  catalog = builtins.fromJSON (builtins.readFile ./fixtures/user-options.json);
  gnomePaths = map (o: lib.splitString "." o.name) catalog."theming/gnome";
  policyBundle = pkgs.runCommand "zenos-user-policy-bundle" {} ''
    mkdir -p "$out/modules"
    cp ${../modules/users.zmdl} "$out/modules/users.zmdl"
    cp ${../modules/userModules.zmdl} "$out/modules/userModules.zmdl"
    cp -r ${../modules/userModules} "$out/modules/userModules"
    cat > "$out/structure.zstr" <<'ZSTR'
    users = {
      _meta.type = (zmdl users);
      (freeform user) = { _meta.type = (zmdl userModules); };
    };
    ZSTR
    ${zenDsl}/bin/zen-dsl compile-tree --root "$out" --output "$out/bundle.json" --mode interface
  '';
  python = pkgs.python3.withPackages (p: [ p.pygobject3 ]);
  schemas = pkgs.runCommand "zenos-user-test-schemas" { nativeBuildInputs = [ pkgs.glib ]; } ''
    mkdir -p "$out"
    for package in ${pkgs.gsettings-desktop-schemas} ${pkgs.gnome-settings-daemon} ${pkgs.mutter} ${pkgs.gnome-shell}; do
      find "$package/share/gsettings-schemas" -name '*.xml' -exec cp {} "$out/" \;
    done
    glib-compile-schemas --strict "$out"
  '';
  settings = pkgs.writeText "user-gnome-settings.json" (builtins.toJSON (map (o:
    let m = builtins.match ''dconf.settings."([^"]+)"."([^"]+)"'' o.target;
    in [ (builtins.replaceStrings [ "/" ] [ "." ] (builtins.elemAt m 0)) (builtins.elemAt m 1) ]
  ) catalog."theming/gnome"));
in pkgs.testers.runNixOSTest {
  name = "zenos-user-options";
  node.pkgsReadOnly = false;
  nodes.machine = { config, lib, ... }: {
    imports = [ zenosModule ];
    boot.consoleLogLevel = lib.mkForce 7;
    boot.initrd.verbose = lib.mkForce true;
    environment.systemPackages = [ pkgs.dconf pkgs.glib python pkgs.git ];
    environment.variables.GI_TYPELIB_PATH = "${pkgs.glib.out}/lib/girepository-1.0";
    programs.dconf = {
      enable = true;
      profiles.user.databases = [ { settings."org/gnome/desktop/interface" = {
        show-battery-percentage = false;
        clock-format = "24h";
      }; } ];
    };
    users.groups.research = {};
    zenos.users = {
      alice = {
        profile = {
          normalUser = true; displayName = "Alice User Options";
          homeDirectory = "/Users/alice"; uid = 1100;
          groups = [ "research" ]; linger = true; loginShell = pkgs.bashInteractive;
          sshKeys = [ "ssh-ed25519 AAAAC3NzaC1lZDI1NTE5AAAAIAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAA user-options-test" ];
        };
        shell.aliases.ll = "ls -l";
        environment = {
          variables.USER_OPTIONS_OWNER = "alice";
          searchPath = [ "$HOME/bin" ]; editor = "vi"; pager = "less";
        };
        locale = { language = "en_US.UTF-8"; numberFormat = "en_US.UTF-8"; timeZone = "Europe/Warsaw"; };
        userDirs = { enable = true; createDirectories = true; documents = "/Users/alice/Docs"; downloads = "/Users/alice/Incoming"; };
        defaultApps = { enable = true; browser = "firefox.desktop"; textEditor = "org.gnome.TextEditor.desktop"; pdfViewer = "org.gnome.Papers.desktop"; };
        fonts = { enable = true; sansSerifFamilies = [ "DejaVu Sans" ]; smoothEdges = false; pixelAlignmentStrength = "slight"; };
        programs.git = { enable = true; authorName = "Alice"; authorEmail = "alice@example.test"; };
        theming.gnome = lib.recursiveUpdate (lib.foldl' lib.recursiveUpdate {} (map (path:
          lib.setAttrByPath path (lib.getAttrFromPath path config.zenos.desktops.gnome)
        ) gnomePaths)) {
          showBatteryPercentage = true;
          clock.format = "12h";
          touchpad.tapToClick = false;
          keyboard.repeatDelayMilliseconds = 321;
          shortcuts.openCalculator = [];
          wallpaper.lightImage = "file:///Users/alice/wallpaper.png";
          wallpaper.darkImage = "file:///Users/alice/wallpaper-dark.png";
        };
        legacy.homeManager.programs.bash.enable = true;
      };
      bob = {
        profile = { normalUser = true; homeDirectory = "/Users/bob"; displayName = "Bob User Options"; uid = 1101; linger = false; };
        environment.variables.USER_OPTIONS_OWNER = "bob";
        theming.gnome = { clock.format = "24h"; touchpad.tapToClick = true; };
      };
      charlie = {};
    };
    users.users.charlie = { isNormalUser = true; home = "/Users/charlie"; };
    home-manager.users = lib.genAttrs [ "alice" "bob" "charlie" ] (_: { home.stateVersion = "26.05"; });
    system.stateVersion = "26.05";
    virtualisation = { memorySize = 3072; diskSize = 8192; useBootLoader = false; mountHostNixStore = true; };
  };
  testScript = ''
    import json
    start_all()
    machine.wait_for_unit("multi-user.target")
    machine.succeed("grep -x ID=zenos /etc/os-release")
    report = json.loads(machine.succeed("nix eval --impure --json --expr 'import ${./user-options-policies.nix} { nixpkgsPath = ${pkgs.path}; homeManagerPath = ${homeManagerPath}; bundlePath = ${policyBundle}/bundle.json; runtimePath = ${../lib/zstr-runtime.nix}; searchPath = ${../lib/search-index.nix}; catalogPath = ${./fixtures/user-options.json}; }'"))
    assert report["optionCount"] == 241, report
    assert all(report["checks"].values()), report
    print("User option schema, policy, and export checks:", report)
    for user in ["alice", "bob", "charlie"]:
        machine.wait_for_unit(f"home-manager-{user}.service")
    machine.succeed("test $(id -u alice) = 1100; test $(id -u bob) = 1101")
    machine.succeed("getent passwd alice | grep 'Alice User Options:/Users/alice:'")
    machine.succeed("id -nG alice | grep -w research")
    machine.fail("id -nG bob | grep -w research")
    machine.succeed("grep user-options-test /etc/ssh/authorized_keys.d/alice")
    machine.succeed("test -f /var/lib/systemd/linger/alice")
    machine.fail("test -f /var/lib/systemd/linger/bob")
    machine.succeed("test -d /Users/alice/Docs; test -d /Users/alice/Incoming")
    machine.fail("test -d /Users/bob/Docs")
    machine.succeed("grep 'XDG_DOCUMENTS_DIR=\"/Users/alice/Docs\"' /Users/alice/.config/user-dirs.dirs")
    machine.succeed("grep 'x-scheme-handler/https=firefox.desktop' /Users/alice/.config/mimeapps.list")
    machine.fail("test -e /Users/bob/.config/mimeapps.list")
    machine.succeed("grep -R 'DejaVu Sans' /Users/alice/.config/fontconfig")
    machine.succeed("su - alice -c 'test \"$USER_OPTIONS_OWNER\" = alice; test \"$EDITOR\" = vi; test \"$TZ\" = Europe/Warsaw'")
    machine.succeed("su - alice -c 'git config user.email' | grep -x alice@example.test")
    machine.fail("su - bob -c 'git config user.email'")

    def setting(user, schema, key, expected):
        actual = machine.succeed(f"su - {user} -c 'env GSETTINGS_SCHEMA_DIR=${schemas} dbus-run-session gsettings get {schema} {key}'").strip()
        assert actual == expected, (user, schema, key, actual, expected)

    setting("alice", "org.gnome.desktop.interface", "show-battery-percentage", "true")
    setting("bob", "org.gnome.desktop.interface", "show-battery-percentage", "false")
    setting("charlie", "org.gnome.desktop.interface", "show-battery-percentage", "false")
    setting("alice", "org.gnome.desktop.interface", "clock-format", "'12h'")
    setting("bob", "org.gnome.desktop.interface", "clock-format", "'24h'")
    setting("alice", "org.gnome.desktop.peripherals.touchpad", "tap-to-click", "false")
    setting("bob", "org.gnome.desktop.peripherals.touchpad", "tap-to-click", "true")
    setting("alice", "org.gnome.desktop.peripherals.keyboard", "delay", "uint32 321")
    setting("alice", "org.gnome.settings-daemon.plugins.media-keys", "calculator", "@as []")
    machine.succeed("su - alice -c 'env GSETTINGS_SCHEMA_DIR=${schemas} dbus-run-session python3 ${./check-desktop-settings.py} ${settings}'")
    machine.succeed("su - alice -c 'dbus-run-session dconf write /org/gnome/desktop/interface/show-battery-percentage false'")
    setting("alice", "org.gnome.desktop.interface", "show-battery-percentage", "false")
    machine.succeed("systemctl restart home-manager-alice.service")
    setting("alice", "org.gnome.desktop.interface", "show-battery-percentage", "true")
  '';
}
