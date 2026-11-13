{ config, lib, pkgs, maintainers ? lib.maintainers, licenses ? lib.licenses, ... }:
let
  cfg = config.zenos.desktops.gnome.extensions.customize-clock-on-lockscreen;
  name = "customize-clock-on-lockscreen";
  hexToDecMap = (builtins.addErrorContext "_let hexToDecMap annotation mismatch: /nix/store/3ni594f60hm22hcrazxd35dmk7pwi61m-zenpkgs-dsl-source/modules/desktops/gnome/extensions/customize-clock-on-lockscreen.zmdl:20:1" ((_zenType: _zenValue: let force = type: value: if type.name == "anything" then true else if type.name == "listOf" then builtins.all (force type.nestedTypes.elemType) value else if type.name == "attrsOf" then builtins.all (force type.nestedTypes.elemType) (builtins.attrValues value) else if type.name == "either" then force (if type.nestedTypes.left.check value then type.nestedTypes.left else type.nestedTypes.right) value else builtins.seq value true; in builtins.seq (force _zenType _zenValue) _zenValue) ((lib.types.attrsOf lib.types.int)) ((lib.evalModules { modules = [ { options.value = lib.mkOption { type = (lib.types.attrsOf lib.types.int); }; config.value = {
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
  hexValue = (builtins.addErrorContext "_let hexValue annotation mismatch: /nix/store/3ni594f60hm22hcrazxd35dmk7pwi61m-zenpkgs-dsl-source/modules/desktops/gnome/extensions/customize-clock-on-lockscreen.zmdl:21:1" ((_zenType: _zenValue: let force = type: value: if type.name == "anything" then true else if type.name == "listOf" then builtins.all (force type.nestedTypes.elemType) value else if type.name == "attrsOf" then builtins.all (force type.nestedTypes.elemType) (builtins.attrValues value) else if type.name == "either" then force (if type.nestedTypes.left.check value then type.nestedTypes.left else type.nestedTypes.right) value else builtins.seq value true; in builtins.seq (force _zenType _zenValue) _zenValue) ((lib.types.addCheck lib.types.unspecified builtins.isFunction)) ((lib.evalModules { modules = [ { options.value = lib.mkOption { type = (lib.types.addCheck lib.types.unspecified builtins.isFunction); }; config.value = (c: (if ((lib.hasAttr c) hexToDecMap) then ((lib.getAttr c) hexToDecMap) else 0)); } ]; }).config.value)));
  parseHexByte = (builtins.addErrorContext "_let parseHexByte annotation mismatch: /nix/store/3ni594f60hm22hcrazxd35dmk7pwi61m-zenpkgs-dsl-source/modules/desktops/gnome/extensions/customize-clock-on-lockscreen.zmdl:22:1" ((_zenType: _zenValue: let force = type: value: if type.name == "anything" then true else if type.name == "listOf" then builtins.all (force type.nestedTypes.elemType) value else if type.name == "attrsOf" then builtins.all (force type.nestedTypes.elemType) (builtins.attrValues value) else if type.name == "either" then force (if type.nestedTypes.left.check value then type.nestedTypes.left else type.nestedTypes.right) value else builtins.seq value true; in builtins.seq (force _zenType _zenValue) _zenValue) ((lib.types.addCheck lib.types.unspecified builtins.isFunction)) ((lib.evalModules { modules = [ { options.value = lib.mkOption { type = (lib.types.addCheck lib.types.unspecified builtins.isFunction); }; config.value = (s: ((((hexValue ((((lib.substring 0) 1) s))) * 16)) + (hexValue ((((lib.substring 1) 1) s))))); } ]; }).config.value)));
  serializeFloat = (builtins.addErrorContext "_let serializeFloat annotation mismatch: /nix/store/3ni594f60hm22hcrazxd35dmk7pwi61m-zenpkgs-dsl-source/modules/desktops/gnome/extensions/customize-clock-on-lockscreen.zmdl:23:1" ((_zenType: _zenValue: let force = type: value: if type.name == "anything" then true else if type.name == "listOf" then builtins.all (force type.nestedTypes.elemType) value else if type.name == "attrsOf" then builtins.all (force type.nestedTypes.elemType) (builtins.attrValues value) else if type.name == "either" then force (if type.nestedTypes.left.check value then type.nestedTypes.left else type.nestedTypes.right) value else builtins.seq value true; in builtins.seq (force _zenType _zenValue) _zenValue) ((lib.types.addCheck lib.types.unspecified builtins.isFunction)) ((lib.evalModules { modules = [ { options.value = lib.mkOption { type = (lib.types.addCheck lib.types.unspecified builtins.isFunction); }; config.value = (f: (let
    s = (lib.toString f);
  in (if ((lib.hasInfix ".") s) then s else "${((value: let kind = builtins.typeOf value; in if kind == "string" then value else if kind == "bool" || kind == "int" || kind == "float" then builtins.toJSON value else if kind == "path" then "${value}" else if kind == "set" && (value.type or null) == "derivation" && builtins.isString (value.outPath or null) then value.outPath else throw "/nix/store/3ni594f60hm22hcrazxd35dmk7pwi61m-zenpkgs-dsl-source/modules/desktops/gnome/extensions/customize-clock-on-lockscreen.zmdl:23: string interpolation requires a scalar, path, or package") (s))}.0"))); } ]; }).config.value)));
  toRgbaString = (builtins.addErrorContext "_let toRgbaString annotation mismatch: /nix/store/3ni594f60hm22hcrazxd35dmk7pwi61m-zenpkgs-dsl-source/modules/desktops/gnome/extensions/customize-clock-on-lockscreen.zmdl:24:1" ((_zenType: _zenValue: let force = type: value: if type.name == "anything" then true else if type.name == "listOf" then builtins.all (force type.nestedTypes.elemType) value else if type.name == "attrsOf" then builtins.all (force type.nestedTypes.elemType) (builtins.attrValues value) else if type.name == "either" then force (if type.nestedTypes.left.check value then type.nestedTypes.left else type.nestedTypes.right) value else builtins.seq value true; in builtins.seq (force _zenType _zenValue) _zenValue) ((lib.types.addCheck lib.types.unspecified builtins.isFunction)) ((lib.evalModules { modules = [ { options.value = lib.mkOption { type = (lib.types.addCheck lib.types.unspecified builtins.isFunction); }; config.value = (val: (if ((lib.isString val) && ((lib.hasPrefix "#") val)) then (let
    hex = ((lib.removePrefix "#") val);
    r = (lib.toString ((parseHexByte ((((lib.substring 0) 2) hex)))));
    g = (lib.toString ((parseHexByte ((((lib.substring 2) 2) hex)))));
    b = (lib.toString ((parseHexByte ((((lib.substring 4) 2) hex)))));
    a = (if ((lib.stringLength hex) == 8) then (serializeFloat (((parseHexByte ((((lib.substring 6) 2) hex))) / 255.0))) else "1.0");
  in "rgba(${((value: let kind = builtins.typeOf value; in if kind == "string" then value else if kind == "bool" || kind == "int" || kind == "float" then builtins.toJSON value else if kind == "path" then "${value}" else if kind == "set" && (value.type or null) == "derivation" && builtins.isString (value.outPath or null) then value.outPath else throw "/nix/store/3ni594f60hm22hcrazxd35dmk7pwi61m-zenpkgs-dsl-source/modules/desktops/gnome/extensions/customize-clock-on-lockscreen.zmdl:32: string interpolation requires a scalar, path, or package") (r))}, ${((value: let kind = builtins.typeOf value; in if kind == "string" then value else if kind == "bool" || kind == "int" || kind == "float" then builtins.toJSON value else if kind == "path" then "${value}" else if kind == "set" && (value.type or null) == "derivation" && builtins.isString (value.outPath or null) then value.outPath else throw "/nix/store/3ni594f60hm22hcrazxd35dmk7pwi61m-zenpkgs-dsl-source/modules/desktops/gnome/extensions/customize-clock-on-lockscreen.zmdl:32: string interpolation requires a scalar, path, or package") (g))}, ${((value: let kind = builtins.typeOf value; in if kind == "string" then value else if kind == "bool" || kind == "int" || kind == "float" then builtins.toJSON value else if kind == "path" then "${value}" else if kind == "set" && (value.type or null) == "derivation" && builtins.isString (value.outPath or null) then value.outPath else throw "/nix/store/3ni594f60hm22hcrazxd35dmk7pwi61m-zenpkgs-dsl-source/modules/desktops/gnome/extensions/customize-clock-on-lockscreen.zmdl:32: string interpolation requires a scalar, path, or package") (b))}, ${((value: let kind = builtins.typeOf value; in if kind == "string" then value else if kind == "bool" || kind == "int" || kind == "float" then builtins.toJSON value else if kind == "path" then "${value}" else if kind == "set" && (value.type or null) == "derivation" && builtins.isString (value.outPath or null) then value.outPath else throw "/nix/store/3ni594f60hm22hcrazxd35dmk7pwi61m-zenpkgs-dsl-source/modules/desktops/gnome/extensions/customize-clock-on-lockscreen.zmdl:32: string interpolation requires a scalar, path, or package") (a))})") else val)); } ]; }).config.value)));
in
{
  options.zenos.desktops.gnome.extensions.customize-clock-on-lockscreen = lib.mkOption { type = (lib.types.submodule ({ ... }: (let hexToDecMap = (builtins.addErrorContext "_let hexToDecMap annotation mismatch: /nix/store/3ni594f60hm22hcrazxd35dmk7pwi61m-zenpkgs-dsl-source/modules/desktops/gnome/extensions/customize-clock-on-lockscreen.zmdl:20:1" ((_zenType: _zenValue: let force = type: value: if type.name == "anything" then true else if type.name == "listOf" then builtins.all (force type.nestedTypes.elemType) value else if type.name == "attrsOf" then builtins.all (force type.nestedTypes.elemType) (builtins.attrValues value) else if type.name == "either" then force (if type.nestedTypes.left.check value then type.nestedTypes.left else type.nestedTypes.right) value else builtins.seq value true; in builtins.seq (force _zenType _zenValue) _zenValue) ((lib.types.attrsOf lib.types.int)) ((lib.evalModules { modules = [ { options.value = lib.mkOption { type = (lib.types.attrsOf lib.types.int); }; config.value = {
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
      }; } ]; }).config.value))); hexValue = (builtins.addErrorContext "_let hexValue annotation mismatch: /nix/store/3ni594f60hm22hcrazxd35dmk7pwi61m-zenpkgs-dsl-source/modules/desktops/gnome/extensions/customize-clock-on-lockscreen.zmdl:21:1" ((_zenType: _zenValue: let force = type: value: if type.name == "anything" then true else if type.name == "listOf" then builtins.all (force type.nestedTypes.elemType) value else if type.name == "attrsOf" then builtins.all (force type.nestedTypes.elemType) (builtins.attrValues value) else if type.name == "either" then force (if type.nestedTypes.left.check value then type.nestedTypes.left else type.nestedTypes.right) value else builtins.seq value true; in builtins.seq (force _zenType _zenValue) _zenValue) ((lib.types.addCheck lib.types.unspecified builtins.isFunction)) ((lib.evalModules { modules = [ { options.value = lib.mkOption { type = (lib.types.addCheck lib.types.unspecified builtins.isFunction); }; config.value = (c: (if ((lib.hasAttr c) hexToDecMap) then ((lib.getAttr c) hexToDecMap) else 0)); } ]; }).config.value))); parseHexByte = (builtins.addErrorContext "_let parseHexByte annotation mismatch: /nix/store/3ni594f60hm22hcrazxd35dmk7pwi61m-zenpkgs-dsl-source/modules/desktops/gnome/extensions/customize-clock-on-lockscreen.zmdl:22:1" ((_zenType: _zenValue: let force = type: value: if type.name == "anything" then true else if type.name == "listOf" then builtins.all (force type.nestedTypes.elemType) value else if type.name == "attrsOf" then builtins.all (force type.nestedTypes.elemType) (builtins.attrValues value) else if type.name == "either" then force (if type.nestedTypes.left.check value then type.nestedTypes.left else type.nestedTypes.right) value else builtins.seq value true; in builtins.seq (force _zenType _zenValue) _zenValue) ((lib.types.addCheck lib.types.unspecified builtins.isFunction)) ((lib.evalModules { modules = [ { options.value = lib.mkOption { type = (lib.types.addCheck lib.types.unspecified builtins.isFunction); }; config.value = (s: ((((hexValue ((((lib.substring 0) 1) s))) * 16)) + (hexValue ((((lib.substring 1) 1) s))))); } ]; }).config.value))); serializeFloat = (builtins.addErrorContext "_let serializeFloat annotation mismatch: /nix/store/3ni594f60hm22hcrazxd35dmk7pwi61m-zenpkgs-dsl-source/modules/desktops/gnome/extensions/customize-clock-on-lockscreen.zmdl:23:1" ((_zenType: _zenValue: let force = type: value: if type.name == "anything" then true else if type.name == "listOf" then builtins.all (force type.nestedTypes.elemType) value else if type.name == "attrsOf" then builtins.all (force type.nestedTypes.elemType) (builtins.attrValues value) else if type.name == "either" then force (if type.nestedTypes.left.check value then type.nestedTypes.left else type.nestedTypes.right) value else builtins.seq value true; in builtins.seq (force _zenType _zenValue) _zenValue) ((lib.types.addCheck lib.types.unspecified builtins.isFunction)) ((lib.evalModules { modules = [ { options.value = lib.mkOption { type = (lib.types.addCheck lib.types.unspecified builtins.isFunction); }; config.value = (f: (let
        s = (lib.toString f);
      in (if ((lib.hasInfix ".") s) then s else "${((value: let kind = builtins.typeOf value; in if kind == "string" then value else if kind == "bool" || kind == "int" || kind == "float" then builtins.toJSON value else if kind == "path" then "${value}" else if kind == "set" && (value.type or null) == "derivation" && builtins.isString (value.outPath or null) then value.outPath else throw "/nix/store/3ni594f60hm22hcrazxd35dmk7pwi61m-zenpkgs-dsl-source/modules/desktops/gnome/extensions/customize-clock-on-lockscreen.zmdl:23: string interpolation requires a scalar, path, or package") (s))}.0"))); } ]; }).config.value))); toRgbaString = (builtins.addErrorContext "_let toRgbaString annotation mismatch: /nix/store/3ni594f60hm22hcrazxd35dmk7pwi61m-zenpkgs-dsl-source/modules/desktops/gnome/extensions/customize-clock-on-lockscreen.zmdl:24:1" ((_zenType: _zenValue: let force = type: value: if type.name == "anything" then true else if type.name == "listOf" then builtins.all (force type.nestedTypes.elemType) value else if type.name == "attrsOf" then builtins.all (force type.nestedTypes.elemType) (builtins.attrValues value) else if type.name == "either" then force (if type.nestedTypes.left.check value then type.nestedTypes.left else type.nestedTypes.right) value else builtins.seq value true; in builtins.seq (force _zenType _zenValue) _zenValue) ((lib.types.addCheck lib.types.unspecified builtins.isFunction)) ((lib.evalModules { modules = [ { options.value = lib.mkOption { type = (lib.types.addCheck lib.types.unspecified builtins.isFunction); }; config.value = (val: (if ((lib.isString val) && ((lib.hasPrefix "#") val)) then (let
        hex = ((lib.removePrefix "#") val);
        r = (lib.toString ((parseHexByte ((((lib.substring 0) 2) hex)))));
        g = (lib.toString ((parseHexByte ((((lib.substring 2) 2) hex)))));
        b = (lib.toString ((parseHexByte ((((lib.substring 4) 2) hex)))));
        a = (if ((lib.stringLength hex) == 8) then (serializeFloat (((parseHexByte ((((lib.substring 6) 2) hex))) / 255.0))) else "1.0");
      in "rgba(${((value: let kind = builtins.typeOf value; in if kind == "string" then value else if kind == "bool" || kind == "int" || kind == "float" then builtins.toJSON value else if kind == "path" then "${value}" else if kind == "set" && (value.type or null) == "derivation" && builtins.isString (value.outPath or null) then value.outPath else throw "/nix/store/3ni594f60hm22hcrazxd35dmk7pwi61m-zenpkgs-dsl-source/modules/desktops/gnome/extensions/customize-clock-on-lockscreen.zmdl:32: string interpolation requires a scalar, path, or package") (r))}, ${((value: let kind = builtins.typeOf value; in if kind == "string" then value else if kind == "bool" || kind == "int" || kind == "float" then builtins.toJSON value else if kind == "path" then "${value}" else if kind == "set" && (value.type or null) == "derivation" && builtins.isString (value.outPath or null) then value.outPath else throw "/nix/store/3ni594f60hm22hcrazxd35dmk7pwi61m-zenpkgs-dsl-source/modules/desktops/gnome/extensions/customize-clock-on-lockscreen.zmdl:32: string interpolation requires a scalar, path, or package") (g))}, ${((value: let kind = builtins.typeOf value; in if kind == "string" then value else if kind == "bool" || kind == "int" || kind == "float" then builtins.toJSON value else if kind == "path" then "${value}" else if kind == "set" && (value.type or null) == "derivation" && builtins.isString (value.outPath or null) then value.outPath else throw "/nix/store/3ni594f60hm22hcrazxd35dmk7pwi61m-zenpkgs-dsl-source/modules/desktops/gnome/extensions/customize-clock-on-lockscreen.zmdl:32: string interpolation requires a scalar, path, or package") (b))}, ${((value: let kind = builtins.typeOf value; in if kind == "string" then value else if kind == "bool" || kind == "int" || kind == "float" then builtins.toJSON value else if kind == "path" then "${value}" else if kind == "set" && (value.type or null) == "derivation" && builtins.isString (value.outPath or null) then value.outPath else throw "/nix/store/3ni594f60hm22hcrazxd35dmk7pwi61m-zenpkgs-dsl-source/modules/desktops/gnome/extensions/customize-clock-on-lockscreen.zmdl:32: string interpolation requires a scalar, path, or package") (a))})") else val)); } ]; }).config.value))); in { options = { command = lib.mkOption { type = (lib.types.submodule ({ ... }: { options = { enable = lib.mkOption { type = lib.types.bool; default = true; description = "Display output from a custom shell command"; }; font = lib.mkOption { type = (lib.types.submodule ({ ... }: { options = { color = lib.mkOption { type = lib.types.str; default = "rgba(255, 244, 177, 1.0)"; description = "CSS color (Hex or RGBA)"; }; family = lib.mkOption { type = lib.types.str; default = "Default"; description = "Font family name"; }; size = lib.mkOption { type = lib.types.int; default = 48; description = "Font size in points (20-96)"; }; style = lib.mkOption { type = lib.types.str; default = "Default"; description = "Typography style"; }; weight = lib.mkOption { type = lib.types.str; default = "Default"; description = "Typography weight"; }; }; })); default = { }; }; text = lib.mkOption { type = lib.types.str; default = "whoami"; description = "Shell command to execute for output display"; }; }; })); default = { }; }; date = lib.mkOption { type = (lib.types.submodule ({ ... }: { options = { enable = lib.mkOption { type = lib.types.bool; default = true; description = "Show the lock screen date"; }; font = lib.mkOption { type = (lib.types.submodule ({ ... }: { options = { color = lib.mkOption { type = lib.types.str; default = "rgba(242, 92, 84, 1.0)"; description = "CSS color (Hex or RGBA)"; }; family = lib.mkOption { type = lib.types.str; default = "Default"; description = "Font family name"; }; size = lib.mkOption { type = lib.types.int; default = 28; description = "Font size in points (20-96)"; }; style = lib.mkOption { type = lib.types.str; default = "Default"; description = "Typography style"; }; weight = lib.mkOption { type = lib.types.str; default = "Default"; description = "Typography weight"; }; }; })); default = { }; }; text = lib.mkOption { type = lib.types.str; default = ""; description = "Custom date format pattern"; }; }; })); default = { }; }; enable = lib.mkOption { type = lib.types.bool; default = false; description = "Whether to enable Customize Clock on Lockscreen GNOME extension configuration."; }; hint = lib.mkOption { type = (lib.types.submodule ({ ... }: { options = { enable = lib.mkOption { type = lib.types.bool; default = true; description = "Show the 'swipe up to unlock' hint"; }; font = lib.mkOption { type = (lib.types.submodule ({ ... }: { options = { color = lib.mkOption { type = lib.types.str; default = "rgba(212, 237, 138, 1.0)"; description = "CSS color (Hex or RGBA)"; }; family = lib.mkOption { type = lib.types.str; default = "Default"; description = "Font family name"; }; size = lib.mkOption { type = lib.types.int; default = 20; description = "Font size in points (20-96)"; }; style = lib.mkOption { type = lib.types.str; default = "Default"; description = "Typography style"; }; weight = lib.mkOption { type = lib.types.str; default = "Default"; description = "Typography weight"; }; }; })); default = { }; }; }; })); default = { }; }; time = lib.mkOption { type = (lib.types.submodule ({ ... }: { options = { enable = lib.mkOption { type = lib.types.bool; default = true; description = "Show the lock screen clock"; }; font = lib.mkOption { type = (lib.types.submodule ({ ... }: { options = { color = lib.mkOption { type = lib.types.str; default = "rgba(160, 230, 163, 1.0)"; description = "CSS color (Hex or RGBA)"; }; family = lib.mkOption { type = lib.types.str; default = "Default"; description = "Font family name"; }; size = lib.mkOption { type = lib.types.int; default = 96; description = "Font size in points (20-96)"; }; style = lib.mkOption { type = lib.types.str; default = "Default"; description = "Typography style"; }; weight = lib.mkOption { type = lib.types.str; default = "Default"; description = "Typography weight"; }; }; })); default = { }; }; style = lib.mkOption { type = (lib.types.enum [
  "digital"
  "analog"
  "led"
]); default = "digital"; description = "Clock face rendering style"; }; text = lib.mkOption { type = lib.types.str; default = ""; description = "Custom strftime format pattern"; }; }; })); default = { }; }; }; }))); default = { }; };
  config = lib.mkMerge [
    { _module.args.zenlang.descriptors.desktops.gnome.extensions.customize-clock-on-lockscreen = {
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
            value = "\n    Fine-grained typography control for the GNOME lock screen\n\n    This module installs and configures the **Customize Clock on Lockscreen** extension for GNOME. It allows extensive customization of the clock,\n    date, and hint text on the lock screen.\n\n    **Features:**\n    - Run custom commands to display text (e.g., `whoami`).\n    - Customize clock style (Digital, Analog, LED).\n    - Adjust fonts and colors for all elements.\n  ";
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
            value = "Fine-grained typography control for the GNOME lock screen";
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
    moduleIdentity = "zenos.desktops.gnome.extensions.customize-clock-on-lockscreen";
    modulePath = [
      "desktops"
      "gnome"
      "extensions"
      "customize-clock-on-lockscreen"
    ];
    nodeMetadata = [
      {
        metadata = {
          description = {
            multiline = true;
            parts = [
              {
                type = "text";
                value = "\n    Fine-grained typography control for the GNOME lock screen\n\n    This module installs and configures the **Customize Clock on Lockscreen** extension for GNOME. It allows extensive customization of the clock,\n    date, and hint text on the lock screen.\n\n    **Features:**\n    - Run custom commands to display text (e.g., `whoami`).\n    - Customize clock style (Digital, Analog, LED).\n    - Adjust fonts and colors for all elements.\n  ";
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
                value = "Fine-grained typography control for the GNOME lock screen";
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
                value = "Whether to enable Customize Clock on Lockscreen GNOME extension configuration.";
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
          zenosVersion = {
            kind = "version";
            type = "literal";
            value = "1.0.0Na";
          };
        };
        path = [
          "command"
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
                value = "Display output from a custom shell command";
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
          "command"
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
                value = "whoami";
              }
            ];
            type = "string";
          };
          description = {
            multiline = true;
            parts = [
              {
                type = "text";
                value = "Shell command to execute for output display";
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
          "command"
          "text"
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
          "command"
          "font"
        ];
      }
      {
        metadata = {
          default = {
            multiline = false;
            parts = [
              {
                type = "text";
                value = "rgba(255, 244, 177, 1.0)";
              }
            ];
            type = "string";
          };
          description = {
            multiline = true;
            parts = [
              {
                type = "text";
                value = "CSS color (Hex or RGBA)";
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
          "command"
          "font"
          "color"
        ];
      }
      {
        metadata = {
          default = {
            kind = "integer";
            type = "literal";
            value = 48;
          };
          description = {
            multiline = true;
            parts = [
              {
                type = "text";
                value = "Font size in points (20-96)";
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
          "command"
          "font"
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
                value = "Default";
              }
            ];
            type = "string";
          };
          description = {
            multiline = true;
            parts = [
              {
                type = "text";
                value = "Font family name";
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
          "command"
          "font"
          "family"
        ];
      }
      {
        metadata = {
          default = {
            multiline = false;
            parts = [
              {
                type = "text";
                value = "Default";
              }
            ];
            type = "string";
          };
          description = {
            multiline = true;
            parts = [
              {
                type = "text";
                value = "Typography weight";
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
          "command"
          "font"
          "weight"
        ];
      }
      {
        metadata = {
          default = {
            multiline = false;
            parts = [
              {
                type = "text";
                value = "Default";
              }
            ];
            type = "string";
          };
          description = {
            multiline = true;
            parts = [
              {
                type = "text";
                value = "Typography style";
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
          "command"
          "font"
          "style"
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
          "time"
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
                value = "Show the lock screen clock";
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
          "time"
          "enable"
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
                value = "Custom strftime format pattern";
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
          "time"
          "text"
        ];
      }
      {
        metadata = {
          default = {
            multiline = false;
            parts = [
              {
                type = "text";
                value = "digital";
              }
            ];
            type = "string";
          };
          description = {
            multiline = true;
            parts = [
              {
                type = "text";
                value = "Clock face rendering style";
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
                        value = "digital";
                      }
                    ];
                    type = "string";
                  }
                  {
                    multiline = false;
                    parts = [
                      {
                        type = "text";
                        value = "analog";
                      }
                    ];
                    type = "string";
                  }
                  {
                    multiline = false;
                    parts = [
                      {
                        type = "text";
                        value = "led";
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
          "time"
          "style"
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
          "time"
          "font"
        ];
      }
      {
        metadata = {
          default = {
            multiline = false;
            parts = [
              {
                type = "text";
                value = "rgba(160, 230, 163, 1.0)";
              }
            ];
            type = "string";
          };
          description = {
            multiline = true;
            parts = [
              {
                type = "text";
                value = "CSS color (Hex or RGBA)";
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
          "time"
          "font"
          "color"
        ];
      }
      {
        metadata = {
          default = {
            kind = "integer";
            type = "literal";
            value = 96;
          };
          description = {
            multiline = true;
            parts = [
              {
                type = "text";
                value = "Font size in points (20-96)";
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
          "time"
          "font"
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
                value = "Default";
              }
            ];
            type = "string";
          };
          description = {
            multiline = true;
            parts = [
              {
                type = "text";
                value = "Font family name";
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
          "time"
          "font"
          "family"
        ];
      }
      {
        metadata = {
          default = {
            multiline = false;
            parts = [
              {
                type = "text";
                value = "Default";
              }
            ];
            type = "string";
          };
          description = {
            multiline = true;
            parts = [
              {
                type = "text";
                value = "Typography weight";
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
          "time"
          "font"
          "weight"
        ];
      }
      {
        metadata = {
          default = {
            multiline = false;
            parts = [
              {
                type = "text";
                value = "Default";
              }
            ];
            type = "string";
          };
          description = {
            multiline = true;
            parts = [
              {
                type = "text";
                value = "Typography style";
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
          "time"
          "font"
          "style"
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
          "date"
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
                value = "Show the lock screen date";
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
          "date"
          "enable"
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
                value = "Custom date format pattern";
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
          "date"
          "text"
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
          "date"
          "font"
        ];
      }
      {
        metadata = {
          default = {
            multiline = false;
            parts = [
              {
                type = "text";
                value = "rgba(242, 92, 84, 1.0)";
              }
            ];
            type = "string";
          };
          description = {
            multiline = true;
            parts = [
              {
                type = "text";
                value = "CSS color (Hex or RGBA)";
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
          "date"
          "font"
          "color"
        ];
      }
      {
        metadata = {
          default = {
            kind = "integer";
            type = "literal";
            value = 28;
          };
          description = {
            multiline = true;
            parts = [
              {
                type = "text";
                value = "Font size in points (20-96)";
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
          "date"
          "font"
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
                value = "Default";
              }
            ];
            type = "string";
          };
          description = {
            multiline = true;
            parts = [
              {
                type = "text";
                value = "Font family name";
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
          "date"
          "font"
          "family"
        ];
      }
      {
        metadata = {
          default = {
            multiline = false;
            parts = [
              {
                type = "text";
                value = "Default";
              }
            ];
            type = "string";
          };
          description = {
            multiline = true;
            parts = [
              {
                type = "text";
                value = "Typography weight";
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
          "date"
          "font"
          "weight"
        ];
      }
      {
        metadata = {
          default = {
            multiline = false;
            parts = [
              {
                type = "text";
                value = "Default";
              }
            ];
            type = "string";
          };
          description = {
            multiline = true;
            parts = [
              {
                type = "text";
                value = "Typography style";
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
          "date"
          "font"
          "style"
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
          "hint"
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
                value = "Show the 'swipe up to unlock' hint";
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
          "hint"
          "enable"
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
          "hint"
          "font"
        ];
      }
      {
        metadata = {
          default = {
            multiline = false;
            parts = [
              {
                type = "text";
                value = "rgba(212, 237, 138, 1.0)";
              }
            ];
            type = "string";
          };
          description = {
            multiline = true;
            parts = [
              {
                type = "text";
                value = "CSS color (Hex or RGBA)";
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
          "hint"
          "font"
          "color"
        ];
      }
      {
        metadata = {
          default = {
            kind = "integer";
            type = "literal";
            value = 20;
          };
          description = {
            multiline = true;
            parts = [
              {
                type = "text";
                value = "Font size in points (20-96)";
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
          "hint"
          "font"
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
                value = "Default";
              }
            ];
            type = "string";
          };
          description = {
            multiline = true;
            parts = [
              {
                type = "text";
                value = "Font family name";
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
          "hint"
          "font"
          "family"
        ];
      }
      {
        metadata = {
          default = {
            multiline = false;
            parts = [
              {
                type = "text";
                value = "Default";
              }
            ];
            type = "string";
          };
          description = {
            multiline = true;
            parts = [
              {
                type = "text";
                value = "Typography weight";
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
          "hint"
          "font"
          "weight"
        ];
      }
      {
        metadata = {
          default = {
            multiline = false;
            parts = [
              {
                type = "text";
                value = "Default";
              }
            ];
            type = "string";
          };
          description = {
            multiline = true;
            parts = [
              {
                type = "text";
                value = "Typography style";
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
          "hint"
          "font"
          "style"
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
                    value = "Fine-grained typography control for the GNOME lock screen";
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
                    value = "\n    Fine-grained typography control for the GNOME lock screen\n\n    This module installs and configures the **Customize Clock on Lockscreen** extension for GNOME. It allows extensive customization of the clock,\n    date, and hint text on the lock screen.\n\n    **Features:**\n    - Run custom commands to display text (e.g., `whoami`).\n    - Customize clock style (Digital, Analog, LED).\n    - Adjust fonts and colors for all elements.\n  ";
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
        name = "hexValue";
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
                                value = "s";
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
                        value = "hexValue";
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
                            value = "s";
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
                    value = "hexValue";
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
              name = "s";
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
                        value = "s";
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
                          value = "s";
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
                    value = "s";
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
                    value = "s";
                  }
                ];
                type = "assignment";
                value = {
                  arguments = [
                    {
                      path = [
                        {
                          kind = "identifier";
                          value = "f";
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
              name = "f";
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
                        value = "val";
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
                        value = "val";
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
                  value = "val";
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
                            value = "val";
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
              name = "val";
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
                                value = "zenos";
                              }
                              {
                                kind = "identifier";
                                value = "legacy";
                              }
                              {
                                kind = "identifier";
                                value = "gnomeExtensions";
                              }
                              {
                                kind = "identifier";
                                value = "customize-clock-on-lock-screen";
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
                            value = "Whether to enable Customize Clock on Lockscreen GNOME extension configuration.";
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
                                value = "zenos";
                              }
                              {
                                kind = "identifier";
                                value = "legacy";
                              }
                              {
                                kind = "identifier";
                                value = "gnomeExtensions";
                              }
                              {
                                kind = "identifier";
                                value = "customize-clock-on-lock-screen";
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
                          value = "programs";
                        }
                        {
                          kind = "identifier";
                          value = "dconf";
                        }
                        {
                          kind = "identifier";
                          value = "profiles";
                        }
                        {
                          kind = "identifier";
                          value = "user";
                        }
                        {
                          kind = "identifier";
                          value = "databases";
                        }
                      ];
                      type = "assignment";
                      value = {
                        items = [
                          {
                            recursive = false;
                            statements = [
                              {
                                operator = "=";
                                target = [
                                  {
                                    kind = "identifier";
                                    value = "settings";
                                  }
                                  {
                                    kind = "string";
                                    value = "org/gnome/shell/extensions/customize-clock-on-lockscreen";
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
                                          value = "remove-command-output";
                                        }
                                      ];
                                      type = "assignment";
                                      value = {
                                        operand = {
                                          name = "path";
                                          path = [
                                            {
                                              kind = "identifier";
                                              value = "command";
                                            }
                                            {
                                              kind = "identifier";
                                              value = "enable";
                                            }
                                          ];
                                          type = "variable";
                                        };
                                        operator = "!";
                                        type = "unary";
                                      };
                                    }
                                    {
                                      operator = "=";
                                      target = [
                                        {
                                          kind = "identifier";
                                          value = "remove-time";
                                        }
                                      ];
                                      type = "assignment";
                                      value = {
                                        operand = {
                                          name = "path";
                                          path = [
                                            {
                                              kind = "identifier";
                                              value = "time";
                                            }
                                            {
                                              kind = "identifier";
                                              value = "enable";
                                            }
                                          ];
                                          type = "variable";
                                        };
                                        operator = "!";
                                        type = "unary";
                                      };
                                    }
                                    {
                                      operator = "=";
                                      target = [
                                        {
                                          kind = "identifier";
                                          value = "remove-date";
                                        }
                                      ];
                                      type = "assignment";
                                      value = {
                                        operand = {
                                          name = "path";
                                          path = [
                                            {
                                              kind = "identifier";
                                              value = "date";
                                            }
                                            {
                                              kind = "identifier";
                                              value = "enable";
                                            }
                                          ];
                                          type = "variable";
                                        };
                                        operator = "!";
                                        type = "unary";
                                      };
                                    }
                                    {
                                      operator = "=";
                                      target = [
                                        {
                                          kind = "identifier";
                                          value = "remove-hint";
                                        }
                                      ];
                                      type = "assignment";
                                      value = {
                                        operand = {
                                          name = "path";
                                          path = [
                                            {
                                              kind = "identifier";
                                              value = "hint";
                                            }
                                            {
                                              kind = "identifier";
                                              value = "enable";
                                            }
                                          ];
                                          type = "variable";
                                        };
                                        operator = "!";
                                        type = "unary";
                                      };
                                    }
                                    {
                                      operator = "=";
                                      target = [
                                        {
                                          kind = "identifier";
                                          value = "command";
                                        }
                                      ];
                                      type = "assignment";
                                      value = {
                                        name = "path";
                                        path = [
                                          {
                                            kind = "identifier";
                                            value = "command";
                                          }
                                          {
                                            kind = "identifier";
                                            value = "text";
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
                                          value = "custom-time-text";
                                        }
                                      ];
                                      type = "assignment";
                                      value = {
                                        name = "path";
                                        path = [
                                          {
                                            kind = "identifier";
                                            value = "time";
                                          }
                                          {
                                            kind = "identifier";
                                            value = "text";
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
                                          value = "custom-date-text";
                                        }
                                      ];
                                      type = "assignment";
                                      value = {
                                        name = "path";
                                        path = [
                                          {
                                            kind = "identifier";
                                            value = "date";
                                          }
                                          {
                                            kind = "identifier";
                                            value = "text";
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
                                          value = "clock-style";
                                        }
                                      ];
                                      type = "assignment";
                                      value = {
                                        name = "path";
                                        path = [
                                          {
                                            kind = "identifier";
                                            value = "time";
                                          }
                                          {
                                            kind = "identifier";
                                            value = "style";
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
                                          value = "command-output-font-color";
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
                                                value = "command";
                                              }
                                              {
                                                kind = "identifier";
                                                value = "font";
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
                                          value = "command-output-font-size";
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
                                                value = "command";
                                              }
                                              {
                                                kind = "identifier";
                                                value = "font";
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
                                              value = "mkInt32";
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
                                          value = "command-output-font-family";
                                        }
                                      ];
                                      type = "assignment";
                                      value = {
                                        name = "path";
                                        path = [
                                          {
                                            kind = "identifier";
                                            value = "command";
                                          }
                                          {
                                            kind = "identifier";
                                            value = "font";
                                          }
                                          {
                                            kind = "identifier";
                                            value = "family";
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
                                          value = "command-output-font-weight";
                                        }
                                      ];
                                      type = "assignment";
                                      value = {
                                        name = "path";
                                        path = [
                                          {
                                            kind = "identifier";
                                            value = "command";
                                          }
                                          {
                                            kind = "identifier";
                                            value = "font";
                                          }
                                          {
                                            kind = "identifier";
                                            value = "weight";
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
                                          value = "command-output-font-style";
                                        }
                                      ];
                                      type = "assignment";
                                      value = {
                                        name = "path";
                                        path = [
                                          {
                                            kind = "identifier";
                                            value = "command";
                                          }
                                          {
                                            kind = "identifier";
                                            value = "font";
                                          }
                                          {
                                            kind = "identifier";
                                            value = "style";
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
                                          value = "time-font-color";
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
                                                value = "time";
                                              }
                                              {
                                                kind = "identifier";
                                                value = "font";
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
                                          value = "time-font-size";
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
                                                value = "time";
                                              }
                                              {
                                                kind = "identifier";
                                                value = "font";
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
                                              value = "mkInt32";
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
                                          value = "time-font-family";
                                        }
                                      ];
                                      type = "assignment";
                                      value = {
                                        name = "path";
                                        path = [
                                          {
                                            kind = "identifier";
                                            value = "time";
                                          }
                                          {
                                            kind = "identifier";
                                            value = "font";
                                          }
                                          {
                                            kind = "identifier";
                                            value = "family";
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
                                          value = "time-font-weight";
                                        }
                                      ];
                                      type = "assignment";
                                      value = {
                                        name = "path";
                                        path = [
                                          {
                                            kind = "identifier";
                                            value = "time";
                                          }
                                          {
                                            kind = "identifier";
                                            value = "font";
                                          }
                                          {
                                            kind = "identifier";
                                            value = "weight";
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
                                          value = "time-font-style";
                                        }
                                      ];
                                      type = "assignment";
                                      value = {
                                        name = "path";
                                        path = [
                                          {
                                            kind = "identifier";
                                            value = "time";
                                          }
                                          {
                                            kind = "identifier";
                                            value = "font";
                                          }
                                          {
                                            kind = "identifier";
                                            value = "style";
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
                                          value = "date-font-color";
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
                                                value = "date";
                                              }
                                              {
                                                kind = "identifier";
                                                value = "font";
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
                                          value = "date-font-size";
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
                                                value = "date";
                                              }
                                              {
                                                kind = "identifier";
                                                value = "font";
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
                                              value = "mkInt32";
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
                                          value = "date-font-family";
                                        }
                                      ];
                                      type = "assignment";
                                      value = {
                                        name = "path";
                                        path = [
                                          {
                                            kind = "identifier";
                                            value = "date";
                                          }
                                          {
                                            kind = "identifier";
                                            value = "font";
                                          }
                                          {
                                            kind = "identifier";
                                            value = "family";
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
                                          value = "date-font-weight";
                                        }
                                      ];
                                      type = "assignment";
                                      value = {
                                        name = "path";
                                        path = [
                                          {
                                            kind = "identifier";
                                            value = "date";
                                          }
                                          {
                                            kind = "identifier";
                                            value = "font";
                                          }
                                          {
                                            kind = "identifier";
                                            value = "weight";
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
                                          value = "date-font-style";
                                        }
                                      ];
                                      type = "assignment";
                                      value = {
                                        name = "path";
                                        path = [
                                          {
                                            kind = "identifier";
                                            value = "date";
                                          }
                                          {
                                            kind = "identifier";
                                            value = "font";
                                          }
                                          {
                                            kind = "identifier";
                                            value = "style";
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
                                          value = "hint-font-color";
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
                                                value = "hint";
                                              }
                                              {
                                                kind = "identifier";
                                                value = "font";
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
                                          value = "hint-font-size";
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
                                                value = "hint";
                                              }
                                              {
                                                kind = "identifier";
                                                value = "font";
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
                                              value = "mkInt32";
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
                                          value = "hint-font-family";
                                        }
                                      ];
                                      type = "assignment";
                                      value = {
                                        name = "path";
                                        path = [
                                          {
                                            kind = "identifier";
                                            value = "hint";
                                          }
                                          {
                                            kind = "identifier";
                                            value = "font";
                                          }
                                          {
                                            kind = "identifier";
                                            value = "family";
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
                                          value = "hint-font-weight";
                                        }
                                      ];
                                      type = "assignment";
                                      value = {
                                        name = "path";
                                        path = [
                                          {
                                            kind = "identifier";
                                            value = "hint";
                                          }
                                          {
                                            kind = "identifier";
                                            value = "font";
                                          }
                                          {
                                            kind = "identifier";
                                            value = "weight";
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
                                          value = "hint-font-style";
                                        }
                                      ];
                                      type = "assignment";
                                      value = {
                                        name = "path";
                                        path = [
                                          {
                                            kind = "identifier";
                                            value = "hint";
                                          }
                                          {
                                            kind = "identifier";
                                            value = "font";
                                          }
                                          {
                                            kind = "identifier";
                                            value = "style";
                                          }
                                        ];
                                        type = "variable";
                                      };
                                    }
                                  ];
                                  type = "attr-set";
                                };
                              }
                            ];
                            type = "attr-set";
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
            value = "command";
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
                                value = "Display output from a custom shell command";
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
                  value = "text";
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
                                value = "whoami";
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
                                value = "Shell command to execute for output display";
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
                  value = "font";
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
                                      value = "rgba(255, 244, 177, 1.0)";
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
                                      value = "CSS color (Hex or RGBA)";
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
                                  value = 48;
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
                                      value = "Font size in points (20-96)";
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
                        value = "family";
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
                                      value = "Default";
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
                                      value = "Font family name";
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
                        value = "weight";
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
                                      value = "Default";
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
                                      value = "Typography weight";
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
                        value = "style";
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
                                      value = "Default";
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
                                      value = "Typography style";
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
            value = "time";
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
                                value = "Show the lock screen clock";
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
                  value = "text";
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
                                value = "Custom strftime format pattern";
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
                  value = "style";
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
                                        value = "digital";
                                      }
                                    ];
                                    type = "string";
                                  }
                                  {
                                    multiline = false;
                                    parts = [
                                      {
                                        type = "text";
                                        value = "analog";
                                      }
                                    ];
                                    type = "string";
                                  }
                                  {
                                    multiline = false;
                                    parts = [
                                      {
                                        type = "text";
                                        value = "led";
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
                                value = "digital";
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
                                value = "Clock face rendering style";
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
                  value = "font";
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
                                      value = "rgba(160, 230, 163, 1.0)";
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
                                      value = "CSS color (Hex or RGBA)";
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
                                  value = 96;
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
                                      value = "Font size in points (20-96)";
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
                        value = "family";
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
                                      value = "Default";
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
                                      value = "Font family name";
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
                        value = "weight";
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
                                      value = "Default";
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
                                      value = "Typography weight";
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
                        value = "style";
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
                                      value = "Default";
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
                                      value = "Typography style";
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
            value = "date";
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
                                value = "Show the lock screen date";
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
                  value = "text";
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
                                value = "Custom date format pattern";
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
                  value = "font";
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
                                      value = "rgba(242, 92, 84, 1.0)";
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
                                      value = "CSS color (Hex or RGBA)";
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
                                  value = 28;
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
                                      value = "Font size in points (20-96)";
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
                        value = "family";
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
                                      value = "Default";
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
                                      value = "Font family name";
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
                        value = "weight";
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
                                      value = "Default";
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
                                      value = "Typography weight";
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
                        value = "style";
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
                                      value = "Default";
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
                                      value = "Typography style";
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
            value = "hint";
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
                                value = "Show the 'swipe up to unlock' hint";
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
                  value = "font";
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
                                      value = "rgba(212, 237, 138, 1.0)";
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
                                      value = "CSS color (Hex or RGBA)";
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
                                  value = 20;
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
                                      value = "Font size in points (20-96)";
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
                        value = "family";
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
                                      value = "Default";
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
                                      value = "Font family name";
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
                        value = "weight";
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
                                      value = "Default";
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
                                      value = "Typography weight";
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
                        value = "style";
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
                                      value = "Default";
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
                                      value = "Typography style";
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
    ];
  }; }
    (let hexToDecMap = (builtins.addErrorContext "_let hexToDecMap annotation mismatch: /nix/store/3ni594f60hm22hcrazxd35dmk7pwi61m-zenpkgs-dsl-source/modules/desktops/gnome/extensions/customize-clock-on-lockscreen.zmdl:20:1" ((_zenType: _zenValue: let force = type: value: if type.name == "anything" then true else if type.name == "listOf" then builtins.all (force type.nestedTypes.elemType) value else if type.name == "attrsOf" then builtins.all (force type.nestedTypes.elemType) (builtins.attrValues value) else if type.name == "either" then force (if type.nestedTypes.left.check value then type.nestedTypes.left else type.nestedTypes.right) value else builtins.seq value true; in builtins.seq (force _zenType _zenValue) _zenValue) ((lib.types.attrsOf lib.types.int)) ((lib.evalModules { modules = [ { options.value = lib.mkOption { type = (lib.types.attrsOf lib.types.int); }; config.value = {
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
}; } ]; }).config.value))); hexValue = (builtins.addErrorContext "_let hexValue annotation mismatch: /nix/store/3ni594f60hm22hcrazxd35dmk7pwi61m-zenpkgs-dsl-source/modules/desktops/gnome/extensions/customize-clock-on-lockscreen.zmdl:21:1" ((_zenType: _zenValue: let force = type: value: if type.name == "anything" then true else if type.name == "listOf" then builtins.all (force type.nestedTypes.elemType) value else if type.name == "attrsOf" then builtins.all (force type.nestedTypes.elemType) (builtins.attrValues value) else if type.name == "either" then force (if type.nestedTypes.left.check value then type.nestedTypes.left else type.nestedTypes.right) value else builtins.seq value true; in builtins.seq (force _zenType _zenValue) _zenValue) ((lib.types.addCheck lib.types.unspecified builtins.isFunction)) ((lib.evalModules { modules = [ { options.value = lib.mkOption { type = (lib.types.addCheck lib.types.unspecified builtins.isFunction); }; config.value = (c: (if ((lib.hasAttr c) hexToDecMap) then ((lib.getAttr c) hexToDecMap) else 0)); } ]; }).config.value))); parseHexByte = (builtins.addErrorContext "_let parseHexByte annotation mismatch: /nix/store/3ni594f60hm22hcrazxd35dmk7pwi61m-zenpkgs-dsl-source/modules/desktops/gnome/extensions/customize-clock-on-lockscreen.zmdl:22:1" ((_zenType: _zenValue: let force = type: value: if type.name == "anything" then true else if type.name == "listOf" then builtins.all (force type.nestedTypes.elemType) value else if type.name == "attrsOf" then builtins.all (force type.nestedTypes.elemType) (builtins.attrValues value) else if type.name == "either" then force (if type.nestedTypes.left.check value then type.nestedTypes.left else type.nestedTypes.right) value else builtins.seq value true; in builtins.seq (force _zenType _zenValue) _zenValue) ((lib.types.addCheck lib.types.unspecified builtins.isFunction)) ((lib.evalModules { modules = [ { options.value = lib.mkOption { type = (lib.types.addCheck lib.types.unspecified builtins.isFunction); }; config.value = (s: ((((hexValue ((((lib.substring 0) 1) s))) * 16)) + (hexValue ((((lib.substring 1) 1) s))))); } ]; }).config.value))); serializeFloat = (builtins.addErrorContext "_let serializeFloat annotation mismatch: /nix/store/3ni594f60hm22hcrazxd35dmk7pwi61m-zenpkgs-dsl-source/modules/desktops/gnome/extensions/customize-clock-on-lockscreen.zmdl:23:1" ((_zenType: _zenValue: let force = type: value: if type.name == "anything" then true else if type.name == "listOf" then builtins.all (force type.nestedTypes.elemType) value else if type.name == "attrsOf" then builtins.all (force type.nestedTypes.elemType) (builtins.attrValues value) else if type.name == "either" then force (if type.nestedTypes.left.check value then type.nestedTypes.left else type.nestedTypes.right) value else builtins.seq value true; in builtins.seq (force _zenType _zenValue) _zenValue) ((lib.types.addCheck lib.types.unspecified builtins.isFunction)) ((lib.evalModules { modules = [ { options.value = lib.mkOption { type = (lib.types.addCheck lib.types.unspecified builtins.isFunction); }; config.value = (f: (let
  s = (lib.toString f);
in (if ((lib.hasInfix ".") s) then s else "${((value: let kind = builtins.typeOf value; in if kind == "string" then value else if kind == "bool" || kind == "int" || kind == "float" then builtins.toJSON value else if kind == "path" then "${value}" else if kind == "set" && (value.type or null) == "derivation" && builtins.isString (value.outPath or null) then value.outPath else throw "/nix/store/3ni594f60hm22hcrazxd35dmk7pwi61m-zenpkgs-dsl-source/modules/desktops/gnome/extensions/customize-clock-on-lockscreen.zmdl:23: string interpolation requires a scalar, path, or package") (s))}.0"))); } ]; }).config.value))); toRgbaString = (builtins.addErrorContext "_let toRgbaString annotation mismatch: /nix/store/3ni594f60hm22hcrazxd35dmk7pwi61m-zenpkgs-dsl-source/modules/desktops/gnome/extensions/customize-clock-on-lockscreen.zmdl:24:1" ((_zenType: _zenValue: let force = type: value: if type.name == "anything" then true else if type.name == "listOf" then builtins.all (force type.nestedTypes.elemType) value else if type.name == "attrsOf" then builtins.all (force type.nestedTypes.elemType) (builtins.attrValues value) else if type.name == "either" then force (if type.nestedTypes.left.check value then type.nestedTypes.left else type.nestedTypes.right) value else builtins.seq value true; in builtins.seq (force _zenType _zenValue) _zenValue) ((lib.types.addCheck lib.types.unspecified builtins.isFunction)) ((lib.evalModules { modules = [ { options.value = lib.mkOption { type = (lib.types.addCheck lib.types.unspecified builtins.isFunction); }; config.value = (val: (if ((lib.isString val) && ((lib.hasPrefix "#") val)) then (let
  hex = ((lib.removePrefix "#") val);
  r = (lib.toString ((parseHexByte ((((lib.substring 0) 2) hex)))));
  g = (lib.toString ((parseHexByte ((((lib.substring 2) 2) hex)))));
  b = (lib.toString ((parseHexByte ((((lib.substring 4) 2) hex)))));
  a = (if ((lib.stringLength hex) == 8) then (serializeFloat (((parseHexByte ((((lib.substring 6) 2) hex))) / 255.0))) else "1.0");
in "rgba(${((value: let kind = builtins.typeOf value; in if kind == "string" then value else if kind == "bool" || kind == "int" || kind == "float" then builtins.toJSON value else if kind == "path" then "${value}" else if kind == "set" && (value.type or null) == "derivation" && builtins.isString (value.outPath or null) then value.outPath else throw "/nix/store/3ni594f60hm22hcrazxd35dmk7pwi61m-zenpkgs-dsl-source/modules/desktops/gnome/extensions/customize-clock-on-lockscreen.zmdl:32: string interpolation requires a scalar, path, or package") (r))}, ${((value: let kind = builtins.typeOf value; in if kind == "string" then value else if kind == "bool" || kind == "int" || kind == "float" then builtins.toJSON value else if kind == "path" then "${value}" else if kind == "set" && (value.type or null) == "derivation" && builtins.isString (value.outPath or null) then value.outPath else throw "/nix/store/3ni594f60hm22hcrazxd35dmk7pwi61m-zenpkgs-dsl-source/modules/desktops/gnome/extensions/customize-clock-on-lockscreen.zmdl:32: string interpolation requires a scalar, path, or package") (g))}, ${((value: let kind = builtins.typeOf value; in if kind == "string" then value else if kind == "bool" || kind == "int" || kind == "float" then builtins.toJSON value else if kind == "path" then "${value}" else if kind == "set" && (value.type or null) == "derivation" && builtins.isString (value.outPath or null) then value.outPath else throw "/nix/store/3ni594f60hm22hcrazxd35dmk7pwi61m-zenpkgs-dsl-source/modules/desktops/gnome/extensions/customize-clock-on-lockscreen.zmdl:32: string interpolation requires a scalar, path, or package") (b))}, ${((value: let kind = builtins.typeOf value; in if kind == "string" then value else if kind == "bool" || kind == "int" || kind == "float" then builtins.toJSON value else if kind == "path" then "${value}" else if kind == "set" && (value.type or null) == "derivation" && builtins.isString (value.outPath or null) then value.outPath else throw "/nix/store/3ni594f60hm22hcrazxd35dmk7pwi61m-zenpkgs-dsl-source/modules/desktops/gnome/extensions/customize-clock-on-lockscreen.zmdl:32: string interpolation requires a scalar, path, or package") (a))})") else val)); } ]; }).config.value))); in (lib.mkIf ((cfg.enable)) { home-manager.sharedModules = [ {
      dconf.settings."org/gnome/shell".enabled-extensions = [
        pkgs.zenos.legacy.gnomeExtensions.customize-clock-on-lock-screen.extensionUuid
      ];
    } ]; }))
    (let hexToDecMap = (builtins.addErrorContext "_let hexToDecMap annotation mismatch: /nix/store/3ni594f60hm22hcrazxd35dmk7pwi61m-zenpkgs-dsl-source/modules/desktops/gnome/extensions/customize-clock-on-lockscreen.zmdl:20:1" ((_zenType: _zenValue: let force = type: value: if type.name == "anything" then true else if type.name == "listOf" then builtins.all (force type.nestedTypes.elemType) value else if type.name == "attrsOf" then builtins.all (force type.nestedTypes.elemType) (builtins.attrValues value) else if type.name == "either" then force (if type.nestedTypes.left.check value then type.nestedTypes.left else type.nestedTypes.right) value else builtins.seq value true; in builtins.seq (force _zenType _zenValue) _zenValue) ((lib.types.attrsOf lib.types.int)) ((lib.evalModules { modules = [ { options.value = lib.mkOption { type = (lib.types.attrsOf lib.types.int); }; config.value = {
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
}; } ]; }).config.value))); hexValue = (builtins.addErrorContext "_let hexValue annotation mismatch: /nix/store/3ni594f60hm22hcrazxd35dmk7pwi61m-zenpkgs-dsl-source/modules/desktops/gnome/extensions/customize-clock-on-lockscreen.zmdl:21:1" ((_zenType: _zenValue: let force = type: value: if type.name == "anything" then true else if type.name == "listOf" then builtins.all (force type.nestedTypes.elemType) value else if type.name == "attrsOf" then builtins.all (force type.nestedTypes.elemType) (builtins.attrValues value) else if type.name == "either" then force (if type.nestedTypes.left.check value then type.nestedTypes.left else type.nestedTypes.right) value else builtins.seq value true; in builtins.seq (force _zenType _zenValue) _zenValue) ((lib.types.addCheck lib.types.unspecified builtins.isFunction)) ((lib.evalModules { modules = [ { options.value = lib.mkOption { type = (lib.types.addCheck lib.types.unspecified builtins.isFunction); }; config.value = (c: (if ((lib.hasAttr c) hexToDecMap) then ((lib.getAttr c) hexToDecMap) else 0)); } ]; }).config.value))); parseHexByte = (builtins.addErrorContext "_let parseHexByte annotation mismatch: /nix/store/3ni594f60hm22hcrazxd35dmk7pwi61m-zenpkgs-dsl-source/modules/desktops/gnome/extensions/customize-clock-on-lockscreen.zmdl:22:1" ((_zenType: _zenValue: let force = type: value: if type.name == "anything" then true else if type.name == "listOf" then builtins.all (force type.nestedTypes.elemType) value else if type.name == "attrsOf" then builtins.all (force type.nestedTypes.elemType) (builtins.attrValues value) else if type.name == "either" then force (if type.nestedTypes.left.check value then type.nestedTypes.left else type.nestedTypes.right) value else builtins.seq value true; in builtins.seq (force _zenType _zenValue) _zenValue) ((lib.types.addCheck lib.types.unspecified builtins.isFunction)) ((lib.evalModules { modules = [ { options.value = lib.mkOption { type = (lib.types.addCheck lib.types.unspecified builtins.isFunction); }; config.value = (s: ((((hexValue ((((lib.substring 0) 1) s))) * 16)) + (hexValue ((((lib.substring 1) 1) s))))); } ]; }).config.value))); serializeFloat = (builtins.addErrorContext "_let serializeFloat annotation mismatch: /nix/store/3ni594f60hm22hcrazxd35dmk7pwi61m-zenpkgs-dsl-source/modules/desktops/gnome/extensions/customize-clock-on-lockscreen.zmdl:23:1" ((_zenType: _zenValue: let force = type: value: if type.name == "anything" then true else if type.name == "listOf" then builtins.all (force type.nestedTypes.elemType) value else if type.name == "attrsOf" then builtins.all (force type.nestedTypes.elemType) (builtins.attrValues value) else if type.name == "either" then force (if type.nestedTypes.left.check value then type.nestedTypes.left else type.nestedTypes.right) value else builtins.seq value true; in builtins.seq (force _zenType _zenValue) _zenValue) ((lib.types.addCheck lib.types.unspecified builtins.isFunction)) ((lib.evalModules { modules = [ { options.value = lib.mkOption { type = (lib.types.addCheck lib.types.unspecified builtins.isFunction); }; config.value = (f: (let
  s = (lib.toString f);
in (if ((lib.hasInfix ".") s) then s else "${((value: let kind = builtins.typeOf value; in if kind == "string" then value else if kind == "bool" || kind == "int" || kind == "float" then builtins.toJSON value else if kind == "path" then "${value}" else if kind == "set" && (value.type or null) == "derivation" && builtins.isString (value.outPath or null) then value.outPath else throw "/nix/store/3ni594f60hm22hcrazxd35dmk7pwi61m-zenpkgs-dsl-source/modules/desktops/gnome/extensions/customize-clock-on-lockscreen.zmdl:23: string interpolation requires a scalar, path, or package") (s))}.0"))); } ]; }).config.value))); toRgbaString = (builtins.addErrorContext "_let toRgbaString annotation mismatch: /nix/store/3ni594f60hm22hcrazxd35dmk7pwi61m-zenpkgs-dsl-source/modules/desktops/gnome/extensions/customize-clock-on-lockscreen.zmdl:24:1" ((_zenType: _zenValue: let force = type: value: if type.name == "anything" then true else if type.name == "listOf" then builtins.all (force type.nestedTypes.elemType) value else if type.name == "attrsOf" then builtins.all (force type.nestedTypes.elemType) (builtins.attrValues value) else if type.name == "either" then force (if type.nestedTypes.left.check value then type.nestedTypes.left else type.nestedTypes.right) value else builtins.seq value true; in builtins.seq (force _zenType _zenValue) _zenValue) ((lib.types.addCheck lib.types.unspecified builtins.isFunction)) ((lib.evalModules { modules = [ { options.value = lib.mkOption { type = (lib.types.addCheck lib.types.unspecified builtins.isFunction); }; config.value = (val: (if ((lib.isString val) && ((lib.hasPrefix "#") val)) then (let
  hex = ((lib.removePrefix "#") val);
  r = (lib.toString ((parseHexByte ((((lib.substring 0) 2) hex)))));
  g = (lib.toString ((parseHexByte ((((lib.substring 2) 2) hex)))));
  b = (lib.toString ((parseHexByte ((((lib.substring 4) 2) hex)))));
  a = (if ((lib.stringLength hex) == 8) then (serializeFloat (((parseHexByte ((((lib.substring 6) 2) hex))) / 255.0))) else "1.0");
in "rgba(${((value: let kind = builtins.typeOf value; in if kind == "string" then value else if kind == "bool" || kind == "int" || kind == "float" then builtins.toJSON value else if kind == "path" then "${value}" else if kind == "set" && (value.type or null) == "derivation" && builtins.isString (value.outPath or null) then value.outPath else throw "/nix/store/3ni594f60hm22hcrazxd35dmk7pwi61m-zenpkgs-dsl-source/modules/desktops/gnome/extensions/customize-clock-on-lockscreen.zmdl:32: string interpolation requires a scalar, path, or package") (r))}, ${((value: let kind = builtins.typeOf value; in if kind == "string" then value else if kind == "bool" || kind == "int" || kind == "float" then builtins.toJSON value else if kind == "path" then "${value}" else if kind == "set" && (value.type or null) == "derivation" && builtins.isString (value.outPath or null) then value.outPath else throw "/nix/store/3ni594f60hm22hcrazxd35dmk7pwi61m-zenpkgs-dsl-source/modules/desktops/gnome/extensions/customize-clock-on-lockscreen.zmdl:32: string interpolation requires a scalar, path, or package") (g))}, ${((value: let kind = builtins.typeOf value; in if kind == "string" then value else if kind == "bool" || kind == "int" || kind == "float" then builtins.toJSON value else if kind == "path" then "${value}" else if kind == "set" && (value.type or null) == "derivation" && builtins.isString (value.outPath or null) then value.outPath else throw "/nix/store/3ni594f60hm22hcrazxd35dmk7pwi61m-zenpkgs-dsl-source/modules/desktops/gnome/extensions/customize-clock-on-lockscreen.zmdl:32: string interpolation requires a scalar, path, or package") (b))}, ${((value: let kind = builtins.typeOf value; in if kind == "string" then value else if kind == "bool" || kind == "int" || kind == "float" then builtins.toJSON value else if kind == "path" then "${value}" else if kind == "set" && (value.type or null) == "derivation" && builtins.isString (value.outPath or null) then value.outPath else throw "/nix/store/3ni594f60hm22hcrazxd35dmk7pwi61m-zenpkgs-dsl-source/modules/desktops/gnome/extensions/customize-clock-on-lockscreen.zmdl:32: string interpolation requires a scalar, path, or package") (a))})") else val)); } ]; }).config.value))); in (lib.mkIf ((cfg.enable)) {
      environment.systemPackages = [
        pkgs.zenos.legacy.gnomeExtensions.customize-clock-on-lock-screen
      ];
      programs.dconf.profiles.user.databases = [
        {
          settings."org/gnome/shell/extensions/customize-clock-on-lockscreen" = {
            remove-command-output = (!cfg.command.enable);
            remove-time = (!cfg.time.enable);
            remove-date = (!cfg.date.enable);
            remove-hint = (!cfg.hint.enable);
            command = cfg.command.text;
            custom-time-text = cfg.time.text;
            custom-date-text = cfg.date.text;
            clock-style = cfg.time.style;
            command-output-font-color = (toRgbaString cfg.command.font.color);
            command-output-font-size = (lib.gvariant.mkInt32 cfg.command.font.size);
            command-output-font-family = cfg.command.font.family;
            command-output-font-weight = cfg.command.font.weight;
            command-output-font-style = cfg.command.font.style;
            time-font-color = (toRgbaString cfg.time.font.color);
            time-font-size = (lib.gvariant.mkInt32 cfg.time.font.size);
            time-font-family = cfg.time.font.family;
            time-font-weight = cfg.time.font.weight;
            time-font-style = cfg.time.font.style;
            date-font-color = (toRgbaString cfg.date.font.color);
            date-font-size = (lib.gvariant.mkInt32 cfg.date.font.size);
            date-font-family = cfg.date.font.family;
            date-font-weight = cfg.date.font.weight;
            date-font-style = cfg.date.font.style;
            hint-font-color = (toRgbaString cfg.hint.font.color);
            hint-font-size = (lib.gvariant.mkInt32 cfg.hint.font.size);
            hint-font-family = cfg.hint.font.family;
            hint-font-weight = cfg.hint.font.weight;
            hint-font-style = cfg.hint.font.style;
          };
        }
      ];
    }))
  ];
}
