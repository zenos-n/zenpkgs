{
  inputs,
  self,
  system,
}:
let
  # 1. Prepare Pkgs with Overlays
  pkgs = import inputs.nixpkgs {
    inherit system;
    overlays = [ self.overlays.default ];
    config = {
      allowUnfree = true;
      # CRITICAL FIX: Disable aliases to prevent iterating over renamed/broken packages
      allowAliases = false;
    };
  };

  # 2. Evaluate Full NixOS System
  eval = inputs.nixpkgs.lib.nixosSystem {
    inherit system;

    modules = [
      self.nixosModules.structure
      "${inputs.nixpkgs}/nixos/modules/misc/nixpkgs/read-only.nix"
      {
        nixpkgs.pkgs = pkgs;
        fileSystems."/".device = "/dev/null";
        boot.loader.systemd-boot.enable = true;
        system.stateVersion = "25.11";
        _module.check = false;
      }
    ];
  };

  lib = pkgs.lib;

  # 3. Recursive Package Walker
  showPackages =
    strict: maxDepth: path: v:
    let
      pathStr = lib.concatStringsSep "." path;
      name = lib.last path;

      # Safely check for derivation
      triedDrv = builtins.tryEval (lib.isDerivation v);
      isDrv = triedDrv.success && triedDrv.value;

      # Standard Recursion Logic
      # 1. Must be an attrset
      # 2. Must NOT be a derivation
      # 3. If STRICT is enabled (for nixpkgs), it MUST have recurseForDerivations = true
      checkRecurse =
        if strict then
          let
            res = builtins.tryEval (v.recurseForDerivations or false);
          in
          res.success && res.value
        else
          true;

      isNested = builtins.isAttrs v && !isDrv && checkRecurse;

      depth = builtins.length path;
      isRepeating = name != "<name>" && lib.count (x: x == name) path > 1;
    in
    if isRepeating || depth > maxDepth then
      {
        meta = {
          type = if isDrv then "package" else "category";
          description = if isDrv then (v.meta.description or "") else "Recursion limit reached";
        };
        sub = { };
      }
    else
      {
        meta = {
          type = if isDrv then "package" else "category";
          description = if isDrv then (v.meta.description or "") else "";
        };
        sub =
          if isNested then
            let
              keys = builtins.attrNames v;

              # Filter keys
              safeKeys = builtins.filter (
                n:
                !lib.hasPrefix "_" n
                && !(builtins.elem n [
                  "pkgs"
                  "lib"
                  "out"
                  "dev"
                  "bin"
                  "man"
                  "stdenv"
                  "override"
                  "overrideDerivation"
                  "recurseForDerivations"
                  "nixosTests"
                  "tests"
                  "debugPackages"
                ])
              ) keys;

              process =
                n:
                let
                  currentPath = pathStr + "." + n;
                in
                # tryEval wrap for access safety
                let
                  attempt = builtins.tryEval v.${n};
                in
                if attempt.success then
                  let
                    # Recurse with same strictness setting
                    res = showPackages strict maxDepth (path ++ [ n ]) attempt.value;
                  in
                  {
                    name = n;
                    value = res;
                  }
                else
                  builtins.trace "[ERROR] Failed to eval: ${currentPath}" null;

              results = map process safeKeys;
            in
            builtins.listToAttrs (builtins.filter (x: x != null) results)
          else
            { };
      };

  # 4. Robust Option Walker
  showOptions =
    path: v:
    let
      pathStr = lib.concatStringsSep "." path;
      name = lib.last path;
      isRepeating = name != "<name>" && lib.count (x: x == name) path > 1;
    in
    # Keep option walking quiet unless needed
    # builtins.trace " > Walking: ${pathStr}"
    (
      if isRepeating then
        {
          meta = {
            type = "Recursion Blocked";
            description = "Potential infinite loop detected";
          };
        }
      else
        let
          isOption = v: builtins.isAttrs v && (v._type or "") == "option";
          isContainer = v: builtins.isAttrs v && (v._type or "") == "_container";

          getMeta =
            v:
            if isOption v then
              {
                description = v.description or "";
                type = if name == "legacy" then "passthrough" else (v.type.description or v.type.name or "option");
              }
            else if isContainer v then
              {
                type = "instance";
                description = "Dynamic submodule entry";
              }
            else
              {
                type = "category";
              };

          getRawChildren =
            v:
            if
              path == [
                "zenos"
                "legacy"
              ]
            then
              let
                pruneList = [
                  "zenos"
                  "users"
                  "nixpkgs"
                  "documentation"
                  "hardware"
                  "systemd"
                  "environment"
                  "networking"
                  "config"
                  "options"
                  "_module"
                  "_args"
                  "specialArgs"
                ];
              in
              builtins.removeAttrs eval.options pruneList
            else if
              (builtins.length path == 4) && (name == "legacy") && (builtins.elemAt path 1 == "users")
            then
              eval.options.users.users.type.nestedTypes.elemType.getSubOptions [ ]
            else if isOption v then
              let
                t = v.type;
                elem = t.nestedTypes.elemType or null;
                elemSub = if elem != null then (elem.getSubOptions or null) else null;
                directSub = t.getSubOptions or null;
              in
              if elemSub != null then
                {
                  "<name>" = {
                    _type = "_container";
                    content = elemSub [ ];
                  };
                }
              else if directSub != null then
                directSub [ ]
              else
                null
            else if isContainer v then
              v.content
            else if builtins.isAttrs v then
              v
            else
              null;
        in
        let
          rawChildren = getRawChildren v;
          validChildren =
            if rawChildren != null then
              builtins.removeAttrs rawChildren (
                [
                  "_module"
                  "_args"
                  "freeformType"
                  "specialisation"
                  "containers"
                  "vmVariant"
                ]
                # Fix: Skip zenos.sandbox
                ++ (if path == [ "zenos" ] then [ "sandbox" ] else [ ])
              )
            else
              { };

          hasChildren = validChildren != { };
        in
        {
          meta = getMeta v;
        }
        // (
          if hasChildren then
            { sub = lib.mapAttrs (n: child: showOptions (path ++ [ n ]) child) validChildren; }
          else
            { }
        )
    );

  # 5. Final Stats
  logStats = tree: tree; # Disabled stats logging to reduce noise while debugging

  # 6. Generate Trees
  optionRoot = showOptions [ "zenos" ] eval.options.zenos;
in
{
  inherit pkgs;

  tree = {
    pkgs =
      let
        zenoPkgs = if pkgs ? zenos then pkgs.zenos else { };
        # Custom Pkgs: strict = false (Always show user's packages)
        customPkgs = lib.mapAttrs (n: v: showPackages false 10 [ n ] v) zenoPkgs;

        legacySet = {
          legacy = {
            meta = {
              type = "category";
              description = "Standard Nixpkgs Packages";
            };
            sub =
              let
                names = builtins.attrNames pkgs;
                problematic = [
                  "nixosTests"
                  "tests"
                  "pkgs"
                  "lib"
                  "modules"
                  "haskellPackages"
                  "python3Packages"
                  "perlPackages"
                  "nodePackages"
                  "__info"
                  "__attrs"
                  "legacyPackages"
                  "nixpkgs"
                  "stdenv"
                  "system"
                  "buildPackages"
                  "targetPackages"
                  "releaseTools"
                  "testers"
                  "debugPackages"
                  "nixos"
                  "src"
                  "source"
                  "recurseForDerivations"
                  "dwarfs"
                  "gimpPlugins"
                  "__splicedPackages"
                  "haskell"
                  "beam"
                  "agda"
                ];

                filteredNames = builtins.filter (n: !(builtins.elem n problematic) && !(lib.hasPrefix "_" n)) names;

                process =
                  name:
                  # Trace kept minimal for speed, re-enable if crashes persist
                  let
                    res = builtins.tryEval pkgs.${name};
                  in
                  if res.success && res.value != null then
                    # Legacy Pkgs: strict = true (Only recurse if intended)
                    {
                      name = name;
                      value = showPackages true 3 [ name ] res.value;
                    }
                  else
                    null;

                results = map process filteredNames;
              in
              builtins.listToAttrs (builtins.filter (x: x != null) results);
          };
        };
      in
      customPkgs // legacySet;

    options = (logStats optionRoot).sub or optionRoot;
    maintainers = if builtins.pathExists ./maintainers.nix then import ./maintainers.nix else { };
  };
}
