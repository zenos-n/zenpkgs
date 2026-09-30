"""Lightweight compiler/schema checks; no backend evaluation, builds, or VM.

Run with PYTHONDONTWRITEBYTECODE=1 python3 tests/check-shell-terminal-options.py
--nixpkgs /path/to/pinned/nixpkgs. Only its lib is imported.
"""
import argparse
import json
from pathlib import Path
import subprocess
import sys
import tempfile

ROOT = Path(__file__).resolve().parents[1]
sys.path.insert(0, str(ROOT / 'lib/zen-dsl'))
from zenlang import parse_file
from zenlang.compiler import compile_zmdl_mount

parser = argparse.ArgumentParser(description=__doc__)
parser.add_argument('--nixpkgs', type=Path, required=True)
args = parser.parse_args()
catalog = json.loads((ROOT / 'tests/fixtures/shell-terminal-options.json').read_text())

# Resolve action conditions for inspection, retaining explicit false/empty values.
# This intentionally does not model backend defaults or runtime behavior.
HELPERS = r'''
  normalize = v:
    if builtins.isList v then map normalize v else
    if !builtins.isAttrs v then v else
    if (v._type or "") == "if" then (if v.condition then normalize v.content else null) else
    if (v._type or "") == "override" then normalize v.content else
    if (v._type or "") == "merge" then merge (map normalize v.contents) else
    lib.filterAttrs (_: x: x != null) (lib.mapAttrs (_: normalize) v);
  merge = xs: lib.foldl' lib.recursiveUpdate {} (builtins.filter (x: x != null) xs);
'''

def lookup(value, path):
    for part in path.split('.'):
        value = value[part]
    return value

with tempfile.TemporaryDirectory(prefix='zen-shell-schema-') as directory:
    tmp = Path(directory)
    for name, entries in catalog.items():
        program = name.startswith('programs/')
        compiled = tmp / 'module.nix'
        compiled.write_text(compile_zmdl_mount(parse_file(ROOT / 'modules' / (name + '.zmdl')), root=ROOT))
        subprocess.run(['nix-instantiate', '--parse', str(compiled)], check=True, stdout=subprocess.DEVNULL)
        samples = {x['name']: x['sample'] for x in entries}
        if program:
            samples['enable'] = True
        cases = {'defaults': {}, 'sample': samples}
        if program:
            cases['disabled'] = samples | {'enable': False}
            cases['enabledNull'] = {'enable': True}
        for entry in entries:
            if entry['minimum'] is not None:
                cases['invalid_' + entry['name']] = samples | {entry['name']: entry['minimum'] - 1}
                cases['boundary_' + entry['name']] = samples | {entry['name']: entry['minimum']}
        for entry in entries:
            sample = entry['sample']
            if isinstance(sample, (list, dict, str)) and '$type.enum' not in entry['type']:
                cases['empty_' + entry['name']] = samples | {entry['name']: type(sample)()}
        (tmp / 'cases.json').write_text(json.dumps(cases))
        enums = [x['name'] for x in entries if '$type.enum' in x['type']]
        (tmp / 'enums.json').write_text(json.dumps(enums))
        expression = f'''let
  lib = import {args.nixpkgs.resolve()}/lib;
  cases = builtins.fromJSON (builtins.readFile {tmp}/cases.json);
  make = cfg: user: import {compiled} {{ inherit lib cfg user; config = {{}}; pkgs = {{}}; }};
  schema = (make {{}} null).schema;
{HELPERS}
  run = values: let
    cfg = (lib.evalModules {{ modules = [ schema {{ config = values; }} ]; }}).config;
    mounted = make cfg {('"tester"' if program else 'null')};
    actions = merge mounted.actions;
  in {{ inherit cfg; actions = normalize actions;
    shared = normalize (merge (make cfg null).actions);
  }};
  rejects = name: value: !(builtins.tryEval (builtins.deepSeq
    (lib.evalModules {{ modules = [ schema {{ config.${{name}} = value; }} ]; }}).config true)).success;
in assert builtins.all (name: rejects name "INVALID_ENUM" && rejects name [ "INVALID_ENUM" ])
  (builtins.fromJSON (builtins.readFile {tmp}/enums.json));
  lib.mapAttrs (_: run) cases
'''
        (tmp / 'check.nix').write_text(expression)
        result = subprocess.run(['nix-instantiate', '--eval', '--strict', '--json', str(tmp / 'check.nix')], check=True, capture_output=True, text=True, timeout=30)
        results = json.loads(result.stdout)
        defaults = results['defaults']['cfg']
        assert set(defaults) == set(samples), name
        for entry in entries:
            assert defaults[entry['name']] is None, (name, entry['name'])
        def payload(case):
            value = results[case]['actions']
            return value.get('home-manager', {}).get('users', {}).get('tester', {}) if program else value
        if program:
            assert defaults['enable'] is False
            assert payload('disabled') == {}
            assert lookup(payload('enabledNull'), name.replace('/', '.') + '.enable') is True
            shared = results['sample']['shared']['home-manager']['sharedModules'][0]['config']
            assert shared == payload('sample'), name
        for entry in entries:
            for case in (['defaults', 'enabledNull'] if program else ['defaults']):
                try:
                    lookup(payload(case), entry['target'])
                except KeyError:
                    pass
                else:
                    raise AssertionError((name, case, entry['name'], 'null emitted a value'))
            assert lookup(payload('sample'), entry['target']) == entry['expected'], (name, entry['name'])
            case = 'empty_' + entry['name']
            if case in results:
                assert lookup(payload(case), entry['target']) == type(entry['sample'])(), (name, case)
            if entry['minimum'] is not None:
                assert not all(x['assertion'] for x in payload('invalid_' + entry['name'])['assertions'])
                assert all(x['assertion'] for x in payload('boundary_' + entry['name'])['assertions'])
        assert all(x['assertion'] for x in payload('sample').get('assertions', []))
        print(f'{name}: {len(entries)} preferences checked')
print('Passed: 112 preferences, 8 enable switches; compiler/schema checks only.')
