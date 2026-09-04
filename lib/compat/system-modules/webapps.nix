{
  config,
  lib,
  ...
}:

let
  cfg = config.zenos.system.webApps;
  normalUsers = lib.filterAttrs (_: user: user.isNormalUser) config.users.users;
  webAppModules = [
    ../user-modules/webapps/module.nix
    ../user-modules/webapps/firefox/module.nix
    ../user-modules/webapps/brave/module.nix
    ../user-modules/webapps/chrome/module.nix
  ];
in
{
  options.zenos.system.webApps = {
    enable = lib.mkEnableOption "per-user ZenOS progressive web applications";
    users = lib.mkOption {
      type = lib.types.attrsOf lib.types.attrs;
      default = { };
      description = "Per-user values forwarded to the typed zenos.webApps Home Manager module.";
    };
  };

  config = {
    assertions = lib.optionals cfg.enable (
      lib.mapAttrsToList (name: _userConfig: {
        assertion = builtins.hasAttr name config.users.users;
        message = "zenos.system.webApps.users.${name} must name a declared system user";
      }) cfg.users
    );

    home-manager = {
      backupFileExtension = "zenos-backup";
      useGlobalPkgs = true;
      useUserPackages = false;
      users = lib.mapAttrs (
        name: user:
        {
          home = {
            username = name;
            homeDirectory = user.home;
            stateVersion = config.system.stateVersion;
          };
        }
        // lib.optionalAttrs (cfg.enable && builtins.hasAttr name cfg.users) {
          imports = webAppModules;
          zenos.webApps = cfg.users.${name} // {
            enable = true;
          };
        }
      ) normalUsers;
    };
  };
}
