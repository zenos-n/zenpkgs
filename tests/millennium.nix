{ nixpkgs, zenosModule }:
let
  lib = nixpkgs.lib;
  contains = needle: content: lib.hasInfix (builtins.unsafeDiscardStringContext needle) content;
  evaluate = settings: lib.nixosSystem {
    system = "x86_64-linux";
    modules = [ zenosModule {
      system.stateVersion = "26.05";
      nixpkgs.config.allowUnfree = true;
    } settings ];
  };
  defaults = evaluate { };
  disabled = evaluate { zenos.system.gaming.steam.millennium = false; };
  enabled = evaluate {
    zenos.system.gaming.steam = {
      enable = true;
      millennium = true;
      runtimeLibraries = [ ];
    };
  };
  pkgs = enabled.pkgs;
  steam = pkgs.zenos.legacy.steam;
  runtime = pkgs.zenos.byCategories.apps.gaming.millennium;
  overridden = steam.override { extraEnv.MILLENNIUM_TEST = "retained"; };
  curated = pkgs.zenos.byCategories.apps.gaming.steam;
  curatedWrapper = curated.buildCommand;
  gamescope = pkgs.zenos.byCategories.apps.gaming.steam-gamescope;
  gamescopeWrapper = gamescope.installPhase;
in
assert defaults.config.zenos.system.gaming.steam.millennium == null;
assert disabled.pkgs.zenos.byCategories.apps.gaming.steam.drvPath
  == defaults.pkgs.zenos.byCategories.apps.gaming.steam.drvPath;
assert curated.drvPath != defaults.pkgs.zenos.byCategories.apps.gaming.steam.drvPath;
assert contains "${runtime}/lib/libmillennium_x86.so" steam.args.profile;
assert contains "${runtime}/lib/libmillennium_x64.so" overridden.args.profile;
assert contains "MILLENNIUM_TEST=retained" overridden.args.profile;
assert contains "STEAM_EXTRA_COMPAT_TOOLS_PATHS" curated.args.profile;
assert contains "zen-compat" curatedWrapper;
assert contains curated.outPath gamescopeWrapper;
assert enabled.config.programs.steam.enable;
assert contains "MILLENNIUM_RUNTIME_PATH" enabled.config.programs.steam.package.args.profile;
pkgs.runCommand "millennium-integration-check" { } ''
  test -x ${curated}/bin/steam
  for library in libmillennium_x86.so libmillennium_x64.so \
    libmillennium_bootstrap_x86.so libmillennium_bootstrap_hhx64.so \
    libmillennium_bootstrap_x64.so; do
    test -s ${runtime}/lib/$library
  done
  touch "$out"
''
