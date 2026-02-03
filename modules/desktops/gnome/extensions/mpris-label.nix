{
  config,
  pkgs,
  lib,
  ...
}:

with lib;

let
  cfg = config.zenos.desktops.gnome.extensions.mpris-label;

in
{
  meta = {
    description = ''
      Media metadata display for the GNOME top bar

      This module installs and configures the **MPRIS Label** extension for GNOME.
      It displays the currently playing media metadata (artist, title, etc.) in the top bar,
      with customizable fields, layout, and mouse actions.

      **Features:**
      - Customizable metadata fields (Artist, Title, etc.).
      - configurable mouse click and scroll actions.
      - Extensive layout and formatting options.
    '';
    maintainers = with lib.maintainers; [ doromiert ];
    license = lib.licenses.napl;
    platforms = lib.platforms.zenos;
  };

  options.zenos.desktops.gnome.extensions.mpris-label = {
    enable = mkEnableOption "MPRIS Label GNOME extension configuration";

    layout = {
      padding-left = mkOption {
        type = types.int;
        default = 30;
        description = "Horizontal pixel padding on the left side of the label";
      };
      padding-right = mkOption {
        type = types.int;
        default = 30;
        description = "Horizontal pixel padding on the right side of the label";
      };
      max-string-length = mkOption {
        type = types.int;
        default = 30;
        description = "Maximum character count for the metadata string before truncation";
      };
      extension-index = mkOption {
        type = types.int;
        default = 3;
        description = "Relative sorting index for top bar placement";
      };
      extension-place = mkOption {
        type = types.enum [
          "left"
          "center"
          "right"
        ];
        default = "right";
        description = "Panel container for the label";
      };
      refresh-rate = mkOption {
        type = types.int;
        default = 300;
        description = "Time in milliseconds between metadata polling updates";
      };
      button-placeholder = mkOption {
        type = types.str;
        default = "＿";
        description = "Text displayed when no media metadata is available";
      };
      divider-string = mkOption {
        type = types.str;
        default = " | ";
        description = "Character sequence used to separate metadata fields";
      };
      font-color = mkOption {
        type = types.str;
        default = "";
        description = "Custom CSS color for the label text";
      };
      filtered-list = mkOption {
        type = types.str;
        default = "remaster,remix,featuring,live";
        description = "Comma-separated list of terms to strip from metadata";
      };
    };

    fields = {
      first = mkOption {
        type = types.str;
        default = "xesam:artist";
        description = "Primary xesam metadata key to display";
      };
      second = mkOption {
        type = types.str;
        default = "xesam:title";
        description = "Secondary xesam metadata key to display";
      };
      last = mkOption {
        type = types.str;
        default = "";
        description = "Tertiary xesam metadata key to display";
      };
    };

    actions = {
      left = {
        click = mkOption {
          type = types.str;
          default = "play-pause";
          description = "Action performed on primary mouse click";
        };
        double-click = mkOption {
          type = types.str;
          default = "next-track";
          description = "Action performed on primary double-click";
        };
      };
      right = {
        click = mkOption {
          type = types.str;
          default = "activate-player";
          description = "Action performed on secondary mouse click";
        };
        double-click = mkOption {
          type = types.str;
          default = "prev-track";
          description = "Action performed on secondary double-click";
        };
      };
      middle = {
        click = mkOption {
          type = types.str;
          default = "play-pause";
          description = "Action performed on middle mouse click";
        };
        double-click = mkOption {
          type = types.str;
          default = "none";
          description = "Action performed on middle double-click";
        };
      };
      thumb = {
        forward = mkOption {
          type = types.str;
          default = "next-track";
          description = "Action performed on mouse button 5";
        };
        double-forward = mkOption {
          type = types.str;
          default = "none";
          description = "Action performed on button 5 double-click";
        };
        backward = mkOption {
          type = types.str;
          default = "prev-track";
          description = "Action performed on mouse button 4";
        };
        double-backward = mkOption {
          type = types.str;
          default = "none";
          description = "Action performed on button 4 double-click";
        };
      };
      scroll = mkOption {
        type = types.str;
        default = "volume-controls";
        description = "Action performed on mouse wheel scroll over label";
      };
      volume-control-scheme = mkOption {
        type = types.str;
        default = "application";
        description = "Target for volume adjustments (application or system)";
      };
    };
  };

  config = mkIf cfg.enable {
    environment.systemPackages = [ pkgs.gnomeExtensions.mpris-label ];
    programs.dconf.profiles.user.databases = [
      {
        settings."org/gnome/shell/extensions/mpris-label" = {
          left-padding = cfg.layout.padding-left;
          right-padding = cfg.layout.padding-right;
          max-string-length = cfg.layout.max-string-length;
          extension-index = cfg.layout.extension-index;
          extension-place = cfg.layout.extension-place;
          refresh-rate = cfg.layout.refresh-rate;
          button-placeholder = cfg.layout.button-placeholder;
          font-color = cfg.layout.font-color;
          label-filtered-list = cfg.layout.filtered-list;
          divider-string = cfg.layout.divider-string;
          first-field = cfg.fields.first;
          second-field = cfg.fields.second;
          last-field = cfg.fields.last;
          left-click-action = cfg.actions.left.click;
          left-double-click-action = cfg.actions.left.double-click;
          right-click-action = cfg.actions.right.click;
          right-double-click-action = cfg.actions.right.double-click;
          middle-click-action = cfg.actions.middle.click;
          middle-double-click-action = cfg.actions.middle.double-click;
          thumb-forward-action = cfg.actions.thumb.forward;
          thumb-double-forward-action = cfg.actions.thumb.double-forward;
          thumb-backward-action = cfg.actions.thumb.backward;
          thumb-double-backward-action = cfg.actions.thumb.double-backward;
          scroll-action = cfg.actions.scroll;
          volume-control-scheme = cfg.actions.volume-control-scheme;
        };
      }
    ];
  };
}
