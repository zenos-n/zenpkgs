# Generate a real NixOS activation shell, but replace all unrelated snippets and
# account writes with fixture-only actions. Never activate a real configuration.
{ nixpkgsPath, zenfsModule, zenfsPackage }:
let
  pkgs = import nixpkgsPath { system = "x86_64-linux"; };
  lib = pkgs.lib;
  fixturePackage = pkgs.writeShellScriptBin "zenfs-layout" ''
    case "''${ZENFS_TEST_ROOT-}" in /tmp/zenfs-activation-*) ;; *) exit 2 ;; esac
    exec ${zenfsPackage}/bin/zenfs-layout --root "$ZENFS_TEST_ROOT" "$@"
  '';
  evaluate = extra: (import (nixpkgsPath + "/nixos/lib/eval-config.nix") {
    system = "x86_64-linux";
    modules = [
      zenfsModule
      (import ../lib/zenfs-runtime.nix {
        package = fixturePackage;
        managedUsers.alice = { home = "/Users/alice"; group = "users"; };
      })
      {
        nixpkgs.overlays = [ (_: prev: { zenos.legacy = prev; }) ];
        zenos.system.zenfs.enable = true;
        users.users.alice = { isNormalUser = true; home = "/Users/alice"; };
        system.stateVersion = "26.05";
      }
      extra
    ];
  }).config;
  baseline = evaluate {};
  fixture = evaluate {
    system.activationScripts = lib.mkForce {
      etc = { text = ":"; deps = []; };
      zenfs-hierarchy = baseline.system.activationScripts.zenfs-hierarchy;
      users = {
        deps = baseline.system.activationScripts.users.deps;
        text = ''
          case "''${ZENFS_TEST_SENTINEL-}" in "$ZENFS_TEST_ROOT"/*) ;; *) exit 2 ;; esac
          ${pkgs.coreutils}/bin/touch "$ZENFS_TEST_SENTINEL" || exit 2
          # Exit before NixOS's /run/current-system postamble, even in a broken
          # guard regression. No real account or root-filesystem action runs.
          exit 0
        '';
      };
    };
  };
in
pkgs.writeShellScript "zenfs-activation-fixture" fixture.system.activationScripts.script
