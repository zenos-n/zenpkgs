{ lib }:

let
  packageOutputs = import ../lib/package-outputs.nix { inherit lib; };
  registryFor = targets: {
    packages = map (target: {
      inherit target;
      id = builtins.abort "output discovery evaluated registry identity metadata";
      sourcePath = builtins.abort "output discovery evaluated package provider";
      meta = builtins.abort "output discovery evaluated package metadata";
    }) targets;
  };
  untouched = builtins.abort "output discovery evaluated the package tree";
  reserved = lib.genAttrs [
    "zen-dsl"
    "dsl-bundle"
    "registry-docs"
    "zenos-rebuild"
  ] (_: builtins.abort "output discovery evaluated a reserved output");
  collisionTargets = [ [ "a-b" "c" ] [ "a" "b-c" ] ];
  rejects = args: !(builtins.tryEval (packageOutputs.flatten args)).success;
  tree = {
    apps.first.tool = { type = "derivation"; outPath = "/first-tool"; };
    dev.second.tool = { type = "derivation"; outPath = "/second-tool"; };
    "hyphen-dir".some_tool = { type = "derivation"; outPath = "/hyphen-tool"; };
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
    "dsl-bundle"
    "registry-docs"
    "zen-dsl"
    "zenos-apps-first-tool"
    "zenos-dev-second-tool"
    "zenos-hyphen-dir-some_tool"
    "zenos-rebuild"
  ]; true;

  preservesValuesAndHierarchy =
    assert outputs.zenos-apps-first-tool == tree.apps.first.tool;
    assert outputs.zenos-dev-second-tool == tree.dev.second.tool;
    assert outputs.zenos-hyphen-dir-some_tool == tree."hyphen-dir".some_tool;
    assert !(outputs ? tool);
    true;

  rejectsCollisionBeforeTreeEvaluation = assert rejects {
    registry = registryFor collisionTargets;
    tree = untouched;
  }; true;

  rejectsReversedCollision = assert rejects {
    registry = registryFor (lib.reverseList collisionTargets);
    tree = untouched;
  }; true;

  rejectsLateCollision = assert rejects {
    registry = registryFor (targets ++ collisionTargets);
    tree = untouched;
  }; true;

  rejectsReservedOutputCollision = assert rejects {
    registry = registryFor [ [ "rebuild" ] ];
    tree = untouched;
    inherit reserved;
  }; true;

  rejectsCallerReservedName = assert rejects {
    registry = registryFor [ [ "apps" "first" "tool" ] ];
    tree = untouched;
    reserved.zenos-apps-first-tool = builtins.abort "reserved value was evaluated";
  }; true;

  checksBeforeReturningReservedOutput =
    assert !(builtins.tryEval ((packageOutputs.flatten {
      registry = registryFor collisionTargets;
      tree = untouched;
      reserved.zen-dsl = true;
    }).zen-dsl)).success;
    true;

  namesDoNotEvaluateTree = assert builtins.attrNames (packageOutputs.flatten {
    registry = registryFor targets;
    tree = untouched;
  }) == [
    "zenos-apps-first-tool"
    "zenos-dev-second-tool"
    "zenos-hyphen-dir-some_tool"
  ]; true;

  selectedValueDoesNotEvaluateOtherPackages = assert (packageOutputs.flatten {
    registry = registryFor [ [ "good" ] [ "bad" ] ];
    tree = {
      good = 42;
      bad = builtins.abort "selecting a package evaluated an unrelated package";
    };
  }).zenos-good == 42; true;

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
