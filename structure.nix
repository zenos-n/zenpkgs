# LOCATION: structure.nix
# DESCRIPTION: The ZenOS Blueprint. Defines system.programs, system.packages, and the Legacy logic.

{
  config,
  lib,
  pkgs,
  ...
}:
with lib;
let
  # --- Logic 1: Program Flattener ---
  # Resolves system.programs.foo -> pkgs.foo (Zen Priority via Overlay)
  flattenPrograms =
    cfg:
    concatMap (
      name:
      let
        val = cfg.${name};
      in
      if (val ? enable && val.enable) then
        if val ? package && val.package != null then
          [ val.package ]
        else
          let
            found = attrByPath [ name ] null pkgs;
          in
          if found != null then
            [ found ]
          else
            [ (warn "ZenOS: Program '${name}' enabled but not found in pkgs." null) ]
      else
        [ ]
    ) (attrNames cfg);

  # --- Logic 2: Mirror Flattener ---
  # Recursively maps system.packages.a.b -> pkgs.a.b
  flattenMirror =
    path: attrs:
    concatMap (
      name:
      let
        val = attrs.${name};
        newPath = path ++ [ name ];
      in
      if (val ? enable) then
        if val.enable then
          if val ? package && val.package != null then
            [ val.package ]
          else
            let
              found = attrByPath newPath null pkgs;
            in
            if found != null then
              [ found ]
            else
              [ (warn "ZenOS: Package '${concatStringsSep "." newPath}' enabled but not found in pkgs." null) ]
        else
          [ ]
      else if (builtins.isAttrs val) then
        flattenMirror newPath val
      else
        [ ]
    ) (attrNames attrs);

in
{
  options = {
    # --- System Level ---

    # 1. Programs (Smart Modules)
    system.programs = mkOption {
      description = "ZenOS Programs (Auto-resolves to pkgs.<name> unless overridden)";
      default = { };
      type = types.submodule { freeformType = types.attrsOf types.anything; };
    };

    # 2. Packages (Mirror)
    system.packages = mkOption {
      description = "ZenOS Package Mirror (Maps directly to pkgs structure)";
      default = { };
      type = types.submodule { freeformType = types.attrsOf types.anything; };
    };

    # 3. Services (Mirror)
    system.services = mkOption {
      description = "ZenOS System Services (Mirrors 'services' namespace)";
      default = { };
      type = types.submodule { freeformType = types.attrsOf types.anything; };
    };

    # --- User Level ---
    users.users = mkOption {
      type = types.attrsOf (
        types.submodule (
          { name, config, ... }:
          {
            options.programs = mkOption {
              description = "User Programs";
              default = { };
              type = types.submodule { freeformType = types.attrsOf types.anything; };
            };

            options.software = mkOption {
              description = "User Package Mirror";
              default = { };
              type = types.submodule { freeformType = types.attrsOf types.anything; };
            };

            config.packages = flattenPrograms config.programs ++ flattenMirror [ ] config.software;
          }
        )
      );
    };

    # --- Legacy Dump ---
    legacy = mkOption {
      description = "Dumping ground for legacy configuration maps";
      default = { };
      type = types.submodule {
        freeformType = types.attrsOf types.anything;
        options = { };
      };
    };
  };

  config = {
    # Map system.services -> services
    services = config.system.services;

    # Map packages
    environment.systemPackages =
      flattenPrograms config.system.programs ++ flattenMirror [ ] config.system.packages;
  };
}
