{ lib, inputs }:
let
  # Recursive Directory Walker
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

  # Package Tree Generator
  # Maps a directory (e.g., ./pkgs) to an attribute set of callPackage calls
  mkPackageTree =
    pkgs: root:
    let
      isPkg = n: t: n == "default.nix";
      files = walkDir root isPkg;
      toAttr = entry: {
        # Use the parent directory name as the attribute name
        name = lib.last entry.relPath;
        value = pkgs.callPackage entry.absPath { };
      };
    in
    builtins.listToAttrs (map toAttr files);

  # ZCFG / Flat File Importer (for host configs)
  importZcfg =
    path:
    {
      pkgs,
      lib,
      config,
      ...
    }@args:
    let
      hostDir = dirOf path;
      content = builtins.readFile path;
      wrapped = "{ " + content + " }";
      tempFile = builtins.toFile "zen-config-wrapped.nix" wrapped;

      scope = args // {
        inherit hostDir;
        importZen = p: importZcfg p args;
        conf = f: importZcfg (hostDir + "/config/${f}") args;
      };

      raw = builtins.scopedImport scope tempFile;
    in
    if builtins.isFunction raw then raw args else raw;

  # Host Generator
  mkHosts =
    {
      root,
      modules ? [ ],
      specialArgs ? { },
    }:
    let
      isHost = n: t: n == "host.nix" || n == "host.zcfg" || n == "host.nzo";
      files = walkDir root isHost;

      mkSystem =
        entry:
        let
          name = builtins.concatStringsSep "." entry.relPath;

          hostModule =
            args:
            let
              raw =
                if (lib.hasSuffix ".zcfg" entry.name || lib.hasSuffix ".nzo" entry.name) then
                  importZcfg entry.absPath args
                else
                  import entry.absPath args;

              legacyConfig = raw.legacy or { };
              zenosConfig = builtins.removeAttrs raw [ "legacy" ];
            in
            {
              config = lib.mkMerge [
                legacyConfig
                { zenos = zenosConfig; }
              ];
            };
        in
        {
          inherit name;
          value = lib.nixosSystem {
            system = "x86_64-linux";
            specialArgs = specialArgs // {
              inherit inputs;
            };
            modules = modules ++ [ hostModule ];
          };
        };
    in
    builtins.listToAttrs (map mkSystem files);

in
{
  inherit mkHosts walkDir mkPackageTree;
}
