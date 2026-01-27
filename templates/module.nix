{
  config,
  lib,
  pkgs,
  ...
}:

let
  cfg = config.zenos.template;
in
{
  # Module Metadata
  # This provides info about the module file itself, separate from the options.
  meta = {
    maintainers = with lib.maintainers; [ your-username ];
    doc = ./doc.md; # Optional: Link to a separate doc file if needed
  };

  # 1. Option Declaration
  options.zenos.template = {
    enable = lib.mkOption {
      type = lib.types.bool;
      default = false;
      description = "Whether to enable the template module.";
    };

    package = lib.mkOption {
      type = lib.types.package;
      default = pkgs.hello;
      description = "The package to use for this module.";
      example = "pkgs.gnome.gedit";
    };

    settings = lib.mkOption {
      type = lib.types.attrsOf lib.types.str;
      default = { };
      description = ''
        A set of configuration environment variables.
      '';
    };
  };

  # 2. Configuration Logic
  config = lib.mkIf cfg.enable {
    environment.systemPackages = [ cfg.package ];
    environment.sessionVariables = cfg.settings;
  };
}
