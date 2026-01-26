{
  config,
  pkgs,
  lib,
  ...
}:

with lib;

let
  cfg = config.zenos.desktops.gnome.extensions.mpris-label;

  # --- Helpers for Types ---
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

in
{
  options.zenos.desktops.gnome.extensions.mpris-label = {
    enable = mkEnableOption "MPRIS Label GNOME extension configuration";

    # --- Layout & Formatting ---
    left-padding = mkInt 30 "Left padding.";
    right-padding = mkInt 30 "Right padding.";
    max-string-length = mkInt 30 "Maximum string length.";
    extension-index = mkInt 3 "Extension index.";
    extension-place = mkStr "right" "Extension place (left, center, right).";
    refresh-rate = mkInt 300 "Refresh rate (ms).";
    button-placeholder = mkStr "＿" "Button placeholder text.";
    font-color = mkStr "" "Font color (css).";
    label-filtered-list = mkStr "remaster,remix,featuring,live" "Comma-separated list of strings to filter out.";
    divider-string = mkStr " | " "String separator between fields.";

    # --- Fields ---
    first-field = mkStr "xesam:artist" "First metadata field.";
    second-field = mkStr "xesam:title" "Second metadata field.";
    last-field = mkStr "" "Last metadata field.";

    # --- Actions ---
    left-click-action = mkStr "play-pause" "Left click action.";
    left-double-click-action = mkStr "next-track" "Left double-click action.";
    right-click-action = mkStr "activate-player" "Right click action.";
    right-double-click-action = mkStr "prev-track" "Right double-click action.";
    middle-click-action = mkStr "play-pause" "Middle click action.";
    middle-double-click-action = mkStr "none" "Middle double-click action.";

    thumb-forward-action = mkStr "next-track" "Mouse thumb forward action.";
    thumb-double-forward-action = mkStr "none" "Mouse thumb double forward action.";
    thumb-backward-action = mkStr "prev-track" "Mouse thumb backward action.";
    thumb-double-backward-action = mkStr "none" "Mouse thumb double backward action.";

    scroll-action = mkStr "volume-controls" "Scroll action.";
    volume-control-scheme = mkStr "application" "Volume control scheme.";
  };

  # --- Implementation ---
  config = mkIf cfg.enable {
    environment.systemPackages = [ pkgs.gnomeExtensions.mpris-label ];

    programs.dconf.profiles.user.databases = [
      {
        settings = {
          "org/gnome/shell/extensions/mpris-label" = {
            left-padding = cfg.left-padding;
            right-padding = cfg.right-padding;
            max-string-length = cfg.max-string-length;
            extension-index = cfg.extension-index;
            extension-place = cfg.extension-place;
            refresh-rate = cfg.refresh-rate;
            button-placeholder = cfg.button-placeholder;
            font-color = cfg.font-color;
            label-filtered-list = cfg.label-filtered-list;
            divider-string = cfg.divider-string;
            first-field = cfg.first-field;
            second-field = cfg.second-field;
            last-field = cfg.last-field;

            left-click-action = cfg.left-click-action;
            left-double-click-action = cfg.left-double-click-action;
            right-click-action = cfg.right-click-action;
            right-double-click-action = cfg.right-double-click-action;
            middle-click-action = cfg.middle-click-action;
            middle-double-click-action = cfg.middle-double-click-action;

            thumb-forward-action = cfg.thumb-forward-action;
            thumb-double-forward-action = cfg.thumb-double-forward-action;
            thumb-backward-action = cfg.thumb-backward-action;
            thumb-double-backward-action = cfg.thumb-double-backward-action;

            scroll-action = cfg.scroll-action;
            volume-control-scheme = cfg.volume-control-scheme;
          };
        };
      }
    ];
  };
}
