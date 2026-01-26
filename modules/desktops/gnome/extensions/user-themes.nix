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
  # If overriding, use the generated name (defaulting to "zenos-override" if name is unset).
  # If not overriding, use the provided name directly.
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

in
{
  options.zenos.desktops.gnome.extensions.user-theme = {
    enable = mkEnableOption "User Theme GNOME extension configuration";

    name = mkOption {
      type = types.str;
      default = "";
      description = "The name of the theme to apply. If using cssOverride, this becomes the name of the generated theme.";
    };

    theme = mkOption {
      description = "Theme generation settings.";
      default = { };
      type = types.submodule {
        options = {
          activeTheme = mkOption {
            type = types.str;
            default = "";
            description = "The name of the base theme to inherit from (e.g., 'Orchis-Dark'). Must be installed in systemPackages.";
          };

          cssOverride = mkOption {
            type = types.lines;
            default = "";
            description = "CSS to append to the generated theme. If empty, no theme is generated.";
          };
        };
      };
    };
  };

  config = mkIf cfg.enable {
    # Ensure the extension is installed
    environment.systemPackages = [
      pkgs.gnomeExtensions.user-themes
    ]
    # Add the generated theme to packages if we are overriding
    ++ (optional (cfg.theme.cssOverride != "") generatedTheme);

    # Apply dconf settings
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
