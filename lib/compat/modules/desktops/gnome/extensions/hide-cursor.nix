{
  config,
  pkgs,
  lib,
  ...
}:

with lib;

let
  cfg = config.zenos.desktops.gnome.extensions.hide-cursor;

  meta = {
    description = ''
      Automatic mouse cursor suppression for GNOME Shell

      This module installs and configures the **Hide Cursor** extension for GNOME.
      It automatically hides the mouse cursor after a specified period of inactivity, 
      useful for focused reading or media consumption.

      **Features:**
      - Configurable idle timeout.
    '';
    maintainers = with lib.maintainers; [ doromiert ];
    license = lib.licenses.napl;
    platforms = lib.platforms.zenos;
  };
in
{

  options.zenos.desktops.gnome.extensions.hide-cursor = {
    _meta = lib.mkOption {
      internal = true;
      readOnly = true;
      default = meta;
      description = "Internal documentation metadata";
    };
    enable = mkEnableOption "Hide Cursor GNOME extension configuration";

    timeout = mkOption {
      type = types.int;
      default = 5;
      description = ''
        Idle threshold for cursor hiding

        Specifies the number of seconds of mouse inactivity before 
        the cursor is automatically concealed.
      '';
    };
  };

  config = mkIf cfg.enable {
    environment.systemPackages = [ pkgs.gnomeExtensions.hide-cursor ];

    programs.dconf.profiles.user.databases = [
      {
        settings = {
          "org/gnome/shell/extensions/hide-cursor-elcste-com" = {
            timeout = cfg.timeout;
          };
        };
      }
    ];
  };
}
