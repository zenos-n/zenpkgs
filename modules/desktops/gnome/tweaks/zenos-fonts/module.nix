# @file: coremodules/desktop/gnome/tweaks/zenos-fonts.nix
# @brief: ZenOS custom font configuration.
# @context: desktop tweaks
{
  config,
  lib,
  pkgs,
  ...
}:

let
  cfg = config.zenos.desktops.gnome.tweaks.zenosFonts;
in
{
  meta = {
    description = "Configures system typography and ZenOS font overrides";
    longDescription = ''
      Sets the system-wide font configuration to use Atkinson Hyperlegible Next
      and the custom ZeroFont.

      It integrates with `home-manager` to apply these font settings to
      GTK applications and the GNOME Shell interface.
    '';
    maintainers = with lib.maintainers; [ doromiert ];
    license = lib.licenses.napl;
    platforms = lib.platforms.zenos;
  };

  options.zenos.desktops.gnome.tweaks.zenosFonts = {
    enable = lib.mkEnableOption "ZenOS Fonts for GNOME" // {
      description = "Enables the ZenOS typography stack (Atkinson Hyperlegible/ZeroFont).";
    };
  };

  config = lib.mkIf cfg.enable {
    # 1. System Fonts
    fonts = {
      packages = with pkgs; [
        atkinson-hyperlegible-next
        noto-fonts
        noto-fonts-color-emoji
        nerd-fonts.atkynson-mono
        # Use existing package from the system set
        zenos.theming.fonts.zero-font
      ];

      fontDir.enable = true;

      fontconfig = {
        defaultFonts = {
          monospace = [ "AtkynsonMono NF" ];
          sansSerif = [
            "Atkinson Hyperlegible Next"
            "Symbols Nerd Font"
          ];
          serif = [ "Noto Serif" ];
        };
      };
    };

    # 2. Home Manager Configuration (DConf & GTK)
    home-manager.sharedModules = [
      (
        { pkgs, lib, ... }:
        {
          dconf.settings."org/gnome/desktop/interface" = {
            font-name = lib.mkForce "Atkinson Hyperlegible Next 11";
            document-font-name = "Atkinson Hyperlegible Next 11";
            monospace-font-name = "AtkynsonMono NF 11";
          };

          gtk.font = {
            name = "Atkinson Hyperlegible Next 11";
            package = pkgs.atkinson-hyperlegible-next;
          };
        }
      )
    ];
  };
}
