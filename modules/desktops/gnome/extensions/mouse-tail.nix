{
  pkgs,
  lib,
  ...
}:

with lib;

let
  cfg = options.zenos.desktops.gnome.extensions.mouse-tail;

  # --- Helpers for Types ---
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

  mkStr =
    default: description:
    mkOption {
      type = types.str;
      default = default;
      description = description;
    };

in
{
  options.zenos.desktops.gnome.extensions.mouse-tail = {
    enable = mkEnableOption "Mouse Tail GNOME extension configuration";

    fade-duration = mkInt 200 "How long the trail takes to fade out in milliseconds.";
    line-width = mkInt 8 "Thickness of the mouse trail line.";

    color = mkOption {
      type = types.listOf types.float;
      default = [
        1.0
        1.0
        1.0
      ];
      description = "Color of the mouse trail as RGB values (list of doubles).";
    };

    alpha = mkDouble 0.5 "Transparency level of the mouse trail (0.0 = transparent, 1.0 = opaque).";

    render-mode = mkStr "precise" "Rendering mode: 'precise', 'balance', or 'fast'.";
  };

  # --- Implementation ---
  config = mkIf cfg.enable {
    environment.systemPackages = [ pkgs.gnomeExtensions.mouse-tail ];

    programs.dconf.profiles.user.databases = [
      {
        settings = {
          "org/gnome/shell/extensions/mouse-tail" = {
            fade-duration = cfg.fade-duration;
            line-width = cfg.line-width;
            color = cfg.color;
            alpha = cfg.alpha;
            render-mode = cfg.render-mode;
          };
        };
      }
    ];
  };
}
