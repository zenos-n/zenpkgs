{
  config,
  pkgs,
  lib,
  ...
}:

with lib;

let
  cfg = config.zenos.desktops.gnome.extensions.copyous;

  meta = {
    description = ''
      Advanced clipboard manager with rich UI and media support

      This module installs and configures the **Copyous** extension for GNOME.
      It is a feature-rich clipboard manager with support for text and images, 
      offering extensive customization for its UI, behavior, and keyboard shortcuts.

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
in
{

  options.zenos.desktops.gnome.extensions.copyous = {
    _meta = lib.mkOption {
      internal = true;
      readOnly = true;
      default = meta;
      description = "Internal documentation metadata";
    };
    enable = mkEnableOption "Copyous GNOME extension configuration";

    general = {
      clipboard-size = mkOption {
        type = types.int;
        default = 30;
        description = ''
          Maximum clipboard history size

          Specifies the number of entries to retain in the history buffer.
        '';
      };

      clear-history = mkOption {
        type = types.enum [
          "clear"
          "keep-pinned-and-tagged"
          "keep-all"
        ];
        default = "clear";
        description = ''
          Clipboard clearing behavior

          Determines which items are preserved when the history is cleared.
        '';
      };

      process-primary-selection = mkOption {
        type = types.bool;
        default = false;
        description = ''
          Record primary selection (Middle Click paste)

          Whether to capture text selected by highlighting as a clipboard entry.
        '';
      };
    };

    paste = {
      on-select = mkOption {
        type = types.bool;
        default = true;
        description = ''
          Immediate paste upon selection

          Automatically inserts the clipboard content when an item is 
          selected from the menu.
        '';
      };

      button-action = mkOption {
        type = types.enum [
          "select"
          "copy"
        ];
        default = "select";
        description = ''
          Secondary button click behavior

          Action performed when clicking the secondary interaction button on 
          an item.
        '';
      };
    };

    ui = {
      orientation = mkOption {
        type = types.enum [
          "horizontal"
          "vertical"
        ];
        default = "vertical";
        description = "Visual orientation of the clipboard menu";
      };

      position = mkOption {
        type = types.enum [
          "top"
          "center"
          "bottom"
          "fill"
        ];
        default = "center";
        description = "Screen position of the floating clipboard window";
      };

      header-visibility = mkOption {
        type = types.enum [
          "visible"
          "visible-on-hover"
          "hidden"
        ];
        default = "visible-on-hover";
        description = "Visibility mode for window header controls";
      };

      window-width-percentage = mkOption {
        type = types.int;
        default = 25;
        description = "Width of the clipboard window as a percentage of screen width";
      };

      window-height-percentage = mkOption {
        type = types.int;
        default = 50;
        description = "Height of the clipboard window as a percentage of screen height";
      };

      item-height = mkOption {
        type = types.int;
        default = 90;
        description = "Fixed vertical height for each clipboard list item";
      };

      show-type-icon = mkOption {
        type = types.bool;
        default = true;
        description = "Display icons indicating the data type (text, image, etc.)";
      };

      show-text = mkOption {
        type = types.bool;
        default = true;
        description = "Display the text content or filename of the clipboard entry";
      };
    };

    character-item = {
      max-characters = mkOption {
        type = types.int;
        default = 1;
        description = "Threshold for recognizing an entry as a standalone character";
      };

      show-unicode = mkOption {
        type = types.bool;
        default = false;
        description = "Display the Unicode codepoint for single-character items";
      };
    };

    theme = {
      mode = mkOption {
        type = types.enum [
          "system"
          "dark"
          "light"
          "custom"
        ];
        default = "system";
        description = "Extension color theme mode";
      };

      custom = {
        scheme = mkOption {
          type = types.enum [
            "dark"
            "light"
          ];
          default = "dark";
          description = "Base color scheme for custom theming";
        };

        background-color = mkOption {
          type = types.str;
          default = "";
          description = "Custom CSS color for the window background";
        };

        foreground-color = mkOption {
          type = types.str;
          default = "";
          description = "Custom CSS color for the text and icons";
        };
      };
    };

    shortcuts = {
      toggle-menu = mkOption {
        type = types.listOf types.str;
        default = [ "<Super><Shift>v" ];
        description = "Keyboard shortcut to show/hide the clipboard window";
      };

      move-next = mkOption {
        type = types.listOf types.str;
        default = [ "Down" ];
        description = "Navigation key to move to the next item";
      };

      move-previous = mkOption {
        type = types.listOf types.str;
        default = [ "Up" ];
        description = "Navigation key to move to the previous item";
      };

      select = mkOption {
        type = types.listOf types.str;
        default = [
          "Return"
          "KP_Enter"
        ];
        description = "Shortcut to select and/or paste the focused item";
      };

      delete = mkOption {
        type = types.listOf types.str;
        default = [ "Delete" ];
        description = "Shortcut to remove the focused item from history";
      };

      pin = mkOption {
        type = types.listOf types.str;
        default = [ "p" ];
        description = "Shortcut to toggle the pinned status of an item";
      };

      cycle-view = mkOption {
        type = types.listOf types.str;
        default = [ "Tab" ];
        description = "Shortcut to cycle through different history filters";
      };

      search = mkOption {
        type = types.listOf types.str;
        default = [ "slash" ];
        description = "Shortcut to focus the history search bar";
      };
    };
  };

  config = mkIf cfg.enable {
    environment.systemPackages = [ pkgs.gnomeExtensions.copyous ];

    programs.dconf.profiles.user.databases = [
      {
        settings = {
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
