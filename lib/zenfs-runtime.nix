# Internal lowering only. Public policy is declared by modules/system/zenfs.zmdl.
{ managedUsers, package ? null, includeBootAlias ? true }:
{ config, lib, pkgs, ... }:
let
  cfg = config.zenos.system.zenfs;
  zenfs = if package == null then pkgs.zenos.system.zenfs else package;
  users = lib.mapAttrs (_: user: { inherit (user) home; group = user.group or "users"; }) managedUsers;
  aliases = lib.optionalAttrs includeBootAlias { "/Boot" = "/boot"; } // {
    "/Config" = "/etc";
    "/home" = "/Users";
    "/Packages" = "/nix";
    "/System/Config" = "/etc";
    "/System/Current" = "/run/current-system";
    "/System/Index" = "/run/current-system/sw";
    "/Live/Devices" = "/dev";
    "/Live/Processes" = "/proc";
    "/Live/Runtime" = "/run";
    "/Live/System" = "/sys";
    "/Live/Temporary" = "/tmp";
    "/Live/Variable" = "/var";
    "/Mount" = "/mnt";
  };
  directories = [ "/Apps" "/Live" "/System" "/Users" "/mnt" ];
  hiddenRootEntries = [
    "bin" "boot" "dev" "etc" "home" "lib" "lib32" "lib64" "media" "mnt"
    "nix" "opt" "proc" "root" "run" "sbin" "srv" "sys" "tmp" "usr" "var"
  ];
  absolute = path: lib.hasPrefix "/" path && path != "/"
    && builtins.all (part: part != "" && part != "." && part != "..") (lib.tail (lib.splitString "/" path));
  relative = path: path != "" && !lib.hasPrefix "/" path
    && builtins.all (part: part != "" && part != "." && part != "..") (lib.splitString "/" path);
  unitSafe = name: builtins.match "[A-Za-z0-9_][A-Za-z0-9_.-]*" name != null;
  drives = lib.filterAttrs (_: drive: cfg.roaming.enable && drive.enable) cfg.roaming.drives;
  mounts = lib.concatLists (lib.mapAttrsToList (name: drive:
    lib.mapAttrsToList (mountName: mount:
      let
        user = users.${mount.user} or { home = "/var/empty"; group = "users"; };
        target = if mount.target == null then ".private/Mount/${mountName}" else mount.target;
      in mount // {
        inherit name drive mountName target;
        inherit (user) group;
        sourcePath = "${drive.mountPoint}/${mount.source}";
        targetPath = "${user.home}/${target}";
      }
    ) drive.privateMounts
  ) drives);
  mountTargets = map (drive: drive.mountPoint) (builtins.attrValues drives) ++ map (mount: mount.targetPath) mounts;
  remote = cfg.apps.flatpak.remote;
  descriptor = if remote.descriptor != null then remote.descriptor else pkgs.fetchurl {
    url = "https://dl.flathub.org/repo/flathub.flatpakrepo";
    hash = "sha256-M3HdJQ5h2eFjNjAHP+/aFTzUQm9y9K+gwzc64uj+oDo=";
  };
  manifest = pkgs.writeText "zenfs-manifest.json" (builtins.toJSON {
    schema = "zenfs-v1";
    inherit hiddenRootEntries users;
    aliases = lib.optionalAttrs cfg.filesystemHierarchy.enable aliases;
    directories = lib.optionals cfg.filesystemHierarchy.enable directories;
    inherit (cfg) strict;
    roaming = lib.mapAttrs (name: drive: {
      inherit (drive) enable markerId markerFile mountPoint;
      privateMounts = map (mount: { inherit (mount) sourcePath targetPath; })
        (lib.filter (mount: mount.name == name) mounts);
    }) drives;
    flatpak = {
      enable = cfg.apps.enable && cfg.apps.flatpak.enable;
      inherit (remote) name;
      descriptor = if cfg.apps.enable && cfg.apps.flatpak.enable then toString descriptor else null;
    };
  });
  session = "${zenfs}/bin/zenfs-session --manifest ${manifest}";
  userService = action: {
    wantedBy = [ "graphical-session-pre.target" ];
    before = [ "graphical-session.target" ];
    serviceConfig = {
      Type = "oneshot";
      ExecStart = "${session} ${action}";
      RemainAfterExit = true;
    };
  };
  directoryRule = path: user: group: mode: {
    name = path;
    value.d = { inherit user group mode; };
  };
  privateDirectories = [
    ".private" ".private/Apps" ".private/Config" ".private/Config/gnupg" ".private/Config/ssh"
    ".private/Legacy" ".private/Live" ".private/Local" ".private/Mount" ".private/Packages"
    ".private/Packages/lib" ".private/State" ".private/State/nix" ".private/State/nix/profiles" ".private/State/shell"
  ];
in
{
  config = lib.mkIf cfg.enable (lib.mkMerge [
    {
      assertions = [
        {
          assertion = lib.all (name: unitSafe name && absolute users.${name}.home
            && (lib.hasPrefix "/Users/" users.${name}.home || users.${name}.home == "/run/zenos-oobe")
            && builtins.hasAttr name config.users.users
            && config.users.users.${name}.home == users.${name}.home
            && config.users.users.${name}.group == users.${name}.group) (builtins.attrNames users);
          message = "ZenFS managed users must match declared account homes/groups under /Users or /run/zenos-oobe.";
        }
        {
          assertion = let homes = map (user: user.home) (builtins.attrValues users); in
            builtins.length homes == builtins.length (lib.unique homes)
            && lib.all (a: lib.all (b: a == b || !lib.hasPrefix "${a}/" b) homes) homes;
          message = "ZenFS managed homes must be unique and cannot overlap.";
        }
        {
          assertion = lib.all (name: let drive = drives.${name}; in unitSafe name
            && absolute drive.mountPoint && lib.hasPrefix "/Mount/" drive.mountPoint
            && relative drive.markerFile && drive.markerId != ""
            && lib.all (option: lib.elem option drive.options) [ "nodev" "nosuid" "noexec" ]
            && !lib.any (option: lib.elem option drive.options) [ "dev" "suid" "exec" "bind" "rbind" ]) (builtins.attrNames drives);
          message = "ZenFS roaming drives need unit-safe names, /Mount mountpoints, safe markers, and nodev/nosuid/noexec.";
        }
        {
          assertion = lib.all (mount: builtins.hasAttr mount.user users && relative mount.mountName
            && relative mount.source && relative mount.target && lib.hasPrefix ".private/Mount/" mount.target) mounts;
          message = "ZenFS private mounts require managed users, safe relative sources and targets beneath .private/Mount.";
        }
        {
          assertion = builtins.length mountTargets == builtins.length (lib.unique mountTargets)
            && lib.all (a: lib.all (b: a == b || !lib.hasPrefix "${a}/" b) mountTargets) mountTargets;
          message = "ZenFS mount targets must be unique and cannot overlap.";
        }
        {
          assertion = !cfg.filesystemHierarchy.enable || lib.all (path: !builtins.hasAttr path config.fileSystems) (builtins.attrNames aliases);
          message = "ZenFS hierarchy aliases cannot replace filesystem mountpoints.";
        }
        {
          assertion = unitSafe remote.name;
          message = "ZenFS Flatpak remote names must be nonempty, option-safe identifiers.";
        }
      ];
      environment.systemPackages = [ zenfs ];
      environment.etc."zenfs/manifest.json".source = manifest;
      environment.etc."systemd/user-environment-generators/20-zenfs".source =
        pkgs.writeShellScript "zenfs-user-environment" ''exec ${session} environment'';
      environment.extraInit = ''
        eval "$(${session} environment --shell)"
      '';
      programs.ssh.extraConfig = lib.mkIf (users != { } && cfg.strict) ''
        Match localuser ${lib.concatStringsSep "," (builtins.attrNames users)}
          Include %d/.private/Config/ssh/config
          UserKnownHostsFile %d/.private/Config/ssh/known_hosts
          IdentityFile %d/.private/Config/ssh/id_ed25519
          IdentityFile %d/.private/Config/ssh/id_ecdsa
          IdentityFile %d/.private/Config/ssh/id_rsa
        Match all
      '';
      systemd.tmpfiles.settings."10-zenfs" = builtins.listToAttrs (
        lib.concatLists (lib.mapAttrsToList (name: user:
          [ (directoryRule user.home name user.group "0700") ]
          ++ map (path: directoryRule "${user.home}/${path}" name user.group "0700") privateDirectories
        ) users)
        ++ lib.mapAttrsToList (_: drive: directoryRule drive.mountPoint "root" "root" "0755") drives
        ++ map (mount: directoryRule mount.targetPath mount.user mount.group "0700") mounts
      );
      systemd.user.services.zenfs-user-init = userService "init";
      fileSystems = lib.mapAttrs' (_: drive: lib.nameValuePair drive.mountPoint {
        inherit (drive) device fsType options;
      }) drives // builtins.listToAttrs (map (mount: lib.nameValuePair mount.targetPath {
        device = mount.sourcePath;
        fsType = "none";
        options = [ "bind" "nofail" "nodev" "nosuid" "noexec"
          "x-systemd.requires-mounts-for=${mount.drive.mountPoint}"
          "x-systemd.requires=zenfs-roaming-${mount.name}-marker.service"
          "x-systemd.after=zenfs-roaming-${mount.name}-marker.service"
        ] ++ lib.optional mount.readOnly "ro";
      }) mounts);
      systemd.services = lib.mapAttrs' (name: drive: lib.nameValuePair "zenfs-roaming-${name}-marker" {
        description = "Verify ZenFS roaming drive ${name}";
        unitConfig.RequiresMountsFor = [ drive.mountPoint ];
        serviceConfig = {
          Type = "oneshot";
          ExecStart = lib.escapeShellArgs [ "${zenfs}/bin/zenfs-session" "--manifest" manifest "verify-drive" "--drive" name ];
        };
      }) drives;
    }
    {
      system.activationScripts.zenfs-hierarchy = {
        deps = [ "etc" ];
        text = "${zenfs}/bin/zenfs-layout --manifest ${manifest} || exit 1";
      };
      system.activationScripts.users.deps = [ "zenfs-hierarchy" ];
    }
    (lib.mkIf cfg.apps.enable {
      environment.systemPackages = [ pkgs.nautilus-python ];
      environment.pathsToLink = [ "/share/nautilus-python/extensions" ];
      xdg.mime.enable = true;
      xdg.mime.defaultApplications = {
        "application/x-desktop" = [ "com.negzero.zenos.AppLauncher.desktop" ];
        "application/x-zenos-app" = [ "com.negzero.zenos.AppLauncher.desktop" ];
      };
      systemd.tmpfiles.settings."10-zenfs"."/Apps".d = { mode = "0755"; user = "root"; group = "root"; };
      systemd.services.zenos-app-index = {
        description = "Build the system-only ZenOS application views";
        wantedBy = [ "multi-user.target" ];
        wants = [ "systemd-tmpfiles-setup.service" ];
        after = [ "systemd-tmpfiles-setup.service" ];
        before = [ "display-manager.service" ];
        path = [ config.system.path ];
        restartTriggers = [ config.system.path manifest ];
        serviceConfig = {
          Type = "oneshot";
          ExecStart = "${zenfs}/bin/zen-app-index --home /var/empty --target /Apps --scope system";
        };
      };
      systemd.user.services.zenos-user-app-index = (userService "index") // {
        requires = [ "zenfs-user-init.service" ];
        after = [ "zenfs-user-init.service" ] ++ lib.optional cfg.apps.flatpak.enable "zenos-flatpak-policy.service";
      };
    })
    (lib.mkIf (cfg.apps.enable && cfg.apps.appimage.enable) {
      programs.appimage = { enable = true; binfmt = true; package = cfg.apps.appimage.runPackage; };
    })
    (lib.mkIf (cfg.apps.enable && cfg.apps.flatpak.enable) {
      services.flatpak.enable = true;
      xdg.portal.enable = true;
      environment.profiles = [ "$HOME/.private/Packages/flatpak/exports" ];
      environment.sessionVariables.ZENOS_FLATPAK_REMOTE = remote.name;
      systemd.services.zenos-flatpak-policy = {
        description = "Reconcile the owned system Flatpak remote";
        wantedBy = [ "multi-user.target" ];
        wants = [ "network-online.target" ];
        after = [ "network-online.target" ];
        restartTriggers = [ manifest ];
        serviceConfig = {
          Type = "oneshot";
          ExecStart = "${session} flatpak-system";
          RemainAfterExit = true;
          Restart = "on-failure";
          RestartSec = "30s";
          TimeoutStartSec = "60s";
        };
        unitConfig.StartLimitIntervalSec = 0;
      };
      systemd.user.services.zenos-flatpak-policy = lib.recursiveUpdate (userService "flatpak-user") {
        requires = [ "zenfs-user-init.service" ];
        after = [ "zenfs-user-init.service" ];
        before = [ "zenos-user-app-index.service" ];
        serviceConfig = { Restart = "on-failure"; RestartSec = "30s"; TimeoutStartSec = "60s"; };
        unitConfig.StartLimitIntervalSec = 0;
      };
    })
  ]);
}
