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
  expectedActiveEntries = expectedRegistry.packages;
  registryPaths =
    value:
    map (entry: {
      inherit (entry)
        id
        sourcePath
        target
        ;
    }) (sortPackages value).packages;
  packagePaths = value: map (entry: entry.target) value.packages;
  activePaths = map (entry: entry.target) activeEntries;
  registryPathKeys = map pathKey registry.packages;
  outputName = path: lib.concatStringsSep "-" ([ "zenos" ] ++ path);
  outputIdentities = lib.concatMap (
    entry:
    let
      upstream = lib.attrByPath entry.sourcePath null pkgs;
      overlayPackage = lib.attrByPath ([ "zenos" ] ++ entry.target) null pkgs;
      publicPackage = publicPackages.${outputName entry.target} or null;
    in
    [
      (
        upstream != null
        && overlayPackage != null
        && publicPackage != null
        && overlayPackage.drvPath == upstream.drvPath
        && overlayPackage.outPath == upstream.outPath
        && publicPackage.drvPath == upstream.drvPath
        && publicPackage.outPath == upstream.outPath
      )
    ]
  ) activeEntries;
  pass = name: pkgs.runCommand name { } "touch $out";
  adapter = import ../lib/dsl-bundle.nix { inherit lib; };
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
  incomplete = adapter.decodeInterface (removeAttrs descriptor [ "metadata" ]);
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
  fixtureBuild = builtins.toFile "registry-build.nix" ''
    { pkgs, zpkgRuntime, ... }: zpkgRuntime {
      provider = pkgs.zenos.legacy.hello;
      metadata = builtins.fromJSON ${builtins.toJSON (builtins.toJSON decoded.meta)};
      dependenciesDeclared = false;
    }
  '';
  fixtureBundle = pkgs.runCommand "zenpkgs-registry-adapter-fixture" { } ''
    mkdir -p "$out/interfaces/pkgs/apps/first" "$out/interfaces/pkgs/dev/second"
    mkdir -p "$out/builds/pkgs/apps/first" "$out/builds/pkgs/dev/second"
    cp ${fixtureInterface} "$out/interfaces/pkgs/apps/first/tool.zpkg.nix"
    cp ${fixtureInterface} "$out/interfaces/pkgs/dev/second/tool.zpkg.nix"
    cp ${fixtureBuild} "$out/builds/pkgs/apps/first/tool.zpkg.nix"
    cp ${fixtureBuild} "$out/builds/pkgs/dev/second/tool.zpkg.nix"
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
  firstEntry = builtins.head repeated.packages;
  registryWith = packages: {
    schemaVersion = 1;
    inherit packages;
  };
in
{
  registry-contract =
    assert builtins.toJSON actual == builtins.toJSON expected;
    pass "zenpkgs-package-registry-contract";

  registry-counts =
    assert builtins.length expectedRegistry.packages == 126;
    assert builtins.length expectedActiveEntries == 126;
    assert builtins.length registry.packages == 126;
    assert builtins.length activeEntries == 126;
    pass "zenpkgs-package-registry-counts";

  package-paths =
    assert builtins.length (registryPaths expectedRegistry) == 126;
    assert builtins.length (packagePaths expectedRegistry) == 126;
    assert builtins.length activePaths == 126;
    assert registryPathKeys == lib.sort builtins.lessThan registryPathKeys;
    assert registryPaths registry == registryPaths expectedRegistry;
    assert packagePaths registry == packagePaths expectedSorted;
    pass "zenpkgs-package-registry-paths";

  public-package-outputs =
    assert builtins.length outputIdentities == 126;
    assert lib.all (identity: identity) outputIdentities;
    pass "zenpkgs-public-package-outputs";

  registry-path-identities =
    assert
      map (entry: entry.id) repeated.packages == [
        "pkgs.apps.first.tool"
        "pkgs.dev.second.tool"
      ];
    assert repeatedTree.apps.first.tool.drvPath == pkgs.hello.drvPath;
    assert repeatedTree.dev.second.tool.drvPath == pkgs.hello.drvPath;
    assert
      builtins.attrNames repeatedTree == [
        "apps"
        "dev"
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
      ])).apps.first.tool._zmeta.id == "pkgs.apps.first.tool";
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
    assert rejects (
      adapt (
        bundle
        // {
          sources = [
            structure
            {
              kind = "zpkg";
              path = "pkgs/legacy/tool.zpkg";
            }
          ];
        }
      )
    );
    assert rejects (
      interface.registryDocs (registryWith [
        firstEntry
        firstEntry
      ])
    );
    assert rejects (interface.registryDocs (registryWith [ (firstEntry // { id = "tool"; }) ]));
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
            id = "pkgs.apps.first.tool.child";
            target = firstEntry.target ++ [ "child" ];
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
        }).apps.first.tool;
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
