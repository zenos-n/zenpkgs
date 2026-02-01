{
  config,
  pkgs,
  lib,
  ...
}:

with lib;

let
  cfg = config.zenos.desktops.gnome.extensions.copyous;

in
{
  meta = {
    description = "Configures the Copyous GNOME extension";
    longDescription = ''
      This module installs and configures the **Copyous** extension for GNOME.
      It is a feature-rich clipboard manager with support for text and images, offering
      extensive customization for its UI, behavior, and keyboard shortcuts.

      **Features:**
      - Clipboard history management.
      - Customizable UI (orientation, position, size).
      - Theming support.
      - Extensive keyboard shortcuts.
    '';
    maintainers = with lib.maintainers; [ doromiert ];
    license = lib.licenses.napl;
    platforms = lib.platforms.zenos;
  };

  options.zenos.desktops.gnome.extensions.copyous = {
    enable = mkEnableOption "Copyous GNOME extension configuration";

    # --- General ---
    general = {
      clipboard-size = mkOption {
        type = types.int;
        default = 30;
        description = "Clipboard size";
      };

      clear-history = mkOption {
        type = types.enum [
          "clear"
          "keep-pinned-and-tagged"
          "keep-all"
        ];
        default = "clear";
        description = "Clear history behavior";
      };

      process-primary-selection = mkOption {
        type = types.bool;
        default = false;
        description = "Process primary selection";
      };
    };

    # --- Paste ---
    paste = {
      on-select = mkOption {
        type = types.bool;
        default = true;
        description = "Paste on select";
      };

      button-action = mkOption {
        type = types.enum [
          "select"
          "copy"
        ];
        default = "select";
        description = "Paste button click action";
      };
    };

    # --- UI ---
    ui = {
      orientation = mkOption {
        type = types.enum [
          "horizontal"
          "vertical"
        ];
        default = "vertical";
        description = "Orientation";
      };

      position = mkOption {
        type = types.enum [
          "top"
          "center"
          "bottom"
          "fill"
        ];
        default = "center";
        description = "Position";
      };

      header-visibility = mkOption {
        type = types.enum [
          "visible"
          "visible-on-hover"
          "hidden"
        ];
        default = "visible-on-hover";
        description = "Header controls visibility";
      };

      window-width-percentage = mkOption {
        type = types.int;
        default = 25;
        description = "Window width percentage";
      };

      window-height-percentage = mkOption {
        type = types.int;
        default = 50;
        description = "Window height percentage";
      };

      item-height = mkOption {
        type = types.int;
        default = 90;
        description = "Item height";
      };

      show-type-icon = mkOption {
        type = types.bool;
        default = true;
        description = "Show item type icon";
      };

      show-text = mkOption {
        type = types.bool;
        default = true;
        description = "Show item text";
      };
    };

    # --- Character Item ---
    character-item = {
      max-characters = mkOption {
        type = types.int;
        default = 1;
        description = "Maximum characters to recognize as a character item";
      };

      show-unicode = mkOption {
        type = types.bool;
        default = false;
        description = "Show Unicode of the character";
      };
    };

    # --- Theme ---
    theme = {
      mode = mkOption {
        type = types.enum [
          "system"
          "dark"
          "light"
          "custom"
        ];
        default = "system";
        description = "Theme mode";
      };

      custom = {
        scheme = mkOption {
          type = types.enum [
            "dark"
            "light"
          ];
          default = "dark";
          description = "Custom color scheme base";
        };

        background-color = mkOption {
          type = types.str;
          default = "";
          description = "Custom background color";
        };

        foreground-color = mkOption {
          type = types.str;
          default = "";
          description = "Custom foreground color";
        };
      };
    };

    # --- Shortcuts ---
    shortcuts = {
      toggle-menu = mkOption {
        type = types.listOf types.str;
        default = [ "<Super><Shift>v" ];
        description = "Shortcut to toggle menu";
      };

      move-next = mkOption {
        type = types.listOf types.str;
        default = [ "Down" ];
        description = "Shortcut to move next";
      };

      move-previous = mkOption {
        type = types.listOf types.str;
        default = [ "Up" ];
        description = "Shortcut to move previous";
      };

      select = mkOption {
        type = types.listOf types.str;
        default = [
          "Return"
          "KP_Enter"
        ];
        description = "Shortcut to select";
      };

      delete = mkOption {
        type = types.listOf types.str;
        default = [ "Delete" ];
        description = "Shortcut to delete";
      };

      pin = mkOption {
        type = types.listOf types.str;
        default = [ "p" ];
        description = "Shortcut to pin";
      };

      cycle-view = mkOption {
        type = types.listOf types.str;
        default = [ "Tab" ];
        description = "Shortcut to cycle view";
      };

      search = mkOption {
        type = types.listOf types.str;
        default = [ "slash" ];
        description = "Shortcut to search";
      };
    };
  };

  # --- Implementation ---
  config = mkIf cfg.enable {
    environment.systemPackages = [ pkgs.gnomeExtensions.copyous ];

    programs.dconf.profiles.user.databases = [
      {
        settings = {
          # Main
          "org/gnome/shell/extensions/copyous" = {
            clipboard-size = cfg.general.clipboard-size;
            clear-history = cfg.general.clear-history;
            process-primary-selection = cfg.general.process-primary-selection;
            toggle-menu = cfg.shortcuts.toggle-menu;
          };

          "org/gnome/shell/extensions/copyous/paste" = {
            paste-on-select = cfg.paste.on-select;
            paste-button-click-action = cfg.paste.button-action;
          };

          "org/gnome/shell/extensions/copyous/ui" = {
            orientation = cfg.ui.orientation;
            position = cfg.ui.position;
            header-controls-visibility = cfg.ui.header-visibility;
            window-width-percentage = cfg.ui.window-width-percentage;
            window-height-percentage = cfg.ui.window-height-percentage;
            item-height = cfg.ui.item-height;
            show-item-type-icon = cfg.ui.show-type-icon;
            show-item-text = cfg.ui.show-text;
          };

          "org/gnome/shell/extensions/copyous/shortcuts" = {
            move-next = cfg.shortcuts.move-next;
            move-previous = cfg.shortcuts.move-previous;
            select = cfg.shortcuts.select;
            delete = cfg.shortcuts.delete;
            pin = cfg.shortcuts.pin;
            cycle-view = cfg.shortcuts.cycle-view;
            search = cfg.shortcuts.search;
          };

          "org/gnome/shell/extensions/copyous/character-item" = {
            max-characters = cfg.character-item.max-characters;
            show-unicode = cfg.character-item.show-unicode;
          };

          "org/gnome/shell/extensions/copyous/theme" = {
            theme = cfg.theme.mode;
            custom-color-scheme = cfg.theme.custom.scheme;
            custom-bg-color = cfg.theme.custom.background-color;
            custom-fg-color = cfg.theme.custom.foreground-color;
          };
        };
      }
    ];
  };
}
