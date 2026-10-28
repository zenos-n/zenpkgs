{ lib }:

let
  packageOutputs = import ../lib/package-outputs.nix { inherit lib; };
  registryFor = categoryTargets: {
    packages = map (categoryTarget: {
      target = [ "org" "example" ] ++ categoryTarget;
      inherit categoryTarget;
      id = builtins.abort "output discovery evaluated registry identity metadata";
      sourcePath = builtins.abort "output discovery evaluated package provider";
      meta = builtins.abort "output discovery evaluated package metadata";
    }) categoryTargets;
  };
  untouched = builtins.abort "output discovery evaluated the package tree";
  reserved = lib.genAttrs [
    "zen-dsl"
    "dsl-bundle"
    "registry-docs"
    "zenos-rebuild"
  ] (_: builtins.abort "output discovery evaluated a reserved output");
  collisionEntries = (registryFor [ [ "apps" "foo" ] ]).packages ++ [
    { target = [ "net" "example" "bar" ]; categoryTarget = [ "apps" "foo" ]; }
  ];
  rejects = args: !(builtins.tryEval (packageOutputs.flatten args)).success;
  tree = {
    org.example.apps.first.tool = { type = "derivation"; outPath = "/first-tool"; };
    org.example.dev.second.tool = { type = "derivation"; outPath = "/second-tool"; };
    org.example."hyphen-dir".some_tool = { type = "derivation"; outPath = "/hyphen-tool"; };
    byCategories = builtins.abort "output discovery traversed category aliases";
    unrelated = builtins.abort "output discovery traversed an unregistered branch";
  };
  targets = [
    [ "apps" "first" "tool" ]
    [ "dev" "second" "tool" ]
    [ "hyphen-dir" "some_tool" ]
  ];
  outputs = packageOutputs.flatten {
    registry = registryFor targets;
    inherit tree reserved;
  };
  compatibilitySource = /. + builtins.unsafeDiscardStringContext (builtins.toFile "compatibility-recipe.nix" ''
    builtins.abort "ownership checking evaluated a compatibility recipe"
  '');
  rejectsOwnership = args: !(builtins.tryEval (packageOutputs.checkLegacyOwnership args)).success;
in
{
  rejectsSameLegacyTarget = assert rejectsOwnership {
    registry = registryFor [ [ "apps" "tool" ] ];
    sourceTree.apps.tool = compatibilitySource;
  }; true;

  rejectsLegacyLeafAboveZpkg = assert rejectsOwnership {
    registry = registryFor [ [ "apps" "tool" "child" ] ];
    sourceTree.apps.tool = compatibilitySource;
  }; true;

  rejectsZpkgLeafAboveLegacy = assert rejectsOwnership {
    registry = registryFor [ [ "apps" "tool" ] ];
    sourceTree.apps.tool.child.nested = compatibilitySource;
  }; true;

  checksLaterLegacyOwners = assert rejectsOwnership {
    registry = registryFor [ [ "aaa" ] [ "apps" "tool" ] ];
    sourceTree = {
      aaa.unrelated = { };
      apps.other = compatibilitySource;
      apps.tool = compatibilitySource;
    };
  }; true;

  allowsDisjointLegacyNamespaces = assert packageOutputs.checkLegacyOwnership {
    registry = registryFor [ [ "apps" "tool" ] [ "dev" "compiler" ] ];
    sourceTree = {
      apps.other = compatibilitySource;
      dev.tools.compiler = compatibilitySource;
      system.service = compatibilitySource;
    };
  }; true;

  allowsLegacyTextPrefixes = assert packageOutputs.checkLegacyOwnership {
    registry = registryFor [ [ "apps" "tool" ] [ "dev" "compiler-extra" ] ];
    sourceTree = {
      apps.tool-extra = compatibilitySource;
      dev.compiler = compatibilitySource;
    };
  }; true;

  legacyOwnershipUsesHierarchyNotFlatNames = assert packageOutputs.checkLegacyOwnership {
    registry = registryFor [ [ "a-b" "c" ] ];
    sourceTree.a.b-c = compatibilitySource;
  }; true;

  allowsEmptyLegacyTree = assert packageOutputs.checkLegacyOwnership {
    registry = registryFor targets;
    sourceTree = { };
  }; true;

  allowsEmptyRegistryWithLegacyRecipes = assert packageOutputs.checkLegacyOwnership {
    registry = registryFor [ ];
    sourceTree.apps.tool = compatibilitySource;
  }; true;

  ignoresEmptyLegacyBranches = assert packageOutputs.checkLegacyOwnership {
    registry = registryFor [ [ "apps" "tool" ] ];
    sourceTree.apps.tool.empty = { };
  }; true;

  rejectsInvalidLegacySourceLeaves = assert lib.all (source: rejectsOwnership {
    registry = registryFor [ ];
    sourceTree.apps.tool = source;
  }) [ null false 42 [ ] (toString compatibilitySource) ]; true;

  preservesNames = assert builtins.attrNames outputs == [
    "apps.first.tool"
    "dev.second.tool"
    "dsl-bundle"
    "hyphen-dir.some_tool"
    "org.example.apps.first.tool"
    "org.example.dev.second.tool"
    "org.example.hyphen-dir.some_tool"
    "registry-docs"
    "zen-dsl"
    "zenos-rebuild"
  ]; true;

  preservesValuesAndHierarchy =
    assert outputs."org.example.apps.first.tool" == tree.org.example.apps.first.tool;
    assert outputs."apps.first.tool" == outputs."org.example.apps.first.tool";
    assert outputs."dev.second.tool" == tree.org.example.dev.second.tool;
    assert outputs."hyphen-dir.some_tool" == tree.org.example."hyphen-dir".some_tool;
    assert !(outputs ? tool);
    assert !(outputs ? "zenos-apps-first-tool");
    true;

  rejectsCollisionBeforeTreeEvaluation = assert rejects {
    registry.packages = collisionEntries;
    tree = untouched;
  }; true;

  rejectsReversedCollision = assert rejects {
    registry.packages = lib.reverseList collisionEntries;
    tree = untouched;
  }; true;

  rejectsLateCollision = assert rejects {
    registry.packages = (registryFor targets).packages ++ collisionEntries;
    tree = untouched;
  }; true;

  rejectsCanonicalCollision = assert rejects {
    registry.packages = (registryFor [ [ "apps" "foo" ] ]).packages ++ [
      { target = [ "org" "example" "apps" "foo" ]; categoryTarget = [ "dev" "foo" ]; }
    ];
    tree = untouched;
  }; true;

  rejectsCrossViewCollision = assert rejects {
    registry.packages = (registryFor [ [ "apps" "tool" ] ]).packages ++ [
      { target = [ "apps" "tool" ]; categoryTarget = [ "dev" "tool" ]; }
    ];
    tree = untouched;
  }; true;

  allowsDifferentDottedNames = assert builtins.attrNames (packageOutputs.flatten {
    registry = registryFor [ [ "foo-bar" ] [ "foo" "bar" ] ];
    tree = untouched;
  }) == [
    "foo-bar"
    "foo.bar"
    "org.example.foo-bar"
    "org.example.foo.bar"
  ]; true;

  rejectsReservedOutputCollision = assert rejects {
    registry = registryFor [ [ "zenos-rebuild" ] ];
    tree = untouched;
    inherit reserved;
  }; true;

  rejectsCallerReservedName = assert rejects {
    registry = registryFor [ [ "apps" "first" "tool" ] ];
    tree = untouched;
    reserved."apps.first.tool" = builtins.abort "reserved value was evaluated";
  }; true;

  rejectsCallerReservedCanonicalName = assert rejects {
    registry = registryFor [ [ "apps" "first" "tool" ] ];
    tree = untouched;
    reserved."org.example.apps.first.tool" = builtins.abort "reserved value was evaluated";
  }; true;

  checksBeforeReturningReservedOutput =
    assert !(builtins.tryEval ((packageOutputs.flatten {
      registry.packages = collisionEntries;
      tree = untouched;
      reserved.zen-dsl = true;
    }).zen-dsl)).success;
    true;

  namesDoNotEvaluateTree = assert builtins.attrNames (packageOutputs.flatten {
    registry = registryFor targets;
    tree = untouched;
  }) == [
    "apps.first.tool"
    "dev.second.tool"
    "hyphen-dir.some_tool"
    "org.example.apps.first.tool"
    "org.example.dev.second.tool"
    "org.example.hyphen-dir.some_tool"
  ]; true;

  selectedValueDoesNotEvaluateOtherPackages = assert (packageOutputs.flatten {
    registry = registryFor [ [ "good" ] [ "bad" ] ];
    tree = {
      org.example.good = 42;
      org.example.bad = builtins.abort "selecting a package evaluated an unrelated package";
    };
  })."good" == 42; true;

  preservesReservedValues = assert packageOutputs.flatten {
    registry = registryFor [ ];
    tree = untouched;
    reserved = { zen-dsl = 1; dsl-bundle = 2; registry-docs = 3; zenos-rebuild = 4; };
  } == { zen-dsl = 1; dsl-bundle = 2; registry-docs = 3; zenos-rebuild = 4; }; true;

  emptyRegistry = assert packageOutputs.flatten {
    registry = registryFor [ ];
    tree = untouched;
  } == { }; true;
}
