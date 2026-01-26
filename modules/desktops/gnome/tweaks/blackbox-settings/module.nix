{
  options,
  lib,
  pkgs,
  ...
}:

let
  inherit (lib.hm.gvariant)
    mkTuple
    mkUint32
    ;
  cfg = options.zenos.desktop.gnome.tweaks.blackBoxSettings;
in

{
  cfg = {
    enable = lib.mkEnableOption "BlackBox theming for ZenOS.";
  };

  config = lib.mkIf cfg.enable {

    environment.systemPackages = with pkgs; [
      blackbox-terminal
      nerd-fonts.atkynson-mono
    ];

    programs.dconf.settings = {

      # --- BlackBox Terminal ---
      "com/raggesilver/BlackBox" = {
        floating-controls = true;
        font = "Atkynson Mono NF 11";
        show-headerbar = false;
        terminal-padding = mkTuple [
          (mkUint32 5)
          (mkUint32 5)
          (mkUint32 5)
          (mkUint32 5)
        ];
        window-height = mkUint32 744;
        window-width = mkUint32 828;
      };
    };
  };
}
