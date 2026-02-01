{
  config,
  pkgs,
  lib,
  ...
}:

with lib;

let
  cfg = config.zenos.desktops.gnome.extensions.burn-my-windows;

  # --- INI/Conf Serialization Logic ---

  # Ensure floats always have a decimal point (0 -> "0.0")
  serializeFloat =
    v:
    let
      s = toString v;
    in
    if builtins.match ".*\\..*" s == null then "${s}.0" else s;

  # Serialize primitives to INI format
  serializeIniValue =
    v:
    if builtins.isBool v then
      (if v then "true" else "false")
    else if builtins.isFloat v then
      serializeFloat v
    else
      toString v;

  # Generate the [section] and key=value pairs
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
    description = "Configures the Burn My Windows GNOME extension";
    longDescription = ''
      This module installs and configures the **Burn My Windows** extension for GNOME.
      It adds retro-style window opening and closing effects, such as fire, tv-glitch, and hexagon.

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

    # --- Schema Options ---

    active-profile = mkOption {
      type = types.str;
      default = "";
      description = "The currently active effect profile (Overridden if 'settings' is used)";
    };

    preview-effect = mkOption {
      type = types.str;
      default = "";
      description = "The effect with this nick will be used for the next window animation";
    };

    test-mode = mkOption {
      type = types.bool;
      default = false;
      description = "If set to true, all animations will show only one still frame";
    };

    show-support-dialog = mkOption {
      type = types.bool;
      default = true;
      description = "If set to false, the ask-for-support dialog will never be shown";
    };

    last-prefs-version = mkOption {
      type = types.int;
      default = 0;
      description = "Used to check whether the extension got updated from the preferences dialog";
    };

    last-extension-version = mkOption {
      type = types.int;
      default = 0;
      description = "Used to check whether the extension got updated from the extension side";
    };

    prefs-open-count = mkOption {
      type = types.int;
      default = 0;
      description = "The number of times the settings dialog was opened";
    };

    # --- Profile Generation Options ---

    settings = mkOption {
      description = "Effect settings for the managed profile. Generates ~/.config/burn-my-windows/profiles/nix-managed.conf";
      type = types.attrsOf (
        types.either types.bool (types.either types.int (types.either types.float types.str))
      );
      default = { };
      example = {
        fire-enable-effect = true;
        doom-enable-effect = true;
        glide-animation-time = 150;
        apparition-twirl-intensity = 0.0;
      };
    };
  };

  config = mkIf cfg.enable {
    environment.systemPackages = [ pkgs.gnomeExtensions.burn-my-windows ];

    # 1. Standard Dconf Settings
    programs.dconf.profiles.user.databases = [
      {
        settings = {
          "org/gnome/shell/extensions/burn-my-windows" = {
            # Automatically point to our managed profile if settings are defined
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

    # 2. Profile File Generation
    # We use a systemd user service to write the configuration file because
    # creating files in ~/.config typically requires home-manager's xdg module,
    # but this approach works in pure NixOS modules too.
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
