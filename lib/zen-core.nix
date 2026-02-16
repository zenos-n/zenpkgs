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
      isPkg = n: t: t == "regular" && lib.hasSuffix ".nix" n && n != "default.nix";
      files = walkDir root isPkg;
      toAttr =
        entry:
        let
          imported = import entry.absPath;
          # FIX: Only use callPackage if the file returns a function.
          # This allows 'utils.nix' or library files to be plain sets.
          value = if builtins.isFunction imported then pkgs.callPackage imported { } else imported;
        in
        {
          attrPath = entry.relPath ++ [ (lib.removeSuffix ".nix" entry.name) ];
          inherit value;
        };
    in
    lib.foldl' (acc: el: lib.setAttrByPath el.attrPath el.value acc) { } (map toAttr files);

  # --- LOGIC 2: Module Tree Scanner (Magic Discovery) ---
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
      wrapped = "{ hostDir, ... }:\n{\n" + raw + "\n}";
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
            modules = modules ++ [
              (
                { ... }:
                {
                  zenos = if lib.isFunction configLoader then configLoader { inherit hostDir; } else configLoader;
                }
              )
            ];
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
