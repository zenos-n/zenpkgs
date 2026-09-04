{
  pkgs,
  zenDsl,
}:

pkgs.testers.runNixOSTest {
  name = "zenos-dsl-vm";

  nodes.machine = {
    environment.systemPackages = [
      pkgs.jq
      pkgs.nix
      zenDsl
    ];

    environment.etc."zen-dsl-valid/modules/programs/demo.zmdl".text = ''
      enable = enableOption {
        !! { genericRoute = true; };
        s!! {
          systemRoute = true;
          environment.systemPackages = with $pkgs.zenos.legacy; [ bash ];
        };
        u!! { userRoute = true; };
      };
    '';
    environment.etc."zen-dsl-invalid-id/modules/programs/demo.zmdl".text = ''
      _meta.id = "zenos.programs.demo";
      value = true;
    '';
    environment.etc."zen-dsl-invalid-with/bare.zpkg".text = ''
      value = with $pkgs; git;
    '';
    environment.etc."zen-dsl-invalid-with/lib.zpkg".text = ''
      value = with $pkgs.lib; id;
    '';
    environment.etc."zen-dsl-invalid-with/stdenv.zpkg".text = ''
      value = with $pkgs.stdenv; mkDerivation;
    '';
    environment.etc."zen-dsl-wrong-root/marker".text = "";

    environment.etc."zen-dsl-freeform/modules/users.zmdl".text = ''
      enabled = enableOption { _meta.default = true; };
      (freeform user) = {
        isNormalUser = { _meta.type = $type.bool; _meta.default = false; };
        profiles = {
          (freeform profile) = {
            label = { _meta.type = $type.string; _meta.default = "default"; };
            s!! {
              zenTest.users.($f.user).profiles.($f.profile) =
                $lib.concatStringsSep ":" [ $f.user $f.profile $path.($f.user).profiles.($f.profile).label ];
            };
          };
        };
        s!! {
          users.users.($f.user).isNormalUser = $path.($f.user).isNormalUser;
          zenTest.users.($f.user).description = $f.user;
          zenTest.users.fixed.members = [ $f.user ];
          zenTest.names = $lib.map (ignored: $f.user) [ true ];
        };
      };
    '';
    environment.etc."zen-dsl-freeform/modules/system/disks.zmdl".text = ''
      (freeform device) = {
        s!! {
          disko.devices.($f.device) = $path.($f.device);
        };
      };
    '';
    environment.etc."zen-dsl-freeform/modules/system/syncthing.zmdl".text = ''
      (freeform setting) = {
        s!! {
          services.syncthing.($f.setting) = $path.($f.setting);
        };
      };
    '';
    environment.etc."zen-dsl-freeform/modules/system/packages.zmdl".text = ''
      (freeform package) = {
        _meta.type = $type.package;
        s!! {
          environment.systemPackages = $lib.optional
            ($lib.isDerivation $path.($f.package))
            $path.($f.package);
        };
      };
    '';
    environment.etc."zen-dsl-freeform/helpers/imported-base.zmdl".text = ''
      (freeform item) = {
        settings.first = { _meta.type = $type.bool; _meta.default = false; };
        s!! { zenTest.imported.($f.item).first = $path.($f.item).settings.first; };
      };
    '';
    environment.etc."zen-dsl-freeform/modules/imported.zmdl".text = ''
      _import "../helpers/imported-base.zmdl";
      (freeform item) = {
        settings = {
          second = { _meta.type = $type.bool; _meta.default = false; };
        };
        s!! { zenTest.imported.($f.item).second = $path.($f.item).settings.second; };
      };
    '';
    environment.etc."zen-dsl-freeform/modules/conditional.zmdl".text = ''
      (freeform feature) = {
        _meta.type = $type.bool;
        s! { zenTest.conditional.($f.feature) = true; };
        s!! { zenTest.unconditional.($f.feature) = true; };
      };
    '';
    environment.etc."zen-dsl-freeform/modules/bindings.zmdl".text = ''
      (freeform item) = {
        s!! {
          _let record: $type.set [ $type.string ] = { copied = $f.item; };
          _let direct: $type.string = $f.item;
          zenTest.bound.($f.item) = $v.record.copied;
          inherit ($v.record) copied;
          inherit direct;
        };
      };
    '';
    environment.etc."zen-dsl-freeform/eval.nix".text = ''
      let
        pkgs = import ${pkgs.path} { system = builtins.currentSystem; };
        lib = pkgs.lib;
        evaluated = lib.evalModules {
          specialArgs = { inherit pkgs; };
          modules = [
            /tmp/zen-dsl-users.nix
            /tmp/zen-dsl-system-disks.nix
            /tmp/zen-dsl-system-syncthing.nix
            /tmp/zen-dsl-system-packages.nix
            /tmp/zen-dsl-imported.nix
            /tmp/zen-dsl-conditional.nix
            /tmp/zen-dsl-bindings.nix
            ({ lib, pkgs, ... }: {
              options.users.users = lib.mkOption {
                type = lib.types.attrsOf lib.types.anything;
                default = { };
              };
              options.disko.devices.disk = lib.mkOption {
                type = lib.types.attrsOf lib.types.anything;
                default = { };
              };
              options.services.syncthing.folders = lib.mkOption {
                type = lib.types.attrsOf lib.types.anything;
                default = { };
              };
              options.environment.systemPackages = lib.mkOption {
                type = lib.types.listOf lib.types.package;
                default = [ ];
              };
              options.zenTest.users = lib.mkOption {
                type = lib.types.attrsOf (lib.types.submodule ({ ... }: {
                  options.description = lib.mkOption {
                    type = lib.types.str;
                    default = "";
                  };
                  options.members = lib.mkOption {
                    type = lib.types.listOf lib.types.str;
                    default = [ ];
                  };
                  options.profiles = lib.mkOption {
                    type = lib.types.attrsOf lib.types.str;
                    default = { };
                  };
                }));
                default = { };
              };
              options.zenTest.names = lib.mkOption {
                type = lib.types.listOf lib.types.str;
                default = [ ];
              };
              options.zenTest.imported = lib.mkOption {
                type = lib.types.attrsOf (lib.types.submodule ({ ... }: {
                  options.first = lib.mkOption {
                    type = lib.types.bool;
                    default = false;
                  };
                  options.second = lib.mkOption {
                    type = lib.types.bool;
                    default = false;
                  };
                }));
                default = { };
              };
              options.zenTest.conditional = lib.mkOption {
                type = lib.types.attrsOf lib.types.bool;
                default = { };
              };
              options.zenTest.unconditional = lib.mkOption {
                type = lib.types.attrsOf lib.types.bool;
                default = { };
              };
              options.zenTest.bound = lib.mkOption {
                type = lib.types.attrsOf lib.types.str;
                default = { };
              };
              options.copied = lib.mkOption {
                type = lib.types.str;
                default = "";
              };
              options.direct = lib.mkOption {
                type = lib.types.str;
                default = "";
              };

              config.zenos.users.alice.isNormalUser = true;
              config.zenos.users.alice.profiles.work.label = "primary";
              config.zenos.system.disks.disk.main.device = "/dev/vda";
              config.zenos.system.syncthing.folders.shared.path = "/srv/shared";
              config.zenos.system.packages.hello = pkgs.hello;
              config.zenos.imported.demo.settings.first = true;
              config.zenos.imported.demo.settings.second = true;
              config.zenos.conditional.enabled = true;
              config.zenos.conditional.disabled = false;
              config.zenos.bindings.alpha = true;
            })
          ];
        };
      in
      {
        user = evaluated.config.users.users.alice.isNormalUser;
        disk = evaluated.config.disko.devices.disk.main.device;
        syncthing = evaluated.config.services.syncthing.folders.shared.path;
        packages = map lib.getName evaluated.config.environment.systemPackages;
        description = evaluated.config.zenTest.users.alice.description;
        fixedMembers = evaluated.config.zenTest.users.fixed.members;
        profile = evaluated.config.zenTest.users.alice.profiles.work;
        names = evaluated.config.zenTest.names;
        imported = evaluated.config.zenTest.imported.demo;
        conditional = evaluated.config.zenTest.conditional;
        unconditional = evaluated.config.zenTest.unconditional;
        bound = evaluated.config.zenTest.bound;
        copied = evaluated.config.copied;
        direct = evaluated.config.direct;
      }
    '';
  };

  testScript = ''
    machine.start()
    for tree in [
        "zen-dsl-valid",
        "zen-dsl-invalid-id",
        "zen-dsl-invalid-with",
        "zen-dsl-wrong-root",
        "zen-dsl-freeform",
    ]:
        machine.succeed(f"mkdir -p /run/{tree}; cp -aL /etc/{tree}/. /run/{tree}/")
    machine.succeed(
      "rm /run/zen-dsl-valid/modules/programs/demo.zmdl; "
      "ln -s $(readlink -f /etc/zen-dsl-valid/modules/programs/demo.zmdl) "
      "/run/zen-dsl-valid/modules/programs/demo.zmdl"
    )
    machine.succeed(
      "zen-dsl compile /run/zen-dsl-valid/modules/programs/demo.zmdl "
      "--root /run/zen-dsl-valid -o /tmp/demo.nix"
    )
    machine.succeed("grep -F 'moduleIdentity = \"zenos.programs.demo\";' /tmp/demo.nix")
    machine.succeed("grep -F 'descriptorVersion = \"zenlang.semantic/2\";' /tmp/demo.nix")
    machine.succeed("grep -F 'genericRoute = true;' /tmp/demo.nix")
    machine.succeed("grep -F 'systemRoute = true;' /tmp/demo.nix")
    machine.succeed("grep -F 'home-manager.sharedModules' /tmp/demo.nix")
    machine.succeed("grep -F 'userRoute = true;' /tmp/demo.nix")
    machine.fail("grep -F 'compileTarget' /tmp/demo.nix")

    machine.succeed(
      "zen-dsl compile-tree --root /run/zen-dsl-valid "
      "--output /tmp/bundle.json --mode interface"
    )
    machine.succeed(
      "jq -e '.bundleVersion == \"zenlang.bundle/2\" and "
      "all(.sources[]; .descriptor.descriptorVersion == \"zenlang.semantic/2\") and "
      ".modules == [{identity: \"zenos.programs.demo\", "
      "optionPath: [\"zenos\", \"programs\", \"demo\"], "
      "path: \"modules/programs/demo.zmdl\"}]' /tmp/bundle.json"
    )

    machine.fail(
      "zen-dsl compile /run/zen-dsl-valid/modules/programs/demo.zmdl "
      "-o /tmp/missing-root.nix"
    )
    machine.fail(
      "zen-dsl compile /run/zen-dsl-valid/modules/programs/demo.zmdl "
      "--root /run/zen-dsl-wrong-root -o /tmp/wrong-root.nix"
    )
    machine.fail(
      "zen-dsl compile /run/zen-dsl-valid/modules/programs/demo.zmdl "
      "--root /run/zen-dsl-valid --option-path programs.demo"
    )
    machine.fail(
      "zen-dsl compile /run/zen-dsl-invalid-id/modules/programs/demo.zmdl "
      "--root /run/zen-dsl-invalid-id -o /tmp/authored-id.nix"
    )
    machine.fail("zen-dsl check-tree --root /run/zen-dsl-invalid-id")

    machine.fail("zen-dsl check /run/zen-dsl-invalid-with/bare.zpkg")
    machine.fail("zen-dsl check /run/zen-dsl-invalid-with/lib.zpkg")
    machine.fail("zen-dsl check /run/zen-dsl-invalid-with/stdenv.zpkg")

    for module in [
        "users",
        "system/disks",
        "system/syncthing",
        "system/packages",
        "imported",
        "conditional",
        "bindings",
    ]:
        output = module.replace("/", "-")
        machine.succeed(
            f"zen-dsl compile /run/zen-dsl-freeform/modules/{module}.zmdl "
            f"--root /run/zen-dsl-freeform -o /tmp/zen-dsl-{output}.nix"
        )
    machine.succeed(
      "nix-instantiate --eval --strict --json /run/zen-dsl-freeform/eval.nix "
      "| jq -e '.user == true and .disk == \"/dev/vda\" "
      "and .syncthing == \"/srv/shared\" and (.packages | index(\"hello\") != null) "
      "and .description == \"alice\" and .fixedMembers == [\"alice\"] "
      "and .profile == \"alice:work:primary\" and .names == [\"alice\"] "
      "and .imported == {first: true, second: true} "
      "and .conditional == {enabled: true} "
      "and .unconditional == {disabled: true, enabled: true} "
      "and .bound == {alpha: \"alpha\"} "
      "and .copied == \"alpha\" and .direct == \"alpha\"'"
    )

    machine.succeed(
      "mkdir -p /run/zen-dsl-links/home /run/zen-dsl-links/logical; "
      "printf 'value = true;' > /run/zen-dsl-links/home/source.zcfg; "
      "ln -s home /run/zen-dsl-links/Users; "
      "ln -s /run/zen-dsl-links/Users/source.zcfg /run/zen-dsl-links/logical/entry.zcfg; "
      "zen-dsl check /run/zen-dsl-links/logical/entry.zcfg"
    )
    machine.succeed(
      "mkdir -p /run/zen-dsl-links/outside; "
      "printf 'outside = true;' > /run/zen-dsl-links/outside/attack.zcfg; "
      "ln -s /run/zen-dsl-links/outside /run/zen-dsl-links/logical/linked"
    )
    machine.fail(
      "zen-dsl check /run/zen-dsl-links/logical/linked/attack.zcfg "
      "--import-root /run/zen-dsl-links/logical"
    )
    machine.succeed(
      "ln -s loop-b /run/zen-dsl-links/loop-a; "
      "ln -s loop-a /run/zen-dsl-links/loop-b; "
      "ln -s /run/zen-dsl-links/loop-a/source.zcfg /run/zen-dsl-links/logical/loop.zcfg"
    )
    machine.fail("zen-dsl check /run/zen-dsl-links/logical/loop.zcfg")

    machine.succeed(
      "mkdir -p /run/zen-dsl-aliases/left /run/zen-dsl-aliases/right; "
      "printf '_import \"child.zcfg\";' > /run/zen-dsl-aliases/template; "
      "printf 'left = true;' > /run/zen-dsl-aliases/left/child.zcfg; "
      "printf 'right = true;' > /run/zen-dsl-aliases/right/child.zcfg; "
      "ln -s ../template /run/zen-dsl-aliases/left/alias.zcfg; "
      "ln -s ../template /run/zen-dsl-aliases/right/alias.zcfg; "
      "printf '_import \"left/alias.zcfg\"; _import \"right/alias.zcfg\";' "
      "> /run/zen-dsl-aliases/entry.zcfg; "
      "zen-dsl compile /run/zen-dsl-aliases/entry.zcfg "
      "--import-root /run/zen-dsl-aliases -o /tmp/zen-dsl-aliases.nix; "
      "grep -F 'left = true;' /tmp/zen-dsl-aliases.nix; "
      "grep -F 'right = true;' /tmp/zen-dsl-aliases.nix"
    )
  '';
}
