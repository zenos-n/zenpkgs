{
  pkgs,
  lib,
  ...
}:

with lib;

let
  cfg = options.zenos.desktops.gnome.extensions.hidetopbar;

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

  mkDouble =
    default: description:
    mkOption {
      type = types.float;
      default = default;
      description = description;
    };

in
{
  options.zenos.desktops.gnome.extensions.hidetopbar = {
    enable = mkEnableOption "Hide Top Bar GNOME extension configuration";

    hot-corner = mkBool false "Keep hot corner sensitive even when panel is hidden.";
    mouse-sensitive = mkBool false "Show panel when mouse approaches edge of the screen.";
    mouse-sensitive-fullscreen-window = mkBool true "Show panel when mouse approaches edge in fullscreen.";
    mouse-triggers-overview = mkBool false "Show overview when mouse approaches edge (requires mouse-sensitive).";
    keep-round-corners = mkBool false "Keep round corners on the top when panel is hidden.";

    animation-time-overview = mkDouble 0.4 "Slide in/out animation time for overview.";
    animation-time-autohide = mkDouble 0.2 "Slide in/out animation time for autohide.";

    pressure-threshold = mkInt 100 "Pressure barrier threshold (pixels).";
    pressure-timeout = mkInt 1000 "Pressure barrier timeout (ms).";

    shortcut-keybind = mkOption {
      type = types.listOf types.str;
      default = [ ];
      description = "Keyboard shortcut that triggers the bar to be shown.";
    };

    shortcut-delay = mkDouble 1.0 "Delay before bar rehides automatically after key press (0.0 = unlimited).";
    shortcut-toggles = mkBool true "Pressing the shortcut again rehides the panel.";

    enable-intellihide = mkBool true "Panel only hides if a window takes the space.";
    enable-active-window = mkBool true "Intellihide only triggers for active window.";
    show-in-overview = mkBool true "Panel is visible in overview.";
  };

  # --- Implementation ---
  config = mkIf cfg.enable {
    environment.systemPackages = [ pkgs.gnomeExtensions.hidetopbar ];

    programs.dconf.profiles.user.databases = [
      {
        settings = {
          "org/gnome/shell/extensions/hidetopbar" = {
            hot-corner = cfg.hot-corner;
            mouse-sensitive = cfg.mouse-sensitive;
            mouse-sensitive-fullscreen-window = cfg.mouse-sensitive-fullscreen-window;
            mouse-triggers-overview = cfg.mouse-triggers-overview;
            keep-round-corners = cfg.keep-round-corners;
            animation-time-overview = cfg.animation-time-overview;
            animation-time-autohide = cfg.animation-time-autohide;
            pressure-threshold = cfg.pressure-threshold;
            pressure-timeout = cfg.pressure-timeout;
            shortcut-keybind = cfg.shortcut-keybind;
            shortcut-delay = cfg.shortcut-delay;
            shortcut-toggles = cfg.shortcut-toggles;
            enable-intellihide = cfg.enable-intellihide;
            enable-active-window = cfg.enable-active-window;
            show-in-overview = cfg.show-in-overview;
          };
        };
      }
    ];
  };
}
