{
  index ? import ../../scripts/gen-docs.nix,
}:
let
  user = index.options.users.sub."<name>";
  checks = {
    systemPrograms = index.options.system.sub.programs.sub.zenlink.sub.enable.meta.typeName == "bool";
    userPrograms = user.sub.programs.sub.zenlink.sub.enable.meta.typeName == "bool";
    systemProgramVersion = index.options.system.sub.programs.sub.zenlink.sub.enable.meta.zenosVersion == "1.0.0Na";
    userProgramVersion = user.sub.programs.sub.zenlink.sub.enable.meta.zenosVersion == "1.0.0Na";
    desktop = index.options.desktops.sub.gnome.sub.enable.meta.typeName == "bool";
    legacy = index.options.legacy.sub.networking.sub.hostName.meta.traversal == "complete";
    syncthingAlias = index.options.system.sub.syncthing.meta.upstream;
    syncthingBoolean = index.options.system.sub.syncthing.sub.enable.meta.typeName == "bool";
    syncthingString = index.options.system.sub.syncthing.sub.guiAddress.meta.typeName == "str";
    syncthingMetadata = index.options.system.sub.syncthing.meta.name == "Syncthing";
    nixosUser = user.sub.legacy.sub.isNormalUser.meta.typeName == "bool";
    homeManager = user.sub.legacy.sub.homeManager.sub.home.sub.stateVersion.meta.typeName == "enum";
    systemPackages = index.options.system.sub.packages.meta.typeName == "zstr-package-selectors";
    userPackages = user.sub.packages.meta.typeName == "zstr-package-selectors";
    packageHierarchy = index.pkgs.apps.sub.browsers.sub.firefox.meta.id == "pkgs.apps.browsers.firefox";
    legacyPackage = index.pkgs.legacy.sub.hello.meta.upstream;
    excludedUniverse = !(index.pkgs.legacy.sub ? pkgsCross);
    noPhantomRoots =
      !(index.options ? programs) && !(index.options ? packages) && !(index.options.legacy.sub ? zenos);
    sourceWarnings = index.metadata.warnings != [ ];
    sampleJSON = builtins.isString (
      builtins.toJSON {
        option = index.options.legacy.sub.networking.sub.hostName;
        package = index.pkgs.apps.sub.browsers.sub.firefox;
        program = index.options.system.sub.programs.sub.zenlink;
      }
    );
  };
in
assert builtins.all (
  name: if checks.${name} then true else throw "search production failed: ${name}"
) (builtins.attrNames checks);
checks
