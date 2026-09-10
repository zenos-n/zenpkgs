{ nixpkgsPath, zenfsModule, zenfsPackage ? null }:
let
  lib = import (nixpkgsPath + "/lib");
  managedUsers = {
    alice = { home = "/Users/alice"; group = "users"; };
    bob = { home = "/Users/bob"; group = "staff"; };
    zenos = { home = "/run/zenos-oobe"; group = "users"; };
  };
  evaluate = extra: (import (nixpkgsPath + "/nixos/lib/eval-config.nix") {
    system = "x86_64-linux";
    modules = [
      zenfsModule
      (import ../lib/zenfs-runtime.nix { inherit managedUsers; package = zenfsPackage; })
      ({ pkgs, ... }: {
        nixpkgs.overlays = [ (final: prev: { zenos = { legacy = prev; system.zenfs = prev.hello; }; }) ];
        system.stateVersion = "26.05";
        users.users = lib.mapAttrs (_: user: user // { isNormalUser = true; }) managedUsers;
        users.groups.staff = {};
        zenos.system.zenfs.enable = true;
        boot.loader.grub.enable = false;
        fileSystems."/" = { device = "/dev/vda"; fsType = "ext4"; };
      })
      extra
    ];
  });
  base = evaluate {};
  cfg = base.config;
  disabled = (evaluate { zenos.system.zenfs.enable = lib.mkForce false; }).config;
  noHierarchy = (evaluate { zenos.system.zenfs.filesystemHierarchy.enable = false; }).config;
  roaming = (evaluate {
    zenos.system.zenfs.roaming = {
      enable = true;
      drives.work = {
        device = "/dev/disk/by-label/work";
        privateMounts.docs = { user = "alice"; source = "alice/docs"; };
      };
    };
  }).config;
  bad = (evaluate {
    zenos.system.zenfs.roaming = {
      enable = true;
      drives.work = { device = "/dev/vdb"; mountPoint = "/Drives/work"; options = ["rw"]; };
    };
  }).config;
  good = value: lib.all (a: a.assertion || !lib.hasPrefix "ZenFS" a.message) value.assertions;
in
{
  typed = !(base.options.zenos.system.zenfs.type.getSubOptions []).strict.type.check "true";
  enabled = cfg.zenos.system.zenfs.enable && cfg.zenos.system.zenfs.strict;
  noOldSchema = !(base.options ? zenfs) && !(base.options.zenos ? appPlatform);
  noUnsafeServices = lib.all (name: !(builtins.hasAttr name cfg.systemd.services))
    [ "zenfs-watcher" "zenfs-indexer" "zenfs-gatekeeper" "zenfs-offload" "zenfs-janitor" ];
  noUnsafeTimers = !(cfg.systemd.timers ? zenfs-offload);
  noDriveOwnership = !(cfg.fileSystems ? "/Drives") && !(cfg.systemd.tmpfiles.settings."10-zenfs" ? "/Drives");
  noProfileOverride = !(cfg.environment.sessionVariables ? NIX_PROFILE) && !(cfg.environment.variables ? NIX_PROFILE);
  oobeManaged = let rule = cfg.systemd.tmpfiles.settings."10-zenfs"."/run/zenos-oobe/.private".d; in
    rule.user == "zenos" && rule.group == "users" && rule.mode == "0700";
  userManaged = lib.all (name: let user = managedUsers.${name}; in
    lib.all (suffix: let rule = cfg.systemd.tmpfiles.settings."10-zenfs"."${user.home}${suffix}".d; in
      rule.user == name && rule.group == user.group && rule.mode == "0700")
      [ "" "/.private" "/.private/Apps" "/.private/Config" "/.private/State" "/.private/State/nix" "/.private/State/nix/profiles" ]
  ) (builtins.attrNames managedUsers);
  systemScope = lib.hasInfix "--scope system" cfg.systemd.services.zenos-app-index.serviceConfig.ExecStart
    && (cfg.systemd.services.zenos-app-index.serviceConfig.User or "root") == "root"
    && cfg.systemd.services.zenos-app-index.serviceConfig.Type == "oneshot";
  userScope = lib.hasSuffix " index" cfg.systemd.user.services.zenos-user-app-index.serviceConfig.ExecStart
    && lib.all (name: let service = cfg.systemd.user.services.${name}.serviceConfig; in
      !(service ? User) && !(service ? Group) && service.Type == "oneshot")
      [ "zenfs-user-init" "zenos-user-app-index" "zenos-flatpak-policy" ];
  appImage = cfg.programs.appimage.enable && cfg.programs.appimage.binfmt
    && cfg.programs.appimage.package == cfg.zenos.system.zenfs.apps.appimage.runPackage;
  flatpak = cfg.services.flatpak.enable && lib.elem "$HOME/.private/Packages/flatpak/exports" cfg.environment.profiles;
  mime = cfg.xdg.mime.defaultApplications."application/x-zenos-app" == "com.negzero.zenos.AppLauncher.desktop";
  activationOrder = lib.elem "zenfs-hierarchy" cfg.system.activationScripts.users.deps
    && lib.hasSuffix "|| exit 1" cfg.system.activationScripts.zenfs-hierarchy.text
    && lib.elem "zenfs-hierarchy" noHierarchy.system.activationScripts.users.deps
    && lib.hasSuffix "|| exit 1" noHierarchy.system.activationScripts.zenfs-hierarchy.text;
  noSourceWriter = !(cfg.environment.etc ? "ZenOS/main.zcfg");
  disabledIsInert = !(disabled.system.activationScripts ? zenfs-hierarchy)
    && !(disabled.systemd.user.services ? zenfs-user-init)
    && !(disabled.systemd.services ? zenos-app-index);
  baselineAssertions = good cfg;
  roamingAssertions = good roaming;
  rejectsUnsafeRoaming = !good bad;
  markerDependency = lib.elem "x-systemd.requires=zenfs-roaming-work-marker.service"
    roaming.fileSystems."/Users/alice/.private/Mount/docs".options;
  privateReadOnly = lib.elem "ro" roaming.fileSystems."/Users/alice/.private/Mount/docs".options;
}
