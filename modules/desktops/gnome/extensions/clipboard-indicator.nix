{
  pkgs,
  lib,
  ...
}:

with lib;

let
  cfg = options.zenos.desktops.gnome.extensions.clipboard-indicator;

  # --- Helpers for Types ---
  mkBool =
    default: description:
    mkOption {
      type = types.bool;
      default = default;
      description = description;
    };

  mkInt =
    default: description:
    mkOption {
      type = types.int;
      default = default;
      description = description;
    };

  mkStrList =
    default: description:
    mkOption {
      type = types.listOf types.str;
      default = default;
      description = description;
    };

in
{
  options.zenos.desktops.gnome.extensions.clipboard-indicator = {
    enable = mkEnableOption "Clipboard Indicator GNOME extension configuration";

    # --- Schema Options ---

    paste-button = mkBool true "If true, adds another button to each menu entry that lets you immediately paste it.";

    pinned-on-bottom = mkBool false "If true, places the 'pinned' section on the bottom.";

    enable-deletion = mkBool true "If true, displays 'delete' buttons on each item, and a 'Clear History' option.";

    history-size = mkInt 15 "The number of items to save in history.";

    display-mode = mkInt 0 "What to display in top bar (0-3).";

    disable-down-arrow = mkBool true "Remove down arrow in top bar.";

    clear-on-boot = mkBool false "Clear clipboard history on every system reboot.";

    paste-on-select = mkBool false "Paste on select.";

    preview-size = mkInt 30 "Amount of visible characters for clipboard items in the menu.";

    topbar-preview-size = mkInt 10 "Amount of visible characters for current clipboard item in the topbar.";

    cache-size = mkInt 5 "The allowed size for the registry cache file in MB.";

    cache-only-favorites = mkBool false "Disable the registry cache file for favorites and use memory only (avoids writing secrets to disk).";

    notify-on-copy = mkBool false "Show notification on copy to clipboard.";

    notify-on-cycle = mkBool true "Show notification when cycling through the clipboard entries using hotkeys.";

    confirm-clear = mkBool true "Show confirmation dialog on Clear History.";

    strip-text = mkBool false "Remove whitespace around text.";

    move-item-first = mkBool false "Move items to the top of the list when selected.";

    keep-selected-on-clear = mkBool false "Whether to keep the currently selected entry in the clipboard after clearing history.";

    enable-keybindings = mkBool true "Enable the keyboard shortcuts.";

    # --- Keybindings (Array of Strings) ---

    clear-history = mkStrList [ "<Control>F10" ] "Key to clear the history.";

    prev-entry = mkStrList [ "<Control>F11" ] "Key to cycle to the previous entry in the clipboard.";

    next-entry = mkStrList [ "<Control>F12" ] "Key to cycle to the next entry in the clipboard.";

    toggle-menu = mkStrList [ "<Control>F9" ] "Key to toggle the clipboard menu.";

    private-mode-binding = mkStrList [ "<Control>F8" ] "Key to toggle Private Mode.";

    # --- Advanced / Other ---

    cache-images = mkBool true "Allow caching images to disk.";

    excluded-apps = mkStrList [ ] "List of applications that are excluded from clipboard history.";

    clear-history-on-interval = mkBool false "Enable clearing history on interval.";

    clear-history-interval = mkInt 60 "Interval for clearing history in minutes.";

    next-history-clear = mkInt (-1) "The timestamp for the next scheduled history clear.";

    case-sensitive-search = mkBool false "Make search case sensitive.";

    regex-search = mkBool false "Allow regex in search.";
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
            history-size = cfg.history-size;
            display-mode = cfg.display-mode;
            disable-down-arrow = cfg.disable-down-arrow;
            clear-on-boot = cfg.clear-on-boot;
            paste-on-select = cfg.paste-on-select;
            preview-size = cfg.preview-size;
            topbar-preview-size = cfg.topbar-preview-size;
            cache-size = cfg.cache-size;
            cache-only-favorites = cfg.cache-only-favorites;
            notify-on-copy = cfg.notify-on-copy;
            notify-on-cycle = cfg.notify-on-cycle;
            confirm-clear = cfg.confirm-clear;
            strip-text = cfg.strip-text;
            move-item-first = cfg.move-item-first;
            keep-selected-on-clear = cfg.keep-selected-on-clear;
            enable-keybindings = cfg.enable-keybindings;
            clear-history = cfg.clear-history;
            prev-entry = cfg.prev-entry;
            next-entry = cfg.next-entry;
            toggle-menu = cfg.toggle-menu;
            private-mode-binding = cfg.private-mode-binding;
            cache-images = cfg.cache-images;
            excluded-apps = cfg.excluded-apps;
            clear-history-on-interval = cfg.clear-history-on-interval;
            clear-history-interval = cfg.clear-history-interval;
            next-history-clear = cfg.next-history-clear;
            case-sensitive-search = cfg.case-sensitive-search;
            regex-search = cfg.regex-search;
          };
        };
      }
    ];
  };
}
