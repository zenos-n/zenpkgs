{
  nixpkgs,
  home-manager,
  bundle,
}:
let
  pkgs = import nixpkgs { system = "x86_64-linux"; };
  inherit (pkgs) lib;
  search = import ../../lib/search-index.nix { inherit lib; };
  runtime = import ../../lib/zstr-runtime.nix { inherit lib; };
  packageTree = {
    first.same = pkgs.hello;
    second.same = pkgs.hello;
    legacy = {
      hello = pkgs.hello;
      group.hello = pkgs.hello;
      group.deeper.notEvaluated = throw "package depth limit was ignored";
      pkgsCross = throw "recursive package universe was forced";
      pkgsLinux = throw "recursive package universe was forced";
      callPackage = _: throw "helper was called";
      broken = throw "unavailable package";
    };
  };
  evaluate =
    bundle:
    import (nixpkgs + "/nixos/lib/eval-config.nix") {
      system = "x86_64-linux";
      modules = [
        (home-manager + "/nixos")
        (runtime.moduleFromBundle { inherit bundle packageTree; })
        ({ lib, ... }: {
          options.future.marker = lib.mkOption {
            type = lib.types.str;
            default = "new upstream option";
          };
          config.home-manager.sharedModules = [
            ({ lib, ... }: {
              options.zenos.private = lib.mkOption {
                type = lib.types.bool;
                default = false;
              };
            })
          ];
        })
      ];
    };
  index = search.mkIndex {
    evaluated = evaluate bundle;
    inherit bundle packageTree;
  };
  absentBundle = bundle // {
    structure = {
      present = false;
      mounts = [ ];
      nodes = [ ];
    };
  };
  absent = search.mkIndex {
    evaluated = evaluate absentBundle;
    bundle = absentBundle;
    packageTree = throw "unmounted packages forced";
  };
  demo = index.options.system.sub.programs.sub.demo;
  user = index.options.users.sub."<name>";
  unitTree =
    (lib.evalModules {
      modules = [
        ({ lib, ... }: {
          options = {
            scalar = lib.mkOption {
              type = lib.types.bool;
              default = false;
            };
            required = lib.mkOption { type = lib.types.str; };
            documented = lib.mkOption {
              type = lib.types.str;
              default = throw "must use defaultText";
              defaultText = lib.literalExpression "config.other";
            };
            broken = lib.mkOption {
              type = lib.types.str;
              default = throw "unavailable default";
            };
            brokenText = lib.mkOption {
              type = lib.types.str;
              defaultText = throw "unavailable documentation";
            };
            complex = lib.mkOption {
              type = lib.types.attrs;
              default = {
                value = throw "complex default forced";
              };
            };
            nullable = lib.mkOption {
              type = lib.types.nullOr lib.types.str;
              default = null;
            };
            list = lib.mkOption {
              type = lib.types.listOf (lib.types.submodule { options.enabled = lib.mkEnableOption "entry"; });
            };
            lazy = lib.mkOption {
              type = lib.types.lazyAttrsOf (
                lib.types.submodule { options.enabled = lib.mkEnableOption "entry"; }
              );
            };
            wrapped = lib.mkOption {
              type = lib.types.nullOr (lib.types.uniq (lib.types.attrsOf lib.types.bool));
            };
            enumeration = lib.mkOption {
              type = lib.types.enum [
                "a, b"
                "c"
              ];
              default = "c";
            };
            unavailableSchema = lib.mkOption {
              type = lib.types.mkOptionType {
                name = "broken-schema";
                description = "Unavailable schema";
                getSubOptions = _: throw "schema unavailable";
              };
            };
            repeated.repeated.enabled = lib.mkEnableOption "not recursion";
            recursive = lib.mkOption {
              type =
                let
                  t = lib.types.submodule { options.again = lib.mkOption { type = t; }; };
                in
                t;
            };
          };
        })
      ];
    }).options;
  unit = search.serializeOptions {
    tree = unitTree;
    limits = search.defaultLimits // {
      typeDepth = 2;
    };
  };
  checks = {
    mountedModule = demo.sub.message.meta.default == "hello";
    movedMount = index.options.relocated.sub.demo.sub.message.meta.default == "hello";
    sharedUserTree = user.sub.programs.sub.demo.sub.message.meta.defaultStatus == "unavailable";
    freeform = demo.sub.instances.sub."<name>".sub.label.meta.defaultStatus == "unavailable";
    noCompatibilityRoots = !(index.options ? programs) && !(index.options ? zenos);
    upstreamDiscovery = index.options.legacy.sub.future.sub.marker.meta.typeName == "str";
    nixosLegacy = lib.hasPrefix "str" index.options.legacy.sub.networking.sub.hostName.meta.typeName;
    userLegacy = user.sub.legacy.sub.isNormalUser.meta.typeName == "bool";
    homeManager = user.sub.legacy.sub.homeManager.sub.home.sub.stateVersion.meta.typeName == "enum";
    excludeMirrors =
      !(index.options.legacy.sub ? zenos) && !(user.sub.legacy.sub.homeManager.sub ? zenos);
    noStructure = absent.options == { } && absent.pkgs == { };
    packageHierarchy =
      index.pkgs.first.sub.same.meta.id == "pkgs.first.same"
      && index.pkgs.second.sub.same.meta.id == "pkgs.second.same";
    upstreamPackages = index.pkgs.legacy.sub.hello.meta.upstream;
    excludeUniverses = !(index.pkgs.legacy.sub ? pkgsCross) && !(index.pkgs.legacy.sub ? pkgsLinux);
    packageFailure = index.pkgs.legacy.sub.broken.meta.traversal == "unavailable";
    packageDepthLimit =
      index.pkgs.legacy.sub.group.sub.deeper.meta.traversal == "depth-limit"
      && !(index.pkgs.legacy.sub.group.sub.deeper ? sub);
    moduleMetadata =
      demo.meta.description == "Mounted demo" && lib.hasInfix "**Markdown**" demo.meta.longDescription;
    inheritedVersion = demo.meta.zenosVersion == "1.0.0" && demo.sub.message.meta.zenosVersion == "1.0.0";
    relocatedVersion = index.options.relocated.sub.demo.sub.message.meta.zenosVersion == "1.0.0";
    userVersion = user.sub.programs.sub.demo.sub.message.meta.zenosVersion == "1.0.0";
    overriddenVersion = demo.sub.instances.meta.zenosVersion == "2.0.0";
    freeformVersion =
      demo.sub.instances.sub."<name>".meta.zenosVersion == "3.0.0"
      && demo.sub.instances.sub."<name>".sub.label.meta.zenosVersion == "3.0.0";
    mountedFreeformVersion =
      index.options.relocated.sub.demo.sub.instances.sub."<name>".sub.label.meta.zenosVersion == "3.0.0"
      && user.sub.programs.sub.demo.sub.instances.sub."<name>".sub.label.meta.zenosVersion == "3.0.0";
    localAttribution =
      demo.meta.maintainers == [ "doromiert" ]
      && demo.meta.license == "$l.mit"
      && demo.sub.message.meta.maintainers == [ ]
      && demo.sub.message.meta.license == null
      && demo.sub.instances.sub."<name>".sub.label.meta.license == null;
    sourceWarnings = builtins.any (
      d:
      d.source == "modules/programs/demo.zmdl"
      &&
        d.mountedAt == [
          "relocated"
          "demo"
        ]
    ) index.metadata.warnings;
    noFakeAttribution =
      index.options.legacy.sub.future.sub.marker.meta.license == null
      && index.options.legacy.sub.future.sub.marker.meta.maintainers == [ ];
    scalarDefault =
      unit.sub.scalar.meta.defaultStatus == "value" && unit.sub.scalar.meta.default == false;
    absentDefault = unit.sub.required.meta.defaultStatus == "absent";
    defaultText =
      unit.sub.documented.meta.defaultStatus == "documented"
      && unit.sub.documented.meta.defaultText.text == "config.other"
      && unit.sub.documented.meta.default == null;
    unavailableDefaults =
      unit.sub.broken.meta.defaultStatus == "unavailable"
      && unit.sub.complex.meta.defaultStatus == "unavailable";
    unavailableDefaultText = unit.sub.brokenText.meta.defaultStatus == "unavailable";
    unavailableSchema = unit.sub.unavailableSchema.meta.traversal == "unavailable";
    wrapperSchema = unit.sub.wrapped.sub."<name>".meta.typeName == "bool";
    enumValues =
      unit.sub.enumeration.meta.type.enum == [
        "a, b"
        "c"
      ];
    lazySelection =
      (search.serializeOptions {
        tree = {
          good = unitTree.scalar;
          other = builtins.abort "sibling forced";
        };
      }).sub.good.meta.default == false;
    listSchema = unit.sub.list.sub."*".sub.enabled.meta.typeName == "bool";
    lazySchema = unit.sub.lazy.sub."<name>".sub.enabled.meta.typeName == "bool";
    repeatedNames = unit.sub.repeated.sub.repeated.sub.enabled.meta.typeName == "bool";
    boundedRecursion = unit.sub.recursive.sub.again.sub.again.meta.traversal == "depth-limit";
    sampleJSON = builtins.isString (
      builtins.toJSON {
        inherit demo unit;
        packages = index.pkgs;
      }
    );
  };
in
assert lib.all (name: lib.assertMsg checks.${name} "search acceptance failed: ${name}") (
  builtins.attrNames checks
);
checks
