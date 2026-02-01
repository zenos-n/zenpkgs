{
  config,
  pkgs,
  lib,
  ...
}:

with lib;

let
  cfg = config.zenos.desktops.gnome.extensions.clipboard-indicator;

in
{
  meta = {
    description = "Configures the Clipboard Indicator GNOME extension";
    longDescription = ''
      This module installs and configures the **Clipboard Indicator** extension for GNOME.
      It adds a clipboard history menu to the top bar, allowing users to access and paste previously copied items.

      **Features:**
      - Clipboard history with configurable size.
      - Private mode to prevent caching specific items.
      - Customizable keyboard shortcuts.
      - Option to clear history on boot or interval.
    '';
    maintainers = with lib.maintainers; [ doromiert ];
    license = lib.licenses.napl;
    platforms = lib.platforms.zenos;
  };

  options.zenos.desktops.gnome.extensions.clipboard-indicator = {
    enable = mkEnableOption "Clipboard Indicator GNOME extension configuration";

    # --- UI / Layout Options ---

    paste-button = mkOption {
      type = types.bool;
      default = true;
      description = "If true, adds another button to each menu entry that lets you immediately paste it";
    };

    pinned-on-bottom = mkOption {
      type = types.bool;
      default = false;
      description = "If true, places the 'pinned' section on the bottom";
    };

    enable-deletion = mkOption {
      type = types.bool;
      default = true;
      description = "If true, displays 'delete' buttons on each item, and a 'Clear History' option";
    };

    # --- Grouped Options ---

    topbar = {
      display-mode = mkOption {
        type = types.enum [
          "icon"
          "content"
          "both"
          "neither"
        ];
        default = "icon";
        description = "What to display in the top bar";
      };

      enable-down-arrow = mkOption {
        type = types.bool;
        default = false;
        description = "Show down arrow in top bar";
      };
    };

    preview = {
      menu-length = mkOption {
        type = types.int;
        default = 30;
        description = "Amount of visible characters for clipboard items in the menu";
      };

      topbar-length = mkOption {
        type = types.int;
        default = 10;
        description = "Amount of visible characters for current clipboard item in the topbar";
      };
    };

    history = {
      size = mkOption {
        type = types.int;
        default = 15;
        description = "The number of items to save in history";
      };

      clear-on-boot = mkOption {
        type = types.bool;
        default = false;
        description = "Clear clipboard history on every system reboot";
      };

      confirm-clear = mkOption {
        type = types.bool;
        default = true;
        description = "Show confirmation dialog on Clear History";
      };

      keep-selected-on-clear = mkOption {
        type = types.bool;
        default = false;
        description = "Whether to keep the currently selected entry in the clipboard after clearing history";
      };

      excluded-apps = mkOption {
        type = types.listOf types.str;
        default = [ ];
        description = "List of applications that are excluded from clipboard history";
      };

      autoclear = {
        enable = mkOption {
          type = types.bool;
          default = false;
          description = "Enable clearing history on interval";
        };

        interval = mkOption {
          type = types.int;
          default = 60;
          description = "Interval for clearing history in minutes";
        };

        next-run = mkOption {
          type = types.int;
          default = -1;
          description = "The timestamp for the next scheduled history clear (Internal state)";
        };
      };
    };

    behavior = {
      paste-on-select = mkOption {
        type = types.bool;
        default = false;
        description = "Paste on select";
      };

      move-item-first = mkOption {
        type = types.bool;
        default = false;
        description = "Move items to the top of the list when selected";
      };

      strip-text = mkOption {
        type = types.bool;
        default = false;
        description = "Remove whitespace around text";
      };
    };

    search = {
      case-sensitive = mkOption {
        type = types.bool;
        default = false;
        description = "Make search case sensitive";
      };

      regex = mkOption {
        type = types.bool;
        default = false;
        description = "Allow regex in search";
      };
    };

    notify = {
      on-copy = mkOption {
        type = types.bool;
        default = false;
        description = "Show notification on copy to clipboard";
      };

      on-cycle = mkOption {
        type = types.bool;
        default = true;
        description = "Show notification when cycling through the clipboard entries using hotkeys";
      };
    };

    cache = {
      size = mkOption {
        type = types.int;
        default = 5;
        description = "The allowed size for the registry cache file in MB";
      };

      only-favorites = mkOption {
        type = types.bool;
        default = false;
        description = "Disable the registry cache file for favorites and use memory only (avoids writing secrets to disk)";
      };

      images = mkOption {
        type = types.bool;
        default = true;
        description = "Allow caching images to disk";
      };
    };

    keybindings = {
      enable = mkOption {
        type = types.bool;
        default = true;
        description = "Enable the keyboard shortcuts";
      };

      clear-history = mkOption {
        type = types.listOf types.str;
        default = [ "<Control>F10" ];
        description = "Key to clear the history";
      };

      prev-entry = mkOption {
        type = types.listOf types.str;
        default = [ "<Control>F11" ];
        description = "Key to cycle to the previous entry in the clipboard";
      };

      next-entry = mkOption {
        type = types.listOf types.str;
        default = [ "<Control>F12" ];
        description = "Key to cycle to the next entry in the clipboard";
      };

      toggle-menu = mkOption {
        type = types.listOf types.str;
        default = [ "<Control>F9" ];
        description = "Key to toggle the clipboard menu";
      };

      private-mode = mkOption {
        type = types.listOf types.str;
        default = [ "<Control>F8" ];
        description = "Key to toggle Private Mode";
      };
    };
  };

  config = mkIf cfg.enable {
    environment.systemPackages = [ pkgs.gnomeExtensions.clipboard-indicator ];

    programs.dconf.profiles.user.databases = [
      {
        settings = {
          "org/gnome/shell/extensions/clipboard-indicator" = {
            # UI
            paste-button = cfg.paste-button;
            pinned-on-bottom = cfg.pinned-on-bottom;
            enable-deletion = cfg.enable-deletion;

            # Topbar
            display-mode =
              let
                modes = {
                  icon = 0;
                  content = 1;
                  both = 2;
                  neither = 3;
                };
              in
              modes.${cfg.topbar.display-mode};
            disable-down-arrow = !cfg.topbar.enable-down-arrow;

            # Preview
            preview-size = cfg.preview.menu-length;
            topbar-preview-size = cfg.preview.topbar-length;

            # History
            history-size = cfg.history.size;
            clear-on-boot = cfg.history.clear-on-boot;
            confirm-clear = cfg.history.confirm-clear;
            keep-selected-on-clear = cfg.history.keep-selected-on-clear;
            excluded-apps = cfg.history.excluded-apps;

            # History Autoclear
            clear-history-on-interval = cfg.history.autoclear.enable;
            clear-history-interval = cfg.history.autoclear.interval;
            next-history-clear = cfg.history.autoclear.next-run;

            # Behavior
            paste-on-select = cfg.behavior.paste-on-select;
            move-item-first = cfg.behavior.move-item-first;
            strip-text = cfg.behavior.strip-text;

            # Search
            case-sensitive-search = cfg.search.case-sensitive;
            regex-search = cfg.search.regex;

            # Notify
            notify-on-copy = cfg.notify.on-copy;
            notify-on-cycle = cfg.notify.on-cycle;

            # Cache
            cache-size = cfg.cache.size;
            cache-only-favorites = cfg.cache.only-favorites;
            cache-images = cfg.cache.images;

            # Keybindings
            enable-keybindings = cfg.keybindings.enable;
            clear-history = cfg.keybindings.clear-history;
            prev-entry = cfg.keybindings.prev-entry;
            next-entry = cfg.keybindings.next-entry;
            toggle-menu = cfg.keybindings.toggle-menu;
            private-mode-binding = cfg.keybindings.private-mode;
          };
        };
      }
    ];
  };
}
