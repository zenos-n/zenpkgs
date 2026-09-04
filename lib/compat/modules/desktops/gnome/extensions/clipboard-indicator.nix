{
  config,
  pkgs,
  lib,
  ...
}:

with lib;

let
  cfg = config.zenos.desktops.gnome.extensions.clipboard-indicator;

  meta = {
    description = ''
      Clipboard history management for the GNOME top bar

      This module installs and configures the **Clipboard Indicator** extension for GNOME.
      It adds a clipboard history menu to the top bar, allowing users to access and 
      paste previously copied items.

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
in
{

  options.zenos.desktops.gnome.extensions.clipboard-indicator = {
    _meta = lib.mkOption {
      internal = true;
      readOnly = true;
      default = meta;
      description = "Internal documentation metadata";
    };
    enable = mkEnableOption "Clipboard Indicator GNOME extension configuration";

    paste-button = mkOption {
      type = types.bool;
      default = true;
      description = ''
        Enable immediate paste buttons

        If true, adds a dedicated button to each menu entry that triggers 
        an immediate paste action upon selection.
      '';
    };

    pinned-on-bottom = mkOption {
      type = types.bool;
      default = false;
      description = ''
        Position pinned items at the bottom

        If true, reorders the clipboard menu to place the 'pinned' section 
        at the bottom of the list.
      '';
    };

    enable-deletion = mkOption {
      type = types.bool;
      default = true;
      description = ''
        Enable history deletion controls

        If true, displays 'delete' buttons on each item and provides a 
        'Clear History' option in the menu.
      '';
    };

    topbar = {
      display-mode = mkOption {
        type = types.enum [
          "icon"
          "content"
          "both"
          "neither"
        ];
        default = "icon";
        description = ''
          Panel display mode

          Configures what information is displayed directly in the GNOME 
          top bar (icon, text content, or both).
        '';
      };

      enable-down-arrow = mkOption {
        type = types.bool;
        default = false;
        description = ''
          Show panel dropdown arrow

          Whether to display a visual down-arrow indicator next to the 
          clipboard icon in the top bar.
        '';
      };
    };

    preview = {
      menu-length = mkOption {
        type = types.int;
        default = 30;
        description = ''
          Menu character preview limit

          The maximum number of characters displayed for clipboard items 
          inside the extension menu.
        '';
      };

      topbar-length = mkOption {
        type = types.int;
        default = 10;
        description = ''
          Topbar character preview limit

          The maximum number of characters displayed for the current 
          clipboard item in the GNOME top bar.
        '';
      };
    };

    history = {
      size = mkOption {
        type = types.int;
        default = 15;
        description = ''
          History buffer size

          The maximum number of copied items to persist in the 
          clipboard history.
        '';
      };

      clear-on-boot = mkOption {
        type = types.bool;
        default = false;
        description = ''
          Clear history on system startup

          When enabled, the clipboard history buffer is purged every 
          time the system reboots.
        '';
      };

      confirm-clear = mkOption {
        type = types.bool;
        default = true;
        description = ''
          Confirm history purge

          Whether to show a confirmation dialog before performing a 
          'Clear History' action.
        '';
      };

      keep-selected-on-clear = mkOption {
        type = types.bool;
        default = false;
        description = ''
          Preserve active selection during clear

          Whether to retain the currently selected clipboard entry 
          when performing a bulk history deletion.
        '';
      };

      excluded-apps = mkOption {
        type = types.listOf types.str;
        default = [ ];
        description = ''
          Applications ignored by the extension

          List of application identifiers whose clipboard activity 
          should not be recorded in the history.
        '';
      };

      autoclear = {
        enable = mkOption {
          type = types.bool;
          default = false;
          description = ''
            Enable periodic history clearing

            Activates the timer-based automatic purging of the 
            clipboard history buffer.
          '';
        };

        interval = mkOption {
          type = types.int;
          default = 60;
          description = ''
            Autoclear interval duration

            Specifies the time in minutes between scheduled 
            history purges.
          '';
        };

        next-run = mkOption {
          type = types.int;
          default = -1;
          description = "Internal state tracker for the next scheduled clear";
        };
      };
    };

    behavior = {
      paste-on-select = mkOption {
        type = types.bool;
        default = false;
        description = ''
          Automatic paste upon selection

          When enabled, clicking a history item immediately pastes 
          it into the active window.
        '';
      };

      move-item-first = mkOption {
        type = types.bool;
        default = false;
        description = ''
          Reorder history on use

          Whether to move items to the top of the history list 
          when they are selected.
        '';
      };

      strip-text = mkOption {
        type = types.bool;
        default = false;
        description = ''
          Trim whitespace from text

          When enabled, leading and trailing whitespace is automatically 
          removed from copied text strings.
        '';
      };
    };

    search = {
      case-sensitive = mkOption {
        type = types.bool;
        default = false;
        description = ''
          Case-sensitive history search

          Whether the search filter should respect character casing.
        '';
      };

      regex = mkOption {
        type = types.bool;
        default = false;
        description = ''
          Enable regular expressions in search

          Allows using advanced regex patterns when filtering the 
          clipboard history.
        '';
      };
    };

    notify = {
      on-copy = mkOption {
        type = types.bool;
        default = false;
        description = ''
          Show notification on new copy

          Displays a desktop notification every time a new item 
          is added to the clipboard.
        '';
      };

      on-cycle = mkOption {
        type = types.bool;
        default = true;
        description = ''
          Show notification during history cycling

          Displays a notification when cycling through clipboard 
          entries using keyboard shortcuts.
        '';
      };
    };

    cache = {
      size = mkOption {
        type = types.int;
        default = 5;
        description = ''
          Maximum registry cache size

          The allowed size for the disk-based registry cache file 
          in megabytes.
        '';
      };

      only-favorites = mkOption {
        type = types.bool;
        default = false;
        description = ''
          Restrict disk cache to favorites

          Disables the registry cache file for standard items, using 
          volatile memory only to avoid writing secrets to disk.
        '';
      };

      images = mkOption {
        type = types.bool;
        default = true;
        description = ''
          Enable image caching to disk

          Whether the extension is permitted to persist copied image 
          data in its disk cache.
        '';
      };
    };

    keybindings = {
      enable = mkOption {
        type = types.bool;
        default = true;
        description = "Enable extension keyboard shortcuts";
      };

      clear-history = mkOption {
        type = types.listOf types.str;
        default = [ "<Control>F10" ];
        description = "Shortcut to purge clipboard history";
      };

      prev-entry = mkOption {
        type = types.listOf types.str;
        default = [ "<Control>F11" ];
        description = "Shortcut to cycle to the previous history entry";
      };

      next-entry = mkOption {
        type = types.listOf types.str;
        default = [ "<Control>F12" ];
        description = "Shortcut to cycle to the next history entry";
      };

      toggle-menu = mkOption {
        type = types.listOf types.str;
        default = [ "<Control>F9" ];
        description = "Shortcut to display the clipboard menu";
      };

      private-mode = mkOption {
        type = types.listOf types.str;
        default = [ "<Control>F8" ];
        description = "Shortcut to toggle Private Mode";
      };
    };
  };

  config = mkIf cfg.enable {
    environment.systemPackages = [ pkgs.gnomeExtensions.clipboard-indicator ];

    programs.dconf.profiles.user.databases = [
      {
        settings = {
          "org/gnome/shell/extensions/clipboard-indicator" = {
            paste-button = cfg.paste-button;
            pinned-on-bottom = cfg.pinned-on-bottom;
            enable-deletion = cfg.enable-deletion;
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
            preview-size = cfg.preview.menu-length;
            topbar-preview-size = cfg.preview.topbar-length;
            history-size = cfg.history.size;
            clear-on-boot = cfg.history.clear-on-boot;
            confirm-clear = cfg.history.confirm-clear;
            keep-selected-on-clear = cfg.history.keep-selected-on-clear;
            excluded-apps = cfg.history.excluded-apps;
            clear-history-on-interval = cfg.history.autoclear.enable;
            clear-history-interval = cfg.history.autoclear.interval;
            next-history-clear = cfg.history.autoclear.next-run;
            paste-on-select = cfg.behavior.paste-on-select;
            move-item-first = cfg.behavior.move-item-first;
            strip-text = cfg.behavior.strip-text;
            case-sensitive-search = cfg.search.case-sensitive;
            regex-search = cfg.search.regex;
            notify-on-copy = cfg.notify.on-copy;
            notify-on-cycle = cfg.notify.on-cycle;
            cache-size = cfg.cache.size;
            cache-only-favorites = cfg.cache.only-favorites;
            cache-images = cfg.cache.images;
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
