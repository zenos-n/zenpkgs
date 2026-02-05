{
  config,
  pkgs,
  lib,
  ...
}:

with lib;

let
  cfg = config.zenos.desktops.gnome.extensions.quake-terminal;

  mkGVariantString = v: "'${v}'";

  serializeLaunchArgs =
    args:
    if args == { } then
      "@a{ss} {}"
    else
      let
        pairs = mapAttrsToList (k: v: "${mkGVariantString k}: ${mkGVariantString v}") args;
      in
      "{${concatStringsSep ", " pairs}}";

  meta = {
    description = ''
      Dropdown application integration for GNOME Shell

      This module installs and configures the **Quake Terminal** extension for GNOME.
      It provides a dropdown terminal (Quake-style) that can be toggled with a 
      keyboard shortcut.

      **Features:**
      - Dropdown terminal functionality for any app (defaults to gnome-terminal).
      - Configurable size, position, and animation.
      - Multi-monitor support.
    '';
    maintainers = with lib.maintainers; [ doromiert ];
    license = lib.licenses.napl;
    platforms = lib.platforms.zenos;
  };
in
{

  options.zenos.desktops.gnome.extensions.quake-terminal = {
    _meta = lib.mkOption {
      internal = true;
      readOnly = true;
      default = meta;
      description = "Internal documentation metadata";
    };
    enable = mkEnableOption "Quake Terminal GNOME extension configuration";

    app = {
      id = mkOption {
        type = types.str;
        default = "org.gnome.Terminal.desktop";
        description = ''
          Target application for dropdown

          The desktop entry ID of the application that should behave as the 
          Quake-style terminal.
        '';
      };

      shortcut = mkOption {
        type = types.str;
        default = "<Alt>Tab";
        description = ''
          Toggle keyboard shortcut

          Key combination used to reveal and conceal the dropdown window.
        '';
      };

      launch-args = mkOption {
        type = types.attrsOf types.str;
        default = { };
        description = ''
          Application command arguments

          Custom key-value pairs passed to the application upon launch 
          (e.g., terminal profile or shell flags).
        '';
      };
    };

    layout = {
      size = {
        vertical = mkOption {
          type = types.int;
          default = 50;
          description = "Window height as a percentage of monitor height";
        };
        horizontal = mkOption {
          type = types.int;
          default = 100;
          description = "Window width as a percentage of monitor width";
        };
      };

      alignment = mkOption {
        type = types.int;
        default = 1;
        description = "Horizontal alignment of the dropdown window (0: left, 1: center, 2: right)";
      };
    };

    monitors = {
      render-on-current = mkOption {
        type = types.bool;
        default = true;
        description = "Display the dropdown on the monitor containing the mouse cursor";
      };
      render-on-primary = mkOption {
        type = types.bool;
        default = false;
        description = "Always display the dropdown on the primary monitor";
      };
      monitor-index = mkOption {
        type = types.int;
        default = 0;
        description = "Specific hardware monitor index to use if primary/current is disabled";
      };
    };

    behavior = {
      auto-hide = mkOption {
        type = types.bool;
        default = true;
        description = "Hide the window automatically when it loses input focus";
      };
      always-on-top = mkOption {
        type = types.bool;
        default = true;
        description = "Force the window to remain above all other window actors";
      };
      animation-time = mkOption {
        type = types.float;
        default = 0.2;
        description = "Visual transition duration in seconds for slide events";
      };
      skip-taskbar = mkOption {
        type = types.bool;
        default = true;
        description = "Prevent the dropdown window from appearing in the taskbar or Alt-Tab switcher";
      };
    };
  };

  config = mkIf cfg.enable {
    environment.systemPackages = [ pkgs.gnomeExtensions.quake-terminal ];

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

    systemd.user.services.quake-terminal-setup = {
      description = "Apply Quake Terminal specific configuration";
      wantedBy = [ "graphical-session.target" ];
      partOf = [ "graphical-session.target" ];
      serviceConfig = {
        Type = "oneshot";
        RemainAfterExit = true;
      };
      script = ''
        ${pkgs.dconf}/bin/dconf write /org/gnome/shell/extensions/quake-terminal/terminal-args "${escapeShellArg (serializeLaunchArgs cfg.app.launch-args)}"
      '';
    };
  };
}
