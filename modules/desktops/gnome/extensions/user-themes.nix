{
  pkgs,
  lib,
  config,
  ...
}:

with lib;

let
  cfg = config.zenos.desktops.gnome.extensions.user-theme;

  # Determine the name used in dconf.
  effectiveName =
    if cfg.theme.cssOverride != "" then
      (if cfg.name != "" then cfg.name else "zenos-override")
    else
      cfg.name;

  # Define the generated theme package
  generatedTheme = pkgs.writeTextFile {
    name = "zenos-generated-theme";
    destination = "/share/themes/${effectiveName}/gnome-shell/gnome-shell.css";
    text = ''
      /* Default GNOME Shell Theme */
      @import url("resource:///org/gnome/shell/theme/gnome-shell.css");

      /* Parent/Active Theme Import (if specified) */
      ${optionalString (cfg.theme.activeTheme != "") ''
        @import url("file:///run/current-system/sw/share/themes/${cfg.theme.activeTheme}/gnome-shell/gnome-shell.css");
      ''}

      /* Zenos CSS Overrides */
      ${cfg.theme.cssOverride}
    '';
  };

  meta = {
    description = ''
      Shell theme customization and dynamic theme generation

      This module installs and configures the **User Themes** extension for GNOME.
      It allows loading custom shell themes from the user's home directory and provides
      logic to generate dynamic CSS overrides on top of existing themes.

      **Features:**
      - Enable custom GNOME Shell themes via dconf.
      - Declaratively append CSS to themes using `cssOverride`.
      - Inherit from installed system themes like Orchis or WhiteSur.
    '';
    maintainers = with lib.maintainers; [ doromiert ];
    license = lib.licenses.napl;
    platforms = lib.platforms.zenos;
  };
in
{

  options.zenos.desktops.gnome.extensions.user-theme = {
    _meta = lib.mkOption {
      internal = true;
      readOnly = true;
      default = meta;
      description = "Internal documentation metadata";
    };
    enable = mkEnableOption "User Theme GNOME extension configuration";

    name = mkOption {
      type = types.str;
      default = "";
      description = ''
        Identifier for the shell theme to apply

        The name of the theme directory found in /share/themes. If using 
        `cssOverride`, this becomes the directory name of the generated theme.
      '';
    };

    theme = {
      activeTheme = mkOption {
        type = types.str;
        default = "";
        description = ''
          Base theme for CSS inheritance

          The name of an installed theme (e.g., 'Orchis-Dark') to use as a 
          parent. This theme must be present in the system packages.
        '';
      };

      cssOverride = mkOption {
        type = types.lines;
        default = "";
        description = ''
          Custom CSS rules for GNOME Shell

          Raw CSS content to be appended to the shell's stylesheet. If 
          provided, a synthetic theme package is automatically generated.
        '';
      };
    };
  };

  config = mkIf cfg.enable {
    environment.systemPackages = [
      pkgs.gnomeExtensions.user-themes
    ]
    ++ (optional (cfg.theme.cssOverride != "") generatedTheme);

    programs.dconf.profiles.user.databases = [
      {
        settings = {
          "org/gnome/shell/extensions/user-theme" = {
            name = effectiveName;
          };
        };
      }
    ];
  };
}
