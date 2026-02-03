{
  config,
  pkgs,
  lib,
  ...
}:

with lib;

let
  cfg = config.zenos.desktops.gnome.extensions.hidetopbar;

in
{
  meta = {
    description = ''
      Intelligent panel visibility management for GNOME Shell

      This module installs and configures the **Hide Top Bar** extension for GNOME.
      It automatically hides the top bar to maximize screen space, showing it only
      when the mouse approaches the edge or via keyboard shortcuts.

      **Features:**
      - Intelligent hiding (intellihide) when windows overlap the panel.
      - Configurable mouse sensitivity and pressure barriers.
      - Keyboard shortcuts to toggle visibility.
    '';
    maintainers = with lib.maintainers; [ doromiert ];
    license = lib.licenses.napl;
    platforms = lib.platforms.zenos;
  };

  options.zenos.desktops.gnome.extensions.hidetopbar = {
    enable = mkEnableOption "Hide Top Bar GNOME extension configuration";

    hot-corner = mkOption {
      type = types.bool;
      default = false;
      description = ''
        Maintain hot corner sensitivity

        Whether to keep the activities hot corner active even when the 
        panel is hidden.
      '';
    };

    mouse-sensitive = mkOption {
      type = types.bool;
      default = false;
      description = ''
        Reveal panel on mouse proximity

        Whether to show the panel when the mouse cursor approaches the 
        edge of the screen.
      '';
    };

    mouse-sensitive-fullscreen-window = mkOption {
      type = types.bool;
      default = true;
      description = ''
        Enable mouse reveal in fullscreen

        Allows revealing the panel via mouse proximity even when a 
        fullscreen application is active.
      '';
    };

    mouse-triggers-overview = mkOption {
      type = types.bool;
      default = false;
      description = ''
        Trigger overview on edge proximity

        Whether to open the activity overview when the mouse hits 
        the panel edge.
      '';
    };

    keep-round-corners = mkOption {
      type = types.bool;
      default = false;
      description = ''
        Maintain rounded panel corners

        Preserves the aesthetic rounded corners of the top panel 
        even in its hidden state.
      '';
    };

    animation-time-overview = mkOption {
      type = types.float;
      default = 0.4;
      description = ''
        Overview transition speed

        Duration in seconds for the panel slide animation when 
        entering the overview.
      '';
    };

    animation-time-autohide = mkOption {
      type = types.float;
      default = 0.2;
      description = ''
        Autohide transition speed

        Duration in seconds for the panel slide animation during 
        standard reveal/hide events.
      '';
    };

    pressure-threshold = mkOption {
      type = types.int;
      default = 100;
      description = ''
        Edge pressure barrier limit

        The amount of cursor 'pressure' (pixels) required to break 
        the reveal barrier.
      '';
    };

    pressure-timeout = mkOption {
      type = types.int;
      default = 1000;
      description = ''
        Pressure barrier reset time

        Time in milliseconds before the pressure barrier resets 
        after a failed break attempt.
      '';
    };

    shortcut-keybind = mkOption {
      type = types.listOf types.str;
      default = [ ];
      description = ''
        Panel visibility keyboard shortcut

        List of key combinations used to manually reveal the top bar.
      '';
    };

    shortcut-delay = mkOption {
      type = types.float;
      default = 1.0;
      description = ''
        Manual reveal persistence

        Number of seconds the bar remains visible after being 
        triggered by a keyboard shortcut.
      '';
    };

    shortcut-toggles = mkOption {
      type = types.bool;
      default = true;
      description = ''
        Enable shortcut toggle mode

        If enabled, pressing the reveal shortcut while the bar is 
        visible will manually hide it.
      '';
    };

    enable-intellihide = mkOption {
      type = types.bool;
      default = true;
      description = ''
        Enable smart hiding logic

        Only hides the panel when a window occupies the panel area.
      '';
    };

    enable-active-window = mkOption {
      type = types.bool;
      default = true;
      description = ''
        Restrict intellihide to active window

        When enabled, only the focused window triggers the panel 
        hiding logic.
      '';
    };

    show-in-overview = mkOption {
      type = types.bool;
      default = true;
      description = ''
        Show panel in activities overview

        Whether the panel should always be rendered when the 
        overview is active.
      '';
    };
  };

  config = mkIf cfg.enable {
    environment.systemPackages = [ pkgs.gnomeExtensions.hidetopbar ];
    programs.dconf.profiles.user.databases = [
      {
        settings."org/gnome/shell/extensions/hidetopbar" = {
          inherit (cfg)
            hot-corner
            mouse-sensitive
            mouse-sensitive-fullscreen-window
            mouse-triggers-overview
            keep-round-corners
            animation-time-overview
            animation-time-autohide
            pressure-threshold
            pressure-timeout
            shortcut-keybind
            shortcut-delay
            shortcut-toggles
            enable-intellihide
            enable-active-window
            show-in-overview
            ;
        };
      }
    ];
  };
}
