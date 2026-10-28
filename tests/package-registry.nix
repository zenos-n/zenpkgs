{
  expectedRegistry,
  interface,
  lib,
  pkgs,
  publicPackages,
  registry,
}:

let
  normalize = value: interface.registryDocs value;
  pathKey = entry: lib.concatStringsSep "/" entry.target;
  sortPackages =
    value: value // { packages = lib.sort (left: right: pathKey left < pathKey right) value.packages; };
  actual = normalize (sortPackages registry);
  expected = normalize (sortPackages expectedRegistry);
  expectedSorted = sortPackages expectedRegistry;
  activeEntries = registry.packages;
  importEntries = lib.filter (entry: entry.provider.kind == "import") activeEntries;
  buildEntries = lib.filter (entry: entry.provider.kind == "build") activeEntries;
  expectedActiveEntries = expectedRegistry.packages;
  registryPaths =
    value:
    map (
      entry:
      {
        inherit (entry)
          id
          provider
          target
          categoryTarget
          ;
      }
      // lib.optionalAttrs (entry.provider.kind == "import") {
        inherit (entry) sourcePath;
      }
    ) (sortPackages value).packages;
  packagePaths = value: map (entry: entry.target) value.packages;
  activePaths = map (entry: entry.target) activeEntries;
  registryPathKeys = map pathKey registry.packages;
  outputName = path: lib.concatStringsSep "." path;
  outputNames = lib.concatMap (entry: [
    (outputName entry.target)
    (outputName entry.categoryTarget)
  ]) activeEntries;
  # These recipes are internal builders, each owned by one canonical ZPKG.
  compatBuilderCategories = [
    [ "desktops" "gnome" "extensions" "dash-stacks" ]
    [ "desktops" "gnome" "extensions" "forge" ]
    [ "desktops" "gnome" "extensions" "zenlink-indicator" ]
    [ "desktops" "gnome" "tweaks" "zero-gnome-clock" ]
    [ "system" "zenboot" ]
    [ "system" "zenclean" ]
    [ "system" "zenlink" ]
    [ "theming" "icons" "zenos-icons" ]
    [ "theming" "system" "fastfetch" ]
    [ "theming" "wallpapers" "destination-2" ]
  ];
  buildProvider =
    entry:
    import entry.buildFile {
      inherit pkgs;
      # Compare the undecorated builder result, before dependency handling.
      zpkgRuntime = { provider, ... }: provider;
    };
  outputIdentities = lib.concatMap (
    entry:
    let
      upstream =
        if entry.provider.kind == "import" then
          # ZPKG imports name the pinned legacy provider, not final top-level
          # attributes, which can differ for Nixpkgs bootstrap packages.
          lib.attrByPath entry.sourcePath null (pkgs.zenos.legacy or pkgs)
        else
          buildProvider entry;
      overlayPackage = lib.attrByPath ([ "zenos" ] ++ entry.target) null pkgs;
      categoryPackage = lib.attrByPath ([ "zenos" "byCategories" ] ++ entry.categoryTarget) null pkgs;
      publicPackage = publicPackages.${outputName entry.target} or null;
      publicCategoryPackage = publicPackages.${outputName entry.categoryTarget} or null;
    in
    [
      (
        upstream != null
        && overlayPackage != null
        && categoryPackage != null
        && categoryPackage.drvPath == overlayPackage.drvPath
        && categoryPackage.outPath == overlayPackage.outPath
        && publicPackage != null
        && publicCategoryPackage != null
        && publicCategoryPackage.drvPath == publicPackage.drvPath
        && publicCategoryPackage.outPath == publicPackage.outPath
        && overlayPackage.drvPath == upstream.drvPath
        && overlayPackage.outPath == upstream.outPath
        && publicPackage.drvPath == upstream.drvPath
        && publicPackage.outPath == upstream.outPath
      )
    ]
  ) activeEntries;
  pass = name: pkgs.runCommand name { } "touch $out";
  adapter = import ../lib/dsl-bundle.nix { inherit lib; };
  packageOutputs = import ../lib/package-outputs.nix { inherit lib; };
  rejects = value: !(builtins.tryEval (builtins.deepSeq value true)).success;
  literal = value: {
    type = "literal";
    inherit value;
  };
  packageReference = path: {
    type = "variable";
    name = "pkgs";
    path = map (value: {
      kind = "identifier";
      inherit value;
    }) path;
  };
  descriptor = {
    descriptorVersion = "zenlang.semantic/2";
    kind = "zpkg";
    # Semantic descriptor names identify the source; metadata.id is the package identity.
    name = "pkgs.apps.first.tool";
    imports = [ ];
    provider = {
      kind = "import";
      expression = packageReference [
        "legacy"
        "hello"
      ];
    };
    dependenciesDeclared = false;
    metadata = {
      id = literal "org.example.first-tool";
      name = literal "Tool";
      summary = literal "Example package";
      description = {
        type = "string";
        multiline = true;
        parts = [
          {
            type = "text";
            value = "Example **Markdown**.";
          }
        ];
      };
      zenosVersion = literal "1.0.0";
      tags = literal [ ];
      maintainers = literal [ "$m.doromiert" ];
      license = literal "$l.mit";
    };
  };
  decoded = adapter.decodeInterface descriptor;
  incomplete = adapter.decodeInterface (descriptor // { metadata.id = literal "org.example.first-tool"; });
  scoped = adapter.decodeInterface (
    descriptor
    // {
      dependenciesDeclared = true;
      metadata = descriptor.metadata // {
        dependencies = {
          type = "attr-set";
          statements =
            map
              (scope: {
                type = "assignment";
                operator = "=";
                target = [
                  {
                    kind = "identifier";
                    value = scope;
                  }
                ];
                value = {
                  type = "list";
                  items = [
                    (packageReference [
                      "byCategories"
                      "libs"
                      scope
                      "tool"
                    ])
                  ];
                };
              })
              [
                "general"
                "build"
                "runtime"
              ];
        };
      };
    }
  );
  fixtureInterface = builtins.toFile "registry-interface.nix" "{ ... }: builtins.fromJSON ${builtins.toJSON (builtins.toJSON descriptor)}";
  secondDescriptor = descriptor // {
    name = "pkgs.dev.second.tool";
    metadata = descriptor.metadata // { id = literal "net.example.second-tool"; };
  };
  secondInterface = builtins.toFile "registry-second-interface.nix" "{ ... }: builtins.fromJSON ${builtins.toJSON (builtins.toJSON secondDescriptor)}";
  fixtureBuild = builtins.toFile "registry-build.nix" ''
    { pkgs, zpkgRuntime, ... }: zpkgRuntime {
      provider = pkgs.zenos.legacy.hello;
      metadata = builtins.fromJSON ${builtins.toJSON (builtins.toJSON decoded.meta)};
      dependenciesDeclared = false;
    }
  '';
  secondBuild = builtins.toFile "registry-second-build.nix" ''
    { pkgs, zpkgRuntime, ... }: zpkgRuntime {
      provider = pkgs.zenos.legacy.hello;
      metadata = builtins.fromJSON ${builtins.toJSON (builtins.toJSON (adapter.decodeInterface secondDescriptor).meta)};
      dependenciesDeclared = false;
    }
  '';
  fixtureBundle = pkgs.runCommand "zenpkgs-registry-adapter-fixture" { } ''
    mkdir -p "$out/interfaces/pkgs/apps/first" "$out/interfaces/pkgs/dev/second"
    mkdir -p "$out/builds/pkgs/apps/first" "$out/builds/pkgs/dev/second"
    cp ${fixtureInterface} "$out/interfaces/pkgs/apps/first/tool.zpkg.nix"
    cp ${secondInterface} "$out/interfaces/pkgs/dev/second/tool.zpkg.nix"
    cp ${fixtureBuild} "$out/builds/pkgs/apps/first/tool.zpkg.nix"
    cp ${secondBuild} "$out/builds/pkgs/dev/second/tool.zpkg.nix"
    # Populate reserved paths so missing fixture files cannot mask validation regressions.
    mkdir -p "$out/interfaces/pkgs/legacy" "$out/builds/pkgs/legacy"
    mkdir -p "$out/interfaces/pkgs/apps" "$out/builds/pkgs/apps"
    cp ${fixtureInterface} "$out/interfaces/pkgs/legacy/tool.zpkg.nix"
    cp ${fixtureBuild} "$out/builds/pkgs/legacy/tool.zpkg.nix"
    cp ${fixtureInterface} "$out/interfaces/pkgs/apps/package.zpkg.nix"
    cp ${fixtureBuild} "$out/builds/pkgs/apps/package.zpkg.nix"
  '';
  structure = {
    kind = "zstr";
    path = "structure.zstr";
  };
  first = {
    kind = "zpkg";
    path = "pkgs/apps/first/tool.zpkg";
  };
  second = {
    kind = "zpkg";
    path = "pkgs/dev/second/tool.zpkg";
  };
  bundle = {
    bundleVersion = "zenlang.bundle/2";
    sources = [
      structure
      second
      first
    ];
  };
  adapt =
    value:
    adapter.registryFromBundle {
      bundle = value;
      bundlePath = fixtureBundle;
    };
  repeated = adapt bundle;
  repeatedTree = interface.buildPackageTree { inherit (pkgs) hello; } repeated;
  contextSiblingTree = interface.buildPackageTreeWith {
    pkgs = pkgs // {
      zenos.byCategories = {
        compat.tool = pkgs.hello;
        apps.first.compat = pkgs.hello;
      };
    };
    legacyPkgs = pkgs;
    registry = repeated;
    buildPackage = entry: context:
      assert context.pkgs.zenos.byCategories.compat.tool.drvPath == pkgs.hello.drvPath;
      assert context.pkgs.zenos.byCategories.apps.first.compat.drvPath == pkgs.hello.drvPath;
      # The second provider can consume the first registry leaf through either view.
      assert entry.id != "pkgs.net.example.second-tool" || (
        context.pkgs.zenos.byCategories.apps.first.tool.drvPath
        == context.pkgs.zenos.org.example.first-tool.drvPath
      );
      pkgs.hello;
  };
  firstEntry = lib.findFirst (entry: entry.id == "pkgs.org.example.first-tool") (throw "registry fixture is missing pkgs.org.example.first-tool") repeated.packages;
  registryWith = packages: {
    schemaVersion = 1;
    inherit packages;
  };
in
{
  registry-contract =
    assert builtins.toJSON actual == builtins.toJSON expected;
    pass "zenpkgs-package-registry-contract";

  registry-no-retired-package-roots =
    assert lib.all (name: !(builtins.hasAttr name pkgs.zenos)) [ "apps" "desktops" "libs" "system" "theming" "dev" "programs" ];
    assert !(pkgs.zenos.byCategories.apps ? advanced);
    assert !(pkgs.zenos.byCategories.apps ? utilities);
    assert pkgs.zenos.byCategories.apps.audio.swisstag.pname == "swisstag";
    pass "zenpkgs-no-retired-package-roots";

  registry-counts =
    assert builtins.length expectedRegistry.packages == 4153;
    assert builtins.length expectedActiveEntries == 4153;
    assert builtins.length registry.packages == 4153;
    assert builtins.length activeEntries == 4153;
    assert builtins.length importEntries == 4098;
    assert builtins.length buildEntries == 55;
    assert lib.all (entry: !entry.dependenciesDeclared) importEntries;
    pass "zenpkgs-package-registry-counts";

  package-paths =
    assert builtins.length (registryPaths expectedRegistry) == 4153;
    assert builtins.length (packagePaths expectedRegistry) == 4153;
    assert builtins.length activePaths == 4153;
    assert registryPathKeys == lib.sort builtins.lessThan registryPathKeys;
    assert registryPaths registry == registryPaths expectedRegistry;
    assert packagePaths registry == packagePaths expectedSorted;
    pass "zenpkgs-package-registry-paths";

  public-package-outputs =
    assert builtins.length outputIdentities == 4153;
    assert lib.all (identity: identity) outputIdentities;
    pass "zenpkgs-public-package-outputs";

  gnosis-package =
    let
      canonical = publicPackages."com.neg-zero.gnosis";
      category = publicPackages."apps.browsers.gnosis";
    in
    assert canonical.drvPath == category.drvPath;
    assert canonical.meta.mainProgram == "gnosis";
    assert canonical.meta.homepage == "https://github.com/doromiert/gnosis";
    pass "zenpkgs-gnosis-package";

  registry-build-providers =
    assert
      map (entry: "${lib.concatStringsSep "." entry.categoryTarget}")
        (lib.sort (a: b: lib.concatStringsSep "/" a.categoryTarget < lib.concatStringsSep "/" b.categoryTarget) buildEntries) == [
        "apps.accessibility.hapticspp"
        "apps.ai.codex"
        "apps.ai.codex-desktop"
        "apps.ai.codex-telegram-bot"
        "apps.ai.opencode"
        "apps.ai.opencode-telegram-bot"
        "apps.ai.takopi"
        "apps.audio.swisstag"
        "apps.browsers.gnosis"
        "apps.browsers.hyperbeam"
        "apps.connectivity.zbridge"
        "apps.development.gnome-builder-lsp"
        "apps.gaming.alvr-zenos-compat"
        "apps.gaming.emulators.ryubing-canary"
        "apps.gaming.emulators.yuzu-mainline"
        "apps.gaming.fnuidesktop-vr"
        "apps.gaming.nzportable"
        "apps.gaming.ovr-advanced-settings"
        "apps.gaming.wlx-overlay-s"
        "apps.gaming.zenos-vr-tools"
        "apps.graphics.blender-hip"
        "apps.graphics.select-for-figma"
        "apps.system.zenos-setup"
        "apps.system.zenos.zenos-rebuild"
        "apps.video.tubefin"
        "desktops.gnome.extensions.codex-usage"
        "desktops.gnome.extensions.dash-stacks"
        "desktops.gnome.extensions.forge"
        "desktops.gnome.extensions.wiggly"
        "desktops.gnome.extensions.zane-indicator"
        "desktops.gnome.extensions.zen-vision"
        "desktops.gnome.extensions.zenlink-indicator"
        "desktops.gnome.tweaks.zero-gnome-clock"
        "libs.libfreenect2"
        "system.kernel.popcorn"
        "system.kernel.popcorn-zen4"
        "system.zenboot"
        "system.zenclean"
        "system.zenfs"
        "system.zenlink"
        "system.zenos-oobe-mode"
        "system.zenos-recovery-tools"
        "system.zenos-refind-installer"
        "system.zenos-shell-defaults"
        "theming.apps.firefox-gnome"
        "theming.fonts.zero.mono"
        "theming.fonts.zero.mono-thin"
        "theming.fonts.zero.regular"
        "theming.icons.adwaita-hacks"
        "theming.icons.zenos-icons"
        "theming.system.fastfetch"
        "theming.system.zenos-branding"
        "theming.system.zenos-plymouth"
        "theming.system.zenos-refind-theme"
        "theming.wallpapers.destination-2"
      ];
    assert lib.all (
      entry:
      let
        provider = buildProvider entry;
        package = lib.getAttrFromPath ([ "zenos" ] ++ entry.target) pkgs;
      in
      !(entry ? sourcePath)
      && !entry.dependenciesDeclared
      && !(entry.meta ? dependencies)
      && lib.hasInfix "/pkgs/${lib.concatStringsSep "/" entry.categoryTarget}.zpkg:" entry.location
      && lib.hasSuffix "/builds/pkgs/${lib.concatStringsSep "/" entry.categoryTarget}.zpkg.nix" (toString entry.buildFile)
      && builtins.pathExists entry.buildFile
      && package._zmeta.id == entry.id
      && package._zmeta.interface == entry.provider
      && !package._zmeta.dependenciesDeclared
      && !(package.meta.zenos ? sourcePath)
      && !(package.meta.zenos ? legacyPath)
      &&
        lib.all
          (channel: map toString (package.${channel} or [ ]) == map toString (provider.${channel} or [ ]))
          [
            "buildInputs"
            "nativeBuildInputs"
            "propagatedBuildInputs"
            "propagatedNativeBuildInputs"
          ]
    ) buildEntries;
    pass "zenpkgs-registry-build-providers";

  registry-output-ownership =
    assert builtins.length outputNames == 4153 * 2;
    assert builtins.length (builtins.attrNames (builtins.listToAttrs
      (map (name: { inherit name; value = true; }) outputNames))) == 4153 * 2;
    assert
      builtins.attrNames publicPackages == lib.sort builtins.lessThan (
        outputNames
        ++ [
          "dsl-bundle"
          "registry-docs"
          "zen-dsl"
          "zenos-rebuild"
        ]
      );
    assert builtins.length compatBuilderCategories == 10;
    assert lib.all (categoryTarget:
      builtins.length (lib.filter (entry: entry.categoryTarget == categoryTarget) buildEntries) == 1
    ) compatBuilderCategories;
    pass "zenpkgs-registry-output-ownership";

  registry-dotted-output-collisions =
    let
      first = {
        target = [ "com" "neg-zero" "zenos-setup" ];
        categoryTarget = [ "apps" "system" "zenos-setup" ];
      };
      second = {
        target = [ "org" "example" "other" ];
        categoryTarget = [ "apps" "other" ];
      };
      untouched = builtins.abort "output naming forced a package value";
      flatten = packages: reserved: packageOutputs.flatten {
        registry = { inherit packages; };
        tree = untouched;
        inherit reserved;
      };
      collision = packages: reserved: !(builtins.tryEval (flatten packages reserved)).success;
      outputs = packageOutputs.flatten {
        registry.packages = [ first second ];
        tree.com.neg-zero.zenos-setup = pkgs.hello;
        tree.org.example.other = untouched;
        reserved.zen-dsl = untouched;
      };
    in
    assert builtins.attrNames (flatten [ first ] { zen-dsl = untouched; }) == [
      "apps.system.zenos-setup" "com.neg-zero.zenos-setup" "zen-dsl"
    ];
    assert outputs."com.neg-zero.zenos-setup".drvPath == outputs."apps.system.zenos-setup".drvPath;
    assert outputs."com.neg-zero.zenos-setup".outPath == outputs."apps.system.zenos-setup".outPath;
    assert collision [ first (second // { target = first.target; }) ] { };
    assert collision [ first (second // { categoryTarget = first.categoryTarget; }) ] { };
    assert collision [ first (second // { target = first.categoryTarget; }) ] { };
    assert collision [ first (second // { categoryTarget = first.target; }) ] { };
    assert collision [ (first // { categoryTarget = first.target; }) ] { };
    assert collision [ first ] { "com.neg-zero.zenos-setup" = untouched; };
    assert collision [ first ] { "apps.system.zenos-setup" = untouched; };
    assert collision [ (first // { target = [ "zen-dsl" ]; }) ] { zen-dsl = untouched; };
    assert !(builtins.tryEval ((flatten [ first first ] { zen-dsl = true; }).zen-dsl)).success;
    pass "zenpkgs-dotted-output-collisions";

  registry-setup-identity =
    let
      entries = lib.filter (entry: entry.id == "pkgs.com.neg-zero.zenos-setup") activeEntries;
    in
    assert builtins.length entries == 1;
    assert (builtins.head entries).target == [ "com" "neg-zero" "zenos-setup" ];
    assert (builtins.head entries).categoryTarget == [ "apps" "system" "zenos-setup" ];
    assert publicPackages."com.neg-zero.zenos-setup".drvPath
      == publicPackages."apps.system.zenos-setup".drvPath;
    pass "zenpkgs-setup-identity";

  registry-nzportable-identity =
    let
      entries = lib.filter (entry: entry.id == "pkgs.gay.nzp.nzportable") activeEntries;
    in
    assert builtins.length entries == 1;
    assert (builtins.head entries).target == [ "gay" "nzp" "nzportable" ];
    assert (builtins.head entries).categoryTarget == [ "apps" "gaming" "nzportable" ];
    pass "zenpkgs-nzportable-identity";

  registry-path-identities =
    assert
      map (entry: entry.id) repeated.packages == [
        "pkgs.net.example.second-tool"
        "pkgs.org.example.first-tool"
      ];
    assert repeatedTree.org.example.first-tool.drvPath == pkgs.hello.drvPath;
    assert repeatedTree.net.example.second-tool.drvPath == pkgs.hello.drvPath;
    assert
      builtins.attrNames repeatedTree == [
        "byCategories"
        "net"
        "org"
      ];
    assert !(repeatedTree ? tool) && !(repeatedTree ? hello) && !(repeatedTree ? legacy);
    assert
      builtins.attrNames (interface.registryDocs repeated) == [
        "packages"
        "schemaVersion"
      ];
    assert
      (interface.buildPackageTree { "upstream.tool+" = pkgs.hello; } (registryWith [
        (
          firstEntry
          // {
            sourcePath = [ "upstream.tool+" ];
            provider = {
              kind = "import";
              expression = packageReference [
                "legacy"
                "upstream.tool+"
              ];
            };
            buildFile = builtins.toFile "registry-quoted-build.nix" ''
              { pkgs, zpkgRuntime, ... }: zpkgRuntime { provider = pkgs.zenos.legacy."upstream.tool+"; }
            '';
          }
        )
      ])).org.example.first-tool._zmeta.id == "pkgs.org.example.first-tool";
    assert repeatedTree.byCategories.apps.first.tool.drvPath == repeatedTree.org.example.first-tool.drvPath;
    assert repeatedTree.byCategories.apps.first.tool.outPath == repeatedTree.org.example.first-tool.outPath;
    assert repeatedTree.byCategories.dev.second.tool.drvPath == repeatedTree.net.example.second-tool.drvPath;
    assert !(repeatedTree ? apps) && !(repeatedTree ? dev);
    assert builtins.length repeated.packages == 2;
    assert (interface.buildPackageTree { inherit (pkgs) hello; } (registryWith [
      (firstEntry // { categoryTarget = [ "dev" "moved-tool" ]; })
    ])).org.example.first-tool.drvPath == repeatedTree.org.example.first-tool.drvPath;
    assert repeatedTree.org.example.first-tool.src == pkgs.hello.src;
    assert repeatedTree.byCategories.apps.first.tool.src == repeatedTree.org.example.first-tool.src;
    assert pkgs.zenos.legacy.hello.src == pkgs.hello.src;
    assert contextSiblingTree.net.example.second-tool.drvPath == pkgs.hello.drvPath;
    assert contextSiblingTree.byCategories.apps.first.tool.drvPath
      == contextSiblingTree.org.example.first-tool.drvPath;
    assert !(contextSiblingTree.byCategories ? compat);
    assert !(contextSiblingTree.byCategories.apps.first ? compat);
    assert firstEntry.id == "pkgs.org.example.first-tool";
    assert firstEntry.meta.id == "org.example.first-tool";
    assert firstEntry.target == [ "org" "example" "first-tool" ];
    assert firstEntry.categoryTarget == [ "apps" "first" "tool" ];
    assert firstEntry.buildFile == fixtureBundle + "/builds/pkgs/apps/first/tool.zpkg.nix";
    assert firstEntry.provider == descriptor.provider;
    assert !firstEntry.dependenciesDeclared;
    assert lib.all (entry: entry.id == "pkgs.${lib.concatStringsSep "." entry.target}") activeEntries;
    pass "zenpkgs-registry-path-identities";

  registry-invalid-identities =
    assert rejects (
      adapt (
        bundle
        // {
          sources = [
            structure
            first
            first
          ];
        }
      )
    );
    assert lib.all (path: rejects (adapt (bundle // {
      sources = [ structure { kind = "zpkg"; inherit path; } ];
    }))) [ "pkgs/legacy/tool.zpkg" "pkgs/apps/package.zpkg" ];
    assert rejects (
      interface.registryDocs (registryWith [
        firstEntry
        firstEntry
      ])
    );
    # Isolate duplicate canonical identity from duplicate category detection.
    assert rejects (interface.registryDocs (registryWith [
      firstEntry
      (firstEntry // { categoryTarget = [ "dev" "other-tool" ]; })
    ]));
    # Isolate category leaf/branch collision with a distinct, valid canonical ID.
    assert rejects (interface.registryDocs (registryWith [
      firstEntry
      (firstEntry // {
        id = "pkgs.net.example.category-child";
        target = [ "net" "example" "category-child" ];
        meta = firstEntry.meta // { id = "net.example.category-child"; };
        categoryTarget = firstEntry.categoryTarget ++ [ "child" ];
      })
    ]));
    assert rejects (interface.registryDocs (registryWith [ (firstEntry // { id = "tool"; }) ]));
    assert rejects (adapter.decodeInterface (descriptor // { metadata = removeAttrs descriptor.metadata [ "id" ]; }));
    assert lib.all (id: rejects (adapter.decodeInterface (descriptor // {
      metadata = descriptor.metadata // { id = literal id; };
    }))) [ "" "tool" "org..tool" ".org.tool" "org.tool." "org/example/tool" 123 ];
    assert rejects (interface.registryDocs (registryWith [ (removeAttrs firstEntry [ "categoryTarget" ]) ]));
    assert rejects (interface.registryDocs (registryWith [
      firstEntry
      (firstEntry // { id = "pkgs.net.example.other"; target = [ "net" "example" "other" ];
        meta = firstEntry.meta // { id = "net.example.other"; }; })
    ]));
    assert rejects (
      interface.registryDocs (registryWith [
        (
          firstEntry
          // {
            target = [
              "apps.first"
              "tool"
            ];
          }
        )
      ])
    );
    assert rejects (
      interface.registryDocs (registryWith [
        firstEntry
        (
          firstEntry
          // {
            id = "pkgs.org.example.first-tool.child";
            target = firstEntry.target ++ [ "child" ];
            categoryTarget = [ "apps" "other" ];
            meta = firstEntry.meta // { id = "org.example.first-tool.child"; };
          }
        )
      ])
    );
    pass "zenpkgs-registry-invalid-identities";

  registry-structure-exposure =
    assert
      (adapt (
        bundle
        // {
          sources = [
            first
            second
          ];
        }
      )).packages == [ ];
    assert
      adapter.modulesFromBundle {
        bundle = bundle // {
          sources = [
            {
              kind = "zmdl";
              path = "modules/system/tool.zmdl";
            }
          ];
          modules = [ { path = "modules/system/tool.zmdl"; } ];
        };
        bundlePath = fixtureBundle;
      } == [ ];
    assert rejects (
      adapt (
        bundle
        // {
          sources = [
            structure
            structure
          ];
        }
      )
    );
    assert rejects (
      adapt (
        bundle
        // {
          sources = [
            {
              kind = "zstr";
              path = "nested/structure.zstr";
            }
          ];
        }
      )
    );
    pass "zenpkgs-registry-structure-exposure";

  registry-metadata-defaults =
    assert
      incomplete.meta == {
        id = "org.example.first-tool";
        name = "";
        summary = "";
        description = "";
        tags = [ ];
        maintainers = [ ];
        license = null;
        zenosVersion = "";
        packageVersion = "";
      };
    assert !incomplete.dependenciesDeclared && !decoded.dependenciesDeclared;
    assert decoded.meta.packageVersion == "1.0.0";
    assert
      (adapter.decodeInterface (
        descriptor
        // {
          metadata = descriptor.metadata // {
            packageVersion = literal "";
          };
        }
      )).meta.packageVersion == "1.0.0";
    assert
      (adapter.decodeInterface (
        descriptor
        // {
          metadata = descriptor.metadata // {
            packageVersion = literal "2.0.0";
          };
        }
      )).meta.packageVersion == "2.0.0";
    assert decoded.meta.description == "Example **Markdown**.";
    assert decoded.meta.maintainers == [ "doromiert" ];
    assert decoded.meta.license == "$l.mit";
    assert
      (adapter.decodeInterface (
        descriptor
        // {
          metadata = descriptor.metadata // {
            description = descriptor.metadata.description // {
              parts = [ ];
            };
          };
        }
      )).meta.description == "";
    assert
      scoped.meta.dependencies == {
        general = [
          {
            namespace = "pkgs";
            path = [
              "byCategories"
              "libs"
              "general"
              "tool"
            ];
          }
        ];
        build = [
          {
            namespace = "pkgs";
            path = [
              "byCategories"
              "libs"
              "build"
              "tool"
            ];
          }
        ];
        runtime = [
          {
            namespace = "pkgs";
            path = [
              "byCategories"
              "libs"
              "runtime"
              "tool"
            ];
          }
        ];
      };
    assert scoped.dependenciesDeclared;
    assert
      (adapter.decodeInterface (
        descriptor
        // {
          dependenciesDeclared = true;
          metadata = descriptor.metadata // {
            dependencies = {
              type = "attr-set";
              statements = [ ];
            };
          };
        }
      )).meta.dependencies == {
        general = [ ];
        build = [ ];
        runtime = [ ];
      };
    assert rejects (
      adapter.decodeInterface (
        descriptor
        // {
          metadata = descriptor.metadata // {
            tags = literal "not a list";
          };
        }
      )
    );
    assert rejects (
      adapter.decodeInterface (
        descriptor
        // {
          metadata = descriptor.metadata // {
            description = descriptor.metadata.description // {
              multiline = false;
            };
          };
        }
      )
    );
    assert rejects (
      adapter.decodeInterface (
        descriptor
        // {
          metadata = descriptor.metadata // {
            dependencies = {
              type = "attr-set";
              statements = [
                {
                  type = "assignment";
                  operator = "=";
                  target = [
                    {
                      kind = "identifier";
                      value = "_general";
                    }
                  ];
                  value = {
                    type = "list";
                    items = [ ];
                  };
                }
              ];
            };
          };
          dependenciesDeclared = true;
        }
      )
    );
    pass "zenpkgs-registry-metadata-defaults";

  registry-dependency-support =
    let
      provider =
        pkgs.runCommand "registry-native-provider" { }
          "mkdir -p $out/bin; touch $out/bin/tool; chmod +x $out/bin/tool";
      dependency = pkgs.writeShellScriptBin "registry-dependency" "exit 0";
      packageWith =
        entry: selectedProvider:
        (interface.buildPackageTreeWith {
          inherit pkgs;
          legacyPkgs = pkgs // {
            hello = selectedProvider;
          };
          registry = registryWith [ entry ];
          buildPackage =
            record: context:
            assert record.buildFile == firstEntry.buildFile;
            context.zpkgRuntime {
              provider = context.pkgs.zenos.legacy.hello;
              metadata = record.meta;
              inherit (record) dependenciesDeclared;
            };
        }).org.example.first-tool;
      emptyScopes = {
        general = [ ];
        build = [ ];
        runtime = [ ];
      };
      entryWith =
        dependencies:
        firstEntry
        // {
          dependenciesDeclared = true;
          meta = firstEntry.meta // {
            inherit dependencies;
          };
        };
    in
    assert lib.all
      (
        scope:
        let
          entry = entryWith (emptyScopes // { ${scope} = [ dependency ]; });
          package = packageWith entry provider;
          docsEntry = firstEntry // {
            inherit (scoped) meta dependenciesDeclared;
          };
        in
        package.drvPath != provider.drvPath
        && package.outPath != provider.outPath
        && package.meta.dependencies.${scope} == [ dependency ]
        && (scope != "build" || package.nativeBuildInputs == [ dependency ])
        &&
          (builtins.head (interface.registryDocs (registryWith [ docsEntry ])).packages)
          == removeAttrs docsEntry [
            "buildFile"
            "location"
          ]
      )
      [
        "general"
        "build"
        "runtime"
      ];
    assert lib.all
      (
        dependencies:
        let
          package = packageWith (entryWith dependencies) provider;
        in
        package.meta.dependencies == emptyScopes
        && package.buildInputs == [ ]
        && package.nativeBuildInputs == [ ]
        && package.drvPath != provider.drvPath
        && package.outPath != provider.outPath
      )
      [
        { }
        { general = [ ]; }
        { build = [ ]; }
        { runtime = [ ]; }
        emptyScopes
      ];
    assert (packageWith firstEntry pkgs.hello).drvPath == pkgs.hello.drvPath;
    assert (packageWith firstEntry pkgs.hello).outPath == pkgs.hello.outPath;
    assert lib.all
      (dependencies: !(builtins.tryEval (packageWith (entryWith dependencies) provider).drvPath).success)
      [
        { invalid = [ ]; }
        { build = "not a list"; }
        { runtime = [ "not a derivation" ]; }
      ];
    assert !(builtins.tryEval (packageWith firstEntry { }).drvPath).success;
    assert
      !(builtins.tryEval
        (packageWith (entryWith { }) (
          builtins.derivation {
            name = "registry-opaque-provider";
            system = pkgs.stdenv.hostPlatform.system;
            builder = "/bin/sh";
          }
        )).drvPath
      ).success;
    assert
      !(builtins.tryEval (packageWith (firstEntry // { dependenciesDeclared = true; }) provider).drvPath)
      .success;
    assert rejects (adapter.decodeInterface (descriptor // { dependenciesDeclared = true; }));
    assert rejects (adapter.decodeInterface (descriptor // { provider.kind = "invalid"; }));
    assert rejects (
      adapter.decodeInterface (
        descriptor
        // {
          provider = {
            kind = "import";
            expression = packageReference [
              "apps"
              "tool"
            ];
          };
        }
      )
    );
    pass "zenpkgs-registry-dependency-support";
}
