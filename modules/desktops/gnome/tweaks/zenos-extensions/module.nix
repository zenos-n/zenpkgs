{ lib, pkgs, ... }:
{
  options.zenos.desktops.gnome.tweaks.zenosExtensions = lib.mkOption {
    type = lib.types.submodule {
      options = {
        enable = lib.mkOption {
          type = lib.types.bool;
          default = true;
          description = "Enable installation of curated ZenOS GNOME extensions.";
        };
        excludedExtensions = lib.mkOption {
          type = lib.types.listOf lib.types.str;
          default = [ ];
          description = "List of curated ZenOS GNOME extensions to exclude from installation.";
        };
        extensionConfig.enable = lib.mkOption {
          type = lib.types.bool;
          default = true;
          description = "Default ZenOS extension settings.";
        };
      };
    };
    default = true;
    description = "Install the curated ZenOS GNOME extension set.";
  };

}
