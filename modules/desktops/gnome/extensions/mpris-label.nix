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
    description = "Configures the MPRIS Label GNOME extension";
    longDescription = ''
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

    # --- Layout & Formatting ---
    layout = {
      padding-left = mkOption {
        type = types.int;
        default = 30;
        description = "Left padding";
      };

      padding-right = mkOption {
        type = types.int;
        default = 30;
        description = "Right padding";
      };

      max-string-length = mkOption {
        type = types.int;
        default = 30;
        description = "Maximum string length";
      };

      extension-index = mkOption {
        type = types.int;
        default = 3;
        description = "Extension index position";
      };

      extension-place = mkOption {
        type = types.enum [
          "left"
          "center"
          "right"
        ];
        default = "right";
        description = "Extension placement in the top bar";
      };

      refresh-rate = mkOption {
        type = types.int;
        default = 300;
        description = "Refresh rate in milliseconds";
      };

      button-placeholder = mkOption {
        type = types.str;
        default = "＿";
        description = "Button placeholder text";
      };

      divider-string = mkOption {
        type = types.str;
        default = " | ";
        description = "String separator between fields";
      };

      font-color = mkOption {
        type = types.str;
        default = "";
        description = "Font color (CSS value)";
      };

      filtered-list = mkOption {
        type = types.str;
        default = "remaster,remix,featuring,live";
        description = "Comma-separated list of strings to filter out from metadata";
      };
    };

    # --- Fields ---
    fields = {
      first = mkOption {
        type = types.str;
        default = "xesam:artist";
        description = "First metadata field to display";
      };

      second = mkOption {
        type = types.str;
        default = "xesam:title";
        description = "Second metadata field to display";
      };

      last = mkOption {
        type = types.str;
        default = "";
        description = "Last metadata field to display";
      };
    };

    # --- Actions ---
    actions = {
      left = {
        click = mkOption {
          type = types.str;
          default = "play-pause";
          description = "Left click action";
        };
        double-click = mkOption {
          type = types.str;
          default = "next-track";
          description = "Left double-click action";
        };
      };

      right = {
        click = mkOption {
          type = types.str;
          default = "activate-player";
          description = "Right click action";
        };
        double-click = mkOption {
          type = types.str;
          default = "prev-track";
          description = "Right double-click action";
        };
      };

      middle = {
        click = mkOption {
          type = types.str;
          default = "play-pause";
          description = "Middle click action";
        };
        double-click = mkOption {
          type = types.str;
          default = "none";
          description = "Middle double-click action";
        };
      };

      thumb = {
        forward = mkOption {
          type = types.str;
          default = "next-track";
          description = "Mouse thumb forward action";
        };
        double-forward = mkOption {
          type = types.str;
          default = "none";
          description = "Mouse thumb double forward action";
        };
        backward = mkOption {
          type = types.str;
          default = "prev-track";
          description = "Mouse thumb backward action";
        };
        double-backward = mkOption {
          type = types.str;
          default = "none";
          description = "Mouse thumb double backward action";
        };
      };

      scroll = mkOption {
        type = types.str;
        default = "volume-controls";
        description = "Scroll action";
      };

      volume-control-scheme = mkOption {
        type = types.str;
        default = "application";
        description = "Volume control scheme";
      };
    };
  };

  # --- Implementation ---
  config = mkIf cfg.enable {
    environment.systemPackages = [ pkgs.gnomeExtensions.mpris-label ];

    programs.dconf.profiles.user.databases = [
      {
        settings = {
          "org/gnome/shell/extensions/mpris-label" = {
            # Layout
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

            # Fields
            first-field = cfg.fields.first;
            second-field = cfg.fields.second;
            last-field = cfg.fields.last;

            # Actions
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
        };
      }
    ];
  };
}
