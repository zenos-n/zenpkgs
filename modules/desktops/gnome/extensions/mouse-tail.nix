{
  config,
  pkgs,
  lib,
  ...
}:

with lib;

let
  cfg = config.zenos.desktops.gnome.extensions.mouse-tail;

  hexToDecMap = {
    "0" = 0;
    "1" = 1;
    "2" = 2;
    "3" = 3;
    "4" = 4;
    "5" = 5;
    "6" = 6;
    "7" = 7;
    "8" = 8;
    "9" = 9;
    "a" = 10;
    "b" = 11;
    "c" = 12;
    "d" = 13;
    "e" = 14;
    "f" = 15;
    "A" = 10;
    "B" = 11;
    "C" = 12;
    "D" = 13;
    "E" = 14;
    "F" = 15;
  };

  hexCharToInt = c: if builtins.hasAttr c hexToDecMap then hexToDecMap.${c} else 0;
  parseHexByte =
    s: (hexCharToInt (builtins.substring 0 1 s) * 16) + (hexCharToInt (builtins.substring 1 1 s));

  hexToRgbList =
    val:
    if builtins.isString val && (builtins.substring 0 1 val == "#") then
      let
        hex = lib.removePrefix "#" val;
        r = (parseHexByte (substring 0 2 hex)) / 255.0;
        g = (parseHexByte (substring 2 2 hex)) / 255.0;
        b = (parseHexByte (substring 4 2 hex)) / 255.0;
      in
      [
        r
        g
        b
      ]
    else
      val;

in
{
  meta = {
    description = ''
      Visual trail effect for the GNOME mouse cursor

      This module installs and configures the **Mouse Tail** extension for GNOME.
      It adds a customizable trail effect to the mouse cursor, which can be useful for
      presentations or accessibility to locate the cursor easily.

      **Features:**
      - Customizable fade duration and line width.
      - RGB color and transparency support.
      - Performance tuning via rendering modes.
    '';
    maintainers = with lib.maintainers; [ doromiert ];
    license = lib.licenses.napl;
    platforms = lib.platforms.zenos;
  };

  options.zenos.desktops.gnome.extensions.mouse-tail = {
    enable = mkEnableOption "Mouse Tail GNOME extension configuration";

    fade-duration = mkOption {
      type = types.int;
      default = 200;
      description = ''
        Trail persistence duration

        Specifies how long the trail segments take to fade out in milliseconds.
      '';
    };

    line-width = mkOption {
      type = types.int;
      default = 8;
      description = ''
        Trail line thickness

        Pixel width for the rendered mouse trail segments.
      '';
    };

    color = mkOption {
      type = types.either (types.listOf types.float) types.str;
      default = [
        1.0
        1.0
        1.0
      ];
      description = ''
        Visual color of the trail

        Accepts a list of RGB floats ([1.0 0.0 0.0]) or a Hex string ('#FF0000').
      '';
    };

    alpha = mkOption {
      type = types.float;
      default = 0.5;
      description = ''
        Trail alpha transparency

        Transparency level of the mouse trail, where 0.0 is invisible 
        and 1.0 is fully opaque.
      '';
    };

    render-mode = mkOption {
      type = types.enum [
        "precise"
        "balance"
        "fast"
      ];
      default = "precise";
      description = ''
        Graphic rendering strategy

        Optimizes the trail rendering for either visual precision 
        or performance.
      '';
    };
  };

  config = mkIf cfg.enable {
    environment.systemPackages = [ pkgs.gnomeExtensions.mouse-tail ];
    programs.dconf.profiles.user.databases = [
      {
        settings."org/gnome/shell/extensions/mouse-tail" = {
          fade-duration = cfg.fade-duration;
          line-width = cfg.line-width;
          color = hexToRgbList cfg.color;
          alpha = cfg.alpha;
          render-mode = cfg.render-mode;
        };
      }
    ];
  };
}
