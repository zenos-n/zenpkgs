"""Verify Galeria module defaults and opt-in desktop associations."""
import json
from pathlib import Path
import subprocess
import sys
import tempfile
ROOT=Path(__file__).resolve().parents[1]
sys.path.insert(0,str(ROOT/'lib/zen-dsl'))
from zenlang import parse_file
from zenlang.compiler import compile_zmdl_mount,compile_zpkg
with tempfile.TemporaryDirectory(prefix='zen-galeria-') as temporary:
    module=Path(temporary)/'module.nix'
    module.write_text(compile_zmdl_mount(parse_file(ROOT/'modules/programs/galeria.zmdl'),root=ROOT))
    package=Path(temporary)/'package.nix'
    package.write_text(compile_zpkg(parse_file(ROOT/'pkgs/apps/graphics/galeria.zpkg')))
    for file in [module,package]:subprocess.run(['nix-instantiate','--parse',str(file)],check=True,stdout=subprocess.DEVNULL)
    expression='''
let
 lib=import <nixpkgs/lib>;
 package={type="derivation";outPath="/galeria";};
 pkgs.zenos.com.neg-zero.Galeria=package;
 make = values: user: import MODULE {inherit lib pkgs user;cfg=values;config={};};
 schema=(make {} null).schema;
 evaluate=values:(lib.evalModules {modules=[schema {config=values;}];}).config;
 actions=values:(make (evaluate values) "alex").actions;
in {defaults=evaluate {};disabled=actions {};enabled=actions {enable=true;};viewer=actions {enable=true;defaultViewer=true;};startup=actions {enable=true;startAtLogin=true;};noStartup=actions {enable=true;startAtLogin=false;};}
'''.replace('MODULE',str(module))
    process=subprocess.run(['nix-instantiate','--eval','--strict','--json','--expr',expression],capture_output=True,text=True,timeout=30)
    if process.returncode:raise RuntimeError(process.stderr)
    result=json.loads(process.stdout)
    assert result['defaults']['startAtLogin'] is None
    assert result['defaults']['enable'] is False and result['defaults']['defaultViewer'] is False
    assert result['disabled'][0]['home-manager']['users']['alex']['condition'] is False
    enabled=result['enabled'][0]['home-manager']['users']['alex']['content']
    assert enabled['xdg']['configFile']=={}
    for key,hidden in [('startup','false'),('noStartup','true')]:
        launcher=result[key][0]['home-manager']['users']['alex']['content']['xdg']['configFile']['autostart/com.neg-zero.Galeria.desktop']['text']
        assert 'Exec=/galeria/bin/galeria --background' in launcher and 'Hidden='+hidden in launcher
    assert enabled['home']['packages']==['/galeria'] and enabled['xdg']['mimeApps']=={}
    viewer=result['viewer'][0]['home-manager']['users']['alex']['content']['xdg']['mimeApps']
    assert viewer['enable'] is True
    assert len(viewer['defaultApplications'])==11
    assert all(value==['com.neg-zero.Galeria.desktop'] for value in viewer['defaultApplications'].values())
    assert set(enabled)=={'home','xdg'} and 'activation' not in enabled['home']
    print('Galeria package syntax/module defaults/associations: OK')
