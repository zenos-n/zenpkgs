{ config, lib, pkgs, maintainers ? lib.maintainers, licenses ? lib.licenses, ... }:
let
  cfg = config.zenos.desktops.gnome.extensions.forge;
  name = "forge";
  formatPart = (builtins.addErrorContext "_let formatPart annotation mismatch: /nix/store/3ni594f60hm22hcrazxd35dmk7pwi61m-zenpkgs-dsl-source/modules/desktops/gnome/extensions/forge.zmdl:21:1" ((_zenType: _zenValue: let force = type: value: if type.name == "anything" then true else if type.name == "listOf" then builtins.all (force type.nestedTypes.elemType) value else if type.name == "attrsOf" then builtins.all (force type.nestedTypes.elemType) (builtins.attrValues value) else if type.name == "either" then force (if type.nestedTypes.left.check value then type.nestedTypes.left else type.nestedTypes.right) value else builtins.seq value true; in builtins.seq (force _zenType _zenValue) _zenValue) ((lib.types.addCheck lib.types.unspecified builtins.isFunction)) ((lib.evalModules { modules = [ { options.value = lib.mkOption { type = (lib.types.addCheck lib.types.unspecified builtins.isFunction); }; config.value = (part: (let
    lower = (lib.toLower part);
  in (if (lower == "super") then "<Super>" else (if ((lower == "ctrl") || (lower == "control")) then "<Ctrl>" else (if (lower == "alt") then "<Alt>" else (if (lower == "shift") then "<Shift>" else part)))))); } ]; }).config.value)));
  serializeKeybind = (builtins.addErrorContext "_let serializeKeybind annotation mismatch: /nix/store/3ni594f60hm22hcrazxd35dmk7pwi61m-zenpkgs-dsl-source/modules/desktops/gnome/extensions/forge.zmdl:28:1" ((_zenType: _zenValue: let force = type: value: if type.name == "anything" then true else if type.name == "listOf" then builtins.all (force type.nestedTypes.elemType) value else if type.name == "attrsOf" then builtins.all (force type.nestedTypes.elemType) (builtins.attrValues value) else if type.name == "either" then force (if type.nestedTypes.left.check value then type.nestedTypes.left else type.nestedTypes.right) value else builtins.seq value true; in builtins.seq (force _zenType _zenValue) _zenValue) ((lib.types.addCheck lib.types.unspecified builtins.isFunction)) ((lib.evalModules { modules = [ { options.value = lib.mkOption { type = (lib.types.addCheck lib.types.unspecified builtins.isFunction); }; config.value = (values: [
    (((lib.concatMapStrings formatPart) values))
  ]); } ]; }).config.value)));
  hexToDecMap = (builtins.addErrorContext "_let hexToDecMap annotation mismatch: /nix/store/3ni594f60hm22hcrazxd35dmk7pwi61m-zenpkgs-dsl-source/modules/desktops/gnome/extensions/forge.zmdl:29:1" ((_zenType: _zenValue: let force = type: value: if type.name == "anything" then true else if type.name == "listOf" then builtins.all (force type.nestedTypes.elemType) value else if type.name == "attrsOf" then builtins.all (force type.nestedTypes.elemType) (builtins.attrValues value) else if type.name == "either" then force (if type.nestedTypes.left.check value then type.nestedTypes.left else type.nestedTypes.right) value else builtins.seq value true; in builtins.seq (force _zenType _zenValue) _zenValue) ((lib.types.attrsOf lib.types.int)) ((lib.evalModules { modules = [ { options.value = lib.mkOption { type = (lib.types.attrsOf lib.types.int); }; config.value = {
    "0" = 0;
    "1" = 1;
    "2" = 2;
    "3" = 3;
    "4" = 4;
    "5" = 5;
    "6" = 6;
    "7" = 7;
    "8" = 8;
    "9" = 9;
    "a" = 10;
    "b" = 11;
    "c" = 12;
    "d" = 13;
    "e" = 14;
    "f" = 15;
    "A" = 10;
    "B" = 11;
    "C" = 12;
    "D" = 13;
    "E" = 14;
    "F" = 15;
  }; } ]; }).config.value)));
  hexCharToInt = (builtins.addErrorContext "_let hexCharToInt annotation mismatch: /nix/store/3ni594f60hm22hcrazxd35dmk7pwi61m-zenpkgs-dsl-source/modules/desktops/gnome/extensions/forge.zmdl:30:1" ((_zenType: _zenValue: let force = type: value: if type.name == "anything" then true else if type.name == "listOf" then builtins.all (force type.nestedTypes.elemType) value else if type.name == "attrsOf" then builtins.all (force type.nestedTypes.elemType) (builtins.attrValues value) else if type.name == "either" then force (if type.nestedTypes.left.check value then type.nestedTypes.left else type.nestedTypes.right) value else builtins.seq value true; in builtins.seq (force _zenType _zenValue) _zenValue) ((lib.types.addCheck lib.types.unspecified builtins.isFunction)) ((lib.evalModules { modules = [ { options.value = lib.mkOption { type = (lib.types.addCheck lib.types.unspecified builtins.isFunction); }; config.value = (c: (if ((lib.hasAttr c) hexToDecMap) then ((lib.getAttr c) hexToDecMap) else 0)); } ]; }).config.value)));
  parseHexByte = (builtins.addErrorContext "_let parseHexByte annotation mismatch: /nix/store/3ni594f60hm22hcrazxd35dmk7pwi61m-zenpkgs-dsl-source/modules/desktops/gnome/extensions/forge.zmdl:31:1" ((_zenType: _zenValue: let force = type: value: if type.name == "anything" then true else if type.name == "listOf" then builtins.all (force type.nestedTypes.elemType) value else if type.name == "attrsOf" then builtins.all (force type.nestedTypes.elemType) (builtins.attrValues value) else if type.name == "either" then force (if type.nestedTypes.left.check value then type.nestedTypes.left else type.nestedTypes.right) value else builtins.seq value true; in builtins.seq (force _zenType _zenValue) _zenValue) ((lib.types.addCheck lib.types.unspecified builtins.isFunction)) ((lib.evalModules { modules = [ { options.value = lib.mkOption { type = (lib.types.addCheck lib.types.unspecified builtins.isFunction); }; config.value = (str: ((((hexCharToInt ((((lib.substring 0) 1) str))) * 16)) + (hexCharToInt ((((lib.substring 1) 1) str))))); } ]; }).config.value)));
  serializeFloat = (builtins.addErrorContext "_let serializeFloat annotation mismatch: /nix/store/3ni594f60hm22hcrazxd35dmk7pwi61m-zenpkgs-dsl-source/modules/desktops/gnome/extensions/forge.zmdl:32:1" ((_zenType: _zenValue: let force = type: value: if type.name == "anything" then true else if type.name == "listOf" then builtins.all (force type.nestedTypes.elemType) value else if type.name == "attrsOf" then builtins.all (force type.nestedTypes.elemType) (builtins.attrValues value) else if type.name == "either" then force (if type.nestedTypes.left.check value then type.nestedTypes.left else type.nestedTypes.right) value else builtins.seq value true; in builtins.seq (force _zenType _zenValue) _zenValue) ((lib.types.addCheck lib.types.unspecified builtins.isFunction)) ((lib.evalModules { modules = [ { options.value = lib.mkOption { type = (lib.types.addCheck lib.types.unspecified builtins.isFunction); }; config.value = (value: (let
    str = (lib.toString value);
  in (if ((lib.hasInfix ".") str) then str else "${((value: let kind = builtins.typeOf value; in if kind == "string" then value else if kind == "bool" || kind == "int" || kind == "float" then builtins.toJSON value else if kind == "path" then "${value}" else if kind == "set" && (value.type or null) == "derivation" && builtins.isString (value.outPath or null) then value.outPath else throw "/nix/store/3ni594f60hm22hcrazxd35dmk7pwi61m-zenpkgs-dsl-source/modules/desktops/gnome/extensions/forge.zmdl:32: string interpolation requires a scalar, path, or package") (str))}.0"))); } ]; }).config.value)));
  toRgbaString = (builtins.addErrorContext "_let toRgbaString annotation mismatch: /nix/store/3ni594f60hm22hcrazxd35dmk7pwi61m-zenpkgs-dsl-source/modules/desktops/gnome/extensions/forge.zmdl:33:1" ((_zenType: _zenValue: let force = type: value: if type.name == "anything" then true else if type.name == "listOf" then builtins.all (force type.nestedTypes.elemType) value else if type.name == "attrsOf" then builtins.all (force type.nestedTypes.elemType) (builtins.attrValues value) else if type.name == "either" then force (if type.nestedTypes.left.check value then type.nestedTypes.left else type.nestedTypes.right) value else builtins.seq value true; in builtins.seq (force _zenType _zenValue) _zenValue) ((lib.types.addCheck lib.types.unspecified builtins.isFunction)) ((lib.evalModules { modules = [ { options.value = lib.mkOption { type = (lib.types.addCheck lib.types.unspecified builtins.isFunction); }; config.value = (value: (if ((lib.isString value) && ((lib.hasPrefix "#") value)) then (let
    hex = ((lib.removePrefix "#") value);
    r = (lib.toString ((parseHexByte ((((lib.substring 0) 2) hex)))));
    g = (lib.toString ((parseHexByte ((((lib.substring 2) 2) hex)))));
    b = (lib.toString ((parseHexByte ((((lib.substring 4) 2) hex)))));
    a = (if ((lib.stringLength hex) == 8) then (serializeFloat (((parseHexByte ((((lib.substring 6) 2) hex))) / 255.0))) else "1.0");
  in "rgba(${((value: let kind = builtins.typeOf value; in if kind == "string" then value else if kind == "bool" || kind == "int" || kind == "float" then builtins.toJSON value else if kind == "path" then "${value}" else if kind == "set" && (value.type or null) == "derivation" && builtins.isString (value.outPath or null) then value.outPath else throw "/nix/store/3ni594f60hm22hcrazxd35dmk7pwi61m-zenpkgs-dsl-source/modules/desktops/gnome/extensions/forge.zmdl:41: string interpolation requires a scalar, path, or package") (r))}, ${((value: let kind = builtins.typeOf value; in if kind == "string" then value else if kind == "bool" || kind == "int" || kind == "float" then builtins.toJSON value else if kind == "path" then "${value}" else if kind == "set" && (value.type or null) == "derivation" && builtins.isString (value.outPath or null) then value.outPath else throw "/nix/store/3ni594f60hm22hcrazxd35dmk7pwi61m-zenpkgs-dsl-source/modules/desktops/gnome/extensions/forge.zmdl:41: string interpolation requires a scalar, path, or package") (g))}, ${((value: let kind = builtins.typeOf value; in if kind == "string" then value else if kind == "bool" || kind == "int" || kind == "float" then builtins.toJSON value else if kind == "path" then "${value}" else if kind == "set" && (value.type or null) == "derivation" && builtins.isString (value.outPath or null) then value.outPath else throw "/nix/store/3ni594f60hm22hcrazxd35dmk7pwi61m-zenpkgs-dsl-source/modules/desktops/gnome/extensions/forge.zmdl:41: string interpolation requires a scalar, path, or package") (b))}, ${((value: let kind = builtins.typeOf value; in if kind == "string" then value else if kind == "bool" || kind == "int" || kind == "float" then builtins.toJSON value else if kind == "path" then "${value}" else if kind == "set" && (value.type or null) == "derivation" && builtins.isString (value.outPath or null) then value.outPath else throw "/nix/store/3ni594f60hm22hcrazxd35dmk7pwi61m-zenpkgs-dsl-source/modules/desktops/gnome/extensions/forge.zmdl:41: string interpolation requires a scalar, path, or package") (a))})") else value)); } ]; }).config.value)));
in
{
  options.zenos.desktops.gnome.extensions.forge = lib.mkOption { type = (lib.types.submodule ({ ... }: (let formatPart = (builtins.addErrorContext "_let formatPart annotation mismatch: /nix/store/3ni594f60hm22hcrazxd35dmk7pwi61m-zenpkgs-dsl-source/modules/desktops/gnome/extensions/forge.zmdl:21:1" ((_zenType: _zenValue: let force = type: value: if type.name == "anything" then true else if type.name == "listOf" then builtins.all (force type.nestedTypes.elemType) value else if type.name == "attrsOf" then builtins.all (force type.nestedTypes.elemType) (builtins.attrValues value) else if type.name == "either" then force (if type.nestedTypes.left.check value then type.nestedTypes.left else type.nestedTypes.right) value else builtins.seq value true; in builtins.seq (force _zenType _zenValue) _zenValue) ((lib.types.addCheck lib.types.unspecified builtins.isFunction)) ((lib.evalModules { modules = [ { options.value = lib.mkOption { type = (lib.types.addCheck lib.types.unspecified builtins.isFunction); }; config.value = (part: (let
        lower = (lib.toLower part);
      in (if (lower == "super") then "<Super>" else (if ((lower == "ctrl") || (lower == "control")) then "<Ctrl>" else (if (lower == "alt") then "<Alt>" else (if (lower == "shift") then "<Shift>" else part)))))); } ]; }).config.value))); serializeKeybind = (builtins.addErrorContext "_let serializeKeybind annotation mismatch: /nix/store/3ni594f60hm22hcrazxd35dmk7pwi61m-zenpkgs-dsl-source/modules/desktops/gnome/extensions/forge.zmdl:28:1" ((_zenType: _zenValue: let force = type: value: if type.name == "anything" then true else if type.name == "listOf" then builtins.all (force type.nestedTypes.elemType) value else if type.name == "attrsOf" then builtins.all (force type.nestedTypes.elemType) (builtins.attrValues value) else if type.name == "either" then force (if type.nestedTypes.left.check value then type.nestedTypes.left else type.nestedTypes.right) value else builtins.seq value true; in builtins.seq (force _zenType _zenValue) _zenValue) ((lib.types.addCheck lib.types.unspecified builtins.isFunction)) ((lib.evalModules { modules = [ { options.value = lib.mkOption { type = (lib.types.addCheck lib.types.unspecified builtins.isFunction); }; config.value = (values: [
        (((lib.concatMapStrings formatPart) values))
      ]); } ]; }).config.value))); hexToDecMap = (builtins.addErrorContext "_let hexToDecMap annotation mismatch: /nix/store/3ni594f60hm22hcrazxd35dmk7pwi61m-zenpkgs-dsl-source/modules/desktops/gnome/extensions/forge.zmdl:29:1" ((_zenType: _zenValue: let force = type: value: if type.name == "anything" then true else if type.name == "listOf" then builtins.all (force type.nestedTypes.elemType) value else if type.name == "attrsOf" then builtins.all (force type.nestedTypes.elemType) (builtins.attrValues value) else if type.name == "either" then force (if type.nestedTypes.left.check value then type.nestedTypes.left else type.nestedTypes.right) value else builtins.seq value true; in builtins.seq (force _zenType _zenValue) _zenValue) ((lib.types.attrsOf lib.types.int)) ((lib.evalModules { modules = [ { options.value = lib.mkOption { type = (lib.types.attrsOf lib.types.int); }; config.value = {
        "0" = 0;
        "1" = 1;
        "2" = 2;
        "3" = 3;
        "4" = 4;
        "5" = 5;
        "6" = 6;
        "7" = 7;
        "8" = 8;
        "9" = 9;
        "a" = 10;
        "b" = 11;
        "c" = 12;
        "d" = 13;
        "e" = 14;
        "f" = 15;
        "A" = 10;
        "B" = 11;
        "C" = 12;
        "D" = 13;
        "E" = 14;
        "F" = 15;
      }; } ]; }).config.value))); hexCharToInt = (builtins.addErrorContext "_let hexCharToInt annotation mismatch: /nix/store/3ni594f60hm22hcrazxd35dmk7pwi61m-zenpkgs-dsl-source/modules/desktops/gnome/extensions/forge.zmdl:30:1" ((_zenType: _zenValue: let force = type: value: if type.name == "anything" then true else if type.name == "listOf" then builtins.all (force type.nestedTypes.elemType) value else if type.name == "attrsOf" then builtins.all (force type.nestedTypes.elemType) (builtins.attrValues value) else if type.name == "either" then force (if type.nestedTypes.left.check value then type.nestedTypes.left else type.nestedTypes.right) value else builtins.seq value true; in builtins.seq (force _zenType _zenValue) _zenValue) ((lib.types.addCheck lib.types.unspecified builtins.isFunction)) ((lib.evalModules { modules = [ { options.value = lib.mkOption { type = (lib.types.addCheck lib.types.unspecified builtins.isFunction); }; config.value = (c: (if ((lib.hasAttr c) hexToDecMap) then ((lib.getAttr c) hexToDecMap) else 0)); } ]; }).config.value))); parseHexByte = (builtins.addErrorContext "_let parseHexByte annotation mismatch: /nix/store/3ni594f60hm22hcrazxd35dmk7pwi61m-zenpkgs-dsl-source/modules/desktops/gnome/extensions/forge.zmdl:31:1" ((_zenType: _zenValue: let force = type: value: if type.name == "anything" then true else if type.name == "listOf" then builtins.all (force type.nestedTypes.elemType) value else if type.name == "attrsOf" then builtins.all (force type.nestedTypes.elemType) (builtins.attrValues value) else if type.name == "either" then force (if type.nestedTypes.left.check value then type.nestedTypes.left else type.nestedTypes.right) value else builtins.seq value true; in builtins.seq (force _zenType _zenValue) _zenValue) ((lib.types.addCheck lib.types.unspecified builtins.isFunction)) ((lib.evalModules { modules = [ { options.value = lib.mkOption { type = (lib.types.addCheck lib.types.unspecified builtins.isFunction); }; config.value = (str: ((((hexCharToInt ((((lib.substring 0) 1) str))) * 16)) + (hexCharToInt ((((lib.substring 1) 1) str))))); } ]; }).config.value))); serializeFloat = (builtins.addErrorContext "_let serializeFloat annotation mismatch: /nix/store/3ni594f60hm22hcrazxd35dmk7pwi61m-zenpkgs-dsl-source/modules/desktops/gnome/extensions/forge.zmdl:32:1" ((_zenType: _zenValue: let force = type: value: if type.name == "anything" then true else if type.name == "listOf" then builtins.all (force type.nestedTypes.elemType) value else if type.name == "attrsOf" then builtins.all (force type.nestedTypes.elemType) (builtins.attrValues value) else if type.name == "either" then force (if type.nestedTypes.left.check value then type.nestedTypes.left else type.nestedTypes.right) value else builtins.seq value true; in builtins.seq (force _zenType _zenValue) _zenValue) ((lib.types.addCheck lib.types.unspecified builtins.isFunction)) ((lib.evalModules { modules = [ { options.value = lib.mkOption { type = (lib.types.addCheck lib.types.unspecified builtins.isFunction); }; config.value = (value: (let
        str = (lib.toString value);
      in (if ((lib.hasInfix ".") str) then str else "${((value: let kind = builtins.typeOf value; in if kind == "string" then value else if kind == "bool" || kind == "int" || kind == "float" then builtins.toJSON value else if kind == "path" then "${value}" else if kind == "set" && (value.type or null) == "derivation" && builtins.isString (value.outPath or null) then value.outPath else throw "/nix/store/3ni594f60hm22hcrazxd35dmk7pwi61m-zenpkgs-dsl-source/modules/desktops/gnome/extensions/forge.zmdl:32: string interpolation requires a scalar, path, or package") (str))}.0"))); } ]; }).config.value))); toRgbaString = (builtins.addErrorContext "_let toRgbaString annotation mismatch: /nix/store/3ni594f60hm22hcrazxd35dmk7pwi61m-zenpkgs-dsl-source/modules/desktops/gnome/extensions/forge.zmdl:33:1" ((_zenType: _zenValue: let force = type: value: if type.name == "anything" then true else if type.name == "listOf" then builtins.all (force type.nestedTypes.elemType) value else if type.name == "attrsOf" then builtins.all (force type.nestedTypes.elemType) (builtins.attrValues value) else if type.name == "either" then force (if type.nestedTypes.left.check value then type.nestedTypes.left else type.nestedTypes.right) value else builtins.seq value true; in builtins.seq (force _zenType _zenValue) _zenValue) ((lib.types.addCheck lib.types.unspecified builtins.isFunction)) ((lib.evalModules { modules = [ { options.value = lib.mkOption { type = (lib.types.addCheck lib.types.unspecified builtins.isFunction); }; config.value = (value: (if ((lib.isString value) && ((lib.hasPrefix "#") value)) then (let
        hex = ((lib.removePrefix "#") value);
        r = (lib.toString ((parseHexByte ((((lib.substring 0) 2) hex)))));
        g = (lib.toString ((parseHexByte ((((lib.substring 2) 2) hex)))));
        b = (lib.toString ((parseHexByte ((((lib.substring 4) 2) hex)))));
        a = (if ((lib.stringLength hex) == 8) then (serializeFloat (((parseHexByte ((((lib.substring 6) 2) hex))) / 255.0))) else "1.0");
      in "rgba(${((value: let kind = builtins.typeOf value; in if kind == "string" then value else if kind == "bool" || kind == "int" || kind == "float" then builtins.toJSON value else if kind == "path" then "${value}" else if kind == "set" && (value.type or null) == "derivation" && builtins.isString (value.outPath or null) then value.outPath else throw "/nix/store/3ni594f60hm22hcrazxd35dmk7pwi61m-zenpkgs-dsl-source/modules/desktops/gnome/extensions/forge.zmdl:41: string interpolation requires a scalar, path, or package") (r))}, ${((value: let kind = builtins.typeOf value; in if kind == "string" then value else if kind == "bool" || kind == "int" || kind == "float" then builtins.toJSON value else if kind == "path" then "${value}" else if kind == "set" && (value.type or null) == "derivation" && builtins.isString (value.outPath or null) then value.outPath else throw "/nix/store/3ni594f60hm22hcrazxd35dmk7pwi61m-zenpkgs-dsl-source/modules/desktops/gnome/extensions/forge.zmdl:41: string interpolation requires a scalar, path, or package") (g))}, ${((value: let kind = builtins.typeOf value; in if kind == "string" then value else if kind == "bool" || kind == "int" || kind == "float" then builtins.toJSON value else if kind == "path" then "${value}" else if kind == "set" && (value.type or null) == "derivation" && builtins.isString (value.outPath or null) then value.outPath else throw "/nix/store/3ni594f60hm22hcrazxd35dmk7pwi61m-zenpkgs-dsl-source/modules/desktops/gnome/extensions/forge.zmdl:41: string interpolation requires a scalar, path, or package") (b))}, ${((value: let kind = builtins.typeOf value; in if kind == "string" then value else if kind == "bool" || kind == "int" || kind == "float" then builtins.toJSON value else if kind == "path" then "${value}" else if kind == "set" && (value.type or null) == "derivation" && builtins.isString (value.outPath or null) then value.outPath else throw "/nix/store/3ni594f60hm22hcrazxd35dmk7pwi61m-zenpkgs-dsl-source/modules/desktops/gnome/extensions/forge.zmdl:41: string interpolation requires a scalar, path, or package") (a))})") else value)); } ]; }).config.value))); in { options = { appearance = lib.mkOption { type = (lib.types.submodule ({ ... }: { options = { borders = lib.mkOption { type = (lib.types.submodule ({ ... }: { options = { focus = lib.mkOption { type = (lib.types.submodule ({ ... }: { options = { color = lib.mkOption { type = lib.types.str; default = "rgba(236, 94, 94, 1)"; description = "CSS color for focused border"; }; size = lib.mkOption { type = lib.types.int; default = 3; description = "Focused window border pixel thickness"; }; toggle = lib.mkOption { type = lib.types.bool; default = true; description = "Display border on focused window"; }; }; })); default = { }; }; split = lib.mkOption { type = (lib.types.submodule ({ ... }: { options = { color = lib.mkOption { type = lib.types.str; default = "rgba(255, 246, 108, 1)"; description = "CSS color for split indicator"; }; toggle = lib.mkOption { type = lib.types.bool; default = true; description = "Display split direction indicator"; }; }; })); default = { }; }; }; })); default = { }; }; decorations = lib.mkOption { type = (lib.types.submodule ({ ... }: { options = { preview-hint = lib.mkOption { type = lib.types.bool; default = true; description = "Display preview area during drag-and-drop"; }; tabs = lib.mkOption { type = lib.types.bool; default = true; description = "Display tab decorations for stacked windows"; }; }; })); default = { }; }; gaps = lib.mkOption { type = (lib.types.submodule ({ ... }: { options = { hide-on-single = lib.mkOption { type = lib.types.bool; default = false; description = "Suppress gaps for single windows"; }; increment = lib.mkOption { type = lib.types.int; default = 1; description = "Multiplier for gap size adjustments"; }; size = lib.mkOption { type = lib.types.int; default = 4; description = "Base gap size between tiled windows"; }; }; })); default = { }; }; }; })); default = { }; }; configure = lib.mkOption { type = lib.types.bool; default = cfg.enable; description = "Write settings without requiring extension activation."; }; enable = lib.mkOption { type = lib.types.bool; default = false; description = "Whether to enable Forge GNOME extension configuration."; }; general = lib.mkOption { type = (lib.types.submodule ({ ... }: { options = { css = lib.mkOption { type = (lib.types.submodule ({ ... }: { options = { last-update = lib.mkOption { type = lib.types.int; default = 1; description = "Internal CSS schema version"; }; updated = lib.mkOption { type = lib.types.str; default = ""; description = "Timestamp of the last CSS injection"; }; }; })); default = { }; }; logging = lib.mkOption { type = (lib.types.submodule ({ ... }: { options = { enable = lib.mkOption { type = lib.types.bool; default = false; description = "Enable extension event logging"; }; level = lib.mkOption { type = lib.types.int; default = 0; description = "Verbosity level for extension logs"; }; }; })); default = { }; }; quick-settings = lib.mkOption { type = lib.types.bool; default = true; description = "Add Forge toggle to system quick settings"; }; }; })); default = { }; }; interaction = lib.mkOption { type = (lib.types.submodule ({ ... }: { options = { dnd-center-layout = lib.mkOption { type = (lib.types.enum [
  "tabbed"
  "stacked"
  "swap"
]); default = "tabbed"; description = "Layout used for drops into window center"; }; float-always-on-top = lib.mkOption { type = lib.types.bool; default = true; description = "Keep floating windows above tiled ones"; }; mouse = lib.mkOption { type = (lib.types.submodule ({ ... }: { options = { focus-on-hover = lib.mkOption { type = lib.types.bool; default = false; description = "Follow-mouse focus policy"; }; move-pointer-focus = lib.mkOption { type = lib.types.bool; default = false; description = "Sync pointer location with keyboard focus changes"; }; }; })); default = { }; }; resize-amount = lib.mkOption { type = lib.types.int; default = 15; description = "Pixel increment for window resizing operations"; }; }; })); default = { }; }; keybindings = lib.mkOption { type = (lib.types.submodule ({ ... }: { options = { con-split-horizontal = lib.mkOption { type = (lib.types.listOf lib.types.str); default = [
  "super"
  "z"
]; description = "Shortcut to force horizontal split\n\nDefine as a list of keys, e.g., [ \"super\" \"q\" ].\nSupported modifiers: super, ctrl, alt, shift."; }; con-split-layout-toggle = lib.mkOption { type = (lib.types.listOf lib.types.str); default = [
  "super"
  "g"
]; description = "Shortcut to toggle split orientation\n\nDefine as a list of keys, e.g., [ \"super\" \"q\" ].\nSupported modifiers: super, ctrl, alt, shift."; }; con-split-vertical = lib.mkOption { type = (lib.types.listOf lib.types.str); default = [
  "super"
  "v"
]; description = "Shortcut to force vertical split\n\nDefine as a list of keys, e.g., [ \"super\" \"q\" ].\nSupported modifiers: super, ctrl, alt, shift."; }; con-stacked-layout-toggle = lib.mkOption { type = (lib.types.listOf lib.types.str); default = [
  "shift"
  "super"
  "s"
]; description = "Shortcut to toggle stacked layout\n\nDefine as a list of keys, e.g., [ \"super\" \"q\" ].\nSupported modifiers: super, ctrl, alt, shift."; }; con-tabbed-layout-toggle = lib.mkOption { type = (lib.types.listOf lib.types.str); default = [
  "shift"
  "super"
  "t"
]; description = "Shortcut to toggle tabbed layout\n\nDefine as a list of keys, e.g., [ \"super\" \"q\" ].\nSupported modifiers: super, ctrl, alt, shift."; }; con-tabbed-showtab-decoration-toggle = lib.mkOption { type = (lib.types.listOf lib.types.str); default = [
  "ctrl"
  "alt"
  "y"
]; description = "Shortcut to toggle tab decorations\n\nDefine as a list of keys, e.g., [ \"super\" \"q\" ].\nSupported modifiers: super, ctrl, alt, shift."; }; focus-border-toggle = lib.mkOption { type = (lib.types.listOf lib.types.str); default = [
  "super"
  "x"
]; description = "Shortcut to toggle focused window border\n\nDefine as a list of keys, e.g., [ \"super\" \"q\" ].\nSupported modifiers: super, ctrl, alt, shift."; }; mod-mask-mouse-tile = lib.mkOption { type = (lib.types.enum [
  "Super"
  "Ctrl"
  "Shift"
  "Alt"
  "None"
]); default = "None"; description = "Modifier key for mouse-based tiling operations"; }; prefs-open = lib.mkOption { type = (lib.types.listOf lib.types.str); default = [
  "super"
  "period"
]; description = "Shortcut to open Forge preferences\n\nDefine as a list of keys, e.g., [ \"super\" \"q\" ].\nSupported modifiers: super, ctrl, alt, shift."; }; prefs-tiling-toggle = lib.mkOption { type = (lib.types.listOf lib.types.str); default = [
  "super"
  "w"
]; description = "Shortcut to toggle tiling mode\n\nDefine as a list of keys, e.g., [ \"super\" \"q\" ].\nSupported modifiers: super, ctrl, alt, shift."; }; window-focus-down = lib.mkOption { type = (lib.types.listOf lib.types.str); default = [
  "super"
  "j"
]; description = "Shortcut to focus lower neighbor\n\nDefine as a list of keys, e.g., [ \"super\" \"q\" ].\nSupported modifiers: super, ctrl, alt, shift."; }; window-focus-left = lib.mkOption { type = (lib.types.listOf lib.types.str); default = [
  "super"
  "h"
]; description = "Shortcut to focus left neighbor\n\nDefine as a list of keys, e.g., [ \"super\" \"q\" ].\nSupported modifiers: super, ctrl, alt, shift."; }; window-focus-right = lib.mkOption { type = (lib.types.listOf lib.types.str); default = [
  "super"
  "l"
]; description = "Shortcut to focus right neighbor\n\nDefine as a list of keys, e.g., [ \"super\" \"q\" ].\nSupported modifiers: super, ctrl, alt, shift."; }; window-focus-up = lib.mkOption { type = (lib.types.listOf lib.types.str); default = [
  "super"
  "k"
]; description = "Shortcut to focus upper neighbor\n\nDefine as a list of keys, e.g., [ \"super\" \"q\" ].\nSupported modifiers: super, ctrl, alt, shift."; }; window-gap-size-decrease = lib.mkOption { type = (lib.types.listOf lib.types.str); default = [
  "ctrl"
  "super"
  "minus"
]; description = "Shortcut to decrease window gaps\n\nDefine as a list of keys, e.g., [ \"super\" \"q\" ].\nSupported modifiers: super, ctrl, alt, shift."; }; window-gap-size-increase = lib.mkOption { type = (lib.types.listOf lib.types.str); default = [
  "ctrl"
  "super"
  "plus"
]; description = "Shortcut to increase window gaps\n\nDefine as a list of keys, e.g., [ \"super\" \"q\" ].\nSupported modifiers: super, ctrl, alt, shift."; }; window-move-down = lib.mkOption { type = (lib.types.listOf lib.types.str); default = [
  "shift"
  "super"
  "j"
]; description = "Shortcut to move window down\n\nDefine as a list of keys, e.g., [ \"super\" \"q\" ].\nSupported modifiers: super, ctrl, alt, shift."; }; window-move-left = lib.mkOption { type = (lib.types.listOf lib.types.str); default = [
  "shift"
  "super"
  "h"
]; description = "Shortcut to move window left\n\nDefine as a list of keys, e.g., [ \"super\" \"q\" ].\nSupported modifiers: super, ctrl, alt, shift."; }; window-move-right = lib.mkOption { type = (lib.types.listOf lib.types.str); default = [
  "shift"
  "super"
  "l"
]; description = "Shortcut to move window right\n\nDefine as a list of keys, e.g., [ \"super\" \"q\" ].\nSupported modifiers: super, ctrl, alt, shift."; }; window-move-up = lib.mkOption { type = (lib.types.listOf lib.types.str); default = [
  "shift"
  "super"
  "k"
]; description = "Shortcut to move window up\n\nDefine as a list of keys, e.g., [ \"super\" \"q\" ].\nSupported modifiers: super, ctrl, alt, shift."; }; window-resize-bottom-decrease = lib.mkOption { type = (lib.types.listOf lib.types.str); default = [
  "ctrl"
  "shift"
  "super"
  "i"
]; description = "Shrink window from bottom\n\nDefine as a list of keys, e.g., [ \"super\" \"q\" ].\nSupported modifiers: super, ctrl, alt, shift."; }; window-resize-bottom-increase = lib.mkOption { type = (lib.types.listOf lib.types.str); default = [
  "ctrl"
  "super"
  "u"
]; description = "Resize window downwards\n\nDefine as a list of keys, e.g., [ \"super\" \"q\" ].\nSupported modifiers: super, ctrl, alt, shift."; }; window-resize-left-decrease = lib.mkOption { type = (lib.types.listOf lib.types.str); default = [
  "ctrl"
  "shift"
  "super"
  "o"
]; description = "Shrink window from left\n\nDefine as a list of keys, e.g., [ \"super\" \"q\" ].\nSupported modifiers: super, ctrl, alt, shift."; }; window-resize-left-increase = lib.mkOption { type = (lib.types.listOf lib.types.str); default = [
  "ctrl"
  "super"
  "y"
]; description = "Resize window leftwards\n\nDefine as a list of keys, e.g., [ \"super\" \"q\" ].\nSupported modifiers: super, ctrl, alt, shift."; }; window-resize-right-decrease = lib.mkOption { type = (lib.types.listOf lib.types.str); default = [
  "ctrl"
  "shift"
  "super"
  "y"
]; description = "Shrink window from right\n\nDefine as a list of keys, e.g., [ \"super\" \"q\" ].\nSupported modifiers: super, ctrl, alt, shift."; }; window-resize-right-increase = lib.mkOption { type = (lib.types.listOf lib.types.str); default = [
  "ctrl"
  "super"
  "o"
]; description = "Resize window rightwards\n\nDefine as a list of keys, e.g., [ \"super\" \"q\" ].\nSupported modifiers: super, ctrl, alt, shift."; }; window-resize-top-decrease = lib.mkOption { type = (lib.types.listOf lib.types.str); default = [
  "ctrl"
  "shift"
  "super"
  "u"
]; description = "Shrink window from top\n\nDefine as a list of keys, e.g., [ \"super\" \"q\" ].\nSupported modifiers: super, ctrl, alt, shift."; }; window-resize-top-increase = lib.mkOption { type = (lib.types.listOf lib.types.str); default = [
  "ctrl"
  "super"
  "i"
]; description = "Resize window upwards\n\nDefine as a list of keys, e.g., [ \"super\" \"q\" ].\nSupported modifiers: super, ctrl, alt, shift."; }; window-snap-center = lib.mkOption { type = (lib.types.listOf lib.types.str); default = [
  "ctrl"
  "alt"
  "c"
]; description = "Snap active window to center\n\nDefine as a list of keys, e.g., [ \"super\" \"q\" ].\nSupported modifiers: super, ctrl, alt, shift."; }; window-snap-one-third-left = lib.mkOption { type = (lib.types.listOf lib.types.str); default = [
  "ctrl"
  "alt"
  "d"
]; description = "Snap active window to 1/3 left\n\nDefine as a list of keys, e.g., [ \"super\" \"q\" ].\nSupported modifiers: super, ctrl, alt, shift."; }; window-snap-one-third-right = lib.mkOption { type = (lib.types.listOf lib.types.str); default = [
  "ctrl"
  "alt"
  "g"
]; description = "Snap active window to 1/3 right\n\nDefine as a list of keys, e.g., [ \"super\" \"q\" ].\nSupported modifiers: super, ctrl, alt, shift."; }; window-snap-two-third-left = lib.mkOption { type = (lib.types.listOf lib.types.str); default = [
  "ctrl"
  "alt"
  "e"
]; description = "Snap active window to 2/3 left\n\nDefine as a list of keys, e.g., [ \"super\" \"q\" ].\nSupported modifiers: super, ctrl, alt, shift."; }; window-snap-two-third-right = lib.mkOption { type = (lib.types.listOf lib.types.str); default = [
  "ctrl"
  "alt"
  "t"
]; description = "Snap active window to 2/3 right\n\nDefine as a list of keys, e.g., [ \"super\" \"q\" ].\nSupported modifiers: super, ctrl, alt, shift."; }; window-swap-down = lib.mkOption { type = (lib.types.listOf lib.types.str); default = [
  "ctrl"
  "super"
  "j"
]; description = "Shortcut to swap window with lower neighbor\n\nDefine as a list of keys, e.g., [ \"super\" \"q\" ].\nSupported modifiers: super, ctrl, alt, shift."; }; window-swap-last-active = lib.mkOption { type = (lib.types.listOf lib.types.str); default = [
  "super"
  "return"
]; description = "Shortcut to swap with previously active window\n\nDefine as a list of keys, e.g., [ \"super\" \"q\" ].\nSupported modifiers: super, ctrl, alt, shift."; }; window-swap-left = lib.mkOption { type = (lib.types.listOf lib.types.str); default = [
  "ctrl"
  "super"
  "h"
]; description = "Shortcut to swap window with left neighbor\n\nDefine as a list of keys, e.g., [ \"super\" \"q\" ].\nSupported modifiers: super, ctrl, alt, shift."; }; window-swap-right = lib.mkOption { type = (lib.types.listOf lib.types.str); default = [
  "ctrl"
  "super"
  "l"
]; description = "Shortcut to swap window with right neighbor\n\nDefine as a list of keys, e.g., [ \"super\" \"q\" ].\nSupported modifiers: super, ctrl, alt, shift."; }; window-swap-up = lib.mkOption { type = (lib.types.listOf lib.types.str); default = [
  "ctrl"
  "super"
  "k"
]; description = "Shortcut to swap window with upper neighbor\n\nDefine as a list of keys, e.g., [ \"super\" \"q\" ].\nSupported modifiers: super, ctrl, alt, shift."; }; window-toggle-always-float = lib.mkOption { type = (lib.types.listOf lib.types.str); default = [
  "shift"
  "super"
  "c"
]; description = "Shortcut to force permanent float for app\n\nDefine as a list of keys, e.g., [ \"super\" \"q\" ].\nSupported modifiers: super, ctrl, alt, shift."; }; window-toggle-float = lib.mkOption { type = (lib.types.listOf lib.types.str); default = [
  "super"
  "c"
]; description = "Shortcut to toggle floating for active window\n\nDefine as a list of keys, e.g., [ \"super\" \"q\" ].\nSupported modifiers: super, ctrl, alt, shift."; }; workspace-active-tile-toggle = lib.mkOption { type = (lib.types.listOf lib.types.str); default = [
  "shift"
  "super"
  "w"
]; description = "Shortcut to toggle tiling for current desktop\n\nDefine as a list of keys, e.g., [ \"super\" \"q\" ].\nSupported modifiers: super, ctrl, alt, shift."; }; }; })); default = { }; }; tiling = lib.mkOption { type = (lib.types.submodule ({ ... }: { options = { auto-split = lib.mkOption { type = lib.types.bool; default = true; description = "Automatically select split axis based on window dimensions"; }; enable = lib.mkOption { type = lib.types.bool; default = true; description = "Global tiling mode master switch"; }; primary-mode = lib.mkOption { type = (lib.types.enum [
  "tiling"
  "stacking"
]); default = "tiling"; description = "Default layout strategy for new windows"; }; stacked = lib.mkOption { type = lib.types.bool; default = true; description = "Enable stacked layout capabilities"; }; tabbed = lib.mkOption { type = (lib.types.submodule ({ ... }: { options = { auto-exit = lib.mkOption { type = lib.types.bool; default = true; description = "Automatically exit tabbed mode for single windows"; }; enable = lib.mkOption { type = lib.types.bool; default = true; description = "Enable tabbed layout capabilities"; }; }; })); default = { }; }; workspace-skip = lib.mkOption { type = lib.types.str; default = ""; description = "Indices of workspaces to exclude from tiling"; }; }; })); default = { }; }; }; }))); default = { }; };
  config = lib.mkMerge [
    { _module.args.zenlang.descriptors.desktops.gnome.extensions.forge = {
    aliases = [ ];
    descriptorVersion = "zenlang.semantic/2";
    grammarVersion = "1.0.0Na";
    irVersion = "1.0.0Na";
    kind = "zmdl";
    metadata = {
      description = {
        multiline = true;
        parts = [
          {
            type = "text";
            value = "\n    Tiling window management for GNOME Shell\n\n    This module installs and configures the **Forge** extension for GNOME.\n    Forge transforms the GNOME Shell into a tiling window manager, offering automatic\n    tiling, window gaps, and extensive keyboard shortcuts.\n\n    **Features:**\n    - Automatic tiling and stacking.\n    - Customizable window gaps and borders.\n    - Extensive keyboard shortcuts for moving, resizing, and focusing windows.\n  ";
          }
        ];
        type = "string";
      };
      license = {
        name = "l";
        path = [
          {
            kind = "identifier";
            value = "napl";
          }
        ];
        type = "variable";
      };
      maintainers = {
        items = [
          {
            name = "m";
            path = [
              {
                kind = "identifier";
                value = "doromiert";
              }
            ];
            type = "variable";
          }
        ];
        type = "list";
      };
      platforms = {
        name = "lib";
        path = [
          {
            kind = "identifier";
            value = "platforms";
          }
          {
            kind = "identifier";
            value = "zenos";
          }
        ];
        type = "variable";
      };
      summary = {
        multiline = false;
        parts = [
          {
            type = "text";
            value = "Tiling window management for GNOME Shell";
          }
        ];
        type = "string";
      };
      zenosVersion = {
        kind = "version";
        type = "literal";
        value = "1.0.0Na";
      };
    };
    moduleIdentity = "zenos.desktops.gnome.extensions.forge";
    modulePath = [
      "desktops"
      "gnome"
      "extensions"
      "forge"
    ];
    nodeMetadata = [
      {
        metadata = {
          description = {
            multiline = true;
            parts = [
              {
                type = "text";
                value = "\n    Tiling window management for GNOME Shell\n\n    This module installs and configures the **Forge** extension for GNOME.\n    Forge transforms the GNOME Shell into a tiling window manager, offering automatic\n    tiling, window gaps, and extensive keyboard shortcuts.\n\n    **Features:**\n    - Automatic tiling and stacking.\n    - Customizable window gaps and borders.\n    - Extensive keyboard shortcuts for moving, resizing, and focusing windows.\n  ";
              }
            ];
            type = "string";
          };
          license = {
            name = "l";
            path = [
              {
                kind = "identifier";
                value = "napl";
              }
            ];
            type = "variable";
          };
          maintainers = {
            items = [
              {
                name = "m";
                path = [
                  {
                    kind = "identifier";
                    value = "doromiert";
                  }
                ];
                type = "variable";
              }
            ];
            type = "list";
          };
          platforms = {
            name = "lib";
            path = [
              {
                kind = "identifier";
                value = "platforms";
              }
              {
                kind = "identifier";
                value = "zenos";
              }
            ];
            type = "variable";
          };
          summary = {
            multiline = false;
            parts = [
              {
                type = "text";
                value = "Tiling window management for GNOME Shell";
              }
            ];
            type = "string";
          };
          zenosVersion = {
            kind = "version";
            type = "literal";
            value = "1.0.0Na";
          };
        };
        path = [ ];
      }
      {
        metadata = {
          description = {
            multiline = true;
            parts = [
              {
                type = "text";
                value = "Whether to enable Forge GNOME extension configuration.";
              }
            ];
            type = "string";
          };
          zenosVersion = {
            kind = "version";
            type = "literal";
            value = "1.0.0Na";
          };
        };
        path = [
          "enable"
        ];
      }
      {
        metadata = {
          default = {
            name = "path";
            path = [
              {
                kind = "identifier";
                value = "enable";
              }
            ];
            type = "variable";
          };
          description = {
            multiline = true;
            parts = [
              {
                type = "text";
                value = "Write settings without requiring extension activation.";
              }
            ];
            type = "string";
          };
          zenosVersion = {
            kind = "version";
            type = "literal";
            value = "1.0.0Na";
          };
        };
        path = [
          "configure"
        ];
      }
      {
        metadata = {
          zenosVersion = {
            kind = "version";
            type = "literal";
            value = "1.0.0Na";
          };
        };
        path = [
          "appearance"
        ];
      }
      {
        metadata = {
          zenosVersion = {
            kind = "version";
            type = "literal";
            value = "1.0.0Na";
          };
        };
        path = [
          "appearance"
          "borders"
        ];
      }
      {
        metadata = {
          zenosVersion = {
            kind = "version";
            type = "literal";
            value = "1.0.0Na";
          };
        };
        path = [
          "appearance"
          "borders"
          "focus"
        ];
      }
      {
        metadata = {
          default = {
            kind = "true";
            type = "literal";
            value = true;
          };
          description = {
            multiline = true;
            parts = [
              {
                type = "text";
                value = "Display border on focused window";
              }
            ];
            type = "string";
          };
          type = {
            name = "type";
            path = [
              {
                kind = "identifier";
                value = "bool";
              }
            ];
            type = "variable";
          };
          zenosVersion = {
            kind = "version";
            type = "literal";
            value = "1.0.0Na";
          };
        };
        path = [
          "appearance"
          "borders"
          "focus"
          "toggle"
        ];
      }
      {
        metadata = {
          default = {
            kind = "integer";
            type = "literal";
            value = 3;
          };
          description = {
            multiline = true;
            parts = [
              {
                type = "text";
                value = "Focused window border pixel thickness";
              }
            ];
            type = "string";
          };
          type = {
            name = "type";
            path = [
              {
                kind = "identifier";
                value = "int";
              }
            ];
            type = "variable";
          };
          zenosVersion = {
            kind = "version";
            type = "literal";
            value = "1.0.0Na";
          };
        };
        path = [
          "appearance"
          "borders"
          "focus"
          "size"
        ];
      }
      {
        metadata = {
          default = {
            multiline = false;
            parts = [
              {
                type = "text";
                value = "rgba(236, 94, 94, 1)";
              }
            ];
            type = "string";
          };
          description = {
            multiline = true;
            parts = [
              {
                type = "text";
                value = "CSS color for focused border";
              }
            ];
            type = "string";
          };
          type = {
            name = "type";
            path = [
              {
                kind = "identifier";
                value = "string";
              }
            ];
            type = "variable";
          };
          zenosVersion = {
            kind = "version";
            type = "literal";
            value = "1.0.0Na";
          };
        };
        path = [
          "appearance"
          "borders"
          "focus"
          "color"
        ];
      }
      {
        metadata = {
          zenosVersion = {
            kind = "version";
            type = "literal";
            value = "1.0.0Na";
          };
        };
        path = [
          "appearance"
          "borders"
          "split"
        ];
      }
      {
        metadata = {
          default = {
            kind = "true";
            type = "literal";
            value = true;
          };
          description = {
            multiline = true;
            parts = [
              {
                type = "text";
                value = "Display split direction indicator";
              }
            ];
            type = "string";
          };
          type = {
            name = "type";
            path = [
              {
                kind = "identifier";
                value = "bool";
              }
            ];
            type = "variable";
          };
          zenosVersion = {
            kind = "version";
            type = "literal";
            value = "1.0.0Na";
          };
        };
        path = [
          "appearance"
          "borders"
          "split"
          "toggle"
        ];
      }
      {
        metadata = {
          default = {
            multiline = false;
            parts = [
              {
                type = "text";
                value = "rgba(255, 246, 108, 1)";
              }
            ];
            type = "string";
          };
          description = {
            multiline = true;
            parts = [
              {
                type = "text";
                value = "CSS color for split indicator";
              }
            ];
            type = "string";
          };
          type = {
            name = "type";
            path = [
              {
                kind = "identifier";
                value = "string";
              }
            ];
            type = "variable";
          };
          zenosVersion = {
            kind = "version";
            type = "literal";
            value = "1.0.0Na";
          };
        };
        path = [
          "appearance"
          "borders"
          "split"
          "color"
        ];
      }
      {
        metadata = {
          zenosVersion = {
            kind = "version";
            type = "literal";
            value = "1.0.0Na";
          };
        };
        path = [
          "appearance"
          "gaps"
        ];
      }
      {
        metadata = {
          default = {
            kind = "integer";
            type = "literal";
            value = 4;
          };
          description = {
            multiline = true;
            parts = [
              {
                type = "text";
                value = "Base gap size between tiled windows";
              }
            ];
            type = "string";
          };
          type = {
            name = "type";
            path = [
              {
                kind = "identifier";
                value = "int";
              }
            ];
            type = "variable";
          };
          zenosVersion = {
            kind = "version";
            type = "literal";
            value = "1.0.0Na";
          };
        };
        path = [
          "appearance"
          "gaps"
          "size"
        ];
      }
      {
        metadata = {
          default = {
            kind = "integer";
            type = "literal";
            value = 1;
          };
          description = {
            multiline = true;
            parts = [
              {
                type = "text";
                value = "Multiplier for gap size adjustments";
              }
            ];
            type = "string";
          };
          type = {
            name = "type";
            path = [
              {
                kind = "identifier";
                value = "int";
              }
            ];
            type = "variable";
          };
          zenosVersion = {
            kind = "version";
            type = "literal";
            value = "1.0.0Na";
          };
        };
        path = [
          "appearance"
          "gaps"
          "increment"
        ];
      }
      {
        metadata = {
          default = {
            kind = "false";
            type = "literal";
            value = false;
          };
          description = {
            multiline = true;
            parts = [
              {
                type = "text";
                value = "Suppress gaps for single windows";
              }
            ];
            type = "string";
          };
          type = {
            name = "type";
            path = [
              {
                kind = "identifier";
                value = "bool";
              }
            ];
            type = "variable";
          };
          zenosVersion = {
            kind = "version";
            type = "literal";
            value = "1.0.0Na";
          };
        };
        path = [
          "appearance"
          "gaps"
          "hide-on-single"
        ];
      }
      {
        metadata = {
          zenosVersion = {
            kind = "version";
            type = "literal";
            value = "1.0.0Na";
          };
        };
        path = [
          "appearance"
          "decorations"
        ];
      }
      {
        metadata = {
          default = {
            kind = "true";
            type = "literal";
            value = true;
          };
          description = {
            multiline = true;
            parts = [
              {
                type = "text";
                value = "Display tab decorations for stacked windows";
              }
            ];
            type = "string";
          };
          type = {
            name = "type";
            path = [
              {
                kind = "identifier";
                value = "bool";
              }
            ];
            type = "variable";
          };
          zenosVersion = {
            kind = "version";
            type = "literal";
            value = "1.0.0Na";
          };
        };
        path = [
          "appearance"
          "decorations"
          "tabs"
        ];
      }
      {
        metadata = {
          default = {
            kind = "true";
            type = "literal";
            value = true;
          };
          description = {
            multiline = true;
            parts = [
              {
                type = "text";
                value = "Display preview area during drag-and-drop";
              }
            ];
            type = "string";
          };
          type = {
            name = "type";
            path = [
              {
                kind = "identifier";
                value = "bool";
              }
            ];
            type = "variable";
          };
          zenosVersion = {
            kind = "version";
            type = "literal";
            value = "1.0.0Na";
          };
        };
        path = [
          "appearance"
          "decorations"
          "preview-hint"
        ];
      }
      {
        metadata = {
          zenosVersion = {
            kind = "version";
            type = "literal";
            value = "1.0.0Na";
          };
        };
        path = [
          "tiling"
        ];
      }
      {
        metadata = {
          default = {
            kind = "true";
            type = "literal";
            value = true;
          };
          description = {
            multiline = true;
            parts = [
              {
                type = "text";
                value = "Global tiling mode master switch";
              }
            ];
            type = "string";
          };
          type = {
            name = "type";
            path = [
              {
                kind = "identifier";
                value = "bool";
              }
            ];
            type = "variable";
          };
          zenosVersion = {
            kind = "version";
            type = "literal";
            value = "1.0.0Na";
          };
        };
        path = [
          "tiling"
          "enable"
        ];
      }
      {
        metadata = {
          default = {
            multiline = false;
            parts = [
              {
                type = "text";
                value = "tiling";
              }
            ];
            type = "string";
          };
          description = {
            multiline = true;
            parts = [
              {
                type = "text";
                value = "Default layout strategy for new windows";
              }
            ];
            type = "string";
          };
          type = {
            arguments = [
              {
                items = [
                  {
                    multiline = false;
                    parts = [
                      {
                        type = "text";
                        value = "tiling";
                      }
                    ];
                    type = "string";
                  }
                  {
                    multiline = false;
                    parts = [
                      {
                        type = "text";
                        value = "stacking";
                      }
                    ];
                    type = "string";
                  }
                ];
                type = "list";
              }
            ];
            callee = {
              name = "type";
              path = [
                {
                  kind = "identifier";
                  value = "enum";
                }
              ];
              type = "variable";
            };
            type = "call";
          };
          zenosVersion = {
            kind = "version";
            type = "literal";
            value = "1.0.0Na";
          };
        };
        path = [
          "tiling"
          "primary-mode"
        ];
      }
      {
        metadata = {
          default = {
            kind = "true";
            type = "literal";
            value = true;
          };
          description = {
            multiline = true;
            parts = [
              {
                type = "text";
                value = "Enable stacked layout capabilities";
              }
            ];
            type = "string";
          };
          type = {
            name = "type";
            path = [
              {
                kind = "identifier";
                value = "bool";
              }
            ];
            type = "variable";
          };
          zenosVersion = {
            kind = "version";
            type = "literal";
            value = "1.0.0Na";
          };
        };
        path = [
          "tiling"
          "stacked"
        ];
      }
      {
        metadata = {
          zenosVersion = {
            kind = "version";
            type = "literal";
            value = "1.0.0Na";
          };
        };
        path = [
          "tiling"
          "tabbed"
        ];
      }
      {
        metadata = {
          default = {
            kind = "true";
            type = "literal";
            value = true;
          };
          description = {
            multiline = true;
            parts = [
              {
                type = "text";
                value = "Enable tabbed layout capabilities";
              }
            ];
            type = "string";
          };
          type = {
            name = "type";
            path = [
              {
                kind = "identifier";
                value = "bool";
              }
            ];
            type = "variable";
          };
          zenosVersion = {
            kind = "version";
            type = "literal";
            value = "1.0.0Na";
          };
        };
        path = [
          "tiling"
          "tabbed"
          "enable"
        ];
      }
      {
        metadata = {
          default = {
            kind = "true";
            type = "literal";
            value = true;
          };
          description = {
            multiline = true;
            parts = [
              {
                type = "text";
                value = "Automatically exit tabbed mode for single windows";
              }
            ];
            type = "string";
          };
          type = {
            name = "type";
            path = [
              {
                kind = "identifier";
                value = "bool";
              }
            ];
            type = "variable";
          };
          zenosVersion = {
            kind = "version";
            type = "literal";
            value = "1.0.0Na";
          };
        };
        path = [
          "tiling"
          "tabbed"
          "auto-exit"
        ];
      }
      {
        metadata = {
          default = {
            kind = "true";
            type = "literal";
            value = true;
          };
          description = {
            multiline = true;
            parts = [
              {
                type = "text";
                value = "Automatically select split axis based on window dimensions";
              }
            ];
            type = "string";
          };
          type = {
            name = "type";
            path = [
              {
                kind = "identifier";
                value = "bool";
              }
            ];
            type = "variable";
          };
          zenosVersion = {
            kind = "version";
            type = "literal";
            value = "1.0.0Na";
          };
        };
        path = [
          "tiling"
          "auto-split"
        ];
      }
      {
        metadata = {
          default = {
            multiline = false;
            parts = [ ];
            type = "string";
          };
          description = {
            multiline = true;
            parts = [
              {
                type = "text";
                value = "Indices of workspaces to exclude from tiling";
              }
            ];
            type = "string";
          };
          type = {
            name = "type";
            path = [
              {
                kind = "identifier";
                value = "string";
              }
            ];
            type = "variable";
          };
          zenosVersion = {
            kind = "version";
            type = "literal";
            value = "1.0.0Na";
          };
        };
        path = [
          "tiling"
          "workspace-skip"
        ];
      }
      {
        metadata = {
          zenosVersion = {
            kind = "version";
            type = "literal";
            value = "1.0.0Na";
          };
        };
        path = [
          "interaction"
        ];
      }
      {
        metadata = {
          zenosVersion = {
            kind = "version";
            type = "literal";
            value = "1.0.0Na";
          };
        };
        path = [
          "interaction"
          "mouse"
        ];
      }
      {
        metadata = {
          default = {
            kind = "false";
            type = "literal";
            value = false;
          };
          description = {
            multiline = true;
            parts = [
              {
                type = "text";
                value = "Sync pointer location with keyboard focus changes";
              }
            ];
            type = "string";
          };
          type = {
            name = "type";
            path = [
              {
                kind = "identifier";
                value = "bool";
              }
            ];
            type = "variable";
          };
          zenosVersion = {
            kind = "version";
            type = "literal";
            value = "1.0.0Na";
          };
        };
        path = [
          "interaction"
          "mouse"
          "move-pointer-focus"
        ];
      }
      {
        metadata = {
          default = {
            kind = "false";
            type = "literal";
            value = false;
          };
          description = {
            multiline = true;
            parts = [
              {
                type = "text";
                value = "Follow-mouse focus policy";
              }
            ];
            type = "string";
          };
          type = {
            name = "type";
            path = [
              {
                kind = "identifier";
                value = "bool";
              }
            ];
            type = "variable";
          };
          zenosVersion = {
            kind = "version";
            type = "literal";
            value = "1.0.0Na";
          };
        };
        path = [
          "interaction"
          "mouse"
          "focus-on-hover"
        ];
      }
      {
        metadata = {
          default = {
            multiline = false;
            parts = [
              {
                type = "text";
                value = "tabbed";
              }
            ];
            type = "string";
          };
          description = {
            multiline = true;
            parts = [
              {
                type = "text";
                value = "Layout used for drops into window center";
              }
            ];
            type = "string";
          };
          type = {
            arguments = [
              {
                items = [
                  {
                    multiline = false;
                    parts = [
                      {
                        type = "text";
                        value = "tabbed";
                      }
                    ];
                    type = "string";
                  }
                  {
                    multiline = false;
                    parts = [
                      {
                        type = "text";
                        value = "stacked";
                      }
                    ];
                    type = "string";
                  }
                  {
                    multiline = false;
                    parts = [
                      {
                        type = "text";
                        value = "swap";
                      }
                    ];
                    type = "string";
                  }
                ];
                type = "list";
              }
            ];
            callee = {
              name = "type";
              path = [
                {
                  kind = "identifier";
                  value = "enum";
                }
              ];
              type = "variable";
            };
            type = "call";
          };
          zenosVersion = {
            kind = "version";
            type = "literal";
            value = "1.0.0Na";
          };
        };
        path = [
          "interaction"
          "dnd-center-layout"
        ];
      }
      {
        metadata = {
          default = {
            kind = "true";
            type = "literal";
            value = true;
          };
          description = {
            multiline = true;
            parts = [
              {
                type = "text";
                value = "Keep floating windows above tiled ones";
              }
            ];
            type = "string";
          };
          type = {
            name = "type";
            path = [
              {
                kind = "identifier";
                value = "bool";
              }
            ];
            type = "variable";
          };
          zenosVersion = {
            kind = "version";
            type = "literal";
            value = "1.0.0Na";
          };
        };
        path = [
          "interaction"
          "float-always-on-top"
        ];
      }
      {
        metadata = {
          default = {
            kind = "integer";
            type = "literal";
            value = 15;
          };
          description = {
            multiline = true;
            parts = [
              {
                type = "text";
                value = "Pixel increment for window resizing operations";
              }
            ];
            type = "string";
          };
          type = {
            name = "type";
            path = [
              {
                kind = "identifier";
                value = "int";
              }
            ];
            type = "variable";
          };
          zenosVersion = {
            kind = "version";
            type = "literal";
            value = "1.0.0Na";
          };
        };
        path = [
          "interaction"
          "resize-amount"
        ];
      }
      {
        metadata = {
          zenosVersion = {
            kind = "version";
            type = "literal";
            value = "1.0.0Na";
          };
        };
        path = [
          "general"
        ];
      }
      {
        metadata = {
          default = {
            kind = "true";
            type = "literal";
            value = true;
          };
          description = {
            multiline = true;
            parts = [
              {
                type = "text";
                value = "Add Forge toggle to system quick settings";
              }
            ];
            type = "string";
          };
          type = {
            name = "type";
            path = [
              {
                kind = "identifier";
                value = "bool";
              }
            ];
            type = "variable";
          };
          zenosVersion = {
            kind = "version";
            type = "literal";
            value = "1.0.0Na";
          };
        };
        path = [
          "general"
          "quick-settings"
        ];
      }
      {
        metadata = {
          zenosVersion = {
            kind = "version";
            type = "literal";
            value = "1.0.0Na";
          };
        };
        path = [
          "general"
          "logging"
        ];
      }
      {
        metadata = {
          default = {
            kind = "false";
            type = "literal";
            value = false;
          };
          description = {
            multiline = true;
            parts = [
              {
                type = "text";
                value = "Enable extension event logging";
              }
            ];
            type = "string";
          };
          type = {
            name = "type";
            path = [
              {
                kind = "identifier";
                value = "bool";
              }
            ];
            type = "variable";
          };
          zenosVersion = {
            kind = "version";
            type = "literal";
            value = "1.0.0Na";
          };
        };
        path = [
          "general"
          "logging"
          "enable"
        ];
      }
      {
        metadata = {
          default = {
            kind = "integer";
            type = "literal";
            value = 0;
          };
          description = {
            multiline = true;
            parts = [
              {
                type = "text";
                value = "Verbosity level for extension logs";
              }
            ];
            type = "string";
          };
          type = {
            name = "type";
            path = [
              {
                kind = "identifier";
                value = "int";
              }
            ];
            type = "variable";
          };
          zenosVersion = {
            kind = "version";
            type = "literal";
            value = "1.0.0Na";
          };
        };
        path = [
          "general"
          "logging"
          "level"
        ];
      }
      {
        metadata = {
          zenosVersion = {
            kind = "version";
            type = "literal";
            value = "1.0.0Na";
          };
        };
        path = [
          "general"
          "css"
        ];
      }
      {
        metadata = {
          default = {
            multiline = false;
            parts = [ ];
            type = "string";
          };
          description = {
            multiline = true;
            parts = [
              {
                type = "text";
                value = "Timestamp of the last CSS injection";
              }
            ];
            type = "string";
          };
          type = {
            name = "type";
            path = [
              {
                kind = "identifier";
                value = "string";
              }
            ];
            type = "variable";
          };
          zenosVersion = {
            kind = "version";
            type = "literal";
            value = "1.0.0Na";
          };
        };
        path = [
          "general"
          "css"
          "updated"
        ];
      }
      {
        metadata = {
          default = {
            kind = "integer";
            type = "literal";
            value = 1;
          };
          description = {
            multiline = true;
            parts = [
              {
                type = "text";
                value = "Internal CSS schema version";
              }
            ];
            type = "string";
          };
          type = {
            name = "type";
            path = [
              {
                kind = "identifier";
                value = "int";
              }
            ];
            type = "variable";
          };
          zenosVersion = {
            kind = "version";
            type = "literal";
            value = "1.0.0Na";
          };
        };
        path = [
          "general"
          "css"
          "last-update"
        ];
      }
      {
        metadata = {
          zenosVersion = {
            kind = "version";
            type = "literal";
            value = "1.0.0Na";
          };
        };
        path = [
          "keybindings"
        ];
      }
      {
        metadata = {
          default = {
            items = [
              {
                multiline = false;
                parts = [
                  {
                    type = "text";
                    value = "super";
                  }
                ];
                type = "string";
              }
              {
                multiline = false;
                parts = [
                  {
                    type = "text";
                    value = "x";
                  }
                ];
                type = "string";
              }
            ];
            type = "list";
          };
          description = {
            multiline = true;
            parts = [
              {
                type = "text";
                value = "Shortcut to toggle focused window border\n\nDefine as a list of keys, e.g., [ \"super\" \"q\" ].\nSupported modifiers: super, ctrl, alt, shift.";
              }
            ];
            type = "string";
          };
          type = {
            arguments = [
              {
                items = [
                  {
                    name = "type";
                    path = [
                      {
                        kind = "identifier";
                        value = "string";
                      }
                    ];
                    type = "variable";
                  }
                ];
                type = "list";
              }
            ];
            callee = {
              name = "type";
              path = [
                {
                  kind = "identifier";
                  value = "list";
                }
              ];
              type = "variable";
            };
            type = "call";
          };
          zenosVersion = {
            kind = "version";
            type = "literal";
            value = "1.0.0Na";
          };
        };
        path = [
          "keybindings"
          "focus-border-toggle"
        ];
      }
      {
        metadata = {
          default = {
            items = [
              {
                multiline = false;
                parts = [
                  {
                    type = "text";
                    value = "ctrl";
                  }
                ];
                type = "string";
              }
              {
                multiline = false;
                parts = [
                  {
                    type = "text";
                    value = "super";
                  }
                ];
                type = "string";
              }
              {
                multiline = false;
                parts = [
                  {
                    type = "text";
                    value = "plus";
                  }
                ];
                type = "string";
              }
            ];
            type = "list";
          };
          description = {
            multiline = true;
            parts = [
              {
                type = "text";
                value = "Shortcut to increase window gaps\n\nDefine as a list of keys, e.g., [ \"super\" \"q\" ].\nSupported modifiers: super, ctrl, alt, shift.";
              }
            ];
            type = "string";
          };
          type = {
            arguments = [
              {
                items = [
                  {
                    name = "type";
                    path = [
                      {
                        kind = "identifier";
                        value = "string";
                      }
                    ];
                    type = "variable";
                  }
                ];
                type = "list";
              }
            ];
            callee = {
              name = "type";
              path = [
                {
                  kind = "identifier";
                  value = "list";
                }
              ];
              type = "variable";
            };
            type = "call";
          };
          zenosVersion = {
            kind = "version";
            type = "literal";
            value = "1.0.0Na";
          };
        };
        path = [
          "keybindings"
          "window-gap-size-increase"
        ];
      }
      {
        metadata = {
          default = {
            items = [
              {
                multiline = false;
                parts = [
                  {
                    type = "text";
                    value = "ctrl";
                  }
                ];
                type = "string";
              }
              {
                multiline = false;
                parts = [
                  {
                    type = "text";
                    value = "super";
                  }
                ];
                type = "string";
              }
              {
                multiline = false;
                parts = [
                  {
                    type = "text";
                    value = "minus";
                  }
                ];
                type = "string";
              }
            ];
            type = "list";
          };
          description = {
            multiline = true;
            parts = [
              {
                type = "text";
                value = "Shortcut to decrease window gaps\n\nDefine as a list of keys, e.g., [ \"super\" \"q\" ].\nSupported modifiers: super, ctrl, alt, shift.";
              }
            ];
            type = "string";
          };
          type = {
            arguments = [
              {
                items = [
                  {
                    name = "type";
                    path = [
                      {
                        kind = "identifier";
                        value = "string";
                      }
                    ];
                    type = "variable";
                  }
                ];
                type = "list";
              }
            ];
            callee = {
              name = "type";
              path = [
                {
                  kind = "identifier";
                  value = "list";
                }
              ];
              type = "variable";
            };
            type = "call";
          };
          zenosVersion = {
            kind = "version";
            type = "literal";
            value = "1.0.0Na";
          };
        };
        path = [
          "keybindings"
          "window-gap-size-decrease"
        ];
      }
      {
        metadata = {
          default = {
            items = [
              {
                multiline = false;
                parts = [
                  {
                    type = "text";
                    value = "super";
                  }
                ];
                type = "string";
              }
              {
                multiline = false;
                parts = [
                  {
                    type = "text";
                    value = "g";
                  }
                ];
                type = "string";
              }
            ];
            type = "list";
          };
          description = {
            multiline = true;
            parts = [
              {
                type = "text";
                value = "Shortcut to toggle split orientation\n\nDefine as a list of keys, e.g., [ \"super\" \"q\" ].\nSupported modifiers: super, ctrl, alt, shift.";
              }
            ];
            type = "string";
          };
          type = {
            arguments = [
              {
                items = [
                  {
                    name = "type";
                    path = [
                      {
                        kind = "identifier";
                        value = "string";
                      }
                    ];
                    type = "variable";
                  }
                ];
                type = "list";
              }
            ];
            callee = {
              name = "type";
              path = [
                {
                  kind = "identifier";
                  value = "list";
                }
              ];
              type = "variable";
            };
            type = "call";
          };
          zenosVersion = {
            kind = "version";
            type = "literal";
            value = "1.0.0Na";
          };
        };
        path = [
          "keybindings"
          "con-split-layout-toggle"
        ];
      }
      {
        metadata = {
          default = {
            items = [
              {
                multiline = false;
                parts = [
                  {
                    type = "text";
                    value = "super";
                  }
                ];
                type = "string";
              }
              {
                multiline = false;
                parts = [
                  {
                    type = "text";
                    value = "z";
                  }
                ];
                type = "string";
              }
            ];
            type = "list";
          };
          description = {
            multiline = true;
            parts = [
              {
                type = "text";
                value = "Shortcut to force horizontal split\n\nDefine as a list of keys, e.g., [ \"super\" \"q\" ].\nSupported modifiers: super, ctrl, alt, shift.";
              }
            ];
            type = "string";
          };
          type = {
            arguments = [
              {
                items = [
                  {
                    name = "type";
                    path = [
                      {
                        kind = "identifier";
                        value = "string";
                      }
                    ];
                    type = "variable";
                  }
                ];
                type = "list";
              }
            ];
            callee = {
              name = "type";
              path = [
                {
                  kind = "identifier";
                  value = "list";
                }
              ];
              type = "variable";
            };
            type = "call";
          };
          zenosVersion = {
            kind = "version";
            type = "literal";
            value = "1.0.0Na";
          };
        };
        path = [
          "keybindings"
          "con-split-horizontal"
        ];
      }
      {
        metadata = {
          default = {
            items = [
              {
                multiline = false;
                parts = [
                  {
                    type = "text";
                    value = "super";
                  }
                ];
                type = "string";
              }
              {
                multiline = false;
                parts = [
                  {
                    type = "text";
                    value = "v";
                  }
                ];
                type = "string";
              }
            ];
            type = "list";
          };
          description = {
            multiline = true;
            parts = [
              {
                type = "text";
                value = "Shortcut to force vertical split\n\nDefine as a list of keys, e.g., [ \"super\" \"q\" ].\nSupported modifiers: super, ctrl, alt, shift.";
              }
            ];
            type = "string";
          };
          type = {
            arguments = [
              {
                items = [
                  {
                    name = "type";
                    path = [
                      {
                        kind = "identifier";
                        value = "string";
                      }
                    ];
                    type = "variable";
                  }
                ];
                type = "list";
              }
            ];
            callee = {
              name = "type";
              path = [
                {
                  kind = "identifier";
                  value = "list";
                }
              ];
              type = "variable";
            };
            type = "call";
          };
          zenosVersion = {
            kind = "version";
            type = "literal";
            value = "1.0.0Na";
          };
        };
        path = [
          "keybindings"
          "con-split-vertical"
        ];
      }
      {
        metadata = {
          default = {
            items = [
              {
                multiline = false;
                parts = [
                  {
                    type = "text";
                    value = "shift";
                  }
                ];
                type = "string";
              }
              {
                multiline = false;
                parts = [
                  {
                    type = "text";
                    value = "super";
                  }
                ];
                type = "string";
              }
              {
                multiline = false;
                parts = [
                  {
                    type = "text";
                    value = "s";
                  }
                ];
                type = "string";
              }
            ];
            type = "list";
          };
          description = {
            multiline = true;
            parts = [
              {
                type = "text";
                value = "Shortcut to toggle stacked layout\n\nDefine as a list of keys, e.g., [ \"super\" \"q\" ].\nSupported modifiers: super, ctrl, alt, shift.";
              }
            ];
            type = "string";
          };
          type = {
            arguments = [
              {
                items = [
                  {
                    name = "type";
                    path = [
                      {
                        kind = "identifier";
                        value = "string";
                      }
                    ];
                    type = "variable";
                  }
                ];
                type = "list";
              }
            ];
            callee = {
              name = "type";
              path = [
                {
                  kind = "identifier";
                  value = "list";
                }
              ];
              type = "variable";
            };
            type = "call";
          };
          zenosVersion = {
            kind = "version";
            type = "literal";
            value = "1.0.0Na";
          };
        };
        path = [
          "keybindings"
          "con-stacked-layout-toggle"
        ];
      }
      {
        metadata = {
          default = {
            items = [
              {
                multiline = false;
                parts = [
                  {
                    type = "text";
                    value = "shift";
                  }
                ];
                type = "string";
              }
              {
                multiline = false;
                parts = [
                  {
                    type = "text";
                    value = "super";
                  }
                ];
                type = "string";
              }
              {
                multiline = false;
                parts = [
                  {
                    type = "text";
                    value = "t";
                  }
                ];
                type = "string";
              }
            ];
            type = "list";
          };
          description = {
            multiline = true;
            parts = [
              {
                type = "text";
                value = "Shortcut to toggle tabbed layout\n\nDefine as a list of keys, e.g., [ \"super\" \"q\" ].\nSupported modifiers: super, ctrl, alt, shift.";
              }
            ];
            type = "string";
          };
          type = {
            arguments = [
              {
                items = [
                  {
                    name = "type";
                    path = [
                      {
                        kind = "identifier";
                        value = "string";
                      }
                    ];
                    type = "variable";
                  }
                ];
                type = "list";
              }
            ];
            callee = {
              name = "type";
              path = [
                {
                  kind = "identifier";
                  value = "list";
                }
              ];
              type = "variable";
            };
            type = "call";
          };
          zenosVersion = {
            kind = "version";
            type = "literal";
            value = "1.0.0Na";
          };
        };
        path = [
          "keybindings"
          "con-tabbed-layout-toggle"
        ];
      }
      {
        metadata = {
          default = {
            items = [
              {
                multiline = false;
                parts = [
                  {
                    type = "text";
                    value = "ctrl";
                  }
                ];
                type = "string";
              }
              {
                multiline = false;
                parts = [
                  {
                    type = "text";
                    value = "alt";
                  }
                ];
                type = "string";
              }
              {
                multiline = false;
                parts = [
                  {
                    type = "text";
                    value = "y";
                  }
                ];
                type = "string";
              }
            ];
            type = "list";
          };
          description = {
            multiline = true;
            parts = [
              {
                type = "text";
                value = "Shortcut to toggle tab decorations\n\nDefine as a list of keys, e.g., [ \"super\" \"q\" ].\nSupported modifiers: super, ctrl, alt, shift.";
              }
            ];
            type = "string";
          };
          type = {
            arguments = [
              {
                items = [
                  {
                    name = "type";
                    path = [
                      {
                        kind = "identifier";
                        value = "string";
                      }
                    ];
                    type = "variable";
                  }
                ];
                type = "list";
              }
            ];
            callee = {
              name = "type";
              path = [
                {
                  kind = "identifier";
                  value = "list";
                }
              ];
              type = "variable";
            };
            type = "call";
          };
          zenosVersion = {
            kind = "version";
            type = "literal";
            value = "1.0.0Na";
          };
        };
        path = [
          "keybindings"
          "con-tabbed-showtab-decoration-toggle"
        ];
      }
      {
        metadata = {
          default = {
            items = [
              {
                multiline = false;
                parts = [
                  {
                    type = "text";
                    value = "ctrl";
                  }
                ];
                type = "string";
              }
              {
                multiline = false;
                parts = [
                  {
                    type = "text";
                    value = "super";
                  }
                ];
                type = "string";
              }
              {
                multiline = false;
                parts = [
                  {
                    type = "text";
                    value = "h";
                  }
                ];
                type = "string";
              }
            ];
            type = "list";
          };
          description = {
            multiline = true;
            parts = [
              {
                type = "text";
                value = "Shortcut to swap window with left neighbor\n\nDefine as a list of keys, e.g., [ \"super\" \"q\" ].\nSupported modifiers: super, ctrl, alt, shift.";
              }
            ];
            type = "string";
          };
          type = {
            arguments = [
              {
                items = [
                  {
                    name = "type";
                    path = [
                      {
                        kind = "identifier";
                        value = "string";
                      }
                    ];
                    type = "variable";
                  }
                ];
                type = "list";
              }
            ];
            callee = {
              name = "type";
              path = [
                {
                  kind = "identifier";
                  value = "list";
                }
              ];
              type = "variable";
            };
            type = "call";
          };
          zenosVersion = {
            kind = "version";
            type = "literal";
            value = "1.0.0Na";
          };
        };
        path = [
          "keybindings"
          "window-swap-left"
        ];
      }
      {
        metadata = {
          default = {
            items = [
              {
                multiline = false;
                parts = [
                  {
                    type = "text";
                    value = "ctrl";
                  }
                ];
                type = "string";
              }
              {
                multiline = false;
                parts = [
                  {
                    type = "text";
                    value = "super";
                  }
                ];
                type = "string";
              }
              {
                multiline = false;
                parts = [
                  {
                    type = "text";
                    value = "j";
                  }
                ];
                type = "string";
              }
            ];
            type = "list";
          };
          description = {
            multiline = true;
            parts = [
              {
                type = "text";
                value = "Shortcut to swap window with lower neighbor\n\nDefine as a list of keys, e.g., [ \"super\" \"q\" ].\nSupported modifiers: super, ctrl, alt, shift.";
              }
            ];
            type = "string";
          };
          type = {
            arguments = [
              {
                items = [
                  {
                    name = "type";
                    path = [
                      {
                        kind = "identifier";
                        value = "string";
                      }
                    ];
                    type = "variable";
                  }
                ];
                type = "list";
              }
            ];
            callee = {
              name = "type";
              path = [
                {
                  kind = "identifier";
                  value = "list";
                }
              ];
              type = "variable";
            };
            type = "call";
          };
          zenosVersion = {
            kind = "version";
            type = "literal";
            value = "1.0.0Na";
          };
        };
        path = [
          "keybindings"
          "window-swap-down"
        ];
      }
      {
        metadata = {
          default = {
            items = [
              {
                multiline = false;
                parts = [
                  {
                    type = "text";
                    value = "ctrl";
                  }
                ];
                type = "string";
              }
              {
                multiline = false;
                parts = [
                  {
                    type = "text";
                    value = "super";
                  }
                ];
                type = "string";
              }
              {
                multiline = false;
                parts = [
                  {
                    type = "text";
                    value = "k";
                  }
                ];
                type = "string";
              }
            ];
            type = "list";
          };
          description = {
            multiline = true;
            parts = [
              {
                type = "text";
                value = "Shortcut to swap window with upper neighbor\n\nDefine as a list of keys, e.g., [ \"super\" \"q\" ].\nSupported modifiers: super, ctrl, alt, shift.";
              }
            ];
            type = "string";
          };
          type = {
            arguments = [
              {
                items = [
                  {
                    name = "type";
                    path = [
                      {
                        kind = "identifier";
                        value = "string";
                      }
                    ];
                    type = "variable";
                  }
                ];
                type = "list";
              }
            ];
            callee = {
              name = "type";
              path = [
                {
                  kind = "identifier";
                  value = "list";
                }
              ];
              type = "variable";
            };
            type = "call";
          };
          zenosVersion = {
            kind = "version";
            type = "literal";
            value = "1.0.0Na";
          };
        };
        path = [
          "keybindings"
          "window-swap-up"
        ];
      }
      {
        metadata = {
          default = {
            items = [
              {
                multiline = false;
                parts = [
                  {
                    type = "text";
                    value = "ctrl";
                  }
                ];
                type = "string";
              }
              {
                multiline = false;
                parts = [
                  {
                    type = "text";
                    value = "super";
                  }
                ];
                type = "string";
              }
              {
                multiline = false;
                parts = [
                  {
                    type = "text";
                    value = "l";
                  }
                ];
                type = "string";
              }
            ];
            type = "list";
          };
          description = {
            multiline = true;
            parts = [
              {
                type = "text";
                value = "Shortcut to swap window with right neighbor\n\nDefine as a list of keys, e.g., [ \"super\" \"q\" ].\nSupported modifiers: super, ctrl, alt, shift.";
              }
            ];
            type = "string";
          };
          type = {
            arguments = [
              {
                items = [
                  {
                    name = "type";
                    path = [
                      {
                        kind = "identifier";
                        value = "string";
                      }
                    ];
                    type = "variable";
                  }
                ];
                type = "list";
              }
            ];
            callee = {
              name = "type";
              path = [
                {
                  kind = "identifier";
                  value = "list";
                }
              ];
              type = "variable";
            };
            type = "call";
          };
          zenosVersion = {
            kind = "version";
            type = "literal";
            value = "1.0.0Na";
          };
        };
        path = [
          "keybindings"
          "window-swap-right"
        ];
      }
      {
        metadata = {
          default = {
            items = [
              {
                multiline = false;
                parts = [
                  {
                    type = "text";
                    value = "shift";
                  }
                ];
                type = "string";
              }
              {
                multiline = false;
                parts = [
                  {
                    type = "text";
                    value = "super";
                  }
                ];
                type = "string";
              }
              {
                multiline = false;
                parts = [
                  {
                    type = "text";
                    value = "h";
                  }
                ];
                type = "string";
              }
            ];
            type = "list";
          };
          description = {
            multiline = true;
            parts = [
              {
                type = "text";
                value = "Shortcut to move window left\n\nDefine as a list of keys, e.g., [ \"super\" \"q\" ].\nSupported modifiers: super, ctrl, alt, shift.";
              }
            ];
            type = "string";
          };
          type = {
            arguments = [
              {
                items = [
                  {
                    name = "type";
                    path = [
                      {
                        kind = "identifier";
                        value = "string";
                      }
                    ];
                    type = "variable";
                  }
                ];
                type = "list";
              }
            ];
            callee = {
              name = "type";
              path = [
                {
                  kind = "identifier";
                  value = "list";
                }
              ];
              type = "variable";
            };
            type = "call";
          };
          zenosVersion = {
            kind = "version";
            type = "literal";
            value = "1.0.0Na";
          };
        };
        path = [
          "keybindings"
          "window-move-left"
        ];
      }
      {
        metadata = {
          default = {
            items = [
              {
                multiline = false;
                parts = [
                  {
                    type = "text";
                    value = "shift";
                  }
                ];
                type = "string";
              }
              {
                multiline = false;
                parts = [
                  {
                    type = "text";
                    value = "super";
                  }
                ];
                type = "string";
              }
              {
                multiline = false;
                parts = [
                  {
                    type = "text";
                    value = "j";
                  }
                ];
                type = "string";
              }
            ];
            type = "list";
          };
          description = {
            multiline = true;
            parts = [
              {
                type = "text";
                value = "Shortcut to move window down\n\nDefine as a list of keys, e.g., [ \"super\" \"q\" ].\nSupported modifiers: super, ctrl, alt, shift.";
              }
            ];
            type = "string";
          };
          type = {
            arguments = [
              {
                items = [
                  {
                    name = "type";
                    path = [
                      {
                        kind = "identifier";
                        value = "string";
                      }
                    ];
                    type = "variable";
                  }
                ];
                type = "list";
              }
            ];
            callee = {
              name = "type";
              path = [
                {
                  kind = "identifier";
                  value = "list";
                }
              ];
              type = "variable";
            };
            type = "call";
          };
          zenosVersion = {
            kind = "version";
            type = "literal";
            value = "1.0.0Na";
          };
        };
        path = [
          "keybindings"
          "window-move-down"
        ];
      }
      {
        metadata = {
          default = {
            items = [
              {
                multiline = false;
                parts = [
                  {
                    type = "text";
                    value = "shift";
                  }
                ];
                type = "string";
              }
              {
                multiline = false;
                parts = [
                  {
                    type = "text";
                    value = "super";
                  }
                ];
                type = "string";
              }
              {
                multiline = false;
                parts = [
                  {
                    type = "text";
                    value = "k";
                  }
                ];
                type = "string";
              }
            ];
            type = "list";
          };
          description = {
            multiline = true;
            parts = [
              {
                type = "text";
                value = "Shortcut to move window up\n\nDefine as a list of keys, e.g., [ \"super\" \"q\" ].\nSupported modifiers: super, ctrl, alt, shift.";
              }
            ];
            type = "string";
          };
          type = {
            arguments = [
              {
                items = [
                  {
                    name = "type";
                    path = [
                      {
                        kind = "identifier";
                        value = "string";
                      }
                    ];
                    type = "variable";
                  }
                ];
                type = "list";
              }
            ];
            callee = {
              name = "type";
              path = [
                {
                  kind = "identifier";
                  value = "list";
                }
              ];
              type = "variable";
            };
            type = "call";
          };
          zenosVersion = {
            kind = "version";
            type = "literal";
            value = "1.0.0Na";
          };
        };
        path = [
          "keybindings"
          "window-move-up"
        ];
      }
      {
        metadata = {
          default = {
            items = [
              {
                multiline = false;
                parts = [
                  {
                    type = "text";
                    value = "shift";
                  }
                ];
                type = "string";
              }
              {
                multiline = false;
                parts = [
                  {
                    type = "text";
                    value = "super";
                  }
                ];
                type = "string";
              }
              {
                multiline = false;
                parts = [
                  {
                    type = "text";
                    value = "l";
                  }
                ];
                type = "string";
              }
            ];
            type = "list";
          };
          description = {
            multiline = true;
            parts = [
              {
                type = "text";
                value = "Shortcut to move window right\n\nDefine as a list of keys, e.g., [ \"super\" \"q\" ].\nSupported modifiers: super, ctrl, alt, shift.";
              }
            ];
            type = "string";
          };
          type = {
            arguments = [
              {
                items = [
                  {
                    name = "type";
                    path = [
                      {
                        kind = "identifier";
                        value = "string";
                      }
                    ];
                    type = "variable";
                  }
                ];
                type = "list";
              }
            ];
            callee = {
              name = "type";
              path = [
                {
                  kind = "identifier";
                  value = "list";
                }
              ];
              type = "variable";
            };
            type = "call";
          };
          zenosVersion = {
            kind = "version";
            type = "literal";
            value = "1.0.0Na";
          };
        };
        path = [
          "keybindings"
          "window-move-right"
        ];
      }
      {
        metadata = {
          default = {
            items = [
              {
                multiline = false;
                parts = [
                  {
                    type = "text";
                    value = "super";
                  }
                ];
                type = "string";
              }
              {
                multiline = false;
                parts = [
                  {
                    type = "text";
                    value = "h";
                  }
                ];
                type = "string";
              }
            ];
            type = "list";
          };
          description = {
            multiline = true;
            parts = [
              {
                type = "text";
                value = "Shortcut to focus left neighbor\n\nDefine as a list of keys, e.g., [ \"super\" \"q\" ].\nSupported modifiers: super, ctrl, alt, shift.";
              }
            ];
            type = "string";
          };
          type = {
            arguments = [
              {
                items = [
                  {
                    name = "type";
                    path = [
                      {
                        kind = "identifier";
                        value = "string";
                      }
                    ];
                    type = "variable";
                  }
                ];
                type = "list";
              }
            ];
            callee = {
              name = "type";
              path = [
                {
                  kind = "identifier";
                  value = "list";
                }
              ];
              type = "variable";
            };
            type = "call";
          };
          zenosVersion = {
            kind = "version";
            type = "literal";
            value = "1.0.0Na";
          };
        };
        path = [
          "keybindings"
          "window-focus-left"
        ];
      }
      {
        metadata = {
          default = {
            items = [
              {
                multiline = false;
                parts = [
                  {
                    type = "text";
                    value = "super";
                  }
                ];
                type = "string";
              }
              {
                multiline = false;
                parts = [
                  {
                    type = "text";
                    value = "j";
                  }
                ];
                type = "string";
              }
            ];
            type = "list";
          };
          description = {
            multiline = true;
            parts = [
              {
                type = "text";
                value = "Shortcut to focus lower neighbor\n\nDefine as a list of keys, e.g., [ \"super\" \"q\" ].\nSupported modifiers: super, ctrl, alt, shift.";
              }
            ];
            type = "string";
          };
          type = {
            arguments = [
              {
                items = [
                  {
                    name = "type";
                    path = [
                      {
                        kind = "identifier";
                        value = "string";
                      }
                    ];
                    type = "variable";
                  }
                ];
                type = "list";
              }
            ];
            callee = {
              name = "type";
              path = [
                {
                  kind = "identifier";
                  value = "list";
                }
              ];
              type = "variable";
            };
            type = "call";
          };
          zenosVersion = {
            kind = "version";
            type = "literal";
            value = "1.0.0Na";
          };
        };
        path = [
          "keybindings"
          "window-focus-down"
        ];
      }
      {
        metadata = {
          default = {
            items = [
              {
                multiline = false;
                parts = [
                  {
                    type = "text";
                    value = "super";
                  }
                ];
                type = "string";
              }
              {
                multiline = false;
                parts = [
                  {
                    type = "text";
                    value = "k";
                  }
                ];
                type = "string";
              }
            ];
            type = "list";
          };
          description = {
            multiline = true;
            parts = [
              {
                type = "text";
                value = "Shortcut to focus upper neighbor\n\nDefine as a list of keys, e.g., [ \"super\" \"q\" ].\nSupported modifiers: super, ctrl, alt, shift.";
              }
            ];
            type = "string";
          };
          type = {
            arguments = [
              {
                items = [
                  {
                    name = "type";
                    path = [
                      {
                        kind = "identifier";
                        value = "string";
                      }
                    ];
                    type = "variable";
                  }
                ];
                type = "list";
              }
            ];
            callee = {
              name = "type";
              path = [
                {
                  kind = "identifier";
                  value = "list";
                }
              ];
              type = "variable";
            };
            type = "call";
          };
          zenosVersion = {
            kind = "version";
            type = "literal";
            value = "1.0.0Na";
          };
        };
        path = [
          "keybindings"
          "window-focus-up"
        ];
      }
      {
        metadata = {
          default = {
            items = [
              {
                multiline = false;
                parts = [
                  {
                    type = "text";
                    value = "super";
                  }
                ];
                type = "string";
              }
              {
                multiline = false;
                parts = [
                  {
                    type = "text";
                    value = "l";
                  }
                ];
                type = "string";
              }
            ];
            type = "list";
          };
          description = {
            multiline = true;
            parts = [
              {
                type = "text";
                value = "Shortcut to focus right neighbor\n\nDefine as a list of keys, e.g., [ \"super\" \"q\" ].\nSupported modifiers: super, ctrl, alt, shift.";
              }
            ];
            type = "string";
          };
          type = {
            arguments = [
              {
                items = [
                  {
                    name = "type";
                    path = [
                      {
                        kind = "identifier";
                        value = "string";
                      }
                    ];
                    type = "variable";
                  }
                ];
                type = "list";
              }
            ];
            callee = {
              name = "type";
              path = [
                {
                  kind = "identifier";
                  value = "list";
                }
              ];
              type = "variable";
            };
            type = "call";
          };
          zenosVersion = {
            kind = "version";
            type = "literal";
            value = "1.0.0Na";
          };
        };
        path = [
          "keybindings"
          "window-focus-right"
        ];
      }
      {
        metadata = {
          default = {
            items = [
              {
                multiline = false;
                parts = [
                  {
                    type = "text";
                    value = "super";
                  }
                ];
                type = "string";
              }
              {
                multiline = false;
                parts = [
                  {
                    type = "text";
                    value = "c";
                  }
                ];
                type = "string";
              }
            ];
            type = "list";
          };
          description = {
            multiline = true;
            parts = [
              {
                type = "text";
                value = "Shortcut to toggle floating for active window\n\nDefine as a list of keys, e.g., [ \"super\" \"q\" ].\nSupported modifiers: super, ctrl, alt, shift.";
              }
            ];
            type = "string";
          };
          type = {
            arguments = [
              {
                items = [
                  {
                    name = "type";
                    path = [
                      {
                        kind = "identifier";
                        value = "string";
                      }
                    ];
                    type = "variable";
                  }
                ];
                type = "list";
              }
            ];
            callee = {
              name = "type";
              path = [
                {
                  kind = "identifier";
                  value = "list";
                }
              ];
              type = "variable";
            };
            type = "call";
          };
          zenosVersion = {
            kind = "version";
            type = "literal";
            value = "1.0.0Na";
          };
        };
        path = [
          "keybindings"
          "window-toggle-float"
        ];
      }
      {
        metadata = {
          default = {
            items = [
              {
                multiline = false;
                parts = [
                  {
                    type = "text";
                    value = "shift";
                  }
                ];
                type = "string";
              }
              {
                multiline = false;
                parts = [
                  {
                    type = "text";
                    value = "super";
                  }
                ];
                type = "string";
              }
              {
                multiline = false;
                parts = [
                  {
                    type = "text";
                    value = "c";
                  }
                ];
                type = "string";
              }
            ];
            type = "list";
          };
          description = {
            multiline = true;
            parts = [
              {
                type = "text";
                value = "Shortcut to force permanent float for app\n\nDefine as a list of keys, e.g., [ \"super\" \"q\" ].\nSupported modifiers: super, ctrl, alt, shift.";
              }
            ];
            type = "string";
          };
          type = {
            arguments = [
              {
                items = [
                  {
                    name = "type";
                    path = [
                      {
                        kind = "identifier";
                        value = "string";
                      }
                    ];
                    type = "variable";
                  }
                ];
                type = "list";
              }
            ];
            callee = {
              name = "type";
              path = [
                {
                  kind = "identifier";
                  value = "list";
                }
              ];
              type = "variable";
            };
            type = "call";
          };
          zenosVersion = {
            kind = "version";
            type = "literal";
            value = "1.0.0Na";
          };
        };
        path = [
          "keybindings"
          "window-toggle-always-float"
        ];
      }
      {
        metadata = {
          default = {
            items = [
              {
                multiline = false;
                parts = [
                  {
                    type = "text";
                    value = "shift";
                  }
                ];
                type = "string";
              }
              {
                multiline = false;
                parts = [
                  {
                    type = "text";
                    value = "super";
                  }
                ];
                type = "string";
              }
              {
                multiline = false;
                parts = [
                  {
                    type = "text";
                    value = "w";
                  }
                ];
                type = "string";
              }
            ];
            type = "list";
          };
          description = {
            multiline = true;
            parts = [
              {
                type = "text";
                value = "Shortcut to toggle tiling for current desktop\n\nDefine as a list of keys, e.g., [ \"super\" \"q\" ].\nSupported modifiers: super, ctrl, alt, shift.";
              }
            ];
            type = "string";
          };
          type = {
            arguments = [
              {
                items = [
                  {
                    name = "type";
                    path = [
                      {
                        kind = "identifier";
                        value = "string";
                      }
                    ];
                    type = "variable";
                  }
                ];
                type = "list";
              }
            ];
            callee = {
              name = "type";
              path = [
                {
                  kind = "identifier";
                  value = "list";
                }
              ];
              type = "variable";
            };
            type = "call";
          };
          zenosVersion = {
            kind = "version";
            type = "literal";
            value = "1.0.0Na";
          };
        };
        path = [
          "keybindings"
          "workspace-active-tile-toggle"
        ];
      }
      {
        metadata = {
          default = {
            items = [
              {
                multiline = false;
                parts = [
                  {
                    type = "text";
                    value = "super";
                  }
                ];
                type = "string";
              }
              {
                multiline = false;
                parts = [
                  {
                    type = "text";
                    value = "period";
                  }
                ];
                type = "string";
              }
            ];
            type = "list";
          };
          description = {
            multiline = true;
            parts = [
              {
                type = "text";
                value = "Shortcut to open Forge preferences\n\nDefine as a list of keys, e.g., [ \"super\" \"q\" ].\nSupported modifiers: super, ctrl, alt, shift.";
              }
            ];
            type = "string";
          };
          type = {
            arguments = [
              {
                items = [
                  {
                    name = "type";
                    path = [
                      {
                        kind = "identifier";
                        value = "string";
                      }
                    ];
                    type = "variable";
                  }
                ];
                type = "list";
              }
            ];
            callee = {
              name = "type";
              path = [
                {
                  kind = "identifier";
                  value = "list";
                }
              ];
              type = "variable";
            };
            type = "call";
          };
          zenosVersion = {
            kind = "version";
            type = "literal";
            value = "1.0.0Na";
          };
        };
        path = [
          "keybindings"
          "prefs-open"
        ];
      }
      {
        metadata = {
          default = {
            items = [
              {
                multiline = false;
                parts = [
                  {
                    type = "text";
                    value = "super";
                  }
                ];
                type = "string";
              }
              {
                multiline = false;
                parts = [
                  {
                    type = "text";
                    value = "w";
                  }
                ];
                type = "string";
              }
            ];
            type = "list";
          };
          description = {
            multiline = true;
            parts = [
              {
                type = "text";
                value = "Shortcut to toggle tiling mode\n\nDefine as a list of keys, e.g., [ \"super\" \"q\" ].\nSupported modifiers: super, ctrl, alt, shift.";
              }
            ];
            type = "string";
          };
          type = {
            arguments = [
              {
                items = [
                  {
                    name = "type";
                    path = [
                      {
                        kind = "identifier";
                        value = "string";
                      }
                    ];
                    type = "variable";
                  }
                ];
                type = "list";
              }
            ];
            callee = {
              name = "type";
              path = [
                {
                  kind = "identifier";
                  value = "list";
                }
              ];
              type = "variable";
            };
            type = "call";
          };
          zenosVersion = {
            kind = "version";
            type = "literal";
            value = "1.0.0Na";
          };
        };
        path = [
          "keybindings"
          "prefs-tiling-toggle"
        ];
      }
      {
        metadata = {
          default = {
            multiline = false;
            parts = [
              {
                type = "text";
                value = "None";
              }
            ];
            type = "string";
          };
          description = {
            multiline = true;
            parts = [
              {
                type = "text";
                value = "Modifier key for mouse-based tiling operations";
              }
            ];
            type = "string";
          };
          type = {
            arguments = [
              {
                items = [
                  {
                    multiline = false;
                    parts = [
                      {
                        type = "text";
                        value = "Super";
                      }
                    ];
                    type = "string";
                  }
                  {
                    multiline = false;
                    parts = [
                      {
                        type = "text";
                        value = "Ctrl";
                      }
                    ];
                    type = "string";
                  }
                  {
                    multiline = false;
                    parts = [
                      {
                        type = "text";
                        value = "Shift";
                      }
                    ];
                    type = "string";
                  }
                  {
                    multiline = false;
                    parts = [
                      {
                        type = "text";
                        value = "Alt";
                      }
                    ];
                    type = "string";
                  }
                  {
                    multiline = false;
                    parts = [
                      {
                        type = "text";
                        value = "None";
                      }
                    ];
                    type = "string";
                  }
                ];
                type = "list";
              }
            ];
            callee = {
              name = "type";
              path = [
                {
                  kind = "identifier";
                  value = "enum";
                }
              ];
              type = "variable";
            };
            type = "call";
          };
          zenosVersion = {
            kind = "version";
            type = "literal";
            value = "1.0.0Na";
          };
        };
        path = [
          "keybindings"
          "mod-mask-mouse-tile"
        ];
      }
      {
        metadata = {
          default = {
            items = [
              {
                multiline = false;
                parts = [
                  {
                    type = "text";
                    value = "super";
                  }
                ];
                type = "string";
              }
              {
                multiline = false;
                parts = [
                  {
                    type = "text";
                    value = "return";
                  }
                ];
                type = "string";
              }
            ];
            type = "list";
          };
          description = {
            multiline = true;
            parts = [
              {
                type = "text";
                value = "Shortcut to swap with previously active window\n\nDefine as a list of keys, e.g., [ \"super\" \"q\" ].\nSupported modifiers: super, ctrl, alt, shift.";
              }
            ];
            type = "string";
          };
          type = {
            arguments = [
              {
                items = [
                  {
                    name = "type";
                    path = [
                      {
                        kind = "identifier";
                        value = "string";
                      }
                    ];
                    type = "variable";
                  }
                ];
                type = "list";
              }
            ];
            callee = {
              name = "type";
              path = [
                {
                  kind = "identifier";
                  value = "list";
                }
              ];
              type = "variable";
            };
            type = "call";
          };
          zenosVersion = {
            kind = "version";
            type = "literal";
            value = "1.0.0Na";
          };
        };
        path = [
          "keybindings"
          "window-swap-last-active"
        ];
      }
      {
        metadata = {
          default = {
            items = [
              {
                multiline = false;
                parts = [
                  {
                    type = "text";
                    value = "ctrl";
                  }
                ];
                type = "string";
              }
              {
                multiline = false;
                parts = [
                  {
                    type = "text";
                    value = "alt";
                  }
                ];
                type = "string";
              }
              {
                multiline = false;
                parts = [
                  {
                    type = "text";
                    value = "g";
                  }
                ];
                type = "string";
              }
            ];
            type = "list";
          };
          description = {
            multiline = true;
            parts = [
              {
                type = "text";
                value = "Snap active window to 1/3 right\n\nDefine as a list of keys, e.g., [ \"super\" \"q\" ].\nSupported modifiers: super, ctrl, alt, shift.";
              }
            ];
            type = "string";
          };
          type = {
            arguments = [
              {
                items = [
                  {
                    name = "type";
                    path = [
                      {
                        kind = "identifier";
                        value = "string";
                      }
                    ];
                    type = "variable";
                  }
                ];
                type = "list";
              }
            ];
            callee = {
              name = "type";
              path = [
                {
                  kind = "identifier";
                  value = "list";
                }
              ];
              type = "variable";
            };
            type = "call";
          };
          zenosVersion = {
            kind = "version";
            type = "literal";
            value = "1.0.0Na";
          };
        };
        path = [
          "keybindings"
          "window-snap-one-third-right"
        ];
      }
      {
        metadata = {
          default = {
            items = [
              {
                multiline = false;
                parts = [
                  {
                    type = "text";
                    value = "ctrl";
                  }
                ];
                type = "string";
              }
              {
                multiline = false;
                parts = [
                  {
                    type = "text";
                    value = "alt";
                  }
                ];
                type = "string";
              }
              {
                multiline = false;
                parts = [
                  {
                    type = "text";
                    value = "t";
                  }
                ];
                type = "string";
              }
            ];
            type = "list";
          };
          description = {
            multiline = true;
            parts = [
              {
                type = "text";
                value = "Snap active window to 2/3 right\n\nDefine as a list of keys, e.g., [ \"super\" \"q\" ].\nSupported modifiers: super, ctrl, alt, shift.";
              }
            ];
            type = "string";
          };
          type = {
            arguments = [
              {
                items = [
                  {
                    name = "type";
                    path = [
                      {
                        kind = "identifier";
                        value = "string";
                      }
                    ];
                    type = "variable";
                  }
                ];
                type = "list";
              }
            ];
            callee = {
              name = "type";
              path = [
                {
                  kind = "identifier";
                  value = "list";
                }
              ];
              type = "variable";
            };
            type = "call";
          };
          zenosVersion = {
            kind = "version";
            type = "literal";
            value = "1.0.0Na";
          };
        };
        path = [
          "keybindings"
          "window-snap-two-third-right"
        ];
      }
      {
        metadata = {
          default = {
            items = [
              {
                multiline = false;
                parts = [
                  {
                    type = "text";
                    value = "ctrl";
                  }
                ];
                type = "string";
              }
              {
                multiline = false;
                parts = [
                  {
                    type = "text";
                    value = "alt";
                  }
                ];
                type = "string";
              }
              {
                multiline = false;
                parts = [
                  {
                    type = "text";
                    value = "d";
                  }
                ];
                type = "string";
              }
            ];
            type = "list";
          };
          description = {
            multiline = true;
            parts = [
              {
                type = "text";
                value = "Snap active window to 1/3 left\n\nDefine as a list of keys, e.g., [ \"super\" \"q\" ].\nSupported modifiers: super, ctrl, alt, shift.";
              }
            ];
            type = "string";
          };
          type = {
            arguments = [
              {
                items = [
                  {
                    name = "type";
                    path = [
                      {
                        kind = "identifier";
                        value = "string";
                      }
                    ];
                    type = "variable";
                  }
                ];
                type = "list";
              }
            ];
            callee = {
              name = "type";
              path = [
                {
                  kind = "identifier";
                  value = "list";
                }
              ];
              type = "variable";
            };
            type = "call";
          };
          zenosVersion = {
            kind = "version";
            type = "literal";
            value = "1.0.0Na";
          };
        };
        path = [
          "keybindings"
          "window-snap-one-third-left"
        ];
      }
      {
        metadata = {
          default = {
            items = [
              {
                multiline = false;
                parts = [
                  {
                    type = "text";
                    value = "ctrl";
                  }
                ];
                type = "string";
              }
              {
                multiline = false;
                parts = [
                  {
                    type = "text";
                    value = "alt";
                  }
                ];
                type = "string";
              }
              {
                multiline = false;
                parts = [
                  {
                    type = "text";
                    value = "e";
                  }
                ];
                type = "string";
              }
            ];
            type = "list";
          };
          description = {
            multiline = true;
            parts = [
              {
                type = "text";
                value = "Snap active window to 2/3 left\n\nDefine as a list of keys, e.g., [ \"super\" \"q\" ].\nSupported modifiers: super, ctrl, alt, shift.";
              }
            ];
            type = "string";
          };
          type = {
            arguments = [
              {
                items = [
                  {
                    name = "type";
                    path = [
                      {
                        kind = "identifier";
                        value = "string";
                      }
                    ];
                    type = "variable";
                  }
                ];
                type = "list";
              }
            ];
            callee = {
              name = "type";
              path = [
                {
                  kind = "identifier";
                  value = "list";
                }
              ];
              type = "variable";
            };
            type = "call";
          };
          zenosVersion = {
            kind = "version";
            type = "literal";
            value = "1.0.0Na";
          };
        };
        path = [
          "keybindings"
          "window-snap-two-third-left"
        ];
      }
      {
        metadata = {
          default = {
            items = [
              {
                multiline = false;
                parts = [
                  {
                    type = "text";
                    value = "ctrl";
                  }
                ];
                type = "string";
              }
              {
                multiline = false;
                parts = [
                  {
                    type = "text";
                    value = "alt";
                  }
                ];
                type = "string";
              }
              {
                multiline = false;
                parts = [
                  {
                    type = "text";
                    value = "c";
                  }
                ];
                type = "string";
              }
            ];
            type = "list";
          };
          description = {
            multiline = true;
            parts = [
              {
                type = "text";
                value = "Snap active window to center\n\nDefine as a list of keys, e.g., [ \"super\" \"q\" ].\nSupported modifiers: super, ctrl, alt, shift.";
              }
            ];
            type = "string";
          };
          type = {
            arguments = [
              {
                items = [
                  {
                    name = "type";
                    path = [
                      {
                        kind = "identifier";
                        value = "string";
                      }
                    ];
                    type = "variable";
                  }
                ];
                type = "list";
              }
            ];
            callee = {
              name = "type";
              path = [
                {
                  kind = "identifier";
                  value = "list";
                }
              ];
              type = "variable";
            };
            type = "call";
          };
          zenosVersion = {
            kind = "version";
            type = "literal";
            value = "1.0.0Na";
          };
        };
        path = [
          "keybindings"
          "window-snap-center"
        ];
      }
      {
        metadata = {
          default = {
            items = [
              {
                multiline = false;
                parts = [
                  {
                    type = "text";
                    value = "ctrl";
                  }
                ];
                type = "string";
              }
              {
                multiline = false;
                parts = [
                  {
                    type = "text";
                    value = "super";
                  }
                ];
                type = "string";
              }
              {
                multiline = false;
                parts = [
                  {
                    type = "text";
                    value = "y";
                  }
                ];
                type = "string";
              }
            ];
            type = "list";
          };
          description = {
            multiline = true;
            parts = [
              {
                type = "text";
                value = "Resize window leftwards\n\nDefine as a list of keys, e.g., [ \"super\" \"q\" ].\nSupported modifiers: super, ctrl, alt, shift.";
              }
            ];
            type = "string";
          };
          type = {
            arguments = [
              {
                items = [
                  {
                    name = "type";
                    path = [
                      {
                        kind = "identifier";
                        value = "string";
                      }
                    ];
                    type = "variable";
                  }
                ];
                type = "list";
              }
            ];
            callee = {
              name = "type";
              path = [
                {
                  kind = "identifier";
                  value = "list";
                }
              ];
              type = "variable";
            };
            type = "call";
          };
          zenosVersion = {
            kind = "version";
            type = "literal";
            value = "1.0.0Na";
          };
        };
        path = [
          "keybindings"
          "window-resize-left-increase"
        ];
      }
      {
        metadata = {
          default = {
            items = [
              {
                multiline = false;
                parts = [
                  {
                    type = "text";
                    value = "ctrl";
                  }
                ];
                type = "string";
              }
              {
                multiline = false;
                parts = [
                  {
                    type = "text";
                    value = "shift";
                  }
                ];
                type = "string";
              }
              {
                multiline = false;
                parts = [
                  {
                    type = "text";
                    value = "super";
                  }
                ];
                type = "string";
              }
              {
                multiline = false;
                parts = [
                  {
                    type = "text";
                    value = "o";
                  }
                ];
                type = "string";
              }
            ];
            type = "list";
          };
          description = {
            multiline = true;
            parts = [
              {
                type = "text";
                value = "Shrink window from left\n\nDefine as a list of keys, e.g., [ \"super\" \"q\" ].\nSupported modifiers: super, ctrl, alt, shift.";
              }
            ];
            type = "string";
          };
          type = {
            arguments = [
              {
                items = [
                  {
                    name = "type";
                    path = [
                      {
                        kind = "identifier";
                        value = "string";
                      }
                    ];
                    type = "variable";
                  }
                ];
                type = "list";
              }
            ];
            callee = {
              name = "type";
              path = [
                {
                  kind = "identifier";
                  value = "list";
                }
              ];
              type = "variable";
            };
            type = "call";
          };
          zenosVersion = {
            kind = "version";
            type = "literal";
            value = "1.0.0Na";
          };
        };
        path = [
          "keybindings"
          "window-resize-left-decrease"
        ];
      }
      {
        metadata = {
          default = {
            items = [
              {
                multiline = false;
                parts = [
                  {
                    type = "text";
                    value = "ctrl";
                  }
                ];
                type = "string";
              }
              {
                multiline = false;
                parts = [
                  {
                    type = "text";
                    value = "super";
                  }
                ];
                type = "string";
              }
              {
                multiline = false;
                parts = [
                  {
                    type = "text";
                    value = "u";
                  }
                ];
                type = "string";
              }
            ];
            type = "list";
          };
          description = {
            multiline = true;
            parts = [
              {
                type = "text";
                value = "Resize window downwards\n\nDefine as a list of keys, e.g., [ \"super\" \"q\" ].\nSupported modifiers: super, ctrl, alt, shift.";
              }
            ];
            type = "string";
          };
          type = {
            arguments = [
              {
                items = [
                  {
                    name = "type";
                    path = [
                      {
                        kind = "identifier";
                        value = "string";
                      }
                    ];
                    type = "variable";
                  }
                ];
                type = "list";
              }
            ];
            callee = {
              name = "type";
              path = [
                {
                  kind = "identifier";
                  value = "list";
                }
              ];
              type = "variable";
            };
            type = "call";
          };
          zenosVersion = {
            kind = "version";
            type = "literal";
            value = "1.0.0Na";
          };
        };
        path = [
          "keybindings"
          "window-resize-bottom-increase"
        ];
      }
      {
        metadata = {
          default = {
            items = [
              {
                multiline = false;
                parts = [
                  {
                    type = "text";
                    value = "ctrl";
                  }
                ];
                type = "string";
              }
              {
                multiline = false;
                parts = [
                  {
                    type = "text";
                    value = "shift";
                  }
                ];
                type = "string";
              }
              {
                multiline = false;
                parts = [
                  {
                    type = "text";
                    value = "super";
                  }
                ];
                type = "string";
              }
              {
                multiline = false;
                parts = [
                  {
                    type = "text";
                    value = "i";
                  }
                ];
                type = "string";
              }
            ];
            type = "list";
          };
          description = {
            multiline = true;
            parts = [
              {
                type = "text";
                value = "Shrink window from bottom\n\nDefine as a list of keys, e.g., [ \"super\" \"q\" ].\nSupported modifiers: super, ctrl, alt, shift.";
              }
            ];
            type = "string";
          };
          type = {
            arguments = [
              {
                items = [
                  {
                    name = "type";
                    path = [
                      {
                        kind = "identifier";
                        value = "string";
                      }
                    ];
                    type = "variable";
                  }
                ];
                type = "list";
              }
            ];
            callee = {
              name = "type";
              path = [
                {
                  kind = "identifier";
                  value = "list";
                }
              ];
              type = "variable";
            };
            type = "call";
          };
          zenosVersion = {
            kind = "version";
            type = "literal";
            value = "1.0.0Na";
          };
        };
        path = [
          "keybindings"
          "window-resize-bottom-decrease"
        ];
      }
      {
        metadata = {
          default = {
            items = [
              {
                multiline = false;
                parts = [
                  {
                    type = "text";
                    value = "ctrl";
                  }
                ];
                type = "string";
              }
              {
                multiline = false;
                parts = [
                  {
                    type = "text";
                    value = "super";
                  }
                ];
                type = "string";
              }
              {
                multiline = false;
                parts = [
                  {
                    type = "text";
                    value = "i";
                  }
                ];
                type = "string";
              }
            ];
            type = "list";
          };
          description = {
            multiline = true;
            parts = [
              {
                type = "text";
                value = "Resize window upwards\n\nDefine as a list of keys, e.g., [ \"super\" \"q\" ].\nSupported modifiers: super, ctrl, alt, shift.";
              }
            ];
            type = "string";
          };
          type = {
            arguments = [
              {
                items = [
                  {
                    name = "type";
                    path = [
                      {
                        kind = "identifier";
                        value = "string";
                      }
                    ];
                    type = "variable";
                  }
                ];
                type = "list";
              }
            ];
            callee = {
              name = "type";
              path = [
                {
                  kind = "identifier";
                  value = "list";
                }
              ];
              type = "variable";
            };
            type = "call";
          };
          zenosVersion = {
            kind = "version";
            type = "literal";
            value = "1.0.0Na";
          };
        };
        path = [
          "keybindings"
          "window-resize-top-increase"
        ];
      }
      {
        metadata = {
          default = {
            items = [
              {
                multiline = false;
                parts = [
                  {
                    type = "text";
                    value = "ctrl";
                  }
                ];
                type = "string";
              }
              {
                multiline = false;
                parts = [
                  {
                    type = "text";
                    value = "shift";
                  }
                ];
                type = "string";
              }
              {
                multiline = false;
                parts = [
                  {
                    type = "text";
                    value = "super";
                  }
                ];
                type = "string";
              }
              {
                multiline = false;
                parts = [
                  {
                    type = "text";
                    value = "u";
                  }
                ];
                type = "string";
              }
            ];
            type = "list";
          };
          description = {
            multiline = true;
            parts = [
              {
                type = "text";
                value = "Shrink window from top\n\nDefine as a list of keys, e.g., [ \"super\" \"q\" ].\nSupported modifiers: super, ctrl, alt, shift.";
              }
            ];
            type = "string";
          };
          type = {
            arguments = [
              {
                items = [
                  {
                    name = "type";
                    path = [
                      {
                        kind = "identifier";
                        value = "string";
                      }
                    ];
                    type = "variable";
                  }
                ];
                type = "list";
              }
            ];
            callee = {
              name = "type";
              path = [
                {
                  kind = "identifier";
                  value = "list";
                }
              ];
              type = "variable";
            };
            type = "call";
          };
          zenosVersion = {
            kind = "version";
            type = "literal";
            value = "1.0.0Na";
          };
        };
        path = [
          "keybindings"
          "window-resize-top-decrease"
        ];
      }
      {
        metadata = {
          default = {
            items = [
              {
                multiline = false;
                parts = [
                  {
                    type = "text";
                    value = "ctrl";
                  }
                ];
                type = "string";
              }
              {
                multiline = false;
                parts = [
                  {
                    type = "text";
                    value = "super";
                  }
                ];
                type = "string";
              }
              {
                multiline = false;
                parts = [
                  {
                    type = "text";
                    value = "o";
                  }
                ];
                type = "string";
              }
            ];
            type = "list";
          };
          description = {
            multiline = true;
            parts = [
              {
                type = "text";
                value = "Resize window rightwards\n\nDefine as a list of keys, e.g., [ \"super\" \"q\" ].\nSupported modifiers: super, ctrl, alt, shift.";
              }
            ];
            type = "string";
          };
          type = {
            arguments = [
              {
                items = [
                  {
                    name = "type";
                    path = [
                      {
                        kind = "identifier";
                        value = "string";
                      }
                    ];
                    type = "variable";
                  }
                ];
                type = "list";
              }
            ];
            callee = {
              name = "type";
              path = [
                {
                  kind = "identifier";
                  value = "list";
                }
              ];
              type = "variable";
            };
            type = "call";
          };
          zenosVersion = {
            kind = "version";
            type = "literal";
            value = "1.0.0Na";
          };
        };
        path = [
          "keybindings"
          "window-resize-right-increase"
        ];
      }
      {
        metadata = {
          default = {
            items = [
              {
                multiline = false;
                parts = [
                  {
                    type = "text";
                    value = "ctrl";
                  }
                ];
                type = "string";
              }
              {
                multiline = false;
                parts = [
                  {
                    type = "text";
                    value = "shift";
                  }
                ];
                type = "string";
              }
              {
                multiline = false;
                parts = [
                  {
                    type = "text";
                    value = "super";
                  }
                ];
                type = "string";
              }
              {
                multiline = false;
                parts = [
                  {
                    type = "text";
                    value = "y";
                  }
                ];
                type = "string";
              }
            ];
            type = "list";
          };
          description = {
            multiline = true;
            parts = [
              {
                type = "text";
                value = "Shrink window from right\n\nDefine as a list of keys, e.g., [ \"super\" \"q\" ].\nSupported modifiers: super, ctrl, alt, shift.";
              }
            ];
            type = "string";
          };
          type = {
            arguments = [
              {
                items = [
                  {
                    name = "type";
                    path = [
                      {
                        kind = "identifier";
                        value = "string";
                      }
                    ];
                    type = "variable";
                  }
                ];
                type = "list";
              }
            ];
            callee = {
              name = "type";
              path = [
                {
                  kind = "identifier";
                  value = "list";
                }
              ];
              type = "variable";
            };
            type = "call";
          };
          zenosVersion = {
            kind = "version";
            type = "literal";
            value = "1.0.0Na";
          };
        };
        path = [
          "keybindings"
          "window-resize-right-decrease"
        ];
      }
    ];
    statements = [
      {
        operator = "=";
        target = [
          {
            kind = "identifier";
            value = "_meta";
          }
        ];
        type = "assignment";
        value = {
          recursive = false;
          statements = [
            {
              operator = "=";
              target = [
                {
                  kind = "identifier";
                  value = "zenosVersion";
                }
              ];
              type = "assignment";
              value = {
                kind = "version";
                type = "literal";
                value = "1.0.0Na";
              };
            }
            {
              operator = "=";
              target = [
                {
                  kind = "identifier";
                  value = "summary";
                }
              ];
              type = "assignment";
              value = {
                multiline = false;
                parts = [
                  {
                    type = "text";
                    value = "Tiling window management for GNOME Shell";
                  }
                ];
                type = "string";
              };
            }
            {
              operator = "=";
              target = [
                {
                  kind = "identifier";
                  value = "description";
                }
              ];
              type = "assignment";
              value = {
                multiline = true;
                parts = [
                  {
                    type = "text";
                    value = "\n    Tiling window management for GNOME Shell\n\n    This module installs and configures the **Forge** extension for GNOME.\n    Forge transforms the GNOME Shell into a tiling window manager, offering automatic\n    tiling, window gaps, and extensive keyboard shortcuts.\n\n    **Features:**\n    - Automatic tiling and stacking.\n    - Customizable window gaps and borders.\n    - Extensive keyboard shortcuts for moving, resizing, and focusing windows.\n  ";
                  }
                ];
                type = "string";
              };
            }
            {
              operator = "=";
              target = [
                {
                  kind = "identifier";
                  value = "maintainers";
                }
              ];
              type = "assignment";
              value = {
                items = [
                  {
                    name = "m";
                    path = [
                      {
                        kind = "identifier";
                        value = "doromiert";
                      }
                    ];
                    type = "variable";
                  }
                ];
                type = "list";
              };
            }
            {
              operator = "=";
              target = [
                {
                  kind = "identifier";
                  value = "license";
                }
              ];
              type = "assignment";
              value = {
                name = "l";
                path = [
                  {
                    kind = "identifier";
                    value = "napl";
                  }
                ];
                type = "variable";
              };
            }
            {
              operator = "=";
              target = [
                {
                  kind = "identifier";
                  value = "platforms";
                }
              ];
              type = "assignment";
              value = {
                name = "lib";
                path = [
                  {
                    kind = "identifier";
                    value = "platforms";
                  }
                  {
                    kind = "identifier";
                    value = "zenos";
                  }
                ];
                type = "variable";
              };
            }
          ];
          type = "attr-set";
        };
      }
      {
        annotation = {
          arguments = [
            {
              multiline = false;
              parts = [
                {
                  type = "text";
                  value = "key";
                }
              ];
              type = "string";
            }
          ];
          callee = {
            name = "type";
            path = [
              {
                kind = "identifier";
                value = "function";
              }
            ];
            type = "variable";
          };
          type = "call";
        };
        name = "formatPart";
        type = "let-binding";
        value = {
          body = {
            body = {
              condition = {
                left = {
                  path = [
                    {
                      kind = "identifier";
                      value = "lower";
                    }
                  ];
                  type = "reference";
                };
                operator = "==";
                right = {
                  multiline = false;
                  parts = [
                    {
                      type = "text";
                      value = "super";
                    }
                  ];
                  type = "string";
                };
                type = "binary";
              };
              "else" = {
                condition = {
                  left = {
                    left = {
                      path = [
                        {
                          kind = "identifier";
                          value = "lower";
                        }
                      ];
                      type = "reference";
                    };
                    operator = "==";
                    right = {
                      multiline = false;
                      parts = [
                        {
                          type = "text";
                          value = "ctrl";
                        }
                      ];
                      type = "string";
                    };
                    type = "binary";
                  };
                  operator = "||";
                  right = {
                    left = {
                      path = [
                        {
                          kind = "identifier";
                          value = "lower";
                        }
                      ];
                      type = "reference";
                    };
                    operator = "==";
                    right = {
                      multiline = false;
                      parts = [
                        {
                          type = "text";
                          value = "control";
                        }
                      ];
                      type = "string";
                    };
                    type = "binary";
                  };
                  type = "binary";
                };
                "else" = {
                  condition = {
                    left = {
                      path = [
                        {
                          kind = "identifier";
                          value = "lower";
                        }
                      ];
                      type = "reference";
                    };
                    operator = "==";
                    right = {
                      multiline = false;
                      parts = [
                        {
                          type = "text";
                          value = "alt";
                        }
                      ];
                      type = "string";
                    };
                    type = "binary";
                  };
                  "else" = {
                    condition = {
                      left = {
                        path = [
                          {
                            kind = "identifier";
                            value = "lower";
                          }
                        ];
                        type = "reference";
                      };
                      operator = "==";
                      right = {
                        multiline = false;
                        parts = [
                          {
                            type = "text";
                            value = "shift";
                          }
                        ];
                        type = "string";
                      };
                      type = "binary";
                    };
                    "else" = {
                      path = [
                        {
                          kind = "identifier";
                          value = "part";
                        }
                      ];
                      type = "reference";
                    };
                    "then" = {
                      multiline = false;
                      parts = [
                        {
                          type = "text";
                          value = "<Shift>";
                        }
                      ];
                      type = "string";
                    };
                    type = "if";
                  };
                  "then" = {
                    multiline = false;
                    parts = [
                      {
                        type = "text";
                        value = "<Alt>";
                      }
                    ];
                    type = "string";
                  };
                  type = "if";
                };
                "then" = {
                  multiline = false;
                  parts = [
                    {
                      type = "text";
                      value = "<Ctrl>";
                    }
                  ];
                  type = "string";
                };
                type = "if";
              };
              "then" = {
                multiline = false;
                parts = [
                  {
                    type = "text";
                    value = "<Super>";
                  }
                ];
                type = "string";
              };
              type = "if";
            };
            statements = [
              {
                operator = "=";
                target = [
                  {
                    kind = "identifier";
                    value = "lower";
                  }
                ];
                type = "assignment";
                value = {
                  arguments = [
                    {
                      path = [
                        {
                          kind = "identifier";
                          value = "part";
                        }
                      ];
                      type = "reference";
                    }
                  ];
                  callee = {
                    name = "lib";
                    path = [
                      {
                        kind = "identifier";
                        value = "toLower";
                      }
                    ];
                    type = "variable";
                  };
                  type = "call";
                };
              }
            ];
            type = "let";
          };
          form = "identifier";
          parameters = [
            {
              default = null;
              name = "part";
              variadic = false;
            }
          ];
          type = "lambda";
        };
      }
      {
        annotation = {
          arguments = [
            {
              multiline = false;
              parts = [
                {
                  type = "text";
                  value = "keys";
                }
              ];
              type = "string";
            }
          ];
          callee = {
            name = "type";
            path = [
              {
                kind = "identifier";
                value = "function";
              }
            ];
            type = "variable";
          };
          type = "call";
        };
        name = "serializeKeybind";
        type = "let-binding";
        value = {
          body = {
            items = [
              {
                type = "group";
                value = {
                  arguments = [
                    {
                      path = [
                        {
                          kind = "identifier";
                          value = "values";
                        }
                      ];
                      type = "reference";
                    }
                  ];
                  callee = {
                    arguments = [
                      {
                        name = "v";
                        path = [
                          {
                            kind = "identifier";
                            value = "formatPart";
                          }
                        ];
                        type = "variable";
                      }
                    ];
                    callee = {
                      name = "lib";
                      path = [
                        {
                          kind = "identifier";
                          value = "concatMapStrings";
                        }
                      ];
                      type = "variable";
                    };
                    type = "call";
                  };
                  type = "call";
                };
              }
            ];
            type = "list";
          };
          form = "identifier";
          parameters = [
            {
              default = null;
              name = "values";
              variadic = false;
            }
          ];
          type = "lambda";
        };
      }
      {
        annotation = {
          arguments = [
            {
              items = [
                {
                  name = "type";
                  path = [
                    {
                      kind = "identifier";
                      value = "int";
                    }
                  ];
                  type = "variable";
                }
              ];
              type = "list";
            }
          ];
          callee = {
            name = "type";
            path = [
              {
                kind = "identifier";
                value = "set";
              }
            ];
            type = "variable";
          };
          type = "call";
        };
        name = "hexToDecMap";
        type = "let-binding";
        value = {
          recursive = false;
          statements = [
            {
              operator = "=";
              target = [
                {
                  kind = "string";
                  value = "0";
                }
              ];
              type = "assignment";
              value = {
                kind = "integer";
                type = "literal";
                value = 0;
              };
            }
            {
              operator = "=";
              target = [
                {
                  kind = "string";
                  value = "1";
                }
              ];
              type = "assignment";
              value = {
                kind = "integer";
                type = "literal";
                value = 1;
              };
            }
            {
              operator = "=";
              target = [
                {
                  kind = "string";
                  value = "2";
                }
              ];
              type = "assignment";
              value = {
                kind = "integer";
                type = "literal";
                value = 2;
              };
            }
            {
              operator = "=";
              target = [
                {
                  kind = "string";
                  value = "3";
                }
              ];
              type = "assignment";
              value = {
                kind = "integer";
                type = "literal";
                value = 3;
              };
            }
            {
              operator = "=";
              target = [
                {
                  kind = "string";
                  value = "4";
                }
              ];
              type = "assignment";
              value = {
                kind = "integer";
                type = "literal";
                value = 4;
              };
            }
            {
              operator = "=";
              target = [
                {
                  kind = "string";
                  value = "5";
                }
              ];
              type = "assignment";
              value = {
                kind = "integer";
                type = "literal";
                value = 5;
              };
            }
            {
              operator = "=";
              target = [
                {
                  kind = "string";
                  value = "6";
                }
              ];
              type = "assignment";
              value = {
                kind = "integer";
                type = "literal";
                value = 6;
              };
            }
            {
              operator = "=";
              target = [
                {
                  kind = "string";
                  value = "7";
                }
              ];
              type = "assignment";
              value = {
                kind = "integer";
                type = "literal";
                value = 7;
              };
            }
            {
              operator = "=";
              target = [
                {
                  kind = "string";
                  value = "8";
                }
              ];
              type = "assignment";
              value = {
                kind = "integer";
                type = "literal";
                value = 8;
              };
            }
            {
              operator = "=";
              target = [
                {
                  kind = "string";
                  value = "9";
                }
              ];
              type = "assignment";
              value = {
                kind = "integer";
                type = "literal";
                value = 9;
              };
            }
            {
              operator = "=";
              target = [
                {
                  kind = "string";
                  value = "a";
                }
              ];
              type = "assignment";
              value = {
                kind = "integer";
                type = "literal";
                value = 10;
              };
            }
            {
              operator = "=";
              target = [
                {
                  kind = "string";
                  value = "b";
                }
              ];
              type = "assignment";
              value = {
                kind = "integer";
                type = "literal";
                value = 11;
              };
            }
            {
              operator = "=";
              target = [
                {
                  kind = "string";
                  value = "c";
                }
              ];
              type = "assignment";
              value = {
                kind = "integer";
                type = "literal";
                value = 12;
              };
            }
            {
              operator = "=";
              target = [
                {
                  kind = "string";
                  value = "d";
                }
              ];
              type = "assignment";
              value = {
                kind = "integer";
                type = "literal";
                value = 13;
              };
            }
            {
              operator = "=";
              target = [
                {
                  kind = "string";
                  value = "e";
                }
              ];
              type = "assignment";
              value = {
                kind = "integer";
                type = "literal";
                value = 14;
              };
            }
            {
              operator = "=";
              target = [
                {
                  kind = "string";
                  value = "f";
                }
              ];
              type = "assignment";
              value = {
                kind = "integer";
                type = "literal";
                value = 15;
              };
            }
            {
              operator = "=";
              target = [
                {
                  kind = "string";
                  value = "A";
                }
              ];
              type = "assignment";
              value = {
                kind = "integer";
                type = "literal";
                value = 10;
              };
            }
            {
              operator = "=";
              target = [
                {
                  kind = "string";
                  value = "B";
                }
              ];
              type = "assignment";
              value = {
                kind = "integer";
                type = "literal";
                value = 11;
              };
            }
            {
              operator = "=";
              target = [
                {
                  kind = "string";
                  value = "C";
                }
              ];
              type = "assignment";
              value = {
                kind = "integer";
                type = "literal";
                value = 12;
              };
            }
            {
              operator = "=";
              target = [
                {
                  kind = "string";
                  value = "D";
                }
              ];
              type = "assignment";
              value = {
                kind = "integer";
                type = "literal";
                value = 13;
              };
            }
            {
              operator = "=";
              target = [
                {
                  kind = "string";
                  value = "E";
                }
              ];
              type = "assignment";
              value = {
                kind = "integer";
                type = "literal";
                value = 14;
              };
            }
            {
              operator = "=";
              target = [
                {
                  kind = "string";
                  value = "F";
                }
              ];
              type = "assignment";
              value = {
                kind = "integer";
                type = "literal";
                value = 15;
              };
            }
          ];
          type = "attr-set";
        };
      }
      {
        annotation = {
          arguments = [
            {
              multiline = false;
              parts = [
                {
                  type = "text";
                  value = "char";
                }
              ];
              type = "string";
            }
          ];
          callee = {
            name = "type";
            path = [
              {
                kind = "identifier";
                value = "function";
              }
            ];
            type = "variable";
          };
          type = "call";
        };
        name = "hexCharToInt";
        type = "let-binding";
        value = {
          body = {
            condition = {
              arguments = [
                {
                  name = "v";
                  path = [
                    {
                      kind = "identifier";
                      value = "hexToDecMap";
                    }
                  ];
                  type = "variable";
                }
              ];
              callee = {
                arguments = [
                  {
                    path = [
                      {
                        kind = "identifier";
                        value = "c";
                      }
                    ];
                    type = "reference";
                  }
                ];
                callee = {
                  name = "lib";
                  path = [
                    {
                      kind = "identifier";
                      value = "hasAttr";
                    }
                  ];
                  type = "variable";
                };
                type = "call";
              };
              type = "call";
            };
            "else" = {
              kind = "integer";
              type = "literal";
              value = 0;
            };
            "then" = {
              arguments = [
                {
                  name = "v";
                  path = [
                    {
                      kind = "identifier";
                      value = "hexToDecMap";
                    }
                  ];
                  type = "variable";
                }
              ];
              callee = {
                arguments = [
                  {
                    path = [
                      {
                        kind = "identifier";
                        value = "c";
                      }
                    ];
                    type = "reference";
                  }
                ];
                callee = {
                  name = "lib";
                  path = [
                    {
                      kind = "identifier";
                      value = "getAttr";
                    }
                  ];
                  type = "variable";
                };
                type = "call";
              };
              type = "call";
            };
            type = "if";
          };
          form = "identifier";
          parameters = [
            {
              default = null;
              name = "c";
              variadic = false;
            }
          ];
          type = "lambda";
        };
      }
      {
        annotation = {
          arguments = [
            {
              multiline = false;
              parts = [
                {
                  type = "text";
                  value = "byte";
                }
              ];
              type = "string";
            }
          ];
          callee = {
            name = "type";
            path = [
              {
                kind = "identifier";
                value = "function";
              }
            ];
            type = "variable";
          };
          type = "call";
        };
        name = "parseHexByte";
        type = "let-binding";
        value = {
          body = {
            left = {
              type = "group";
              value = {
                left = {
                  arguments = [
                    {
                      type = "group";
                      value = {
                        arguments = [
                          {
                            path = [
                              {
                                kind = "identifier";
                                value = "str";
                              }
                            ];
                            type = "reference";
                          }
                        ];
                        callee = {
                          arguments = [
                            {
                              kind = "integer";
                              type = "literal";
                              value = 1;
                            }
                          ];
                          callee = {
                            arguments = [
                              {
                                kind = "integer";
                                type = "literal";
                                value = 0;
                              }
                            ];
                            callee = {
                              name = "lib";
                              path = [
                                {
                                  kind = "identifier";
                                  value = "substring";
                                }
                              ];
                              type = "variable";
                            };
                            type = "call";
                          };
                          type = "call";
                        };
                        type = "call";
                      };
                    }
                  ];
                  callee = {
                    name = "v";
                    path = [
                      {
                        kind = "identifier";
                        value = "hexCharToInt";
                      }
                    ];
                    type = "variable";
                  };
                  type = "call";
                };
                operator = "*";
                right = {
                  kind = "integer";
                  type = "literal";
                  value = 16;
                };
                type = "binary";
              };
            };
            operator = "+";
            right = {
              arguments = [
                {
                  type = "group";
                  value = {
                    arguments = [
                      {
                        path = [
                          {
                            kind = "identifier";
                            value = "str";
                          }
                        ];
                        type = "reference";
                      }
                    ];
                    callee = {
                      arguments = [
                        {
                          kind = "integer";
                          type = "literal";
                          value = 1;
                        }
                      ];
                      callee = {
                        arguments = [
                          {
                            kind = "integer";
                            type = "literal";
                            value = 1;
                          }
                        ];
                        callee = {
                          name = "lib";
                          path = [
                            {
                              kind = "identifier";
                              value = "substring";
                            }
                          ];
                          type = "variable";
                        };
                        type = "call";
                      };
                      type = "call";
                    };
                    type = "call";
                  };
                }
              ];
              callee = {
                name = "v";
                path = [
                  {
                    kind = "identifier";
                    value = "hexCharToInt";
                  }
                ];
                type = "variable";
              };
              type = "call";
            };
            type = "binary";
          };
          form = "identifier";
          parameters = [
            {
              default = null;
              name = "str";
              variadic = false;
            }
          ];
          type = "lambda";
        };
      }
      {
        annotation = {
          arguments = [
            {
              multiline = false;
              parts = [
                {
                  type = "text";
                  value = "float";
                }
              ];
              type = "string";
            }
          ];
          callee = {
            name = "type";
            path = [
              {
                kind = "identifier";
                value = "function";
              }
            ];
            type = "variable";
          };
          type = "call";
        };
        name = "serializeFloat";
        type = "let-binding";
        value = {
          body = {
            body = {
              condition = {
                arguments = [
                  {
                    path = [
                      {
                        kind = "identifier";
                        value = "str";
                      }
                    ];
                    type = "reference";
                  }
                ];
                callee = {
                  arguments = [
                    {
                      multiline = false;
                      parts = [
                        {
                          type = "text";
                          value = ".";
                        }
                      ];
                      type = "string";
                    }
                  ];
                  callee = {
                    name = "lib";
                    path = [
                      {
                        kind = "identifier";
                        value = "hasInfix";
                      }
                    ];
                    type = "variable";
                  };
                  type = "call";
                };
                type = "call";
              };
              "else" = {
                multiline = false;
                parts = [
                  {
                    expression = {
                      path = [
                        {
                          kind = "identifier";
                          value = "str";
                        }
                      ];
                      type = "reference";
                    };
                    type = "interpolation";
                  }
                  {
                    type = "text";
                    value = ".0";
                  }
                ];
                type = "string";
              };
              "then" = {
                path = [
                  {
                    kind = "identifier";
                    value = "str";
                  }
                ];
                type = "reference";
              };
              type = "if";
            };
            statements = [
              {
                operator = "=";
                target = [
                  {
                    kind = "identifier";
                    value = "str";
                  }
                ];
                type = "assignment";
                value = {
                  arguments = [
                    {
                      path = [
                        {
                          kind = "identifier";
                          value = "value";
                        }
                      ];
                      type = "reference";
                    }
                  ];
                  callee = {
                    name = "lib";
                    path = [
                      {
                        kind = "identifier";
                        value = "toString";
                      }
                    ];
                    type = "variable";
                  };
                  type = "call";
                };
              }
            ];
            type = "let";
          };
          form = "identifier";
          parameters = [
            {
              default = null;
              name = "value";
              variadic = false;
            }
          ];
          type = "lambda";
        };
      }
      {
        annotation = {
          arguments = [
            {
              multiline = false;
              parts = [
                {
                  type = "text";
                  value = "color";
                }
              ];
              type = "string";
            }
          ];
          callee = {
            name = "type";
            path = [
              {
                kind = "identifier";
                value = "function";
              }
            ];
            type = "variable";
          };
          type = "call";
        };
        name = "toRgbaString";
        type = "let-binding";
        value = {
          body = {
            condition = {
              left = {
                arguments = [
                  {
                    path = [
                      {
                        kind = "identifier";
                        value = "value";
                      }
                    ];
                    type = "reference";
                  }
                ];
                callee = {
                  name = "lib";
                  path = [
                    {
                      kind = "identifier";
                      value = "isString";
                    }
                  ];
                  type = "variable";
                };
                type = "call";
              };
              operator = "&&";
              right = {
                arguments = [
                  {
                    path = [
                      {
                        kind = "identifier";
                        value = "value";
                      }
                    ];
                    type = "reference";
                  }
                ];
                callee = {
                  arguments = [
                    {
                      multiline = false;
                      parts = [
                        {
                          type = "text";
                          value = "#";
                        }
                      ];
                      type = "string";
                    }
                  ];
                  callee = {
                    name = "lib";
                    path = [
                      {
                        kind = "identifier";
                        value = "hasPrefix";
                      }
                    ];
                    type = "variable";
                  };
                  type = "call";
                };
                type = "call";
              };
              type = "binary";
            };
            "else" = {
              path = [
                {
                  kind = "identifier";
                  value = "value";
                }
              ];
              type = "reference";
            };
            "then" = {
              body = {
                multiline = false;
                parts = [
                  {
                    type = "text";
                    value = "rgba(";
                  }
                  {
                    expression = {
                      path = [
                        {
                          kind = "identifier";
                          value = "r";
                        }
                      ];
                      type = "reference";
                    };
                    type = "interpolation";
                  }
                  {
                    type = "text";
                    value = ", ";
                  }
                  {
                    expression = {
                      path = [
                        {
                          kind = "identifier";
                          value = "g";
                        }
                      ];
                      type = "reference";
                    };
                    type = "interpolation";
                  }
                  {
                    type = "text";
                    value = ", ";
                  }
                  {
                    expression = {
                      path = [
                        {
                          kind = "identifier";
                          value = "b";
                        }
                      ];
                      type = "reference";
                    };
                    type = "interpolation";
                  }
                  {
                    type = "text";
                    value = ", ";
                  }
                  {
                    expression = {
                      path = [
                        {
                          kind = "identifier";
                          value = "a";
                        }
                      ];
                      type = "reference";
                    };
                    type = "interpolation";
                  }
                  {
                    type = "text";
                    value = ")";
                  }
                ];
                type = "string";
              };
              statements = [
                {
                  operator = "=";
                  target = [
                    {
                      kind = "identifier";
                      value = "hex";
                    }
                  ];
                  type = "assignment";
                  value = {
                    arguments = [
                      {
                        path = [
                          {
                            kind = "identifier";
                            value = "value";
                          }
                        ];
                        type = "reference";
                      }
                    ];
                    callee = {
                      arguments = [
                        {
                          multiline = false;
                          parts = [
                            {
                              type = "text";
                              value = "#";
                            }
                          ];
                          type = "string";
                        }
                      ];
                      callee = {
                        name = "lib";
                        path = [
                          {
                            kind = "identifier";
                            value = "removePrefix";
                          }
                        ];
                        type = "variable";
                      };
                      type = "call";
                    };
                    type = "call";
                  };
                }
                {
                  operator = "=";
                  target = [
                    {
                      kind = "identifier";
                      value = "r";
                    }
                  ];
                  type = "assignment";
                  value = {
                    arguments = [
                      {
                        type = "group";
                        value = {
                          arguments = [
                            {
                              type = "group";
                              value = {
                                arguments = [
                                  {
                                    path = [
                                      {
                                        kind = "identifier";
                                        value = "hex";
                                      }
                                    ];
                                    type = "reference";
                                  }
                                ];
                                callee = {
                                  arguments = [
                                    {
                                      kind = "integer";
                                      type = "literal";
                                      value = 2;
                                    }
                                  ];
                                  callee = {
                                    arguments = [
                                      {
                                        kind = "integer";
                                        type = "literal";
                                        value = 0;
                                      }
                                    ];
                                    callee = {
                                      name = "lib";
                                      path = [
                                        {
                                          kind = "identifier";
                                          value = "substring";
                                        }
                                      ];
                                      type = "variable";
                                    };
                                    type = "call";
                                  };
                                  type = "call";
                                };
                                type = "call";
                              };
                            }
                          ];
                          callee = {
                            name = "v";
                            path = [
                              {
                                kind = "identifier";
                                value = "parseHexByte";
                              }
                            ];
                            type = "variable";
                          };
                          type = "call";
                        };
                      }
                    ];
                    callee = {
                      name = "lib";
                      path = [
                        {
                          kind = "identifier";
                          value = "toString";
                        }
                      ];
                      type = "variable";
                    };
                    type = "call";
                  };
                }
                {
                  operator = "=";
                  target = [
                    {
                      kind = "identifier";
                      value = "g";
                    }
                  ];
                  type = "assignment";
                  value = {
                    arguments = [
                      {
                        type = "group";
                        value = {
                          arguments = [
                            {
                              type = "group";
                              value = {
                                arguments = [
                                  {
                                    path = [
                                      {
                                        kind = "identifier";
                                        value = "hex";
                                      }
                                    ];
                                    type = "reference";
                                  }
                                ];
                                callee = {
                                  arguments = [
                                    {
                                      kind = "integer";
                                      type = "literal";
                                      value = 2;
                                    }
                                  ];
                                  callee = {
                                    arguments = [
                                      {
                                        kind = "integer";
                                        type = "literal";
                                        value = 2;
                                      }
                                    ];
                                    callee = {
                                      name = "lib";
                                      path = [
                                        {
                                          kind = "identifier";
                                          value = "substring";
                                        }
                                      ];
                                      type = "variable";
                                    };
                                    type = "call";
                                  };
                                  type = "call";
                                };
                                type = "call";
                              };
                            }
                          ];
                          callee = {
                            name = "v";
                            path = [
                              {
                                kind = "identifier";
                                value = "parseHexByte";
                              }
                            ];
                            type = "variable";
                          };
                          type = "call";
                        };
                      }
                    ];
                    callee = {
                      name = "lib";
                      path = [
                        {
                          kind = "identifier";
                          value = "toString";
                        }
                      ];
                      type = "variable";
                    };
                    type = "call";
                  };
                }
                {
                  operator = "=";
                  target = [
                    {
                      kind = "identifier";
                      value = "b";
                    }
                  ];
                  type = "assignment";
                  value = {
                    arguments = [
                      {
                        type = "group";
                        value = {
                          arguments = [
                            {
                              type = "group";
                              value = {
                                arguments = [
                                  {
                                    path = [
                                      {
                                        kind = "identifier";
                                        value = "hex";
                                      }
                                    ];
                                    type = "reference";
                                  }
                                ];
                                callee = {
                                  arguments = [
                                    {
                                      kind = "integer";
                                      type = "literal";
                                      value = 2;
                                    }
                                  ];
                                  callee = {
                                    arguments = [
                                      {
                                        kind = "integer";
                                        type = "literal";
                                        value = 4;
                                      }
                                    ];
                                    callee = {
                                      name = "lib";
                                      path = [
                                        {
                                          kind = "identifier";
                                          value = "substring";
                                        }
                                      ];
                                      type = "variable";
                                    };
                                    type = "call";
                                  };
                                  type = "call";
                                };
                                type = "call";
                              };
                            }
                          ];
                          callee = {
                            name = "v";
                            path = [
                              {
                                kind = "identifier";
                                value = "parseHexByte";
                              }
                            ];
                            type = "variable";
                          };
                          type = "call";
                        };
                      }
                    ];
                    callee = {
                      name = "lib";
                      path = [
                        {
                          kind = "identifier";
                          value = "toString";
                        }
                      ];
                      type = "variable";
                    };
                    type = "call";
                  };
                }
                {
                  operator = "=";
                  target = [
                    {
                      kind = "identifier";
                      value = "a";
                    }
                  ];
                  type = "assignment";
                  value = {
                    condition = {
                      left = {
                        arguments = [
                          {
                            path = [
                              {
                                kind = "identifier";
                                value = "hex";
                              }
                            ];
                            type = "reference";
                          }
                        ];
                        callee = {
                          name = "lib";
                          path = [
                            {
                              kind = "identifier";
                              value = "stringLength";
                            }
                          ];
                          type = "variable";
                        };
                        type = "call";
                      };
                      operator = "==";
                      right = {
                        kind = "integer";
                        type = "literal";
                        value = 8;
                      };
                      type = "binary";
                    };
                    "else" = {
                      multiline = false;
                      parts = [
                        {
                          type = "text";
                          value = "1.0";
                        }
                      ];
                      type = "string";
                    };
                    "then" = {
                      arguments = [
                        {
                          type = "group";
                          value = {
                            left = {
                              arguments = [
                                {
                                  type = "group";
                                  value = {
                                    arguments = [
                                      {
                                        path = [
                                          {
                                            kind = "identifier";
                                            value = "hex";
                                          }
                                        ];
                                        type = "reference";
                                      }
                                    ];
                                    callee = {
                                      arguments = [
                                        {
                                          kind = "integer";
                                          type = "literal";
                                          value = 2;
                                        }
                                      ];
                                      callee = {
                                        arguments = [
                                          {
                                            kind = "integer";
                                            type = "literal";
                                            value = 6;
                                          }
                                        ];
                                        callee = {
                                          name = "lib";
                                          path = [
                                            {
                                              kind = "identifier";
                                              value = "substring";
                                            }
                                          ];
                                          type = "variable";
                                        };
                                        type = "call";
                                      };
                                      type = "call";
                                    };
                                    type = "call";
                                  };
                                }
                              ];
                              callee = {
                                name = "v";
                                path = [
                                  {
                                    kind = "identifier";
                                    value = "parseHexByte";
                                  }
                                ];
                                type = "variable";
                              };
                              type = "call";
                            };
                            operator = "/";
                            right = {
                              kind = "float";
                              type = "literal";
                              value = 255.0;
                            };
                            type = "binary";
                          };
                        }
                      ];
                      callee = {
                        name = "v";
                        path = [
                          {
                            kind = "identifier";
                            value = "serializeFloat";
                          }
                        ];
                        type = "variable";
                      };
                      type = "call";
                    };
                    type = "if";
                  };
                }
              ];
              type = "let";
            };
            type = "if";
          };
          form = "identifier";
          parameters = [
            {
              default = null;
              name = "value";
              variadic = false;
            }
          ];
          type = "lambda";
        };
      }
      {
        operator = "=";
        target = [
          {
            kind = "identifier";
            value = "enable";
          }
        ];
        type = "assignment";
        value = {
          body = {
            recursive = false;
            statements = [
              {
                operator = "=";
                target = [
                  {
                    kind = "identifier";
                    value = "_meta";
                  }
                ];
                type = "assignment";
                value = {
                  recursive = false;
                  statements = [
                    {
                      operator = "=";
                      target = [
                        {
                          kind = "identifier";
                          value = "description";
                        }
                      ];
                      type = "assignment";
                      value = {
                        multiline = true;
                        parts = [
                          {
                            type = "text";
                            value = "Whether to enable Forge GNOME extension configuration.";
                          }
                        ];
                        type = "string";
                      };
                    }
                  ];
                  type = "attr-set";
                };
              }
              {
                body = {
                  recursive = false;
                  statements = [
                    {
                      operator = "=";
                      target = [
                        {
                          kind = "identifier";
                          value = "environment";
                        }
                        {
                          kind = "identifier";
                          value = "systemPackages";
                        }
                      ];
                      type = "assignment";
                      value = {
                        items = [
                          {
                            name = "pkgs";
                            path = [
                              {
                                kind = "identifier";
                                value = "byCategories";
                              }
                              {
                                kind = "identifier";
                                value = "desktops";
                              }
                              {
                                kind = "identifier";
                                value = "gnome";
                              }
                              {
                                kind = "identifier";
                                value = "extensions";
                              }
                              {
                                kind = "identifier";
                                value = "forge";
                              }
                            ];
                            type = "variable";
                          }
                        ];
                        type = "list";
                      };
                    }
                  ];
                  type = "attr-set";
                };
                guards = [ ];
                scope = "system";
                type = "action";
                unconditional = false;
              }
              {
                body = {
                  recursive = false;
                  statements = [
                    {
                      operator = "=";
                      target = [
                        {
                          kind = "identifier";
                          value = "dconf";
                        }
                        {
                          kind = "identifier";
                          value = "settings";
                        }
                        {
                          kind = "string";
                          value = "org/gnome/mutter";
                        }
                        {
                          kind = "identifier";
                          value = "auto-maximize";
                        }
                      ];
                      type = "assignment";
                      value = {
                        arguments = [
                          {
                            kind = "false";
                            type = "literal";
                            value = false;
                          }
                        ];
                        callee = {
                          name = "lib";
                          path = [
                            {
                              kind = "identifier";
                              value = "mkDefault";
                            }
                          ];
                          type = "variable";
                        };
                        type = "call";
                      };
                    }
                    {
                      operator = "=";
                      target = [
                        {
                          kind = "identifier";
                          value = "dconf";
                        }
                        {
                          kind = "identifier";
                          value = "settings";
                        }
                        {
                          kind = "string";
                          value = "org/gnome/shell";
                        }
                        {
                          kind = "identifier";
                          value = "enabled-extensions";
                        }
                      ];
                      type = "assignment";
                      value = {
                        items = [
                          {
                            name = "pkgs";
                            path = [
                              {
                                kind = "identifier";
                                value = "byCategories";
                              }
                              {
                                kind = "identifier";
                                value = "desktops";
                              }
                              {
                                kind = "identifier";
                                value = "gnome";
                              }
                              {
                                kind = "identifier";
                                value = "extensions";
                              }
                              {
                                kind = "identifier";
                                value = "forge";
                              }
                              {
                                kind = "identifier";
                                value = "extensionUuid";
                              }
                            ];
                            type = "variable";
                          }
                        ];
                        type = "list";
                      };
                    }
                  ];
                  type = "attr-set";
                };
                guards = [ ];
                scope = "user";
                type = "action";
                unconditional = false;
              }
            ];
            type = "attr-set";
          };
          type = "enable-option";
        };
      }
      {
        operator = "=";
        target = [
          {
            kind = "identifier";
            value = "configure";
          }
        ];
        type = "assignment";
        value = {
          body = {
            recursive = false;
            statements = [
              {
                operator = "=";
                target = [
                  {
                    kind = "identifier";
                    value = "_meta";
                  }
                ];
                type = "assignment";
                value = {
                  recursive = false;
                  statements = [
                    {
                      operator = "=";
                      target = [
                        {
                          kind = "identifier";
                          value = "default";
                        }
                      ];
                      type = "assignment";
                      value = {
                        name = "path";
                        path = [
                          {
                            kind = "identifier";
                            value = "enable";
                          }
                        ];
                        type = "variable";
                      };
                    }
                    {
                      operator = "=";
                      target = [
                        {
                          kind = "identifier";
                          value = "description";
                        }
                      ];
                      type = "assignment";
                      value = {
                        multiline = true;
                        parts = [
                          {
                            type = "text";
                            value = "Write settings without requiring extension activation.";
                          }
                        ];
                        type = "string";
                      };
                    }
                  ];
                  type = "attr-set";
                };
              }
              {
                body = {
                  recursive = false;
                  statements = [
                    {
                      operator = "=";
                      target = [
                        {
                          kind = "identifier";
                          value = "dconf";
                        }
                      ];
                      type = "assignment";
                      value = {
                        recursive = false;
                        statements = [
                          {
                            operator = "=";
                            target = [
                              {
                                kind = "identifier";
                                value = "settings";
                              }
                            ];
                            type = "assignment";
                            value = {
                              recursive = false;
                              statements = [
                                {
                                  operator = "=";
                                  target = [
                                    {
                                      kind = "string";
                                      value = "org/gnome/shell/extensions/forge";
                                    }
                                  ];
                                  type = "assignment";
                                  value = {
                                    recursive = false;
                                    statements = [
                                      {
                                        operator = "=";
                                        target = [
                                          {
                                            kind = "identifier";
                                            value = "focus-border-toggle";
                                          }
                                        ];
                                        type = "assignment";
                                        value = {
                                          name = "path";
                                          path = [
                                            {
                                              kind = "identifier";
                                              value = "appearance";
                                            }
                                            {
                                              kind = "identifier";
                                              value = "borders";
                                            }
                                            {
                                              kind = "identifier";
                                              value = "focus";
                                            }
                                            {
                                              kind = "identifier";
                                              value = "toggle";
                                            }
                                          ];
                                          type = "variable";
                                        };
                                      }
                                      {
                                        operator = "=";
                                        target = [
                                          {
                                            kind = "identifier";
                                            value = "focus-border-size";
                                          }
                                        ];
                                        type = "assignment";
                                        value = {
                                          arguments = [
                                            {
                                              name = "path";
                                              path = [
                                                {
                                                  kind = "identifier";
                                                  value = "appearance";
                                                }
                                                {
                                                  kind = "identifier";
                                                  value = "borders";
                                                }
                                                {
                                                  kind = "identifier";
                                                  value = "focus";
                                                }
                                                {
                                                  kind = "identifier";
                                                  value = "size";
                                                }
                                              ];
                                              type = "variable";
                                            }
                                          ];
                                          callee = {
                                            name = "lib";
                                            path = [
                                              {
                                                kind = "identifier";
                                                value = "gvariant";
                                              }
                                              {
                                                kind = "identifier";
                                                value = "mkUint32";
                                              }
                                            ];
                                            type = "variable";
                                          };
                                          type = "call";
                                        };
                                      }
                                      {
                                        operator = "=";
                                        target = [
                                          {
                                            kind = "identifier";
                                            value = "focus-border-color";
                                          }
                                        ];
                                        type = "assignment";
                                        value = {
                                          arguments = [
                                            {
                                              name = "path";
                                              path = [
                                                {
                                                  kind = "identifier";
                                                  value = "appearance";
                                                }
                                                {
                                                  kind = "identifier";
                                                  value = "borders";
                                                }
                                                {
                                                  kind = "identifier";
                                                  value = "focus";
                                                }
                                                {
                                                  kind = "identifier";
                                                  value = "color";
                                                }
                                              ];
                                              type = "variable";
                                            }
                                          ];
                                          callee = {
                                            name = "v";
                                            path = [
                                              {
                                                kind = "identifier";
                                                value = "toRgbaString";
                                              }
                                            ];
                                            type = "variable";
                                          };
                                          type = "call";
                                        };
                                      }
                                      {
                                        operator = "=";
                                        target = [
                                          {
                                            kind = "identifier";
                                            value = "split-border-toggle";
                                          }
                                        ];
                                        type = "assignment";
                                        value = {
                                          name = "path";
                                          path = [
                                            {
                                              kind = "identifier";
                                              value = "appearance";
                                            }
                                            {
                                              kind = "identifier";
                                              value = "borders";
                                            }
                                            {
                                              kind = "identifier";
                                              value = "split";
                                            }
                                            {
                                              kind = "identifier";
                                              value = "toggle";
                                            }
                                          ];
                                          type = "variable";
                                        };
                                      }
                                      {
                                        operator = "=";
                                        target = [
                                          {
                                            kind = "identifier";
                                            value = "split-border-color";
                                          }
                                        ];
                                        type = "assignment";
                                        value = {
                                          arguments = [
                                            {
                                              name = "path";
                                              path = [
                                                {
                                                  kind = "identifier";
                                                  value = "appearance";
                                                }
                                                {
                                                  kind = "identifier";
                                                  value = "borders";
                                                }
                                                {
                                                  kind = "identifier";
                                                  value = "split";
                                                }
                                                {
                                                  kind = "identifier";
                                                  value = "color";
                                                }
                                              ];
                                              type = "variable";
                                            }
                                          ];
                                          callee = {
                                            name = "v";
                                            path = [
                                              {
                                                kind = "identifier";
                                                value = "toRgbaString";
                                              }
                                            ];
                                            type = "variable";
                                          };
                                          type = "call";
                                        };
                                      }
                                      {
                                        operator = "=";
                                        target = [
                                          {
                                            kind = "identifier";
                                            value = "window-gap-size";
                                          }
                                        ];
                                        type = "assignment";
                                        value = {
                                          arguments = [
                                            {
                                              name = "path";
                                              path = [
                                                {
                                                  kind = "identifier";
                                                  value = "appearance";
                                                }
                                                {
                                                  kind = "identifier";
                                                  value = "gaps";
                                                }
                                                {
                                                  kind = "identifier";
                                                  value = "size";
                                                }
                                              ];
                                              type = "variable";
                                            }
                                          ];
                                          callee = {
                                            name = "lib";
                                            path = [
                                              {
                                                kind = "identifier";
                                                value = "gvariant";
                                              }
                                              {
                                                kind = "identifier";
                                                value = "mkUint32";
                                              }
                                            ];
                                            type = "variable";
                                          };
                                          type = "call";
                                        };
                                      }
                                      {
                                        operator = "=";
                                        target = [
                                          {
                                            kind = "identifier";
                                            value = "window-gap-size-increment";
                                          }
                                        ];
                                        type = "assignment";
                                        value = {
                                          arguments = [
                                            {
                                              name = "path";
                                              path = [
                                                {
                                                  kind = "identifier";
                                                  value = "appearance";
                                                }
                                                {
                                                  kind = "identifier";
                                                  value = "gaps";
                                                }
                                                {
                                                  kind = "identifier";
                                                  value = "increment";
                                                }
                                              ];
                                              type = "variable";
                                            }
                                          ];
                                          callee = {
                                            name = "lib";
                                            path = [
                                              {
                                                kind = "identifier";
                                                value = "gvariant";
                                              }
                                              {
                                                kind = "identifier";
                                                value = "mkUint32";
                                              }
                                            ];
                                            type = "variable";
                                          };
                                          type = "call";
                                        };
                                      }
                                      {
                                        operator = "=";
                                        target = [
                                          {
                                            kind = "identifier";
                                            value = "window-gap-hidden-on-single";
                                          }
                                        ];
                                        type = "assignment";
                                        value = {
                                          name = "path";
                                          path = [
                                            {
                                              kind = "identifier";
                                              value = "appearance";
                                            }
                                            {
                                              kind = "identifier";
                                              value = "gaps";
                                            }
                                            {
                                              kind = "identifier";
                                              value = "hide-on-single";
                                            }
                                          ];
                                          type = "variable";
                                        };
                                      }
                                      {
                                        operator = "=";
                                        target = [
                                          {
                                            kind = "identifier";
                                            value = "showtab-decoration-enabled";
                                          }
                                        ];
                                        type = "assignment";
                                        value = {
                                          name = "path";
                                          path = [
                                            {
                                              kind = "identifier";
                                              value = "appearance";
                                            }
                                            {
                                              kind = "identifier";
                                              value = "decorations";
                                            }
                                            {
                                              kind = "identifier";
                                              value = "tabs";
                                            }
                                          ];
                                          type = "variable";
                                        };
                                      }
                                      {
                                        operator = "=";
                                        target = [
                                          {
                                            kind = "identifier";
                                            value = "preview-hint-enabled";
                                          }
                                        ];
                                        type = "assignment";
                                        value = {
                                          name = "path";
                                          path = [
                                            {
                                              kind = "identifier";
                                              value = "appearance";
                                            }
                                            {
                                              kind = "identifier";
                                              value = "decorations";
                                            }
                                            {
                                              kind = "identifier";
                                              value = "preview-hint";
                                            }
                                          ];
                                          type = "variable";
                                        };
                                      }
                                      {
                                        operator = "=";
                                        target = [
                                          {
                                            kind = "identifier";
                                            value = "tiling-mode-enabled";
                                          }
                                        ];
                                        type = "assignment";
                                        value = {
                                          name = "path";
                                          path = [
                                            {
                                              kind = "identifier";
                                              value = "tiling";
                                            }
                                            {
                                              kind = "identifier";
                                              value = "enable";
                                            }
                                          ];
                                          type = "variable";
                                        };
                                      }
                                      {
                                        operator = "=";
                                        target = [
                                          {
                                            kind = "identifier";
                                            value = "primary-layout-mode";
                                          }
                                        ];
                                        type = "assignment";
                                        value = {
                                          name = "path";
                                          path = [
                                            {
                                              kind = "identifier";
                                              value = "tiling";
                                            }
                                            {
                                              kind = "identifier";
                                              value = "primary-mode";
                                            }
                                          ];
                                          type = "variable";
                                        };
                                      }
                                      {
                                        operator = "=";
                                        target = [
                                          {
                                            kind = "identifier";
                                            value = "stacked-tiling-mode-enabled";
                                          }
                                        ];
                                        type = "assignment";
                                        value = {
                                          name = "path";
                                          path = [
                                            {
                                              kind = "identifier";
                                              value = "tiling";
                                            }
                                            {
                                              kind = "identifier";
                                              value = "stacked";
                                            }
                                          ];
                                          type = "variable";
                                        };
                                      }
                                      {
                                        operator = "=";
                                        target = [
                                          {
                                            kind = "identifier";
                                            value = "tabbed-tiling-mode-enabled";
                                          }
                                        ];
                                        type = "assignment";
                                        value = {
                                          name = "path";
                                          path = [
                                            {
                                              kind = "identifier";
                                              value = "tiling";
                                            }
                                            {
                                              kind = "identifier";
                                              value = "tabbed";
                                            }
                                            {
                                              kind = "identifier";
                                              value = "enable";
                                            }
                                          ];
                                          type = "variable";
                                        };
                                      }
                                      {
                                        operator = "=";
                                        target = [
                                          {
                                            kind = "identifier";
                                            value = "auto-exit-tabbed";
                                          }
                                        ];
                                        type = "assignment";
                                        value = {
                                          name = "path";
                                          path = [
                                            {
                                              kind = "identifier";
                                              value = "tiling";
                                            }
                                            {
                                              kind = "identifier";
                                              value = "tabbed";
                                            }
                                            {
                                              kind = "identifier";
                                              value = "auto-exit";
                                            }
                                          ];
                                          type = "variable";
                                        };
                                      }
                                      {
                                        operator = "=";
                                        target = [
                                          {
                                            kind = "identifier";
                                            value = "auto-split-enabled";
                                          }
                                        ];
                                        type = "assignment";
                                        value = {
                                          name = "path";
                                          path = [
                                            {
                                              kind = "identifier";
                                              value = "tiling";
                                            }
                                            {
                                              kind = "identifier";
                                              value = "auto-split";
                                            }
                                          ];
                                          type = "variable";
                                        };
                                      }
                                      {
                                        operator = "=";
                                        target = [
                                          {
                                            kind = "identifier";
                                            value = "workspace-skip-tile";
                                          }
                                        ];
                                        type = "assignment";
                                        value = {
                                          name = "path";
                                          path = [
                                            {
                                              kind = "identifier";
                                              value = "tiling";
                                            }
                                            {
                                              kind = "identifier";
                                              value = "workspace-skip";
                                            }
                                          ];
                                          type = "variable";
                                        };
                                      }
                                      {
                                        operator = "=";
                                        target = [
                                          {
                                            kind = "identifier";
                                            value = "move-pointer-focus-enabled";
                                          }
                                        ];
                                        type = "assignment";
                                        value = {
                                          name = "path";
                                          path = [
                                            {
                                              kind = "identifier";
                                              value = "interaction";
                                            }
                                            {
                                              kind = "identifier";
                                              value = "mouse";
                                            }
                                            {
                                              kind = "identifier";
                                              value = "move-pointer-focus";
                                            }
                                          ];
                                          type = "variable";
                                        };
                                      }
                                      {
                                        operator = "=";
                                        target = [
                                          {
                                            kind = "identifier";
                                            value = "focus-on-hover-enabled";
                                          }
                                        ];
                                        type = "assignment";
                                        value = {
                                          name = "path";
                                          path = [
                                            {
                                              kind = "identifier";
                                              value = "interaction";
                                            }
                                            {
                                              kind = "identifier";
                                              value = "mouse";
                                            }
                                            {
                                              kind = "identifier";
                                              value = "focus-on-hover";
                                            }
                                          ];
                                          type = "variable";
                                        };
                                      }
                                      {
                                        operator = "=";
                                        target = [
                                          {
                                            kind = "identifier";
                                            value = "dnd-center-layout";
                                          }
                                        ];
                                        type = "assignment";
                                        value = {
                                          name = "path";
                                          path = [
                                            {
                                              kind = "identifier";
                                              value = "interaction";
                                            }
                                            {
                                              kind = "identifier";
                                              value = "dnd-center-layout";
                                            }
                                          ];
                                          type = "variable";
                                        };
                                      }
                                      {
                                        operator = "=";
                                        target = [
                                          {
                                            kind = "identifier";
                                            value = "float-always-on-top-enabled";
                                          }
                                        ];
                                        type = "assignment";
                                        value = {
                                          name = "path";
                                          path = [
                                            {
                                              kind = "identifier";
                                              value = "interaction";
                                            }
                                            {
                                              kind = "identifier";
                                              value = "float-always-on-top";
                                            }
                                          ];
                                          type = "variable";
                                        };
                                      }
                                      {
                                        operator = "=";
                                        target = [
                                          {
                                            kind = "identifier";
                                            value = "resize-amount";
                                          }
                                        ];
                                        type = "assignment";
                                        value = {
                                          arguments = [
                                            {
                                              name = "path";
                                              path = [
                                                {
                                                  kind = "identifier";
                                                  value = "interaction";
                                                }
                                                {
                                                  kind = "identifier";
                                                  value = "resize-amount";
                                                }
                                              ];
                                              type = "variable";
                                            }
                                          ];
                                          callee = {
                                            name = "lib";
                                            path = [
                                              {
                                                kind = "identifier";
                                                value = "gvariant";
                                              }
                                              {
                                                kind = "identifier";
                                                value = "mkUint32";
                                              }
                                            ];
                                            type = "variable";
                                          };
                                          type = "call";
                                        };
                                      }
                                      {
                                        operator = "=";
                                        target = [
                                          {
                                            kind = "identifier";
                                            value = "quick-settings-enabled";
                                          }
                                        ];
                                        type = "assignment";
                                        value = {
                                          name = "path";
                                          path = [
                                            {
                                              kind = "identifier";
                                              value = "general";
                                            }
                                            {
                                              kind = "identifier";
                                              value = "quick-settings";
                                            }
                                          ];
                                          type = "variable";
                                        };
                                      }
                                      {
                                        operator = "=";
                                        target = [
                                          {
                                            kind = "identifier";
                                            value = "logging-enabled";
                                          }
                                        ];
                                        type = "assignment";
                                        value = {
                                          name = "path";
                                          path = [
                                            {
                                              kind = "identifier";
                                              value = "general";
                                            }
                                            {
                                              kind = "identifier";
                                              value = "logging";
                                            }
                                            {
                                              kind = "identifier";
                                              value = "enable";
                                            }
                                          ];
                                          type = "variable";
                                        };
                                      }
                                      {
                                        operator = "=";
                                        target = [
                                          {
                                            kind = "identifier";
                                            value = "log-level";
                                          }
                                        ];
                                        type = "assignment";
                                        value = {
                                          arguments = [
                                            {
                                              name = "path";
                                              path = [
                                                {
                                                  kind = "identifier";
                                                  value = "general";
                                                }
                                                {
                                                  kind = "identifier";
                                                  value = "logging";
                                                }
                                                {
                                                  kind = "identifier";
                                                  value = "level";
                                                }
                                              ];
                                              type = "variable";
                                            }
                                          ];
                                          callee = {
                                            name = "lib";
                                            path = [
                                              {
                                                kind = "identifier";
                                                value = "gvariant";
                                              }
                                              {
                                                kind = "identifier";
                                                value = "mkUint32";
                                              }
                                            ];
                                            type = "variable";
                                          };
                                          type = "call";
                                        };
                                      }
                                      {
                                        operator = "=";
                                        target = [
                                          {
                                            kind = "identifier";
                                            value = "css-updated";
                                          }
                                        ];
                                        type = "assignment";
                                        value = {
                                          name = "path";
                                          path = [
                                            {
                                              kind = "identifier";
                                              value = "general";
                                            }
                                            {
                                              kind = "identifier";
                                              value = "css";
                                            }
                                            {
                                              kind = "identifier";
                                              value = "updated";
                                            }
                                          ];
                                          type = "variable";
                                        };
                                      }
                                      {
                                        operator = "=";
                                        target = [
                                          {
                                            kind = "identifier";
                                            value = "css-last-update";
                                          }
                                        ];
                                        type = "assignment";
                                        value = {
                                          arguments = [
                                            {
                                              name = "path";
                                              path = [
                                                {
                                                  kind = "identifier";
                                                  value = "general";
                                                }
                                                {
                                                  kind = "identifier";
                                                  value = "css";
                                                }
                                                {
                                                  kind = "identifier";
                                                  value = "last-update";
                                                }
                                              ];
                                              type = "variable";
                                            }
                                          ];
                                          callee = {
                                            name = "lib";
                                            path = [
                                              {
                                                kind = "identifier";
                                                value = "gvariant";
                                              }
                                              {
                                                kind = "identifier";
                                                value = "mkUint32";
                                              }
                                            ];
                                            type = "variable";
                                          };
                                          type = "call";
                                        };
                                      }
                                    ];
                                    type = "attr-set";
                                  };
                                }
                                {
                                  operator = "=";
                                  target = [
                                    {
                                      kind = "string";
                                      value = "org/gnome/shell/extensions/forge/keybindings";
                                    }
                                  ];
                                  type = "assignment";
                                  value = {
                                    recursive = false;
                                    statements = [
                                      {
                                        operator = "=";
                                        target = [
                                          {
                                            kind = "identifier";
                                            value = "focus-border-toggle";
                                          }
                                        ];
                                        type = "assignment";
                                        value = {
                                          arguments = [
                                            {
                                              name = "path";
                                              path = [
                                                {
                                                  kind = "identifier";
                                                  value = "keybindings";
                                                }
                                                {
                                                  kind = "identifier";
                                                  value = "focus-border-toggle";
                                                }
                                              ];
                                              type = "variable";
                                            }
                                          ];
                                          callee = {
                                            name = "v";
                                            path = [
                                              {
                                                kind = "identifier";
                                                value = "serializeKeybind";
                                              }
                                            ];
                                            type = "variable";
                                          };
                                          type = "call";
                                        };
                                      }
                                      {
                                        operator = "=";
                                        target = [
                                          {
                                            kind = "identifier";
                                            value = "window-gap-size-increase";
                                          }
                                        ];
                                        type = "assignment";
                                        value = {
                                          arguments = [
                                            {
                                              name = "path";
                                              path = [
                                                {
                                                  kind = "identifier";
                                                  value = "keybindings";
                                                }
                                                {
                                                  kind = "identifier";
                                                  value = "window-gap-size-increase";
                                                }
                                              ];
                                              type = "variable";
                                            }
                                          ];
                                          callee = {
                                            name = "v";
                                            path = [
                                              {
                                                kind = "identifier";
                                                value = "serializeKeybind";
                                              }
                                            ];
                                            type = "variable";
                                          };
                                          type = "call";
                                        };
                                      }
                                      {
                                        operator = "=";
                                        target = [
                                          {
                                            kind = "identifier";
                                            value = "window-gap-size-decrease";
                                          }
                                        ];
                                        type = "assignment";
                                        value = {
                                          arguments = [
                                            {
                                              name = "path";
                                              path = [
                                                {
                                                  kind = "identifier";
                                                  value = "keybindings";
                                                }
                                                {
                                                  kind = "identifier";
                                                  value = "window-gap-size-decrease";
                                                }
                                              ];
                                              type = "variable";
                                            }
                                          ];
                                          callee = {
                                            name = "v";
                                            path = [
                                              {
                                                kind = "identifier";
                                                value = "serializeKeybind";
                                              }
                                            ];
                                            type = "variable";
                                          };
                                          type = "call";
                                        };
                                      }
                                      {
                                        operator = "=";
                                        target = [
                                          {
                                            kind = "identifier";
                                            value = "con-split-layout-toggle";
                                          }
                                        ];
                                        type = "assignment";
                                        value = {
                                          arguments = [
                                            {
                                              name = "path";
                                              path = [
                                                {
                                                  kind = "identifier";
                                                  value = "keybindings";
                                                }
                                                {
                                                  kind = "identifier";
                                                  value = "con-split-layout-toggle";
                                                }
                                              ];
                                              type = "variable";
                                            }
                                          ];
                                          callee = {
                                            name = "v";
                                            path = [
                                              {
                                                kind = "identifier";
                                                value = "serializeKeybind";
                                              }
                                            ];
                                            type = "variable";
                                          };
                                          type = "call";
                                        };
                                      }
                                      {
                                        operator = "=";
                                        target = [
                                          {
                                            kind = "identifier";
                                            value = "con-split-horizontal";
                                          }
                                        ];
                                        type = "assignment";
                                        value = {
                                          arguments = [
                                            {
                                              name = "path";
                                              path = [
                                                {
                                                  kind = "identifier";
                                                  value = "keybindings";
                                                }
                                                {
                                                  kind = "identifier";
                                                  value = "con-split-horizontal";
                                                }
                                              ];
                                              type = "variable";
                                            }
                                          ];
                                          callee = {
                                            name = "v";
                                            path = [
                                              {
                                                kind = "identifier";
                                                value = "serializeKeybind";
                                              }
                                            ];
                                            type = "variable";
                                          };
                                          type = "call";
                                        };
                                      }
                                      {
                                        operator = "=";
                                        target = [
                                          {
                                            kind = "identifier";
                                            value = "con-split-vertical";
                                          }
                                        ];
                                        type = "assignment";
                                        value = {
                                          arguments = [
                                            {
                                              name = "path";
                                              path = [
                                                {
                                                  kind = "identifier";
                                                  value = "keybindings";
                                                }
                                                {
                                                  kind = "identifier";
                                                  value = "con-split-vertical";
                                                }
                                              ];
                                              type = "variable";
                                            }
                                          ];
                                          callee = {
                                            name = "v";
                                            path = [
                                              {
                                                kind = "identifier";
                                                value = "serializeKeybind";
                                              }
                                            ];
                                            type = "variable";
                                          };
                                          type = "call";
                                        };
                                      }
                                      {
                                        operator = "=";
                                        target = [
                                          {
                                            kind = "identifier";
                                            value = "con-stacked-layout-toggle";
                                          }
                                        ];
                                        type = "assignment";
                                        value = {
                                          arguments = [
                                            {
                                              name = "path";
                                              path = [
                                                {
                                                  kind = "identifier";
                                                  value = "keybindings";
                                                }
                                                {
                                                  kind = "identifier";
                                                  value = "con-stacked-layout-toggle";
                                                }
                                              ];
                                              type = "variable";
                                            }
                                          ];
                                          callee = {
                                            name = "v";
                                            path = [
                                              {
                                                kind = "identifier";
                                                value = "serializeKeybind";
                                              }
                                            ];
                                            type = "variable";
                                          };
                                          type = "call";
                                        };
                                      }
                                      {
                                        operator = "=";
                                        target = [
                                          {
                                            kind = "identifier";
                                            value = "con-tabbed-layout-toggle";
                                          }
                                        ];
                                        type = "assignment";
                                        value = {
                                          arguments = [
                                            {
                                              name = "path";
                                              path = [
                                                {
                                                  kind = "identifier";
                                                  value = "keybindings";
                                                }
                                                {
                                                  kind = "identifier";
                                                  value = "con-tabbed-layout-toggle";
                                                }
                                              ];
                                              type = "variable";
                                            }
                                          ];
                                          callee = {
                                            name = "v";
                                            path = [
                                              {
                                                kind = "identifier";
                                                value = "serializeKeybind";
                                              }
                                            ];
                                            type = "variable";
                                          };
                                          type = "call";
                                        };
                                      }
                                      {
                                        operator = "=";
                                        target = [
                                          {
                                            kind = "identifier";
                                            value = "con-tabbed-showtab-decoration-toggle";
                                          }
                                        ];
                                        type = "assignment";
                                        value = {
                                          arguments = [
                                            {
                                              name = "path";
                                              path = [
                                                {
                                                  kind = "identifier";
                                                  value = "keybindings";
                                                }
                                                {
                                                  kind = "identifier";
                                                  value = "con-tabbed-showtab-decoration-toggle";
                                                }
                                              ];
                                              type = "variable";
                                            }
                                          ];
                                          callee = {
                                            name = "v";
                                            path = [
                                              {
                                                kind = "identifier";
                                                value = "serializeKeybind";
                                              }
                                            ];
                                            type = "variable";
                                          };
                                          type = "call";
                                        };
                                      }
                                      {
                                        operator = "=";
                                        target = [
                                          {
                                            kind = "identifier";
                                            value = "window-swap-left";
                                          }
                                        ];
                                        type = "assignment";
                                        value = {
                                          arguments = [
                                            {
                                              name = "path";
                                              path = [
                                                {
                                                  kind = "identifier";
                                                  value = "keybindings";
                                                }
                                                {
                                                  kind = "identifier";
                                                  value = "window-swap-left";
                                                }
                                              ];
                                              type = "variable";
                                            }
                                          ];
                                          callee = {
                                            name = "v";
                                            path = [
                                              {
                                                kind = "identifier";
                                                value = "serializeKeybind";
                                              }
                                            ];
                                            type = "variable";
                                          };
                                          type = "call";
                                        };
                                      }
                                      {
                                        operator = "=";
                                        target = [
                                          {
                                            kind = "identifier";
                                            value = "window-swap-down";
                                          }
                                        ];
                                        type = "assignment";
                                        value = {
                                          arguments = [
                                            {
                                              name = "path";
                                              path = [
                                                {
                                                  kind = "identifier";
                                                  value = "keybindings";
                                                }
                                                {
                                                  kind = "identifier";
                                                  value = "window-swap-down";
                                                }
                                              ];
                                              type = "variable";
                                            }
                                          ];
                                          callee = {
                                            name = "v";
                                            path = [
                                              {
                                                kind = "identifier";
                                                value = "serializeKeybind";
                                              }
                                            ];
                                            type = "variable";
                                          };
                                          type = "call";
                                        };
                                      }
                                      {
                                        operator = "=";
                                        target = [
                                          {
                                            kind = "identifier";
                                            value = "window-swap-up";
                                          }
                                        ];
                                        type = "assignment";
                                        value = {
                                          arguments = [
                                            {
                                              name = "path";
                                              path = [
                                                {
                                                  kind = "identifier";
                                                  value = "keybindings";
                                                }
                                                {
                                                  kind = "identifier";
                                                  value = "window-swap-up";
                                                }
                                              ];
                                              type = "variable";
                                            }
                                          ];
                                          callee = {
                                            name = "v";
                                            path = [
                                              {
                                                kind = "identifier";
                                                value = "serializeKeybind";
                                              }
                                            ];
                                            type = "variable";
                                          };
                                          type = "call";
                                        };
                                      }
                                      {
                                        operator = "=";
                                        target = [
                                          {
                                            kind = "identifier";
                                            value = "window-swap-right";
                                          }
                                        ];
                                        type = "assignment";
                                        value = {
                                          arguments = [
                                            {
                                              name = "path";
                                              path = [
                                                {
                                                  kind = "identifier";
                                                  value = "keybindings";
                                                }
                                                {
                                                  kind = "identifier";
                                                  value = "window-swap-right";
                                                }
                                              ];
                                              type = "variable";
                                            }
                                          ];
                                          callee = {
                                            name = "v";
                                            path = [
                                              {
                                                kind = "identifier";
                                                value = "serializeKeybind";
                                              }
                                            ];
                                            type = "variable";
                                          };
                                          type = "call";
                                        };
                                      }
                                      {
                                        operator = "=";
                                        target = [
                                          {
                                            kind = "identifier";
                                            value = "window-move-left";
                                          }
                                        ];
                                        type = "assignment";
                                        value = {
                                          arguments = [
                                            {
                                              name = "path";
                                              path = [
                                                {
                                                  kind = "identifier";
                                                  value = "keybindings";
                                                }
                                                {
                                                  kind = "identifier";
                                                  value = "window-move-left";
                                                }
                                              ];
                                              type = "variable";
                                            }
                                          ];
                                          callee = {
                                            name = "v";
                                            path = [
                                              {
                                                kind = "identifier";
                                                value = "serializeKeybind";
                                              }
                                            ];
                                            type = "variable";
                                          };
                                          type = "call";
                                        };
                                      }
                                      {
                                        operator = "=";
                                        target = [
                                          {
                                            kind = "identifier";
                                            value = "window-move-down";
                                          }
                                        ];
                                        type = "assignment";
                                        value = {
                                          arguments = [
                                            {
                                              name = "path";
                                              path = [
                                                {
                                                  kind = "identifier";
                                                  value = "keybindings";
                                                }
                                                {
                                                  kind = "identifier";
                                                  value = "window-move-down";
                                                }
                                              ];
                                              type = "variable";
                                            }
                                          ];
                                          callee = {
                                            name = "v";
                                            path = [
                                              {
                                                kind = "identifier";
                                                value = "serializeKeybind";
                                              }
                                            ];
                                            type = "variable";
                                          };
                                          type = "call";
                                        };
                                      }
                                      {
                                        operator = "=";
                                        target = [
                                          {
                                            kind = "identifier";
                                            value = "window-move-up";
                                          }
                                        ];
                                        type = "assignment";
                                        value = {
                                          arguments = [
                                            {
                                              name = "path";
                                              path = [
                                                {
                                                  kind = "identifier";
                                                  value = "keybindings";
                                                }
                                                {
                                                  kind = "identifier";
                                                  value = "window-move-up";
                                                }
                                              ];
                                              type = "variable";
                                            }
                                          ];
                                          callee = {
                                            name = "v";
                                            path = [
                                              {
                                                kind = "identifier";
                                                value = "serializeKeybind";
                                              }
                                            ];
                                            type = "variable";
                                          };
                                          type = "call";
                                        };
                                      }
                                      {
                                        operator = "=";
                                        target = [
                                          {
                                            kind = "identifier";
                                            value = "window-move-right";
                                          }
                                        ];
                                        type = "assignment";
                                        value = {
                                          arguments = [
                                            {
                                              name = "path";
                                              path = [
                                                {
                                                  kind = "identifier";
                                                  value = "keybindings";
                                                }
                                                {
                                                  kind = "identifier";
                                                  value = "window-move-right";
                                                }
                                              ];
                                              type = "variable";
                                            }
                                          ];
                                          callee = {
                                            name = "v";
                                            path = [
                                              {
                                                kind = "identifier";
                                                value = "serializeKeybind";
                                              }
                                            ];
                                            type = "variable";
                                          };
                                          type = "call";
                                        };
                                      }
                                      {
                                        operator = "=";
                                        target = [
                                          {
                                            kind = "identifier";
                                            value = "window-focus-left";
                                          }
                                        ];
                                        type = "assignment";
                                        value = {
                                          arguments = [
                                            {
                                              name = "path";
                                              path = [
                                                {
                                                  kind = "identifier";
                                                  value = "keybindings";
                                                }
                                                {
                                                  kind = "identifier";
                                                  value = "window-focus-left";
                                                }
                                              ];
                                              type = "variable";
                                            }
                                          ];
                                          callee = {
                                            name = "v";
                                            path = [
                                              {
                                                kind = "identifier";
                                                value = "serializeKeybind";
                                              }
                                            ];
                                            type = "variable";
                                          };
                                          type = "call";
                                        };
                                      }
                                      {
                                        operator = "=";
                                        target = [
                                          {
                                            kind = "identifier";
                                            value = "window-focus-down";
                                          }
                                        ];
                                        type = "assignment";
                                        value = {
                                          arguments = [
                                            {
                                              name = "path";
                                              path = [
                                                {
                                                  kind = "identifier";
                                                  value = "keybindings";
                                                }
                                                {
                                                  kind = "identifier";
                                                  value = "window-focus-down";
                                                }
                                              ];
                                              type = "variable";
                                            }
                                          ];
                                          callee = {
                                            name = "v";
                                            path = [
                                              {
                                                kind = "identifier";
                                                value = "serializeKeybind";
                                              }
                                            ];
                                            type = "variable";
                                          };
                                          type = "call";
                                        };
                                      }
                                      {
                                        operator = "=";
                                        target = [
                                          {
                                            kind = "identifier";
                                            value = "window-focus-up";
                                          }
                                        ];
                                        type = "assignment";
                                        value = {
                                          arguments = [
                                            {
                                              name = "path";
                                              path = [
                                                {
                                                  kind = "identifier";
                                                  value = "keybindings";
                                                }
                                                {
                                                  kind = "identifier";
                                                  value = "window-focus-up";
                                                }
                                              ];
                                              type = "variable";
                                            }
                                          ];
                                          callee = {
                                            name = "v";
                                            path = [
                                              {
                                                kind = "identifier";
                                                value = "serializeKeybind";
                                              }
                                            ];
                                            type = "variable";
                                          };
                                          type = "call";
                                        };
                                      }
                                      {
                                        operator = "=";
                                        target = [
                                          {
                                            kind = "identifier";
                                            value = "window-focus-right";
                                          }
                                        ];
                                        type = "assignment";
                                        value = {
                                          arguments = [
                                            {
                                              name = "path";
                                              path = [
                                                {
                                                  kind = "identifier";
                                                  value = "keybindings";
                                                }
                                                {
                                                  kind = "identifier";
                                                  value = "window-focus-right";
                                                }
                                              ];
                                              type = "variable";
                                            }
                                          ];
                                          callee = {
                                            name = "v";
                                            path = [
                                              {
                                                kind = "identifier";
                                                value = "serializeKeybind";
                                              }
                                            ];
                                            type = "variable";
                                          };
                                          type = "call";
                                        };
                                      }
                                      {
                                        operator = "=";
                                        target = [
                                          {
                                            kind = "identifier";
                                            value = "window-toggle-float";
                                          }
                                        ];
                                        type = "assignment";
                                        value = {
                                          arguments = [
                                            {
                                              name = "path";
                                              path = [
                                                {
                                                  kind = "identifier";
                                                  value = "keybindings";
                                                }
                                                {
                                                  kind = "identifier";
                                                  value = "window-toggle-float";
                                                }
                                              ];
                                              type = "variable";
                                            }
                                          ];
                                          callee = {
                                            name = "v";
                                            path = [
                                              {
                                                kind = "identifier";
                                                value = "serializeKeybind";
                                              }
                                            ];
                                            type = "variable";
                                          };
                                          type = "call";
                                        };
                                      }
                                      {
                                        operator = "=";
                                        target = [
                                          {
                                            kind = "identifier";
                                            value = "window-toggle-always-float";
                                          }
                                        ];
                                        type = "assignment";
                                        value = {
                                          arguments = [
                                            {
                                              name = "path";
                                              path = [
                                                {
                                                  kind = "identifier";
                                                  value = "keybindings";
                                                }
                                                {
                                                  kind = "identifier";
                                                  value = "window-toggle-always-float";
                                                }
                                              ];
                                              type = "variable";
                                            }
                                          ];
                                          callee = {
                                            name = "v";
                                            path = [
                                              {
                                                kind = "identifier";
                                                value = "serializeKeybind";
                                              }
                                            ];
                                            type = "variable";
                                          };
                                          type = "call";
                                        };
                                      }
                                      {
                                        operator = "=";
                                        target = [
                                          {
                                            kind = "identifier";
                                            value = "workspace-active-tile-toggle";
                                          }
                                        ];
                                        type = "assignment";
                                        value = {
                                          arguments = [
                                            {
                                              name = "path";
                                              path = [
                                                {
                                                  kind = "identifier";
                                                  value = "keybindings";
                                                }
                                                {
                                                  kind = "identifier";
                                                  value = "workspace-active-tile-toggle";
                                                }
                                              ];
                                              type = "variable";
                                            }
                                          ];
                                          callee = {
                                            name = "v";
                                            path = [
                                              {
                                                kind = "identifier";
                                                value = "serializeKeybind";
                                              }
                                            ];
                                            type = "variable";
                                          };
                                          type = "call";
                                        };
                                      }
                                      {
                                        operator = "=";
                                        target = [
                                          {
                                            kind = "identifier";
                                            value = "prefs-open";
                                          }
                                        ];
                                        type = "assignment";
                                        value = {
                                          arguments = [
                                            {
                                              name = "path";
                                              path = [
                                                {
                                                  kind = "identifier";
                                                  value = "keybindings";
                                                }
                                                {
                                                  kind = "identifier";
                                                  value = "prefs-open";
                                                }
                                              ];
                                              type = "variable";
                                            }
                                          ];
                                          callee = {
                                            name = "v";
                                            path = [
                                              {
                                                kind = "identifier";
                                                value = "serializeKeybind";
                                              }
                                            ];
                                            type = "variable";
                                          };
                                          type = "call";
                                        };
                                      }
                                      {
                                        operator = "=";
                                        target = [
                                          {
                                            kind = "identifier";
                                            value = "prefs-tiling-toggle";
                                          }
                                        ];
                                        type = "assignment";
                                        value = {
                                          arguments = [
                                            {
                                              name = "path";
                                              path = [
                                                {
                                                  kind = "identifier";
                                                  value = "keybindings";
                                                }
                                                {
                                                  kind = "identifier";
                                                  value = "prefs-tiling-toggle";
                                                }
                                              ];
                                              type = "variable";
                                            }
                                          ];
                                          callee = {
                                            name = "v";
                                            path = [
                                              {
                                                kind = "identifier";
                                                value = "serializeKeybind";
                                              }
                                            ];
                                            type = "variable";
                                          };
                                          type = "call";
                                        };
                                      }
                                      {
                                        operator = "=";
                                        target = [
                                          {
                                            kind = "identifier";
                                            value = "mod-mask-mouse-tile";
                                          }
                                        ];
                                        type = "assignment";
                                        value = {
                                          name = "path";
                                          path = [
                                            {
                                              kind = "identifier";
                                              value = "keybindings";
                                            }
                                            {
                                              kind = "identifier";
                                              value = "mod-mask-mouse-tile";
                                            }
                                          ];
                                          type = "variable";
                                        };
                                      }
                                      {
                                        operator = "=";
                                        target = [
                                          {
                                            kind = "identifier";
                                            value = "window-swap-last-active";
                                          }
                                        ];
                                        type = "assignment";
                                        value = {
                                          arguments = [
                                            {
                                              name = "path";
                                              path = [
                                                {
                                                  kind = "identifier";
                                                  value = "keybindings";
                                                }
                                                {
                                                  kind = "identifier";
                                                  value = "window-swap-last-active";
                                                }
                                              ];
                                              type = "variable";
                                            }
                                          ];
                                          callee = {
                                            name = "v";
                                            path = [
                                              {
                                                kind = "identifier";
                                                value = "serializeKeybind";
                                              }
                                            ];
                                            type = "variable";
                                          };
                                          type = "call";
                                        };
                                      }
                                      {
                                        operator = "=";
                                        target = [
                                          {
                                            kind = "identifier";
                                            value = "window-snap-one-third-right";
                                          }
                                        ];
                                        type = "assignment";
                                        value = {
                                          arguments = [
                                            {
                                              name = "path";
                                              path = [
                                                {
                                                  kind = "identifier";
                                                  value = "keybindings";
                                                }
                                                {
                                                  kind = "identifier";
                                                  value = "window-snap-one-third-right";
                                                }
                                              ];
                                              type = "variable";
                                            }
                                          ];
                                          callee = {
                                            name = "v";
                                            path = [
                                              {
                                                kind = "identifier";
                                                value = "serializeKeybind";
                                              }
                                            ];
                                            type = "variable";
                                          };
                                          type = "call";
                                        };
                                      }
                                      {
                                        operator = "=";
                                        target = [
                                          {
                                            kind = "identifier";
                                            value = "window-snap-two-third-right";
                                          }
                                        ];
                                        type = "assignment";
                                        value = {
                                          arguments = [
                                            {
                                              name = "path";
                                              path = [
                                                {
                                                  kind = "identifier";
                                                  value = "keybindings";
                                                }
                                                {
                                                  kind = "identifier";
                                                  value = "window-snap-two-third-right";
                                                }
                                              ];
                                              type = "variable";
                                            }
                                          ];
                                          callee = {
                                            name = "v";
                                            path = [
                                              {
                                                kind = "identifier";
                                                value = "serializeKeybind";
                                              }
                                            ];
                                            type = "variable";
                                          };
                                          type = "call";
                                        };
                                      }
                                      {
                                        operator = "=";
                                        target = [
                                          {
                                            kind = "identifier";
                                            value = "window-snap-one-third-left";
                                          }
                                        ];
                                        type = "assignment";
                                        value = {
                                          arguments = [
                                            {
                                              name = "path";
                                              path = [
                                                {
                                                  kind = "identifier";
                                                  value = "keybindings";
                                                }
                                                {
                                                  kind = "identifier";
                                                  value = "window-snap-one-third-left";
                                                }
                                              ];
                                              type = "variable";
                                            }
                                          ];
                                          callee = {
                                            name = "v";
                                            path = [
                                              {
                                                kind = "identifier";
                                                value = "serializeKeybind";
                                              }
                                            ];
                                            type = "variable";
                                          };
                                          type = "call";
                                        };
                                      }
                                      {
                                        operator = "=";
                                        target = [
                                          {
                                            kind = "identifier";
                                            value = "window-snap-two-third-left";
                                          }
                                        ];
                                        type = "assignment";
                                        value = {
                                          arguments = [
                                            {
                                              name = "path";
                                              path = [
                                                {
                                                  kind = "identifier";
                                                  value = "keybindings";
                                                }
                                                {
                                                  kind = "identifier";
                                                  value = "window-snap-two-third-left";
                                                }
                                              ];
                                              type = "variable";
                                            }
                                          ];
                                          callee = {
                                            name = "v";
                                            path = [
                                              {
                                                kind = "identifier";
                                                value = "serializeKeybind";
                                              }
                                            ];
                                            type = "variable";
                                          };
                                          type = "call";
                                        };
                                      }
                                      {
                                        operator = "=";
                                        target = [
                                          {
                                            kind = "identifier";
                                            value = "window-snap-center";
                                          }
                                        ];
                                        type = "assignment";
                                        value = {
                                          arguments = [
                                            {
                                              name = "path";
                                              path = [
                                                {
                                                  kind = "identifier";
                                                  value = "keybindings";
                                                }
                                                {
                                                  kind = "identifier";
                                                  value = "window-snap-center";
                                                }
                                              ];
                                              type = "variable";
                                            }
                                          ];
                                          callee = {
                                            name = "v";
                                            path = [
                                              {
                                                kind = "identifier";
                                                value = "serializeKeybind";
                                              }
                                            ];
                                            type = "variable";
                                          };
                                          type = "call";
                                        };
                                      }
                                      {
                                        operator = "=";
                                        target = [
                                          {
                                            kind = "identifier";
                                            value = "window-resize-left-increase";
                                          }
                                        ];
                                        type = "assignment";
                                        value = {
                                          arguments = [
                                            {
                                              name = "path";
                                              path = [
                                                {
                                                  kind = "identifier";
                                                  value = "keybindings";
                                                }
                                                {
                                                  kind = "identifier";
                                                  value = "window-resize-left-increase";
                                                }
                                              ];
                                              type = "variable";
                                            }
                                          ];
                                          callee = {
                                            name = "v";
                                            path = [
                                              {
                                                kind = "identifier";
                                                value = "serializeKeybind";
                                              }
                                            ];
                                            type = "variable";
                                          };
                                          type = "call";
                                        };
                                      }
                                      {
                                        operator = "=";
                                        target = [
                                          {
                                            kind = "identifier";
                                            value = "window-resize-left-decrease";
                                          }
                                        ];
                                        type = "assignment";
                                        value = {
                                          arguments = [
                                            {
                                              name = "path";
                                              path = [
                                                {
                                                  kind = "identifier";
                                                  value = "keybindings";
                                                }
                                                {
                                                  kind = "identifier";
                                                  value = "window-resize-left-decrease";
                                                }
                                              ];
                                              type = "variable";
                                            }
                                          ];
                                          callee = {
                                            name = "v";
                                            path = [
                                              {
                                                kind = "identifier";
                                                value = "serializeKeybind";
                                              }
                                            ];
                                            type = "variable";
                                          };
                                          type = "call";
                                        };
                                      }
                                      {
                                        operator = "=";
                                        target = [
                                          {
                                            kind = "identifier";
                                            value = "window-resize-bottom-increase";
                                          }
                                        ];
                                        type = "assignment";
                                        value = {
                                          arguments = [
                                            {
                                              name = "path";
                                              path = [
                                                {
                                                  kind = "identifier";
                                                  value = "keybindings";
                                                }
                                                {
                                                  kind = "identifier";
                                                  value = "window-resize-bottom-increase";
                                                }
                                              ];
                                              type = "variable";
                                            }
                                          ];
                                          callee = {
                                            name = "v";
                                            path = [
                                              {
                                                kind = "identifier";
                                                value = "serializeKeybind";
                                              }
                                            ];
                                            type = "variable";
                                          };
                                          type = "call";
                                        };
                                      }
                                      {
                                        operator = "=";
                                        target = [
                                          {
                                            kind = "identifier";
                                            value = "window-resize-bottom-decrease";
                                          }
                                        ];
                                        type = "assignment";
                                        value = {
                                          arguments = [
                                            {
                                              name = "path";
                                              path = [
                                                {
                                                  kind = "identifier";
                                                  value = "keybindings";
                                                }
                                                {
                                                  kind = "identifier";
                                                  value = "window-resize-bottom-decrease";
                                                }
                                              ];
                                              type = "variable";
                                            }
                                          ];
                                          callee = {
                                            name = "v";
                                            path = [
                                              {
                                                kind = "identifier";
                                                value = "serializeKeybind";
                                              }
                                            ];
                                            type = "variable";
                                          };
                                          type = "call";
                                        };
                                      }
                                      {
                                        operator = "=";
                                        target = [
                                          {
                                            kind = "identifier";
                                            value = "window-resize-top-increase";
                                          }
                                        ];
                                        type = "assignment";
                                        value = {
                                          arguments = [
                                            {
                                              name = "path";
                                              path = [
                                                {
                                                  kind = "identifier";
                                                  value = "keybindings";
                                                }
                                                {
                                                  kind = "identifier";
                                                  value = "window-resize-top-increase";
                                                }
                                              ];
                                              type = "variable";
                                            }
                                          ];
                                          callee = {
                                            name = "v";
                                            path = [
                                              {
                                                kind = "identifier";
                                                value = "serializeKeybind";
                                              }
                                            ];
                                            type = "variable";
                                          };
                                          type = "call";
                                        };
                                      }
                                      {
                                        operator = "=";
                                        target = [
                                          {
                                            kind = "identifier";
                                            value = "window-resize-top-decrease";
                                          }
                                        ];
                                        type = "assignment";
                                        value = {
                                          arguments = [
                                            {
                                              name = "path";
                                              path = [
                                                {
                                                  kind = "identifier";
                                                  value = "keybindings";
                                                }
                                                {
                                                  kind = "identifier";
                                                  value = "window-resize-top-decrease";
                                                }
                                              ];
                                              type = "variable";
                                            }
                                          ];
                                          callee = {
                                            name = "v";
                                            path = [
                                              {
                                                kind = "identifier";
                                                value = "serializeKeybind";
                                              }
                                            ];
                                            type = "variable";
                                          };
                                          type = "call";
                                        };
                                      }
                                      {
                                        operator = "=";
                                        target = [
                                          {
                                            kind = "identifier";
                                            value = "window-resize-right-increase";
                                          }
                                        ];
                                        type = "assignment";
                                        value = {
                                          arguments = [
                                            {
                                              name = "path";
                                              path = [
                                                {
                                                  kind = "identifier";
                                                  value = "keybindings";
                                                }
                                                {
                                                  kind = "identifier";
                                                  value = "window-resize-right-increase";
                                                }
                                              ];
                                              type = "variable";
                                            }
                                          ];
                                          callee = {
                                            name = "v";
                                            path = [
                                              {
                                                kind = "identifier";
                                                value = "serializeKeybind";
                                              }
                                            ];
                                            type = "variable";
                                          };
                                          type = "call";
                                        };
                                      }
                                      {
                                        operator = "=";
                                        target = [
                                          {
                                            kind = "identifier";
                                            value = "window-resize-right-decrease";
                                          }
                                        ];
                                        type = "assignment";
                                        value = {
                                          arguments = [
                                            {
                                              name = "path";
                                              path = [
                                                {
                                                  kind = "identifier";
                                                  value = "keybindings";
                                                }
                                                {
                                                  kind = "identifier";
                                                  value = "window-resize-right-decrease";
                                                }
                                              ];
                                              type = "variable";
                                            }
                                          ];
                                          callee = {
                                            name = "v";
                                            path = [
                                              {
                                                kind = "identifier";
                                                value = "serializeKeybind";
                                              }
                                            ];
                                            type = "variable";
                                          };
                                          type = "call";
                                        };
                                      }
                                    ];
                                    type = "attr-set";
                                  };
                                }
                              ];
                              type = "attr-set";
                            };
                          }
                        ];
                        type = "attr-set";
                      };
                    }
                  ];
                  type = "attr-set";
                };
                guards = [ ];
                scope = "user";
                type = "action";
                unconditional = false;
              }
            ];
            type = "attr-set";
          };
          type = "enable-option";
        };
      }
      {
        operator = "=";
        target = [
          {
            kind = "identifier";
            value = "appearance";
          }
        ];
        type = "assignment";
        value = {
          recursive = false;
          statements = [
            {
              operator = "=";
              target = [
                {
                  kind = "identifier";
                  value = "borders";
                }
              ];
              type = "assignment";
              value = {
                recursive = false;
                statements = [
                  {
                    operator = "=";
                    target = [
                      {
                        kind = "identifier";
                        value = "focus";
                      }
                    ];
                    type = "assignment";
                    value = {
                      recursive = false;
                      statements = [
                        {
                          operator = "=";
                          target = [
                            {
                              kind = "identifier";
                              value = "toggle";
                            }
                          ];
                          type = "assignment";
                          value = {
                            recursive = false;
                            statements = [
                              {
                                operator = "=";
                                target = [
                                  {
                                    kind = "identifier";
                                    value = "_meta";
                                  }
                                ];
                                type = "assignment";
                                value = {
                                  recursive = false;
                                  statements = [
                                    {
                                      operator = "=";
                                      target = [
                                        {
                                          kind = "identifier";
                                          value = "type";
                                        }
                                      ];
                                      type = "assignment";
                                      value = {
                                        name = "type";
                                        path = [
                                          {
                                            kind = "identifier";
                                            value = "bool";
                                          }
                                        ];
                                        type = "variable";
                                      };
                                    }
                                    {
                                      operator = "=";
                                      target = [
                                        {
                                          kind = "identifier";
                                          value = "default";
                                        }
                                      ];
                                      type = "assignment";
                                      value = {
                                        kind = "true";
                                        type = "literal";
                                        value = true;
                                      };
                                    }
                                    {
                                      operator = "=";
                                      target = [
                                        {
                                          kind = "identifier";
                                          value = "description";
                                        }
                                      ];
                                      type = "assignment";
                                      value = {
                                        multiline = true;
                                        parts = [
                                          {
                                            type = "text";
                                            value = "Display border on focused window";
                                          }
                                        ];
                                        type = "string";
                                      };
                                    }
                                  ];
                                  type = "attr-set";
                                };
                              }
                            ];
                            type = "attr-set";
                          };
                        }
                        {
                          operator = "=";
                          target = [
                            {
                              kind = "identifier";
                              value = "size";
                            }
                          ];
                          type = "assignment";
                          value = {
                            recursive = false;
                            statements = [
                              {
                                operator = "=";
                                target = [
                                  {
                                    kind = "identifier";
                                    value = "_meta";
                                  }
                                ];
                                type = "assignment";
                                value = {
                                  recursive = false;
                                  statements = [
                                    {
                                      operator = "=";
                                      target = [
                                        {
                                          kind = "identifier";
                                          value = "type";
                                        }
                                      ];
                                      type = "assignment";
                                      value = {
                                        name = "type";
                                        path = [
                                          {
                                            kind = "identifier";
                                            value = "int";
                                          }
                                        ];
                                        type = "variable";
                                      };
                                    }
                                    {
                                      operator = "=";
                                      target = [
                                        {
                                          kind = "identifier";
                                          value = "default";
                                        }
                                      ];
                                      type = "assignment";
                                      value = {
                                        kind = "integer";
                                        type = "literal";
                                        value = 3;
                                      };
                                    }
                                    {
                                      operator = "=";
                                      target = [
                                        {
                                          kind = "identifier";
                                          value = "description";
                                        }
                                      ];
                                      type = "assignment";
                                      value = {
                                        multiline = true;
                                        parts = [
                                          {
                                            type = "text";
                                            value = "Focused window border pixel thickness";
                                          }
                                        ];
                                        type = "string";
                                      };
                                    }
                                  ];
                                  type = "attr-set";
                                };
                              }
                            ];
                            type = "attr-set";
                          };
                        }
                        {
                          operator = "=";
                          target = [
                            {
                              kind = "identifier";
                              value = "color";
                            }
                          ];
                          type = "assignment";
                          value = {
                            recursive = false;
                            statements = [
                              {
                                operator = "=";
                                target = [
                                  {
                                    kind = "identifier";
                                    value = "_meta";
                                  }
                                ];
                                type = "assignment";
                                value = {
                                  recursive = false;
                                  statements = [
                                    {
                                      operator = "=";
                                      target = [
                                        {
                                          kind = "identifier";
                                          value = "type";
                                        }
                                      ];
                                      type = "assignment";
                                      value = {
                                        name = "type";
                                        path = [
                                          {
                                            kind = "identifier";
                                            value = "string";
                                          }
                                        ];
                                        type = "variable";
                                      };
                                    }
                                    {
                                      operator = "=";
                                      target = [
                                        {
                                          kind = "identifier";
                                          value = "default";
                                        }
                                      ];
                                      type = "assignment";
                                      value = {
                                        multiline = false;
                                        parts = [
                                          {
                                            type = "text";
                                            value = "rgba(236, 94, 94, 1)";
                                          }
                                        ];
                                        type = "string";
                                      };
                                    }
                                    {
                                      operator = "=";
                                      target = [
                                        {
                                          kind = "identifier";
                                          value = "description";
                                        }
                                      ];
                                      type = "assignment";
                                      value = {
                                        multiline = true;
                                        parts = [
                                          {
                                            type = "text";
                                            value = "CSS color for focused border";
                                          }
                                        ];
                                        type = "string";
                                      };
                                    }
                                  ];
                                  type = "attr-set";
                                };
                              }
                            ];
                            type = "attr-set";
                          };
                        }
                      ];
                      type = "attr-set";
                    };
                  }
                  {
                    operator = "=";
                    target = [
                      {
                        kind = "identifier";
                        value = "split";
                      }
                    ];
                    type = "assignment";
                    value = {
                      recursive = false;
                      statements = [
                        {
                          operator = "=";
                          target = [
                            {
                              kind = "identifier";
                              value = "toggle";
                            }
                          ];
                          type = "assignment";
                          value = {
                            recursive = false;
                            statements = [
                              {
                                operator = "=";
                                target = [
                                  {
                                    kind = "identifier";
                                    value = "_meta";
                                  }
                                ];
                                type = "assignment";
                                value = {
                                  recursive = false;
                                  statements = [
                                    {
                                      operator = "=";
                                      target = [
                                        {
                                          kind = "identifier";
                                          value = "type";
                                        }
                                      ];
                                      type = "assignment";
                                      value = {
                                        name = "type";
                                        path = [
                                          {
                                            kind = "identifier";
                                            value = "bool";
                                          }
                                        ];
                                        type = "variable";
                                      };
                                    }
                                    {
                                      operator = "=";
                                      target = [
                                        {
                                          kind = "identifier";
                                          value = "default";
                                        }
                                      ];
                                      type = "assignment";
                                      value = {
                                        kind = "true";
                                        type = "literal";
                                        value = true;
                                      };
                                    }
                                    {
                                      operator = "=";
                                      target = [
                                        {
                                          kind = "identifier";
                                          value = "description";
                                        }
                                      ];
                                      type = "assignment";
                                      value = {
                                        multiline = true;
                                        parts = [
                                          {
                                            type = "text";
                                            value = "Display split direction indicator";
                                          }
                                        ];
                                        type = "string";
                                      };
                                    }
                                  ];
                                  type = "attr-set";
                                };
                              }
                            ];
                            type = "attr-set";
                          };
                        }
                        {
                          operator = "=";
                          target = [
                            {
                              kind = "identifier";
                              value = "color";
                            }
                          ];
                          type = "assignment";
                          value = {
                            recursive = false;
                            statements = [
                              {
                                operator = "=";
                                target = [
                                  {
                                    kind = "identifier";
                                    value = "_meta";
                                  }
                                ];
                                type = "assignment";
                                value = {
                                  recursive = false;
                                  statements = [
                                    {
                                      operator = "=";
                                      target = [
                                        {
                                          kind = "identifier";
                                          value = "type";
                                        }
                                      ];
                                      type = "assignment";
                                      value = {
                                        name = "type";
                                        path = [
                                          {
                                            kind = "identifier";
                                            value = "string";
                                          }
                                        ];
                                        type = "variable";
                                      };
                                    }
                                    {
                                      operator = "=";
                                      target = [
                                        {
                                          kind = "identifier";
                                          value = "default";
                                        }
                                      ];
                                      type = "assignment";
                                      value = {
                                        multiline = false;
                                        parts = [
                                          {
                                            type = "text";
                                            value = "rgba(255, 246, 108, 1)";
                                          }
                                        ];
                                        type = "string";
                                      };
                                    }
                                    {
                                      operator = "=";
                                      target = [
                                        {
                                          kind = "identifier";
                                          value = "description";
                                        }
                                      ];
                                      type = "assignment";
                                      value = {
                                        multiline = true;
                                        parts = [
                                          {
                                            type = "text";
                                            value = "CSS color for split indicator";
                                          }
                                        ];
                                        type = "string";
                                      };
                                    }
                                  ];
                                  type = "attr-set";
                                };
                              }
                            ];
                            type = "attr-set";
                          };
                        }
                      ];
                      type = "attr-set";
                    };
                  }
                ];
                type = "attr-set";
              };
            }
            {
              operator = "=";
              target = [
                {
                  kind = "identifier";
                  value = "gaps";
                }
              ];
              type = "assignment";
              value = {
                recursive = false;
                statements = [
                  {
                    operator = "=";
                    target = [
                      {
                        kind = "identifier";
                        value = "size";
                      }
                    ];
                    type = "assignment";
                    value = {
                      recursive = false;
                      statements = [
                        {
                          operator = "=";
                          target = [
                            {
                              kind = "identifier";
                              value = "_meta";
                            }
                          ];
                          type = "assignment";
                          value = {
                            recursive = false;
                            statements = [
                              {
                                operator = "=";
                                target = [
                                  {
                                    kind = "identifier";
                                    value = "type";
                                  }
                                ];
                                type = "assignment";
                                value = {
                                  name = "type";
                                  path = [
                                    {
                                      kind = "identifier";
                                      value = "int";
                                    }
                                  ];
                                  type = "variable";
                                };
                              }
                              {
                                operator = "=";
                                target = [
                                  {
                                    kind = "identifier";
                                    value = "default";
                                  }
                                ];
                                type = "assignment";
                                value = {
                                  kind = "integer";
                                  type = "literal";
                                  value = 4;
                                };
                              }
                              {
                                operator = "=";
                                target = [
                                  {
                                    kind = "identifier";
                                    value = "description";
                                  }
                                ];
                                type = "assignment";
                                value = {
                                  multiline = true;
                                  parts = [
                                    {
                                      type = "text";
                                      value = "Base gap size between tiled windows";
                                    }
                                  ];
                                  type = "string";
                                };
                              }
                            ];
                            type = "attr-set";
                          };
                        }
                      ];
                      type = "attr-set";
                    };
                  }
                  {
                    operator = "=";
                    target = [
                      {
                        kind = "identifier";
                        value = "increment";
                      }
                    ];
                    type = "assignment";
                    value = {
                      recursive = false;
                      statements = [
                        {
                          operator = "=";
                          target = [
                            {
                              kind = "identifier";
                              value = "_meta";
                            }
                          ];
                          type = "assignment";
                          value = {
                            recursive = false;
                            statements = [
                              {
                                operator = "=";
                                target = [
                                  {
                                    kind = "identifier";
                                    value = "type";
                                  }
                                ];
                                type = "assignment";
                                value = {
                                  name = "type";
                                  path = [
                                    {
                                      kind = "identifier";
                                      value = "int";
                                    }
                                  ];
                                  type = "variable";
                                };
                              }
                              {
                                operator = "=";
                                target = [
                                  {
                                    kind = "identifier";
                                    value = "default";
                                  }
                                ];
                                type = "assignment";
                                value = {
                                  kind = "integer";
                                  type = "literal";
                                  value = 1;
                                };
                              }
                              {
                                operator = "=";
                                target = [
                                  {
                                    kind = "identifier";
                                    value = "description";
                                  }
                                ];
                                type = "assignment";
                                value = {
                                  multiline = true;
                                  parts = [
                                    {
                                      type = "text";
                                      value = "Multiplier for gap size adjustments";
                                    }
                                  ];
                                  type = "string";
                                };
                              }
                            ];
                            type = "attr-set";
                          };
                        }
                      ];
                      type = "attr-set";
                    };
                  }
                  {
                    operator = "=";
                    target = [
                      {
                        kind = "identifier";
                        value = "hide-on-single";
                      }
                    ];
                    type = "assignment";
                    value = {
                      recursive = false;
                      statements = [
                        {
                          operator = "=";
                          target = [
                            {
                              kind = "identifier";
                              value = "_meta";
                            }
                          ];
                          type = "assignment";
                          value = {
                            recursive = false;
                            statements = [
                              {
                                operator = "=";
                                target = [
                                  {
                                    kind = "identifier";
                                    value = "type";
                                  }
                                ];
                                type = "assignment";
                                value = {
                                  name = "type";
                                  path = [
                                    {
                                      kind = "identifier";
                                      value = "bool";
                                    }
                                  ];
                                  type = "variable";
                                };
                              }
                              {
                                operator = "=";
                                target = [
                                  {
                                    kind = "identifier";
                                    value = "default";
                                  }
                                ];
                                type = "assignment";
                                value = {
                                  kind = "false";
                                  type = "literal";
                                  value = false;
                                };
                              }
                              {
                                operator = "=";
                                target = [
                                  {
                                    kind = "identifier";
                                    value = "description";
                                  }
                                ];
                                type = "assignment";
                                value = {
                                  multiline = true;
                                  parts = [
                                    {
                                      type = "text";
                                      value = "Suppress gaps for single windows";
                                    }
                                  ];
                                  type = "string";
                                };
                              }
                            ];
                            type = "attr-set";
                          };
                        }
                      ];
                      type = "attr-set";
                    };
                  }
                ];
                type = "attr-set";
              };
            }
            {
              operator = "=";
              target = [
                {
                  kind = "identifier";
                  value = "decorations";
                }
              ];
              type = "assignment";
              value = {
                recursive = false;
                statements = [
                  {
                    operator = "=";
                    target = [
                      {
                        kind = "identifier";
                        value = "tabs";
                      }
                    ];
                    type = "assignment";
                    value = {
                      recursive = false;
                      statements = [
                        {
                          operator = "=";
                          target = [
                            {
                              kind = "identifier";
                              value = "_meta";
                            }
                          ];
                          type = "assignment";
                          value = {
                            recursive = false;
                            statements = [
                              {
                                operator = "=";
                                target = [
                                  {
                                    kind = "identifier";
                                    value = "type";
                                  }
                                ];
                                type = "assignment";
                                value = {
                                  name = "type";
                                  path = [
                                    {
                                      kind = "identifier";
                                      value = "bool";
                                    }
                                  ];
                                  type = "variable";
                                };
                              }
                              {
                                operator = "=";
                                target = [
                                  {
                                    kind = "identifier";
                                    value = "default";
                                  }
                                ];
                                type = "assignment";
                                value = {
                                  kind = "true";
                                  type = "literal";
                                  value = true;
                                };
                              }
                              {
                                operator = "=";
                                target = [
                                  {
                                    kind = "identifier";
                                    value = "description";
                                  }
                                ];
                                type = "assignment";
                                value = {
                                  multiline = true;
                                  parts = [
                                    {
                                      type = "text";
                                      value = "Display tab decorations for stacked windows";
                                    }
                                  ];
                                  type = "string";
                                };
                              }
                            ];
                            type = "attr-set";
                          };
                        }
                      ];
                      type = "attr-set";
                    };
                  }
                  {
                    operator = "=";
                    target = [
                      {
                        kind = "identifier";
                        value = "preview-hint";
                      }
                    ];
                    type = "assignment";
                    value = {
                      recursive = false;
                      statements = [
                        {
                          operator = "=";
                          target = [
                            {
                              kind = "identifier";
                              value = "_meta";
                            }
                          ];
                          type = "assignment";
                          value = {
                            recursive = false;
                            statements = [
                              {
                                operator = "=";
                                target = [
                                  {
                                    kind = "identifier";
                                    value = "type";
                                  }
                                ];
                                type = "assignment";
                                value = {
                                  name = "type";
                                  path = [
                                    {
                                      kind = "identifier";
                                      value = "bool";
                                    }
                                  ];
                                  type = "variable";
                                };
                              }
                              {
                                operator = "=";
                                target = [
                                  {
                                    kind = "identifier";
                                    value = "default";
                                  }
                                ];
                                type = "assignment";
                                value = {
                                  kind = "true";
                                  type = "literal";
                                  value = true;
                                };
                              }
                              {
                                operator = "=";
                                target = [
                                  {
                                    kind = "identifier";
                                    value = "description";
                                  }
                                ];
                                type = "assignment";
                                value = {
                                  multiline = true;
                                  parts = [
                                    {
                                      type = "text";
                                      value = "Display preview area during drag-and-drop";
                                    }
                                  ];
                                  type = "string";
                                };
                              }
                            ];
                            type = "attr-set";
                          };
                        }
                      ];
                      type = "attr-set";
                    };
                  }
                ];
                type = "attr-set";
              };
            }
          ];
          type = "attr-set";
        };
      }
      {
        operator = "=";
        target = [
          {
            kind = "identifier";
            value = "tiling";
          }
        ];
        type = "assignment";
        value = {
          recursive = false;
          statements = [
            {
              operator = "=";
              target = [
                {
                  kind = "identifier";
                  value = "enable";
                }
              ];
              type = "assignment";
              value = {
                recursive = false;
                statements = [
                  {
                    operator = "=";
                    target = [
                      {
                        kind = "identifier";
                        value = "_meta";
                      }
                    ];
                    type = "assignment";
                    value = {
                      recursive = false;
                      statements = [
                        {
                          operator = "=";
                          target = [
                            {
                              kind = "identifier";
                              value = "type";
                            }
                          ];
                          type = "assignment";
                          value = {
                            name = "type";
                            path = [
                              {
                                kind = "identifier";
                                value = "bool";
                              }
                            ];
                            type = "variable";
                          };
                        }
                        {
                          operator = "=";
                          target = [
                            {
                              kind = "identifier";
                              value = "default";
                            }
                          ];
                          type = "assignment";
                          value = {
                            kind = "true";
                            type = "literal";
                            value = true;
                          };
                        }
                        {
                          operator = "=";
                          target = [
                            {
                              kind = "identifier";
                              value = "description";
                            }
                          ];
                          type = "assignment";
                          value = {
                            multiline = true;
                            parts = [
                              {
                                type = "text";
                                value = "Global tiling mode master switch";
                              }
                            ];
                            type = "string";
                          };
                        }
                      ];
                      type = "attr-set";
                    };
                  }
                ];
                type = "attr-set";
              };
            }
            {
              operator = "=";
              target = [
                {
                  kind = "identifier";
                  value = "primary-mode";
                }
              ];
              type = "assignment";
              value = {
                recursive = false;
                statements = [
                  {
                    operator = "=";
                    target = [
                      {
                        kind = "identifier";
                        value = "_meta";
                      }
                    ];
                    type = "assignment";
                    value = {
                      recursive = false;
                      statements = [
                        {
                          operator = "=";
                          target = [
                            {
                              kind = "identifier";
                              value = "type";
                            }
                          ];
                          type = "assignment";
                          value = {
                            arguments = [
                              {
                                items = [
                                  {
                                    multiline = false;
                                    parts = [
                                      {
                                        type = "text";
                                        value = "tiling";
                                      }
                                    ];
                                    type = "string";
                                  }
                                  {
                                    multiline = false;
                                    parts = [
                                      {
                                        type = "text";
                                        value = "stacking";
                                      }
                                    ];
                                    type = "string";
                                  }
                                ];
                                type = "list";
                              }
                            ];
                            callee = {
                              name = "type";
                              path = [
                                {
                                  kind = "identifier";
                                  value = "enum";
                                }
                              ];
                              type = "variable";
                            };
                            type = "call";
                          };
                        }
                        {
                          operator = "=";
                          target = [
                            {
                              kind = "identifier";
                              value = "default";
                            }
                          ];
                          type = "assignment";
                          value = {
                            multiline = false;
                            parts = [
                              {
                                type = "text";
                                value = "tiling";
                              }
                            ];
                            type = "string";
                          };
                        }
                        {
                          operator = "=";
                          target = [
                            {
                              kind = "identifier";
                              value = "description";
                            }
                          ];
                          type = "assignment";
                          value = {
                            multiline = true;
                            parts = [
                              {
                                type = "text";
                                value = "Default layout strategy for new windows";
                              }
                            ];
                            type = "string";
                          };
                        }
                      ];
                      type = "attr-set";
                    };
                  }
                ];
                type = "attr-set";
              };
            }
            {
              operator = "=";
              target = [
                {
                  kind = "identifier";
                  value = "stacked";
                }
              ];
              type = "assignment";
              value = {
                recursive = false;
                statements = [
                  {
                    operator = "=";
                    target = [
                      {
                        kind = "identifier";
                        value = "_meta";
                      }
                    ];
                    type = "assignment";
                    value = {
                      recursive = false;
                      statements = [
                        {
                          operator = "=";
                          target = [
                            {
                              kind = "identifier";
                              value = "type";
                            }
                          ];
                          type = "assignment";
                          value = {
                            name = "type";
                            path = [
                              {
                                kind = "identifier";
                                value = "bool";
                              }
                            ];
                            type = "variable";
                          };
                        }
                        {
                          operator = "=";
                          target = [
                            {
                              kind = "identifier";
                              value = "default";
                            }
                          ];
                          type = "assignment";
                          value = {
                            kind = "true";
                            type = "literal";
                            value = true;
                          };
                        }
                        {
                          operator = "=";
                          target = [
                            {
                              kind = "identifier";
                              value = "description";
                            }
                          ];
                          type = "assignment";
                          value = {
                            multiline = true;
                            parts = [
                              {
                                type = "text";
                                value = "Enable stacked layout capabilities";
                              }
                            ];
                            type = "string";
                          };
                        }
                      ];
                      type = "attr-set";
                    };
                  }
                ];
                type = "attr-set";
              };
            }
            {
              operator = "=";
              target = [
                {
                  kind = "identifier";
                  value = "tabbed";
                }
              ];
              type = "assignment";
              value = {
                recursive = false;
                statements = [
                  {
                    operator = "=";
                    target = [
                      {
                        kind = "identifier";
                        value = "enable";
                      }
                    ];
                    type = "assignment";
                    value = {
                      recursive = false;
                      statements = [
                        {
                          operator = "=";
                          target = [
                            {
                              kind = "identifier";
                              value = "_meta";
                            }
                          ];
                          type = "assignment";
                          value = {
                            recursive = false;
                            statements = [
                              {
                                operator = "=";
                                target = [
                                  {
                                    kind = "identifier";
                                    value = "type";
                                  }
                                ];
                                type = "assignment";
                                value = {
                                  name = "type";
                                  path = [
                                    {
                                      kind = "identifier";
                                      value = "bool";
                                    }
                                  ];
                                  type = "variable";
                                };
                              }
                              {
                                operator = "=";
                                target = [
                                  {
                                    kind = "identifier";
                                    value = "default";
                                  }
                                ];
                                type = "assignment";
                                value = {
                                  kind = "true";
                                  type = "literal";
                                  value = true;
                                };
                              }
                              {
                                operator = "=";
                                target = [
                                  {
                                    kind = "identifier";
                                    value = "description";
                                  }
                                ];
                                type = "assignment";
                                value = {
                                  multiline = true;
                                  parts = [
                                    {
                                      type = "text";
                                      value = "Enable tabbed layout capabilities";
                                    }
                                  ];
                                  type = "string";
                                };
                              }
                            ];
                            type = "attr-set";
                          };
                        }
                      ];
                      type = "attr-set";
                    };
                  }
                  {
                    operator = "=";
                    target = [
                      {
                        kind = "identifier";
                        value = "auto-exit";
                      }
                    ];
                    type = "assignment";
                    value = {
                      recursive = false;
                      statements = [
                        {
                          operator = "=";
                          target = [
                            {
                              kind = "identifier";
                              value = "_meta";
                            }
                          ];
                          type = "assignment";
                          value = {
                            recursive = false;
                            statements = [
                              {
                                operator = "=";
                                target = [
                                  {
                                    kind = "identifier";
                                    value = "type";
                                  }
                                ];
                                type = "assignment";
                                value = {
                                  name = "type";
                                  path = [
                                    {
                                      kind = "identifier";
                                      value = "bool";
                                    }
                                  ];
                                  type = "variable";
                                };
                              }
                              {
                                operator = "=";
                                target = [
                                  {
                                    kind = "identifier";
                                    value = "default";
                                  }
                                ];
                                type = "assignment";
                                value = {
                                  kind = "true";
                                  type = "literal";
                                  value = true;
                                };
                              }
                              {
                                operator = "=";
                                target = [
                                  {
                                    kind = "identifier";
                                    value = "description";
                                  }
                                ];
                                type = "assignment";
                                value = {
                                  multiline = true;
                                  parts = [
                                    {
                                      type = "text";
                                      value = "Automatically exit tabbed mode for single windows";
                                    }
                                  ];
                                  type = "string";
                                };
                              }
                            ];
                            type = "attr-set";
                          };
                        }
                      ];
                      type = "attr-set";
                    };
                  }
                ];
                type = "attr-set";
              };
            }
            {
              operator = "=";
              target = [
                {
                  kind = "identifier";
                  value = "auto-split";
                }
              ];
              type = "assignment";
              value = {
                recursive = false;
                statements = [
                  {
                    operator = "=";
                    target = [
                      {
                        kind = "identifier";
                        value = "_meta";
                      }
                    ];
                    type = "assignment";
                    value = {
                      recursive = false;
                      statements = [
                        {
                          operator = "=";
                          target = [
                            {
                              kind = "identifier";
                              value = "type";
                            }
                          ];
                          type = "assignment";
                          value = {
                            name = "type";
                            path = [
                              {
                                kind = "identifier";
                                value = "bool";
                              }
                            ];
                            type = "variable";
                          };
                        }
                        {
                          operator = "=";
                          target = [
                            {
                              kind = "identifier";
                              value = "default";
                            }
                          ];
                          type = "assignment";
                          value = {
                            kind = "true";
                            type = "literal";
                            value = true;
                          };
                        }
                        {
                          operator = "=";
                          target = [
                            {
                              kind = "identifier";
                              value = "description";
                            }
                          ];
                          type = "assignment";
                          value = {
                            multiline = true;
                            parts = [
                              {
                                type = "text";
                                value = "Automatically select split axis based on window dimensions";
                              }
                            ];
                            type = "string";
                          };
                        }
                      ];
                      type = "attr-set";
                    };
                  }
                ];
                type = "attr-set";
              };
            }
            {
              operator = "=";
              target = [
                {
                  kind = "identifier";
                  value = "workspace-skip";
                }
              ];
              type = "assignment";
              value = {
                recursive = false;
                statements = [
                  {
                    operator = "=";
                    target = [
                      {
                        kind = "identifier";
                        value = "_meta";
                      }
                    ];
                    type = "assignment";
                    value = {
                      recursive = false;
                      statements = [
                        {
                          operator = "=";
                          target = [
                            {
                              kind = "identifier";
                              value = "type";
                            }
                          ];
                          type = "assignment";
                          value = {
                            name = "type";
                            path = [
                              {
                                kind = "identifier";
                                value = "string";
                              }
                            ];
                            type = "variable";
                          };
                        }
                        {
                          operator = "=";
                          target = [
                            {
                              kind = "identifier";
                              value = "default";
                            }
                          ];
                          type = "assignment";
                          value = {
                            multiline = false;
                            parts = [ ];
                            type = "string";
                          };
                        }
                        {
                          operator = "=";
                          target = [
                            {
                              kind = "identifier";
                              value = "description";
                            }
                          ];
                          type = "assignment";
                          value = {
                            multiline = true;
                            parts = [
                              {
                                type = "text";
                                value = "Indices of workspaces to exclude from tiling";
                              }
                            ];
                            type = "string";
                          };
                        }
                      ];
                      type = "attr-set";
                    };
                  }
                ];
                type = "attr-set";
              };
            }
          ];
          type = "attr-set";
        };
      }
      {
        operator = "=";
        target = [
          {
            kind = "identifier";
            value = "interaction";
          }
        ];
        type = "assignment";
        value = {
          recursive = false;
          statements = [
            {
              operator = "=";
              target = [
                {
                  kind = "identifier";
                  value = "mouse";
                }
              ];
              type = "assignment";
              value = {
                recursive = false;
                statements = [
                  {
                    operator = "=";
                    target = [
                      {
                        kind = "identifier";
                        value = "move-pointer-focus";
                      }
                    ];
                    type = "assignment";
                    value = {
                      recursive = false;
                      statements = [
                        {
                          operator = "=";
                          target = [
                            {
                              kind = "identifier";
                              value = "_meta";
                            }
                          ];
                          type = "assignment";
                          value = {
                            recursive = false;
                            statements = [
                              {
                                operator = "=";
                                target = [
                                  {
                                    kind = "identifier";
                                    value = "type";
                                  }
                                ];
                                type = "assignment";
                                value = {
                                  name = "type";
                                  path = [
                                    {
                                      kind = "identifier";
                                      value = "bool";
                                    }
                                  ];
                                  type = "variable";
                                };
                              }
                              {
                                operator = "=";
                                target = [
                                  {
                                    kind = "identifier";
                                    value = "default";
                                  }
                                ];
                                type = "assignment";
                                value = {
                                  kind = "false";
                                  type = "literal";
                                  value = false;
                                };
                              }
                              {
                                operator = "=";
                                target = [
                                  {
                                    kind = "identifier";
                                    value = "description";
                                  }
                                ];
                                type = "assignment";
                                value = {
                                  multiline = true;
                                  parts = [
                                    {
                                      type = "text";
                                      value = "Sync pointer location with keyboard focus changes";
                                    }
                                  ];
                                  type = "string";
                                };
                              }
                            ];
                            type = "attr-set";
                          };
                        }
                      ];
                      type = "attr-set";
                    };
                  }
                  {
                    operator = "=";
                    target = [
                      {
                        kind = "identifier";
                        value = "focus-on-hover";
                      }
                    ];
                    type = "assignment";
                    value = {
                      recursive = false;
                      statements = [
                        {
                          operator = "=";
                          target = [
                            {
                              kind = "identifier";
                              value = "_meta";
                            }
                          ];
                          type = "assignment";
                          value = {
                            recursive = false;
                            statements = [
                              {
                                operator = "=";
                                target = [
                                  {
                                    kind = "identifier";
                                    value = "type";
                                  }
                                ];
                                type = "assignment";
                                value = {
                                  name = "type";
                                  path = [
                                    {
                                      kind = "identifier";
                                      value = "bool";
                                    }
                                  ];
                                  type = "variable";
                                };
                              }
                              {
                                operator = "=";
                                target = [
                                  {
                                    kind = "identifier";
                                    value = "default";
                                  }
                                ];
                                type = "assignment";
                                value = {
                                  kind = "false";
                                  type = "literal";
                                  value = false;
                                };
                              }
                              {
                                operator = "=";
                                target = [
                                  {
                                    kind = "identifier";
                                    value = "description";
                                  }
                                ];
                                type = "assignment";
                                value = {
                                  multiline = true;
                                  parts = [
                                    {
                                      type = "text";
                                      value = "Follow-mouse focus policy";
                                    }
                                  ];
                                  type = "string";
                                };
                              }
                            ];
                            type = "attr-set";
                          };
                        }
                      ];
                      type = "attr-set";
                    };
                  }
                ];
                type = "attr-set";
              };
            }
            {
              operator = "=";
              target = [
                {
                  kind = "identifier";
                  value = "dnd-center-layout";
                }
              ];
              type = "assignment";
              value = {
                recursive = false;
                statements = [
                  {
                    operator = "=";
                    target = [
                      {
                        kind = "identifier";
                        value = "_meta";
                      }
                    ];
                    type = "assignment";
                    value = {
                      recursive = false;
                      statements = [
                        {
                          operator = "=";
                          target = [
                            {
                              kind = "identifier";
                              value = "type";
                            }
                          ];
                          type = "assignment";
                          value = {
                            arguments = [
                              {
                                items = [
                                  {
                                    multiline = false;
                                    parts = [
                                      {
                                        type = "text";
                                        value = "tabbed";
                                      }
                                    ];
                                    type = "string";
                                  }
                                  {
                                    multiline = false;
                                    parts = [
                                      {
                                        type = "text";
                                        value = "stacked";
                                      }
                                    ];
                                    type = "string";
                                  }
                                  {
                                    multiline = false;
                                    parts = [
                                      {
                                        type = "text";
                                        value = "swap";
                                      }
                                    ];
                                    type = "string";
                                  }
                                ];
                                type = "list";
                              }
                            ];
                            callee = {
                              name = "type";
                              path = [
                                {
                                  kind = "identifier";
                                  value = "enum";
                                }
                              ];
                              type = "variable";
                            };
                            type = "call";
                          };
                        }
                        {
                          operator = "=";
                          target = [
                            {
                              kind = "identifier";
                              value = "default";
                            }
                          ];
                          type = "assignment";
                          value = {
                            multiline = false;
                            parts = [
                              {
                                type = "text";
                                value = "tabbed";
                              }
                            ];
                            type = "string";
                          };
                        }
                        {
                          operator = "=";
                          target = [
                            {
                              kind = "identifier";
                              value = "description";
                            }
                          ];
                          type = "assignment";
                          value = {
                            multiline = true;
                            parts = [
                              {
                                type = "text";
                                value = "Layout used for drops into window center";
                              }
                            ];
                            type = "string";
                          };
                        }
                      ];
                      type = "attr-set";
                    };
                  }
                ];
                type = "attr-set";
              };
            }
            {
              operator = "=";
              target = [
                {
                  kind = "identifier";
                  value = "float-always-on-top";
                }
              ];
              type = "assignment";
              value = {
                recursive = false;
                statements = [
                  {
                    operator = "=";
                    target = [
                      {
                        kind = "identifier";
                        value = "_meta";
                      }
                    ];
                    type = "assignment";
                    value = {
                      recursive = false;
                      statements = [
                        {
                          operator = "=";
                          target = [
                            {
                              kind = "identifier";
                              value = "type";
                            }
                          ];
                          type = "assignment";
                          value = {
                            name = "type";
                            path = [
                              {
                                kind = "identifier";
                                value = "bool";
                              }
                            ];
                            type = "variable";
                          };
                        }
                        {
                          operator = "=";
                          target = [
                            {
                              kind = "identifier";
                              value = "default";
                            }
                          ];
                          type = "assignment";
                          value = {
                            kind = "true";
                            type = "literal";
                            value = true;
                          };
                        }
                        {
                          operator = "=";
                          target = [
                            {
                              kind = "identifier";
                              value = "description";
                            }
                          ];
                          type = "assignment";
                          value = {
                            multiline = true;
                            parts = [
                              {
                                type = "text";
                                value = "Keep floating windows above tiled ones";
                              }
                            ];
                            type = "string";
                          };
                        }
                      ];
                      type = "attr-set";
                    };
                  }
                ];
                type = "attr-set";
              };
            }
            {
              operator = "=";
              target = [
                {
                  kind = "identifier";
                  value = "resize-amount";
                }
              ];
              type = "assignment";
              value = {
                recursive = false;
                statements = [
                  {
                    operator = "=";
                    target = [
                      {
                        kind = "identifier";
                        value = "_meta";
                      }
                    ];
                    type = "assignment";
                    value = {
                      recursive = false;
                      statements = [
                        {
                          operator = "=";
                          target = [
                            {
                              kind = "identifier";
                              value = "type";
                            }
                          ];
                          type = "assignment";
                          value = {
                            name = "type";
                            path = [
                              {
                                kind = "identifier";
                                value = "int";
                              }
                            ];
                            type = "variable";
                          };
                        }
                        {
                          operator = "=";
                          target = [
                            {
                              kind = "identifier";
                              value = "default";
                            }
                          ];
                          type = "assignment";
                          value = {
                            kind = "integer";
                            type = "literal";
                            value = 15;
                          };
                        }
                        {
                          operator = "=";
                          target = [
                            {
                              kind = "identifier";
                              value = "description";
                            }
                          ];
                          type = "assignment";
                          value = {
                            multiline = true;
                            parts = [
                              {
                                type = "text";
                                value = "Pixel increment for window resizing operations";
                              }
                            ];
                            type = "string";
                          };
                        }
                      ];
                      type = "attr-set";
                    };
                  }
                ];
                type = "attr-set";
              };
            }
          ];
          type = "attr-set";
        };
      }
      {
        operator = "=";
        target = [
          {
            kind = "identifier";
            value = "general";
          }
        ];
        type = "assignment";
        value = {
          recursive = false;
          statements = [
            {
              operator = "=";
              target = [
                {
                  kind = "identifier";
                  value = "quick-settings";
                }
              ];
              type = "assignment";
              value = {
                recursive = false;
                statements = [
                  {
                    operator = "=";
                    target = [
                      {
                        kind = "identifier";
                        value = "_meta";
                      }
                    ];
                    type = "assignment";
                    value = {
                      recursive = false;
                      statements = [
                        {
                          operator = "=";
                          target = [
                            {
                              kind = "identifier";
                              value = "type";
                            }
                          ];
                          type = "assignment";
                          value = {
                            name = "type";
                            path = [
                              {
                                kind = "identifier";
                                value = "bool";
                              }
                            ];
                            type = "variable";
                          };
                        }
                        {
                          operator = "=";
                          target = [
                            {
                              kind = "identifier";
                              value = "default";
                            }
                          ];
                          type = "assignment";
                          value = {
                            kind = "true";
                            type = "literal";
                            value = true;
                          };
                        }
                        {
                          operator = "=";
                          target = [
                            {
                              kind = "identifier";
                              value = "description";
                            }
                          ];
                          type = "assignment";
                          value = {
                            multiline = true;
                            parts = [
                              {
                                type = "text";
                                value = "Add Forge toggle to system quick settings";
                              }
                            ];
                            type = "string";
                          };
                        }
                      ];
                      type = "attr-set";
                    };
                  }
                ];
                type = "attr-set";
              };
            }
            {
              operator = "=";
              target = [
                {
                  kind = "identifier";
                  value = "logging";
                }
              ];
              type = "assignment";
              value = {
                recursive = false;
                statements = [
                  {
                    operator = "=";
                    target = [
                      {
                        kind = "identifier";
                        value = "enable";
                      }
                    ];
                    type = "assignment";
                    value = {
                      recursive = false;
                      statements = [
                        {
                          operator = "=";
                          target = [
                            {
                              kind = "identifier";
                              value = "_meta";
                            }
                          ];
                          type = "assignment";
                          value = {
                            recursive = false;
                            statements = [
                              {
                                operator = "=";
                                target = [
                                  {
                                    kind = "identifier";
                                    value = "type";
                                  }
                                ];
                                type = "assignment";
                                value = {
                                  name = "type";
                                  path = [
                                    {
                                      kind = "identifier";
                                      value = "bool";
                                    }
                                  ];
                                  type = "variable";
                                };
                              }
                              {
                                operator = "=";
                                target = [
                                  {
                                    kind = "identifier";
                                    value = "default";
                                  }
                                ];
                                type = "assignment";
                                value = {
                                  kind = "false";
                                  type = "literal";
                                  value = false;
                                };
                              }
                              {
                                operator = "=";
                                target = [
                                  {
                                    kind = "identifier";
                                    value = "description";
                                  }
                                ];
                                type = "assignment";
                                value = {
                                  multiline = true;
                                  parts = [
                                    {
                                      type = "text";
                                      value = "Enable extension event logging";
                                    }
                                  ];
                                  type = "string";
                                };
                              }
                            ];
                            type = "attr-set";
                          };
                        }
                      ];
                      type = "attr-set";
                    };
                  }
                  {
                    operator = "=";
                    target = [
                      {
                        kind = "identifier";
                        value = "level";
                      }
                    ];
                    type = "assignment";
                    value = {
                      recursive = false;
                      statements = [
                        {
                          operator = "=";
                          target = [
                            {
                              kind = "identifier";
                              value = "_meta";
                            }
                          ];
                          type = "assignment";
                          value = {
                            recursive = false;
                            statements = [
                              {
                                operator = "=";
                                target = [
                                  {
                                    kind = "identifier";
                                    value = "type";
                                  }
                                ];
                                type = "assignment";
                                value = {
                                  name = "type";
                                  path = [
                                    {
                                      kind = "identifier";
                                      value = "int";
                                    }
                                  ];
                                  type = "variable";
                                };
                              }
                              {
                                operator = "=";
                                target = [
                                  {
                                    kind = "identifier";
                                    value = "default";
                                  }
                                ];
                                type = "assignment";
                                value = {
                                  kind = "integer";
                                  type = "literal";
                                  value = 0;
                                };
                              }
                              {
                                operator = "=";
                                target = [
                                  {
                                    kind = "identifier";
                                    value = "description";
                                  }
                                ];
                                type = "assignment";
                                value = {
                                  multiline = true;
                                  parts = [
                                    {
                                      type = "text";
                                      value = "Verbosity level for extension logs";
                                    }
                                  ];
                                  type = "string";
                                };
                              }
                            ];
                            type = "attr-set";
                          };
                        }
                      ];
                      type = "attr-set";
                    };
                  }
                ];
                type = "attr-set";
              };
            }
            {
              operator = "=";
              target = [
                {
                  kind = "identifier";
                  value = "css";
                }
              ];
              type = "assignment";
              value = {
                recursive = false;
                statements = [
                  {
                    operator = "=";
                    target = [
                      {
                        kind = "identifier";
                        value = "updated";
                      }
                    ];
                    type = "assignment";
                    value = {
                      recursive = false;
                      statements = [
                        {
                          operator = "=";
                          target = [
                            {
                              kind = "identifier";
                              value = "_meta";
                            }
                          ];
                          type = "assignment";
                          value = {
                            recursive = false;
                            statements = [
                              {
                                operator = "=";
                                target = [
                                  {
                                    kind = "identifier";
                                    value = "type";
                                  }
                                ];
                                type = "assignment";
                                value = {
                                  name = "type";
                                  path = [
                                    {
                                      kind = "identifier";
                                      value = "string";
                                    }
                                  ];
                                  type = "variable";
                                };
                              }
                              {
                                operator = "=";
                                target = [
                                  {
                                    kind = "identifier";
                                    value = "default";
                                  }
                                ];
                                type = "assignment";
                                value = {
                                  multiline = false;
                                  parts = [ ];
                                  type = "string";
                                };
                              }
                              {
                                operator = "=";
                                target = [
                                  {
                                    kind = "identifier";
                                    value = "description";
                                  }
                                ];
                                type = "assignment";
                                value = {
                                  multiline = true;
                                  parts = [
                                    {
                                      type = "text";
                                      value = "Timestamp of the last CSS injection";
                                    }
                                  ];
                                  type = "string";
                                };
                              }
                            ];
                            type = "attr-set";
                          };
                        }
                      ];
                      type = "attr-set";
                    };
                  }
                  {
                    operator = "=";
                    target = [
                      {
                        kind = "identifier";
                        value = "last-update";
                      }
                    ];
                    type = "assignment";
                    value = {
                      recursive = false;
                      statements = [
                        {
                          operator = "=";
                          target = [
                            {
                              kind = "identifier";
                              value = "_meta";
                            }
                          ];
                          type = "assignment";
                          value = {
                            recursive = false;
                            statements = [
                              {
                                operator = "=";
                                target = [
                                  {
                                    kind = "identifier";
                                    value = "type";
                                  }
                                ];
                                type = "assignment";
                                value = {
                                  name = "type";
                                  path = [
                                    {
                                      kind = "identifier";
                                      value = "int";
                                    }
                                  ];
                                  type = "variable";
                                };
                              }
                              {
                                operator = "=";
                                target = [
                                  {
                                    kind = "identifier";
                                    value = "default";
                                  }
                                ];
                                type = "assignment";
                                value = {
                                  kind = "integer";
                                  type = "literal";
                                  value = 1;
                                };
                              }
                              {
                                operator = "=";
                                target = [
                                  {
                                    kind = "identifier";
                                    value = "description";
                                  }
                                ];
                                type = "assignment";
                                value = {
                                  multiline = true;
                                  parts = [
                                    {
                                      type = "text";
                                      value = "Internal CSS schema version";
                                    }
                                  ];
                                  type = "string";
                                };
                              }
                            ];
                            type = "attr-set";
                          };
                        }
                      ];
                      type = "attr-set";
                    };
                  }
                ];
                type = "attr-set";
              };
            }
          ];
          type = "attr-set";
        };
      }
      {
        operator = "=";
        target = [
          {
            kind = "identifier";
            value = "keybindings";
          }
        ];
        type = "assignment";
        value = {
          recursive = false;
          statements = [
            {
              operator = "=";
              target = [
                {
                  kind = "identifier";
                  value = "focus-border-toggle";
                }
              ];
              type = "assignment";
              value = {
                recursive = false;
                statements = [
                  {
                    operator = "=";
                    target = [
                      {
                        kind = "identifier";
                        value = "_meta";
                      }
                    ];
                    type = "assignment";
                    value = {
                      recursive = false;
                      statements = [
                        {
                          operator = "=";
                          target = [
                            {
                              kind = "identifier";
                              value = "type";
                            }
                          ];
                          type = "assignment";
                          value = {
                            arguments = [
                              {
                                items = [
                                  {
                                    name = "type";
                                    path = [
                                      {
                                        kind = "identifier";
                                        value = "string";
                                      }
                                    ];
                                    type = "variable";
                                  }
                                ];
                                type = "list";
                              }
                            ];
                            callee = {
                              name = "type";
                              path = [
                                {
                                  kind = "identifier";
                                  value = "list";
                                }
                              ];
                              type = "variable";
                            };
                            type = "call";
                          };
                        }
                        {
                          operator = "=";
                          target = [
                            {
                              kind = "identifier";
                              value = "default";
                            }
                          ];
                          type = "assignment";
                          value = {
                            items = [
                              {
                                multiline = false;
                                parts = [
                                  {
                                    type = "text";
                                    value = "super";
                                  }
                                ];
                                type = "string";
                              }
                              {
                                multiline = false;
                                parts = [
                                  {
                                    type = "text";
                                    value = "x";
                                  }
                                ];
                                type = "string";
                              }
                            ];
                            type = "list";
                          };
                        }
                        {
                          operator = "=";
                          target = [
                            {
                              kind = "identifier";
                              value = "description";
                            }
                          ];
                          type = "assignment";
                          value = {
                            multiline = true;
                            parts = [
                              {
                                type = "text";
                                value = "Shortcut to toggle focused window border\n\nDefine as a list of keys, e.g., [ \"super\" \"q\" ].\nSupported modifiers: super, ctrl, alt, shift.";
                              }
                            ];
                            type = "string";
                          };
                        }
                      ];
                      type = "attr-set";
                    };
                  }
                ];
                type = "attr-set";
              };
            }
            {
              operator = "=";
              target = [
                {
                  kind = "identifier";
                  value = "window-gap-size-increase";
                }
              ];
              type = "assignment";
              value = {
                recursive = false;
                statements = [
                  {
                    operator = "=";
                    target = [
                      {
                        kind = "identifier";
                        value = "_meta";
                      }
                    ];
                    type = "assignment";
                    value = {
                      recursive = false;
                      statements = [
                        {
                          operator = "=";
                          target = [
                            {
                              kind = "identifier";
                              value = "type";
                            }
                          ];
                          type = "assignment";
                          value = {
                            arguments = [
                              {
                                items = [
                                  {
                                    name = "type";
                                    path = [
                                      {
                                        kind = "identifier";
                                        value = "string";
                                      }
                                    ];
                                    type = "variable";
                                  }
                                ];
                                type = "list";
                              }
                            ];
                            callee = {
                              name = "type";
                              path = [
                                {
                                  kind = "identifier";
                                  value = "list";
                                }
                              ];
                              type = "variable";
                            };
                            type = "call";
                          };
                        }
                        {
                          operator = "=";
                          target = [
                            {
                              kind = "identifier";
                              value = "default";
                            }
                          ];
                          type = "assignment";
                          value = {
                            items = [
                              {
                                multiline = false;
                                parts = [
                                  {
                                    type = "text";
                                    value = "ctrl";
                                  }
                                ];
                                type = "string";
                              }
                              {
                                multiline = false;
                                parts = [
                                  {
                                    type = "text";
                                    value = "super";
                                  }
                                ];
                                type = "string";
                              }
                              {
                                multiline = false;
                                parts = [
                                  {
                                    type = "text";
                                    value = "plus";
                                  }
                                ];
                                type = "string";
                              }
                            ];
                            type = "list";
                          };
                        }
                        {
                          operator = "=";
                          target = [
                            {
                              kind = "identifier";
                              value = "description";
                            }
                          ];
                          type = "assignment";
                          value = {
                            multiline = true;
                            parts = [
                              {
                                type = "text";
                                value = "Shortcut to increase window gaps\n\nDefine as a list of keys, e.g., [ \"super\" \"q\" ].\nSupported modifiers: super, ctrl, alt, shift.";
                              }
                            ];
                            type = "string";
                          };
                        }
                      ];
                      type = "attr-set";
                    };
                  }
                ];
                type = "attr-set";
              };
            }
            {
              operator = "=";
              target = [
                {
                  kind = "identifier";
                  value = "window-gap-size-decrease";
                }
              ];
              type = "assignment";
              value = {
                recursive = false;
                statements = [
                  {
                    operator = "=";
                    target = [
                      {
                        kind = "identifier";
                        value = "_meta";
                      }
                    ];
                    type = "assignment";
                    value = {
                      recursive = false;
                      statements = [
                        {
                          operator = "=";
                          target = [
                            {
                              kind = "identifier";
                              value = "type";
                            }
                          ];
                          type = "assignment";
                          value = {
                            arguments = [
                              {
                                items = [
                                  {
                                    name = "type";
                                    path = [
                                      {
                                        kind = "identifier";
                                        value = "string";
                                      }
                                    ];
                                    type = "variable";
                                  }
                                ];
                                type = "list";
                              }
                            ];
                            callee = {
                              name = "type";
                              path = [
                                {
                                  kind = "identifier";
                                  value = "list";
                                }
                              ];
                              type = "variable";
                            };
                            type = "call";
                          };
                        }
                        {
                          operator = "=";
                          target = [
                            {
                              kind = "identifier";
                              value = "default";
                            }
                          ];
                          type = "assignment";
                          value = {
                            items = [
                              {
                                multiline = false;
                                parts = [
                                  {
                                    type = "text";
                                    value = "ctrl";
                                  }
                                ];
                                type = "string";
                              }
                              {
                                multiline = false;
                                parts = [
                                  {
                                    type = "text";
                                    value = "super";
                                  }
                                ];
                                type = "string";
                              }
                              {
                                multiline = false;
                                parts = [
                                  {
                                    type = "text";
                                    value = "minus";
                                  }
                                ];
                                type = "string";
                              }
                            ];
                            type = "list";
                          };
                        }
                        {
                          operator = "=";
                          target = [
                            {
                              kind = "identifier";
                              value = "description";
                            }
                          ];
                          type = "assignment";
                          value = {
                            multiline = true;
                            parts = [
                              {
                                type = "text";
                                value = "Shortcut to decrease window gaps\n\nDefine as a list of keys, e.g., [ \"super\" \"q\" ].\nSupported modifiers: super, ctrl, alt, shift.";
                              }
                            ];
                            type = "string";
                          };
                        }
                      ];
                      type = "attr-set";
                    };
                  }
                ];
                type = "attr-set";
              };
            }
            {
              operator = "=";
              target = [
                {
                  kind = "identifier";
                  value = "con-split-layout-toggle";
                }
              ];
              type = "assignment";
              value = {
                recursive = false;
                statements = [
                  {
                    operator = "=";
                    target = [
                      {
                        kind = "identifier";
                        value = "_meta";
                      }
                    ];
                    type = "assignment";
                    value = {
                      recursive = false;
                      statements = [
                        {
                          operator = "=";
                          target = [
                            {
                              kind = "identifier";
                              value = "type";
                            }
                          ];
                          type = "assignment";
                          value = {
                            arguments = [
                              {
                                items = [
                                  {
                                    name = "type";
                                    path = [
                                      {
                                        kind = "identifier";
                                        value = "string";
                                      }
                                    ];
                                    type = "variable";
                                  }
                                ];
                                type = "list";
                              }
                            ];
                            callee = {
                              name = "type";
                              path = [
                                {
                                  kind = "identifier";
                                  value = "list";
                                }
                              ];
                              type = "variable";
                            };
                            type = "call";
                          };
                        }
                        {
                          operator = "=";
                          target = [
                            {
                              kind = "identifier";
                              value = "default";
                            }
                          ];
                          type = "assignment";
                          value = {
                            items = [
                              {
                                multiline = false;
                                parts = [
                                  {
                                    type = "text";
                                    value = "super";
                                  }
                                ];
                                type = "string";
                              }
                              {
                                multiline = false;
                                parts = [
                                  {
                                    type = "text";
                                    value = "g";
                                  }
                                ];
                                type = "string";
                              }
                            ];
                            type = "list";
                          };
                        }
                        {
                          operator = "=";
                          target = [
                            {
                              kind = "identifier";
                              value = "description";
                            }
                          ];
                          type = "assignment";
                          value = {
                            multiline = true;
                            parts = [
                              {
                                type = "text";
                                value = "Shortcut to toggle split orientation\n\nDefine as a list of keys, e.g., [ \"super\" \"q\" ].\nSupported modifiers: super, ctrl, alt, shift.";
                              }
                            ];
                            type = "string";
                          };
                        }
                      ];
                      type = "attr-set";
                    };
                  }
                ];
                type = "attr-set";
              };
            }
            {
              operator = "=";
              target = [
                {
                  kind = "identifier";
                  value = "con-split-horizontal";
                }
              ];
              type = "assignment";
              value = {
                recursive = false;
                statements = [
                  {
                    operator = "=";
                    target = [
                      {
                        kind = "identifier";
                        value = "_meta";
                      }
                    ];
                    type = "assignment";
                    value = {
                      recursive = false;
                      statements = [
                        {
                          operator = "=";
                          target = [
                            {
                              kind = "identifier";
                              value = "type";
                            }
                          ];
                          type = "assignment";
                          value = {
                            arguments = [
                              {
                                items = [
                                  {
                                    name = "type";
                                    path = [
                                      {
                                        kind = "identifier";
                                        value = "string";
                                      }
                                    ];
                                    type = "variable";
                                  }
                                ];
                                type = "list";
                              }
                            ];
                            callee = {
                              name = "type";
                              path = [
                                {
                                  kind = "identifier";
                                  value = "list";
                                }
                              ];
                              type = "variable";
                            };
                            type = "call";
                          };
                        }
                        {
                          operator = "=";
                          target = [
                            {
                              kind = "identifier";
                              value = "default";
                            }
                          ];
                          type = "assignment";
                          value = {
                            items = [
                              {
                                multiline = false;
                                parts = [
                                  {
                                    type = "text";
                                    value = "super";
                                  }
                                ];
                                type = "string";
                              }
                              {
                                multiline = false;
                                parts = [
                                  {
                                    type = "text";
                                    value = "z";
                                  }
                                ];
                                type = "string";
                              }
                            ];
                            type = "list";
                          };
                        }
                        {
                          operator = "=";
                          target = [
                            {
                              kind = "identifier";
                              value = "description";
                            }
                          ];
                          type = "assignment";
                          value = {
                            multiline = true;
                            parts = [
                              {
                                type = "text";
                                value = "Shortcut to force horizontal split\n\nDefine as a list of keys, e.g., [ \"super\" \"q\" ].\nSupported modifiers: super, ctrl, alt, shift.";
                              }
                            ];
                            type = "string";
                          };
                        }
                      ];
                      type = "attr-set";
                    };
                  }
                ];
                type = "attr-set";
              };
            }
            {
              operator = "=";
              target = [
                {
                  kind = "identifier";
                  value = "con-split-vertical";
                }
              ];
              type = "assignment";
              value = {
                recursive = false;
                statements = [
                  {
                    operator = "=";
                    target = [
                      {
                        kind = "identifier";
                        value = "_meta";
                      }
                    ];
                    type = "assignment";
                    value = {
                      recursive = false;
                      statements = [
                        {
                          operator = "=";
                          target = [
                            {
                              kind = "identifier";
                              value = "type";
                            }
                          ];
                          type = "assignment";
                          value = {
                            arguments = [
                              {
                                items = [
                                  {
                                    name = "type";
                                    path = [
                                      {
                                        kind = "identifier";
                                        value = "string";
                                      }
                                    ];
                                    type = "variable";
                                  }
                                ];
                                type = "list";
                              }
                            ];
                            callee = {
                              name = "type";
                              path = [
                                {
                                  kind = "identifier";
                                  value = "list";
                                }
                              ];
                              type = "variable";
                            };
                            type = "call";
                          };
                        }
                        {
                          operator = "=";
                          target = [
                            {
                              kind = "identifier";
                              value = "default";
                            }
                          ];
                          type = "assignment";
                          value = {
                            items = [
                              {
                                multiline = false;
                                parts = [
                                  {
                                    type = "text";
                                    value = "super";
                                  }
                                ];
                                type = "string";
                              }
                              {
                                multiline = false;
                                parts = [
                                  {
                                    type = "text";
                                    value = "v";
                                  }
                                ];
                                type = "string";
                              }
                            ];
                            type = "list";
                          };
                        }
                        {
                          operator = "=";
                          target = [
                            {
                              kind = "identifier";
                              value = "description";
                            }
                          ];
                          type = "assignment";
                          value = {
                            multiline = true;
                            parts = [
                              {
                                type = "text";
                                value = "Shortcut to force vertical split\n\nDefine as a list of keys, e.g., [ \"super\" \"q\" ].\nSupported modifiers: super, ctrl, alt, shift.";
                              }
                            ];
                            type = "string";
                          };
                        }
                      ];
                      type = "attr-set";
                    };
                  }
                ];
                type = "attr-set";
              };
            }
            {
              operator = "=";
              target = [
                {
                  kind = "identifier";
                  value = "con-stacked-layout-toggle";
                }
              ];
              type = "assignment";
              value = {
                recursive = false;
                statements = [
                  {
                    operator = "=";
                    target = [
                      {
                        kind = "identifier";
                        value = "_meta";
                      }
                    ];
                    type = "assignment";
                    value = {
                      recursive = false;
                      statements = [
                        {
                          operator = "=";
                          target = [
                            {
                              kind = "identifier";
                              value = "type";
                            }
                          ];
                          type = "assignment";
                          value = {
                            arguments = [
                              {
                                items = [
                                  {
                                    name = "type";
                                    path = [
                                      {
                                        kind = "identifier";
                                        value = "string";
                                      }
                                    ];
                                    type = "variable";
                                  }
                                ];
                                type = "list";
                              }
                            ];
                            callee = {
                              name = "type";
                              path = [
                                {
                                  kind = "identifier";
                                  value = "list";
                                }
                              ];
                              type = "variable";
                            };
                            type = "call";
                          };
                        }
                        {
                          operator = "=";
                          target = [
                            {
                              kind = "identifier";
                              value = "default";
                            }
                          ];
                          type = "assignment";
                          value = {
                            items = [
                              {
                                multiline = false;
                                parts = [
                                  {
                                    type = "text";
                                    value = "shift";
                                  }
                                ];
                                type = "string";
                              }
                              {
                                multiline = false;
                                parts = [
                                  {
                                    type = "text";
                                    value = "super";
                                  }
                                ];
                                type = "string";
                              }
                              {
                                multiline = false;
                                parts = [
                                  {
                                    type = "text";
                                    value = "s";
                                  }
                                ];
                                type = "string";
                              }
                            ];
                            type = "list";
                          };
                        }
                        {
                          operator = "=";
                          target = [
                            {
                              kind = "identifier";
                              value = "description";
                            }
                          ];
                          type = "assignment";
                          value = {
                            multiline = true;
                            parts = [
                              {
                                type = "text";
                                value = "Shortcut to toggle stacked layout\n\nDefine as a list of keys, e.g., [ \"super\" \"q\" ].\nSupported modifiers: super, ctrl, alt, shift.";
                              }
                            ];
                            type = "string";
                          };
                        }
                      ];
                      type = "attr-set";
                    };
                  }
                ];
                type = "attr-set";
              };
            }
            {
              operator = "=";
              target = [
                {
                  kind = "identifier";
                  value = "con-tabbed-layout-toggle";
                }
              ];
              type = "assignment";
              value = {
                recursive = false;
                statements = [
                  {
                    operator = "=";
                    target = [
                      {
                        kind = "identifier";
                        value = "_meta";
                      }
                    ];
                    type = "assignment";
                    value = {
                      recursive = false;
                      statements = [
                        {
                          operator = "=";
                          target = [
                            {
                              kind = "identifier";
                              value = "type";
                            }
                          ];
                          type = "assignment";
                          value = {
                            arguments = [
                              {
                                items = [
                                  {
                                    name = "type";
                                    path = [
                                      {
                                        kind = "identifier";
                                        value = "string";
                                      }
                                    ];
                                    type = "variable";
                                  }
                                ];
                                type = "list";
                              }
                            ];
                            callee = {
                              name = "type";
                              path = [
                                {
                                  kind = "identifier";
                                  value = "list";
                                }
                              ];
                              type = "variable";
                            };
                            type = "call";
                          };
                        }
                        {
                          operator = "=";
                          target = [
                            {
                              kind = "identifier";
                              value = "default";
                            }
                          ];
                          type = "assignment";
                          value = {
                            items = [
                              {
                                multiline = false;
                                parts = [
                                  {
                                    type = "text";
                                    value = "shift";
                                  }
                                ];
                                type = "string";
                              }
                              {
                                multiline = false;
                                parts = [
                                  {
                                    type = "text";
                                    value = "super";
                                  }
                                ];
                                type = "string";
                              }
                              {
                                multiline = false;
                                parts = [
                                  {
                                    type = "text";
                                    value = "t";
                                  }
                                ];
                                type = "string";
                              }
                            ];
                            type = "list";
                          };
                        }
                        {
                          operator = "=";
                          target = [
                            {
                              kind = "identifier";
                              value = "description";
                            }
                          ];
                          type = "assignment";
                          value = {
                            multiline = true;
                            parts = [
                              {
                                type = "text";
                                value = "Shortcut to toggle tabbed layout\n\nDefine as a list of keys, e.g., [ \"super\" \"q\" ].\nSupported modifiers: super, ctrl, alt, shift.";
                              }
                            ];
                            type = "string";
                          };
                        }
                      ];
                      type = "attr-set";
                    };
                  }
                ];
                type = "attr-set";
              };
            }
            {
              operator = "=";
              target = [
                {
                  kind = "identifier";
                  value = "con-tabbed-showtab-decoration-toggle";
                }
              ];
              type = "assignment";
              value = {
                recursive = false;
                statements = [
                  {
                    operator = "=";
                    target = [
                      {
                        kind = "identifier";
                        value = "_meta";
                      }
                    ];
                    type = "assignment";
                    value = {
                      recursive = false;
                      statements = [
                        {
                          operator = "=";
                          target = [
                            {
                              kind = "identifier";
                              value = "type";
                            }
                          ];
                          type = "assignment";
                          value = {
                            arguments = [
                              {
                                items = [
                                  {
                                    name = "type";
                                    path = [
                                      {
                                        kind = "identifier";
                                        value = "string";
                                      }
                                    ];
                                    type = "variable";
                                  }
                                ];
                                type = "list";
                              }
                            ];
                            callee = {
                              name = "type";
                              path = [
                                {
                                  kind = "identifier";
                                  value = "list";
                                }
                              ];
                              type = "variable";
                            };
                            type = "call";
                          };
                        }
                        {
                          operator = "=";
                          target = [
                            {
                              kind = "identifier";
                              value = "default";
                            }
                          ];
                          type = "assignment";
                          value = {
                            items = [
                              {
                                multiline = false;
                                parts = [
                                  {
                                    type = "text";
                                    value = "ctrl";
                                  }
                                ];
                                type = "string";
                              }
                              {
                                multiline = false;
                                parts = [
                                  {
                                    type = "text";
                                    value = "alt";
                                  }
                                ];
                                type = "string";
                              }
                              {
                                multiline = false;
                                parts = [
                                  {
                                    type = "text";
                                    value = "y";
                                  }
                                ];
                                type = "string";
                              }
                            ];
                            type = "list";
                          };
                        }
                        {
                          operator = "=";
                          target = [
                            {
                              kind = "identifier";
                              value = "description";
                            }
                          ];
                          type = "assignment";
                          value = {
                            multiline = true;
                            parts = [
                              {
                                type = "text";
                                value = "Shortcut to toggle tab decorations\n\nDefine as a list of keys, e.g., [ \"super\" \"q\" ].\nSupported modifiers: super, ctrl, alt, shift.";
                              }
                            ];
                            type = "string";
                          };
                        }
                      ];
                      type = "attr-set";
                    };
                  }
                ];
                type = "attr-set";
              };
            }
            {
              operator = "=";
              target = [
                {
                  kind = "identifier";
                  value = "window-swap-left";
                }
              ];
              type = "assignment";
              value = {
                recursive = false;
                statements = [
                  {
                    operator = "=";
                    target = [
                      {
                        kind = "identifier";
                        value = "_meta";
                      }
                    ];
                    type = "assignment";
                    value = {
                      recursive = false;
                      statements = [
                        {
                          operator = "=";
                          target = [
                            {
                              kind = "identifier";
                              value = "type";
                            }
                          ];
                          type = "assignment";
                          value = {
                            arguments = [
                              {
                                items = [
                                  {
                                    name = "type";
                                    path = [
                                      {
                                        kind = "identifier";
                                        value = "string";
                                      }
                                    ];
                                    type = "variable";
                                  }
                                ];
                                type = "list";
                              }
                            ];
                            callee = {
                              name = "type";
                              path = [
                                {
                                  kind = "identifier";
                                  value = "list";
                                }
                              ];
                              type = "variable";
                            };
                            type = "call";
                          };
                        }
                        {
                          operator = "=";
                          target = [
                            {
                              kind = "identifier";
                              value = "default";
                            }
                          ];
                          type = "assignment";
                          value = {
                            items = [
                              {
                                multiline = false;
                                parts = [
                                  {
                                    type = "text";
                                    value = "ctrl";
                                  }
                                ];
                                type = "string";
                              }
                              {
                                multiline = false;
                                parts = [
                                  {
                                    type = "text";
                                    value = "super";
                                  }
                                ];
                                type = "string";
                              }
                              {
                                multiline = false;
                                parts = [
                                  {
                                    type = "text";
                                    value = "h";
                                  }
                                ];
                                type = "string";
                              }
                            ];
                            type = "list";
                          };
                        }
                        {
                          operator = "=";
                          target = [
                            {
                              kind = "identifier";
                              value = "description";
                            }
                          ];
                          type = "assignment";
                          value = {
                            multiline = true;
                            parts = [
                              {
                                type = "text";
                                value = "Shortcut to swap window with left neighbor\n\nDefine as a list of keys, e.g., [ \"super\" \"q\" ].\nSupported modifiers: super, ctrl, alt, shift.";
                              }
                            ];
                            type = "string";
                          };
                        }
                      ];
                      type = "attr-set";
                    };
                  }
                ];
                type = "attr-set";
              };
            }
            {
              operator = "=";
              target = [
                {
                  kind = "identifier";
                  value = "window-swap-down";
                }
              ];
              type = "assignment";
              value = {
                recursive = false;
                statements = [
                  {
                    operator = "=";
                    target = [
                      {
                        kind = "identifier";
                        value = "_meta";
                      }
                    ];
                    type = "assignment";
                    value = {
                      recursive = false;
                      statements = [
                        {
                          operator = "=";
                          target = [
                            {
                              kind = "identifier";
                              value = "type";
                            }
                          ];
                          type = "assignment";
                          value = {
                            arguments = [
                              {
                                items = [
                                  {
                                    name = "type";
                                    path = [
                                      {
                                        kind = "identifier";
                                        value = "string";
                                      }
                                    ];
                                    type = "variable";
                                  }
                                ];
                                type = "list";
                              }
                            ];
                            callee = {
                              name = "type";
                              path = [
                                {
                                  kind = "identifier";
                                  value = "list";
                                }
                              ];
                              type = "variable";
                            };
                            type = "call";
                          };
                        }
                        {
                          operator = "=";
                          target = [
                            {
                              kind = "identifier";
                              value = "default";
                            }
                          ];
                          type = "assignment";
                          value = {
                            items = [
                              {
                                multiline = false;
                                parts = [
                                  {
                                    type = "text";
                                    value = "ctrl";
                                  }
                                ];
                                type = "string";
                              }
                              {
                                multiline = false;
                                parts = [
                                  {
                                    type = "text";
                                    value = "super";
                                  }
                                ];
                                type = "string";
                              }
                              {
                                multiline = false;
                                parts = [
                                  {
                                    type = "text";
                                    value = "j";
                                  }
                                ];
                                type = "string";
                              }
                            ];
                            type = "list";
                          };
                        }
                        {
                          operator = "=";
                          target = [
                            {
                              kind = "identifier";
                              value = "description";
                            }
                          ];
                          type = "assignment";
                          value = {
                            multiline = true;
                            parts = [
                              {
                                type = "text";
                                value = "Shortcut to swap window with lower neighbor\n\nDefine as a list of keys, e.g., [ \"super\" \"q\" ].\nSupported modifiers: super, ctrl, alt, shift.";
                              }
                            ];
                            type = "string";
                          };
                        }
                      ];
                      type = "attr-set";
                    };
                  }
                ];
                type = "attr-set";
              };
            }
            {
              operator = "=";
              target = [
                {
                  kind = "identifier";
                  value = "window-swap-up";
                }
              ];
              type = "assignment";
              value = {
                recursive = false;
                statements = [
                  {
                    operator = "=";
                    target = [
                      {
                        kind = "identifier";
                        value = "_meta";
                      }
                    ];
                    type = "assignment";
                    value = {
                      recursive = false;
                      statements = [
                        {
                          operator = "=";
                          target = [
                            {
                              kind = "identifier";
                              value = "type";
                            }
                          ];
                          type = "assignment";
                          value = {
                            arguments = [
                              {
                                items = [
                                  {
                                    name = "type";
                                    path = [
                                      {
                                        kind = "identifier";
                                        value = "string";
                                      }
                                    ];
                                    type = "variable";
                                  }
                                ];
                                type = "list";
                              }
                            ];
                            callee = {
                              name = "type";
                              path = [
                                {
                                  kind = "identifier";
                                  value = "list";
                                }
                              ];
                              type = "variable";
                            };
                            type = "call";
                          };
                        }
                        {
                          operator = "=";
                          target = [
                            {
                              kind = "identifier";
                              value = "default";
                            }
                          ];
                          type = "assignment";
                          value = {
                            items = [
                              {
                                multiline = false;
                                parts = [
                                  {
                                    type = "text";
                                    value = "ctrl";
                                  }
                                ];
                                type = "string";
                              }
                              {
                                multiline = false;
                                parts = [
                                  {
                                    type = "text";
                                    value = "super";
                                  }
                                ];
                                type = "string";
                              }
                              {
                                multiline = false;
                                parts = [
                                  {
                                    type = "text";
                                    value = "k";
                                  }
                                ];
                                type = "string";
                              }
                            ];
                            type = "list";
                          };
                        }
                        {
                          operator = "=";
                          target = [
                            {
                              kind = "identifier";
                              value = "description";
                            }
                          ];
                          type = "assignment";
                          value = {
                            multiline = true;
                            parts = [
                              {
                                type = "text";
                                value = "Shortcut to swap window with upper neighbor\n\nDefine as a list of keys, e.g., [ \"super\" \"q\" ].\nSupported modifiers: super, ctrl, alt, shift.";
                              }
                            ];
                            type = "string";
                          };
                        }
                      ];
                      type = "attr-set";
                    };
                  }
                ];
                type = "attr-set";
              };
            }
            {
              operator = "=";
              target = [
                {
                  kind = "identifier";
                  value = "window-swap-right";
                }
              ];
              type = "assignment";
              value = {
                recursive = false;
                statements = [
                  {
                    operator = "=";
                    target = [
                      {
                        kind = "identifier";
                        value = "_meta";
                      }
                    ];
                    type = "assignment";
                    value = {
                      recursive = false;
                      statements = [
                        {
                          operator = "=";
                          target = [
                            {
                              kind = "identifier";
                              value = "type";
                            }
                          ];
                          type = "assignment";
                          value = {
                            arguments = [
                              {
                                items = [
                                  {
                                    name = "type";
                                    path = [
                                      {
                                        kind = "identifier";
                                        value = "string";
                                      }
                                    ];
                                    type = "variable";
                                  }
                                ];
                                type = "list";
                              }
                            ];
                            callee = {
                              name = "type";
                              path = [
                                {
                                  kind = "identifier";
                                  value = "list";
                                }
                              ];
                              type = "variable";
                            };
                            type = "call";
                          };
                        }
                        {
                          operator = "=";
                          target = [
                            {
                              kind = "identifier";
                              value = "default";
                            }
                          ];
                          type = "assignment";
                          value = {
                            items = [
                              {
                                multiline = false;
                                parts = [
                                  {
                                    type = "text";
                                    value = "ctrl";
                                  }
                                ];
                                type = "string";
                              }
                              {
                                multiline = false;
                                parts = [
                                  {
                                    type = "text";
                                    value = "super";
                                  }
                                ];
                                type = "string";
                              }
                              {
                                multiline = false;
                                parts = [
                                  {
                                    type = "text";
                                    value = "l";
                                  }
                                ];
                                type = "string";
                              }
                            ];
                            type = "list";
                          };
                        }
                        {
                          operator = "=";
                          target = [
                            {
                              kind = "identifier";
                              value = "description";
                            }
                          ];
                          type = "assignment";
                          value = {
                            multiline = true;
                            parts = [
                              {
                                type = "text";
                                value = "Shortcut to swap window with right neighbor\n\nDefine as a list of keys, e.g., [ \"super\" \"q\" ].\nSupported modifiers: super, ctrl, alt, shift.";
                              }
                            ];
                            type = "string";
                          };
                        }
                      ];
                      type = "attr-set";
                    };
                  }
                ];
                type = "attr-set";
              };
            }
            {
              operator = "=";
              target = [
                {
                  kind = "identifier";
                  value = "window-move-left";
                }
              ];
              type = "assignment";
              value = {
                recursive = false;
                statements = [
                  {
                    operator = "=";
                    target = [
                      {
                        kind = "identifier";
                        value = "_meta";
                      }
                    ];
                    type = "assignment";
                    value = {
                      recursive = false;
                      statements = [
                        {
                          operator = "=";
                          target = [
                            {
                              kind = "identifier";
                              value = "type";
                            }
                          ];
                          type = "assignment";
                          value = {
                            arguments = [
                              {
                                items = [
                                  {
                                    name = "type";
                                    path = [
                                      {
                                        kind = "identifier";
                                        value = "string";
                                      }
                                    ];
                                    type = "variable";
                                  }
                                ];
                                type = "list";
                              }
                            ];
                            callee = {
                              name = "type";
                              path = [
                                {
                                  kind = "identifier";
                                  value = "list";
                                }
                              ];
                              type = "variable";
                            };
                            type = "call";
                          };
                        }
                        {
                          operator = "=";
                          target = [
                            {
                              kind = "identifier";
                              value = "default";
                            }
                          ];
                          type = "assignment";
                          value = {
                            items = [
                              {
                                multiline = false;
                                parts = [
                                  {
                                    type = "text";
                                    value = "shift";
                                  }
                                ];
                                type = "string";
                              }
                              {
                                multiline = false;
                                parts = [
                                  {
                                    type = "text";
                                    value = "super";
                                  }
                                ];
                                type = "string";
                              }
                              {
                                multiline = false;
                                parts = [
                                  {
                                    type = "text";
                                    value = "h";
                                  }
                                ];
                                type = "string";
                              }
                            ];
                            type = "list";
                          };
                        }
                        {
                          operator = "=";
                          target = [
                            {
                              kind = "identifier";
                              value = "description";
                            }
                          ];
                          type = "assignment";
                          value = {
                            multiline = true;
                            parts = [
                              {
                                type = "text";
                                value = "Shortcut to move window left\n\nDefine as a list of keys, e.g., [ \"super\" \"q\" ].\nSupported modifiers: super, ctrl, alt, shift.";
                              }
                            ];
                            type = "string";
                          };
                        }
                      ];
                      type = "attr-set";
                    };
                  }
                ];
                type = "attr-set";
              };
            }
            {
              operator = "=";
              target = [
                {
                  kind = "identifier";
                  value = "window-move-down";
                }
              ];
              type = "assignment";
              value = {
                recursive = false;
                statements = [
                  {
                    operator = "=";
                    target = [
                      {
                        kind = "identifier";
                        value = "_meta";
                      }
                    ];
                    type = "assignment";
                    value = {
                      recursive = false;
                      statements = [
                        {
                          operator = "=";
                          target = [
                            {
                              kind = "identifier";
                              value = "type";
                            }
                          ];
                          type = "assignment";
                          value = {
                            arguments = [
                              {
                                items = [
                                  {
                                    name = "type";
                                    path = [
                                      {
                                        kind = "identifier";
                                        value = "string";
                                      }
                                    ];
                                    type = "variable";
                                  }
                                ];
                                type = "list";
                              }
                            ];
                            callee = {
                              name = "type";
                              path = [
                                {
                                  kind = "identifier";
                                  value = "list";
                                }
                              ];
                              type = "variable";
                            };
                            type = "call";
                          };
                        }
                        {
                          operator = "=";
                          target = [
                            {
                              kind = "identifier";
                              value = "default";
                            }
                          ];
                          type = "assignment";
                          value = {
                            items = [
                              {
                                multiline = false;
                                parts = [
                                  {
                                    type = "text";
                                    value = "shift";
                                  }
                                ];
                                type = "string";
                              }
                              {
                                multiline = false;
                                parts = [
                                  {
                                    type = "text";
                                    value = "super";
                                  }
                                ];
                                type = "string";
                              }
                              {
                                multiline = false;
                                parts = [
                                  {
                                    type = "text";
                                    value = "j";
                                  }
                                ];
                                type = "string";
                              }
                            ];
                            type = "list";
                          };
                        }
                        {
                          operator = "=";
                          target = [
                            {
                              kind = "identifier";
                              value = "description";
                            }
                          ];
                          type = "assignment";
                          value = {
                            multiline = true;
                            parts = [
                              {
                                type = "text";
                                value = "Shortcut to move window down\n\nDefine as a list of keys, e.g., [ \"super\" \"q\" ].\nSupported modifiers: super, ctrl, alt, shift.";
                              }
                            ];
                            type = "string";
                          };
                        }
                      ];
                      type = "attr-set";
                    };
                  }
                ];
                type = "attr-set";
              };
            }
            {
              operator = "=";
              target = [
                {
                  kind = "identifier";
                  value = "window-move-up";
                }
              ];
              type = "assignment";
              value = {
                recursive = false;
                statements = [
                  {
                    operator = "=";
                    target = [
                      {
                        kind = "identifier";
                        value = "_meta";
                      }
                    ];
                    type = "assignment";
                    value = {
                      recursive = false;
                      statements = [
                        {
                          operator = "=";
                          target = [
                            {
                              kind = "identifier";
                              value = "type";
                            }
                          ];
                          type = "assignment";
                          value = {
                            arguments = [
                              {
                                items = [
                                  {
                                    name = "type";
                                    path = [
                                      {
                                        kind = "identifier";
                                        value = "string";
                                      }
                                    ];
                                    type = "variable";
                                  }
                                ];
                                type = "list";
                              }
                            ];
                            callee = {
                              name = "type";
                              path = [
                                {
                                  kind = "identifier";
                                  value = "list";
                                }
                              ];
                              type = "variable";
                            };
                            type = "call";
                          };
                        }
                        {
                          operator = "=";
                          target = [
                            {
                              kind = "identifier";
                              value = "default";
                            }
                          ];
                          type = "assignment";
                          value = {
                            items = [
                              {
                                multiline = false;
                                parts = [
                                  {
                                    type = "text";
                                    value = "shift";
                                  }
                                ];
                                type = "string";
                              }
                              {
                                multiline = false;
                                parts = [
                                  {
                                    type = "text";
                                    value = "super";
                                  }
                                ];
                                type = "string";
                              }
                              {
                                multiline = false;
                                parts = [
                                  {
                                    type = "text";
                                    value = "k";
                                  }
                                ];
                                type = "string";
                              }
                            ];
                            type = "list";
                          };
                        }
                        {
                          operator = "=";
                          target = [
                            {
                              kind = "identifier";
                              value = "description";
                            }
                          ];
                          type = "assignment";
                          value = {
                            multiline = true;
                            parts = [
                              {
                                type = "text";
                                value = "Shortcut to move window up\n\nDefine as a list of keys, e.g., [ \"super\" \"q\" ].\nSupported modifiers: super, ctrl, alt, shift.";
                              }
                            ];
                            type = "string";
                          };
                        }
                      ];
                      type = "attr-set";
                    };
                  }
                ];
                type = "attr-set";
              };
            }
            {
              operator = "=";
              target = [
                {
                  kind = "identifier";
                  value = "window-move-right";
                }
              ];
              type = "assignment";
              value = {
                recursive = false;
                statements = [
                  {
                    operator = "=";
                    target = [
                      {
                        kind = "identifier";
                        value = "_meta";
                      }
                    ];
                    type = "assignment";
                    value = {
                      recursive = false;
                      statements = [
                        {
                          operator = "=";
                          target = [
                            {
                              kind = "identifier";
                              value = "type";
                            }
                          ];
                          type = "assignment";
                          value = {
                            arguments = [
                              {
                                items = [
                                  {
                                    name = "type";
                                    path = [
                                      {
                                        kind = "identifier";
                                        value = "string";
                                      }
                                    ];
                                    type = "variable";
                                  }
                                ];
                                type = "list";
                              }
                            ];
                            callee = {
                              name = "type";
                              path = [
                                {
                                  kind = "identifier";
                                  value = "list";
                                }
                              ];
                              type = "variable";
                            };
                            type = "call";
                          };
                        }
                        {
                          operator = "=";
                          target = [
                            {
                              kind = "identifier";
                              value = "default";
                            }
                          ];
                          type = "assignment";
                          value = {
                            items = [
                              {
                                multiline = false;
                                parts = [
                                  {
                                    type = "text";
                                    value = "shift";
                                  }
                                ];
                                type = "string";
                              }
                              {
                                multiline = false;
                                parts = [
                                  {
                                    type = "text";
                                    value = "super";
                                  }
                                ];
                                type = "string";
                              }
                              {
                                multiline = false;
                                parts = [
                                  {
                                    type = "text";
                                    value = "l";
                                  }
                                ];
                                type = "string";
                              }
                            ];
                            type = "list";
                          };
                        }
                        {
                          operator = "=";
                          target = [
                            {
                              kind = "identifier";
                              value = "description";
                            }
                          ];
                          type = "assignment";
                          value = {
                            multiline = true;
                            parts = [
                              {
                                type = "text";
                                value = "Shortcut to move window right\n\nDefine as a list of keys, e.g., [ \"super\" \"q\" ].\nSupported modifiers: super, ctrl, alt, shift.";
                              }
                            ];
                            type = "string";
                          };
                        }
                      ];
                      type = "attr-set";
                    };
                  }
                ];
                type = "attr-set";
              };
            }
            {
              operator = "=";
              target = [
                {
                  kind = "identifier";
                  value = "window-focus-left";
                }
              ];
              type = "assignment";
              value = {
                recursive = false;
                statements = [
                  {
                    operator = "=";
                    target = [
                      {
                        kind = "identifier";
                        value = "_meta";
                      }
                    ];
                    type = "assignment";
                    value = {
                      recursive = false;
                      statements = [
                        {
                          operator = "=";
                          target = [
                            {
                              kind = "identifier";
                              value = "type";
                            }
                          ];
                          type = "assignment";
                          value = {
                            arguments = [
                              {
                                items = [
                                  {
                                    name = "type";
                                    path = [
                                      {
                                        kind = "identifier";
                                        value = "string";
                                      }
                                    ];
                                    type = "variable";
                                  }
                                ];
                                type = "list";
                              }
                            ];
                            callee = {
                              name = "type";
                              path = [
                                {
                                  kind = "identifier";
                                  value = "list";
                                }
                              ];
                              type = "variable";
                            };
                            type = "call";
                          };
                        }
                        {
                          operator = "=";
                          target = [
                            {
                              kind = "identifier";
                              value = "default";
                            }
                          ];
                          type = "assignment";
                          value = {
                            items = [
                              {
                                multiline = false;
                                parts = [
                                  {
                                    type = "text";
                                    value = "super";
                                  }
                                ];
                                type = "string";
                              }
                              {
                                multiline = false;
                                parts = [
                                  {
                                    type = "text";
                                    value = "h";
                                  }
                                ];
                                type = "string";
                              }
                            ];
                            type = "list";
                          };
                        }
                        {
                          operator = "=";
                          target = [
                            {
                              kind = "identifier";
                              value = "description";
                            }
                          ];
                          type = "assignment";
                          value = {
                            multiline = true;
                            parts = [
                              {
                                type = "text";
                                value = "Shortcut to focus left neighbor\n\nDefine as a list of keys, e.g., [ \"super\" \"q\" ].\nSupported modifiers: super, ctrl, alt, shift.";
                              }
                            ];
                            type = "string";
                          };
                        }
                      ];
                      type = "attr-set";
                    };
                  }
                ];
                type = "attr-set";
              };
            }
            {
              operator = "=";
              target = [
                {
                  kind = "identifier";
                  value = "window-focus-down";
                }
              ];
              type = "assignment";
              value = {
                recursive = false;
                statements = [
                  {
                    operator = "=";
                    target = [
                      {
                        kind = "identifier";
                        value = "_meta";
                      }
                    ];
                    type = "assignment";
                    value = {
                      recursive = false;
                      statements = [
                        {
                          operator = "=";
                          target = [
                            {
                              kind = "identifier";
                              value = "type";
                            }
                          ];
                          type = "assignment";
                          value = {
                            arguments = [
                              {
                                items = [
                                  {
                                    name = "type";
                                    path = [
                                      {
                                        kind = "identifier";
                                        value = "string";
                                      }
                                    ];
                                    type = "variable";
                                  }
                                ];
                                type = "list";
                              }
                            ];
                            callee = {
                              name = "type";
                              path = [
                                {
                                  kind = "identifier";
                                  value = "list";
                                }
                              ];
                              type = "variable";
                            };
                            type = "call";
                          };
                        }
                        {
                          operator = "=";
                          target = [
                            {
                              kind = "identifier";
                              value = "default";
                            }
                          ];
                          type = "assignment";
                          value = {
                            items = [
                              {
                                multiline = false;
                                parts = [
                                  {
                                    type = "text";
                                    value = "super";
                                  }
                                ];
                                type = "string";
                              }
                              {
                                multiline = false;
                                parts = [
                                  {
                                    type = "text";
                                    value = "j";
                                  }
                                ];
                                type = "string";
                              }
                            ];
                            type = "list";
                          };
                        }
                        {
                          operator = "=";
                          target = [
                            {
                              kind = "identifier";
                              value = "description";
                            }
                          ];
                          type = "assignment";
                          value = {
                            multiline = true;
                            parts = [
                              {
                                type = "text";
                                value = "Shortcut to focus lower neighbor\n\nDefine as a list of keys, e.g., [ \"super\" \"q\" ].\nSupported modifiers: super, ctrl, alt, shift.";
                              }
                            ];
                            type = "string";
                          };
                        }
                      ];
                      type = "attr-set";
                    };
                  }
                ];
                type = "attr-set";
              };
            }
            {
              operator = "=";
              target = [
                {
                  kind = "identifier";
                  value = "window-focus-up";
                }
              ];
              type = "assignment";
              value = {
                recursive = false;
                statements = [
                  {
                    operator = "=";
                    target = [
                      {
                        kind = "identifier";
                        value = "_meta";
                      }
                    ];
                    type = "assignment";
                    value = {
                      recursive = false;
                      statements = [
                        {
                          operator = "=";
                          target = [
                            {
                              kind = "identifier";
                              value = "type";
                            }
                          ];
                          type = "assignment";
                          value = {
                            arguments = [
                              {
                                items = [
                                  {
                                    name = "type";
                                    path = [
                                      {
                                        kind = "identifier";
                                        value = "string";
                                      }
                                    ];
                                    type = "variable";
                                  }
                                ];
                                type = "list";
                              }
                            ];
                            callee = {
                              name = "type";
                              path = [
                                {
                                  kind = "identifier";
                                  value = "list";
                                }
                              ];
                              type = "variable";
                            };
                            type = "call";
                          };
                        }
                        {
                          operator = "=";
                          target = [
                            {
                              kind = "identifier";
                              value = "default";
                            }
                          ];
                          type = "assignment";
                          value = {
                            items = [
                              {
                                multiline = false;
                                parts = [
                                  {
                                    type = "text";
                                    value = "super";
                                  }
                                ];
                                type = "string";
                              }
                              {
                                multiline = false;
                                parts = [
                                  {
                                    type = "text";
                                    value = "k";
                                  }
                                ];
                                type = "string";
                              }
                            ];
                            type = "list";
                          };
                        }
                        {
                          operator = "=";
                          target = [
                            {
                              kind = "identifier";
                              value = "description";
                            }
                          ];
                          type = "assignment";
                          value = {
                            multiline = true;
                            parts = [
                              {
                                type = "text";
                                value = "Shortcut to focus upper neighbor\n\nDefine as a list of keys, e.g., [ \"super\" \"q\" ].\nSupported modifiers: super, ctrl, alt, shift.";
                              }
                            ];
                            type = "string";
                          };
                        }
                      ];
                      type = "attr-set";
                    };
                  }
                ];
                type = "attr-set";
              };
            }
            {
              operator = "=";
              target = [
                {
                  kind = "identifier";
                  value = "window-focus-right";
                }
              ];
              type = "assignment";
              value = {
                recursive = false;
                statements = [
                  {
                    operator = "=";
                    target = [
                      {
                        kind = "identifier";
                        value = "_meta";
                      }
                    ];
                    type = "assignment";
                    value = {
                      recursive = false;
                      statements = [
                        {
                          operator = "=";
                          target = [
                            {
                              kind = "identifier";
                              value = "type";
                            }
                          ];
                          type = "assignment";
                          value = {
                            arguments = [
                              {
                                items = [
                                  {
                                    name = "type";
                                    path = [
                                      {
                                        kind = "identifier";
                                        value = "string";
                                      }
                                    ];
                                    type = "variable";
                                  }
                                ];
                                type = "list";
                              }
                            ];
                            callee = {
                              name = "type";
                              path = [
                                {
                                  kind = "identifier";
                                  value = "list";
                                }
                              ];
                              type = "variable";
                            };
                            type = "call";
                          };
                        }
                        {
                          operator = "=";
                          target = [
                            {
                              kind = "identifier";
                              value = "default";
                            }
                          ];
                          type = "assignment";
                          value = {
                            items = [
                              {
                                multiline = false;
                                parts = [
                                  {
                                    type = "text";
                                    value = "super";
                                  }
                                ];
                                type = "string";
                              }
                              {
                                multiline = false;
                                parts = [
                                  {
                                    type = "text";
                                    value = "l";
                                  }
                                ];
                                type = "string";
                              }
                            ];
                            type = "list";
                          };
                        }
                        {
                          operator = "=";
                          target = [
                            {
                              kind = "identifier";
                              value = "description";
                            }
                          ];
                          type = "assignment";
                          value = {
                            multiline = true;
                            parts = [
                              {
                                type = "text";
                                value = "Shortcut to focus right neighbor\n\nDefine as a list of keys, e.g., [ \"super\" \"q\" ].\nSupported modifiers: super, ctrl, alt, shift.";
                              }
                            ];
                            type = "string";
                          };
                        }
                      ];
                      type = "attr-set";
                    };
                  }
                ];
                type = "attr-set";
              };
            }
            {
              operator = "=";
              target = [
                {
                  kind = "identifier";
                  value = "window-toggle-float";
                }
              ];
              type = "assignment";
              value = {
                recursive = false;
                statements = [
                  {
                    operator = "=";
                    target = [
                      {
                        kind = "identifier";
                        value = "_meta";
                      }
                    ];
                    type = "assignment";
                    value = {
                      recursive = false;
                      statements = [
                        {
                          operator = "=";
                          target = [
                            {
                              kind = "identifier";
                              value = "type";
                            }
                          ];
                          type = "assignment";
                          value = {
                            arguments = [
                              {
                                items = [
                                  {
                                    name = "type";
                                    path = [
                                      {
                                        kind = "identifier";
                                        value = "string";
                                      }
                                    ];
                                    type = "variable";
                                  }
                                ];
                                type = "list";
                              }
                            ];
                            callee = {
                              name = "type";
                              path = [
                                {
                                  kind = "identifier";
                                  value = "list";
                                }
                              ];
                              type = "variable";
                            };
                            type = "call";
                          };
                        }
                        {
                          operator = "=";
                          target = [
                            {
                              kind = "identifier";
                              value = "default";
                            }
                          ];
                          type = "assignment";
                          value = {
                            items = [
                              {
                                multiline = false;
                                parts = [
                                  {
                                    type = "text";
                                    value = "super";
                                  }
                                ];
                                type = "string";
                              }
                              {
                                multiline = false;
                                parts = [
                                  {
                                    type = "text";
                                    value = "c";
                                  }
                                ];
                                type = "string";
                              }
                            ];
                            type = "list";
                          };
                        }
                        {
                          operator = "=";
                          target = [
                            {
                              kind = "identifier";
                              value = "description";
                            }
                          ];
                          type = "assignment";
                          value = {
                            multiline = true;
                            parts = [
                              {
                                type = "text";
                                value = "Shortcut to toggle floating for active window\n\nDefine as a list of keys, e.g., [ \"super\" \"q\" ].\nSupported modifiers: super, ctrl, alt, shift.";
                              }
                            ];
                            type = "string";
                          };
                        }
                      ];
                      type = "attr-set";
                    };
                  }
                ];
                type = "attr-set";
              };
            }
            {
              operator = "=";
              target = [
                {
                  kind = "identifier";
                  value = "window-toggle-always-float";
                }
              ];
              type = "assignment";
              value = {
                recursive = false;
                statements = [
                  {
                    operator = "=";
                    target = [
                      {
                        kind = "identifier";
                        value = "_meta";
                      }
                    ];
                    type = "assignment";
                    value = {
                      recursive = false;
                      statements = [
                        {
                          operator = "=";
                          target = [
                            {
                              kind = "identifier";
                              value = "type";
                            }
                          ];
                          type = "assignment";
                          value = {
                            arguments = [
                              {
                                items = [
                                  {
                                    name = "type";
                                    path = [
                                      {
                                        kind = "identifier";
                                        value = "string";
                                      }
                                    ];
                                    type = "variable";
                                  }
                                ];
                                type = "list";
                              }
                            ];
                            callee = {
                              name = "type";
                              path = [
                                {
                                  kind = "identifier";
                                  value = "list";
                                }
                              ];
                              type = "variable";
                            };
                            type = "call";
                          };
                        }
                        {
                          operator = "=";
                          target = [
                            {
                              kind = "identifier";
                              value = "default";
                            }
                          ];
                          type = "assignment";
                          value = {
                            items = [
                              {
                                multiline = false;
                                parts = [
                                  {
                                    type = "text";
                                    value = "shift";
                                  }
                                ];
                                type = "string";
                              }
                              {
                                multiline = false;
                                parts = [
                                  {
                                    type = "text";
                                    value = "super";
                                  }
                                ];
                                type = "string";
                              }
                              {
                                multiline = false;
                                parts = [
                                  {
                                    type = "text";
                                    value = "c";
                                  }
                                ];
                                type = "string";
                              }
                            ];
                            type = "list";
                          };
                        }
                        {
                          operator = "=";
                          target = [
                            {
                              kind = "identifier";
                              value = "description";
                            }
                          ];
                          type = "assignment";
                          value = {
                            multiline = true;
                            parts = [
                              {
                                type = "text";
                                value = "Shortcut to force permanent float for app\n\nDefine as a list of keys, e.g., [ \"super\" \"q\" ].\nSupported modifiers: super, ctrl, alt, shift.";
                              }
                            ];
                            type = "string";
                          };
                        }
                      ];
                      type = "attr-set";
                    };
                  }
                ];
                type = "attr-set";
              };
            }
            {
              operator = "=";
              target = [
                {
                  kind = "identifier";
                  value = "workspace-active-tile-toggle";
                }
              ];
              type = "assignment";
              value = {
                recursive = false;
                statements = [
                  {
                    operator = "=";
                    target = [
                      {
                        kind = "identifier";
                        value = "_meta";
                      }
                    ];
                    type = "assignment";
                    value = {
                      recursive = false;
                      statements = [
                        {
                          operator = "=";
                          target = [
                            {
                              kind = "identifier";
                              value = "type";
                            }
                          ];
                          type = "assignment";
                          value = {
                            arguments = [
                              {
                                items = [
                                  {
                                    name = "type";
                                    path = [
                                      {
                                        kind = "identifier";
                                        value = "string";
                                      }
                                    ];
                                    type = "variable";
                                  }
                                ];
                                type = "list";
                              }
                            ];
                            callee = {
                              name = "type";
                              path = [
                                {
                                  kind = "identifier";
                                  value = "list";
                                }
                              ];
                              type = "variable";
                            };
                            type = "call";
                          };
                        }
                        {
                          operator = "=";
                          target = [
                            {
                              kind = "identifier";
                              value = "default";
                            }
                          ];
                          type = "assignment";
                          value = {
                            items = [
                              {
                                multiline = false;
                                parts = [
                                  {
                                    type = "text";
                                    value = "shift";
                                  }
                                ];
                                type = "string";
                              }
                              {
                                multiline = false;
                                parts = [
                                  {
                                    type = "text";
                                    value = "super";
                                  }
                                ];
                                type = "string";
                              }
                              {
                                multiline = false;
                                parts = [
                                  {
                                    type = "text";
                                    value = "w";
                                  }
                                ];
                                type = "string";
                              }
                            ];
                            type = "list";
                          };
                        }
                        {
                          operator = "=";
                          target = [
                            {
                              kind = "identifier";
                              value = "description";
                            }
                          ];
                          type = "assignment";
                          value = {
                            multiline = true;
                            parts = [
                              {
                                type = "text";
                                value = "Shortcut to toggle tiling for current desktop\n\nDefine as a list of keys, e.g., [ \"super\" \"q\" ].\nSupported modifiers: super, ctrl, alt, shift.";
                              }
                            ];
                            type = "string";
                          };
                        }
                      ];
                      type = "attr-set";
                    };
                  }
                ];
                type = "attr-set";
              };
            }
            {
              operator = "=";
              target = [
                {
                  kind = "identifier";
                  value = "prefs-open";
                }
              ];
              type = "assignment";
              value = {
                recursive = false;
                statements = [
                  {
                    operator = "=";
                    target = [
                      {
                        kind = "identifier";
                        value = "_meta";
                      }
                    ];
                    type = "assignment";
                    value = {
                      recursive = false;
                      statements = [
                        {
                          operator = "=";
                          target = [
                            {
                              kind = "identifier";
                              value = "type";
                            }
                          ];
                          type = "assignment";
                          value = {
                            arguments = [
                              {
                                items = [
                                  {
                                    name = "type";
                                    path = [
                                      {
                                        kind = "identifier";
                                        value = "string";
                                      }
                                    ];
                                    type = "variable";
                                  }
                                ];
                                type = "list";
                              }
                            ];
                            callee = {
                              name = "type";
                              path = [
                                {
                                  kind = "identifier";
                                  value = "list";
                                }
                              ];
                              type = "variable";
                            };
                            type = "call";
                          };
                        }
                        {
                          operator = "=";
                          target = [
                            {
                              kind = "identifier";
                              value = "default";
                            }
                          ];
                          type = "assignment";
                          value = {
                            items = [
                              {
                                multiline = false;
                                parts = [
                                  {
                                    type = "text";
                                    value = "super";
                                  }
                                ];
                                type = "string";
                              }
                              {
                                multiline = false;
                                parts = [
                                  {
                                    type = "text";
                                    value = "period";
                                  }
                                ];
                                type = "string";
                              }
                            ];
                            type = "list";
                          };
                        }
                        {
                          operator = "=";
                          target = [
                            {
                              kind = "identifier";
                              value = "description";
                            }
                          ];
                          type = "assignment";
                          value = {
                            multiline = true;
                            parts = [
                              {
                                type = "text";
                                value = "Shortcut to open Forge preferences\n\nDefine as a list of keys, e.g., [ \"super\" \"q\" ].\nSupported modifiers: super, ctrl, alt, shift.";
                              }
                            ];
                            type = "string";
                          };
                        }
                      ];
                      type = "attr-set";
                    };
                  }
                ];
                type = "attr-set";
              };
            }
            {
              operator = "=";
              target = [
                {
                  kind = "identifier";
                  value = "prefs-tiling-toggle";
                }
              ];
              type = "assignment";
              value = {
                recursive = false;
                statements = [
                  {
                    operator = "=";
                    target = [
                      {
                        kind = "identifier";
                        value = "_meta";
                      }
                    ];
                    type = "assignment";
                    value = {
                      recursive = false;
                      statements = [
                        {
                          operator = "=";
                          target = [
                            {
                              kind = "identifier";
                              value = "type";
                            }
                          ];
                          type = "assignment";
                          value = {
                            arguments = [
                              {
                                items = [
                                  {
                                    name = "type";
                                    path = [
                                      {
                                        kind = "identifier";
                                        value = "string";
                                      }
                                    ];
                                    type = "variable";
                                  }
                                ];
                                type = "list";
                              }
                            ];
                            callee = {
                              name = "type";
                              path = [
                                {
                                  kind = "identifier";
                                  value = "list";
                                }
                              ];
                              type = "variable";
                            };
                            type = "call";
                          };
                        }
                        {
                          operator = "=";
                          target = [
                            {
                              kind = "identifier";
                              value = "default";
                            }
                          ];
                          type = "assignment";
                          value = {
                            items = [
                              {
                                multiline = false;
                                parts = [
                                  {
                                    type = "text";
                                    value = "super";
                                  }
                                ];
                                type = "string";
                              }
                              {
                                multiline = false;
                                parts = [
                                  {
                                    type = "text";
                                    value = "w";
                                  }
                                ];
                                type = "string";
                              }
                            ];
                            type = "list";
                          };
                        }
                        {
                          operator = "=";
                          target = [
                            {
                              kind = "identifier";
                              value = "description";
                            }
                          ];
                          type = "assignment";
                          value = {
                            multiline = true;
                            parts = [
                              {
                                type = "text";
                                value = "Shortcut to toggle tiling mode\n\nDefine as a list of keys, e.g., [ \"super\" \"q\" ].\nSupported modifiers: super, ctrl, alt, shift.";
                              }
                            ];
                            type = "string";
                          };
                        }
                      ];
                      type = "attr-set";
                    };
                  }
                ];
                type = "attr-set";
              };
            }
            {
              operator = "=";
              target = [
                {
                  kind = "identifier";
                  value = "mod-mask-mouse-tile";
                }
              ];
              type = "assignment";
              value = {
                recursive = false;
                statements = [
                  {
                    operator = "=";
                    target = [
                      {
                        kind = "identifier";
                        value = "_meta";
                      }
                    ];
                    type = "assignment";
                    value = {
                      recursive = false;
                      statements = [
                        {
                          operator = "=";
                          target = [
                            {
                              kind = "identifier";
                              value = "type";
                            }
                          ];
                          type = "assignment";
                          value = {
                            arguments = [
                              {
                                items = [
                                  {
                                    multiline = false;
                                    parts = [
                                      {
                                        type = "text";
                                        value = "Super";
                                      }
                                    ];
                                    type = "string";
                                  }
                                  {
                                    multiline = false;
                                    parts = [
                                      {
                                        type = "text";
                                        value = "Ctrl";
                                      }
                                    ];
                                    type = "string";
                                  }
                                  {
                                    multiline = false;
                                    parts = [
                                      {
                                        type = "text";
                                        value = "Shift";
                                      }
                                    ];
                                    type = "string";
                                  }
                                  {
                                    multiline = false;
                                    parts = [
                                      {
                                        type = "text";
                                        value = "Alt";
                                      }
                                    ];
                                    type = "string";
                                  }
                                  {
                                    multiline = false;
                                    parts = [
                                      {
                                        type = "text";
                                        value = "None";
                                      }
                                    ];
                                    type = "string";
                                  }
                                ];
                                type = "list";
                              }
                            ];
                            callee = {
                              name = "type";
                              path = [
                                {
                                  kind = "identifier";
                                  value = "enum";
                                }
                              ];
                              type = "variable";
                            };
                            type = "call";
                          };
                        }
                        {
                          operator = "=";
                          target = [
                            {
                              kind = "identifier";
                              value = "default";
                            }
                          ];
                          type = "assignment";
                          value = {
                            multiline = false;
                            parts = [
                              {
                                type = "text";
                                value = "None";
                              }
                            ];
                            type = "string";
                          };
                        }
                        {
                          operator = "=";
                          target = [
                            {
                              kind = "identifier";
                              value = "description";
                            }
                          ];
                          type = "assignment";
                          value = {
                            multiline = true;
                            parts = [
                              {
                                type = "text";
                                value = "Modifier key for mouse-based tiling operations";
                              }
                            ];
                            type = "string";
                          };
                        }
                      ];
                      type = "attr-set";
                    };
                  }
                ];
                type = "attr-set";
              };
            }
            {
              operator = "=";
              target = [
                {
                  kind = "identifier";
                  value = "window-swap-last-active";
                }
              ];
              type = "assignment";
              value = {
                recursive = false;
                statements = [
                  {
                    operator = "=";
                    target = [
                      {
                        kind = "identifier";
                        value = "_meta";
                      }
                    ];
                    type = "assignment";
                    value = {
                      recursive = false;
                      statements = [
                        {
                          operator = "=";
                          target = [
                            {
                              kind = "identifier";
                              value = "type";
                            }
                          ];
                          type = "assignment";
                          value = {
                            arguments = [
                              {
                                items = [
                                  {
                                    name = "type";
                                    path = [
                                      {
                                        kind = "identifier";
                                        value = "string";
                                      }
                                    ];
                                    type = "variable";
                                  }
                                ];
                                type = "list";
                              }
                            ];
                            callee = {
                              name = "type";
                              path = [
                                {
                                  kind = "identifier";
                                  value = "list";
                                }
                              ];
                              type = "variable";
                            };
                            type = "call";
                          };
                        }
                        {
                          operator = "=";
                          target = [
                            {
                              kind = "identifier";
                              value = "default";
                            }
                          ];
                          type = "assignment";
                          value = {
                            items = [
                              {
                                multiline = false;
                                parts = [
                                  {
                                    type = "text";
                                    value = "super";
                                  }
                                ];
                                type = "string";
                              }
                              {
                                multiline = false;
                                parts = [
                                  {
                                    type = "text";
                                    value = "return";
                                  }
                                ];
                                type = "string";
                              }
                            ];
                            type = "list";
                          };
                        }
                        {
                          operator = "=";
                          target = [
                            {
                              kind = "identifier";
                              value = "description";
                            }
                          ];
                          type = "assignment";
                          value = {
                            multiline = true;
                            parts = [
                              {
                                type = "text";
                                value = "Shortcut to swap with previously active window\n\nDefine as a list of keys, e.g., [ \"super\" \"q\" ].\nSupported modifiers: super, ctrl, alt, shift.";
                              }
                            ];
                            type = "string";
                          };
                        }
                      ];
                      type = "attr-set";
                    };
                  }
                ];
                type = "attr-set";
              };
            }
            {
              operator = "=";
              target = [
                {
                  kind = "identifier";
                  value = "window-snap-one-third-right";
                }
              ];
              type = "assignment";
              value = {
                recursive = false;
                statements = [
                  {
                    operator = "=";
                    target = [
                      {
                        kind = "identifier";
                        value = "_meta";
                      }
                    ];
                    type = "assignment";
                    value = {
                      recursive = false;
                      statements = [
                        {
                          operator = "=";
                          target = [
                            {
                              kind = "identifier";
                              value = "type";
                            }
                          ];
                          type = "assignment";
                          value = {
                            arguments = [
                              {
                                items = [
                                  {
                                    name = "type";
                                    path = [
                                      {
                                        kind = "identifier";
                                        value = "string";
                                      }
                                    ];
                                    type = "variable";
                                  }
                                ];
                                type = "list";
                              }
                            ];
                            callee = {
                              name = "type";
                              path = [
                                {
                                  kind = "identifier";
                                  value = "list";
                                }
                              ];
                              type = "variable";
                            };
                            type = "call";
                          };
                        }
                        {
                          operator = "=";
                          target = [
                            {
                              kind = "identifier";
                              value = "default";
                            }
                          ];
                          type = "assignment";
                          value = {
                            items = [
                              {
                                multiline = false;
                                parts = [
                                  {
                                    type = "text";
                                    value = "ctrl";
                                  }
                                ];
                                type = "string";
                              }
                              {
                                multiline = false;
                                parts = [
                                  {
                                    type = "text";
                                    value = "alt";
                                  }
                                ];
                                type = "string";
                              }
                              {
                                multiline = false;
                                parts = [
                                  {
                                    type = "text";
                                    value = "g";
                                  }
                                ];
                                type = "string";
                              }
                            ];
                            type = "list";
                          };
                        }
                        {
                          operator = "=";
                          target = [
                            {
                              kind = "identifier";
                              value = "description";
                            }
                          ];
                          type = "assignment";
                          value = {
                            multiline = true;
                            parts = [
                              {
                                type = "text";
                                value = "Snap active window to 1/3 right\n\nDefine as a list of keys, e.g., [ \"super\" \"q\" ].\nSupported modifiers: super, ctrl, alt, shift.";
                              }
                            ];
                            type = "string";
                          };
                        }
                      ];
                      type = "attr-set";
                    };
                  }
                ];
                type = "attr-set";
              };
            }
            {
              operator = "=";
              target = [
                {
                  kind = "identifier";
                  value = "window-snap-two-third-right";
                }
              ];
              type = "assignment";
              value = {
                recursive = false;
                statements = [
                  {
                    operator = "=";
                    target = [
                      {
                        kind = "identifier";
                        value = "_meta";
                      }
                    ];
                    type = "assignment";
                    value = {
                      recursive = false;
                      statements = [
                        {
                          operator = "=";
                          target = [
                            {
                              kind = "identifier";
                              value = "type";
                            }
                          ];
                          type = "assignment";
                          value = {
                            arguments = [
                              {
                                items = [
                                  {
                                    name = "type";
                                    path = [
                                      {
                                        kind = "identifier";
                                        value = "string";
                                      }
                                    ];
                                    type = "variable";
                                  }
                                ];
                                type = "list";
                              }
                            ];
                            callee = {
                              name = "type";
                              path = [
                                {
                                  kind = "identifier";
                                  value = "list";
                                }
                              ];
                              type = "variable";
                            };
                            type = "call";
                          };
                        }
                        {
                          operator = "=";
                          target = [
                            {
                              kind = "identifier";
                              value = "default";
                            }
                          ];
                          type = "assignment";
                          value = {
                            items = [
                              {
                                multiline = false;
                                parts = [
                                  {
                                    type = "text";
                                    value = "ctrl";
                                  }
                                ];
                                type = "string";
                              }
                              {
                                multiline = false;
                                parts = [
                                  {
                                    type = "text";
                                    value = "alt";
                                  }
                                ];
                                type = "string";
                              }
                              {
                                multiline = false;
                                parts = [
                                  {
                                    type = "text";
                                    value = "t";
                                  }
                                ];
                                type = "string";
                              }
                            ];
                            type = "list";
                          };
                        }
                        {
                          operator = "=";
                          target = [
                            {
                              kind = "identifier";
                              value = "description";
                            }
                          ];
                          type = "assignment";
                          value = {
                            multiline = true;
                            parts = [
                              {
                                type = "text";
                                value = "Snap active window to 2/3 right\n\nDefine as a list of keys, e.g., [ \"super\" \"q\" ].\nSupported modifiers: super, ctrl, alt, shift.";
                              }
                            ];
                            type = "string";
                          };
                        }
                      ];
                      type = "attr-set";
                    };
                  }
                ];
                type = "attr-set";
              };
            }
            {
              operator = "=";
              target = [
                {
                  kind = "identifier";
                  value = "window-snap-one-third-left";
                }
              ];
              type = "assignment";
              value = {
                recursive = false;
                statements = [
                  {
                    operator = "=";
                    target = [
                      {
                        kind = "identifier";
                        value = "_meta";
                      }
                    ];
                    type = "assignment";
                    value = {
                      recursive = false;
                      statements = [
                        {
                          operator = "=";
                          target = [
                            {
                              kind = "identifier";
                              value = "type";
                            }
                          ];
                          type = "assignment";
                          value = {
                            arguments = [
                              {
                                items = [
                                  {
                                    name = "type";
                                    path = [
                                      {
                                        kind = "identifier";
                                        value = "string";
                                      }
                                    ];
                                    type = "variable";
                                  }
                                ];
                                type = "list";
                              }
                            ];
                            callee = {
                              name = "type";
                              path = [
                                {
                                  kind = "identifier";
                                  value = "list";
                                }
                              ];
                              type = "variable";
                            };
                            type = "call";
                          };
                        }
                        {
                          operator = "=";
                          target = [
                            {
                              kind = "identifier";
                              value = "default";
                            }
                          ];
                          type = "assignment";
                          value = {
                            items = [
                              {
                                multiline = false;
                                parts = [
                                  {
                                    type = "text";
                                    value = "ctrl";
                                  }
                                ];
                                type = "string";
                              }
                              {
                                multiline = false;
                                parts = [
                                  {
                                    type = "text";
                                    value = "alt";
                                  }
                                ];
                                type = "string";
                              }
                              {
                                multiline = false;
                                parts = [
                                  {
                                    type = "text";
                                    value = "d";
                                  }
                                ];
                                type = "string";
                              }
                            ];
                            type = "list";
                          };
                        }
                        {
                          operator = "=";
                          target = [
                            {
                              kind = "identifier";
                              value = "description";
                            }
                          ];
                          type = "assignment";
                          value = {
                            multiline = true;
                            parts = [
                              {
                                type = "text";
                                value = "Snap active window to 1/3 left\n\nDefine as a list of keys, e.g., [ \"super\" \"q\" ].\nSupported modifiers: super, ctrl, alt, shift.";
                              }
                            ];
                            type = "string";
                          };
                        }
                      ];
                      type = "attr-set";
                    };
                  }
                ];
                type = "attr-set";
              };
            }
            {
              operator = "=";
              target = [
                {
                  kind = "identifier";
                  value = "window-snap-two-third-left";
                }
              ];
              type = "assignment";
              value = {
                recursive = false;
                statements = [
                  {
                    operator = "=";
                    target = [
                      {
                        kind = "identifier";
                        value = "_meta";
                      }
                    ];
                    type = "assignment";
                    value = {
                      recursive = false;
                      statements = [
                        {
                          operator = "=";
                          target = [
                            {
                              kind = "identifier";
                              value = "type";
                            }
                          ];
                          type = "assignment";
                          value = {
                            arguments = [
                              {
                                items = [
                                  {
                                    name = "type";
                                    path = [
                                      {
                                        kind = "identifier";
                                        value = "string";
                                      }
                                    ];
                                    type = "variable";
                                  }
                                ];
                                type = "list";
                              }
                            ];
                            callee = {
                              name = "type";
                              path = [
                                {
                                  kind = "identifier";
                                  value = "list";
                                }
                              ];
                              type = "variable";
                            };
                            type = "call";
                          };
                        }
                        {
                          operator = "=";
                          target = [
                            {
                              kind = "identifier";
                              value = "default";
                            }
                          ];
                          type = "assignment";
                          value = {
                            items = [
                              {
                                multiline = false;
                                parts = [
                                  {
                                    type = "text";
                                    value = "ctrl";
                                  }
                                ];
                                type = "string";
                              }
                              {
                                multiline = false;
                                parts = [
                                  {
                                    type = "text";
                                    value = "alt";
                                  }
                                ];
                                type = "string";
                              }
                              {
                                multiline = false;
                                parts = [
                                  {
                                    type = "text";
                                    value = "e";
                                  }
                                ];
                                type = "string";
                              }
                            ];
                            type = "list";
                          };
                        }
                        {
                          operator = "=";
                          target = [
                            {
                              kind = "identifier";
                              value = "description";
                            }
                          ];
                          type = "assignment";
                          value = {
                            multiline = true;
                            parts = [
                              {
                                type = "text";
                                value = "Snap active window to 2/3 left\n\nDefine as a list of keys, e.g., [ \"super\" \"q\" ].\nSupported modifiers: super, ctrl, alt, shift.";
                              }
                            ];
                            type = "string";
                          };
                        }
                      ];
                      type = "attr-set";
                    };
                  }
                ];
                type = "attr-set";
              };
            }
            {
              operator = "=";
              target = [
                {
                  kind = "identifier";
                  value = "window-snap-center";
                }
              ];
              type = "assignment";
              value = {
                recursive = false;
                statements = [
                  {
                    operator = "=";
                    target = [
                      {
                        kind = "identifier";
                        value = "_meta";
                      }
                    ];
                    type = "assignment";
                    value = {
                      recursive = false;
                      statements = [
                        {
                          operator = "=";
                          target = [
                            {
                              kind = "identifier";
                              value = "type";
                            }
                          ];
                          type = "assignment";
                          value = {
                            arguments = [
                              {
                                items = [
                                  {
                                    name = "type";
                                    path = [
                                      {
                                        kind = "identifier";
                                        value = "string";
                                      }
                                    ];
                                    type = "variable";
                                  }
                                ];
                                type = "list";
                              }
                            ];
                            callee = {
                              name = "type";
                              path = [
                                {
                                  kind = "identifier";
                                  value = "list";
                                }
                              ];
                              type = "variable";
                            };
                            type = "call";
                          };
                        }
                        {
                          operator = "=";
                          target = [
                            {
                              kind = "identifier";
                              value = "default";
                            }
                          ];
                          type = "assignment";
                          value = {
                            items = [
                              {
                                multiline = false;
                                parts = [
                                  {
                                    type = "text";
                                    value = "ctrl";
                                  }
                                ];
                                type = "string";
                              }
                              {
                                multiline = false;
                                parts = [
                                  {
                                    type = "text";
                                    value = "alt";
                                  }
                                ];
                                type = "string";
                              }
                              {
                                multiline = false;
                                parts = [
                                  {
                                    type = "text";
                                    value = "c";
                                  }
                                ];
                                type = "string";
                              }
                            ];
                            type = "list";
                          };
                        }
                        {
                          operator = "=";
                          target = [
                            {
                              kind = "identifier";
                              value = "description";
                            }
                          ];
                          type = "assignment";
                          value = {
                            multiline = true;
                            parts = [
                              {
                                type = "text";
                                value = "Snap active window to center\n\nDefine as a list of keys, e.g., [ \"super\" \"q\" ].\nSupported modifiers: super, ctrl, alt, shift.";
                              }
                            ];
                            type = "string";
                          };
                        }
                      ];
                      type = "attr-set";
                    };
                  }
                ];
                type = "attr-set";
              };
            }
            {
              operator = "=";
              target = [
                {
                  kind = "identifier";
                  value = "window-resize-left-increase";
                }
              ];
              type = "assignment";
              value = {
                recursive = false;
                statements = [
                  {
                    operator = "=";
                    target = [
                      {
                        kind = "identifier";
                        value = "_meta";
                      }
                    ];
                    type = "assignment";
                    value = {
                      recursive = false;
                      statements = [
                        {
                          operator = "=";
                          target = [
                            {
                              kind = "identifier";
                              value = "type";
                            }
                          ];
                          type = "assignment";
                          value = {
                            arguments = [
                              {
                                items = [
                                  {
                                    name = "type";
                                    path = [
                                      {
                                        kind = "identifier";
                                        value = "string";
                                      }
                                    ];
                                    type = "variable";
                                  }
                                ];
                                type = "list";
                              }
                            ];
                            callee = {
                              name = "type";
                              path = [
                                {
                                  kind = "identifier";
                                  value = "list";
                                }
                              ];
                              type = "variable";
                            };
                            type = "call";
                          };
                        }
                        {
                          operator = "=";
                          target = [
                            {
                              kind = "identifier";
                              value = "default";
                            }
                          ];
                          type = "assignment";
                          value = {
                            items = [
                              {
                                multiline = false;
                                parts = [
                                  {
                                    type = "text";
                                    value = "ctrl";
                                  }
                                ];
                                type = "string";
                              }
                              {
                                multiline = false;
                                parts = [
                                  {
                                    type = "text";
                                    value = "super";
                                  }
                                ];
                                type = "string";
                              }
                              {
                                multiline = false;
                                parts = [
                                  {
                                    type = "text";
                                    value = "y";
                                  }
                                ];
                                type = "string";
                              }
                            ];
                            type = "list";
                          };
                        }
                        {
                          operator = "=";
                          target = [
                            {
                              kind = "identifier";
                              value = "description";
                            }
                          ];
                          type = "assignment";
                          value = {
                            multiline = true;
                            parts = [
                              {
                                type = "text";
                                value = "Resize window leftwards\n\nDefine as a list of keys, e.g., [ \"super\" \"q\" ].\nSupported modifiers: super, ctrl, alt, shift.";
                              }
                            ];
                            type = "string";
                          };
                        }
                      ];
                      type = "attr-set";
                    };
                  }
                ];
                type = "attr-set";
              };
            }
            {
              operator = "=";
              target = [
                {
                  kind = "identifier";
                  value = "window-resize-left-decrease";
                }
              ];
              type = "assignment";
              value = {
                recursive = false;
                statements = [
                  {
                    operator = "=";
                    target = [
                      {
                        kind = "identifier";
                        value = "_meta";
                      }
                    ];
                    type = "assignment";
                    value = {
                      recursive = false;
                      statements = [
                        {
                          operator = "=";
                          target = [
                            {
                              kind = "identifier";
                              value = "type";
                            }
                          ];
                          type = "assignment";
                          value = {
                            arguments = [
                              {
                                items = [
                                  {
                                    name = "type";
                                    path = [
                                      {
                                        kind = "identifier";
                                        value = "string";
                                      }
                                    ];
                                    type = "variable";
                                  }
                                ];
                                type = "list";
                              }
                            ];
                            callee = {
                              name = "type";
                              path = [
                                {
                                  kind = "identifier";
                                  value = "list";
                                }
                              ];
                              type = "variable";
                            };
                            type = "call";
                          };
                        }
                        {
                          operator = "=";
                          target = [
                            {
                              kind = "identifier";
                              value = "default";
                            }
                          ];
                          type = "assignment";
                          value = {
                            items = [
                              {
                                multiline = false;
                                parts = [
                                  {
                                    type = "text";
                                    value = "ctrl";
                                  }
                                ];
                                type = "string";
                              }
                              {
                                multiline = false;
                                parts = [
                                  {
                                    type = "text";
                                    value = "shift";
                                  }
                                ];
                                type = "string";
                              }
                              {
                                multiline = false;
                                parts = [
                                  {
                                    type = "text";
                                    value = "super";
                                  }
                                ];
                                type = "string";
                              }
                              {
                                multiline = false;
                                parts = [
                                  {
                                    type = "text";
                                    value = "o";
                                  }
                                ];
                                type = "string";
                              }
                            ];
                            type = "list";
                          };
                        }
                        {
                          operator = "=";
                          target = [
                            {
                              kind = "identifier";
                              value = "description";
                            }
                          ];
                          type = "assignment";
                          value = {
                            multiline = true;
                            parts = [
                              {
                                type = "text";
                                value = "Shrink window from left\n\nDefine as a list of keys, e.g., [ \"super\" \"q\" ].\nSupported modifiers: super, ctrl, alt, shift.";
                              }
                            ];
                            type = "string";
                          };
                        }
                      ];
                      type = "attr-set";
                    };
                  }
                ];
                type = "attr-set";
              };
            }
            {
              operator = "=";
              target = [
                {
                  kind = "identifier";
                  value = "window-resize-bottom-increase";
                }
              ];
              type = "assignment";
              value = {
                recursive = false;
                statements = [
                  {
                    operator = "=";
                    target = [
                      {
                        kind = "identifier";
                        value = "_meta";
                      }
                    ];
                    type = "assignment";
                    value = {
                      recursive = false;
                      statements = [
                        {
                          operator = "=";
                          target = [
                            {
                              kind = "identifier";
                              value = "type";
                            }
                          ];
                          type = "assignment";
                          value = {
                            arguments = [
                              {
                                items = [
                                  {
                                    name = "type";
                                    path = [
                                      {
                                        kind = "identifier";
                                        value = "string";
                                      }
                                    ];
                                    type = "variable";
                                  }
                                ];
                                type = "list";
                              }
                            ];
                            callee = {
                              name = "type";
                              path = [
                                {
                                  kind = "identifier";
                                  value = "list";
                                }
                              ];
                              type = "variable";
                            };
                            type = "call";
                          };
                        }
                        {
                          operator = "=";
                          target = [
                            {
                              kind = "identifier";
                              value = "default";
                            }
                          ];
                          type = "assignment";
                          value = {
                            items = [
                              {
                                multiline = false;
                                parts = [
                                  {
                                    type = "text";
                                    value = "ctrl";
                                  }
                                ];
                                type = "string";
                              }
                              {
                                multiline = false;
                                parts = [
                                  {
                                    type = "text";
                                    value = "super";
                                  }
                                ];
                                type = "string";
                              }
                              {
                                multiline = false;
                                parts = [
                                  {
                                    type = "text";
                                    value = "u";
                                  }
                                ];
                                type = "string";
                              }
                            ];
                            type = "list";
                          };
                        }
                        {
                          operator = "=";
                          target = [
                            {
                              kind = "identifier";
                              value = "description";
                            }
                          ];
                          type = "assignment";
                          value = {
                            multiline = true;
                            parts = [
                              {
                                type = "text";
                                value = "Resize window downwards\n\nDefine as a list of keys, e.g., [ \"super\" \"q\" ].\nSupported modifiers: super, ctrl, alt, shift.";
                              }
                            ];
                            type = "string";
                          };
                        }
                      ];
                      type = "attr-set";
                    };
                  }
                ];
                type = "attr-set";
              };
            }
            {
              operator = "=";
              target = [
                {
                  kind = "identifier";
                  value = "window-resize-bottom-decrease";
                }
              ];
              type = "assignment";
              value = {
                recursive = false;
                statements = [
                  {
                    operator = "=";
                    target = [
                      {
                        kind = "identifier";
                        value = "_meta";
                      }
                    ];
                    type = "assignment";
                    value = {
                      recursive = false;
                      statements = [
                        {
                          operator = "=";
                          target = [
                            {
                              kind = "identifier";
                              value = "type";
                            }
                          ];
                          type = "assignment";
                          value = {
                            arguments = [
                              {
                                items = [
                                  {
                                    name = "type";
                                    path = [
                                      {
                                        kind = "identifier";
                                        value = "string";
                                      }
                                    ];
                                    type = "variable";
                                  }
                                ];
                                type = "list";
                              }
                            ];
                            callee = {
                              name = "type";
                              path = [
                                {
                                  kind = "identifier";
                                  value = "list";
                                }
                              ];
                              type = "variable";
                            };
                            type = "call";
                          };
                        }
                        {
                          operator = "=";
                          target = [
                            {
                              kind = "identifier";
                              value = "default";
                            }
                          ];
                          type = "assignment";
                          value = {
                            items = [
                              {
                                multiline = false;
                                parts = [
                                  {
                                    type = "text";
                                    value = "ctrl";
                                  }
                                ];
                                type = "string";
                              }
                              {
                                multiline = false;
                                parts = [
                                  {
                                    type = "text";
                                    value = "shift";
                                  }
                                ];
                                type = "string";
                              }
                              {
                                multiline = false;
                                parts = [
                                  {
                                    type = "text";
                                    value = "super";
                                  }
                                ];
                                type = "string";
                              }
                              {
                                multiline = false;
                                parts = [
                                  {
                                    type = "text";
                                    value = "i";
                                  }
                                ];
                                type = "string";
                              }
                            ];
                            type = "list";
                          };
                        }
                        {
                          operator = "=";
                          target = [
                            {
                              kind = "identifier";
                              value = "description";
                            }
                          ];
                          type = "assignment";
                          value = {
                            multiline = true;
                            parts = [
                              {
                                type = "text";
                                value = "Shrink window from bottom\n\nDefine as a list of keys, e.g., [ \"super\" \"q\" ].\nSupported modifiers: super, ctrl, alt, shift.";
                              }
                            ];
                            type = "string";
                          };
                        }
                      ];
                      type = "attr-set";
                    };
                  }
                ];
                type = "attr-set";
              };
            }
            {
              operator = "=";
              target = [
                {
                  kind = "identifier";
                  value = "window-resize-top-increase";
                }
              ];
              type = "assignment";
              value = {
                recursive = false;
                statements = [
                  {
                    operator = "=";
                    target = [
                      {
                        kind = "identifier";
                        value = "_meta";
                      }
                    ];
                    type = "assignment";
                    value = {
                      recursive = false;
                      statements = [
                        {
                          operator = "=";
                          target = [
                            {
                              kind = "identifier";
                              value = "type";
                            }
                          ];
                          type = "assignment";
                          value = {
                            arguments = [
                              {
                                items = [
                                  {
                                    name = "type";
                                    path = [
                                      {
                                        kind = "identifier";
                                        value = "string";
                                      }
                                    ];
                                    type = "variable";
                                  }
                                ];
                                type = "list";
                              }
                            ];
                            callee = {
                              name = "type";
                              path = [
                                {
                                  kind = "identifier";
                                  value = "list";
                                }
                              ];
                              type = "variable";
                            };
                            type = "call";
                          };
                        }
                        {
                          operator = "=";
                          target = [
                            {
                              kind = "identifier";
                              value = "default";
                            }
                          ];
                          type = "assignment";
                          value = {
                            items = [
                              {
                                multiline = false;
                                parts = [
                                  {
                                    type = "text";
                                    value = "ctrl";
                                  }
                                ];
                                type = "string";
                              }
                              {
                                multiline = false;
                                parts = [
                                  {
                                    type = "text";
                                    value = "super";
                                  }
                                ];
                                type = "string";
                              }
                              {
                                multiline = false;
                                parts = [
                                  {
                                    type = "text";
                                    value = "i";
                                  }
                                ];
                                type = "string";
                              }
                            ];
                            type = "list";
                          };
                        }
                        {
                          operator = "=";
                          target = [
                            {
                              kind = "identifier";
                              value = "description";
                            }
                          ];
                          type = "assignment";
                          value = {
                            multiline = true;
                            parts = [
                              {
                                type = "text";
                                value = "Resize window upwards\n\nDefine as a list of keys, e.g., [ \"super\" \"q\" ].\nSupported modifiers: super, ctrl, alt, shift.";
                              }
                            ];
                            type = "string";
                          };
                        }
                      ];
                      type = "attr-set";
                    };
                  }
                ];
                type = "attr-set";
              };
            }
            {
              operator = "=";
              target = [
                {
                  kind = "identifier";
                  value = "window-resize-top-decrease";
                }
              ];
              type = "assignment";
              value = {
                recursive = false;
                statements = [
                  {
                    operator = "=";
                    target = [
                      {
                        kind = "identifier";
                        value = "_meta";
                      }
                    ];
                    type = "assignment";
                    value = {
                      recursive = false;
                      statements = [
                        {
                          operator = "=";
                          target = [
                            {
                              kind = "identifier";
                              value = "type";
                            }
                          ];
                          type = "assignment";
                          value = {
                            arguments = [
                              {
                                items = [
                                  {
                                    name = "type";
                                    path = [
                                      {
                                        kind = "identifier";
                                        value = "string";
                                      }
                                    ];
                                    type = "variable";
                                  }
                                ];
                                type = "list";
                              }
                            ];
                            callee = {
                              name = "type";
                              path = [
                                {
                                  kind = "identifier";
                                  value = "list";
                                }
                              ];
                              type = "variable";
                            };
                            type = "call";
                          };
                        }
                        {
                          operator = "=";
                          target = [
                            {
                              kind = "identifier";
                              value = "default";
                            }
                          ];
                          type = "assignment";
                          value = {
                            items = [
                              {
                                multiline = false;
                                parts = [
                                  {
                                    type = "text";
                                    value = "ctrl";
                                  }
                                ];
                                type = "string";
                              }
                              {
                                multiline = false;
                                parts = [
                                  {
                                    type = "text";
                                    value = "shift";
                                  }
                                ];
                                type = "string";
                              }
                              {
                                multiline = false;
                                parts = [
                                  {
                                    type = "text";
                                    value = "super";
                                  }
                                ];
                                type = "string";
                              }
                              {
                                multiline = false;
                                parts = [
                                  {
                                    type = "text";
                                    value = "u";
                                  }
                                ];
                                type = "string";
                              }
                            ];
                            type = "list";
                          };
                        }
                        {
                          operator = "=";
                          target = [
                            {
                              kind = "identifier";
                              value = "description";
                            }
                          ];
                          type = "assignment";
                          value = {
                            multiline = true;
                            parts = [
                              {
                                type = "text";
                                value = "Shrink window from top\n\nDefine as a list of keys, e.g., [ \"super\" \"q\" ].\nSupported modifiers: super, ctrl, alt, shift.";
                              }
                            ];
                            type = "string";
                          };
                        }
                      ];
                      type = "attr-set";
                    };
                  }
                ];
                type = "attr-set";
              };
            }
            {
              operator = "=";
              target = [
                {
                  kind = "identifier";
                  value = "window-resize-right-increase";
                }
              ];
              type = "assignment";
              value = {
                recursive = false;
                statements = [
                  {
                    operator = "=";
                    target = [
                      {
                        kind = "identifier";
                        value = "_meta";
                      }
                    ];
                    type = "assignment";
                    value = {
                      recursive = false;
                      statements = [
                        {
                          operator = "=";
                          target = [
                            {
                              kind = "identifier";
                              value = "type";
                            }
                          ];
                          type = "assignment";
                          value = {
                            arguments = [
                              {
                                items = [
                                  {
                                    name = "type";
                                    path = [
                                      {
                                        kind = "identifier";
                                        value = "string";
                                      }
                                    ];
                                    type = "variable";
                                  }
                                ];
                                type = "list";
                              }
                            ];
                            callee = {
                              name = "type";
                              path = [
                                {
                                  kind = "identifier";
                                  value = "list";
                                }
                              ];
                              type = "variable";
                            };
                            type = "call";
                          };
                        }
                        {
                          operator = "=";
                          target = [
                            {
                              kind = "identifier";
                              value = "default";
                            }
                          ];
                          type = "assignment";
                          value = {
                            items = [
                              {
                                multiline = false;
                                parts = [
                                  {
                                    type = "text";
                                    value = "ctrl";
                                  }
                                ];
                                type = "string";
                              }
                              {
                                multiline = false;
                                parts = [
                                  {
                                    type = "text";
                                    value = "super";
                                  }
                                ];
                                type = "string";
                              }
                              {
                                multiline = false;
                                parts = [
                                  {
                                    type = "text";
                                    value = "o";
                                  }
                                ];
                                type = "string";
                              }
                            ];
                            type = "list";
                          };
                        }
                        {
                          operator = "=";
                          target = [
                            {
                              kind = "identifier";
                              value = "description";
                            }
                          ];
                          type = "assignment";
                          value = {
                            multiline = true;
                            parts = [
                              {
                                type = "text";
                                value = "Resize window rightwards\n\nDefine as a list of keys, e.g., [ \"super\" \"q\" ].\nSupported modifiers: super, ctrl, alt, shift.";
                              }
                            ];
                            type = "string";
                          };
                        }
                      ];
                      type = "attr-set";
                    };
                  }
                ];
                type = "attr-set";
              };
            }
            {
              operator = "=";
              target = [
                {
                  kind = "identifier";
                  value = "window-resize-right-decrease";
                }
              ];
              type = "assignment";
              value = {
                recursive = false;
                statements = [
                  {
                    operator = "=";
                    target = [
                      {
                        kind = "identifier";
                        value = "_meta";
                      }
                    ];
                    type = "assignment";
                    value = {
                      recursive = false;
                      statements = [
                        {
                          operator = "=";
                          target = [
                            {
                              kind = "identifier";
                              value = "type";
                            }
                          ];
                          type = "assignment";
                          value = {
                            arguments = [
                              {
                                items = [
                                  {
                                    name = "type";
                                    path = [
                                      {
                                        kind = "identifier";
                                        value = "string";
                                      }
                                    ];
                                    type = "variable";
                                  }
                                ];
                                type = "list";
                              }
                            ];
                            callee = {
                              name = "type";
                              path = [
                                {
                                  kind = "identifier";
                                  value = "list";
                                }
                              ];
                              type = "variable";
                            };
                            type = "call";
                          };
                        }
                        {
                          operator = "=";
                          target = [
                            {
                              kind = "identifier";
                              value = "default";
                            }
                          ];
                          type = "assignment";
                          value = {
                            items = [
                              {
                                multiline = false;
                                parts = [
                                  {
                                    type = "text";
                                    value = "ctrl";
                                  }
                                ];
                                type = "string";
                              }
                              {
                                multiline = false;
                                parts = [
                                  {
                                    type = "text";
                                    value = "shift";
                                  }
                                ];
                                type = "string";
                              }
                              {
                                multiline = false;
                                parts = [
                                  {
                                    type = "text";
                                    value = "super";
                                  }
                                ];
                                type = "string";
                              }
                              {
                                multiline = false;
                                parts = [
                                  {
                                    type = "text";
                                    value = "y";
                                  }
                                ];
                                type = "string";
                              }
                            ];
                            type = "list";
                          };
                        }
                        {
                          operator = "=";
                          target = [
                            {
                              kind = "identifier";
                              value = "description";
                            }
                          ];
                          type = "assignment";
                          value = {
                            multiline = true;
                            parts = [
                              {
                                type = "text";
                                value = "Shrink window from right\n\nDefine as a list of keys, e.g., [ \"super\" \"q\" ].\nSupported modifiers: super, ctrl, alt, shift.";
                              }
                            ];
                            type = "string";
                          };
                        }
                      ];
                      type = "attr-set";
                    };
                  }
                ];
                type = "attr-set";
              };
            }
          ];
          type = "attr-set";
        };
      }
    ];
  }; }
    (let formatPart = (builtins.addErrorContext "_let formatPart annotation mismatch: /nix/store/3ni594f60hm22hcrazxd35dmk7pwi61m-zenpkgs-dsl-source/modules/desktops/gnome/extensions/forge.zmdl:21:1" ((_zenType: _zenValue: let force = type: value: if type.name == "anything" then true else if type.name == "listOf" then builtins.all (force type.nestedTypes.elemType) value else if type.name == "attrsOf" then builtins.all (force type.nestedTypes.elemType) (builtins.attrValues value) else if type.name == "either" then force (if type.nestedTypes.left.check value then type.nestedTypes.left else type.nestedTypes.right) value else builtins.seq value true; in builtins.seq (force _zenType _zenValue) _zenValue) ((lib.types.addCheck lib.types.unspecified builtins.isFunction)) ((lib.evalModules { modules = [ { options.value = lib.mkOption { type = (lib.types.addCheck lib.types.unspecified builtins.isFunction); }; config.value = (part: (let
  lower = (lib.toLower part);
in (if (lower == "super") then "<Super>" else (if ((lower == "ctrl") || (lower == "control")) then "<Ctrl>" else (if (lower == "alt") then "<Alt>" else (if (lower == "shift") then "<Shift>" else part)))))); } ]; }).config.value))); serializeKeybind = (builtins.addErrorContext "_let serializeKeybind annotation mismatch: /nix/store/3ni594f60hm22hcrazxd35dmk7pwi61m-zenpkgs-dsl-source/modules/desktops/gnome/extensions/forge.zmdl:28:1" ((_zenType: _zenValue: let force = type: value: if type.name == "anything" then true else if type.name == "listOf" then builtins.all (force type.nestedTypes.elemType) value else if type.name == "attrsOf" then builtins.all (force type.nestedTypes.elemType) (builtins.attrValues value) else if type.name == "either" then force (if type.nestedTypes.left.check value then type.nestedTypes.left else type.nestedTypes.right) value else builtins.seq value true; in builtins.seq (force _zenType _zenValue) _zenValue) ((lib.types.addCheck lib.types.unspecified builtins.isFunction)) ((lib.evalModules { modules = [ { options.value = lib.mkOption { type = (lib.types.addCheck lib.types.unspecified builtins.isFunction); }; config.value = (values: [
  (((lib.concatMapStrings formatPart) values))
]); } ]; }).config.value))); hexToDecMap = (builtins.addErrorContext "_let hexToDecMap annotation mismatch: /nix/store/3ni594f60hm22hcrazxd35dmk7pwi61m-zenpkgs-dsl-source/modules/desktops/gnome/extensions/forge.zmdl:29:1" ((_zenType: _zenValue: let force = type: value: if type.name == "anything" then true else if type.name == "listOf" then builtins.all (force type.nestedTypes.elemType) value else if type.name == "attrsOf" then builtins.all (force type.nestedTypes.elemType) (builtins.attrValues value) else if type.name == "either" then force (if type.nestedTypes.left.check value then type.nestedTypes.left else type.nestedTypes.right) value else builtins.seq value true; in builtins.seq (force _zenType _zenValue) _zenValue) ((lib.types.attrsOf lib.types.int)) ((lib.evalModules { modules = [ { options.value = lib.mkOption { type = (lib.types.attrsOf lib.types.int); }; config.value = {
  "0" = 0;
  "1" = 1;
  "2" = 2;
  "3" = 3;
  "4" = 4;
  "5" = 5;
  "6" = 6;
  "7" = 7;
  "8" = 8;
  "9" = 9;
  "a" = 10;
  "b" = 11;
  "c" = 12;
  "d" = 13;
  "e" = 14;
  "f" = 15;
  "A" = 10;
  "B" = 11;
  "C" = 12;
  "D" = 13;
  "E" = 14;
  "F" = 15;
}; } ]; }).config.value))); hexCharToInt = (builtins.addErrorContext "_let hexCharToInt annotation mismatch: /nix/store/3ni594f60hm22hcrazxd35dmk7pwi61m-zenpkgs-dsl-source/modules/desktops/gnome/extensions/forge.zmdl:30:1" ((_zenType: _zenValue: let force = type: value: if type.name == "anything" then true else if type.name == "listOf" then builtins.all (force type.nestedTypes.elemType) value else if type.name == "attrsOf" then builtins.all (force type.nestedTypes.elemType) (builtins.attrValues value) else if type.name == "either" then force (if type.nestedTypes.left.check value then type.nestedTypes.left else type.nestedTypes.right) value else builtins.seq value true; in builtins.seq (force _zenType _zenValue) _zenValue) ((lib.types.addCheck lib.types.unspecified builtins.isFunction)) ((lib.evalModules { modules = [ { options.value = lib.mkOption { type = (lib.types.addCheck lib.types.unspecified builtins.isFunction); }; config.value = (c: (if ((lib.hasAttr c) hexToDecMap) then ((lib.getAttr c) hexToDecMap) else 0)); } ]; }).config.value))); parseHexByte = (builtins.addErrorContext "_let parseHexByte annotation mismatch: /nix/store/3ni594f60hm22hcrazxd35dmk7pwi61m-zenpkgs-dsl-source/modules/desktops/gnome/extensions/forge.zmdl:31:1" ((_zenType: _zenValue: let force = type: value: if type.name == "anything" then true else if type.name == "listOf" then builtins.all (force type.nestedTypes.elemType) value else if type.name == "attrsOf" then builtins.all (force type.nestedTypes.elemType) (builtins.attrValues value) else if type.name == "either" then force (if type.nestedTypes.left.check value then type.nestedTypes.left else type.nestedTypes.right) value else builtins.seq value true; in builtins.seq (force _zenType _zenValue) _zenValue) ((lib.types.addCheck lib.types.unspecified builtins.isFunction)) ((lib.evalModules { modules = [ { options.value = lib.mkOption { type = (lib.types.addCheck lib.types.unspecified builtins.isFunction); }; config.value = (str: ((((hexCharToInt ((((lib.substring 0) 1) str))) * 16)) + (hexCharToInt ((((lib.substring 1) 1) str))))); } ]; }).config.value))); serializeFloat = (builtins.addErrorContext "_let serializeFloat annotation mismatch: /nix/store/3ni594f60hm22hcrazxd35dmk7pwi61m-zenpkgs-dsl-source/modules/desktops/gnome/extensions/forge.zmdl:32:1" ((_zenType: _zenValue: let force = type: value: if type.name == "anything" then true else if type.name == "listOf" then builtins.all (force type.nestedTypes.elemType) value else if type.name == "attrsOf" then builtins.all (force type.nestedTypes.elemType) (builtins.attrValues value) else if type.name == "either" then force (if type.nestedTypes.left.check value then type.nestedTypes.left else type.nestedTypes.right) value else builtins.seq value true; in builtins.seq (force _zenType _zenValue) _zenValue) ((lib.types.addCheck lib.types.unspecified builtins.isFunction)) ((lib.evalModules { modules = [ { options.value = lib.mkOption { type = (lib.types.addCheck lib.types.unspecified builtins.isFunction); }; config.value = (value: (let
  str = (lib.toString value);
in (if ((lib.hasInfix ".") str) then str else "${((value: let kind = builtins.typeOf value; in if kind == "string" then value else if kind == "bool" || kind == "int" || kind == "float" then builtins.toJSON value else if kind == "path" then "${value}" else if kind == "set" && (value.type or null) == "derivation" && builtins.isString (value.outPath or null) then value.outPath else throw "/nix/store/3ni594f60hm22hcrazxd35dmk7pwi61m-zenpkgs-dsl-source/modules/desktops/gnome/extensions/forge.zmdl:32: string interpolation requires a scalar, path, or package") (str))}.0"))); } ]; }).config.value))); toRgbaString = (builtins.addErrorContext "_let toRgbaString annotation mismatch: /nix/store/3ni594f60hm22hcrazxd35dmk7pwi61m-zenpkgs-dsl-source/modules/desktops/gnome/extensions/forge.zmdl:33:1" ((_zenType: _zenValue: let force = type: value: if type.name == "anything" then true else if type.name == "listOf" then builtins.all (force type.nestedTypes.elemType) value else if type.name == "attrsOf" then builtins.all (force type.nestedTypes.elemType) (builtins.attrValues value) else if type.name == "either" then force (if type.nestedTypes.left.check value then type.nestedTypes.left else type.nestedTypes.right) value else builtins.seq value true; in builtins.seq (force _zenType _zenValue) _zenValue) ((lib.types.addCheck lib.types.unspecified builtins.isFunction)) ((lib.evalModules { modules = [ { options.value = lib.mkOption { type = (lib.types.addCheck lib.types.unspecified builtins.isFunction); }; config.value = (value: (if ((lib.isString value) && ((lib.hasPrefix "#") value)) then (let
  hex = ((lib.removePrefix "#") value);
  r = (lib.toString ((parseHexByte ((((lib.substring 0) 2) hex)))));
  g = (lib.toString ((parseHexByte ((((lib.substring 2) 2) hex)))));
  b = (lib.toString ((parseHexByte ((((lib.substring 4) 2) hex)))));
  a = (if ((lib.stringLength hex) == 8) then (serializeFloat (((parseHexByte ((((lib.substring 6) 2) hex))) / 255.0))) else "1.0");
in "rgba(${((value: let kind = builtins.typeOf value; in if kind == "string" then value else if kind == "bool" || kind == "int" || kind == "float" then builtins.toJSON value else if kind == "path" then "${value}" else if kind == "set" && (value.type or null) == "derivation" && builtins.isString (value.outPath or null) then value.outPath else throw "/nix/store/3ni594f60hm22hcrazxd35dmk7pwi61m-zenpkgs-dsl-source/modules/desktops/gnome/extensions/forge.zmdl:41: string interpolation requires a scalar, path, or package") (r))}, ${((value: let kind = builtins.typeOf value; in if kind == "string" then value else if kind == "bool" || kind == "int" || kind == "float" then builtins.toJSON value else if kind == "path" then "${value}" else if kind == "set" && (value.type or null) == "derivation" && builtins.isString (value.outPath or null) then value.outPath else throw "/nix/store/3ni594f60hm22hcrazxd35dmk7pwi61m-zenpkgs-dsl-source/modules/desktops/gnome/extensions/forge.zmdl:41: string interpolation requires a scalar, path, or package") (g))}, ${((value: let kind = builtins.typeOf value; in if kind == "string" then value else if kind == "bool" || kind == "int" || kind == "float" then builtins.toJSON value else if kind == "path" then "${value}" else if kind == "set" && (value.type or null) == "derivation" && builtins.isString (value.outPath or null) then value.outPath else throw "/nix/store/3ni594f60hm22hcrazxd35dmk7pwi61m-zenpkgs-dsl-source/modules/desktops/gnome/extensions/forge.zmdl:41: string interpolation requires a scalar, path, or package") (b))}, ${((value: let kind = builtins.typeOf value; in if kind == "string" then value else if kind == "bool" || kind == "int" || kind == "float" then builtins.toJSON value else if kind == "path" then "${value}" else if kind == "set" && (value.type or null) == "derivation" && builtins.isString (value.outPath or null) then value.outPath else throw "/nix/store/3ni594f60hm22hcrazxd35dmk7pwi61m-zenpkgs-dsl-source/modules/desktops/gnome/extensions/forge.zmdl:41: string interpolation requires a scalar, path, or package") (a))})") else value)); } ]; }).config.value))); in (lib.mkIf ((cfg.enable)) {
      environment.systemPackages = [
        pkgs.zenos.byCategories.desktops.gnome.extensions.forge
      ];
    }))
    (let formatPart = (builtins.addErrorContext "_let formatPart annotation mismatch: /nix/store/3ni594f60hm22hcrazxd35dmk7pwi61m-zenpkgs-dsl-source/modules/desktops/gnome/extensions/forge.zmdl:21:1" ((_zenType: _zenValue: let force = type: value: if type.name == "anything" then true else if type.name == "listOf" then builtins.all (force type.nestedTypes.elemType) value else if type.name == "attrsOf" then builtins.all (force type.nestedTypes.elemType) (builtins.attrValues value) else if type.name == "either" then force (if type.nestedTypes.left.check value then type.nestedTypes.left else type.nestedTypes.right) value else builtins.seq value true; in builtins.seq (force _zenType _zenValue) _zenValue) ((lib.types.addCheck lib.types.unspecified builtins.isFunction)) ((lib.evalModules { modules = [ { options.value = lib.mkOption { type = (lib.types.addCheck lib.types.unspecified builtins.isFunction); }; config.value = (part: (let
  lower = (lib.toLower part);
in (if (lower == "super") then "<Super>" else (if ((lower == "ctrl") || (lower == "control")) then "<Ctrl>" else (if (lower == "alt") then "<Alt>" else (if (lower == "shift") then "<Shift>" else part)))))); } ]; }).config.value))); serializeKeybind = (builtins.addErrorContext "_let serializeKeybind annotation mismatch: /nix/store/3ni594f60hm22hcrazxd35dmk7pwi61m-zenpkgs-dsl-source/modules/desktops/gnome/extensions/forge.zmdl:28:1" ((_zenType: _zenValue: let force = type: value: if type.name == "anything" then true else if type.name == "listOf" then builtins.all (force type.nestedTypes.elemType) value else if type.name == "attrsOf" then builtins.all (force type.nestedTypes.elemType) (builtins.attrValues value) else if type.name == "either" then force (if type.nestedTypes.left.check value then type.nestedTypes.left else type.nestedTypes.right) value else builtins.seq value true; in builtins.seq (force _zenType _zenValue) _zenValue) ((lib.types.addCheck lib.types.unspecified builtins.isFunction)) ((lib.evalModules { modules = [ { options.value = lib.mkOption { type = (lib.types.addCheck lib.types.unspecified builtins.isFunction); }; config.value = (values: [
  (((lib.concatMapStrings formatPart) values))
]); } ]; }).config.value))); hexToDecMap = (builtins.addErrorContext "_let hexToDecMap annotation mismatch: /nix/store/3ni594f60hm22hcrazxd35dmk7pwi61m-zenpkgs-dsl-source/modules/desktops/gnome/extensions/forge.zmdl:29:1" ((_zenType: _zenValue: let force = type: value: if type.name == "anything" then true else if type.name == "listOf" then builtins.all (force type.nestedTypes.elemType) value else if type.name == "attrsOf" then builtins.all (force type.nestedTypes.elemType) (builtins.attrValues value) else if type.name == "either" then force (if type.nestedTypes.left.check value then type.nestedTypes.left else type.nestedTypes.right) value else builtins.seq value true; in builtins.seq (force _zenType _zenValue) _zenValue) ((lib.types.attrsOf lib.types.int)) ((lib.evalModules { modules = [ { options.value = lib.mkOption { type = (lib.types.attrsOf lib.types.int); }; config.value = {
  "0" = 0;
  "1" = 1;
  "2" = 2;
  "3" = 3;
  "4" = 4;
  "5" = 5;
  "6" = 6;
  "7" = 7;
  "8" = 8;
  "9" = 9;
  "a" = 10;
  "b" = 11;
  "c" = 12;
  "d" = 13;
  "e" = 14;
  "f" = 15;
  "A" = 10;
  "B" = 11;
  "C" = 12;
  "D" = 13;
  "E" = 14;
  "F" = 15;
}; } ]; }).config.value))); hexCharToInt = (builtins.addErrorContext "_let hexCharToInt annotation mismatch: /nix/store/3ni594f60hm22hcrazxd35dmk7pwi61m-zenpkgs-dsl-source/modules/desktops/gnome/extensions/forge.zmdl:30:1" ((_zenType: _zenValue: let force = type: value: if type.name == "anything" then true else if type.name == "listOf" then builtins.all (force type.nestedTypes.elemType) value else if type.name == "attrsOf" then builtins.all (force type.nestedTypes.elemType) (builtins.attrValues value) else if type.name == "either" then force (if type.nestedTypes.left.check value then type.nestedTypes.left else type.nestedTypes.right) value else builtins.seq value true; in builtins.seq (force _zenType _zenValue) _zenValue) ((lib.types.addCheck lib.types.unspecified builtins.isFunction)) ((lib.evalModules { modules = [ { options.value = lib.mkOption { type = (lib.types.addCheck lib.types.unspecified builtins.isFunction); }; config.value = (c: (if ((lib.hasAttr c) hexToDecMap) then ((lib.getAttr c) hexToDecMap) else 0)); } ]; }).config.value))); parseHexByte = (builtins.addErrorContext "_let parseHexByte annotation mismatch: /nix/store/3ni594f60hm22hcrazxd35dmk7pwi61m-zenpkgs-dsl-source/modules/desktops/gnome/extensions/forge.zmdl:31:1" ((_zenType: _zenValue: let force = type: value: if type.name == "anything" then true else if type.name == "listOf" then builtins.all (force type.nestedTypes.elemType) value else if type.name == "attrsOf" then builtins.all (force type.nestedTypes.elemType) (builtins.attrValues value) else if type.name == "either" then force (if type.nestedTypes.left.check value then type.nestedTypes.left else type.nestedTypes.right) value else builtins.seq value true; in builtins.seq (force _zenType _zenValue) _zenValue) ((lib.types.addCheck lib.types.unspecified builtins.isFunction)) ((lib.evalModules { modules = [ { options.value = lib.mkOption { type = (lib.types.addCheck lib.types.unspecified builtins.isFunction); }; config.value = (str: ((((hexCharToInt ((((lib.substring 0) 1) str))) * 16)) + (hexCharToInt ((((lib.substring 1) 1) str))))); } ]; }).config.value))); serializeFloat = (builtins.addErrorContext "_let serializeFloat annotation mismatch: /nix/store/3ni594f60hm22hcrazxd35dmk7pwi61m-zenpkgs-dsl-source/modules/desktops/gnome/extensions/forge.zmdl:32:1" ((_zenType: _zenValue: let force = type: value: if type.name == "anything" then true else if type.name == "listOf" then builtins.all (force type.nestedTypes.elemType) value else if type.name == "attrsOf" then builtins.all (force type.nestedTypes.elemType) (builtins.attrValues value) else if type.name == "either" then force (if type.nestedTypes.left.check value then type.nestedTypes.left else type.nestedTypes.right) value else builtins.seq value true; in builtins.seq (force _zenType _zenValue) _zenValue) ((lib.types.addCheck lib.types.unspecified builtins.isFunction)) ((lib.evalModules { modules = [ { options.value = lib.mkOption { type = (lib.types.addCheck lib.types.unspecified builtins.isFunction); }; config.value = (value: (let
  str = (lib.toString value);
in (if ((lib.hasInfix ".") str) then str else "${((value: let kind = builtins.typeOf value; in if kind == "string" then value else if kind == "bool" || kind == "int" || kind == "float" then builtins.toJSON value else if kind == "path" then "${value}" else if kind == "set" && (value.type or null) == "derivation" && builtins.isString (value.outPath or null) then value.outPath else throw "/nix/store/3ni594f60hm22hcrazxd35dmk7pwi61m-zenpkgs-dsl-source/modules/desktops/gnome/extensions/forge.zmdl:32: string interpolation requires a scalar, path, or package") (str))}.0"))); } ]; }).config.value))); toRgbaString = (builtins.addErrorContext "_let toRgbaString annotation mismatch: /nix/store/3ni594f60hm22hcrazxd35dmk7pwi61m-zenpkgs-dsl-source/modules/desktops/gnome/extensions/forge.zmdl:33:1" ((_zenType: _zenValue: let force = type: value: if type.name == "anything" then true else if type.name == "listOf" then builtins.all (force type.nestedTypes.elemType) value else if type.name == "attrsOf" then builtins.all (force type.nestedTypes.elemType) (builtins.attrValues value) else if type.name == "either" then force (if type.nestedTypes.left.check value then type.nestedTypes.left else type.nestedTypes.right) value else builtins.seq value true; in builtins.seq (force _zenType _zenValue) _zenValue) ((lib.types.addCheck lib.types.unspecified builtins.isFunction)) ((lib.evalModules { modules = [ { options.value = lib.mkOption { type = (lib.types.addCheck lib.types.unspecified builtins.isFunction); }; config.value = (value: (if ((lib.isString value) && ((lib.hasPrefix "#") value)) then (let
  hex = ((lib.removePrefix "#") value);
  r = (lib.toString ((parseHexByte ((((lib.substring 0) 2) hex)))));
  g = (lib.toString ((parseHexByte ((((lib.substring 2) 2) hex)))));
  b = (lib.toString ((parseHexByte ((((lib.substring 4) 2) hex)))));
  a = (if ((lib.stringLength hex) == 8) then (serializeFloat (((parseHexByte ((((lib.substring 6) 2) hex))) / 255.0))) else "1.0");
in "rgba(${((value: let kind = builtins.typeOf value; in if kind == "string" then value else if kind == "bool" || kind == "int" || kind == "float" then builtins.toJSON value else if kind == "path" then "${value}" else if kind == "set" && (value.type or null) == "derivation" && builtins.isString (value.outPath or null) then value.outPath else throw "/nix/store/3ni594f60hm22hcrazxd35dmk7pwi61m-zenpkgs-dsl-source/modules/desktops/gnome/extensions/forge.zmdl:41: string interpolation requires a scalar, path, or package") (r))}, ${((value: let kind = builtins.typeOf value; in if kind == "string" then value else if kind == "bool" || kind == "int" || kind == "float" then builtins.toJSON value else if kind == "path" then "${value}" else if kind == "set" && (value.type or null) == "derivation" && builtins.isString (value.outPath or null) then value.outPath else throw "/nix/store/3ni594f60hm22hcrazxd35dmk7pwi61m-zenpkgs-dsl-source/modules/desktops/gnome/extensions/forge.zmdl:41: string interpolation requires a scalar, path, or package") (g))}, ${((value: let kind = builtins.typeOf value; in if kind == "string" then value else if kind == "bool" || kind == "int" || kind == "float" then builtins.toJSON value else if kind == "path" then "${value}" else if kind == "set" && (value.type or null) == "derivation" && builtins.isString (value.outPath or null) then value.outPath else throw "/nix/store/3ni594f60hm22hcrazxd35dmk7pwi61m-zenpkgs-dsl-source/modules/desktops/gnome/extensions/forge.zmdl:41: string interpolation requires a scalar, path, or package") (b))}, ${((value: let kind = builtins.typeOf value; in if kind == "string" then value else if kind == "bool" || kind == "int" || kind == "float" then builtins.toJSON value else if kind == "path" then "${value}" else if kind == "set" && (value.type or null) == "derivation" && builtins.isString (value.outPath or null) then value.outPath else throw "/nix/store/3ni594f60hm22hcrazxd35dmk7pwi61m-zenpkgs-dsl-source/modules/desktops/gnome/extensions/forge.zmdl:41: string interpolation requires a scalar, path, or package") (a))})") else value)); } ]; }).config.value))); in (lib.mkIf ((cfg.enable)) { home-manager.sharedModules = [ {
      dconf.settings."org/gnome/mutter".auto-maximize = (lib.mkDefault false);
      dconf.settings."org/gnome/shell".enabled-extensions = [
        pkgs.zenos.byCategories.desktops.gnome.extensions.forge.extensionUuid
      ];
    } ]; }))
    (let formatPart = (builtins.addErrorContext "_let formatPart annotation mismatch: /nix/store/3ni594f60hm22hcrazxd35dmk7pwi61m-zenpkgs-dsl-source/modules/desktops/gnome/extensions/forge.zmdl:21:1" ((_zenType: _zenValue: let force = type: value: if type.name == "anything" then true else if type.name == "listOf" then builtins.all (force type.nestedTypes.elemType) value else if type.name == "attrsOf" then builtins.all (force type.nestedTypes.elemType) (builtins.attrValues value) else if type.name == "either" then force (if type.nestedTypes.left.check value then type.nestedTypes.left else type.nestedTypes.right) value else builtins.seq value true; in builtins.seq (force _zenType _zenValue) _zenValue) ((lib.types.addCheck lib.types.unspecified builtins.isFunction)) ((lib.evalModules { modules = [ { options.value = lib.mkOption { type = (lib.types.addCheck lib.types.unspecified builtins.isFunction); }; config.value = (part: (let
  lower = (lib.toLower part);
in (if (lower == "super") then "<Super>" else (if ((lower == "ctrl") || (lower == "control")) then "<Ctrl>" else (if (lower == "alt") then "<Alt>" else (if (lower == "shift") then "<Shift>" else part)))))); } ]; }).config.value))); serializeKeybind = (builtins.addErrorContext "_let serializeKeybind annotation mismatch: /nix/store/3ni594f60hm22hcrazxd35dmk7pwi61m-zenpkgs-dsl-source/modules/desktops/gnome/extensions/forge.zmdl:28:1" ((_zenType: _zenValue: let force = type: value: if type.name == "anything" then true else if type.name == "listOf" then builtins.all (force type.nestedTypes.elemType) value else if type.name == "attrsOf" then builtins.all (force type.nestedTypes.elemType) (builtins.attrValues value) else if type.name == "either" then force (if type.nestedTypes.left.check value then type.nestedTypes.left else type.nestedTypes.right) value else builtins.seq value true; in builtins.seq (force _zenType _zenValue) _zenValue) ((lib.types.addCheck lib.types.unspecified builtins.isFunction)) ((lib.evalModules { modules = [ { options.value = lib.mkOption { type = (lib.types.addCheck lib.types.unspecified builtins.isFunction); }; config.value = (values: [
  (((lib.concatMapStrings formatPart) values))
]); } ]; }).config.value))); hexToDecMap = (builtins.addErrorContext "_let hexToDecMap annotation mismatch: /nix/store/3ni594f60hm22hcrazxd35dmk7pwi61m-zenpkgs-dsl-source/modules/desktops/gnome/extensions/forge.zmdl:29:1" ((_zenType: _zenValue: let force = type: value: if type.name == "anything" then true else if type.name == "listOf" then builtins.all (force type.nestedTypes.elemType) value else if type.name == "attrsOf" then builtins.all (force type.nestedTypes.elemType) (builtins.attrValues value) else if type.name == "either" then force (if type.nestedTypes.left.check value then type.nestedTypes.left else type.nestedTypes.right) value else builtins.seq value true; in builtins.seq (force _zenType _zenValue) _zenValue) ((lib.types.attrsOf lib.types.int)) ((lib.evalModules { modules = [ { options.value = lib.mkOption { type = (lib.types.attrsOf lib.types.int); }; config.value = {
  "0" = 0;
  "1" = 1;
  "2" = 2;
  "3" = 3;
  "4" = 4;
  "5" = 5;
  "6" = 6;
  "7" = 7;
  "8" = 8;
  "9" = 9;
  "a" = 10;
  "b" = 11;
  "c" = 12;
  "d" = 13;
  "e" = 14;
  "f" = 15;
  "A" = 10;
  "B" = 11;
  "C" = 12;
  "D" = 13;
  "E" = 14;
  "F" = 15;
}; } ]; }).config.value))); hexCharToInt = (builtins.addErrorContext "_let hexCharToInt annotation mismatch: /nix/store/3ni594f60hm22hcrazxd35dmk7pwi61m-zenpkgs-dsl-source/modules/desktops/gnome/extensions/forge.zmdl:30:1" ((_zenType: _zenValue: let force = type: value: if type.name == "anything" then true else if type.name == "listOf" then builtins.all (force type.nestedTypes.elemType) value else if type.name == "attrsOf" then builtins.all (force type.nestedTypes.elemType) (builtins.attrValues value) else if type.name == "either" then force (if type.nestedTypes.left.check value then type.nestedTypes.left else type.nestedTypes.right) value else builtins.seq value true; in builtins.seq (force _zenType _zenValue) _zenValue) ((lib.types.addCheck lib.types.unspecified builtins.isFunction)) ((lib.evalModules { modules = [ { options.value = lib.mkOption { type = (lib.types.addCheck lib.types.unspecified builtins.isFunction); }; config.value = (c: (if ((lib.hasAttr c) hexToDecMap) then ((lib.getAttr c) hexToDecMap) else 0)); } ]; }).config.value))); parseHexByte = (builtins.addErrorContext "_let parseHexByte annotation mismatch: /nix/store/3ni594f60hm22hcrazxd35dmk7pwi61m-zenpkgs-dsl-source/modules/desktops/gnome/extensions/forge.zmdl:31:1" ((_zenType: _zenValue: let force = type: value: if type.name == "anything" then true else if type.name == "listOf" then builtins.all (force type.nestedTypes.elemType) value else if type.name == "attrsOf" then builtins.all (force type.nestedTypes.elemType) (builtins.attrValues value) else if type.name == "either" then force (if type.nestedTypes.left.check value then type.nestedTypes.left else type.nestedTypes.right) value else builtins.seq value true; in builtins.seq (force _zenType _zenValue) _zenValue) ((lib.types.addCheck lib.types.unspecified builtins.isFunction)) ((lib.evalModules { modules = [ { options.value = lib.mkOption { type = (lib.types.addCheck lib.types.unspecified builtins.isFunction); }; config.value = (str: ((((hexCharToInt ((((lib.substring 0) 1) str))) * 16)) + (hexCharToInt ((((lib.substring 1) 1) str))))); } ]; }).config.value))); serializeFloat = (builtins.addErrorContext "_let serializeFloat annotation mismatch: /nix/store/3ni594f60hm22hcrazxd35dmk7pwi61m-zenpkgs-dsl-source/modules/desktops/gnome/extensions/forge.zmdl:32:1" ((_zenType: _zenValue: let force = type: value: if type.name == "anything" then true else if type.name == "listOf" then builtins.all (force type.nestedTypes.elemType) value else if type.name == "attrsOf" then builtins.all (force type.nestedTypes.elemType) (builtins.attrValues value) else if type.name == "either" then force (if type.nestedTypes.left.check value then type.nestedTypes.left else type.nestedTypes.right) value else builtins.seq value true; in builtins.seq (force _zenType _zenValue) _zenValue) ((lib.types.addCheck lib.types.unspecified builtins.isFunction)) ((lib.evalModules { modules = [ { options.value = lib.mkOption { type = (lib.types.addCheck lib.types.unspecified builtins.isFunction); }; config.value = (value: (let
  str = (lib.toString value);
in (if ((lib.hasInfix ".") str) then str else "${((value: let kind = builtins.typeOf value; in if kind == "string" then value else if kind == "bool" || kind == "int" || kind == "float" then builtins.toJSON value else if kind == "path" then "${value}" else if kind == "set" && (value.type or null) == "derivation" && builtins.isString (value.outPath or null) then value.outPath else throw "/nix/store/3ni594f60hm22hcrazxd35dmk7pwi61m-zenpkgs-dsl-source/modules/desktops/gnome/extensions/forge.zmdl:32: string interpolation requires a scalar, path, or package") (str))}.0"))); } ]; }).config.value))); toRgbaString = (builtins.addErrorContext "_let toRgbaString annotation mismatch: /nix/store/3ni594f60hm22hcrazxd35dmk7pwi61m-zenpkgs-dsl-source/modules/desktops/gnome/extensions/forge.zmdl:33:1" ((_zenType: _zenValue: let force = type: value: if type.name == "anything" then true else if type.name == "listOf" then builtins.all (force type.nestedTypes.elemType) value else if type.name == "attrsOf" then builtins.all (force type.nestedTypes.elemType) (builtins.attrValues value) else if type.name == "either" then force (if type.nestedTypes.left.check value then type.nestedTypes.left else type.nestedTypes.right) value else builtins.seq value true; in builtins.seq (force _zenType _zenValue) _zenValue) ((lib.types.addCheck lib.types.unspecified builtins.isFunction)) ((lib.evalModules { modules = [ { options.value = lib.mkOption { type = (lib.types.addCheck lib.types.unspecified builtins.isFunction); }; config.value = (value: (if ((lib.isString value) && ((lib.hasPrefix "#") value)) then (let
  hex = ((lib.removePrefix "#") value);
  r = (lib.toString ((parseHexByte ((((lib.substring 0) 2) hex)))));
  g = (lib.toString ((parseHexByte ((((lib.substring 2) 2) hex)))));
  b = (lib.toString ((parseHexByte ((((lib.substring 4) 2) hex)))));
  a = (if ((lib.stringLength hex) == 8) then (serializeFloat (((parseHexByte ((((lib.substring 6) 2) hex))) / 255.0))) else "1.0");
in "rgba(${((value: let kind = builtins.typeOf value; in if kind == "string" then value else if kind == "bool" || kind == "int" || kind == "float" then builtins.toJSON value else if kind == "path" then "${value}" else if kind == "set" && (value.type or null) == "derivation" && builtins.isString (value.outPath or null) then value.outPath else throw "/nix/store/3ni594f60hm22hcrazxd35dmk7pwi61m-zenpkgs-dsl-source/modules/desktops/gnome/extensions/forge.zmdl:41: string interpolation requires a scalar, path, or package") (r))}, ${((value: let kind = builtins.typeOf value; in if kind == "string" then value else if kind == "bool" || kind == "int" || kind == "float" then builtins.toJSON value else if kind == "path" then "${value}" else if kind == "set" && (value.type or null) == "derivation" && builtins.isString (value.outPath or null) then value.outPath else throw "/nix/store/3ni594f60hm22hcrazxd35dmk7pwi61m-zenpkgs-dsl-source/modules/desktops/gnome/extensions/forge.zmdl:41: string interpolation requires a scalar, path, or package") (g))}, ${((value: let kind = builtins.typeOf value; in if kind == "string" then value else if kind == "bool" || kind == "int" || kind == "float" then builtins.toJSON value else if kind == "path" then "${value}" else if kind == "set" && (value.type or null) == "derivation" && builtins.isString (value.outPath or null) then value.outPath else throw "/nix/store/3ni594f60hm22hcrazxd35dmk7pwi61m-zenpkgs-dsl-source/modules/desktops/gnome/extensions/forge.zmdl:41: string interpolation requires a scalar, path, or package") (b))}, ${((value: let kind = builtins.typeOf value; in if kind == "string" then value else if kind == "bool" || kind == "int" || kind == "float" then builtins.toJSON value else if kind == "path" then "${value}" else if kind == "set" && (value.type or null) == "derivation" && builtins.isString (value.outPath or null) then value.outPath else throw "/nix/store/3ni594f60hm22hcrazxd35dmk7pwi61m-zenpkgs-dsl-source/modules/desktops/gnome/extensions/forge.zmdl:41: string interpolation requires a scalar, path, or package") (a))})") else value)); } ]; }).config.value))); in (lib.mkIf ((cfg.configure)) { home-manager.sharedModules = [ {
      dconf = {
        settings = {
          "org/gnome/shell/extensions/forge" = {
            focus-border-toggle = cfg.appearance.borders.focus.toggle;
            focus-border-size = (lib.gvariant.mkUint32 cfg.appearance.borders.focus.size);
            focus-border-color = (toRgbaString cfg.appearance.borders.focus.color);
            split-border-toggle = cfg.appearance.borders.split.toggle;
            split-border-color = (toRgbaString cfg.appearance.borders.split.color);
            window-gap-size = (lib.gvariant.mkUint32 cfg.appearance.gaps.size);
            window-gap-size-increment = (lib.gvariant.mkUint32 cfg.appearance.gaps.increment);
            window-gap-hidden-on-single = cfg.appearance.gaps.hide-on-single;
            showtab-decoration-enabled = cfg.appearance.decorations.tabs;
            preview-hint-enabled = cfg.appearance.decorations.preview-hint;
            tiling-mode-enabled = cfg.tiling.enable;
            primary-layout-mode = cfg.tiling.primary-mode;
            stacked-tiling-mode-enabled = cfg.tiling.stacked;
            tabbed-tiling-mode-enabled = cfg.tiling.tabbed.enable;
            auto-exit-tabbed = cfg.tiling.tabbed.auto-exit;
            auto-split-enabled = cfg.tiling.auto-split;
            workspace-skip-tile = cfg.tiling.workspace-skip;
            move-pointer-focus-enabled = cfg.interaction.mouse.move-pointer-focus;
            focus-on-hover-enabled = cfg.interaction.mouse.focus-on-hover;
            dnd-center-layout = cfg.interaction.dnd-center-layout;
            float-always-on-top-enabled = cfg.interaction.float-always-on-top;
            resize-amount = (lib.gvariant.mkUint32 cfg.interaction.resize-amount);
            quick-settings-enabled = cfg.general.quick-settings;
            logging-enabled = cfg.general.logging.enable;
            log-level = (lib.gvariant.mkUint32 cfg.general.logging.level);
            css-updated = cfg.general.css.updated;
            css-last-update = (lib.gvariant.mkUint32 cfg.general.css.last-update);
          };
          "org/gnome/shell/extensions/forge/keybindings" = {
            focus-border-toggle = (serializeKeybind cfg.keybindings.focus-border-toggle);
            window-gap-size-increase = (serializeKeybind cfg.keybindings.window-gap-size-increase);
            window-gap-size-decrease = (serializeKeybind cfg.keybindings.window-gap-size-decrease);
            con-split-layout-toggle = (serializeKeybind cfg.keybindings.con-split-layout-toggle);
            con-split-horizontal = (serializeKeybind cfg.keybindings.con-split-horizontal);
            con-split-vertical = (serializeKeybind cfg.keybindings.con-split-vertical);
            con-stacked-layout-toggle = (serializeKeybind cfg.keybindings.con-stacked-layout-toggle);
            con-tabbed-layout-toggle = (serializeKeybind cfg.keybindings.con-tabbed-layout-toggle);
            con-tabbed-showtab-decoration-toggle = (serializeKeybind cfg.keybindings.con-tabbed-showtab-decoration-toggle);
            window-swap-left = (serializeKeybind cfg.keybindings.window-swap-left);
            window-swap-down = (serializeKeybind cfg.keybindings.window-swap-down);
            window-swap-up = (serializeKeybind cfg.keybindings.window-swap-up);
            window-swap-right = (serializeKeybind cfg.keybindings.window-swap-right);
            window-move-left = (serializeKeybind cfg.keybindings.window-move-left);
            window-move-down = (serializeKeybind cfg.keybindings.window-move-down);
            window-move-up = (serializeKeybind cfg.keybindings.window-move-up);
            window-move-right = (serializeKeybind cfg.keybindings.window-move-right);
            window-focus-left = (serializeKeybind cfg.keybindings.window-focus-left);
            window-focus-down = (serializeKeybind cfg.keybindings.window-focus-down);
            window-focus-up = (serializeKeybind cfg.keybindings.window-focus-up);
            window-focus-right = (serializeKeybind cfg.keybindings.window-focus-right);
            window-toggle-float = (serializeKeybind cfg.keybindings.window-toggle-float);
            window-toggle-always-float = (serializeKeybind cfg.keybindings.window-toggle-always-float);
            workspace-active-tile-toggle = (serializeKeybind cfg.keybindings.workspace-active-tile-toggle);
            prefs-open = (serializeKeybind cfg.keybindings.prefs-open);
            prefs-tiling-toggle = (serializeKeybind cfg.keybindings.prefs-tiling-toggle);
            mod-mask-mouse-tile = cfg.keybindings.mod-mask-mouse-tile;
            window-swap-last-active = (serializeKeybind cfg.keybindings.window-swap-last-active);
            window-snap-one-third-right = (serializeKeybind cfg.keybindings.window-snap-one-third-right);
            window-snap-two-third-right = (serializeKeybind cfg.keybindings.window-snap-two-third-right);
            window-snap-one-third-left = (serializeKeybind cfg.keybindings.window-snap-one-third-left);
            window-snap-two-third-left = (serializeKeybind cfg.keybindings.window-snap-two-third-left);
            window-snap-center = (serializeKeybind cfg.keybindings.window-snap-center);
            window-resize-left-increase = (serializeKeybind cfg.keybindings.window-resize-left-increase);
            window-resize-left-decrease = (serializeKeybind cfg.keybindings.window-resize-left-decrease);
            window-resize-bottom-increase = (serializeKeybind cfg.keybindings.window-resize-bottom-increase);
            window-resize-bottom-decrease = (serializeKeybind cfg.keybindings.window-resize-bottom-decrease);
            window-resize-top-increase = (serializeKeybind cfg.keybindings.window-resize-top-increase);
            window-resize-top-decrease = (serializeKeybind cfg.keybindings.window-resize-top-decrease);
            window-resize-right-increase = (serializeKeybind cfg.keybindings.window-resize-right-increase);
            window-resize-right-decrease = (serializeKeybind cfg.keybindings.window-resize-right-decrease);
          };
        };
      };
    } ]; }))
  ];
}
