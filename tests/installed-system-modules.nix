{
  interfaceModule,
  installedBaseModule,
  nixpkgs,
  oobeModule,
  pkgs,
  system,
}:

let
  lib = nixpkgs.lib;
  mkSystem =
    modules:
    nixpkgs.lib.nixosSystem {
      inherit system;
      modules = [ { nixpkgs.pkgs = pkgs; } ] ++ modules;
    };

  finalSystem = mkSystem [
    interfaceModule
    installedBaseModule
    {
      zenos.desktops.gnome.enable = true;
    }
  ];
  final = finalSystem.config;

  disabledSystem = mkSystem [
    interfaceModule
    installedBaseModule
    oobeModule
    {
      zenos.desktops.gnome.enable = true;
      zenos.oobe.enable = false;
    }
  ];
  disabled = disabledSystem.config;

  setupPackage =
    pkgs.runCommand "dummy-zenos-setup"
      {
        meta.mainProgram = "zenos-setup";
      }
      ''
        mkdir -p "$out/bin"
        touch "$out/bin/zenos-setup"
        chmod +x "$out/bin/zenos-setup"
      '';
  compilerPackage = pkgs.runCommand "dummy-zen-dsl" { } ''
    mkdir -p "$out/bin"
    touch "$out/bin/zcfg"
    chmod +x "$out/bin/zcfg"
  '';
  extensionPackage = pkgs.runCommand "dummy-zenos-oobe-extension" { } ''
    extension="$out/share/gnome-shell/extensions/zenos-oobe-mode@neg-zero.com"
    mode="$out/share/gnome-shell/modes/zenos-oobe.json"
    mkdir -p "$extension" "$(dirname "$mode")"
    touch "$extension/extension.js"
    cat > "$extension/metadata.json" <<'EOF'
    {
      "uuid": "zenos-oobe-mode@neg-zero.com",
      "shell-version": ["49", "50"],
      "session-modes": ["user", "zenos-oobe"]
    }
    EOF
    cat > "$mode" <<'EOF'
    {
      "parentMode": "user",
      "hasOverview": true,
      "showWelcomeDialog": false
    }
    EOF
  '';

  temporarySystem = mkSystem [
    interfaceModule
    installedBaseModule
    oobeModule
    {
      zenos.oobe = {
        enable = true;
        inherit extensionPackage setupPackage;
      };
      # The installed template injects zcfg this way. The service PATH below
      # deliberately resolves it through /run/current-system/sw/bin.
      environment.systemPackages = [ compilerPackage ];
    }
  ];
  temporary = temporarySystem.config;
  initialSession = temporary.services.greetd.settings.initial_session;
  defaultSession = temporary.services.greetd.settings.default_session;
  setupService = temporary.systemd.user.services.zenos-oobe;
  shellService = temporary.systemd.user.services."org.gnome.Shell@zenos-oobe";
  oobeTarget = temporary.systemd.user.targets."gnome-session@zenos-oobe";
  dconfDatabase = builtins.head temporary.programs.dconf.profiles.user.databases;

  setupWithoutMainProgram = pkgs.runCommand "dummy-setup-without-main-program" { } ''
    mkdir -p "$out/bin"
    touch "$out/bin/zenos-setup"
    chmod +x "$out/bin/zenos-setup"
  '';
  invalidSetupSystem = mkSystem [
    interfaceModule
    installedBaseModule
    oobeModule
    {
      zenos.oobe = {
        enable = true;
        extensionPackage = extensionPackage;
        setupPackage = setupWithoutMainProgram;
      };
    }
  ];
  invalidSetupAssertions = invalidSetupSystem.config.assertions;
in
{
  installed-base =
    assert final.system.stateVersion == "26.05";
    assert final.zenos.system.installedBase._meta.license.shortName == "napalm";
    assert final.system.nixos.distroId == "zenos";
    assert final.system.nixos.distroName == "ZenOS";
    assert final.nixpkgs.config.allowUnfree;
    assert final.networking.networkmanager.enable;
    assert final.services.pipewire.enable;
    assert final.services.pipewire.alsa.enable;
    assert final.services.pipewire.pulse.enable;
    assert final.programs.dconf.enable;
    assert final.hardware.enableRedistributableFirmware;
    assert final.boot.loader.efi.canTouchEfiVariables;
    assert final.services.displayManager.gdm.enable;
    assert !final.services.displayManager.autoLogin.enable;
    assert final.services.displayManager.autoLogin.user == null;
    assert final.services.displayManager.defaultSession == null;
    assert !final.services.displayManager.gdm.settings.daemon.AutomaticLoginEnable;
    assert !final.services.displayManager.gdm.settings.daemon.TimedLoginEnable;
    assert !final.users.mutableUsers;
    assert !final.services.greetd.enable;
    assert !(final.users.users ? zenos);
    assert !(final.systemd.user.services ? zenos-oobe);
    assert !(final.environment.sessionVariables ? ZENOS_OOBE);
    assert lib.any (lib.hasPrefix "f+ /var/lib/AccountsService/users/gdm-greeter ")
      final.systemd.tmpfiles.rules;
    assert !disabled.zenos.oobe.enable;
    assert disabled.services.displayManager.gdm.enable;
    assert !disabled.services.greetd.enable;
    assert !(disabled.users.users ? zenos);
    assert !(disabled.systemd.user.services ? zenos-oobe);
    assert !(disabled.environment.sessionVariables ? ZENOS_OOBE);
    assert !(lib.any (lib.hasInfix "/Config/ZenOS/Flake") disabled.systemd.tmpfiles.rules);
    pkgs.runCommand "zenpkgs-installed-base-check" { } "touch $out";

  oobe =
    assert temporary.zenos.oobe.userName == "zenos";
    assert temporary.zenos.oobe._meta.license.shortName == "napalm";
    assert temporary.services.desktopManager.gnome.enable;
    assert !temporary.services.displayManager.gdm.enable;
    assert temporary.services.greetd.enable;
    assert initialSession.user == "zenos";
    assert defaultSession.user == "zenos";
    assert initialSession.command == defaultSession.command;
    assert lib.hasInfix "ZENOS_OOBE=1" initialSession.command;
    assert lib.hasInfix "--session=zenos-oobe" initialSession.command;
    assert !temporary.users.mutableUsers;
    assert temporary.users.users.zenos.isNormalUser;
    assert temporary.users.users.zenos.home == "/run/zenos-oobe";
    assert temporary.users.users.zenos.initialHashedPassword == "";
    assert temporary.services.openssh.enable;
    assert temporary.services.openssh.settings.PermitEmptyPasswords;
    assert lib.elem "wheel" temporary.users.users.zenos.extraGroups;
    assert lib.elem setupPackage temporary.environment.systemPackages;
    assert lib.elem extensionPackage temporary.environment.systemPackages;
    assert lib.elem compilerPackage temporary.environment.systemPackages;
    assert !(temporary.environment.sessionVariables ? ZENOS_OOBE);
    assert !(builtins.hasAttr "org.gnome.Shell@" temporary.systemd.user.services);
    assert shellService.environment.PATH == "/run/wrappers/bin:/run/current-system/sw/bin";
    assert shellService.environment.ZENOS_OOBE == "1";
    assert lib.elem "org.gnome.Shell@zenos-oobe.service" oobeTarget.unitConfig.Requires;
    assert setupService.environment.PATH == "/run/wrappers/bin:/run/current-system/sw/bin";
    assert setupService.environment.ZENOS_OOBE == "1";
    assert setupService.unitConfig.ConditionUser == "zenos";
    assert setupService.serviceConfig.ExecStart == "${lib.getExe setupPackage} --oobe";
    assert setupPackage.meta.mainProgram == "zenos-setup";
    assert lib.any (
      item: !item.assertion && lib.hasInfix "meta.mainProgram" item.message
    ) invalidSetupAssertions;
    assert dconfDatabase.settings."org/gnome/desktop/lockdown".disable-log-out;
    assert lib.elem "/org/gnome/shell/enabled-extensions" dconfDatabase.locks;
    assert lib.elem "z /Config/ZenOS/Flake 0775 zenos users -" temporary.systemd.tmpfiles.rules;
    assert lib.elem "Z /Config/ZenOS/Flake - zenos users -" temporary.systemd.tmpfiles.rules;
    assert lib.elem "f /run/zenos-oobe/.local/share/gnome-shell/lock-warning-shown 0600 zenos users -"
      temporary.systemd.tmpfiles.rules;
    assert !(lib.elem "d /Config/ZenOS/Flake 0775 zenos users -" temporary.systemd.tmpfiles.rules);
    pkgs.runCommand "zenpkgs-oobe-check" { } ''
      extension=${extensionPackage}/share/gnome-shell/extensions/zenos-oobe-mode@neg-zero.com
      mode=${extensionPackage}/share/gnome-shell/modes/zenos-oobe.json

      test -x ${lib.getExe setupPackage}
      test -x ${compilerPackage}/bin/zcfg
      test -f "$extension/extension.js"
      test -f "$extension/metadata.json"
      test -f "$mode"
      ${lib.getExe pkgs.jq} -e '
        .uuid == "zenos-oobe-mode@neg-zero.com"
        and (."session-modes" | index("zenos-oobe") != null)
      ' "$extension/metadata.json" > /dev/null
      ${lib.getExe pkgs.jq} -e '
        .parentMode == "user"
        and .hasOverview
        and (.showWelcomeDialog == false)
      ' "$mode" > /dev/null
      touch $out
    '';
}
