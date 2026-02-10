{ lib, pkgs, ... }:

let
  inherit (lib) mkOption types;

  # --- USER SUBMODULE SCHEMA ---
  # This defines what options are available INSIDE a user block.
  userSubmodule =
    { name, ... }:
    {
      options = {
        legacy = mkOption {
          description = "Standard Home-Manager/NixOS legacy options";
          type = types.attrsOf types.str; # Placeholder type
          default = { };
        };

        programs = mkOption {
          description = "User-specific programs (Git, Shells, etc)";
          type = types.attrsOf types.package;
          default = { };
        };

        packages = mkOption {
          description = "Set of packages to install for this user";
          type = types.attrsOf types.package;
          default = { };
        };
      };
    };

in
{
  # Define the root 'zenos' namespace
  options.zenos = {

    # --- SYSTEM ---
    system = {
      packages = mkOption {
        type = types.attrsOf types.package;
        description = "System-wide packages (Set-based)";
      };
    };

    # --- DESKTOPS ---
    desktops = {
    };

    # --- ENVIRONMENT ---
    environment = {
      variables = mkOption {
        type = types.attrsOf types.str;
        description = "System-wide environment variables";
      };
    };

    # --- USERS ---
    # The map of users, utilizing the submodule defined above.
    users = mkOption {
      description = "Map of user configurations";
      type = types.attrsOf (types.submodule userSubmodule);
      default = { };
    };
  };
}
