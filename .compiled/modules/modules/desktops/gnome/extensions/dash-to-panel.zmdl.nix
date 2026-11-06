{ config, lib, pkgs, maintainers ? lib.maintainers, licenses ? lib.licenses, ... }:
let
  cfg = config.zenos.desktops.gnome.extensions.dash-to-panel;
  name = "dash-to-panel";
  mkGVariantString = (builtins.addErrorContext "_let mkGVariantString annotation mismatch: /nix/store/59qqzf108ga8h2qmsjizzsn2p7i889xx-zenpkgs-dsl-source/modules/desktops/gnome/extensions/dash-to-panel.zmdl:22:1" ((_zenType: _zenValue: let force = type: value: if type.name == "anything" then true else if type.name == "listOf" then builtins.all (force type.nestedTypes.elemType) value else if type.name == "attrsOf" then builtins.all (force type.nestedTypes.elemType) (builtins.attrValues value) else if type.name == "either" then force (if type.nestedTypes.left.check value then type.nestedTypes.left else type.nestedTypes.right) value else builtins.seq value true; in builtins.seq (force _zenType _zenValue) _zenValue) ((lib.types.addCheck lib.types.unspecified builtins.isFunction)) ((lib.evalModules { modules = [ { options.value = lib.mkOption { type = (lib.types.addCheck lib.types.unspecified builtins.isFunction); }; config.value = (v: "'${((value: let kind = builtins.typeOf value; in if kind == "string" then value else if kind == "bool" || kind == "int" || kind == "float" then builtins.toJSON value else if kind == "path" then "${value}" else if kind == "set" && (value.type or null) == "derivation" && builtins.isString (value.outPath or null) then value.outPath else throw "/nix/store/59qqzf108ga8h2qmsjizzsn2p7i889xx-zenpkgs-dsl-source/modules/desktops/gnome/extensions/dash-to-panel.zmdl:22: string interpolation requires a scalar, path, or package") (v))}'"); } ]; }).config.value)));
  mkGVariantDouble = (builtins.addErrorContext "_let mkGVariantDouble annotation mismatch: /nix/store/59qqzf108ga8h2qmsjizzsn2p7i889xx-zenpkgs-dsl-source/modules/desktops/gnome/extensions/dash-to-panel.zmdl:23:1" ((_zenType: _zenValue: let force = type: value: if type.name == "anything" then true else if type.name == "listOf" then builtins.all (force type.nestedTypes.elemType) value else if type.name == "attrsOf" then builtins.all (force type.nestedTypes.elemType) (builtins.attrValues value) else if type.name == "either" then force (if type.nestedTypes.left.check value then type.nestedTypes.left else type.nestedTypes.right) value else builtins.seq value true; in builtins.seq (force _zenType _zenValue) _zenValue) ((lib.types.addCheck lib.types.unspecified builtins.isFunction)) ((lib.evalModules { modules = [ { options.value = lib.mkOption { type = (lib.types.addCheck lib.types.unspecified builtins.isFunction); }; config.value = (v: (let
    s = (lib.toString v);
  in (if ((lib.hasInfix ".") s) then s else "${((value: let kind = builtins.typeOf value; in if kind == "string" then value else if kind == "bool" || kind == "int" || kind == "float" then builtins.toJSON value else if kind == "path" then "${value}" else if kind == "set" && (value.type or null) == "derivation" && builtins.isString (value.outPath or null) then value.outPath else throw "/nix/store/59qqzf108ga8h2qmsjizzsn2p7i889xx-zenpkgs-dsl-source/modules/desktops/gnome/extensions/dash-to-panel.zmdl:23: string interpolation requires a scalar, path, or package") (s))}.0"))); } ]; }).config.value)));
  serializeMap = (builtins.addErrorContext "_let serializeMap annotation mismatch: /nix/store/59qqzf108ga8h2qmsjizzsn2p7i889xx-zenpkgs-dsl-source/modules/desktops/gnome/extensions/dash-to-panel.zmdl:24:1" ((_zenType: _zenValue: let force = type: value: if type.name == "anything" then true else if type.name == "listOf" then builtins.all (force type.nestedTypes.elemType) value else if type.name == "attrsOf" then builtins.all (force type.nestedTypes.elemType) (builtins.attrValues value) else if type.name == "either" then force (if type.nestedTypes.left.check value then type.nestedTypes.left else type.nestedTypes.right) value else builtins.seq value true; in builtins.seq (force _zenType _zenValue) _zenValue) ((lib.types.addCheck lib.types.unspecified builtins.isFunction)) ((lib.evalModules { modules = [ { options.value = lib.mkOption { type = (lib.types.addCheck lib.types.unspecified builtins.isFunction); }; config.value = (formatter: (values: (if (values == { }) then "@a{s*} {}" else "{${((value: let kind = builtins.typeOf value; in if kind == "string" then value else if kind == "bool" || kind == "int" || kind == "float" then builtins.toJSON value else if kind == "path" then "${value}" else if kind == "set" && (value.type or null) == "derivation" && builtins.isString (value.outPath or null) then value.outPath else throw "/nix/store/59qqzf108ga8h2qmsjizzsn2p7i889xx-zenpkgs-dsl-source/modules/desktops/gnome/extensions/dash-to-panel.zmdl:26: string interpolation requires a scalar, path, or package") (((lib.concatStringsSep ", ") (((lib.mapAttrsToList ((k: (v: "${((value: let kind = builtins.typeOf value; in if kind == "string" then value else if kind == "bool" || kind == "int" || kind == "float" then builtins.toJSON value else if kind == "path" then "${value}" else if kind == "set" && (value.type or null) == "derivation" && builtins.isString (value.outPath or null) then value.outPath else throw "/nix/store/59qqzf108ga8h2qmsjizzsn2p7i889xx-zenpkgs-dsl-source/modules/desktops/gnome/extensions/dash-to-panel.zmdl:26: string interpolation requires a scalar, path, or package") ((mkGVariantString k)))}: ${((value: let kind = builtins.typeOf value; in if kind == "string" then value else if kind == "bool" || kind == "int" || kind == "float" then builtins.toJSON value else if kind == "path" then "${value}" else if kind == "set" && (value.type or null) == "derivation" && builtins.isString (value.outPath or null) then value.outPath else throw "/nix/store/59qqzf108ga8h2qmsjizzsn2p7i889xx-zenpkgs-dsl-source/modules/desktops/gnome/extensions/dash-to-panel.zmdl:26: string interpolation requires a scalar, path, or package") ((formatter v)))}")))) values)))))}}"))); } ]; }).config.value)));
  serializeMapStrDouble = (builtins.addErrorContext "_let serializeMapStrDouble annotation mismatch: /nix/store/59qqzf108ga8h2qmsjizzsn2p7i889xx-zenpkgs-dsl-source/modules/desktops/gnome/extensions/dash-to-panel.zmdl:27:1" ((_zenType: _zenValue: let force = type: value: if type.name == "anything" then true else if type.name == "listOf" then builtins.all (force type.nestedTypes.elemType) value else if type.name == "attrsOf" then builtins.all (force type.nestedTypes.elemType) (builtins.attrValues value) else if type.name == "either" then force (if type.nestedTypes.left.check value then type.nestedTypes.left else type.nestedTypes.right) value else builtins.seq value true; in builtins.seq (force _zenType _zenValue) _zenValue) ((lib.types.addCheck lib.types.unspecified builtins.isFunction)) ((lib.evalModules { modules = [ { options.value = lib.mkOption { type = (lib.types.addCheck lib.types.unspecified builtins.isFunction); }; config.value = (serializeMap mkGVariantDouble); } ]; }).config.value)));
  serializeMapStrUint = (builtins.addErrorContext "_let serializeMapStrUint annotation mismatch: /nix/store/59qqzf108ga8h2qmsjizzsn2p7i889xx-zenpkgs-dsl-source/modules/desktops/gnome/extensions/dash-to-panel.zmdl:28:1" ((_zenType: _zenValue: let force = type: value: if type.name == "anything" then true else if type.name == "listOf" then builtins.all (force type.nestedTypes.elemType) value else if type.name == "attrsOf" then builtins.all (force type.nestedTypes.elemType) (builtins.attrValues value) else if type.name == "either" then force (if type.nestedTypes.left.check value then type.nestedTypes.left else type.nestedTypes.right) value else builtins.seq value true; in builtins.seq (force _zenType _zenValue) _zenValue) ((lib.types.addCheck lib.types.unspecified builtins.isFunction)) ((lib.evalModules { modules = [ { options.value = lib.mkOption { type = (lib.types.addCheck lib.types.unspecified builtins.isFunction); }; config.value = (serializeMap ((v: "uint32 ${((value: let kind = builtins.typeOf value; in if kind == "string" then value else if kind == "bool" || kind == "int" || kind == "float" then builtins.toJSON value else if kind == "path" then "${value}" else if kind == "set" && (value.type or null) == "derivation" && builtins.isString (value.outPath or null) then value.outPath else throw "/nix/store/59qqzf108ga8h2qmsjizzsn2p7i889xx-zenpkgs-dsl-source/modules/desktops/gnome/extensions/dash-to-panel.zmdl:28: string interpolation requires a scalar, path, or package") ((lib.toString v)))}"))); } ]; }).config.value)));
  serializeMapStrInt = (builtins.addErrorContext "_let serializeMapStrInt annotation mismatch: /nix/store/59qqzf108ga8h2qmsjizzsn2p7i889xx-zenpkgs-dsl-source/modules/desktops/gnome/extensions/dash-to-panel.zmdl:29:1" ((_zenType: _zenValue: let force = type: value: if type.name == "anything" then true else if type.name == "listOf" then builtins.all (force type.nestedTypes.elemType) value else if type.name == "attrsOf" then builtins.all (force type.nestedTypes.elemType) (builtins.attrValues value) else if type.name == "either" then force (if type.nestedTypes.left.check value then type.nestedTypes.left else type.nestedTypes.right) value else builtins.seq value true; in builtins.seq (force _zenType _zenValue) _zenValue) ((lib.types.addCheck lib.types.unspecified builtins.isFunction)) ((lib.evalModules { modules = [ { options.value = lib.mkOption { type = (lib.types.addCheck lib.types.unspecified builtins.isFunction); }; config.value = (serializeMap lib.toString); } ]; }).config.value)));
in
{
  options.zenos.desktops.gnome.extensions.dash-to-panel = lib.mkOption { type = (lib.types.submodule ({ ... }: (let mkGVariantString = (builtins.addErrorContext "_let mkGVariantString annotation mismatch: /nix/store/59qqzf108ga8h2qmsjizzsn2p7i889xx-zenpkgs-dsl-source/modules/desktops/gnome/extensions/dash-to-panel.zmdl:22:1" ((_zenType: _zenValue: let force = type: value: if type.name == "anything" then true else if type.name == "listOf" then builtins.all (force type.nestedTypes.elemType) value else if type.name == "attrsOf" then builtins.all (force type.nestedTypes.elemType) (builtins.attrValues value) else if type.name == "either" then force (if type.nestedTypes.left.check value then type.nestedTypes.left else type.nestedTypes.right) value else builtins.seq value true; in builtins.seq (force _zenType _zenValue) _zenValue) ((lib.types.addCheck lib.types.unspecified builtins.isFunction)) ((lib.evalModules { modules = [ { options.value = lib.mkOption { type = (lib.types.addCheck lib.types.unspecified builtins.isFunction); }; config.value = (v: "'${((value: let kind = builtins.typeOf value; in if kind == "string" then value else if kind == "bool" || kind == "int" || kind == "float" then builtins.toJSON value else if kind == "path" then "${value}" else if kind == "set" && (value.type or null) == "derivation" && builtins.isString (value.outPath or null) then value.outPath else throw "/nix/store/59qqzf108ga8h2qmsjizzsn2p7i889xx-zenpkgs-dsl-source/modules/desktops/gnome/extensions/dash-to-panel.zmdl:22: string interpolation requires a scalar, path, or package") (v))}'"); } ]; }).config.value))); mkGVariantDouble = (builtins.addErrorContext "_let mkGVariantDouble annotation mismatch: /nix/store/59qqzf108ga8h2qmsjizzsn2p7i889xx-zenpkgs-dsl-source/modules/desktops/gnome/extensions/dash-to-panel.zmdl:23:1" ((_zenType: _zenValue: let force = type: value: if type.name == "anything" then true else if type.name == "listOf" then builtins.all (force type.nestedTypes.elemType) value else if type.name == "attrsOf" then builtins.all (force type.nestedTypes.elemType) (builtins.attrValues value) else if type.name == "either" then force (if type.nestedTypes.left.check value then type.nestedTypes.left else type.nestedTypes.right) value else builtins.seq value true; in builtins.seq (force _zenType _zenValue) _zenValue) ((lib.types.addCheck lib.types.unspecified builtins.isFunction)) ((lib.evalModules { modules = [ { options.value = lib.mkOption { type = (lib.types.addCheck lib.types.unspecified builtins.isFunction); }; config.value = (v: (let
        s = (lib.toString v);
      in (if ((lib.hasInfix ".") s) then s else "${((value: let kind = builtins.typeOf value; in if kind == "string" then value else if kind == "bool" || kind == "int" || kind == "float" then builtins.toJSON value else if kind == "path" then "${value}" else if kind == "set" && (value.type or null) == "derivation" && builtins.isString (value.outPath or null) then value.outPath else throw "/nix/store/59qqzf108ga8h2qmsjizzsn2p7i889xx-zenpkgs-dsl-source/modules/desktops/gnome/extensions/dash-to-panel.zmdl:23: string interpolation requires a scalar, path, or package") (s))}.0"))); } ]; }).config.value))); serializeMap = (builtins.addErrorContext "_let serializeMap annotation mismatch: /nix/store/59qqzf108ga8h2qmsjizzsn2p7i889xx-zenpkgs-dsl-source/modules/desktops/gnome/extensions/dash-to-panel.zmdl:24:1" ((_zenType: _zenValue: let force = type: value: if type.name == "anything" then true else if type.name == "listOf" then builtins.all (force type.nestedTypes.elemType) value else if type.name == "attrsOf" then builtins.all (force type.nestedTypes.elemType) (builtins.attrValues value) else if type.name == "either" then force (if type.nestedTypes.left.check value then type.nestedTypes.left else type.nestedTypes.right) value else builtins.seq value true; in builtins.seq (force _zenType _zenValue) _zenValue) ((lib.types.addCheck lib.types.unspecified builtins.isFunction)) ((lib.evalModules { modules = [ { options.value = lib.mkOption { type = (lib.types.addCheck lib.types.unspecified builtins.isFunction); }; config.value = (formatter: (values: (if (values == { }) then "@a{s*} {}" else "{${((value: let kind = builtins.typeOf value; in if kind == "string" then value else if kind == "bool" || kind == "int" || kind == "float" then builtins.toJSON value else if kind == "path" then "${value}" else if kind == "set" && (value.type or null) == "derivation" && builtins.isString (value.outPath or null) then value.outPath else throw "/nix/store/59qqzf108ga8h2qmsjizzsn2p7i889xx-zenpkgs-dsl-source/modules/desktops/gnome/extensions/dash-to-panel.zmdl:26: string interpolation requires a scalar, path, or package") (((lib.concatStringsSep ", ") (((lib.mapAttrsToList ((k: (v: "${((value: let kind = builtins.typeOf value; in if kind == "string" then value else if kind == "bool" || kind == "int" || kind == "float" then builtins.toJSON value else if kind == "path" then "${value}" else if kind == "set" && (value.type or null) == "derivation" && builtins.isString (value.outPath or null) then value.outPath else throw "/nix/store/59qqzf108ga8h2qmsjizzsn2p7i889xx-zenpkgs-dsl-source/modules/desktops/gnome/extensions/dash-to-panel.zmdl:26: string interpolation requires a scalar, path, or package") ((mkGVariantString k)))}: ${((value: let kind = builtins.typeOf value; in if kind == "string" then value else if kind == "bool" || kind == "int" || kind == "float" then builtins.toJSON value else if kind == "path" then "${value}" else if kind == "set" && (value.type or null) == "derivation" && builtins.isString (value.outPath or null) then value.outPath else throw "/nix/store/59qqzf108ga8h2qmsjizzsn2p7i889xx-zenpkgs-dsl-source/modules/desktops/gnome/extensions/dash-to-panel.zmdl:26: string interpolation requires a scalar, path, or package") ((formatter v)))}")))) values)))))}}"))); } ]; }).config.value))); serializeMapStrDouble = (builtins.addErrorContext "_let serializeMapStrDouble annotation mismatch: /nix/store/59qqzf108ga8h2qmsjizzsn2p7i889xx-zenpkgs-dsl-source/modules/desktops/gnome/extensions/dash-to-panel.zmdl:27:1" ((_zenType: _zenValue: let force = type: value: if type.name == "anything" then true else if type.name == "listOf" then builtins.all (force type.nestedTypes.elemType) value else if type.name == "attrsOf" then builtins.all (force type.nestedTypes.elemType) (builtins.attrValues value) else if type.name == "either" then force (if type.nestedTypes.left.check value then type.nestedTypes.left else type.nestedTypes.right) value else builtins.seq value true; in builtins.seq (force _zenType _zenValue) _zenValue) ((lib.types.addCheck lib.types.unspecified builtins.isFunction)) ((lib.evalModules { modules = [ { options.value = lib.mkOption { type = (lib.types.addCheck lib.types.unspecified builtins.isFunction); }; config.value = (serializeMap mkGVariantDouble); } ]; }).config.value))); serializeMapStrUint = (builtins.addErrorContext "_let serializeMapStrUint annotation mismatch: /nix/store/59qqzf108ga8h2qmsjizzsn2p7i889xx-zenpkgs-dsl-source/modules/desktops/gnome/extensions/dash-to-panel.zmdl:28:1" ((_zenType: _zenValue: let force = type: value: if type.name == "anything" then true else if type.name == "listOf" then builtins.all (force type.nestedTypes.elemType) value else if type.name == "attrsOf" then builtins.all (force type.nestedTypes.elemType) (builtins.attrValues value) else if type.name == "either" then force (if type.nestedTypes.left.check value then type.nestedTypes.left else type.nestedTypes.right) value else builtins.seq value true; in builtins.seq (force _zenType _zenValue) _zenValue) ((lib.types.addCheck lib.types.unspecified builtins.isFunction)) ((lib.evalModules { modules = [ { options.value = lib.mkOption { type = (lib.types.addCheck lib.types.unspecified builtins.isFunction); }; config.value = (serializeMap ((v: "uint32 ${((value: let kind = builtins.typeOf value; in if kind == "string" then value else if kind == "bool" || kind == "int" || kind == "float" then builtins.toJSON value else if kind == "path" then "${value}" else if kind == "set" && (value.type or null) == "derivation" && builtins.isString (value.outPath or null) then value.outPath else throw "/nix/store/59qqzf108ga8h2qmsjizzsn2p7i889xx-zenpkgs-dsl-source/modules/desktops/gnome/extensions/dash-to-panel.zmdl:28: string interpolation requires a scalar, path, or package") ((lib.toString v)))}"))); } ]; }).config.value))); serializeMapStrInt = (builtins.addErrorContext "_let serializeMapStrInt annotation mismatch: /nix/store/59qqzf108ga8h2qmsjizzsn2p7i889xx-zenpkgs-dsl-source/modules/desktops/gnome/extensions/dash-to-panel.zmdl:29:1" ((_zenType: _zenValue: let force = type: value: if type.name == "anything" then true else if type.name == "listOf" then builtins.all (force type.nestedTypes.elemType) value else if type.name == "attrsOf" then builtins.all (force type.nestedTypes.elemType) (builtins.attrValues value) else if type.name == "either" then force (if type.nestedTypes.left.check value then type.nestedTypes.left else type.nestedTypes.right) value else builtins.seq value true; in builtins.seq (force _zenType _zenValue) _zenValue) ((lib.types.addCheck lib.types.unspecified builtins.isFunction)) ((lib.evalModules { modules = [ { options.value = lib.mkOption { type = (lib.types.addCheck lib.types.unspecified builtins.isFunction); }; config.value = (serializeMap lib.toString); } ]; }).config.value))); in { options = { animations = lib.mkOption { type = (lib.types.submodule ({ ... }: { options = { appicon-hover = lib.mkOption { type = (lib.types.submodule ({ ... }: { options = { convexity = lib.mkOption { type = (lib.types.attrsOf lib.types.float); default = {
  RIPPLE = 2.0;
  PLANK = 1.0;
}; description = "Deformation curvature map"; }; duration = lib.mkOption { type = (lib.types.attrsOf lib.types.int); default = {
  SIMPLE = 160;
  RIPPLE = 130;
  PLANK = 100;
}; description = "Animation speed map"; }; enable = lib.mkOption { type = lib.types.bool; default = false; description = "Enable mouse hover animations for icons"; }; extent = lib.mkOption { type = (lib.types.attrsOf lib.types.int); default = {
  RIPPLE = 4;
  PLANK = 4;
}; description = "Animation spread map"; }; rotation = lib.mkOption { type = (lib.types.attrsOf lib.types.int); default = {
  SIMPLE = 0;
  RIPPLE = 10;
  PLANK = 0;
}; description = "Icon rotation map"; }; travel = lib.mkOption { type = (lib.types.attrsOf lib.types.float); default = {
  SIMPLE = 0.3;
  RIPPLE = 0.4;
  PLANK = 0.0;
}; description = "Translation distance map"; }; zoom = lib.mkOption { type = (lib.types.attrsOf lib.types.float); default = {
  SIMPLE = 1.0;
  RIPPLE = 1.25;
  PLANK = 2.0;
}; description = "Scale factor map"; }; }; })); default = { }; }; }; })); default = { }; }; behavior = lib.mkOption { type = (lib.types.submodule ({ ... }: { options = { click-action = lib.mkOption { type = lib.types.str; default = "CYCLE-MIN"; description = "Primary interaction button behavior"; }; group-apps = lib.mkOption { type = lib.types.bool; default = true; description = "Unify multiple windows under one icon"; }; isolate-monitors = lib.mkOption { type = lib.types.bool; default = false; description = "Filter items by hardware monitor"; }; isolate-workspaces = lib.mkOption { type = lib.types.bool; default = false; description = "Filter items by current desktop"; }; scroll-panel-action = lib.mkOption { type = lib.types.str; default = "SWITCH_WORKSPACE"; description = "Mouse scroll wheel behavior on the panel"; }; show-window-previews = lib.mkOption { type = lib.types.bool; default = true; description = "Show live thumbnails on icon hover"; }; }; })); default = { }; }; enable = lib.mkOption { type = lib.types.bool; default = false; description = "Whether to enable Dash to Panel GNOME extension configuration."; }; extraSettings = lib.mkOption { type = lib.types.attrs; default = { }; description = "Direct schema-key overrides for dconf"; }; intellihide = lib.mkOption { type = (lib.types.submodule ({ ... }: { options = { animation-time = lib.mkOption { type = lib.types.int; default = 200; description = "Visual transition time in milliseconds"; }; behavior = lib.mkOption { type = (lib.types.enum [
  "ALL_WINDOWS"
  "FOCUSED_WINDOWS"
  "MAXIMIZED_WINDOWS"
]); default = "FOCUSED_WINDOWS"; description = "Hiding trigger policy"; }; enable = lib.mkOption { type = lib.types.bool; default = false; description = "Hide panel when obstructed by windows"; }; }; })); default = { }; }; positioning = lib.mkOption { type = (lib.types.submodule ({ ... }: { options = { panel-lengths = lib.mkOption { type = lib.types.str; default = "{}"; description = "Per-monitor panel lengths (JSON)"; }; panel-position = lib.mkOption { type = (lib.types.enum [
  "BOTTOM"
  "TOP"
  "LEFT"
  "RIGHT"
]); default = "BOTTOM"; description = "Anchor edge for the consolidated panel"; }; panel-size = lib.mkOption { type = lib.types.int; default = 48; description = "Consolidated panel thickness in pixels"; }; panel-sizes = lib.mkOption { type = lib.types.str; default = "{}"; description = "Per-monitor panel thicknesses (JSON)"; }; }; })); default = { }; }; style = lib.mkOption { type = (lib.types.submodule ({ ... }: { options = { appicon-margin = lib.mkOption { type = lib.types.int; default = 8; description = "Pixel margin around application icons"; }; appicon-padding = lib.mkOption { type = lib.types.int; default = 4; description = "Internal padding for application icons"; }; dot-position = lib.mkOption { type = (lib.types.enum [
  "BOTTOM"
  "TOP"
]); default = "BOTTOM"; description = "Placement of the active window marker"; }; dot-style-focused = lib.mkOption { type = (lib.types.enum [
  "METRO"
  "DOTS"
  "SQUARES"
  "DASHES"
  "SEGMENTED"
  "SOLID"
  "CILIORA"
]); default = "METRO"; description = "Visual style of the focused app marker"; }; dot-style-unfocused = lib.mkOption { type = (lib.types.enum [
  "METRO"
  "DOTS"
  "SQUARES"
  "DASHES"
  "SEGMENTED"
  "SOLID"
  "CILIORA"
]); default = "METRO"; description = "Visual style of unfocused app markers"; }; transparency = lib.mkOption { type = (lib.types.submodule ({ ... }: { options = { color = lib.mkOption { type = lib.types.str; default = "#000000"; description = "Custom panel background color (Hex)"; }; dynamic = lib.mkOption { type = lib.types.bool; default = false; description = "Adjust opacity based on window proximity"; }; enable = lib.mkOption { type = lib.types.bool; default = false; description = "Enable shell theme transparency overrides"; }; opacity = lib.mkOption { type = lib.types.float; default = 0.4; description = "Fixed panel alpha transparency (0.0-1.0)"; }; }; })); default = { }; }; }; })); default = { }; }; }; }))); default = { }; };
  config = lib.mkMerge [
    { _module.args.zenlang.descriptors.desktops.gnome.extensions.dash-to-panel = {
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
            value = "\n    Combined taskbar and panel interface for GNOME Shell\n\n    This module installs and configures the **Dash to Panel** extension for GNOME.\n    It combines the Dash and the Top Bar into a single panel, similar to\n    Windows or KDE Plasma.\n\n    **Features:**\n    - Integrated taskbar and system tray.\n    - Highly configurable positioning and sizing.\n    - Window previews and indicators.\n    - Extensive customization for transparency and styling.\n  ";
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
            value = "Combined taskbar and panel interface for GNOME Shell";
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
    moduleIdentity = "zenos.desktops.gnome.extensions.dash-to-panel";
    modulePath = [
      "desktops"
      "gnome"
      "extensions"
      "dash-to-panel"
    ];
    nodeMetadata = [
      {
        metadata = {
          description = {
            multiline = true;
            parts = [
              {
                type = "text";
                value = "\n    Combined taskbar and panel interface for GNOME Shell\n\n    This module installs and configures the **Dash to Panel** extension for GNOME.\n    It combines the Dash and the Top Bar into a single panel, similar to\n    Windows or KDE Plasma.\n\n    **Features:**\n    - Integrated taskbar and system tray.\n    - Highly configurable positioning and sizing.\n    - Window previews and indicators.\n    - Extensive customization for transparency and styling.\n  ";
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
                value = "Combined taskbar and panel interface for GNOME Shell";
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
                value = "Whether to enable Dash to Panel GNOME extension configuration.";
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
          "positioning"
        ];
      }
      {
        metadata = {
          default = {
            multiline = false;
            parts = [
              {
                type = "text";
                value = "BOTTOM";
              }
            ];
            type = "string";
          };
          description = {
            multiline = true;
            parts = [
              {
                type = "text";
                value = "Anchor edge for the consolidated panel";
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
                        value = "BOTTOM";
                      }
                    ];
                    type = "string";
                  }
                  {
                    multiline = false;
                    parts = [
                      {
                        type = "text";
                        value = "TOP";
                      }
                    ];
                    type = "string";
                  }
                  {
                    multiline = false;
                    parts = [
                      {
                        type = "text";
                        value = "LEFT";
                      }
                    ];
                    type = "string";
                  }
                  {
                    multiline = false;
                    parts = [
                      {
                        type = "text";
                        value = "RIGHT";
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
          "positioning"
          "panel-position"
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
                value = "Consolidated panel thickness in pixels";
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
          "positioning"
          "panel-size"
        ];
      }
      {
        metadata = {
          default = {
            multiline = false;
            parts = [
              {
                type = "text";
                value = "{}";
              }
            ];
            type = "string";
          };
          description = {
            multiline = true;
            parts = [
              {
                type = "text";
                value = "Per-monitor panel lengths (JSON)";
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
          "positioning"
          "panel-lengths"
        ];
      }
      {
        metadata = {
          default = {
            multiline = false;
            parts = [
              {
                type = "text";
                value = "{}";
              }
            ];
            type = "string";
          };
          description = {
            multiline = true;
            parts = [
              {
                type = "text";
                value = "Per-monitor panel thicknesses (JSON)";
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
          "positioning"
          "panel-sizes"
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
          "style"
        ];
      }
      {
        metadata = {
          default = {
            kind = "integer";
            type = "literal";
            value = 8;
          };
          description = {
            multiline = true;
            parts = [
              {
                type = "text";
                value = "Pixel margin around application icons";
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
          "style"
          "appicon-margin"
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
                value = "Internal padding for application icons";
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
          "style"
          "appicon-padding"
        ];
      }
      {
        metadata = {
          default = {
            multiline = false;
            parts = [
              {
                type = "text";
                value = "BOTTOM";
              }
            ];
            type = "string";
          };
          description = {
            multiline = true;
            parts = [
              {
                type = "text";
                value = "Placement of the active window marker";
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
                        value = "BOTTOM";
                      }
                    ];
                    type = "string";
                  }
                  {
                    multiline = false;
                    parts = [
                      {
                        type = "text";
                        value = "TOP";
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
          "style"
          "dot-position"
        ];
      }
      {
        metadata = {
          default = {
            multiline = false;
            parts = [
              {
                type = "text";
                value = "METRO";
              }
            ];
            type = "string";
          };
          description = {
            multiline = true;
            parts = [
              {
                type = "text";
                value = "Visual style of the focused app marker";
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
                        value = "METRO";
                      }
                    ];
                    type = "string";
                  }
                  {
                    multiline = false;
                    parts = [
                      {
                        type = "text";
                        value = "DOTS";
                      }
                    ];
                    type = "string";
                  }
                  {
                    multiline = false;
                    parts = [
                      {
                        type = "text";
                        value = "SQUARES";
                      }
                    ];
                    type = "string";
                  }
                  {
                    multiline = false;
                    parts = [
                      {
                        type = "text";
                        value = "DASHES";
                      }
                    ];
                    type = "string";
                  }
                  {
                    multiline = false;
                    parts = [
                      {
                        type = "text";
                        value = "SEGMENTED";
                      }
                    ];
                    type = "string";
                  }
                  {
                    multiline = false;
                    parts = [
                      {
                        type = "text";
                        value = "SOLID";
                      }
                    ];
                    type = "string";
                  }
                  {
                    multiline = false;
                    parts = [
                      {
                        type = "text";
                        value = "CILIORA";
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
          "style"
          "dot-style-focused"
        ];
      }
      {
        metadata = {
          default = {
            multiline = false;
            parts = [
              {
                type = "text";
                value = "METRO";
              }
            ];
            type = "string";
          };
          description = {
            multiline = true;
            parts = [
              {
                type = "text";
                value = "Visual style of unfocused app markers";
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
                        value = "METRO";
                      }
                    ];
                    type = "string";
                  }
                  {
                    multiline = false;
                    parts = [
                      {
                        type = "text";
                        value = "DOTS";
                      }
                    ];
                    type = "string";
                  }
                  {
                    multiline = false;
                    parts = [
                      {
                        type = "text";
                        value = "SQUARES";
                      }
                    ];
                    type = "string";
                  }
                  {
                    multiline = false;
                    parts = [
                      {
                        type = "text";
                        value = "DASHES";
                      }
                    ];
                    type = "string";
                  }
                  {
                    multiline = false;
                    parts = [
                      {
                        type = "text";
                        value = "SEGMENTED";
                      }
                    ];
                    type = "string";
                  }
                  {
                    multiline = false;
                    parts = [
                      {
                        type = "text";
                        value = "SOLID";
                      }
                    ];
                    type = "string";
                  }
                  {
                    multiline = false;
                    parts = [
                      {
                        type = "text";
                        value = "CILIORA";
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
          "style"
          "dot-style-unfocused"
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
          "style"
          "transparency"
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
                value = "Enable shell theme transparency overrides";
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
          "style"
          "transparency"
          "enable"
        ];
      }
      {
        metadata = {
          default = {
            kind = "float";
            type = "literal";
            value = 0.4;
          };
          description = {
            multiline = true;
            parts = [
              {
                type = "text";
                value = "Fixed panel alpha transparency (0.0-1.0)";
              }
            ];
            type = "string";
          };
          type = {
            name = "type";
            path = [
              {
                kind = "identifier";
                value = "float";
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
          "style"
          "transparency"
          "opacity"
        ];
      }
      {
        metadata = {
          default = {
            multiline = false;
            parts = [
              {
                type = "text";
                value = "#000000";
              }
            ];
            type = "string";
          };
          description = {
            multiline = true;
            parts = [
              {
                type = "text";
                value = "Custom panel background color (Hex)";
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
          "style"
          "transparency"
          "color"
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
                value = "Adjust opacity based on window proximity";
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
          "style"
          "transparency"
          "dynamic"
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
          "behavior"
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
                value = "Filter items by current desktop";
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
          "behavior"
          "isolate-workspaces"
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
                value = "Filter items by hardware monitor";
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
          "behavior"
          "isolate-monitors"
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
                value = "Unify multiple windows under one icon";
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
          "behavior"
          "group-apps"
        ];
      }
      {
        metadata = {
          default = {
            multiline = false;
            parts = [
              {
                type = "text";
                value = "CYCLE-MIN";
              }
            ];
            type = "string";
          };
          description = {
            multiline = true;
            parts = [
              {
                type = "text";
                value = "Primary interaction button behavior";
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
          "behavior"
          "click-action"
        ];
      }
      {
        metadata = {
          default = {
            multiline = false;
            parts = [
              {
                type = "text";
                value = "SWITCH_WORKSPACE";
              }
            ];
            type = "string";
          };
          description = {
            multiline = true;
            parts = [
              {
                type = "text";
                value = "Mouse scroll wheel behavior on the panel";
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
          "behavior"
          "scroll-panel-action"
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
                value = "Show live thumbnails on icon hover";
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
          "behavior"
          "show-window-previews"
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
          "intellihide"
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
                value = "Hide panel when obstructed by windows";
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
          "intellihide"
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
                value = "FOCUSED_WINDOWS";
              }
            ];
            type = "string";
          };
          description = {
            multiline = true;
            parts = [
              {
                type = "text";
                value = "Hiding trigger policy";
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
                        value = "ALL_WINDOWS";
                      }
                    ];
                    type = "string";
                  }
                  {
                    multiline = false;
                    parts = [
                      {
                        type = "text";
                        value = "FOCUSED_WINDOWS";
                      }
                    ];
                    type = "string";
                  }
                  {
                    multiline = false;
                    parts = [
                      {
                        type = "text";
                        value = "MAXIMIZED_WINDOWS";
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
          "intellihide"
          "behavior"
        ];
      }
      {
        metadata = {
          default = {
            kind = "integer";
            type = "literal";
            value = 200;
          };
          description = {
            multiline = true;
            parts = [
              {
                type = "text";
                value = "Visual transition time in milliseconds";
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
          "intellihide"
          "animation-time"
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
          "animations"
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
          "animations"
          "appicon-hover"
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
                value = "Enable mouse hover animations for icons";
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
          "animations"
          "appicon-hover"
          "enable"
        ];
      }
      {
        metadata = {
          default = {
            recursive = false;
            statements = [
              {
                operator = "=";
                target = [
                  {
                    kind = "identifier";
                    value = "RIPPLE";
                  }
                ];
                type = "assignment";
                value = {
                  kind = "float";
                  type = "literal";
                  value = 2.0;
                };
              }
              {
                operator = "=";
                target = [
                  {
                    kind = "identifier";
                    value = "PLANK";
                  }
                ];
                type = "assignment";
                value = {
                  kind = "float";
                  type = "literal";
                  value = 1.0;
                };
              }
            ];
            type = "attr-set";
          };
          description = {
            multiline = true;
            parts = [
              {
                type = "text";
                value = "Deformation curvature map";
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
                        value = "float";
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
          zenosVersion = {
            kind = "version";
            type = "literal";
            value = "1.0.0Na";
          };
        };
        path = [
          "animations"
          "appicon-hover"
          "convexity"
        ];
      }
      {
        metadata = {
          default = {
            recursive = false;
            statements = [
              {
                operator = "=";
                target = [
                  {
                    kind = "identifier";
                    value = "SIMPLE";
                  }
                ];
                type = "assignment";
                value = {
                  kind = "integer";
                  type = "literal";
                  value = 160;
                };
              }
              {
                operator = "=";
                target = [
                  {
                    kind = "identifier";
                    value = "RIPPLE";
                  }
                ];
                type = "assignment";
                value = {
                  kind = "integer";
                  type = "literal";
                  value = 130;
                };
              }
              {
                operator = "=";
                target = [
                  {
                    kind = "identifier";
                    value = "PLANK";
                  }
                ];
                type = "assignment";
                value = {
                  kind = "integer";
                  type = "literal";
                  value = 100;
                };
              }
            ];
            type = "attr-set";
          };
          description = {
            multiline = true;
            parts = [
              {
                type = "text";
                value = "Animation speed map";
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
          zenosVersion = {
            kind = "version";
            type = "literal";
            value = "1.0.0Na";
          };
        };
        path = [
          "animations"
          "appicon-hover"
          "duration"
        ];
      }
      {
        metadata = {
          default = {
            recursive = false;
            statements = [
              {
                operator = "=";
                target = [
                  {
                    kind = "identifier";
                    value = "RIPPLE";
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
                    value = "PLANK";
                  }
                ];
                type = "assignment";
                value = {
                  kind = "integer";
                  type = "literal";
                  value = 4;
                };
              }
            ];
            type = "attr-set";
          };
          description = {
            multiline = true;
            parts = [
              {
                type = "text";
                value = "Animation spread map";
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
          zenosVersion = {
            kind = "version";
            type = "literal";
            value = "1.0.0Na";
          };
        };
        path = [
          "animations"
          "appicon-hover"
          "extent"
        ];
      }
      {
        metadata = {
          default = {
            recursive = false;
            statements = [
              {
                operator = "=";
                target = [
                  {
                    kind = "identifier";
                    value = "SIMPLE";
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
                    value = "RIPPLE";
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
                    kind = "identifier";
                    value = "PLANK";
                  }
                ];
                type = "assignment";
                value = {
                  kind = "integer";
                  type = "literal";
                  value = 0;
                };
              }
            ];
            type = "attr-set";
          };
          description = {
            multiline = true;
            parts = [
              {
                type = "text";
                value = "Icon rotation map";
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
          zenosVersion = {
            kind = "version";
            type = "literal";
            value = "1.0.0Na";
          };
        };
        path = [
          "animations"
          "appicon-hover"
          "rotation"
        ];
      }
      {
        metadata = {
          default = {
            recursive = false;
            statements = [
              {
                operator = "=";
                target = [
                  {
                    kind = "identifier";
                    value = "SIMPLE";
                  }
                ];
                type = "assignment";
                value = {
                  kind = "float";
                  type = "literal";
                  value = 0.3;
                };
              }
              {
                operator = "=";
                target = [
                  {
                    kind = "identifier";
                    value = "RIPPLE";
                  }
                ];
                type = "assignment";
                value = {
                  kind = "float";
                  type = "literal";
                  value = 0.4;
                };
              }
              {
                operator = "=";
                target = [
                  {
                    kind = "identifier";
                    value = "PLANK";
                  }
                ];
                type = "assignment";
                value = {
                  kind = "float";
                  type = "literal";
                  value = 0.0;
                };
              }
            ];
            type = "attr-set";
          };
          description = {
            multiline = true;
            parts = [
              {
                type = "text";
                value = "Translation distance map";
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
                        value = "float";
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
          zenosVersion = {
            kind = "version";
            type = "literal";
            value = "1.0.0Na";
          };
        };
        path = [
          "animations"
          "appicon-hover"
          "travel"
        ];
      }
      {
        metadata = {
          default = {
            recursive = false;
            statements = [
              {
                operator = "=";
                target = [
                  {
                    kind = "identifier";
                    value = "SIMPLE";
                  }
                ];
                type = "assignment";
                value = {
                  kind = "float";
                  type = "literal";
                  value = 1.0;
                };
              }
              {
                operator = "=";
                target = [
                  {
                    kind = "identifier";
                    value = "RIPPLE";
                  }
                ];
                type = "assignment";
                value = {
                  kind = "float";
                  type = "literal";
                  value = 1.25;
                };
              }
              {
                operator = "=";
                target = [
                  {
                    kind = "identifier";
                    value = "PLANK";
                  }
                ];
                type = "assignment";
                value = {
                  kind = "float";
                  type = "literal";
                  value = 2.0;
                };
              }
            ];
            type = "attr-set";
          };
          description = {
            multiline = true;
            parts = [
              {
                type = "text";
                value = "Scale factor map";
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
                        value = "float";
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
          zenosVersion = {
            kind = "version";
            type = "literal";
            value = "1.0.0Na";
          };
        };
        path = [
          "animations"
          "appicon-hover"
          "zoom"
        ];
      }
      {
        metadata = {
          default = {
            recursive = false;
            statements = [ ];
            type = "attr-set";
          };
          description = {
            multiline = true;
            parts = [
              {
                type = "text";
                value = "Direct schema-key overrides for dconf";
              }
            ];
            type = "string";
          };
          type = {
            name = "type";
            path = [
              {
                kind = "identifier";
                value = "set";
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
          "extraSettings"
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
                    value = "Combined taskbar and panel interface for GNOME Shell";
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
                    value = "\n    Combined taskbar and panel interface for GNOME Shell\n\n    This module installs and configures the **Dash to Panel** extension for GNOME.\n    It combines the Dash and the Top Bar into a single panel, similar to\n    Windows or KDE Plasma.\n\n    **Features:**\n    - Integrated taskbar and system tray.\n    - Highly configurable positioning and sizing.\n    - Window previews and indicators.\n    - Extensive customization for transparency and styling.\n  ";
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
                  value = "string";
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
        name = "mkGVariantString";
        type = "let-binding";
        value = {
          body = {
            multiline = false;
            parts = [
              {
                type = "text";
                value = "'";
              }
              {
                expression = {
                  path = [
                    {
                      kind = "identifier";
                      value = "v";
                    }
                  ];
                  type = "reference";
                };
                type = "interpolation";
              }
              {
                type = "text";
                value = "'";
              }
            ];
            type = "string";
          };
          form = "identifier";
          parameters = [
            {
              default = null;
              name = "v";
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
                  value = "double";
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
        name = "mkGVariantDouble";
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
                          value = "v";
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
              name = "v";
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
                  value = "map";
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
        name = "serializeMap";
        type = "let-binding";
        value = {
          body = {
            body = {
              condition = {
                left = {
                  path = [
                    {
                      kind = "identifier";
                      value = "values";
                    }
                  ];
                  type = "reference";
                };
                operator = "==";
                right = {
                  recursive = false;
                  statements = [ ];
                  type = "attr-set";
                };
                type = "binary";
              };
              "else" = {
                multiline = false;
                parts = [
                  {
                    type = "text";
                    value = "{";
                  }
                  {
                    expression = {
                      arguments = [
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
                                  type = "group";
                                  value = {
                                    body = {
                                      body = {
                                        multiline = false;
                                        parts = [
                                          {
                                            expression = {
                                              arguments = [
                                                {
                                                  path = [
                                                    {
                                                      kind = "identifier";
                                                      value = "k";
                                                    }
                                                  ];
                                                  type = "reference";
                                                }
                                              ];
                                              callee = {
                                                name = "v";
                                                path = [
                                                  {
                                                    kind = "identifier";
                                                    value = "mkGVariantString";
                                                  }
                                                ];
                                                type = "variable";
                                              };
                                              type = "call";
                                            };
                                            type = "interpolation";
                                          }
                                          {
                                            type = "text";
                                            value = ": ";
                                          }
                                          {
                                            expression = {
                                              arguments = [
                                                {
                                                  path = [
                                                    {
                                                      kind = "identifier";
                                                      value = "v";
                                                    }
                                                  ];
                                                  type = "reference";
                                                }
                                              ];
                                              callee = {
                                                path = [
                                                  {
                                                    kind = "identifier";
                                                    value = "formatter";
                                                  }
                                                ];
                                                type = "reference";
                                              };
                                              type = "call";
                                            };
                                            type = "interpolation";
                                          }
                                        ];
                                        type = "string";
                                      };
                                      form = "identifier";
                                      parameters = [
                                        {
                                          default = null;
                                          name = "v";
                                          variadic = false;
                                        }
                                      ];
                                      type = "lambda";
                                    };
                                    form = "identifier";
                                    parameters = [
                                      {
                                        default = null;
                                        name = "k";
                                        variadic = false;
                                      }
                                    ];
                                    type = "lambda";
                                  };
                                }
                              ];
                              callee = {
                                name = "lib";
                                path = [
                                  {
                                    kind = "identifier";
                                    value = "mapAttrsToList";
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
                      callee = {
                        arguments = [
                          {
                            multiline = false;
                            parts = [
                              {
                                type = "text";
                                value = ", ";
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
                              value = "concatStringsSep";
                            }
                          ];
                          type = "variable";
                        };
                        type = "call";
                      };
                      type = "call";
                    };
                    type = "interpolation";
                  }
                  {
                    type = "text";
                    value = "}";
                  }
                ];
                type = "string";
              };
              "then" = {
                multiline = false;
                parts = [
                  {
                    type = "text";
                    value = "@a{s*} {}";
                  }
                ];
                type = "string";
              };
              type = "if";
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
          form = "identifier";
          parameters = [
            {
              default = null;
              name = "formatter";
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
                  value = "map";
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
        name = "serializeMapStrDouble";
        type = "let-binding";
        value = {
          arguments = [
            {
              name = "v";
              path = [
                {
                  kind = "identifier";
                  value = "mkGVariantDouble";
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
                value = "serializeMap";
              }
            ];
            type = "variable";
          };
          type = "call";
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
                  value = "map";
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
        name = "serializeMapStrUint";
        type = "let-binding";
        value = {
          arguments = [
            {
              type = "group";
              value = {
                body = {
                  multiline = false;
                  parts = [
                    {
                      type = "text";
                      value = "uint32 ";
                    }
                    {
                      expression = {
                        arguments = [
                          {
                            path = [
                              {
                                kind = "identifier";
                                value = "v";
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
                      type = "interpolation";
                    }
                  ];
                  type = "string";
                };
                form = "identifier";
                parameters = [
                  {
                    default = null;
                    name = "v";
                    variadic = false;
                  }
                ];
                type = "lambda";
              };
            }
          ];
          callee = {
            name = "v";
            path = [
              {
                kind = "identifier";
                value = "serializeMap";
              }
            ];
            type = "variable";
          };
          type = "call";
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
                  value = "map";
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
        name = "serializeMapStrInt";
        type = "let-binding";
        value = {
          arguments = [
            {
              name = "lib";
              path = [
                {
                  kind = "identifier";
                  value = "toString";
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
                value = "serializeMap";
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
                                value = "dash-to-panel";
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
                            value = "Whether to enable Dash to Panel GNOME extension configuration.";
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
                                value = "dash-to-panel";
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
                                    value = "org/gnome/shell/extensions/dash-to-panel";
                                  }
                                ];
                                type = "assignment";
                                value = {
                                  left = {
                                    recursive = false;
                                    statements = [
                                      {
                                        operator = "=";
                                        target = [
                                          {
                                            kind = "identifier";
                                            value = "panel-position";
                                          }
                                        ];
                                        type = "assignment";
                                        value = {
                                          name = "path";
                                          path = [
                                            {
                                              kind = "identifier";
                                              value = "positioning";
                                            }
                                            {
                                              kind = "identifier";
                                              value = "panel-position";
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
                                            value = "panel-size";
                                          }
                                        ];
                                        type = "assignment";
                                        value = {
                                          name = "path";
                                          path = [
                                            {
                                              kind = "identifier";
                                              value = "positioning";
                                            }
                                            {
                                              kind = "identifier";
                                              value = "panel-size";
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
                                            value = "panel-lengths";
                                          }
                                        ];
                                        type = "assignment";
                                        value = {
                                          name = "path";
                                          path = [
                                            {
                                              kind = "identifier";
                                              value = "positioning";
                                            }
                                            {
                                              kind = "identifier";
                                              value = "panel-lengths";
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
                                            value = "panel-sizes";
                                          }
                                        ];
                                        type = "assignment";
                                        value = {
                                          name = "path";
                                          path = [
                                            {
                                              kind = "identifier";
                                              value = "positioning";
                                            }
                                            {
                                              kind = "identifier";
                                              value = "panel-sizes";
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
                                            value = "appicon-margin";
                                          }
                                        ];
                                        type = "assignment";
                                        value = {
                                          name = "path";
                                          path = [
                                            {
                                              kind = "identifier";
                                              value = "style";
                                            }
                                            {
                                              kind = "identifier";
                                              value = "appicon-margin";
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
                                            value = "appicon-padding";
                                          }
                                        ];
                                        type = "assignment";
                                        value = {
                                          name = "path";
                                          path = [
                                            {
                                              kind = "identifier";
                                              value = "style";
                                            }
                                            {
                                              kind = "identifier";
                                              value = "appicon-padding";
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
                                            value = "dot-position";
                                          }
                                        ];
                                        type = "assignment";
                                        value = {
                                          name = "path";
                                          path = [
                                            {
                                              kind = "identifier";
                                              value = "style";
                                            }
                                            {
                                              kind = "identifier";
                                              value = "dot-position";
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
                                            value = "dot-style-focused";
                                          }
                                        ];
                                        type = "assignment";
                                        value = {
                                          name = "path";
                                          path = [
                                            {
                                              kind = "identifier";
                                              value = "style";
                                            }
                                            {
                                              kind = "identifier";
                                              value = "dot-style-focused";
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
                                            value = "dot-style-unfocused";
                                          }
                                        ];
                                        type = "assignment";
                                        value = {
                                          name = "path";
                                          path = [
                                            {
                                              kind = "identifier";
                                              value = "style";
                                            }
                                            {
                                              kind = "identifier";
                                              value = "dot-style-unfocused";
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
                                            value = "trans-use-custom-opacity";
                                          }
                                        ];
                                        type = "assignment";
                                        value = {
                                          name = "path";
                                          path = [
                                            {
                                              kind = "identifier";
                                              value = "style";
                                            }
                                            {
                                              kind = "identifier";
                                              value = "transparency";
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
                                            value = "trans-panel-opacity";
                                          }
                                        ];
                                        type = "assignment";
                                        value = {
                                          name = "path";
                                          path = [
                                            {
                                              kind = "identifier";
                                              value = "style";
                                            }
                                            {
                                              kind = "identifier";
                                              value = "transparency";
                                            }
                                            {
                                              kind = "identifier";
                                              value = "opacity";
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
                                            value = "trans-bg-color";
                                          }
                                        ];
                                        type = "assignment";
                                        value = {
                                          name = "path";
                                          path = [
                                            {
                                              kind = "identifier";
                                              value = "style";
                                            }
                                            {
                                              kind = "identifier";
                                              value = "transparency";
                                            }
                                            {
                                              kind = "identifier";
                                              value = "color";
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
                                            value = "trans-use-dynamic-opacity";
                                          }
                                        ];
                                        type = "assignment";
                                        value = {
                                          name = "path";
                                          path = [
                                            {
                                              kind = "identifier";
                                              value = "style";
                                            }
                                            {
                                              kind = "identifier";
                                              value = "transparency";
                                            }
                                            {
                                              kind = "identifier";
                                              value = "dynamic";
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
                                            value = "isolate-workspaces";
                                          }
                                        ];
                                        type = "assignment";
                                        value = {
                                          name = "path";
                                          path = [
                                            {
                                              kind = "identifier";
                                              value = "behavior";
                                            }
                                            {
                                              kind = "identifier";
                                              value = "isolate-workspaces";
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
                                            value = "isolate-monitors";
                                          }
                                        ];
                                        type = "assignment";
                                        value = {
                                          name = "path";
                                          path = [
                                            {
                                              kind = "identifier";
                                              value = "behavior";
                                            }
                                            {
                                              kind = "identifier";
                                              value = "isolate-monitors";
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
                                            value = "group-apps";
                                          }
                                        ];
                                        type = "assignment";
                                        value = {
                                          name = "path";
                                          path = [
                                            {
                                              kind = "identifier";
                                              value = "behavior";
                                            }
                                            {
                                              kind = "identifier";
                                              value = "group-apps";
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
                                            value = "click-action";
                                          }
                                        ];
                                        type = "assignment";
                                        value = {
                                          name = "path";
                                          path = [
                                            {
                                              kind = "identifier";
                                              value = "behavior";
                                            }
                                            {
                                              kind = "identifier";
                                              value = "click-action";
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
                                            value = "scroll-panel-action";
                                          }
                                        ];
                                        type = "assignment";
                                        value = {
                                          name = "path";
                                          path = [
                                            {
                                              kind = "identifier";
                                              value = "behavior";
                                            }
                                            {
                                              kind = "identifier";
                                              value = "scroll-panel-action";
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
                                            value = "show-window-previews";
                                          }
                                        ];
                                        type = "assignment";
                                        value = {
                                          name = "path";
                                          path = [
                                            {
                                              kind = "identifier";
                                              value = "behavior";
                                            }
                                            {
                                              kind = "identifier";
                                              value = "show-window-previews";
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
                                            value = "intellihide";
                                          }
                                        ];
                                        type = "assignment";
                                        value = {
                                          name = "path";
                                          path = [
                                            {
                                              kind = "identifier";
                                              value = "intellihide";
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
                                            value = "intellihide-behaviour";
                                          }
                                        ];
                                        type = "assignment";
                                        value = {
                                          name = "path";
                                          path = [
                                            {
                                              kind = "identifier";
                                              value = "intellihide";
                                            }
                                            {
                                              kind = "identifier";
                                              value = "behavior";
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
                                            value = "intellihide-animation-time";
                                          }
                                        ];
                                        type = "assignment";
                                        value = {
                                          name = "path";
                                          path = [
                                            {
                                              kind = "identifier";
                                              value = "intellihide";
                                            }
                                            {
                                              kind = "identifier";
                                              value = "animation-time";
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
                                            value = "animate-appicon-hover";
                                          }
                                        ];
                                        type = "assignment";
                                        value = {
                                          name = "path";
                                          path = [
                                            {
                                              kind = "identifier";
                                              value = "animations";
                                            }
                                            {
                                              kind = "identifier";
                                              value = "appicon-hover";
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
                                            value = "desktop-line-use-custom-color";
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
                                            value = "animate-app-switch";
                                          }
                                        ];
                                        type = "assignment";
                                        value = {
                                          kind = "true";
                                          type = "literal";
                                          value = true;
                                        };
                                      }
                                    ];
                                    type = "attr-set";
                                  };
                                  operator = "//";
                                  right = {
                                    name = "path";
                                    path = [
                                      {
                                        kind = "identifier";
                                        value = "extraSettings";
                                      }
                                    ];
                                    type = "variable";
                                  };
                                  type = "binary";
                                };
                              }
                            ];
                            type = "attr-set";
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
                          value = "systemd";
                        }
                        {
                          kind = "identifier";
                          value = "user";
                        }
                        {
                          kind = "identifier";
                          value = "services";
                        }
                        {
                          kind = "identifier";
                          value = "dash-to-panel-complex-config";
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
                              multiline = false;
                              parts = [
                                {
                                  type = "text";
                                  value = "Apply Dash to Panel complex configuration";
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
                                value = "wantedBy";
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
                                      value = "graphical-session.target";
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
                                value = "partOf";
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
                                      value = "graphical-session.target";
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
                                value = "serviceConfig";
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
                                      value = "Type";
                                    }
                                  ];
                                  type = "assignment";
                                  value = {
                                    multiline = false;
                                    parts = [
                                      {
                                        type = "text";
                                        value = "oneshot";
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
                                      value = "RemainAfterExit";
                                    }
                                  ];
                                  type = "assignment";
                                  value = {
                                    kind = "true";
                                    type = "literal";
                                    value = true;
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
                                value = "script";
                              }
                            ];
                            type = "assignment";
                            value = {
                              multiline = true;
                              parts = [
                                {
                                  type = "text";
                                  value = "\n          ";
                                }
                                {
                                  expression = {
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
                                        value = "dconf";
                                      }
                                    ];
                                    type = "variable";
                                  };
                                  type = "interpolation";
                                }
                                {
                                  type = "text";
                                  value = "/bin/dconf write /org/gnome/shell/extensions/dash-to-panel/animate-appicon-hover-animation-convexity ";
                                }
                                {
                                  expression = {
                                    arguments = [
                                      {
                                        type = "group";
                                        value = {
                                          arguments = [
                                            {
                                              name = "path";
                                              path = [
                                                {
                                                  kind = "identifier";
                                                  value = "animations";
                                                }
                                                {
                                                  kind = "identifier";
                                                  value = "appicon-hover";
                                                }
                                                {
                                                  kind = "identifier";
                                                  value = "convexity";
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
                                                value = "serializeMapStrDouble";
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
                                          value = "escapeShellArg";
                                        }
                                      ];
                                      type = "variable";
                                    };
                                    type = "call";
                                  };
                                  type = "interpolation";
                                }
                                {
                                  type = "text";
                                  value = "\n          ";
                                }
                                {
                                  expression = {
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
                                        value = "dconf";
                                      }
                                    ];
                                    type = "variable";
                                  };
                                  type = "interpolation";
                                }
                                {
                                  type = "text";
                                  value = "/bin/dconf write /org/gnome/shell/extensions/dash-to-panel/animate-appicon-hover-animation-duration ";
                                }
                                {
                                  expression = {
                                    arguments = [
                                      {
                                        type = "group";
                                        value = {
                                          arguments = [
                                            {
                                              name = "path";
                                              path = [
                                                {
                                                  kind = "identifier";
                                                  value = "animations";
                                                }
                                                {
                                                  kind = "identifier";
                                                  value = "appicon-hover";
                                                }
                                                {
                                                  kind = "identifier";
                                                  value = "duration";
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
                                                value = "serializeMapStrUint";
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
                                          value = "escapeShellArg";
                                        }
                                      ];
                                      type = "variable";
                                    };
                                    type = "call";
                                  };
                                  type = "interpolation";
                                }
                                {
                                  type = "text";
                                  value = "\n          ";
                                }
                                {
                                  expression = {
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
                                        value = "dconf";
                                      }
                                    ];
                                    type = "variable";
                                  };
                                  type = "interpolation";
                                }
                                {
                                  type = "text";
                                  value = "/bin/dconf write /org/gnome/shell/extensions/dash-to-panel/animate-appicon-hover-animation-extent ";
                                }
                                {
                                  expression = {
                                    arguments = [
                                      {
                                        type = "group";
                                        value = {
                                          arguments = [
                                            {
                                              name = "path";
                                              path = [
                                                {
                                                  kind = "identifier";
                                                  value = "animations";
                                                }
                                                {
                                                  kind = "identifier";
                                                  value = "appicon-hover";
                                                }
                                                {
                                                  kind = "identifier";
                                                  value = "extent";
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
                                                value = "serializeMapStrInt";
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
                                          value = "escapeShellArg";
                                        }
                                      ];
                                      type = "variable";
                                    };
                                    type = "call";
                                  };
                                  type = "interpolation";
                                }
                                {
                                  type = "text";
                                  value = "\n          ";
                                }
                                {
                                  expression = {
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
                                        value = "dconf";
                                      }
                                    ];
                                    type = "variable";
                                  };
                                  type = "interpolation";
                                }
                                {
                                  type = "text";
                                  value = "/bin/dconf write /org/gnome/shell/extensions/dash-to-panel/animate-appicon-hover-animation-rotation ";
                                }
                                {
                                  expression = {
                                    arguments = [
                                      {
                                        type = "group";
                                        value = {
                                          arguments = [
                                            {
                                              name = "path";
                                              path = [
                                                {
                                                  kind = "identifier";
                                                  value = "animations";
                                                }
                                                {
                                                  kind = "identifier";
                                                  value = "appicon-hover";
                                                }
                                                {
                                                  kind = "identifier";
                                                  value = "rotation";
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
                                                value = "serializeMapStrInt";
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
                                          value = "escapeShellArg";
                                        }
                                      ];
                                      type = "variable";
                                    };
                                    type = "call";
                                  };
                                  type = "interpolation";
                                }
                                {
                                  type = "text";
                                  value = "\n          ";
                                }
                                {
                                  expression = {
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
                                        value = "dconf";
                                      }
                                    ];
                                    type = "variable";
                                  };
                                  type = "interpolation";
                                }
                                {
                                  type = "text";
                                  value = "/bin/dconf write /org/gnome/shell/extensions/dash-to-panel/animate-appicon-hover-animation-travel ";
                                }
                                {
                                  expression = {
                                    arguments = [
                                      {
                                        type = "group";
                                        value = {
                                          arguments = [
                                            {
                                              name = "path";
                                              path = [
                                                {
                                                  kind = "identifier";
                                                  value = "animations";
                                                }
                                                {
                                                  kind = "identifier";
                                                  value = "appicon-hover";
                                                }
                                                {
                                                  kind = "identifier";
                                                  value = "travel";
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
                                                value = "serializeMapStrDouble";
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
                                          value = "escapeShellArg";
                                        }
                                      ];
                                      type = "variable";
                                    };
                                    type = "call";
                                  };
                                  type = "interpolation";
                                }
                                {
                                  type = "text";
                                  value = "\n          ";
                                }
                                {
                                  expression = {
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
                                        value = "dconf";
                                      }
                                    ];
                                    type = "variable";
                                  };
                                  type = "interpolation";
                                }
                                {
                                  type = "text";
                                  value = "/bin/dconf write /org/gnome/shell/extensions/dash-to-panel/animate-appicon-hover-animation-zoom ";
                                }
                                {
                                  expression = {
                                    arguments = [
                                      {
                                        type = "group";
                                        value = {
                                          arguments = [
                                            {
                                              name = "path";
                                              path = [
                                                {
                                                  kind = "identifier";
                                                  value = "animations";
                                                }
                                                {
                                                  kind = "identifier";
                                                  value = "appicon-hover";
                                                }
                                                {
                                                  kind = "identifier";
                                                  value = "zoom";
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
                                                value = "serializeMapStrDouble";
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
                                          value = "escapeShellArg";
                                        }
                                      ];
                                      type = "variable";
                                    };
                                    type = "call";
                                  };
                                  type = "interpolation";
                                }
                                {
                                  type = "text";
                                  value = "\n        ";
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
            value = "positioning";
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
                  value = "panel-position";
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
                                        value = "BOTTOM";
                                      }
                                    ];
                                    type = "string";
                                  }
                                  {
                                    multiline = false;
                                    parts = [
                                      {
                                        type = "text";
                                        value = "TOP";
                                      }
                                    ];
                                    type = "string";
                                  }
                                  {
                                    multiline = false;
                                    parts = [
                                      {
                                        type = "text";
                                        value = "LEFT";
                                      }
                                    ];
                                    type = "string";
                                  }
                                  {
                                    multiline = false;
                                    parts = [
                                      {
                                        type = "text";
                                        value = "RIGHT";
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
                                value = "BOTTOM";
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
                                value = "Anchor edge for the consolidated panel";
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
                  value = "panel-size";
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
                                value = "Consolidated panel thickness in pixels";
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
                  value = "panel-lengths";
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
                                value = "{}";
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
                                value = "Per-monitor panel lengths (JSON)";
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
                  value = "panel-sizes";
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
                                value = "{}";
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
                                value = "Per-monitor panel thicknesses (JSON)";
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
                  value = "appicon-margin";
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
                            value = 8;
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
                                value = "Pixel margin around application icons";
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
                  value = "appicon-padding";
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
                                value = "Internal padding for application icons";
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
                  value = "dot-position";
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
                                        value = "BOTTOM";
                                      }
                                    ];
                                    type = "string";
                                  }
                                  {
                                    multiline = false;
                                    parts = [
                                      {
                                        type = "text";
                                        value = "TOP";
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
                                value = "BOTTOM";
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
                                value = "Placement of the active window marker";
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
                  value = "dot-style-focused";
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
                                        value = "METRO";
                                      }
                                    ];
                                    type = "string";
                                  }
                                  {
                                    multiline = false;
                                    parts = [
                                      {
                                        type = "text";
                                        value = "DOTS";
                                      }
                                    ];
                                    type = "string";
                                  }
                                  {
                                    multiline = false;
                                    parts = [
                                      {
                                        type = "text";
                                        value = "SQUARES";
                                      }
                                    ];
                                    type = "string";
                                  }
                                  {
                                    multiline = false;
                                    parts = [
                                      {
                                        type = "text";
                                        value = "DASHES";
                                      }
                                    ];
                                    type = "string";
                                  }
                                  {
                                    multiline = false;
                                    parts = [
                                      {
                                        type = "text";
                                        value = "SEGMENTED";
                                      }
                                    ];
                                    type = "string";
                                  }
                                  {
                                    multiline = false;
                                    parts = [
                                      {
                                        type = "text";
                                        value = "SOLID";
                                      }
                                    ];
                                    type = "string";
                                  }
                                  {
                                    multiline = false;
                                    parts = [
                                      {
                                        type = "text";
                                        value = "CILIORA";
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
                                value = "METRO";
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
                                value = "Visual style of the focused app marker";
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
                  value = "dot-style-unfocused";
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
                                        value = "METRO";
                                      }
                                    ];
                                    type = "string";
                                  }
                                  {
                                    multiline = false;
                                    parts = [
                                      {
                                        type = "text";
                                        value = "DOTS";
                                      }
                                    ];
                                    type = "string";
                                  }
                                  {
                                    multiline = false;
                                    parts = [
                                      {
                                        type = "text";
                                        value = "SQUARES";
                                      }
                                    ];
                                    type = "string";
                                  }
                                  {
                                    multiline = false;
                                    parts = [
                                      {
                                        type = "text";
                                        value = "DASHES";
                                      }
                                    ];
                                    type = "string";
                                  }
                                  {
                                    multiline = false;
                                    parts = [
                                      {
                                        type = "text";
                                        value = "SEGMENTED";
                                      }
                                    ];
                                    type = "string";
                                  }
                                  {
                                    multiline = false;
                                    parts = [
                                      {
                                        type = "text";
                                        value = "SOLID";
                                      }
                                    ];
                                    type = "string";
                                  }
                                  {
                                    multiline = false;
                                    parts = [
                                      {
                                        type = "text";
                                        value = "CILIORA";
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
                                value = "METRO";
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
                                value = "Visual style of unfocused app markers";
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
                  value = "transparency";
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
                                      value = "Enable shell theme transparency overrides";
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
                        value = "opacity";
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
                                      value = "float";
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
                                  kind = "float";
                                  type = "literal";
                                  value = 0.4;
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
                                      value = "Fixed panel alpha transparency (0.0-1.0)";
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
                                      value = "#000000";
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
                                      value = "Custom panel background color (Hex)";
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
                        value = "dynamic";
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
                                      value = "Adjust opacity based on window proximity";
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
            value = "behavior";
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
                  value = "isolate-workspaces";
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
                                value = "Filter items by current desktop";
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
                  value = "isolate-monitors";
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
                                value = "Filter items by hardware monitor";
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
                  value = "group-apps";
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
                                value = "Unify multiple windows under one icon";
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
                  value = "click-action";
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
                                value = "CYCLE-MIN";
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
                                value = "Primary interaction button behavior";
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
                  value = "scroll-panel-action";
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
                                value = "SWITCH_WORKSPACE";
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
                                value = "Mouse scroll wheel behavior on the panel";
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
                  value = "show-window-previews";
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
                                value = "Show live thumbnails on icon hover";
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
            value = "intellihide";
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
                                value = "Hide panel when obstructed by windows";
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
                  value = "behavior";
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
                                        value = "ALL_WINDOWS";
                                      }
                                    ];
                                    type = "string";
                                  }
                                  {
                                    multiline = false;
                                    parts = [
                                      {
                                        type = "text";
                                        value = "FOCUSED_WINDOWS";
                                      }
                                    ];
                                    type = "string";
                                  }
                                  {
                                    multiline = false;
                                    parts = [
                                      {
                                        type = "text";
                                        value = "MAXIMIZED_WINDOWS";
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
                                value = "FOCUSED_WINDOWS";
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
                                value = "Hiding trigger policy";
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
                  value = "animation-time";
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
                            value = 200;
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
                                value = "Visual transition time in milliseconds";
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
            value = "animations";
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
                  value = "appicon-hover";
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
                                      value = "Enable mouse hover animations for icons";
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
                        value = "convexity";
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
                                              value = "float";
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
                                  recursive = false;
                                  statements = [
                                    {
                                      operator = "=";
                                      target = [
                                        {
                                          kind = "identifier";
                                          value = "RIPPLE";
                                        }
                                      ];
                                      type = "assignment";
                                      value = {
                                        kind = "float";
                                        type = "literal";
                                        value = 2.0;
                                      };
                                    }
                                    {
                                      operator = "=";
                                      target = [
                                        {
                                          kind = "identifier";
                                          value = "PLANK";
                                        }
                                      ];
                                      type = "assignment";
                                      value = {
                                        kind = "float";
                                        type = "literal";
                                        value = 1.0;
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
                                    value = "description";
                                  }
                                ];
                                type = "assignment";
                                value = {
                                  multiline = true;
                                  parts = [
                                    {
                                      type = "text";
                                      value = "Deformation curvature map";
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
                        value = "duration";
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
                                  recursive = false;
                                  statements = [
                                    {
                                      operator = "=";
                                      target = [
                                        {
                                          kind = "identifier";
                                          value = "SIMPLE";
                                        }
                                      ];
                                      type = "assignment";
                                      value = {
                                        kind = "integer";
                                        type = "literal";
                                        value = 160;
                                      };
                                    }
                                    {
                                      operator = "=";
                                      target = [
                                        {
                                          kind = "identifier";
                                          value = "RIPPLE";
                                        }
                                      ];
                                      type = "assignment";
                                      value = {
                                        kind = "integer";
                                        type = "literal";
                                        value = 130;
                                      };
                                    }
                                    {
                                      operator = "=";
                                      target = [
                                        {
                                          kind = "identifier";
                                          value = "PLANK";
                                        }
                                      ];
                                      type = "assignment";
                                      value = {
                                        kind = "integer";
                                        type = "literal";
                                        value = 100;
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
                                    value = "description";
                                  }
                                ];
                                type = "assignment";
                                value = {
                                  multiline = true;
                                  parts = [
                                    {
                                      type = "text";
                                      value = "Animation speed map";
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
                        value = "extent";
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
                                  recursive = false;
                                  statements = [
                                    {
                                      operator = "=";
                                      target = [
                                        {
                                          kind = "identifier";
                                          value = "RIPPLE";
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
                                          value = "PLANK";
                                        }
                                      ];
                                      type = "assignment";
                                      value = {
                                        kind = "integer";
                                        type = "literal";
                                        value = 4;
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
                                    value = "description";
                                  }
                                ];
                                type = "assignment";
                                value = {
                                  multiline = true;
                                  parts = [
                                    {
                                      type = "text";
                                      value = "Animation spread map";
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
                        value = "rotation";
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
                                  recursive = false;
                                  statements = [
                                    {
                                      operator = "=";
                                      target = [
                                        {
                                          kind = "identifier";
                                          value = "SIMPLE";
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
                                          value = "RIPPLE";
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
                                          kind = "identifier";
                                          value = "PLANK";
                                        }
                                      ];
                                      type = "assignment";
                                      value = {
                                        kind = "integer";
                                        type = "literal";
                                        value = 0;
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
                                    value = "description";
                                  }
                                ];
                                type = "assignment";
                                value = {
                                  multiline = true;
                                  parts = [
                                    {
                                      type = "text";
                                      value = "Icon rotation map";
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
                        value = "travel";
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
                                              value = "float";
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
                                  recursive = false;
                                  statements = [
                                    {
                                      operator = "=";
                                      target = [
                                        {
                                          kind = "identifier";
                                          value = "SIMPLE";
                                        }
                                      ];
                                      type = "assignment";
                                      value = {
                                        kind = "float";
                                        type = "literal";
                                        value = 0.3;
                                      };
                                    }
                                    {
                                      operator = "=";
                                      target = [
                                        {
                                          kind = "identifier";
                                          value = "RIPPLE";
                                        }
                                      ];
                                      type = "assignment";
                                      value = {
                                        kind = "float";
                                        type = "literal";
                                        value = 0.4;
                                      };
                                    }
                                    {
                                      operator = "=";
                                      target = [
                                        {
                                          kind = "identifier";
                                          value = "PLANK";
                                        }
                                      ];
                                      type = "assignment";
                                      value = {
                                        kind = "float";
                                        type = "literal";
                                        value = 0.0;
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
                                    value = "description";
                                  }
                                ];
                                type = "assignment";
                                value = {
                                  multiline = true;
                                  parts = [
                                    {
                                      type = "text";
                                      value = "Translation distance map";
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
                        value = "zoom";
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
                                              value = "float";
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
                                  recursive = false;
                                  statements = [
                                    {
                                      operator = "=";
                                      target = [
                                        {
                                          kind = "identifier";
                                          value = "SIMPLE";
                                        }
                                      ];
                                      type = "assignment";
                                      value = {
                                        kind = "float";
                                        type = "literal";
                                        value = 1.0;
                                      };
                                    }
                                    {
                                      operator = "=";
                                      target = [
                                        {
                                          kind = "identifier";
                                          value = "RIPPLE";
                                        }
                                      ];
                                      type = "assignment";
                                      value = {
                                        kind = "float";
                                        type = "literal";
                                        value = 1.25;
                                      };
                                    }
                                    {
                                      operator = "=";
                                      target = [
                                        {
                                          kind = "identifier";
                                          value = "PLANK";
                                        }
                                      ];
                                      type = "assignment";
                                      value = {
                                        kind = "float";
                                        type = "literal";
                                        value = 2.0;
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
                                    value = "description";
                                  }
                                ];
                                type = "assignment";
                                value = {
                                  multiline = true;
                                  parts = [
                                    {
                                      type = "text";
                                      value = "Scale factor map";
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
            value = "extraSettings";
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
                          value = "set";
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
                      recursive = false;
                      statements = [ ];
                      type = "attr-set";
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
                          value = "Direct schema-key overrides for dconf";
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
  }; }
    (let mkGVariantString = (builtins.addErrorContext "_let mkGVariantString annotation mismatch: /nix/store/59qqzf108ga8h2qmsjizzsn2p7i889xx-zenpkgs-dsl-source/modules/desktops/gnome/extensions/dash-to-panel.zmdl:22:1" ((_zenType: _zenValue: let force = type: value: if type.name == "anything" then true else if type.name == "listOf" then builtins.all (force type.nestedTypes.elemType) value else if type.name == "attrsOf" then builtins.all (force type.nestedTypes.elemType) (builtins.attrValues value) else if type.name == "either" then force (if type.nestedTypes.left.check value then type.nestedTypes.left else type.nestedTypes.right) value else builtins.seq value true; in builtins.seq (force _zenType _zenValue) _zenValue) ((lib.types.addCheck lib.types.unspecified builtins.isFunction)) ((lib.evalModules { modules = [ { options.value = lib.mkOption { type = (lib.types.addCheck lib.types.unspecified builtins.isFunction); }; config.value = (v: "'${((value: let kind = builtins.typeOf value; in if kind == "string" then value else if kind == "bool" || kind == "int" || kind == "float" then builtins.toJSON value else if kind == "path" then "${value}" else if kind == "set" && (value.type or null) == "derivation" && builtins.isString (value.outPath or null) then value.outPath else throw "/nix/store/59qqzf108ga8h2qmsjizzsn2p7i889xx-zenpkgs-dsl-source/modules/desktops/gnome/extensions/dash-to-panel.zmdl:22: string interpolation requires a scalar, path, or package") (v))}'"); } ]; }).config.value))); mkGVariantDouble = (builtins.addErrorContext "_let mkGVariantDouble annotation mismatch: /nix/store/59qqzf108ga8h2qmsjizzsn2p7i889xx-zenpkgs-dsl-source/modules/desktops/gnome/extensions/dash-to-panel.zmdl:23:1" ((_zenType: _zenValue: let force = type: value: if type.name == "anything" then true else if type.name == "listOf" then builtins.all (force type.nestedTypes.elemType) value else if type.name == "attrsOf" then builtins.all (force type.nestedTypes.elemType) (builtins.attrValues value) else if type.name == "either" then force (if type.nestedTypes.left.check value then type.nestedTypes.left else type.nestedTypes.right) value else builtins.seq value true; in builtins.seq (force _zenType _zenValue) _zenValue) ((lib.types.addCheck lib.types.unspecified builtins.isFunction)) ((lib.evalModules { modules = [ { options.value = lib.mkOption { type = (lib.types.addCheck lib.types.unspecified builtins.isFunction); }; config.value = (v: (let
  s = (lib.toString v);
in (if ((lib.hasInfix ".") s) then s else "${((value: let kind = builtins.typeOf value; in if kind == "string" then value else if kind == "bool" || kind == "int" || kind == "float" then builtins.toJSON value else if kind == "path" then "${value}" else if kind == "set" && (value.type or null) == "derivation" && builtins.isString (value.outPath or null) then value.outPath else throw "/nix/store/59qqzf108ga8h2qmsjizzsn2p7i889xx-zenpkgs-dsl-source/modules/desktops/gnome/extensions/dash-to-panel.zmdl:23: string interpolation requires a scalar, path, or package") (s))}.0"))); } ]; }).config.value))); serializeMap = (builtins.addErrorContext "_let serializeMap annotation mismatch: /nix/store/59qqzf108ga8h2qmsjizzsn2p7i889xx-zenpkgs-dsl-source/modules/desktops/gnome/extensions/dash-to-panel.zmdl:24:1" ((_zenType: _zenValue: let force = type: value: if type.name == "anything" then true else if type.name == "listOf" then builtins.all (force type.nestedTypes.elemType) value else if type.name == "attrsOf" then builtins.all (force type.nestedTypes.elemType) (builtins.attrValues value) else if type.name == "either" then force (if type.nestedTypes.left.check value then type.nestedTypes.left else type.nestedTypes.right) value else builtins.seq value true; in builtins.seq (force _zenType _zenValue) _zenValue) ((lib.types.addCheck lib.types.unspecified builtins.isFunction)) ((lib.evalModules { modules = [ { options.value = lib.mkOption { type = (lib.types.addCheck lib.types.unspecified builtins.isFunction); }; config.value = (formatter: (values: (if (values == { }) then "@a{s*} {}" else "{${((value: let kind = builtins.typeOf value; in if kind == "string" then value else if kind == "bool" || kind == "int" || kind == "float" then builtins.toJSON value else if kind == "path" then "${value}" else if kind == "set" && (value.type or null) == "derivation" && builtins.isString (value.outPath or null) then value.outPath else throw "/nix/store/59qqzf108ga8h2qmsjizzsn2p7i889xx-zenpkgs-dsl-source/modules/desktops/gnome/extensions/dash-to-panel.zmdl:26: string interpolation requires a scalar, path, or package") (((lib.concatStringsSep ", ") (((lib.mapAttrsToList ((k: (v: "${((value: let kind = builtins.typeOf value; in if kind == "string" then value else if kind == "bool" || kind == "int" || kind == "float" then builtins.toJSON value else if kind == "path" then "${value}" else if kind == "set" && (value.type or null) == "derivation" && builtins.isString (value.outPath or null) then value.outPath else throw "/nix/store/59qqzf108ga8h2qmsjizzsn2p7i889xx-zenpkgs-dsl-source/modules/desktops/gnome/extensions/dash-to-panel.zmdl:26: string interpolation requires a scalar, path, or package") ((mkGVariantString k)))}: ${((value: let kind = builtins.typeOf value; in if kind == "string" then value else if kind == "bool" || kind == "int" || kind == "float" then builtins.toJSON value else if kind == "path" then "${value}" else if kind == "set" && (value.type or null) == "derivation" && builtins.isString (value.outPath or null) then value.outPath else throw "/nix/store/59qqzf108ga8h2qmsjizzsn2p7i889xx-zenpkgs-dsl-source/modules/desktops/gnome/extensions/dash-to-panel.zmdl:26: string interpolation requires a scalar, path, or package") ((formatter v)))}")))) values)))))}}"))); } ]; }).config.value))); serializeMapStrDouble = (builtins.addErrorContext "_let serializeMapStrDouble annotation mismatch: /nix/store/59qqzf108ga8h2qmsjizzsn2p7i889xx-zenpkgs-dsl-source/modules/desktops/gnome/extensions/dash-to-panel.zmdl:27:1" ((_zenType: _zenValue: let force = type: value: if type.name == "anything" then true else if type.name == "listOf" then builtins.all (force type.nestedTypes.elemType) value else if type.name == "attrsOf" then builtins.all (force type.nestedTypes.elemType) (builtins.attrValues value) else if type.name == "either" then force (if type.nestedTypes.left.check value then type.nestedTypes.left else type.nestedTypes.right) value else builtins.seq value true; in builtins.seq (force _zenType _zenValue) _zenValue) ((lib.types.addCheck lib.types.unspecified builtins.isFunction)) ((lib.evalModules { modules = [ { options.value = lib.mkOption { type = (lib.types.addCheck lib.types.unspecified builtins.isFunction); }; config.value = (serializeMap mkGVariantDouble); } ]; }).config.value))); serializeMapStrUint = (builtins.addErrorContext "_let serializeMapStrUint annotation mismatch: /nix/store/59qqzf108ga8h2qmsjizzsn2p7i889xx-zenpkgs-dsl-source/modules/desktops/gnome/extensions/dash-to-panel.zmdl:28:1" ((_zenType: _zenValue: let force = type: value: if type.name == "anything" then true else if type.name == "listOf" then builtins.all (force type.nestedTypes.elemType) value else if type.name == "attrsOf" then builtins.all (force type.nestedTypes.elemType) (builtins.attrValues value) else if type.name == "either" then force (if type.nestedTypes.left.check value then type.nestedTypes.left else type.nestedTypes.right) value else builtins.seq value true; in builtins.seq (force _zenType _zenValue) _zenValue) ((lib.types.addCheck lib.types.unspecified builtins.isFunction)) ((lib.evalModules { modules = [ { options.value = lib.mkOption { type = (lib.types.addCheck lib.types.unspecified builtins.isFunction); }; config.value = (serializeMap ((v: "uint32 ${((value: let kind = builtins.typeOf value; in if kind == "string" then value else if kind == "bool" || kind == "int" || kind == "float" then builtins.toJSON value else if kind == "path" then "${value}" else if kind == "set" && (value.type or null) == "derivation" && builtins.isString (value.outPath or null) then value.outPath else throw "/nix/store/59qqzf108ga8h2qmsjizzsn2p7i889xx-zenpkgs-dsl-source/modules/desktops/gnome/extensions/dash-to-panel.zmdl:28: string interpolation requires a scalar, path, or package") ((lib.toString v)))}"))); } ]; }).config.value))); serializeMapStrInt = (builtins.addErrorContext "_let serializeMapStrInt annotation mismatch: /nix/store/59qqzf108ga8h2qmsjizzsn2p7i889xx-zenpkgs-dsl-source/modules/desktops/gnome/extensions/dash-to-panel.zmdl:29:1" ((_zenType: _zenValue: let force = type: value: if type.name == "anything" then true else if type.name == "listOf" then builtins.all (force type.nestedTypes.elemType) value else if type.name == "attrsOf" then builtins.all (force type.nestedTypes.elemType) (builtins.attrValues value) else if type.name == "either" then force (if type.nestedTypes.left.check value then type.nestedTypes.left else type.nestedTypes.right) value else builtins.seq value true; in builtins.seq (force _zenType _zenValue) _zenValue) ((lib.types.addCheck lib.types.unspecified builtins.isFunction)) ((lib.evalModules { modules = [ { options.value = lib.mkOption { type = (lib.types.addCheck lib.types.unspecified builtins.isFunction); }; config.value = (serializeMap lib.toString); } ]; }).config.value))); in (lib.mkIf ((cfg.enable)) { home-manager.sharedModules = [ {
      dconf.settings."org/gnome/shell".enabled-extensions = [
        pkgs.zenos.legacy.gnomeExtensions.dash-to-panel.extensionUuid
      ];
    } ]; }))
    (let mkGVariantString = (builtins.addErrorContext "_let mkGVariantString annotation mismatch: /nix/store/59qqzf108ga8h2qmsjizzsn2p7i889xx-zenpkgs-dsl-source/modules/desktops/gnome/extensions/dash-to-panel.zmdl:22:1" ((_zenType: _zenValue: let force = type: value: if type.name == "anything" then true else if type.name == "listOf" then builtins.all (force type.nestedTypes.elemType) value else if type.name == "attrsOf" then builtins.all (force type.nestedTypes.elemType) (builtins.attrValues value) else if type.name == "either" then force (if type.nestedTypes.left.check value then type.nestedTypes.left else type.nestedTypes.right) value else builtins.seq value true; in builtins.seq (force _zenType _zenValue) _zenValue) ((lib.types.addCheck lib.types.unspecified builtins.isFunction)) ((lib.evalModules { modules = [ { options.value = lib.mkOption { type = (lib.types.addCheck lib.types.unspecified builtins.isFunction); }; config.value = (v: "'${((value: let kind = builtins.typeOf value; in if kind == "string" then value else if kind == "bool" || kind == "int" || kind == "float" then builtins.toJSON value else if kind == "path" then "${value}" else if kind == "set" && (value.type or null) == "derivation" && builtins.isString (value.outPath or null) then value.outPath else throw "/nix/store/59qqzf108ga8h2qmsjizzsn2p7i889xx-zenpkgs-dsl-source/modules/desktops/gnome/extensions/dash-to-panel.zmdl:22: string interpolation requires a scalar, path, or package") (v))}'"); } ]; }).config.value))); mkGVariantDouble = (builtins.addErrorContext "_let mkGVariantDouble annotation mismatch: /nix/store/59qqzf108ga8h2qmsjizzsn2p7i889xx-zenpkgs-dsl-source/modules/desktops/gnome/extensions/dash-to-panel.zmdl:23:1" ((_zenType: _zenValue: let force = type: value: if type.name == "anything" then true else if type.name == "listOf" then builtins.all (force type.nestedTypes.elemType) value else if type.name == "attrsOf" then builtins.all (force type.nestedTypes.elemType) (builtins.attrValues value) else if type.name == "either" then force (if type.nestedTypes.left.check value then type.nestedTypes.left else type.nestedTypes.right) value else builtins.seq value true; in builtins.seq (force _zenType _zenValue) _zenValue) ((lib.types.addCheck lib.types.unspecified builtins.isFunction)) ((lib.evalModules { modules = [ { options.value = lib.mkOption { type = (lib.types.addCheck lib.types.unspecified builtins.isFunction); }; config.value = (v: (let
  s = (lib.toString v);
in (if ((lib.hasInfix ".") s) then s else "${((value: let kind = builtins.typeOf value; in if kind == "string" then value else if kind == "bool" || kind == "int" || kind == "float" then builtins.toJSON value else if kind == "path" then "${value}" else if kind == "set" && (value.type or null) == "derivation" && builtins.isString (value.outPath or null) then value.outPath else throw "/nix/store/59qqzf108ga8h2qmsjizzsn2p7i889xx-zenpkgs-dsl-source/modules/desktops/gnome/extensions/dash-to-panel.zmdl:23: string interpolation requires a scalar, path, or package") (s))}.0"))); } ]; }).config.value))); serializeMap = (builtins.addErrorContext "_let serializeMap annotation mismatch: /nix/store/59qqzf108ga8h2qmsjizzsn2p7i889xx-zenpkgs-dsl-source/modules/desktops/gnome/extensions/dash-to-panel.zmdl:24:1" ((_zenType: _zenValue: let force = type: value: if type.name == "anything" then true else if type.name == "listOf" then builtins.all (force type.nestedTypes.elemType) value else if type.name == "attrsOf" then builtins.all (force type.nestedTypes.elemType) (builtins.attrValues value) else if type.name == "either" then force (if type.nestedTypes.left.check value then type.nestedTypes.left else type.nestedTypes.right) value else builtins.seq value true; in builtins.seq (force _zenType _zenValue) _zenValue) ((lib.types.addCheck lib.types.unspecified builtins.isFunction)) ((lib.evalModules { modules = [ { options.value = lib.mkOption { type = (lib.types.addCheck lib.types.unspecified builtins.isFunction); }; config.value = (formatter: (values: (if (values == { }) then "@a{s*} {}" else "{${((value: let kind = builtins.typeOf value; in if kind == "string" then value else if kind == "bool" || kind == "int" || kind == "float" then builtins.toJSON value else if kind == "path" then "${value}" else if kind == "set" && (value.type or null) == "derivation" && builtins.isString (value.outPath or null) then value.outPath else throw "/nix/store/59qqzf108ga8h2qmsjizzsn2p7i889xx-zenpkgs-dsl-source/modules/desktops/gnome/extensions/dash-to-panel.zmdl:26: string interpolation requires a scalar, path, or package") (((lib.concatStringsSep ", ") (((lib.mapAttrsToList ((k: (v: "${((value: let kind = builtins.typeOf value; in if kind == "string" then value else if kind == "bool" || kind == "int" || kind == "float" then builtins.toJSON value else if kind == "path" then "${value}" else if kind == "set" && (value.type or null) == "derivation" && builtins.isString (value.outPath or null) then value.outPath else throw "/nix/store/59qqzf108ga8h2qmsjizzsn2p7i889xx-zenpkgs-dsl-source/modules/desktops/gnome/extensions/dash-to-panel.zmdl:26: string interpolation requires a scalar, path, or package") ((mkGVariantString k)))}: ${((value: let kind = builtins.typeOf value; in if kind == "string" then value else if kind == "bool" || kind == "int" || kind == "float" then builtins.toJSON value else if kind == "path" then "${value}" else if kind == "set" && (value.type or null) == "derivation" && builtins.isString (value.outPath or null) then value.outPath else throw "/nix/store/59qqzf108ga8h2qmsjizzsn2p7i889xx-zenpkgs-dsl-source/modules/desktops/gnome/extensions/dash-to-panel.zmdl:26: string interpolation requires a scalar, path, or package") ((formatter v)))}")))) values)))))}}"))); } ]; }).config.value))); serializeMapStrDouble = (builtins.addErrorContext "_let serializeMapStrDouble annotation mismatch: /nix/store/59qqzf108ga8h2qmsjizzsn2p7i889xx-zenpkgs-dsl-source/modules/desktops/gnome/extensions/dash-to-panel.zmdl:27:1" ((_zenType: _zenValue: let force = type: value: if type.name == "anything" then true else if type.name == "listOf" then builtins.all (force type.nestedTypes.elemType) value else if type.name == "attrsOf" then builtins.all (force type.nestedTypes.elemType) (builtins.attrValues value) else if type.name == "either" then force (if type.nestedTypes.left.check value then type.nestedTypes.left else type.nestedTypes.right) value else builtins.seq value true; in builtins.seq (force _zenType _zenValue) _zenValue) ((lib.types.addCheck lib.types.unspecified builtins.isFunction)) ((lib.evalModules { modules = [ { options.value = lib.mkOption { type = (lib.types.addCheck lib.types.unspecified builtins.isFunction); }; config.value = (serializeMap mkGVariantDouble); } ]; }).config.value))); serializeMapStrUint = (builtins.addErrorContext "_let serializeMapStrUint annotation mismatch: /nix/store/59qqzf108ga8h2qmsjizzsn2p7i889xx-zenpkgs-dsl-source/modules/desktops/gnome/extensions/dash-to-panel.zmdl:28:1" ((_zenType: _zenValue: let force = type: value: if type.name == "anything" then true else if type.name == "listOf" then builtins.all (force type.nestedTypes.elemType) value else if type.name == "attrsOf" then builtins.all (force type.nestedTypes.elemType) (builtins.attrValues value) else if type.name == "either" then force (if type.nestedTypes.left.check value then type.nestedTypes.left else type.nestedTypes.right) value else builtins.seq value true; in builtins.seq (force _zenType _zenValue) _zenValue) ((lib.types.addCheck lib.types.unspecified builtins.isFunction)) ((lib.evalModules { modules = [ { options.value = lib.mkOption { type = (lib.types.addCheck lib.types.unspecified builtins.isFunction); }; config.value = (serializeMap ((v: "uint32 ${((value: let kind = builtins.typeOf value; in if kind == "string" then value else if kind == "bool" || kind == "int" || kind == "float" then builtins.toJSON value else if kind == "path" then "${value}" else if kind == "set" && (value.type or null) == "derivation" && builtins.isString (value.outPath or null) then value.outPath else throw "/nix/store/59qqzf108ga8h2qmsjizzsn2p7i889xx-zenpkgs-dsl-source/modules/desktops/gnome/extensions/dash-to-panel.zmdl:28: string interpolation requires a scalar, path, or package") ((lib.toString v)))}"))); } ]; }).config.value))); serializeMapStrInt = (builtins.addErrorContext "_let serializeMapStrInt annotation mismatch: /nix/store/59qqzf108ga8h2qmsjizzsn2p7i889xx-zenpkgs-dsl-source/modules/desktops/gnome/extensions/dash-to-panel.zmdl:29:1" ((_zenType: _zenValue: let force = type: value: if type.name == "anything" then true else if type.name == "listOf" then builtins.all (force type.nestedTypes.elemType) value else if type.name == "attrsOf" then builtins.all (force type.nestedTypes.elemType) (builtins.attrValues value) else if type.name == "either" then force (if type.nestedTypes.left.check value then type.nestedTypes.left else type.nestedTypes.right) value else builtins.seq value true; in builtins.seq (force _zenType _zenValue) _zenValue) ((lib.types.addCheck lib.types.unspecified builtins.isFunction)) ((lib.evalModules { modules = [ { options.value = lib.mkOption { type = (lib.types.addCheck lib.types.unspecified builtins.isFunction); }; config.value = (serializeMap lib.toString); } ]; }).config.value))); in (lib.mkIf ((cfg.enable)) {
      environment.systemPackages = [
        pkgs.zenos.legacy.gnomeExtensions.dash-to-panel
      ];
      programs.dconf.profiles.user.databases = [
        {
          settings."org/gnome/shell/extensions/dash-to-panel" = ({
            panel-position = cfg.positioning.panel-position;
            panel-size = cfg.positioning.panel-size;
            panel-lengths = cfg.positioning.panel-lengths;
            panel-sizes = cfg.positioning.panel-sizes;
            appicon-margin = cfg.style.appicon-margin;
            appicon-padding = cfg.style.appicon-padding;
            dot-position = cfg.style.dot-position;
            dot-style-focused = cfg.style.dot-style-focused;
            dot-style-unfocused = cfg.style.dot-style-unfocused;
            trans-use-custom-opacity = cfg.style.transparency.enable;
            trans-panel-opacity = cfg.style.transparency.opacity;
            trans-bg-color = cfg.style.transparency.color;
            trans-use-dynamic-opacity = cfg.style.transparency.dynamic;
            isolate-workspaces = cfg.behavior.isolate-workspaces;
            isolate-monitors = cfg.behavior.isolate-monitors;
            group-apps = cfg.behavior.group-apps;
            click-action = cfg.behavior.click-action;
            scroll-panel-action = cfg.behavior.scroll-panel-action;
            show-window-previews = cfg.behavior.show-window-previews;
            intellihide = cfg.intellihide.enable;
            intellihide-behaviour = cfg.intellihide.behavior;
            intellihide-animation-time = cfg.intellihide.animation-time;
            animate-appicon-hover = cfg.animations.appicon-hover.enable;
            desktop-line-use-custom-color = false;
            animate-app-switch = true;
          } // cfg.extraSettings);
        }
      ];
      systemd.user.services.dash-to-panel-complex-config = {
        description = "Apply Dash to Panel complex configuration";
        wantedBy = [
          "graphical-session.target"
        ];
        partOf = [
          "graphical-session.target"
        ];
        serviceConfig = {
          Type = "oneshot";
          RemainAfterExit = true;
        };
        script = "\n          ${((value: let kind = builtins.typeOf value; in if kind == "string" then value else if kind == "bool" || kind == "int" || kind == "float" then builtins.toJSON value else if kind == "path" then "${value}" else if kind == "set" && (value.type or null) == "derivation" && builtins.isString (value.outPath or null) then value.outPath else throw "/nix/store/59qqzf108ga8h2qmsjizzsn2p7i889xx-zenpkgs-dsl-source/modules/desktops/gnome/extensions/dash-to-panel.zmdl:73: string interpolation requires a scalar, path, or package") (pkgs.zenos.legacy.dconf))}/bin/dconf write /org/gnome/shell/extensions/dash-to-panel/animate-appicon-hover-animation-convexity ${((value: let kind = builtins.typeOf value; in if kind == "string" then value else if kind == "bool" || kind == "int" || kind == "float" then builtins.toJSON value else if kind == "path" then "${value}" else if kind == "set" && (value.type or null) == "derivation" && builtins.isString (value.outPath or null) then value.outPath else throw "/nix/store/59qqzf108ga8h2qmsjizzsn2p7i889xx-zenpkgs-dsl-source/modules/desktops/gnome/extensions/dash-to-panel.zmdl:73: string interpolation requires a scalar, path, or package") ((lib.escapeShellArg ((serializeMapStrDouble cfg.animations.appicon-hover.convexity)))))}\n          ${((value: let kind = builtins.typeOf value; in if kind == "string" then value else if kind == "bool" || kind == "int" || kind == "float" then builtins.toJSON value else if kind == "path" then "${value}" else if kind == "set" && (value.type or null) == "derivation" && builtins.isString (value.outPath or null) then value.outPath else throw "/nix/store/59qqzf108ga8h2qmsjizzsn2p7i889xx-zenpkgs-dsl-source/modules/desktops/gnome/extensions/dash-to-panel.zmdl:74: string interpolation requires a scalar, path, or package") (pkgs.zenos.legacy.dconf))}/bin/dconf write /org/gnome/shell/extensions/dash-to-panel/animate-appicon-hover-animation-duration ${((value: let kind = builtins.typeOf value; in if kind == "string" then value else if kind == "bool" || kind == "int" || kind == "float" then builtins.toJSON value else if kind == "path" then "${value}" else if kind == "set" && (value.type or null) == "derivation" && builtins.isString (value.outPath or null) then value.outPath else throw "/nix/store/59qqzf108ga8h2qmsjizzsn2p7i889xx-zenpkgs-dsl-source/modules/desktops/gnome/extensions/dash-to-panel.zmdl:74: string interpolation requires a scalar, path, or package") ((lib.escapeShellArg ((serializeMapStrUint cfg.animations.appicon-hover.duration)))))}\n          ${((value: let kind = builtins.typeOf value; in if kind == "string" then value else if kind == "bool" || kind == "int" || kind == "float" then builtins.toJSON value else if kind == "path" then "${value}" else if kind == "set" && (value.type or null) == "derivation" && builtins.isString (value.outPath or null) then value.outPath else throw "/nix/store/59qqzf108ga8h2qmsjizzsn2p7i889xx-zenpkgs-dsl-source/modules/desktops/gnome/extensions/dash-to-panel.zmdl:75: string interpolation requires a scalar, path, or package") (pkgs.zenos.legacy.dconf))}/bin/dconf write /org/gnome/shell/extensions/dash-to-panel/animate-appicon-hover-animation-extent ${((value: let kind = builtins.typeOf value; in if kind == "string" then value else if kind == "bool" || kind == "int" || kind == "float" then builtins.toJSON value else if kind == "path" then "${value}" else if kind == "set" && (value.type or null) == "derivation" && builtins.isString (value.outPath or null) then value.outPath else throw "/nix/store/59qqzf108ga8h2qmsjizzsn2p7i889xx-zenpkgs-dsl-source/modules/desktops/gnome/extensions/dash-to-panel.zmdl:75: string interpolation requires a scalar, path, or package") ((lib.escapeShellArg ((serializeMapStrInt cfg.animations.appicon-hover.extent)))))}\n          ${((value: let kind = builtins.typeOf value; in if kind == "string" then value else if kind == "bool" || kind == "int" || kind == "float" then builtins.toJSON value else if kind == "path" then "${value}" else if kind == "set" && (value.type or null) == "derivation" && builtins.isString (value.outPath or null) then value.outPath else throw "/nix/store/59qqzf108ga8h2qmsjizzsn2p7i889xx-zenpkgs-dsl-source/modules/desktops/gnome/extensions/dash-to-panel.zmdl:76: string interpolation requires a scalar, path, or package") (pkgs.zenos.legacy.dconf))}/bin/dconf write /org/gnome/shell/extensions/dash-to-panel/animate-appicon-hover-animation-rotation ${((value: let kind = builtins.typeOf value; in if kind == "string" then value else if kind == "bool" || kind == "int" || kind == "float" then builtins.toJSON value else if kind == "path" then "${value}" else if kind == "set" && (value.type or null) == "derivation" && builtins.isString (value.outPath or null) then value.outPath else throw "/nix/store/59qqzf108ga8h2qmsjizzsn2p7i889xx-zenpkgs-dsl-source/modules/desktops/gnome/extensions/dash-to-panel.zmdl:76: string interpolation requires a scalar, path, or package") ((lib.escapeShellArg ((serializeMapStrInt cfg.animations.appicon-hover.rotation)))))}\n          ${((value: let kind = builtins.typeOf value; in if kind == "string" then value else if kind == "bool" || kind == "int" || kind == "float" then builtins.toJSON value else if kind == "path" then "${value}" else if kind == "set" && (value.type or null) == "derivation" && builtins.isString (value.outPath or null) then value.outPath else throw "/nix/store/59qqzf108ga8h2qmsjizzsn2p7i889xx-zenpkgs-dsl-source/modules/desktops/gnome/extensions/dash-to-panel.zmdl:77: string interpolation requires a scalar, path, or package") (pkgs.zenos.legacy.dconf))}/bin/dconf write /org/gnome/shell/extensions/dash-to-panel/animate-appicon-hover-animation-travel ${((value: let kind = builtins.typeOf value; in if kind == "string" then value else if kind == "bool" || kind == "int" || kind == "float" then builtins.toJSON value else if kind == "path" then "${value}" else if kind == "set" && (value.type or null) == "derivation" && builtins.isString (value.outPath or null) then value.outPath else throw "/nix/store/59qqzf108ga8h2qmsjizzsn2p7i889xx-zenpkgs-dsl-source/modules/desktops/gnome/extensions/dash-to-panel.zmdl:77: string interpolation requires a scalar, path, or package") ((lib.escapeShellArg ((serializeMapStrDouble cfg.animations.appicon-hover.travel)))))}\n          ${((value: let kind = builtins.typeOf value; in if kind == "string" then value else if kind == "bool" || kind == "int" || kind == "float" then builtins.toJSON value else if kind == "path" then "${value}" else if kind == "set" && (value.type or null) == "derivation" && builtins.isString (value.outPath or null) then value.outPath else throw "/nix/store/59qqzf108ga8h2qmsjizzsn2p7i889xx-zenpkgs-dsl-source/modules/desktops/gnome/extensions/dash-to-panel.zmdl:78: string interpolation requires a scalar, path, or package") (pkgs.zenos.legacy.dconf))}/bin/dconf write /org/gnome/shell/extensions/dash-to-panel/animate-appicon-hover-animation-zoom ${((value: let kind = builtins.typeOf value; in if kind == "string" then value else if kind == "bool" || kind == "int" || kind == "float" then builtins.toJSON value else if kind == "path" then "${value}" else if kind == "set" && (value.type or null) == "derivation" && builtins.isString (value.outPath or null) then value.outPath else throw "/nix/store/59qqzf108ga8h2qmsjizzsn2p7i889xx-zenpkgs-dsl-source/modules/desktops/gnome/extensions/dash-to-panel.zmdl:78: string interpolation requires a scalar, path, or package") ((lib.escapeShellArg ((serializeMapStrDouble cfg.animations.appicon-hover.zoom)))))}\n        ";
      };
    }))
  ];
}
