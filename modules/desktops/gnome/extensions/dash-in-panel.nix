{
  pkgs,
  lib,
  ...
}:

with lib;

let
  cfg = options.zenos.desktops.gnome.extensions.dash-in-panel;

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

in
{
  options.zenos.desktops.gnome.extensions.dash-in-panel = {
    enable = mkEnableOption "Dash In Panel GNOME extension configuration";

    show-overview = mkBool false "Show overview at start-up.";
    show-dash = mkBool false "Show dash in overview.";
    show-activities = mkBool false "Show activities indicator.";
    move-date = mkBool true "Move date menu to the right.";
    center-dash = mkBool false "Move dash to the center.";
    show-label = mkBool true "Show app label on hover.";
    show-running = mkBool false "Show only running apps.";
    dim-dot = mkBool false "Dim running app indicator opacity when not on active workspace.";
    show-apps = mkBool true "Show app grid button.";
    scroll-panel = mkBool true "Scroll on panel to change workspace.";
    click-changed = mkBool true "Minimize focus app on click.";
    cycle-windows = mkBool true "Cycle through windows.";
    colored-dot = mkBool true "Colored running indicator.";
    button-margin = mkInt 2 "App button margin.";
    panel-height = mkInt 32 "Top panel height.";
    icon-size = mkInt 20 "Icon size.";
  };

  # --- Implementation ---
  config = mkIf cfg.enable {
    environment.systemPackages = [ pkgs.gnomeExtensions.dash-in-panel ];

    programs.dconf.profiles.user.databases = [
      {
        settings = {
          "org/gnome/shell/extensions/dash-in-panel" = {
            show-overview = cfg.show-overview;
            show-dash = cfg.show-dash;
            show-activities = cfg.show-activities;
            move-date = cfg.move-date;
            center-dash = cfg.center-dash;
            show-label = cfg.show-label;
            show-running = cfg.show-running;
            dim-dot = cfg.dim-dot;
            show-apps = cfg.show-apps;
            scroll-panel = cfg.scroll-panel;
            click-changed = cfg.click-changed;
            cycle-windows = cfg.cycle-windows;
            colored-dot = cfg.colored-dot;
            button-margin = cfg.button-margin;
            panel-height = cfg.panel-height;
            icon-size = cfg.icon-size;
          };
        };
      }
    ];
  };
}
