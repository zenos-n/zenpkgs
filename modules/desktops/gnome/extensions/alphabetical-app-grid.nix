{
  config,
  pkgs,
  lib,
  ...
}:

with lib;

let
  cfg = config.zenos.desktops.gnome.extensions.alphabetical-app-grid;

  # --- Helpers for Types ---
  mkBool =
    default: description:
    mkOption {
      type = types.bool;
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

in
{
  meta = {
    description = "Configures the Alphabetical App Grid GNOME extension";
    longDescription = ''
      This module installs and configures the **Alphabetical App Grid** extension for GNOME.
      It enforces alphabetical sorting on the application grid and folders, ensuring a consistent layout.

      **Features:**
      - Automatically sorts folder contents.
      - Configurable positioning for folders vs files.
      - Optional integration with favorite apps (GNOME 40+).
    '';
    maintainers = with lib.maintainers; [ doromiert ];
    license = lib.licenses.napl;
    platforms = lib.platforms.zenos;
  };

  options.zenos.desktops.gnome.extensions.alphabetical-app-grid = {
    enable = mkEnableOption "Alphabetical App Grid GNOME extension configuration";

    sort-folder-contents = mkBool true "Whether the contents of folders should be sorted alphabetically";

    folder-order-position = mkStr "alphabetical" "Where to place folders when ordering the application grid";

    show-favourite-apps = mkBool false "Allows displaying the favourite apps on the app grid (GNOME 40+)";

    logging-enabled = mkBool false "Allow the extension to send messages to the system logs";
  };

  config = mkIf cfg.enable {
    environment.systemPackages = [ pkgs.gnomeExtensions.alphabetical-app-grid ];

    # Standard types (b, i, s, as) are handled directly by dconf module
    programs.dconf.profiles.user.databases = [
      {
        settings = {
          "org/gnome/shell/extensions/alphabetical-app-grid" = {
            sort-folder-contents = cfg.sort-folder-contents;
            folder-order-position = cfg.folder-order-position;
            show-favourite-apps = cfg.show-favourite-apps;
            logging-enabled = cfg.logging-enabled;
          };
        };
      }
    ];
  };
}
