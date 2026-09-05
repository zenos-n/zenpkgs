{ self, nixpkgs, system, artifact ? "report" }:
let
  evaluated = nixpkgs.lib.nixosSystem {
    inherit system;
    modules = [
      self.nixosModules.default
      {
        zenos = {
          legacy = {
            networking.hostName = "zstr-production";
            system.stateVersion = "26.05";
            boot.loader.grub.enable = false;
            fileSystems."/" = { device = "/dev/test-root"; fsType = "ext4"; };
          };
          system.packages.apps.development-tools.git = true;
          system.packages.apps.system.btop = false;
          users.alice = {
            packages.apps.system.btop = true;
            programs.zenlink = false;
            legacy = {
              isNormalUser = true;
              extraGroups = [ "wheel" ];
              openssh.authorizedKeys.keys = [
                "ssh-ed25519 AAAAC3NzaC1lZDI1NTE5AAAAIAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAA evaluation-only"
              ];
              homeManager.home = {
                stateVersion = "26.05";
                sessionVariables.MOUNT_USER = "alice";
              };
            };
          };
          users.bob = {
            packages.apps.development-tools.nano = true;
            programs.zenlink = false;
            legacy = {
              isNormalUser = true;
              homeManager.home = {
                stateVersion = "26.05";
                sessionVariables.MOUNT_USER = "bob";
              };
            };
          };
        };
      }
    ];
  };
  inherit (evaluated) config pkgs;
  bundle = self.lib.dslBundleFor system;
  lib = nixpkgs.lib;
  sources = builtins.listToAttrs (map (source: { name = source.path; value = source; }) bundle.sources);
  inspectOptions = source: prefix: options: lib.concatLists (lib.mapAttrsToList (name: option:
    let path = prefix ++ [ name ]; in
    if !lib.isOption option then inspectOptions source path option else [ {
      path = lib.showOption path;
      type = option.type.name;
      defaultValid = builtins.addErrorContext "checking ZSTR default ${lib.showOption path} from ${source}:"
        (!(option ? default) || option.type.check option.default);
    } ] ++ inspectOptions source path (option.type.getSubOptions path)
  ) (builtins.removeAttrs options [ "_module" ]));
  schemas = lib.concatMap (mount:
    lib.concatMap (record:
      let
        userMount = builtins.head mount.path == "users";
        users = if userMount then [ "alice" "bob" ] else [ null ];
      in map (user:
        let
          path = map (part: if part == "{user}" then user else part) mount.path
            ++ lib.drop (builtins.length mount.target) (builtins.tail record.optionPath);
          definition = import (builtins.toFile "production-mounted-schema.nix" sources.${record.path}.mountNix) {
            inherit config pkgs user;
            lib = lib // self.lib.dslLibrary;
            cfg = lib.getAttrFromPath path config.zenos;
            freeform = lib.optionalAttrs userMount { inherit user; };
          };
          schema = lib.evalModules { modules = [ definition.schema ]; };
        in { source = record.path; options = inspectOptions record.path path schema.options; }
      ) users
    ) (builtins.filter (record:
      lib.take (builtins.length mount.target) (builtins.tail record.optionPath) == mount.target
    ) bundle.modules)
  ) (builtins.filter (mount: mount.kind == "zmdl") bundle.structure.mounts);
  hasPackage = package: values: builtins.elem package.outPath (map (value: value.outPath) values);
  alice = config.home-manager.users.alice;
  bob = config.home-manager.users.bob;
  suppliedProfiles = (evaluated.extendModules { modules = [ {
    zenos.users.alice.programs.web-apps.profileDir = "/srv/test-alice-profiles";
    zenos.users.bob.programs.web-apps.profileDir = "/srv/test-bob-profiles";
  } ]; }).config;
  invalidProfile = (evaluated.extendModules { modules = [ {
    zenos.users.alice.programs.web-apps.profileDir = 42;
  } ]; }).config;
  fails = value: !(builtins.tryEval (builtins.deepSeq value true)).success;
in
assert config.networking.hostName == "zstr-production";
assert config.users.users.alice.isNormalUser && config.users.users.bob.isNormalUser;
assert alice.home.sessionVariables.MOUNT_USER == "alice";
assert bob.home.sessionVariables.MOUNT_USER == "bob";
assert hasPackage pkgs.zenos.apps.development-tools.git config.environment.systemPackages;
assert !(hasPackage pkgs.zenos.apps.system.btop config.environment.systemPackages);
assert hasPackage pkgs.zenos.apps.system.btop alice.home.packages;
assert !(hasPackage pkgs.zenos.apps.system.btop bob.home.packages);
assert hasPackage pkgs.zenos.apps.development-tools.nano bob.home.packages;
assert !(config.zenos ? programs);
assert builtins.any (warning: lib.hasInfix "modules/system/version.zmdl:" warning) config.warnings;
assert fails config.zenos.system.programs.web-apps.profileDir;
assert fails config.zenos.users.alice.programs.web-apps.profileDir;
assert fails config.zenos.users.bob.programs.web-apps.profileDir;
assert suppliedProfiles.zenos.users.alice.programs.web-apps.profileDir == "/srv/test-alice-profiles";
assert suppliedProfiles.zenos.users.bob.programs.web-apps.profileDir == "/srv/test-bob-profiles";
assert fails invalidProfile.zenos.users.alice.programs.web-apps.profileDir;
assert builtins.all (schema: builtins.all (option: option.defaultValid) schema.options) schemas;
if artifact != "report" then {
  system = config.system.build.toplevel;
  alice = alice.home.activationPackage;
  bob = bob.home.activationPackage;
}.${artifact} else
{
  moduleCount = builtins.length bundle.modules;
  schemaInstanceCount = builtins.length schemas;
  schemaOptionCount = builtins.length (lib.concatMap (schema: schema.options) schemas);
  inherit schemas;
  metadataWarningCount = builtins.length config.warnings;
  systemDerivation = config.system.build.toplevel.drvPath;
  aliceActivation = alice.home.activationPackage.drvPath;
  bobActivation = bob.home.activationPackage.drvPath;
  twoUserIsolation = true;
  productionPackageSelectors = true;
  requiredProfileDir = true;
}
