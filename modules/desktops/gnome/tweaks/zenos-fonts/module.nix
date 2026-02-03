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
    description = ''
      System typography and ZenOS font overrides

      Sets the system-wide font configuration to use Atkinson Hyperlegible Next
      and the custom ZeroFont. Integrates with `home-manager` to apply these 
      font settings to GTK applications and the GNOME Shell interface.
    '';
    maintainers = with lib.maintainers; [ doromiert ];
    license = lib.licenses.napl;
    platforms = lib.platforms.zenos;
  };

  options.zenos.desktops.gnome.tweaks.zenosFonts = {
    enable = lib.mkOption {
      type = lib.types.bool;
      default = false;
      description = ''
        Enable ZenOS typography stack

        Activates the Atkinson Hyperlegible and ZeroFont overrides for 
        system-wide UI, documents, and terminal monospaced fonts.
      '';
    };
  };

  config = lib.mkIf cfg.enable {
    fonts = {
      packages = with pkgs; [
        atkinson-hyperlegible-next
        noto-fonts
        noto-fonts-color-emoji
        nerd-fonts.atkynson-mono
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

    home-manager.sharedModules = [
      (
        { lib, ... }:
        {
          dconf.settings."org/gnome/desktop/interface" = {
            font-name = lib.mkForce "Atkinson Hyperlegible Next 11";
            document-font-name = "Atkinson Hyperlegible Next 11";
            monospace-font-name = "AtkynsonMono NF 10";
          };
          dconf.settings."org/gnome/desktop/wm/preferences" = {
            titlebar-font = "Atkinson Hyperlegible Next Bold 11";
          };
        }
      )
    ];
  };
}
