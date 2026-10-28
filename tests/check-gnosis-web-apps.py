"""Check Gnosis's named web-app schema and generated desktop entries without a build."""

import json
from pathlib import Path
import subprocess
import sys
import tempfile

ROOT = Path(__file__).resolve().parents[1]
sys.path.insert(0, str(ROOT / "lib/zen-dsl"))
from zenlang import parse_file
from zenlang.compiler import compile_zmdl_mount


with tempfile.TemporaryDirectory(prefix="zen-gnosis-apps-") as temporary:
    module = Path(temporary) / "module.nix"
    module.write_text(compile_zmdl_mount(parse_file(ROOT / "modules/programs/gnosis.zmdl"), root=ROOT))
    subprocess.run(["nix-instantiate", "--parse", str(module)], check=True, stdout=subprocess.DEVNULL)
    expression = f'''
let
  lib = import <nixpkgs/lib>;
  package = {{ type = "derivation"; outPath = "/gnosis"; }};
  pkgs = {{ zenos.byCategories.apps.browsers.gnosis = package; }};
  make = values: user: (import {module}) {{ inherit lib pkgs user; cfg = values; config = {{}}; }};
  schema = (make {{}} null).schema;
  evaluate = values: (lib.evalModules {{ modules = [ schema {{ config = values; }} ]; }}).config;
  actions = values: (make (evaluate values) "alex").actions;
  valid = {{ enable = true; apps.mail = {{ name = "Mail"; url = "https://mail.example/path?q=1%20a"; }}; }};
  badKey = {{ enable = true; apps."bad/key" = {{ name = "Bad"; url = "https://example.com"; }}; }};
  badUrl = {{ enable = true; apps.mail = {{ name = "Mail"; url = "file:///etc/passwd"; }}; }};
in {{
  enabled = actions valid;
  defaultBrowser = actions (valid // {{ defaultBrowser = true; }});
  empty = actions {{ enable = true; }};
  disabled = actions (valid // {{ enable = false; }});
  renamed = actions (valid // {{ apps.mail = {{ name = "Inbox"; url = "https://mail.example/"; }}; }});
  badKey = actions badKey;
  badUrl = actions badUrl;
}}
'''
    output = subprocess.run(
        ["nix-instantiate", "--eval", "--strict", "--json", "--expr", expression],
        check=True, capture_output=True, text=True, timeout=30,
    )
    result = json.loads(output.stdout)
    enabled = result["enabled"][0]["home-manager"]["users"]["alex"]["content"]
    entry = enabled["xdg"]["desktopEntries"]["com.neg-zero.Gnosis.WebApp_mail"]
    assert entry["name"] == "Mail"
    assert entry["icon"] == "web-browser"
    assert entry["exec"] == '/gnosis/bin/gnosis --application-mode=com.neg-zero.Gnosis.WebApp_mail.desktop "https://mail.example/path?q=1%%20a"'
    assert entry["settings"]["X-Gnosis-Declarative"] == "true"
    assert enabled["home"]["packages"] == ["/gnosis"]
    defaults = result["defaultBrowser"][0]["home-manager"]["users"]["alex"]["content"]["xdg"]["mimeApps"]
    assert defaults["enable"] is True
    assert defaults["defaultApplications"] == {
        kind: ["com.neg-zero.Gnosis.desktop"]
        for kind in ("x-scheme-handler/http", "x-scheme-handler/https", "text/html", "application/xhtml+xml")
    }
    assert enabled["assertions"][0]["assertion"] is True
    empty = result["empty"][0]["home-manager"]["users"]["alex"]["content"]
    assert empty["xdg"]["desktopEntries"] == {}
    assert result["disabled"][0]["home-manager"]["users"]["alex"]["condition"] is False
    renamed = result["renamed"][0]["home-manager"]["users"]["alex"]["content"]
    assert "com.neg-zero.Gnosis.WebApp_mail" in renamed["xdg"]["desktopEntries"]
    for case in ("badKey", "badUrl"):
        invalid_action = result[case][0]["home-manager"]["users"]["alex"]["content"]
        assert invalid_action["assertions"][0]["assertion"] is False
    print("Gnosis web-app module: OK")
