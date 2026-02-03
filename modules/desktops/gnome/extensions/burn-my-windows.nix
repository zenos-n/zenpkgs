{
  config,
  pkgs,
  lib,
  ...
}:

with lib;

let
  cfg = config.zenos.desktops.gnome.extensions.burn-my-windows;

  serializeFloat =
    v:
    let
      s = toString v;
    in
    if builtins.match ".*\\..*" s == null then "${s}.0" else s;

  serializeIniValue =
    v:
    if builtins.isBool v then
      (if v then "true" else "false")
    else if builtins.isFloat v then
      serializeFloat v
    else
      toString v;

  generateProfileContent =
    settings:
    let
      lines = mapAttrsToList (k: v: "${k}=${serializeIniValue v}") settings;
    in
    ''
      [burn-my-windows-profile]
      ${concatStringsSep "\n" lines}
    '';

in
{
  meta = {
    description = ''
      Retro window opening and closing animations for GNOME

      This module installs and configures the **Burn My Windows** extension for GNOME.
      It adds retro-style window opening and closing effects, such as fire, 
      tv-glitch, and hexagon.

      **Features:**
      - Configure active effects and profiles.
      - Generate custom Nix-managed effect profiles.
    '';
    maintainers = with lib.maintainers; [ doromiert ];
    license = lib.licenses.napl;
    platforms = lib.platforms.zenos;
  };

  options.zenos.desktops.gnome.extensions.burn-my-windows = {
    enable = mkEnableOption "Burn My Windows GNOME extension configuration";

    active-profile = mkOption {
      type = types.str;
      default = "";
      description = ''
        Currently selected animation profile

        The filename of the active effect profile (e.g., 'fire.conf'). 
        Overridden if 'settings' attribute is defined.
      '';
    };

    preview-effect = mkOption {
      type = types.str;
      default = "";
      description = ''
        Nickname of the effect for preview

        The effect with this nick will be used for the next window animation.
      '';
    };

    test-mode = mkOption {
      type = types.bool;
      default = false;
      description = ''
        Enable single-frame animation testing

        If set to true, all animations will show only one still frame.
      '';
    };

    show-support-dialog = mkOption {
      type = types.bool;
      default = true;
      description = ''
        Display the ask-for-support dialog

        Whether to allow the extension to show its periodic donation dialog.
      '';
    };

    last-prefs-version = mkOption {
      type = types.int;
      default = 0;
      description = ''
        Internal version of last used preferences

        Tracks updates between the preferences dialog and the extension core.
      '';
    };

    last-extension-version = mkOption {
      type = types.int;
      default = 0;
      description = ''
        Internal version of the extension core

        Tracks the version of the extension code for compatibility checks.
      '';
    };

    prefs-open-count = mkOption {
      type = types.int;
      default = 0;
      description = ''
        Preferences dialog interaction counter

        Tracks how many times the settings interface has been opened.
      '';
    };

    settings = mkOption {
      description = ''
        Declarative effect parameters for the managed profile

        Generates a custom INI profile at `~/.config/burn-my-windows/profiles/nix-managed.conf`.
      '';
      type = types.attrsOf (
        types.either types.bool (types.either types.int (types.either types.float types.str))
      );
      default = { };
      example = {
        fire-enable-effect = true;
        doom-enable-effect = true;
        glide-animation-time = 150;
      };
    };
  };

  config = mkIf cfg.enable {
    environment.systemPackages = [ pkgs.gnomeExtensions.burn-my-windows ];

    programs.dconf.profiles.user.databases = [
      {
        settings = {
          "org/gnome/shell/extensions/burn-my-windows" = {
            active-profile = if cfg.settings != { } then "nix-managed.conf" else cfg.active-profile;
            preview-effect = cfg.preview-effect;
            test-mode = cfg.test-mode;
            show-support-dialog = cfg.show-support-dialog;
            last-prefs-version = cfg.last-prefs-version;
            last-extension-version = cfg.last-extension-version;
            prefs-open-count = cfg.prefs-open-count;
          };
        };
      }
    ];

    systemd.user.services.burn-my-windows-profile = mkIf (cfg.settings != { }) {
      description = "Generate Burn My Windows Nix-managed profile";
      wantedBy = [ "graphical-session.target" ];
      partOf = [ "graphical-session.target" ];
      serviceConfig = {
        Type = "oneshot";
        RemainAfterExit = true;
      };
      script = ''
        mkdir -p %h/.config/burn-my-windows/profiles
        cat > %h/.config/burn-my-windows/profiles/nix-managed.conf <<EOF
        ${generateProfileContent cfg.settings}
        EOF
      '';
    };
  };
}
