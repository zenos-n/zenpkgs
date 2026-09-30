# Run inside the ZenOS VM against the pinned real backend schemas.
{ nixpkgsPath, homeManagerPath, bundlePath, runtimePath, searchPath, catalogPath }:
let
  pkgs = import nixpkgsPath { system = "x86_64-linux"; };
  inherit (pkgs) lib;
  runtime = import runtimePath { inherit lib; };
  bundle = builtins.fromJSON (builtins.readFile bundlePath);
  catalog = builtins.fromJSON (builtins.readFile catalogPath);
  evaluate = extra: import (nixpkgsPath + "/nixos/lib/eval-config.nix") {
    system = "x86_64-linux";
    modules = [
      (homeManagerPath + "/nixos")
      (runtime.moduleFromBundle { inherit bundle; packageTree = {}; })
      {
        system.stateVersion = "26.05";
        users.users.alice = { isNormalUser = true; home = "/Users/alice"; };
        home-manager.users.alice.home.stateVersion = "26.05";
      }
      extra
    ];
  };
  base = evaluate { zenos.users.alice = {}; };
  namedEnable = evaluate {
    zenos.users.enable.profile = { normalUser = true; displayName = "Enable User"; };
    home-manager.users.enable.home.stateVersion = "26.05";
  };
  configured = evaluate {
    zenos.users.alice = {
      profile = { groups = [ "research" ]; passwordHashFile = "/run/secrets/alice-hash"; };
      shell.aliases = { ll = "ls -l"; };
      locale = { currencyFormat = "pl_PL.UTF-8"; dateTimeFormat = "en_GB.UTF-8"; };
      defaultApps = { enable = true; browser = "firefox.desktop"; };
      fonts = { enable = true; smoothEdges = false; };
      theming.gnome = { showBatteryPercentage = false; shortcuts.openCalculator = []; };
    };
  };
  hm = configured.config.home-manager.users.alice;
  negativeUid = evaluate { zenos.users.alice.profile.uid = -1; };
  relativeHome = evaluate { zenos.users.alice.profile.homeDirectory = "relative/home"; };
  relativeHash = evaluate { zenos.users.alice.profile.passwordHashFile = "relative/hash"; };
  relativeFolder = evaluate { zenos.users.alice.userDirs.documents = "relative/docs"; };
  invalidZoom = evaluate { zenos.users.alice.theming.gnome.magnification.zoom = 100.0; };
  invalidSpeed = evaluate { zenos.users.alice.theming.gnome.mouse.speed = 2.0; };
  invalidType = evaluate { zenos.users.alice.theming.gnome.clock.format = "invalid"; };
  hasFailure = text: assertions: builtins.any (a: lib.hasInfix text a.message && !a.assertion) assertions;
  index = (import searchPath { inherit lib; }).mkIndex {
    evaluated = base;
    inherit bundle;
  };
  userTree = index.options.users.sub."<name>";
  lookup = path: tree: if path == [] then tree else
    lookup (builtins.tail path) tree.sub.${builtins.head path};
  paths = lib.concatLists (lib.mapAttrsToList (group: opts:
    map (o: lib.splitString "." (builtins.replaceStrings [ "/" ] [ "." ] group + "." + o.name)) opts
  ) catalog);
  checks = {
    unsetPreservesAccount = base.config.users.users.alice.description == "" && base.config.users.users.alice.extraGroups == [];
    unsetDoesNotChangeSession = base.config.home-manager.users.alice.home.sessionVariables == {};
    unsetLeavesDconfEmpty = lib.all (values: values == {}) (builtins.attrValues base.config.home-manager.users.alice.dconf.settings);
    enableIsAValidAccountName = namedEnable.config.users.users.enable.description == "Enable User";
    noPhantomAccounts = builtins.attrNames base.config.zenos.users == [ "alice" ];
    groupsAreTargeted = configured.config.users.users.alice.extraGroups == [ "research" ];
    runtimeSecretStaysAPath = configured.config.users.users.alice.hashedPasswordFile == "/run/secrets/alice-hash";
    aliasesAreTargeted = hm.home.shellAliases.ll == "ls -l";
    regionalFormats = hm.home.language.monetary == "pl_PL.UTF-8" && hm.home.language.time == "en_GB.UTF-8";
    browserAssociations = hm.xdg.mimeApps.defaultApplications."x-scheme-handler/https" == [ "firefox.desktop" ];
    explicitFalseIsPreserved = hm.fonts.fontconfig.antialiasing == false && hm.dconf.settings."org/gnome/desktop/interface".show-battery-percentage == false;
    emptyShortcutIsTyped = hm.dconf.settings."org/gnome/settings-daemon/plugins/media-keys".calculator.type == "as";
    negativeUidRejected = hasFailure "UID must" negativeUid.config.assertions;
    relativeHomeRejected = hasFailure "homeDirectory must" relativeHome.config.assertions;
    relativeSecretRejected = hasFailure "passwordHashFile must" relativeHash.config.assertions;
    relativeFolderRejected = hasFailure "documents must" relativeFolder.config.home-manager.users.alice.assertions;
    excessiveZoomRejected = hasFailure "magnification.zoom" invalidZoom.config.home-manager.users.alice.assertions;
    excessiveSpeedRejected = hasFailure "mouse.speed" invalidSpeed.config.home-manager.users.alice.assertions;
    invalidEnumRejected = !(builtins.tryEval invalidType.config.zenos.users.alice.theming.gnome.clock.format).success;
    allOptionsExported = lib.all (path: let node = lookup path userTree; in
      node.meta ? typeName && node.meta.traversal == "complete" && builtins.isString node.meta.description
    ) paths;
    allDefaultsUnset = lib.all (path: lib.getAttrFromPath path base.config.zenos.users.alice == null) paths;
  };
in assert lib.all (name: if checks.${name} then true else throw "user option check failed: ${name}") (builtins.attrNames checks);
{ inherit checks; optionCount = builtins.length paths; }
