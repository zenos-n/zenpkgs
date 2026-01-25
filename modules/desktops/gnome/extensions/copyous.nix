{
  pkgs,
  lib,
  ...
}:

with lib;

let
  cfg = options.zenos.desktops.gnome.extensions.copyous;

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

  mkStr =
    default: description:
    mkOption {
      type = types.str;
      default = default;
      description = description;
    };

  mkOptionStrList =
    default: description:
    mkOption {
      type = types.listOf types.str;
      default = default;
      description = description;
    };

in
{
  options.zenos.desktops.gnome.extensions.copyous = {
    enable = mkEnableOption "Copyous GNOME extension configuration";

    # --- Main ---
    clipboard-size = mkInt 30 "Clipboard size.";
    clear-history = mkStr "clear" "Clear history behavior (clear, keep-pinned-and-tagged, keep-all).";
    process-primary-selection = mkBool false "Process primary selection.";

    # --- Paste ---
    paste-on-select = mkBool true "Paste on select.";
    paste-button-click-action = mkStr "select" "Paste button click action (select, copy).";

    # --- UI ---
    orientation = mkStr "vertical" "Orientation (horizontal, vertical).";
    position = mkStr "center" "Position (top, center, bottom, fill).";
    header-controls-visibility = mkStr "visible-on-hover" "Header controls visibility (visible, visible-on-hover, hidden).";
    window-width-percentage = mkInt 25 "Window width percentage.";
    window-height-percentage = mkInt 50 "Window height percentage.";
    item-height = mkInt 90 "Item height.";
    show-item-type-icon = mkBool true "Show item type icon.";
    show-item-text = mkBool true "Show item text.";

    # --- Character Item ---
    max-characters = mkInt 1 "Maximum characters to recognize as a character item.";
    show-unicode = mkBool false "Show Unicode of the character.";

    # --- Theme ---
    theme = mkStr "system" "Theme (system, dark, light, custom).";
    custom-color-scheme = mkStr "dark" "Custom color scheme (dark, light).";
    custom-bg-color = mkStr "" "Custom background color.";
    custom-fg-color = mkStr "" "Custom foreground color.";

    # --- Shortcuts ---
    toggle-menu = mkOptionStrList [ "<Super><Shift>v" ] "Shortcut to toggle menu.";
    move-next = mkOptionStrList [ "Down" ] "Shortcut to move next.";
    move-previous = mkOptionStrList [ "Up" ] "Shortcut to move previous.";
    select = mkOptionStrList [ "Return" "KP_Enter" ] "Shortcut to select.";
    delete = mkOptionStrList [ "Delete" ] "Shortcut to delete.";
    pin = mkOptionStrList [ "p" ] "Shortcut to pin.";
    cycle-view = mkOptionStrList [ "Tab" ] "Shortcut to cycle view.";
    search = mkOptionStrList [ "slash" ] "Shortcut to search.";
  };

  # --- Implementation ---
  config = mkIf cfg.enable {
    environment.systemPackages = [ pkgs.gnomeExtensions.copyous ];

    programs.dconf.profiles.user.databases = [
      {
        settings = {
          # Main
          "org/gnome/shell/extensions/copyous" = {
            clipboard-size = cfg.clipboard-size;
            clear-history = cfg.clear-history;
            process-primary-selection = cfg.process-primary-selection;
            toggle-menu = cfg.toggle-menu;
          };

          # History (Usually overlaps with main or separate, schema says main)
          # Note: The schema 'org.gnome.shell.extensions.copyous' handles clipboard-size etc.
          # Sub-schemas follow:

          "org/gnome/shell/extensions/copyous/paste" = {
            paste-on-select = cfg.paste-on-select;
            paste-button-click-action = cfg.paste-button-click-action;
          };

          "org/gnome/shell/extensions/copyous/ui" = {
            orientation = cfg.orientation;
            position = cfg.position;
            header-controls-visibility = cfg.header-controls-visibility;
            window-width-percentage = cfg.window-width-percentage;
            window-height-percentage = cfg.window-height-percentage;
            item-height = cfg.item-height;
            show-item-type-icon = cfg.show-item-type-icon;
            show-item-text = cfg.show-item-text;
          };

          "org/gnome/shell/extensions/copyous/shortcuts" = {
            move-next = cfg.move-next;
            move-previous = cfg.move-previous;
            select = cfg.select;
            delete = cfg.delete;
            pin = cfg.pin;
            cycle-view = cfg.cycle-view;
            search = cfg.search;
          };

          "org/gnome/shell/extensions/copyous/character-item" = {
            max-characters = cfg.max-characters;
            show-unicode = cfg.show-unicode;
          };

          "org/gnome/shell/extensions/copyous/theme" = {
            theme = cfg.theme;
            custom-color-scheme = cfg.custom-color-scheme;
            custom-bg-color = cfg.custom-bg-color;
            custom-fg-color = cfg.custom-fg-color;
          };
        };
      }
    ];
  };
}
