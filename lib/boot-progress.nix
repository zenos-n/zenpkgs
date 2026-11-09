{ config, lib, pkgs, ... }:
let
  cfg = config.services.bootvine;
  unit = shutdown: {
    description = "ZenOS verbose ${if shutdown then "shutdown" else "boot"} progress";
    wantedBy = [ (if shutdown then "shutdown.target" else "sysinit.target") ];
    after = if shutdown then [ "bootvine.service" "display-manager.service" "plymouth-start.service" ] ++ lib.optionals cfg.plymouth [ "plymouth-poweroff.service" "plymouth-reboot.service" "plymouth-halt.service" "plymouth-kexec.service" ] else [ "plymouth-start.service" ];
    before = if shutdown then [ "systemd-poweroff.service" "systemd-reboot.service" "systemd-halt.service" "systemd-kexec.service" ] else [ "display-manager.service" "shutdown.target" ];
    conflicts = lib.optionals (!shutdown) [ "shutdown.target" ];
    unitConfig = { DefaultDependencies = false; IgnoreOnIsolate = true; };
    environment.BOOTVINE_PLYMOUTH_COMMAND = "${config.boot.plymouth.package}/bin/plymouth";
    preStart = lib.mkIf cfg.plymouth ''
      ${pkgs.coreutils}/bin/cat /sys/class/tty/tty0/active > /run/bootvine/return-vt
      ${pkgs.coreutils}/bin/cat /proc/sys/kernel/printk > /run/bootvine/kernel-printk
    '';
    # A SIGKILL cannot run Rust destructors. Restore the splash only while the
    # dead viewer still owns its VT; never steal a display manager's console.
    postStop = lib.mkIf cfg.plymouth ''
      if [ -S /run/bootvine/plymouth.sock ] && [ "$(${pkgs.coreutils}/bin/cat /sys/class/tty/tty0/active)" = tty12 ]; then
        if ${config.boot.plymouth.package}/bin/plymouth reactivate; then
          return_vt=$(${pkgs.coreutils}/bin/cat /run/bootvine/return-vt)
          case "$return_vt" in
            tty[0-9]|tty[0-9][0-9]) ${pkgs.kbd}/bin/chvt "''${return_vt#tty}" || true ;;
          esac
        fi
        ${pkgs.coreutils}/bin/cat /run/bootvine/kernel-printk > /proc/sys/kernel/printk
      fi
      ${pkgs.coreutils}/bin/rm -f /run/bootvine/plymouth.sock
    '';
    serviceConfig = {
      Type = "simple";
      # A live system switch must not take the user's current console.
      ExecCondition = lib.optional cfg.plymouth "${config.boot.plymouth.package}/bin/plymouth --ping";
      ExecStart = "@${cfg.package}/bin/bootvine @bootvine${lib.optionalString shutdown " --shutdown"}${lib.optionalString cfg.plymouth " --plymouth"}";
      StandardInput = "tty";
      StandardOutput = "tty";
      StandardError = "journal";
      TTYPath = "/dev/tty12";
      TTYReset = true;
      TTYVTDisallocate = false;
      RuntimeDirectory = "bootvine";
      RuntimeDirectoryMode = "0700";
      RuntimeDirectoryPreserve = true;
    };
  };
in {
  options.services.bootvine = {
    enable = lib.mkEnableOption "Bootvine verbose boot progress";
    package = lib.mkOption { type = lib.types.package; default = pkgs.zenos.byCategories.system.bootvine; };
    plymouth = lib.mkOption { type = lib.types.bool; default = config.boot.plymouth.enable; description = "Keep Plymouth until Escape requests verbose progress."; };
  };
  config = lib.mkIf cfg.enable {
    environment.systemPackages = [ cfg.package ];
    assertions = [{ assertion = config.boot.initrd.systemd.enable; message = "ZenOS Bootvine requires the systemd initrd for complete verbose boot progress."; }];
    boot.plymouth.package = lib.mkIf cfg.plymouth (lib.mkDefault (pkgs.plymouth.overrideAttrs (old: {
      patches = (old.patches or []) ++ [ "${cfg.package}/share/bootvine/plymouth-bootvine.patch" ];
    })));
    systemd.services.bootvine = (unit false) // { restartIfChanged = false; };
    systemd.services.bootvine-shutdown = (unit true) // { restartIfChanged = false; };
    boot.initrd.kernelModules = lib.optional cfg.plymouth "evdev";
    boot.initrd.systemd = {
      # Plymouth's evdev keyboard needs the XKB data, not just libxkbcommon.
      storePaths = [ cfg.package config.boot.plymouth.package ] ++ lib.optional cfg.plymouth pkgs.xkeyboard-config;
      services.bootvine = unit false;
    };
  };
}
