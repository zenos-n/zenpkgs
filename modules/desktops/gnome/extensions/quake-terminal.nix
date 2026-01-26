{
  config,
  pkgs,
  lib,
  ...
}:

with lib;

let
  cfg = config.zenos.desktops.gnome.extensions.quake-terminal;

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
  options.zenos.desktops.gnome.extensions.quake-terminal = {
    enable = mkEnableOption "Quake Terminal GNOME extension configuration";

    terminal-id = mkStr "org.gnome.Terminal.desktop" "The application path used as a reference.";
    terminal-shortcut = mkOptionStrList [
      "<Super>Return"
    ] "Shortcut to activate the terminal application.";

    vertical-size = mkInt 50 "Terminal Vertical Size (percentage).";
    horizontal-size = mkInt 100 "Terminal Horizontal Size (percentage).";
    horizontal-alignment = mkInt 2 "Terminal Horizontal Alignment (0-2).";

    render-on-current-monitor = mkBool false "Show on the current Display.";
    render-on-primary-monitor = mkBool false "Show on the primary Display.";
    monitor-screen = mkInt 0 "Specify the display where the terminal should be rendered.";

    auto-hide-window = mkBool true "Hide Terminal window when it loses focus.";
    always-on-top = mkBool false "Terminal window will appear on top of all other windows.";
    animation-time = mkInt 250 "Duration of the dropdown animation in milliseconds.";
    skip-taskbar = mkBool true "Hide terminal window in overview mode or Alt+Tab.";

    launch-args-map = mkOption {
      type = types.attrsOf types.str;
      default = { };
      description = "Dictionary mapping application IDs to their terminal launch arguments (a{ss}).";
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
            terminal-id = cfg.terminal-id;
            terminal-shortcut = cfg.terminal-shortcut;
            vertical-size = cfg.vertical-size;
            horizontal-size = cfg.horizontal-size;
            horizontal-alignment = cfg.horizontal-alignment;
            render-on-current-monitor = cfg.render-on-current-monitor;
            render-on-primary-monitor = cfg.render-on-primary-monitor;
            monitor-screen = cfg.monitor-screen;
            auto-hide-window = cfg.auto-hide-window;
            always-on-top = cfg.always-on-top;
            animation-time = cfg.animation-time;
            skip-taskbar = cfg.skip-taskbar;
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
        ${pkgs.dconf}/bin/dconf write /org/gnome/shell/extensions/quake-terminal/launch-args-map ${escapeShellArg (serializeLaunchArgs cfg.launch-args-map)}
      '';
    };
  };
}
