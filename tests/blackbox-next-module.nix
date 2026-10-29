{ nixpkgs, homeManager, moduleFile }:
let
  base = import (nixpkgs + "/lib");
  lib = base // { gvariant = import (homeManager + "/modules/lib/gvariant.nix") { lib = base; }; };
  package = { type = "derivation"; outPath = "/nix/store/blackbox-test"; drvPath = "/nix/store/blackbox-test.drv"; };
  pkgs.zenos = {
    byCategories.apps.terminal.blackbox-next = package;
    legacy.xdg-terminal-exec = package;
  };
  make = cfg: user: import moduleFile { inherit lib cfg pkgs user; config = {}; };
  schema = (make {} null).schema;
  normalize = v:
    if builtins.isList v then map normalize v else
    if !builtins.isAttrs v then v else
    if (v._type or "") == "if" then (if v.condition then normalize v.content else {}) else
    if (v._type or "") == "override" then normalize v.content else
    if (v._type or "") == "merge" then merge (map normalize v.contents) else
    lib.mapAttrs (_: normalize) v;
  merge = xs: lib.foldl' lib.recursiveUpdate {} xs;
  run = values: let
    cfg = (lib.evalModules { modules = [schema {config=values;}]; }).config;
    actions = normalize (lib.mkMerge (make cfg "tester").actions);
  in actions.home-manager.users.tester or {};
  defaults = (lib.evalModules {modules=[schema];}).config;
  disabled = run {};
  plain = run {enable=true;};
  selected = run {enable=true;defaultTerminal=true;cursorUseAccent=false;cursorTrail=true;opacity=0;font="";cellWidth=1.5;padding=[0 5 0 5];stylePreference="dark";};
  prefs = selected.dconf.settings."com/neg-zero/BlackBoxNext";
  invalid = run {enable=true;opacity=101;};
in
assert defaults.enable == false && defaults.defaultTerminal == false;
assert lib.all (n: defaults.${n} == null) (builtins.filter (n: !(builtins.elem n ["enable" "defaultTerminal" "package" "_meta"])) (builtins.attrNames defaults));
assert disabled == {};
assert plain.home.packages == [package] && plain.dconf.settings == {} && plain.home.sessionVariables == {};
assert prefs.cursor-use-accent == false && prefs.cursor-trail == true && prefs.font == "";
assert toString prefs.opacity == "@u 0" && toString prefs.terminal-cell-width == "1.500000";
assert toString prefs.style-preference == "@u 2";
assert selected.home.sessionVariables.TERMINAL == "/nix/store/blackbox-test/bin/blackbox-next";
assert selected.xdg.terminal-exec.settings.GNOME == ["com.neg-zero.BlackBoxNext.desktop"];
assert selected.xdg.terminal-exec.package == package;
assert !(lib.all (a: a.assertion) invalid.assertions);
{preferences=lib.mapAttrs (_: v: if builtins.isAttrs v then toString v else v) prefs; defaultTerminal=selected.xdg.terminal-exec.enable;}
