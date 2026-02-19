# FILE: zenpkgs/lib/zen-core.nix
{ lib, inputs }:
let
  # --- HELPER: Recursive Directory Walker ---
  walkDir =
    dir: criteriaFn:
    let
      read = if builtins.pathExists dir then builtins.readDir dir else { };
      entries = lib.mapAttrsToList (name: type: { inherit name type; }) read;
      processEntry =
        { name, type }:
        if type == "directory" then
          let
            children = walkDir (dir + "/${name}") criteriaFn;
          in
          map (child: child // { relPath = [ name ] ++ child.relPath; }) children
        else if criteriaFn name type then
          [
            {
              inherit name type;
              relPath = [ ];
              absPath = dir + "/${name}";
            }
          ]
        else
          [ ];
    in
    lib.flatten (map processEntry entries);

  # --- LOGIC 1: Package Importer (Resilient) ---
  mkPackageTree =
    pkgs: root:
    let
      # Load local metadata to inject into lib
      localLib = mkLib (dirOf root + "/lib");

      # Create an extended lib that includes our custom maintainers and licenses
      extendedLib = pkgs.lib.extend (
        self: super: {
          maintainers = super.maintainers // (localLib.maintainers or { });
          licenses = super.licenses // (localLib.licenses or { });
        }
      );

      isPkg = n: t: t == "regular" && lib.hasSuffix ".nix" n && n != "default.nix";
      files = walkDir root isPkg;

      toAttr =
        entry:
        let
          # Use tryEval to prevent crash on broken imports
          importedTry = builtins.tryEval (import entry.absPath);
          imported = if importedTry.success then importedTry.value else { };

          # Pass the extended lib so lib.licenses.napalm works
          value =
            if builtins.isFunction imported then pkgs.callPackage imported { lib = extendedLib; } else imported;
        in
        {
          attrPath = entry.relPath ++ [ (lib.removeSuffix ".nix" entry.name) ];
          inherit value;
        };

      allAttrs = map toAttr files;
    in
    lib.foldl' (
      acc: el:
      let
        existing = lib.attrByPath el.attrPath null acc;
      in
      # Avoid overwriting or merging into derivations (leaf nodes)
      if existing != null && (lib.isDerivation existing || !builtins.isAttrs el.value) then
        acc
      else
        lib.recursiveUpdate acc (lib.setAttrByPath el.attrPath el.value)
    ) { } allAttrs;

  # --- LOGIC 2: Module Tree Scanner ---
  mkModuleTree =
    root:
    let
      dirs =
        if builtins.pathExists root then
          lib.attrNames (lib.filterAttrs (n: v: v == "directory") (builtins.readDir root))
        else
          [ ];
      getModules =
        subdir:
        let
          isMod = n: t: t == "regular" && lib.hasSuffix ".nix" n;
          files = walkDir (root + "/${subdir}") isMod;
        in
        map (e: e.absPath) files;
    in
    lib.genAttrs dirs (d: getModules d);

  mkLib = root: {
    maintainers =
      if builtins.pathExists (root + "/maintainers.nix") then import (root + "/maintainers.nix") else { };
    licenses =
      if builtins.pathExists (root + "/licenses.nix") then import (root + "/licenses.nix") else { };
  };

  importZen =
    path:
    let
      raw = builtins.readFile path;
      wrapped = "{ pkgs, lib, config, options, hostDir, ... }:\n{\n" + raw + "\n}";
      storeFile = builtins.toFile "zen-config.nix" wrapped;
    in
    import storeFile;

  mkHosts =
    {
      root,
      modules ? [ ],
    }:
    let
      isHost = n: t: n == "host.nix" || n == "host.zcfg" || n == "host.nzo";
      files = walkDir root isHost;
      mkSystem =
        entry:
        let
          name = builtins.concatStringsSep "." entry.relPath;
          hostDir = dirOf entry.absPath;
          configLoader =
            if (lib.hasSuffix ".zcfg" entry.name || lib.hasSuffix ".nzo" entry.name) then
              (importZen entry.absPath)
            else
              (import entry.absPath);
        in
        {
          name = name;
          value = inputs.nixpkgs.lib.nixosSystem {
            system = "x86_64-linux";
            specialArgs = { inherit inputs; };
            modules =
              modules
              ++ [
                (
                  args@{
                    pkgs,
                    lib,
                    config,
                    options,
                    ...
                  }:
                  {
                    zenos =
                      if lib.isFunction configLoader then configLoader (args // { inherit hostDir; }) else configLoader;
                  }
                )
              ]
              ++ (
                if builtins.pathExists (hostDir + "/hardware-configuration.nix") then
                  [ (hostDir + "/hardware-configuration.nix") ]
                else
                  [ ]
              );
          };
        };
    in
    builtins.listToAttrs (map mkSystem files);

in
{
  inherit
    mkPackageTree
    mkHosts
    mkLib
    mkModuleTree
    ;
}
