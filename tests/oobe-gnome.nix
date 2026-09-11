# Evaluate the canonical public graph; no boot, activation, or disk operations.
{
  nixpkgs,
  pkgs,
  module,
}:
let
  inherit (pkgs) lib;
  evaluate =
    extra:
    (nixpkgs.lib.nixosSystem {
      system = pkgs.stdenv.hostPlatform.system;
      modules = [
        module
        {
          fileSystems."/" = {
            device = "/dev/disk/by-label/test-root";
            fsType = "ext4";
          };
          fileSystems."/boot" = {
            device = "/dev/disk/by-label/test-esp";
            fsType = "vfat";
          };
          users.users.alice = {
            isNormalUser = true;
            home = "/Users/alice";
            password = "evaluation-only";
            extraGroups = [ "wheel" ];
          };
        }
        extra
      ];
    }).config;
  desktop = evaluate { zenos.desktops.gnome.enable = true; };
  headless = evaluate { };
  temporary = evaluate {
    zenos.desktops.gnome.enable = true;
    zenos.system.oobeMode = true;
  };
  alternate = evaluate {
    zenos.system.oobeMode = true;
    services.displayManager.plasma-login-manager.enable = true;
    services.displayManager.autoLogin = {
      enable = true;
      user = "alice";
    };
  };
  valid =
    c:
    lib.assertMsg (lib.all (a: a.assertion) c.assertions) (
      lib.concatMapStringsSep "\n" (a: a.message) (lib.filter (a: !a.assertion) c.assertions)
    );
in
assert lib.all valid [
  desktop
  headless
  temporary
  alternate
];
assert desktop.services.displayManager.gdm.enable;
assert desktop.services.displayManager.gdm.settings.daemon.GreeterSession == "zenos-greeter";
assert
  !headless.services.desktopManager.gnome.enable && !headless.services.displayManager.gdm.enable;
assert lib.all
  (
    c:
    !c.zenos.system.oobeMode
    && !c.services.greetd.enable
    && !(c.users.users ? zenos)
    && !(c.systemd.user.services ? zenos-oobe)
    && !(c.systemd.user.services ? "org.gnome.Shell@zenos-oobe")
    && c.security.sudo.wheelNeedsPassword
  )
  [
    desktop
    headless
  ];
assert lib.all
  (
    c:
    c.services.greetd.enable
    && c.services.desktopManager.gnome.enable
    && !c.services.displayManager.gdm.enable
    && !c.services.displayManager.sddm.enable
    && !c.services.displayManager.plasma-login-manager.enable
    && !c.services.displayManager.autoLogin.enable
    && c.services.displayManager.autoLogin.user == null
    && c.services.openssh.enable
    && c.services.openssh.openFirewall
    && c.services.openssh.settings.PasswordAuthentication
    && c.services.openssh.settings.PermitEmptyPasswords
    && c.services.openssh.settings.PermitRootLogin == "no"
    && !c.security.sudo.wheelNeedsPassword
    && c.users.users.zenos.home == "/run/zenos-oobe"
    && !(c.systemd.user.services ? zenos-setup)
  )
  [
    temporary
    alternate
  ];
assert temporary.systemd.user.services.zenos-oobe.environment.ZENOS_SETUP_DRY_RUN == "0";
assert temporary.home-manager.users.zenos.dconf.settings == { };
assert lib.elem temporary.systemd.package temporary.environment.systemPackages;
assert lib.elem "/etc/dbus-1" temporary.environment.pathsToLink;
assert lib.any (lib.hasPrefix "D /var/empty ") temporary.systemd.tmpfiles.rules;
assert lib.hasInfix (builtins.unsafeDiscardStringContext (
  toString temporary.services.displayManager.sessionData.wrapper
)) temporary.services.greetd.settings.initial_session.command;
assert
  temporary.services.greetd.settings.default_session.command
  == temporary.services.greetd.settings.initial_session.command;
assert temporary.systemd.user.services.zenos-oobe.environment.ZENOS_OOBE == "1";
assert
  temporary.systemd.user.services.zenos-oobe.environment.PATH
  == "/run/wrappers/bin:/run/current-system/sw/bin";
assert
  temporary.systemd.user.services.zenos-oobe.serviceConfig.ExecStart
  == "${lib.getExe pkgs.zenos.system.zenos-setup} --oobe";
assert
  !(temporary.systemd.user.services."org.gnome.Shell@zenos-oobe".environment ? ZENOS_SETUP_DRY_RUN);
assert
  temporary.systemd.user.services."org.gnome.Shell@zenos-oobe".environment.GNOME_SHELL_SESSION_MODE
  == "zenos-oobe";
pkgs.runCommand "zenpkgs-oobe-gnome-contract" { } ''touch "$out"''
