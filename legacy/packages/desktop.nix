{
  config,
  lib,
  pkgs,
  ...
}:

let
  cfg = config.system.programs;
in
{
  meta = {
    description = "Optimized configurations for core system programs and desktops";
    longDescription = ''
      This module serves as the primary bridge between high-level system requirements 
      and NixOS-specific configurations for application suites, desktops, and themes.

      ### Features
      - **Steam Integration**: Automatically configures the Steam gaming suite with 
        `gamemode` enabled and enforced performance settings.
      - **Desktop Environments**: Provides managed configurations for GNOME (Shell, 
        Nautilus, Console) and Hyprland.
      - **Theming & Assets**: Integrated support for ZenOS-approved fonts (Atkinson, 
        Noto) and icon sets (Papirus, Adwaita).
      - **Autogen System**: A flexible attribute-based configurator to enable utility 
        packages via the `pkgs.zenos` namespace.

      This module ensures that all graphical components align with the ZenOS 
      visual identity and performance profiles.
    '';
    maintainers = with lib.maintainers; [ doromiert ];
    license = lib.licenses.napl;
    platforms = lib.platforms.zenos;
  };

  options.system.programs = {
    steam.enable = lib.mkOption {
      type = lib.types.bool;
      default = false;
      description = "Enable Steam gaming suite with ZenOS performance optimizations";
      example = true;
    };

    desktop = {
      gnome.enable = lib.mkOption {
        type = lib.types.bool;
        default = false;
        description = "Enable optimized GNOME desktop environment";
      };
      hyprland.enable = lib.mkOption {
        type = lib.types.bool;
        default = false;
        description = "Enable Hyprland tiling window manager core";
      };
    };

    autogen = lib.mkOption {
      description = "The Universal App Configurator for automated program enablement";
      default = { };
      example = {
        python3.enable = true;
      };
      type = lib.types.attrsOf (
        lib.types.submodule {
          options = {
            enable = lib.mkOption {
              type = lib.types.bool;
              default = false;
              description = "Enable the parent program in the system environment";
            };
          };
        }
      );
    };
  };

  config = lib.mkMerge [
    # Steam Logic
    (lib.mkIf cfg.steam.enable {
      programs.steam.enable = lib.mkForce true;
      programs.gamemode.enable = lib.mkForce true;

      warnings =
        lib.optional
          (
            config.legacy ? programs && config.legacy.programs ? steam && config.legacy.programs.steam ? enable
          )
          "ZenOS Warning: 'legacy.programs.steam' detected. The 'system.programs.steam' module is currently enforcing optimized settings.";
    })

    # Desktop Logic - Using the zenos namespace logic
    (lib.mkIf cfg.desktop.gnome.enable {
      services.xserver.desktopManager.gnome.enable = true;
      environment.systemPackages = [
        pkgs.zenos.desktops.gnome.base.gnome-shell
        pkgs.zenos.desktops.gnome.base.nautilus
        pkgs.zenos.desktops.gnome.base.gnome-console
      ];
    })

    (lib.mkIf cfg.desktop.hyprland.enable {
      programs.hyprland.enable = true;
      programs.hyprland.package = pkgs.zenos.desktops.hyprland.core;
    })

    # Autogen Logic
    (lib.mkIf (cfg.autogen.python3.enable or false) {
      environment.systemPackages = [ pkgs.python3 ];
    })

    # Logic for enabling core ZenOS themes if any program is enabled
    (lib.mkIf (cfg.steam.enable || cfg.desktop.gnome.enable || cfg.desktop.hyprland.enable) {
      fonts.packages = [
        pkgs.zenos.theming.fonts.atkinson-hyperlegible
        pkgs.zenos.theming.fonts.noto
      ];
      environment.systemPackages = [
        pkgs.zenos.theming.icons.papirus
      ];
    })
  ];
}
