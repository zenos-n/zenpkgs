{
  config,
  lib,
  ...
}:

let
  cfg = config.zenos.system.webApps;
  webAppModules = [
    ../hm-modules/webapps/module.nix
    ../hm-modules/webapps/firefox/module.nix
    ../hm-modules/webapps/brave/module.nix
    ../hm-modules/webapps/chrome/module.nix
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

  config = lib.mkIf cfg.enable {
    assertions = lib.mapAttrsToList (name: _userConfig: {
      assertion = builtins.hasAttr name config.users.users;
      message = "zenos.system.webApps.users.${name} must name a declared system user";
    }) cfg.users;

    home-manager = {
      useGlobalPkgs = true;
      useUserPackages = true;
      users = lib.mapAttrs (name: webAppConfig: {
        imports = webAppModules;
        home = {
          username = name;
          homeDirectory = config.users.users.${name}.home;
          stateVersion = config.system.stateVersion;
        };
        zenos.webApps = webAppConfig // {
          enable = true;
        };
      }) cfg.users;
    };
  };
}
