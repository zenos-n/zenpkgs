{
  config,
  pkgs,
  lib,
  ...
}:

with lib;

let
  cfg = config.zenos.desktops.gnome.extensions.quake-terminal;

  # --- Serializer Logic for a{ss} ---
  # Helper to quote strings for GVariant
  mkGVariantString = v: "'${v}'";

  # Serializer for a{ss} (Map<String, String>)
  serializeLaunchArgs =
    args:
    if args == { } then
      "@a{ss} {}"
    else
      let
        pairs = mapAttrsToList (k: v: "${mkGVariantString k}: ${mkGVariantString v}") args;
      in
      "{${concatStringsSep ", " pairs}}";

in
{
  meta = {
    description = "Configures the Quake Terminal GNOME extension";
    longDescription = ''
      This module installs and configures the **Quake Terminal** extension for GNOME.
      It provides a dropdown terminal (Quake-style) that can be toggled with a keyboard shortcut.

      **Features:**
      - Dropdown terminal functionality for any app (defaults to gnome-terminal).
      - Configurable size, position, and animation.
      - Multi-monitor support.
    '';
    maintainers = with lib.maintainers; [ doromiert ];
    license = lib.licenses.napl;
    platforms = lib.platforms.zenos;
  };

  options.zenos.desktops.gnome.extensions.quake-terminal = {
    enable = mkEnableOption "Quake Terminal GNOME extension configuration";

    # --- Application Settings ---
    app = {
      id = mkOption {
        type = types.str;
        default = "org.gnome.Terminal.desktop";
        description = "The application path used as a reference";
      };

      shortcut = mkOption {
        type = types.listOf types.str;
        default = [ "<Super>Return" ];
        description = "Shortcut to activate the terminal application";
      };

      launch-args = mkOption {
        type = types.attrsOf types.str;
        default = { };
        description = "Dictionary mapping application IDs to their terminal launch arguments";
      };
    };

    # --- Layout ---
    layout = {
      size = {
        vertical = mkOption {
          type = types.int;
          default = 50;
          description = "Terminal Vertical Size (percentage)";
        };

        horizontal = mkOption {
          type = types.int;
          default = 100;
          description = "Terminal Horizontal Size (percentage)";
        };
      };

      alignment = mkOption {
        type = types.int;
        default = 2;
        description = "Terminal Horizontal Alignment (0-2)";
      };
    };

    # --- Monitors ---
    monitors = {
      render-on-current = mkOption {
        type = types.bool;
        default = false;
        description = "Show on the current Display";
      };

      render-on-primary = mkOption {
        type = types.bool;
        default = false;
        description = "Show on the primary Display";
      };

      monitor-index = mkOption {
        type = types.int;
        default = 0;
        description = "Specify the display where the terminal should be rendered";
      };
    };

    # --- Behavior ---
    behavior = {
      auto-hide = mkOption {
        type = types.bool;
        default = true;
        description = "Hide Terminal window when it loses focus";
      };

      always-on-top = mkOption {
        type = types.bool;
        default = false;
        description = "Terminal window will appear on top of all other windows";
      };

      animation-time = mkOption {
        type = types.int;
        default = 250;
        description = "Duration of the dropdown animation in milliseconds";
      };

      skip-taskbar = mkOption {
        type = types.bool;
        default = true;
        description = "Hide terminal window in overview mode or Alt+Tab";
      };
    };
  };

  # --- Implementation ---
  config = mkIf cfg.enable {
    environment.systemPackages = [ pkgs.gnomeExtensions.quake-terminal ];

    # Standard types mapped directly
    programs.dconf.profiles.user.databases = [
      {
        settings = {
          "org/gnome/shell/extensions/quake-terminal" = {
            terminal-id = cfg.app.id;
            terminal-shortcut = cfg.app.shortcut;
            vertical-size = cfg.layout.size.vertical;
            horizontal-size = cfg.layout.size.horizontal;
            horizontal-alignment = cfg.layout.alignment;
            render-on-current-monitor = cfg.monitors.render-on-current;
            render-on-primary-monitor = cfg.monitors.render-on-primary;
            monitor-screen = cfg.monitors.monitor-index;
            auto-hide-window = cfg.behavior.auto-hide;
            always-on-top = cfg.behavior.always-on-top;
            animation-time = cfg.behavior.animation-time;
            skip-taskbar = cfg.behavior.skip-taskbar;
          };
        };
      }
    ];

    # Complex type (a{ss}) handled by systemd service
    systemd.user.services.quake-terminal-setup = {
      description = "Apply Quake Terminal specific configuration";
      wantedBy = [ "graphical-session.target" ];
      partOf = [ "graphical-session.target" ];
      serviceConfig = {
        Type = "oneshot";
        RemainAfterExit = true;
      };
      script = ''
        ${pkgs.dconf}/bin/dconf write /org/gnome/shell/extensions/quake-terminal/launch-args-map ${escapeShellArg (serializeLaunchArgs cfg.app.launch-args)}
      '';
    };
  };
}
