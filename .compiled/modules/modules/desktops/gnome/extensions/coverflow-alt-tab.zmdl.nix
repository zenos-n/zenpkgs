{ config, lib, pkgs, maintainers ? lib.maintainers, licenses ? lib.licenses, ... }:
let
  cfg = config.zenos.desktops.gnome.extensions.coverflow-alt-tab;
  name = "coverflow-alt-tab";
  hexToDecMap = (builtins.addErrorContext "_let hexToDecMap annotation mismatch: /nix/store/59qqzf108ga8h2qmsjizzsn2p7i889xx-zenpkgs-dsl-source/modules/desktops/gnome/extensions/coverflow-alt-tab.zmdl:20:1" ((_zenType: _zenValue: let force = type: value: if type.name == "anything" then true else if type.name == "listOf" then builtins.all (force type.nestedTypes.elemType) value else if type.name == "attrsOf" then builtins.all (force type.nestedTypes.elemType) (builtins.attrValues value) else if type.name == "either" then force (if type.nestedTypes.left.check value then type.nestedTypes.left else type.nestedTypes.right) value else builtins.seq value true; in builtins.seq (force _zenType _zenValue) _zenValue) ((lib.types.attrsOf lib.types.int)) ((lib.evalModules { modules = [ { options.value = lib.mkOption { type = (lib.types.attrsOf lib.types.int); }; config.value = {
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
  hexCharToInt = (builtins.addErrorContext "_let hexCharToInt annotation mismatch: /nix/store/59qqzf108ga8h2qmsjizzsn2p7i889xx-zenpkgs-dsl-source/modules/desktops/gnome/extensions/coverflow-alt-tab.zmdl:21:1" ((_zenType: _zenValue: let force = type: value: if type.name == "anything" then true else if type.name == "listOf" then builtins.all (force type.nestedTypes.elemType) value else if type.name == "attrsOf" then builtins.all (force type.nestedTypes.elemType) (builtins.attrValues value) else if type.name == "either" then force (if type.nestedTypes.left.check value then type.nestedTypes.left else type.nestedTypes.right) value else builtins.seq value true; in builtins.seq (force _zenType _zenValue) _zenValue) ((lib.types.addCheck lib.types.unspecified builtins.isFunction)) ((lib.evalModules { modules = [ { options.value = lib.mkOption { type = (lib.types.addCheck lib.types.unspecified builtins.isFunction); }; config.value = (c: (((lib.throwIfNot (((lib.hasAttr c) hexToDecMap))) "Invalid hex character: ${((value: let kind = builtins.typeOf value; in if kind == "string" then value else if kind == "bool" || kind == "int" || kind == "float" then builtins.toJSON value else if kind == "path" then "${value}" else if kind == "set" && (value.type or null) == "derivation" && builtins.isString (value.outPath or null) then value.outPath else throw "/nix/store/59qqzf108ga8h2qmsjizzsn2p7i889xx-zenpkgs-dsl-source/modules/desktops/gnome/extensions/coverflow-alt-tab.zmdl:22: string interpolation requires a scalar, path, or package") (c))}") (((lib.getAttr c) hexToDecMap)))); } ]; }).config.value)));
  parseHexByte = (builtins.addErrorContext "_let parseHexByte annotation mismatch: /nix/store/59qqzf108ga8h2qmsjizzsn2p7i889xx-zenpkgs-dsl-source/modules/desktops/gnome/extensions/coverflow-alt-tab.zmdl:23:1" ((_zenType: _zenValue: let force = type: value: if type.name == "anything" then true else if type.name == "listOf" then builtins.all (force type.nestedTypes.elemType) value else if type.name == "attrsOf" then builtins.all (force type.nestedTypes.elemType) (builtins.attrValues value) else if type.name == "either" then force (if type.nestedTypes.left.check value then type.nestedTypes.left else type.nestedTypes.right) value else builtins.seq value true; in builtins.seq (force _zenType _zenValue) _zenValue) ((lib.types.addCheck lib.types.unspecified builtins.isFunction)) ((lib.evalModules { modules = [ { options.value = lib.mkOption { type = (lib.types.addCheck lib.types.unspecified builtins.isFunction); }; config.value = (s: ((((hexCharToInt ((((lib.substring 0) 1) s))) * 16)) + (hexCharToInt ((((lib.substring 1) 1) s))))); } ]; }).config.value)));
  parseHexColor = (builtins.addErrorContext "_let parseHexColor annotation mismatch: /nix/store/59qqzf108ga8h2qmsjizzsn2p7i889xx-zenpkgs-dsl-source/modules/desktops/gnome/extensions/coverflow-alt-tab.zmdl:24:1" ((_zenType: _zenValue: let force = type: value: if type.name == "anything" then true else if type.name == "listOf" then builtins.all (force type.nestedTypes.elemType) value else if type.name == "attrsOf" then builtins.all (force type.nestedTypes.elemType) (builtins.attrValues value) else if type.name == "either" then force (if type.nestedTypes.left.check value then type.nestedTypes.left else type.nestedTypes.right) value else builtins.seq value true; in builtins.seq (force _zenType _zenValue) _zenValue) ((lib.types.addCheck lib.types.unspecified builtins.isFunction)) ((lib.evalModules { modules = [ { options.value = lib.mkOption { type = (lib.types.addCheck lib.types.unspecified builtins.isFunction); }; config.value = (s: (let
    hex = ((lib.removePrefix "#") s);
    len = (lib.stringLength hex);
    norm = (v: (v / 255.0));
  in (((lib.throwIfNot (((len == 6) || (len == 8)))) "Invalid hex color: '${((value: let kind = builtins.typeOf value; in if kind == "string" then value else if kind == "bool" || kind == "int" || kind == "float" then builtins.toJSON value else if kind == "path" then "${value}" else if kind == "set" && (value.type or null) == "derivation" && builtins.isString (value.outPath or null) then value.outPath else throw "/nix/store/59qqzf108ga8h2qmsjizzsn2p7i889xx-zenpkgs-dsl-source/modules/desktops/gnome/extensions/coverflow-alt-tab.zmdl:30: string interpolation requires a scalar, path, or package") (s))}'. Must be 6 (RRGGBB) or 8 (RRGGBBAA) characters") ((if (len == 6) then [
    ((norm ((parseHexByte ((((lib.substring 0) 2) hex))))))
    ((norm ((parseHexByte ((((lib.substring 2) 2) hex))))))
    ((norm ((parseHexByte ((((lib.substring 4) 2) hex))))))
    1.0
  ] else [
    ((norm ((parseHexByte ((((lib.substring 0) 2) hex))))))
    ((norm ((parseHexByte ((((lib.substring 2) 2) hex))))))
    ((norm ((parseHexByte ((((lib.substring 4) 2) hex))))))
    ((norm ((parseHexByte ((((lib.substring 6) 2) hex))))))
  ]))))); } ]; }).config.value)));
  normalizeColor = (builtins.addErrorContext "_let normalizeColor annotation mismatch: /nix/store/59qqzf108ga8h2qmsjizzsn2p7i889xx-zenpkgs-dsl-source/modules/desktops/gnome/extensions/coverflow-alt-tab.zmdl:33:1" ((_zenType: _zenValue: let force = type: value: if type.name == "anything" then true else if type.name == "listOf" then builtins.all (force type.nestedTypes.elemType) value else if type.name == "attrsOf" then builtins.all (force type.nestedTypes.elemType) (builtins.attrValues value) else if type.name == "either" then force (if type.nestedTypes.left.check value then type.nestedTypes.left else type.nestedTypes.right) value else builtins.seq value true; in builtins.seq (force _zenType _zenValue) _zenValue) ((lib.types.addCheck lib.types.unspecified builtins.isFunction)) ((lib.evalModules { modules = [ { options.value = lib.mkOption { type = (lib.types.addCheck lib.types.unspecified builtins.isFunction); }; config.value = (value: (let
    tuple = (if (lib.isString value) then ((lib.match "[[:space:]]*\\(([^()]*)\\)[[:space:]]*") value) else null);
    values = (if (lib.isList value) then value else (if ((lib.isString value) && ((lib.hasPrefix "#") value)) then (parseHexColor value) else (((lib.throwIfNot ((tuple != null))) "Coverflow color must be a hex color, RGB list, or RGB tuple string") ((lib.fromJSON "[${((value: let kind = builtins.typeOf value; in if kind == "string" then value else if kind == "bool" || kind == "int" || kind == "float" then builtins.toJSON value else if kind == "path" then "${value}" else if kind == "set" && (value.type or null) == "derivation" && builtins.isString (value.outPath or null) then value.outPath else throw "/nix/store/59qqzf108ga8h2qmsjizzsn2p7i889xx-zenpkgs-dsl-source/modules/desktops/gnome/extensions/coverflow-alt-tab.zmdl:39: string interpolation requires a scalar, path, or package") (((lib.elemAt tuple) 0)))}]")))));
    valid = ((((lib.isList values) && ((lib.length values) >= 3)) && (((tuple == null) || ((lib.length values) == 3)))) && ((lib.all ((channel: (((((lib.isInt channel) || (lib.isFloat channel))) && (channel >= 0)) && (channel <= 1))))) values));
  in (((lib.throwIfNot valid) "Coverflow color requires RGB channels in [0, 1] (exactly three in tuple strings)") ((lib.gvariant.mkTuple (((lib.map ((channel: (lib.gvariant.mkDouble ((channel + 0.0)))))) (((lib.take 3) values))))))))); } ]; }).config.value)));
in
{
  options.zenos.desktops.gnome.extensions.coverflow-alt-tab = lib.mkOption { type = (lib.types.submodule ({ ... }: (let hexToDecMap = (builtins.addErrorContext "_let hexToDecMap annotation mismatch: /nix/store/59qqzf108ga8h2qmsjizzsn2p7i889xx-zenpkgs-dsl-source/modules/desktops/gnome/extensions/coverflow-alt-tab.zmdl:20:1" ((_zenType: _zenValue: let force = type: value: if type.name == "anything" then true else if type.name == "listOf" then builtins.all (force type.nestedTypes.elemType) value else if type.name == "attrsOf" then builtins.all (force type.nestedTypes.elemType) (builtins.attrValues value) else if type.name == "either" then force (if type.nestedTypes.left.check value then type.nestedTypes.left else type.nestedTypes.right) value else builtins.seq value true; in builtins.seq (force _zenType _zenValue) _zenValue) ((lib.types.attrsOf lib.types.int)) ((lib.evalModules { modules = [ { options.value = lib.mkOption { type = (lib.types.attrsOf lib.types.int); }; config.value = {
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
      }; } ]; }).config.value))); hexCharToInt = (builtins.addErrorContext "_let hexCharToInt annotation mismatch: /nix/store/59qqzf108ga8h2qmsjizzsn2p7i889xx-zenpkgs-dsl-source/modules/desktops/gnome/extensions/coverflow-alt-tab.zmdl:21:1" ((_zenType: _zenValue: let force = type: value: if type.name == "anything" then true else if type.name == "listOf" then builtins.all (force type.nestedTypes.elemType) value else if type.name == "attrsOf" then builtins.all (force type.nestedTypes.elemType) (builtins.attrValues value) else if type.name == "either" then force (if type.nestedTypes.left.check value then type.nestedTypes.left else type.nestedTypes.right) value else builtins.seq value true; in builtins.seq (force _zenType _zenValue) _zenValue) ((lib.types.addCheck lib.types.unspecified builtins.isFunction)) ((lib.evalModules { modules = [ { options.value = lib.mkOption { type = (lib.types.addCheck lib.types.unspecified builtins.isFunction); }; config.value = (c: (((lib.throwIfNot (((lib.hasAttr c) hexToDecMap))) "Invalid hex character: ${((value: let kind = builtins.typeOf value; in if kind == "string" then value else if kind == "bool" || kind == "int" || kind == "float" then builtins.toJSON value else if kind == "path" then "${value}" else if kind == "set" && (value.type or null) == "derivation" && builtins.isString (value.outPath or null) then value.outPath else throw "/nix/store/59qqzf108ga8h2qmsjizzsn2p7i889xx-zenpkgs-dsl-source/modules/desktops/gnome/extensions/coverflow-alt-tab.zmdl:22: string interpolation requires a scalar, path, or package") (c))}") (((lib.getAttr c) hexToDecMap)))); } ]; }).config.value))); parseHexByte = (builtins.addErrorContext "_let parseHexByte annotation mismatch: /nix/store/59qqzf108ga8h2qmsjizzsn2p7i889xx-zenpkgs-dsl-source/modules/desktops/gnome/extensions/coverflow-alt-tab.zmdl:23:1" ((_zenType: _zenValue: let force = type: value: if type.name == "anything" then true else if type.name == "listOf" then builtins.all (force type.nestedTypes.elemType) value else if type.name == "attrsOf" then builtins.all (force type.nestedTypes.elemType) (builtins.attrValues value) else if type.name == "either" then force (if type.nestedTypes.left.check value then type.nestedTypes.left else type.nestedTypes.right) value else builtins.seq value true; in builtins.seq (force _zenType _zenValue) _zenValue) ((lib.types.addCheck lib.types.unspecified builtins.isFunction)) ((lib.evalModules { modules = [ { options.value = lib.mkOption { type = (lib.types.addCheck lib.types.unspecified builtins.isFunction); }; config.value = (s: ((((hexCharToInt ((((lib.substring 0) 1) s))) * 16)) + (hexCharToInt ((((lib.substring 1) 1) s))))); } ]; }).config.value))); parseHexColor = (builtins.addErrorContext "_let parseHexColor annotation mismatch: /nix/store/59qqzf108ga8h2qmsjizzsn2p7i889xx-zenpkgs-dsl-source/modules/desktops/gnome/extensions/coverflow-alt-tab.zmdl:24:1" ((_zenType: _zenValue: let force = type: value: if type.name == "anything" then true else if type.name == "listOf" then builtins.all (force type.nestedTypes.elemType) value else if type.name == "attrsOf" then builtins.all (force type.nestedTypes.elemType) (builtins.attrValues value) else if type.name == "either" then force (if type.nestedTypes.left.check value then type.nestedTypes.left else type.nestedTypes.right) value else builtins.seq value true; in builtins.seq (force _zenType _zenValue) _zenValue) ((lib.types.addCheck lib.types.unspecified builtins.isFunction)) ((lib.evalModules { modules = [ { options.value = lib.mkOption { type = (lib.types.addCheck lib.types.unspecified builtins.isFunction); }; config.value = (s: (let
        hex = ((lib.removePrefix "#") s);
        len = (lib.stringLength hex);
        norm = (v: (v / 255.0));
      in (((lib.throwIfNot (((len == 6) || (len == 8)))) "Invalid hex color: '${((value: let kind = builtins.typeOf value; in if kind == "string" then value else if kind == "bool" || kind == "int" || kind == "float" then builtins.toJSON value else if kind == "path" then "${value}" else if kind == "set" && (value.type or null) == "derivation" && builtins.isString (value.outPath or null) then value.outPath else throw "/nix/store/59qqzf108ga8h2qmsjizzsn2p7i889xx-zenpkgs-dsl-source/modules/desktops/gnome/extensions/coverflow-alt-tab.zmdl:30: string interpolation requires a scalar, path, or package") (s))}'. Must be 6 (RRGGBB) or 8 (RRGGBBAA) characters") ((if (len == 6) then [
        ((norm ((parseHexByte ((((lib.substring 0) 2) hex))))))
        ((norm ((parseHexByte ((((lib.substring 2) 2) hex))))))
        ((norm ((parseHexByte ((((lib.substring 4) 2) hex))))))
        1.0
      ] else [
        ((norm ((parseHexByte ((((lib.substring 0) 2) hex))))))
        ((norm ((parseHexByte ((((lib.substring 2) 2) hex))))))
        ((norm ((parseHexByte ((((lib.substring 4) 2) hex))))))
        ((norm ((parseHexByte ((((lib.substring 6) 2) hex))))))
      ]))))); } ]; }).config.value))); normalizeColor = (builtins.addErrorContext "_let normalizeColor annotation mismatch: /nix/store/59qqzf108ga8h2qmsjizzsn2p7i889xx-zenpkgs-dsl-source/modules/desktops/gnome/extensions/coverflow-alt-tab.zmdl:33:1" ((_zenType: _zenValue: let force = type: value: if type.name == "anything" then true else if type.name == "listOf" then builtins.all (force type.nestedTypes.elemType) value else if type.name == "attrsOf" then builtins.all (force type.nestedTypes.elemType) (builtins.attrValues value) else if type.name == "either" then force (if type.nestedTypes.left.check value then type.nestedTypes.left else type.nestedTypes.right) value else builtins.seq value true; in builtins.seq (force _zenType _zenValue) _zenValue) ((lib.types.addCheck lib.types.unspecified builtins.isFunction)) ((lib.evalModules { modules = [ { options.value = lib.mkOption { type = (lib.types.addCheck lib.types.unspecified builtins.isFunction); }; config.value = (value: (let
        tuple = (if (lib.isString value) then ((lib.match "[[:space:]]*\\(([^()]*)\\)[[:space:]]*") value) else null);
        values = (if (lib.isList value) then value else (if ((lib.isString value) && ((lib.hasPrefix "#") value)) then (parseHexColor value) else (((lib.throwIfNot ((tuple != null))) "Coverflow color must be a hex color, RGB list, or RGB tuple string") ((lib.fromJSON "[${((value: let kind = builtins.typeOf value; in if kind == "string" then value else if kind == "bool" || kind == "int" || kind == "float" then builtins.toJSON value else if kind == "path" then "${value}" else if kind == "set" && (value.type or null) == "derivation" && builtins.isString (value.outPath or null) then value.outPath else throw "/nix/store/59qqzf108ga8h2qmsjizzsn2p7i889xx-zenpkgs-dsl-source/modules/desktops/gnome/extensions/coverflow-alt-tab.zmdl:39: string interpolation requires a scalar, path, or package") (((lib.elemAt tuple) 0)))}]")))));
        valid = ((((lib.isList values) && ((lib.length values) >= 3)) && (((tuple == null) || ((lib.length values) == 3)))) && ((lib.all ((channel: (((((lib.isInt channel) || (lib.isFloat channel))) && (channel >= 0)) && (channel <= 1))))) values));
      in (((lib.throwIfNot valid) "Coverflow color requires RGB channels in [0, 1] (exactly three in tuple strings)") ((lib.gvariant.mkTuple (((lib.map ((channel: (lib.gvariant.mkDouble ((channel + 0.0)))))) (((lib.take 3) values))))))))); } ]; }).config.value))); in { options = { animation-time = lib.mkOption { type = lib.types.float; default = 0.2; description = "The duration of coverflow animations in ms"; }; bind-to-switch-applications = lib.mkOption { type = lib.types.bool; default = true; description = "Bind to 'switch-applications' keybinding"; }; bind-to-switch-windows = lib.mkOption { type = lib.types.bool; default = true; description = "Bind to 'switch-windows' keybinding"; }; blur-radius = lib.mkOption { type = lib.types.float; default = 0.0; description = "Radius of Blur Applied to the Background Application Switcher"; }; coverflow-switch-applications = lib.mkOption { type = (lib.types.listOf lib.types.str); default = [
  ""
]; description = "Switch Applications Keyboard Shortcut"; }; coverflow-switch-applications-backward = lib.mkOption { type = (lib.types.listOf lib.types.str); default = [
  ""
]; description = "Switch Applications Backward Keyboard Shortcut"; }; coverflow-switch-windows = lib.mkOption { type = (lib.types.listOf lib.types.str); default = [
  ""
]; description = "Switch Windows Keyboard Shortcut"; }; coverflow-switch-windows-backward = lib.mkOption { type = (lib.types.listOf lib.types.str); default = [
  ""
]; description = "Switch Windows Backward Keyboard Shortcut"; }; coverflow-window-angle = lib.mkOption { type = lib.types.float; default = 90.0; description = "In Coverflow switcher, angle of off-center windows"; }; coverflow-window-offset-width = lib.mkOption { type = lib.types.float; default = 50.0; description = "In Coverflow switcher, distance from center of off-center windows"; }; current-workspace-only = lib.mkOption { type = (lib.types.enum [
  "current"
  "all"
  "all-currentfirst"
]); default = "current"; description = "Show windows from current workspace only"; }; desaturate-factor = lib.mkOption { type = lib.types.float; default = 0.0; description = "Amount to Desaturate the Background Application Switcher"; }; dim-factor = lib.mkOption { type = lib.types.float; default = 1.0; description = "Dim factor for background"; }; easing-function = lib.mkOption { type = lib.types.str; default = "ease-out-cubic"; description = "Easing function used in animations"; }; enable = lib.mkOption { type = lib.types.bool; default = false; description = "Whether to enable Coverflow Alt-Tab GNOME extension configuration."; }; enforce-primary-monitor = lib.mkOption { type = lib.types.bool; default = false; description = "Always show the switcher on the primary monitor"; }; hide-panel = lib.mkOption { type = lib.types.bool; default = true; description = "Hide the panel when showing coverflow"; }; highlight-color = lib.mkOption { type = (lib.types.either lib.types.str (lib.types.listOf lib.types.float)); default = "(1.0,1.0,1.0)"; description = "Highlight Color accepts hex ('#RRGGBB' or '#RRGGBBAA'), a list of at least three channels ([0.0 0.0 0.0]), or an RGB tuple string ('(0.0,0.0,0.0)'). Channels must be in [0, 1]; alpha and extra list channels are validated but ignored."; }; highlight-mouse-over = lib.mkOption { type = lib.types.bool; default = false; description = "Highlight window under mouse"; }; highlight-use-theme-color = lib.mkOption { type = lib.types.bool; default = true; description = "Use theme color for highlight"; }; icon-add-remove-effects = lib.mkOption { type = lib.types.str; default = "Fade Only"; description = "Whether to fade, scale, or both fade and scale icons in and out"; }; icon-has-shadow = lib.mkOption { type = lib.types.bool; default = false; description = "Icon has shadow switch"; }; icon-style = lib.mkOption { type = (lib.types.enum [
  "Classic"
  "Overlay"
  "Attached"
]); default = "Classic"; description = "Icon style"; }; invert-swipes = lib.mkOption { type = lib.types.bool; default = false; description = "Invert System Scroll Direction Setting"; }; offset = lib.mkOption { type = lib.types.int; default = 0; description = "Set a vertical offset"; }; overlay-icon-opacity = lib.mkOption { type = lib.types.float; default = 1.0; description = "The opacity of the overlay icon"; }; overlay-icon-size = lib.mkOption { type = lib.types.float; default = 128.0; description = "The icon size in pixels"; }; perspective-correction-method = lib.mkOption { type = lib.types.str; default = "Move Camera"; description = "Method to correct off-center monitor perspective"; }; position = lib.mkOption { type = (lib.types.enum [
  "Top"
  "Bottom"
]); default = "Bottom"; description = "Position of icon and window title"; }; prefs-default-height = lib.mkOption { type = lib.types.float; default = 600.0; description = "Default height for the preferences window"; }; prefs-default-width = lib.mkOption { type = lib.types.float; default = 700.0; description = "Default width for the preferences window"; }; preview-scaling-factor = lib.mkOption { type = lib.types.float; default = 0.8; description = "Scales Coverflow previews as they spread out to the sides. Sets the extension's coverflow-preview-scaling-factor key; Timeline scaling is independent."; }; preview-to-monitor-ratio = lib.mkOption { type = lib.types.float; default = 0.5; description = "The maximum ratio of the preview dimensions with the monitor dimensions"; }; raise-mouse-over = lib.mkOption { type = lib.types.bool; default = true; description = "Raise window under mouse"; }; randomize-animation-times = lib.mkOption { type = lib.types.bool; default = false; description = "Randomize animation times switch"; }; switch-application-behaves-like-switch-windows = lib.mkOption { type = lib.types.bool; default = false; description = "The application-switcher keybinding action behaves the same as the window-switcher"; }; switch-per-monitor = lib.mkOption { type = lib.types.bool; default = false; description = "Per monitor window switch"; }; switcher-background-color = lib.mkOption { type = (lib.types.either lib.types.str (lib.types.listOf lib.types.float)); default = "(0.0,0.0,0.0)"; description = "Switcher Background Color accepts hex ('#RRGGBB' or '#RRGGBBAA'), a list of at least three channels ([0.0 0.0 0.0]), or an RGB tuple string ('(0.0,0.0,0.0)'). Channels must be in [0, 1]; alpha and extra list channels are validated but ignored."; }; switcher-looping-method = lib.mkOption { type = (lib.types.enum [
  "Flip Stack"
  "Carousel"
]); default = "Flip Stack"; description = "How the windows cycle through the coverflow"; }; switcher-style = lib.mkOption { type = (lib.types.enum [
  "Coverflow"
  "Timeline"
]); default = "Coverflow"; description = "Switcher style"; }; tint-blend = lib.mkOption { type = lib.types.float; default = 0.0; description = "Amount to Blend Tint Color"; }; tint-color = lib.mkOption { type = (lib.types.either lib.types.str (lib.types.listOf lib.types.float)); default = "(0.0,0.0,0.0)"; description = "Tint Color accepts hex ('#RRGGBB' or '#RRGGBBAA'), a list of at least three channels ([0.0 0.0 0.0]), or an RGB tuple string ('(0.0,0.0,0.0)'). Channels must be in [0, 1]; alpha and extra list channels are validated but ignored."; }; tint-use-theme-color = lib.mkOption { type = lib.types.bool; default = true; description = "Use theme color for tint"; }; use-glitch-effect = lib.mkOption { type = lib.types.bool; default = false; description = "Use a 'glitch effect' on the background application switcher"; }; use-tint = lib.mkOption { type = lib.types.bool; default = true; description = "Whether to Use a Tint Color on the Background Application Switcher"; }; verbose-logging = lib.mkOption { type = lib.types.bool; default = false; description = "Whether to log lots of messages or not"; }; }; }))); default = { }; };
  config = lib.mkMerge [
    { _module.args.zenlang.descriptors.desktops.gnome.extensions.coverflow-alt-tab = {
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
            value = "\n    Configures the Coverflow Alt-Tab GNOME extension\n    **Context**\n    This module installs and configures the **Coverflow Alt-Tab** extension for GNOME.\n    It replaces the standard Alt-Tab switcher with a visually rich Coverflow or Timeline 3D effect.\n\n    **Key Features**\n    - 3D Coverflow or Timeline switcher styles.\n    - Highly configurable animations, dimming, and scaling.\n    - Support for custom tint and background colors.\n  ";
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
            value = "Configures the Coverflow Alt-Tab GNOME extension";
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
    moduleIdentity = "zenos.desktops.gnome.extensions.coverflow-alt-tab";
    modulePath = [
      "desktops"
      "gnome"
      "extensions"
      "coverflow-alt-tab"
    ];
    nodeMetadata = [
      {
        metadata = {
          description = {
            multiline = true;
            parts = [
              {
                type = "text";
                value = "\n    Configures the Coverflow Alt-Tab GNOME extension\n    **Context**\n    This module installs and configures the **Coverflow Alt-Tab** extension for GNOME.\n    It replaces the standard Alt-Tab switcher with a visually rich Coverflow or Timeline 3D effect.\n\n    **Key Features**\n    - 3D Coverflow or Timeline switcher styles.\n    - Highly configurable animations, dimming, and scaling.\n    - Support for custom tint and background colors.\n  ";
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
                value = "Configures the Coverflow Alt-Tab GNOME extension";
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
                value = "Whether to enable Coverflow Alt-Tab GNOME extension configuration.";
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
            kind = "true";
            type = "literal";
            value = true;
          };
          description = {
            multiline = true;
            parts = [
              {
                type = "text";
                value = "Hide the panel when showing coverflow";
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
          "hide-panel"
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
                value = "Always show the switcher on the primary monitor";
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
          "enforce-primary-monitor"
        ];
      }
      {
        metadata = {
          default = {
            kind = "float";
            type = "literal";
            value = 0.2;
          };
          description = {
            multiline = true;
            parts = [
              {
                type = "text";
                value = "The duration of coverflow animations in ms";
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
          "animation-time"
        ];
      }
      {
        metadata = {
          default = {
            kind = "float";
            type = "literal";
            value = 1.0;
          };
          description = {
            multiline = true;
            parts = [
              {
                type = "text";
                value = "Dim factor for background";
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
          "dim-factor"
        ];
      }
      {
        metadata = {
          default = {
            multiline = false;
            parts = [
              {
                type = "text";
                value = "Bottom";
              }
            ];
            type = "string";
          };
          description = {
            multiline = true;
            parts = [
              {
                type = "text";
                value = "Position of icon and window title";
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
                        value = "Top";
                      }
                    ];
                    type = "string";
                  }
                  {
                    multiline = false;
                    parts = [
                      {
                        type = "text";
                        value = "Bottom";
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
          "position"
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
                value = "Set a vertical offset";
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
          "offset"
        ];
      }
      {
        metadata = {
          default = {
            multiline = false;
            parts = [
              {
                type = "text";
                value = "Classic";
              }
            ];
            type = "string";
          };
          description = {
            multiline = true;
            parts = [
              {
                type = "text";
                value = "Icon style";
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
                        value = "Classic";
                      }
                    ];
                    type = "string";
                  }
                  {
                    multiline = false;
                    parts = [
                      {
                        type = "text";
                        value = "Overlay";
                      }
                    ];
                    type = "string";
                  }
                  {
                    multiline = false;
                    parts = [
                      {
                        type = "text";
                        value = "Attached";
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
          "icon-style"
        ];
      }
      {
        metadata = {
          default = {
            kind = "float";
            type = "literal";
            value = 1.0;
          };
          description = {
            multiline = true;
            parts = [
              {
                type = "text";
                value = "The opacity of the overlay icon";
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
          "overlay-icon-opacity"
        ];
      }
      {
        metadata = {
          default = {
            kind = "float";
            type = "literal";
            value = 128.0;
          };
          description = {
            multiline = true;
            parts = [
              {
                type = "text";
                value = "The icon size in pixels";
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
          "overlay-icon-size"
        ];
      }
      {
        metadata = {
          default = {
            multiline = false;
            parts = [
              {
                type = "text";
                value = "Coverflow";
              }
            ];
            type = "string";
          };
          description = {
            multiline = true;
            parts = [
              {
                type = "text";
                value = "Switcher style";
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
                        value = "Coverflow";
                      }
                    ];
                    type = "string";
                  }
                  {
                    multiline = false;
                    parts = [
                      {
                        type = "text";
                        value = "Timeline";
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
          "switcher-style"
        ];
      }
      {
        metadata = {
          default = {
            multiline = false;
            parts = [
              {
                type = "text";
                value = "ease-out-cubic";
              }
            ];
            type = "string";
          };
          description = {
            multiline = true;
            parts = [
              {
                type = "text";
                value = "Easing function used in animations";
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
          "easing-function"
        ];
      }
      {
        metadata = {
          default = {
            multiline = false;
            parts = [
              {
                type = "text";
                value = "current";
              }
            ];
            type = "string";
          };
          description = {
            multiline = true;
            parts = [
              {
                type = "text";
                value = "Show windows from current workspace only";
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
                        value = "current";
                      }
                    ];
                    type = "string";
                  }
                  {
                    multiline = false;
                    parts = [
                      {
                        type = "text";
                        value = "all";
                      }
                    ];
                    type = "string";
                  }
                  {
                    multiline = false;
                    parts = [
                      {
                        type = "text";
                        value = "all-currentfirst";
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
          "current-workspace-only"
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
                value = "Per monitor window switch";
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
          "switch-per-monitor"
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
                value = "Icon has shadow switch";
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
          "icon-has-shadow"
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
                value = "Randomize animation times switch";
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
          "randomize-animation-times"
        ];
      }
      {
        metadata = {
          default = {
            kind = "float";
            type = "literal";
            value = 0.5;
          };
          description = {
            multiline = true;
            parts = [
              {
                type = "text";
                value = "The maximum ratio of the preview dimensions with the monitor dimensions";
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
          "preview-to-monitor-ratio"
        ];
      }
      {
        metadata = {
          default = {
            kind = "float";
            type = "literal";
            value = 0.8;
          };
          description = {
            multiline = true;
            parts = [
              {
                type = "text";
                value = "Scales Coverflow previews as they spread out to the sides. Sets the extension's coverflow-preview-scaling-factor key; Timeline scaling is independent.";
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
          "preview-scaling-factor"
        ];
      }
      {
        metadata = {
          default = {
            kind = "float";
            type = "literal";
            value = 90.0;
          };
          description = {
            multiline = true;
            parts = [
              {
                type = "text";
                value = "In Coverflow switcher, angle of off-center windows";
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
          "coverflow-window-angle"
        ];
      }
      {
        metadata = {
          default = {
            kind = "float";
            type = "literal";
            value = 50.0;
          };
          description = {
            multiline = true;
            parts = [
              {
                type = "text";
                value = "In Coverflow switcher, distance from center of off-center windows";
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
          "coverflow-window-offset-width"
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
                value = "Bind to 'switch-applications' keybinding";
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
          "bind-to-switch-applications"
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
                value = "Bind to 'switch-windows' keybinding";
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
          "bind-to-switch-windows"
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
                value = "Highlight window under mouse";
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
          "highlight-mouse-over"
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
                value = "Use theme color for highlight";
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
          "highlight-use-theme-color"
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
                value = "Raise window under mouse";
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
          "raise-mouse-over"
        ];
      }
      {
        metadata = {
          default = {
            multiline = false;
            parts = [
              {
                type = "text";
                value = "Move Camera";
              }
            ];
            type = "string";
          };
          description = {
            multiline = true;
            parts = [
              {
                type = "text";
                value = "Method to correct off-center monitor perspective";
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
          "perspective-correction-method"
        ];
      }
      {
        metadata = {
          default = {
            kind = "float";
            type = "literal";
            value = 0.0;
          };
          description = {
            multiline = true;
            parts = [
              {
                type = "text";
                value = "Amount to Desaturate the Background Application Switcher";
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
          "desaturate-factor"
        ];
      }
      {
        metadata = {
          default = {
            kind = "float";
            type = "literal";
            value = 0.0;
          };
          description = {
            multiline = true;
            parts = [
              {
                type = "text";
                value = "Radius of Blur Applied to the Background Application Switcher";
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
          "blur-radius"
        ];
      }
      {
        metadata = {
          default = {
            multiline = false;
            parts = [
              {
                type = "text";
                value = "Flip Stack";
              }
            ];
            type = "string";
          };
          description = {
            multiline = true;
            parts = [
              {
                type = "text";
                value = "How the windows cycle through the coverflow";
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
                        value = "Flip Stack";
                      }
                    ];
                    type = "string";
                  }
                  {
                    multiline = false;
                    parts = [
                      {
                        type = "text";
                        value = "Carousel";
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
          "switcher-looping-method"
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
                value = "The application-switcher keybinding action behaves the same as the window-switcher";
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
          "switch-application-behaves-like-switch-windows"
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
                value = "Whether to Use a Tint Color on the Background Application Switcher";
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
          "use-tint"
        ];
      }
      {
        metadata = {
          default = {
            multiline = false;
            parts = [
              {
                type = "text";
                value = "(0.0,0.0,0.0)";
              }
            ];
            type = "string";
          };
          description = {
            multiline = true;
            parts = [
              {
                type = "text";
                value = "Tint Color accepts hex ('#RRGGBB' or '#RRGGBBAA'), a list of at least three channels ([0.0 0.0 0.0]), or an RGB tuple string ('(0.0,0.0,0.0)'). Channels must be in [0, 1]; alpha and extra list channels are validated but ignored.";
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
                  {
                    type = "group";
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
                            value = "list";
                          }
                        ];
                        type = "variable";
                      };
                      type = "call";
                    };
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
                  value = "either";
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
          "tint-color"
        ];
      }
      {
        metadata = {
          default = {
            multiline = false;
            parts = [
              {
                type = "text";
                value = "(0.0,0.0,0.0)";
              }
            ];
            type = "string";
          };
          description = {
            multiline = true;
            parts = [
              {
                type = "text";
                value = "Switcher Background Color accepts hex ('#RRGGBB' or '#RRGGBBAA'), a list of at least three channels ([0.0 0.0 0.0]), or an RGB tuple string ('(0.0,0.0,0.0)'). Channels must be in [0, 1]; alpha and extra list channels are validated but ignored.";
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
                  {
                    type = "group";
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
                            value = "list";
                          }
                        ];
                        type = "variable";
                      };
                      type = "call";
                    };
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
                  value = "either";
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
          "switcher-background-color"
        ];
      }
      {
        metadata = {
          default = {
            kind = "float";
            type = "literal";
            value = 0.0;
          };
          description = {
            multiline = true;
            parts = [
              {
                type = "text";
                value = "Amount to Blend Tint Color";
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
          "tint-blend"
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
                value = "Use theme color for tint";
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
          "tint-use-theme-color"
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
                value = "Use a 'glitch effect' on the background application switcher";
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
          "use-glitch-effect"
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
                value = "Invert System Scroll Direction Setting";
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
          "invert-swipes"
        ];
      }
      {
        metadata = {
          default = {
            multiline = false;
            parts = [
              {
                type = "text";
                value = "(1.0,1.0,1.0)";
              }
            ];
            type = "string";
          };
          description = {
            multiline = true;
            parts = [
              {
                type = "text";
                value = "Highlight Color accepts hex ('#RRGGBB' or '#RRGGBBAA'), a list of at least three channels ([0.0 0.0 0.0]), or an RGB tuple string ('(0.0,0.0,0.0)'). Channels must be in [0, 1]; alpha and extra list channels are validated but ignored.";
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
                  {
                    type = "group";
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
                            value = "list";
                          }
                        ];
                        type = "variable";
                      };
                      type = "call";
                    };
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
                  value = "either";
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
          "highlight-color"
        ];
      }
      {
        metadata = {
          default = {
            items = [
              {
                multiline = false;
                parts = [ ];
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
                value = "Switch Windows Keyboard Shortcut";
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
          "coverflow-switch-windows"
        ];
      }
      {
        metadata = {
          default = {
            items = [
              {
                multiline = false;
                parts = [ ];
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
                value = "Switch Windows Backward Keyboard Shortcut";
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
          "coverflow-switch-windows-backward"
        ];
      }
      {
        metadata = {
          default = {
            items = [
              {
                multiline = false;
                parts = [ ];
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
                value = "Switch Applications Keyboard Shortcut";
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
          "coverflow-switch-applications"
        ];
      }
      {
        metadata = {
          default = {
            items = [
              {
                multiline = false;
                parts = [ ];
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
                value = "Switch Applications Backward Keyboard Shortcut";
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
          "coverflow-switch-applications-backward"
        ];
      }
      {
        metadata = {
          default = {
            kind = "float";
            type = "literal";
            value = 700.0;
          };
          description = {
            multiline = true;
            parts = [
              {
                type = "text";
                value = "Default width for the preferences window";
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
          "prefs-default-width"
        ];
      }
      {
        metadata = {
          default = {
            kind = "float";
            type = "literal";
            value = 600.0;
          };
          description = {
            multiline = true;
            parts = [
              {
                type = "text";
                value = "Default height for the preferences window";
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
          "prefs-default-height"
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
                value = "Whether to log lots of messages or not";
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
          "verbose-logging"
        ];
      }
      {
        metadata = {
          default = {
            multiline = false;
            parts = [
              {
                type = "text";
                value = "Fade Only";
              }
            ];
            type = "string";
          };
          description = {
            multiline = true;
            parts = [
              {
                type = "text";
                value = "Whether to fade, scale, or both fade and scale icons in and out";
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
          "icon-add-remove-effects"
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
                    value = "Configures the Coverflow Alt-Tab GNOME extension";
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
                    value = "\n    Configures the Coverflow Alt-Tab GNOME extension\n    **Context**\n    This module installs and configures the **Coverflow Alt-Tab** extension for GNOME.\n    It replaces the standard Alt-Tab switcher with a visually rich Coverflow or Timeline 3D effect.\n\n    **Key Features**\n    - 3D Coverflow or Timeline switcher styles.\n    - Highly configurable animations, dimming, and scaling.\n    - Support for custom tint and background colors.\n  ";
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
        name = "hexCharToInt";
        type = "let-binding";
        value = {
          body = {
            arguments = [
              {
                type = "group";
                value = {
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
              }
            ];
            callee = {
              arguments = [
                {
                  multiline = false;
                  parts = [
                    {
                      type = "text";
                      value = "Invalid hex character: ";
                    }
                    {
                      expression = {
                        path = [
                          {
                            kind = "identifier";
                            value = "c";
                          }
                        ];
                        type = "reference";
                      };
                      type = "interpolation";
                    }
                  ];
                  type = "string";
                }
              ];
              callee = {
                arguments = [
                  {
                    type = "group";
                    value = {
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
                  }
                ];
                callee = {
                  name = "lib";
                  path = [
                    {
                      kind = "identifier";
                      value = "throwIfNot";
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
        name = "parseHexColor";
        type = "let-binding";
        value = {
          body = {
            body = {
              arguments = [
                {
                  type = "group";
                  value = {
                    condition = {
                      left = {
                        path = [
                          {
                            kind = "identifier";
                            value = "len";
                          }
                        ];
                        type = "reference";
                      };
                      operator = "==";
                      right = {
                        kind = "integer";
                        type = "literal";
                        value = 6;
                      };
                      type = "binary";
                    };
                    "else" = {
                      items = [
                        {
                          type = "group";
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
                              path = [
                                {
                                  kind = "identifier";
                                  value = "norm";
                                }
                              ];
                              type = "reference";
                            };
                            type = "call";
                          };
                        }
                        {
                          type = "group";
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
                              path = [
                                {
                                  kind = "identifier";
                                  value = "norm";
                                }
                              ];
                              type = "reference";
                            };
                            type = "call";
                          };
                        }
                        {
                          type = "group";
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
                              path = [
                                {
                                  kind = "identifier";
                                  value = "norm";
                                }
                              ];
                              type = "reference";
                            };
                            type = "call";
                          };
                        }
                        {
                          type = "group";
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
                              }
                            ];
                            callee = {
                              path = [
                                {
                                  kind = "identifier";
                                  value = "norm";
                                }
                              ];
                              type = "reference";
                            };
                            type = "call";
                          };
                        }
                      ];
                      type = "list";
                    };
                    "then" = {
                      items = [
                        {
                          type = "group";
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
                              path = [
                                {
                                  kind = "identifier";
                                  value = "norm";
                                }
                              ];
                              type = "reference";
                            };
                            type = "call";
                          };
                        }
                        {
                          type = "group";
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
                              path = [
                                {
                                  kind = "identifier";
                                  value = "norm";
                                }
                              ];
                              type = "reference";
                            };
                            type = "call";
                          };
                        }
                        {
                          type = "group";
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
                              path = [
                                {
                                  kind = "identifier";
                                  value = "norm";
                                }
                              ];
                              type = "reference";
                            };
                            type = "call";
                          };
                        }
                        {
                          kind = "float";
                          type = "literal";
                          value = 1.0;
                        }
                      ];
                      type = "list";
                    };
                    type = "if";
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
                        value = "Invalid hex color: '";
                      }
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
                        value = "'. Must be 6 (RRGGBB) or 8 (RRGGBBAA) characters";
                      }
                    ];
                    type = "string";
                  }
                ];
                callee = {
                  arguments = [
                    {
                      type = "group";
                      value = {
                        left = {
                          left = {
                            path = [
                              {
                                kind = "identifier";
                                value = "len";
                              }
                            ];
                            type = "reference";
                          };
                          operator = "==";
                          right = {
                            kind = "integer";
                            type = "literal";
                            value = 6;
                          };
                          type = "binary";
                        };
                        operator = "||";
                        right = {
                          left = {
                            path = [
                              {
                                kind = "identifier";
                                value = "len";
                              }
                            ];
                            type = "reference";
                          };
                          operator = "==";
                          right = {
                            kind = "integer";
                            type = "literal";
                            value = 8;
                          };
                          type = "binary";
                        };
                        type = "binary";
                      };
                    }
                  ];
                  callee = {
                    name = "lib";
                    path = [
                      {
                        kind = "identifier";
                        value = "throwIfNot";
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
                    value = "len";
                  }
                ];
                type = "assignment";
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
              }
              {
                operator = "=";
                target = [
                  {
                    kind = "identifier";
                    value = "norm";
                  }
                ];
                type = "assignment";
                value = {
                  body = {
                    left = {
                      path = [
                        {
                          kind = "identifier";
                          value = "v";
                        }
                      ];
                      type = "reference";
                    };
                    operator = "/";
                    right = {
                      kind = "float";
                      type = "literal";
                      value = 255.0;
                    };
                    type = "binary";
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
            type = "let";
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
        name = "normalizeColor";
        type = "let-binding";
        value = {
          body = {
            body = {
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
                                      kind = "integer";
                                      type = "literal";
                                      value = 3;
                                    }
                                  ];
                                  callee = {
                                    name = "lib";
                                    path = [
                                      {
                                        kind = "identifier";
                                        value = "take";
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
                                type = "group";
                                value = {
                                  body = {
                                    arguments = [
                                      {
                                        type = "group";
                                        value = {
                                          left = {
                                            path = [
                                              {
                                                kind = "identifier";
                                                value = "channel";
                                              }
                                            ];
                                            type = "reference";
                                          };
                                          operator = "+";
                                          right = {
                                            kind = "float";
                                            type = "literal";
                                            value = 0.0;
                                          };
                                          type = "binary";
                                        };
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
                                          value = "mkDouble";
                                        }
                                      ];
                                      type = "variable";
                                    };
                                    type = "call";
                                  };
                                  form = "identifier";
                                  parameters = [
                                    {
                                      default = null;
                                      name = "channel";
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
                                  value = "map";
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
                      name = "lib";
                      path = [
                        {
                          kind = "identifier";
                          value = "gvariant";
                        }
                        {
                          kind = "identifier";
                          value = "mkTuple";
                        }
                      ];
                      type = "variable";
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
                        value = "Coverflow color requires RGB channels in [0, 1] (exactly three in tuple strings)";
                      }
                    ];
                    type = "string";
                  }
                ];
                callee = {
                  arguments = [
                    {
                      path = [
                        {
                          kind = "identifier";
                          value = "valid";
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
                        value = "throwIfNot";
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
            statements = [
              {
                operator = "=";
                target = [
                  {
                    kind = "identifier";
                    value = "tuple";
                  }
                ];
                type = "assignment";
                value = {
                  condition = {
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
                  "else" = {
                    kind = "null";
                    type = "literal";
                    value = null;
                  };
                  "then" = {
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
                              value = "[[:space:]]*\\(([^()]*)\\)[[:space:]]*";
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
                            value = "match";
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
              }
              {
                operator = "=";
                target = [
                  {
                    kind = "identifier";
                    value = "values";
                  }
                ];
                type = "assignment";
                value = {
                  condition = {
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
                          value = "isList";
                        }
                      ];
                      type = "variable";
                    };
                    type = "call";
                  };
                  "else" = {
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
                      arguments = [
                        {
                          type = "group";
                          value = {
                            arguments = [
                              {
                                multiline = false;
                                parts = [
                                  {
                                    type = "text";
                                    value = "[";
                                  }
                                  {
                                    expression = {
                                      arguments = [
                                        {
                                          kind = "integer";
                                          type = "literal";
                                          value = 0;
                                        }
                                      ];
                                      callee = {
                                        arguments = [
                                          {
                                            path = [
                                              {
                                                kind = "identifier";
                                                value = "tuple";
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
                                              value = "elemAt";
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
                                    value = "]";
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
                                  value = "fromJSON";
                                }
                              ];
                              type = "variable";
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
                                value = "Coverflow color must be a hex color, RGB list, or RGB tuple string";
                              }
                            ];
                            type = "string";
                          }
                        ];
                        callee = {
                          arguments = [
                            {
                              type = "group";
                              value = {
                                left = {
                                  path = [
                                    {
                                      kind = "identifier";
                                      value = "tuple";
                                    }
                                  ];
                                  type = "reference";
                                };
                                operator = "!=";
                                right = {
                                  kind = "null";
                                  type = "literal";
                                  value = null;
                                };
                                type = "binary";
                              };
                            }
                          ];
                          callee = {
                            name = "lib";
                            path = [
                              {
                                kind = "identifier";
                                value = "throwIfNot";
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
                    "then" = {
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
                        name = "v";
                        path = [
                          {
                            kind = "identifier";
                            value = "parseHexColor";
                          }
                        ];
                        type = "variable";
                      };
                      type = "call";
                    };
                    type = "if";
                  };
                  "then" = {
                    path = [
                      {
                        kind = "identifier";
                        value = "value";
                      }
                    ];
                    type = "reference";
                  };
                  type = "if";
                };
              }
              {
                operator = "=";
                target = [
                  {
                    kind = "identifier";
                    value = "valid";
                  }
                ];
                type = "assignment";
                value = {
                  left = {
                    left = {
                      left = {
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
                          name = "lib";
                          path = [
                            {
                              kind = "identifier";
                              value = "isList";
                            }
                          ];
                          type = "variable";
                        };
                        type = "call";
                      };
                      operator = "&&";
                      right = {
                        left = {
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
                            name = "lib";
                            path = [
                              {
                                kind = "identifier";
                                value = "length";
                              }
                            ];
                            type = "variable";
                          };
                          type = "call";
                        };
                        operator = ">=";
                        right = {
                          kind = "integer";
                          type = "literal";
                          value = 3;
                        };
                        type = "binary";
                      };
                      type = "binary";
                    };
                    operator = "&&";
                    right = {
                      type = "group";
                      value = {
                        left = {
                          left = {
                            path = [
                              {
                                kind = "identifier";
                                value = "tuple";
                              }
                            ];
                            type = "reference";
                          };
                          operator = "==";
                          right = {
                            kind = "null";
                            type = "literal";
                            value = null;
                          };
                          type = "binary";
                        };
                        operator = "||";
                        right = {
                          left = {
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
                              name = "lib";
                              path = [
                                {
                                  kind = "identifier";
                                  value = "length";
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
                            value = 3;
                          };
                          type = "binary";
                        };
                        type = "binary";
                      };
                    };
                    type = "binary";
                  };
                  operator = "&&";
                  right = {
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
                              left = {
                                left = {
                                  type = "group";
                                  value = {
                                    left = {
                                      arguments = [
                                        {
                                          path = [
                                            {
                                              kind = "identifier";
                                              value = "channel";
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
                                            value = "isInt";
                                          }
                                        ];
                                        type = "variable";
                                      };
                                      type = "call";
                                    };
                                    operator = "||";
                                    right = {
                                      arguments = [
                                        {
                                          path = [
                                            {
                                              kind = "identifier";
                                              value = "channel";
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
                                            value = "isFloat";
                                          }
                                        ];
                                        type = "variable";
                                      };
                                      type = "call";
                                    };
                                    type = "binary";
                                  };
                                };
                                operator = "&&";
                                right = {
                                  left = {
                                    path = [
                                      {
                                        kind = "identifier";
                                        value = "channel";
                                      }
                                    ];
                                    type = "reference";
                                  };
                                  operator = ">=";
                                  right = {
                                    kind = "integer";
                                    type = "literal";
                                    value = 0;
                                  };
                                  type = "binary";
                                };
                                type = "binary";
                              };
                              operator = "&&";
                              right = {
                                left = {
                                  path = [
                                    {
                                      kind = "identifier";
                                      value = "channel";
                                    }
                                  ];
                                  type = "reference";
                                };
                                operator = "<=";
                                right = {
                                  kind = "integer";
                                  type = "literal";
                                  value = 1;
                                };
                                type = "binary";
                              };
                              type = "binary";
                            };
                            form = "identifier";
                            parameters = [
                              {
                                default = null;
                                name = "channel";
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
                            value = "all";
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
                            value = "Whether to enable Coverflow Alt-Tab GNOME extension configuration.";
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
                                value = "coverflow-alt-tab";
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
                                value = "coverflow-alt-tab";
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
                          value = "org/gnome/shell/extensions/coverflowalttab";
                        }
                      ];
                      type = "assignment";
                      value = {
                        recursive = false;
                        statements = [
                          {
                            operator = "=";
                            target = [
                              {
                                kind = "identifier";
                                value = "hide-panel";
                              }
                            ];
                            type = "assignment";
                            value = {
                              name = "path";
                              path = [
                                {
                                  kind = "identifier";
                                  value = "hide-panel";
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
                                value = "enforce-primary-monitor";
                              }
                            ];
                            type = "assignment";
                            value = {
                              name = "path";
                              path = [
                                {
                                  kind = "identifier";
                                  value = "enforce-primary-monitor";
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
                                value = "animation-time";
                              }
                            ];
                            type = "assignment";
                            value = {
                              name = "path";
                              path = [
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
                                value = "dim-factor";
                              }
                            ];
                            type = "assignment";
                            value = {
                              name = "path";
                              path = [
                                {
                                  kind = "identifier";
                                  value = "dim-factor";
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
                                value = "position";
                              }
                            ];
                            type = "assignment";
                            value = {
                              name = "path";
                              path = [
                                {
                                  kind = "identifier";
                                  value = "position";
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
                                value = "offset";
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
                                      value = "offset";
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
                                value = "icon-style";
                              }
                            ];
                            type = "assignment";
                            value = {
                              name = "path";
                              path = [
                                {
                                  kind = "identifier";
                                  value = "icon-style";
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
                                value = "overlay-icon-opacity";
                              }
                            ];
                            type = "assignment";
                            value = {
                              name = "path";
                              path = [
                                {
                                  kind = "identifier";
                                  value = "overlay-icon-opacity";
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
                                value = "overlay-icon-size";
                              }
                            ];
                            type = "assignment";
                            value = {
                              name = "path";
                              path = [
                                {
                                  kind = "identifier";
                                  value = "overlay-icon-size";
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
                                value = "switcher-style";
                              }
                            ];
                            type = "assignment";
                            value = {
                              name = "path";
                              path = [
                                {
                                  kind = "identifier";
                                  value = "switcher-style";
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
                                value = "easing-function";
                              }
                            ];
                            type = "assignment";
                            value = {
                              name = "path";
                              path = [
                                {
                                  kind = "identifier";
                                  value = "easing-function";
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
                                value = "current-workspace-only";
                              }
                            ];
                            type = "assignment";
                            value = {
                              name = "path";
                              path = [
                                {
                                  kind = "identifier";
                                  value = "current-workspace-only";
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
                                value = "switch-per-monitor";
                              }
                            ];
                            type = "assignment";
                            value = {
                              name = "path";
                              path = [
                                {
                                  kind = "identifier";
                                  value = "switch-per-monitor";
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
                                value = "icon-has-shadow";
                              }
                            ];
                            type = "assignment";
                            value = {
                              name = "path";
                              path = [
                                {
                                  kind = "identifier";
                                  value = "icon-has-shadow";
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
                                value = "randomize-animation-times";
                              }
                            ];
                            type = "assignment";
                            value = {
                              name = "path";
                              path = [
                                {
                                  kind = "identifier";
                                  value = "randomize-animation-times";
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
                                value = "preview-to-monitor-ratio";
                              }
                            ];
                            type = "assignment";
                            value = {
                              name = "path";
                              path = [
                                {
                                  kind = "identifier";
                                  value = "preview-to-monitor-ratio";
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
                                value = "coverflow-preview-scaling-factor";
                              }
                            ];
                            type = "assignment";
                            value = {
                              name = "path";
                              path = [
                                {
                                  kind = "identifier";
                                  value = "preview-scaling-factor";
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
                                value = "coverflow-window-angle";
                              }
                            ];
                            type = "assignment";
                            value = {
                              name = "path";
                              path = [
                                {
                                  kind = "identifier";
                                  value = "coverflow-window-angle";
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
                                value = "coverflow-window-offset-width";
                              }
                            ];
                            type = "assignment";
                            value = {
                              name = "path";
                              path = [
                                {
                                  kind = "identifier";
                                  value = "coverflow-window-offset-width";
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
                                value = "bind-to-switch-applications";
                              }
                            ];
                            type = "assignment";
                            value = {
                              name = "path";
                              path = [
                                {
                                  kind = "identifier";
                                  value = "bind-to-switch-applications";
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
                                value = "bind-to-switch-windows";
                              }
                            ];
                            type = "assignment";
                            value = {
                              name = "path";
                              path = [
                                {
                                  kind = "identifier";
                                  value = "bind-to-switch-windows";
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
                                value = "highlight-mouse-over";
                              }
                            ];
                            type = "assignment";
                            value = {
                              name = "path";
                              path = [
                                {
                                  kind = "identifier";
                                  value = "highlight-mouse-over";
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
                                value = "highlight-use-theme-color";
                              }
                            ];
                            type = "assignment";
                            value = {
                              name = "path";
                              path = [
                                {
                                  kind = "identifier";
                                  value = "highlight-use-theme-color";
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
                                value = "raise-mouse-over";
                              }
                            ];
                            type = "assignment";
                            value = {
                              name = "path";
                              path = [
                                {
                                  kind = "identifier";
                                  value = "raise-mouse-over";
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
                                value = "perspective-correction-method";
                              }
                            ];
                            type = "assignment";
                            value = {
                              name = "path";
                              path = [
                                {
                                  kind = "identifier";
                                  value = "perspective-correction-method";
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
                                value = "desaturate-factor";
                              }
                            ];
                            type = "assignment";
                            value = {
                              name = "path";
                              path = [
                                {
                                  kind = "identifier";
                                  value = "desaturate-factor";
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
                                value = "blur-radius";
                              }
                            ];
                            type = "assignment";
                            value = {
                              name = "path";
                              path = [
                                {
                                  kind = "identifier";
                                  value = "blur-radius";
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
                                value = "switcher-looping-method";
                              }
                            ];
                            type = "assignment";
                            value = {
                              name = "path";
                              path = [
                                {
                                  kind = "identifier";
                                  value = "switcher-looping-method";
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
                                value = "switch-application-behaves-like-switch-windows";
                              }
                            ];
                            type = "assignment";
                            value = {
                              name = "path";
                              path = [
                                {
                                  kind = "identifier";
                                  value = "switch-application-behaves-like-switch-windows";
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
                                value = "use-tint";
                              }
                            ];
                            type = "assignment";
                            value = {
                              name = "path";
                              path = [
                                {
                                  kind = "identifier";
                                  value = "use-tint";
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
                                value = "tint-color";
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
                                      value = "tint-color";
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
                                    value = "normalizeColor";
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
                                value = "switcher-background-color";
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
                                      value = "switcher-background-color";
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
                                    value = "normalizeColor";
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
                                value = "tint-blend";
                              }
                            ];
                            type = "assignment";
                            value = {
                              name = "path";
                              path = [
                                {
                                  kind = "identifier";
                                  value = "tint-blend";
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
                                value = "tint-use-theme-color";
                              }
                            ];
                            type = "assignment";
                            value = {
                              name = "path";
                              path = [
                                {
                                  kind = "identifier";
                                  value = "tint-use-theme-color";
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
                                value = "use-glitch-effect";
                              }
                            ];
                            type = "assignment";
                            value = {
                              name = "path";
                              path = [
                                {
                                  kind = "identifier";
                                  value = "use-glitch-effect";
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
                                value = "invert-swipes";
                              }
                            ];
                            type = "assignment";
                            value = {
                              name = "path";
                              path = [
                                {
                                  kind = "identifier";
                                  value = "invert-swipes";
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
                                value = "highlight-color";
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
                                      value = "highlight-color";
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
                                    value = "normalizeColor";
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
                                value = "coverflow-switch-windows";
                              }
                            ];
                            type = "assignment";
                            value = {
                              name = "path";
                              path = [
                                {
                                  kind = "identifier";
                                  value = "coverflow-switch-windows";
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
                                value = "coverflow-switch-windows-backward";
                              }
                            ];
                            type = "assignment";
                            value = {
                              name = "path";
                              path = [
                                {
                                  kind = "identifier";
                                  value = "coverflow-switch-windows-backward";
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
                                value = "coverflow-switch-applications";
                              }
                            ];
                            type = "assignment";
                            value = {
                              name = "path";
                              path = [
                                {
                                  kind = "identifier";
                                  value = "coverflow-switch-applications";
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
                                value = "coverflow-switch-applications-backward";
                              }
                            ];
                            type = "assignment";
                            value = {
                              name = "path";
                              path = [
                                {
                                  kind = "identifier";
                                  value = "coverflow-switch-applications-backward";
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
                                value = "prefs-default-width";
                              }
                            ];
                            type = "assignment";
                            value = {
                              name = "path";
                              path = [
                                {
                                  kind = "identifier";
                                  value = "prefs-default-width";
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
                                value = "prefs-default-height";
                              }
                            ];
                            type = "assignment";
                            value = {
                              name = "path";
                              path = [
                                {
                                  kind = "identifier";
                                  value = "prefs-default-height";
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
                                value = "verbose-logging";
                              }
                            ];
                            type = "assignment";
                            value = {
                              name = "path";
                              path = [
                                {
                                  kind = "identifier";
                                  value = "verbose-logging";
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
                                value = "icon-add-remove-effects";
                              }
                            ];
                            type = "assignment";
                            value = {
                              name = "path";
                              path = [
                                {
                                  kind = "identifier";
                                  value = "icon-add-remove-effects";
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
            value = "hide-panel";
          }
        ];
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
                          value = "Hide the panel when showing coverflow";
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
            value = "enforce-primary-monitor";
          }
        ];
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
                          value = "Always show the switcher on the primary monitor";
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
                      value = 0.2;
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
                          value = "The duration of coverflow animations in ms";
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
            value = "dim-factor";
          }
        ];
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
                      value = 1.0;
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
                          value = "Dim factor for background";
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
            value = "position";
          }
        ];
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
                                  value = "Top";
                                }
                              ];
                              type = "string";
                            }
                            {
                              multiline = false;
                              parts = [
                                {
                                  type = "text";
                                  value = "Bottom";
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
                          value = "Bottom";
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
                          value = "Position of icon and window title";
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
            value = "offset";
          }
        ];
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
                          value = "Set a vertical offset";
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
            value = "icon-style";
          }
        ];
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
                                  value = "Classic";
                                }
                              ];
                              type = "string";
                            }
                            {
                              multiline = false;
                              parts = [
                                {
                                  type = "text";
                                  value = "Overlay";
                                }
                              ];
                              type = "string";
                            }
                            {
                              multiline = false;
                              parts = [
                                {
                                  type = "text";
                                  value = "Attached";
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
                          value = "Classic";
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
                          value = "Icon style";
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
            value = "overlay-icon-opacity";
          }
        ];
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
                      value = 1.0;
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
                          value = "The opacity of the overlay icon";
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
            value = "overlay-icon-size";
          }
        ];
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
                      value = 128.0;
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
                          value = "The icon size in pixels";
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
            value = "switcher-style";
          }
        ];
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
                                  value = "Coverflow";
                                }
                              ];
                              type = "string";
                            }
                            {
                              multiline = false;
                              parts = [
                                {
                                  type = "text";
                                  value = "Timeline";
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
                          value = "Coverflow";
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
                          value = "Switcher style";
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
            value = "easing-function";
          }
        ];
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
                          value = "ease-out-cubic";
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
                          value = "Easing function used in animations";
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
            value = "current-workspace-only";
          }
        ];
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
                                  value = "current";
                                }
                              ];
                              type = "string";
                            }
                            {
                              multiline = false;
                              parts = [
                                {
                                  type = "text";
                                  value = "all";
                                }
                              ];
                              type = "string";
                            }
                            {
                              multiline = false;
                              parts = [
                                {
                                  type = "text";
                                  value = "all-currentfirst";
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
                          value = "current";
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
                          value = "Show windows from current workspace only";
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
            value = "switch-per-monitor";
          }
        ];
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
                          value = "Per monitor window switch";
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
            value = "icon-has-shadow";
          }
        ];
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
                          value = "Icon has shadow switch";
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
            value = "randomize-animation-times";
          }
        ];
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
                          value = "Randomize animation times switch";
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
            value = "preview-to-monitor-ratio";
          }
        ];
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
                      value = 0.5;
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
                          value = "The maximum ratio of the preview dimensions with the monitor dimensions";
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
            value = "preview-scaling-factor";
          }
        ];
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
                      value = 0.8;
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
                          value = "Scales Coverflow previews as they spread out to the sides. Sets the extension's coverflow-preview-scaling-factor key; Timeline scaling is independent.";
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
            value = "coverflow-window-angle";
          }
        ];
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
                      value = 90.0;
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
                          value = "In Coverflow switcher, angle of off-center windows";
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
            value = "coverflow-window-offset-width";
          }
        ];
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
                      value = 50.0;
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
                          value = "In Coverflow switcher, distance from center of off-center windows";
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
            value = "bind-to-switch-applications";
          }
        ];
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
                          value = "Bind to 'switch-applications' keybinding";
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
            value = "bind-to-switch-windows";
          }
        ];
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
                          value = "Bind to 'switch-windows' keybinding";
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
            value = "highlight-mouse-over";
          }
        ];
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
                          value = "Highlight window under mouse";
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
            value = "highlight-use-theme-color";
          }
        ];
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
                          value = "Use theme color for highlight";
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
            value = "raise-mouse-over";
          }
        ];
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
                          value = "Raise window under mouse";
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
            value = "perspective-correction-method";
          }
        ];
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
                          value = "Move Camera";
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
                          value = "Method to correct off-center monitor perspective";
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
            value = "desaturate-factor";
          }
        ];
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
                      value = 0.0;
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
                          value = "Amount to Desaturate the Background Application Switcher";
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
            value = "blur-radius";
          }
        ];
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
                      value = 0.0;
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
                          value = "Radius of Blur Applied to the Background Application Switcher";
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
            value = "switcher-looping-method";
          }
        ];
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
                                  value = "Flip Stack";
                                }
                              ];
                              type = "string";
                            }
                            {
                              multiline = false;
                              parts = [
                                {
                                  type = "text";
                                  value = "Carousel";
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
                          value = "Flip Stack";
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
                          value = "How the windows cycle through the coverflow";
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
            value = "switch-application-behaves-like-switch-windows";
          }
        ];
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
                          value = "The application-switcher keybinding action behaves the same as the window-switcher";
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
            value = "use-tint";
          }
        ];
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
                          value = "Whether to Use a Tint Color on the Background Application Switcher";
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
            value = "tint-color";
          }
        ];
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
                            {
                              type = "group";
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
                                      value = "list";
                                    }
                                  ];
                                  type = "variable";
                                };
                                type = "call";
                              };
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
                            value = "either";
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
                          value = "(0.0,0.0,0.0)";
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
                          value = "Tint Color accepts hex ('#RRGGBB' or '#RRGGBBAA'), a list of at least three channels ([0.0 0.0 0.0]), or an RGB tuple string ('(0.0,0.0,0.0)'). Channels must be in [0, 1]; alpha and extra list channels are validated but ignored.";
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
            value = "switcher-background-color";
          }
        ];
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
                            {
                              type = "group";
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
                                      value = "list";
                                    }
                                  ];
                                  type = "variable";
                                };
                                type = "call";
                              };
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
                            value = "either";
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
                          value = "(0.0,0.0,0.0)";
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
                          value = "Switcher Background Color accepts hex ('#RRGGBB' or '#RRGGBBAA'), a list of at least three channels ([0.0 0.0 0.0]), or an RGB tuple string ('(0.0,0.0,0.0)'). Channels must be in [0, 1]; alpha and extra list channels are validated but ignored.";
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
            value = "tint-blend";
          }
        ];
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
                      value = 0.0;
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
                          value = "Amount to Blend Tint Color";
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
            value = "tint-use-theme-color";
          }
        ];
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
                          value = "Use theme color for tint";
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
            value = "use-glitch-effect";
          }
        ];
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
                          value = "Use a 'glitch effect' on the background application switcher";
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
            value = "invert-swipes";
          }
        ];
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
                          value = "Invert System Scroll Direction Setting";
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
            value = "highlight-color";
          }
        ];
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
                            {
                              type = "group";
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
                                      value = "list";
                                    }
                                  ];
                                  type = "variable";
                                };
                                type = "call";
                              };
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
                            value = "either";
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
                          value = "(1.0,1.0,1.0)";
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
                          value = "Highlight Color accepts hex ('#RRGGBB' or '#RRGGBBAA'), a list of at least three channels ([0.0 0.0 0.0]), or an RGB tuple string ('(0.0,0.0,0.0)'). Channels must be in [0, 1]; alpha and extra list channels are validated but ignored.";
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
            value = "coverflow-switch-windows";
          }
        ];
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
                          parts = [ ];
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
                          value = "Switch Windows Keyboard Shortcut";
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
            value = "coverflow-switch-windows-backward";
          }
        ];
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
                          parts = [ ];
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
                          value = "Switch Windows Backward Keyboard Shortcut";
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
            value = "coverflow-switch-applications";
          }
        ];
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
                          parts = [ ];
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
                          value = "Switch Applications Keyboard Shortcut";
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
            value = "coverflow-switch-applications-backward";
          }
        ];
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
                          parts = [ ];
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
                          value = "Switch Applications Backward Keyboard Shortcut";
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
            value = "prefs-default-width";
          }
        ];
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
                      value = 700.0;
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
                          value = "Default width for the preferences window";
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
            value = "prefs-default-height";
          }
        ];
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
                      value = 600.0;
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
                          value = "Default height for the preferences window";
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
            value = "verbose-logging";
          }
        ];
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
                          value = "Whether to log lots of messages or not";
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
            value = "icon-add-remove-effects";
          }
        ];
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
                          value = "Fade Only";
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
                          value = "Whether to fade, scale, or both fade and scale icons in and out";
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
    (let hexToDecMap = (builtins.addErrorContext "_let hexToDecMap annotation mismatch: /nix/store/59qqzf108ga8h2qmsjizzsn2p7i889xx-zenpkgs-dsl-source/modules/desktops/gnome/extensions/coverflow-alt-tab.zmdl:20:1" ((_zenType: _zenValue: let force = type: value: if type.name == "anything" then true else if type.name == "listOf" then builtins.all (force type.nestedTypes.elemType) value else if type.name == "attrsOf" then builtins.all (force type.nestedTypes.elemType) (builtins.attrValues value) else if type.name == "either" then force (if type.nestedTypes.left.check value then type.nestedTypes.left else type.nestedTypes.right) value else builtins.seq value true; in builtins.seq (force _zenType _zenValue) _zenValue) ((lib.types.attrsOf lib.types.int)) ((lib.evalModules { modules = [ { options.value = lib.mkOption { type = (lib.types.attrsOf lib.types.int); }; config.value = {
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
}; } ]; }).config.value))); hexCharToInt = (builtins.addErrorContext "_let hexCharToInt annotation mismatch: /nix/store/59qqzf108ga8h2qmsjizzsn2p7i889xx-zenpkgs-dsl-source/modules/desktops/gnome/extensions/coverflow-alt-tab.zmdl:21:1" ((_zenType: _zenValue: let force = type: value: if type.name == "anything" then true else if type.name == "listOf" then builtins.all (force type.nestedTypes.elemType) value else if type.name == "attrsOf" then builtins.all (force type.nestedTypes.elemType) (builtins.attrValues value) else if type.name == "either" then force (if type.nestedTypes.left.check value then type.nestedTypes.left else type.nestedTypes.right) value else builtins.seq value true; in builtins.seq (force _zenType _zenValue) _zenValue) ((lib.types.addCheck lib.types.unspecified builtins.isFunction)) ((lib.evalModules { modules = [ { options.value = lib.mkOption { type = (lib.types.addCheck lib.types.unspecified builtins.isFunction); }; config.value = (c: (((lib.throwIfNot (((lib.hasAttr c) hexToDecMap))) "Invalid hex character: ${((value: let kind = builtins.typeOf value; in if kind == "string" then value else if kind == "bool" || kind == "int" || kind == "float" then builtins.toJSON value else if kind == "path" then "${value}" else if kind == "set" && (value.type or null) == "derivation" && builtins.isString (value.outPath or null) then value.outPath else throw "/nix/store/59qqzf108ga8h2qmsjizzsn2p7i889xx-zenpkgs-dsl-source/modules/desktops/gnome/extensions/coverflow-alt-tab.zmdl:22: string interpolation requires a scalar, path, or package") (c))}") (((lib.getAttr c) hexToDecMap)))); } ]; }).config.value))); parseHexByte = (builtins.addErrorContext "_let parseHexByte annotation mismatch: /nix/store/59qqzf108ga8h2qmsjizzsn2p7i889xx-zenpkgs-dsl-source/modules/desktops/gnome/extensions/coverflow-alt-tab.zmdl:23:1" ((_zenType: _zenValue: let force = type: value: if type.name == "anything" then true else if type.name == "listOf" then builtins.all (force type.nestedTypes.elemType) value else if type.name == "attrsOf" then builtins.all (force type.nestedTypes.elemType) (builtins.attrValues value) else if type.name == "either" then force (if type.nestedTypes.left.check value then type.nestedTypes.left else type.nestedTypes.right) value else builtins.seq value true; in builtins.seq (force _zenType _zenValue) _zenValue) ((lib.types.addCheck lib.types.unspecified builtins.isFunction)) ((lib.evalModules { modules = [ { options.value = lib.mkOption { type = (lib.types.addCheck lib.types.unspecified builtins.isFunction); }; config.value = (s: ((((hexCharToInt ((((lib.substring 0) 1) s))) * 16)) + (hexCharToInt ((((lib.substring 1) 1) s))))); } ]; }).config.value))); parseHexColor = (builtins.addErrorContext "_let parseHexColor annotation mismatch: /nix/store/59qqzf108ga8h2qmsjizzsn2p7i889xx-zenpkgs-dsl-source/modules/desktops/gnome/extensions/coverflow-alt-tab.zmdl:24:1" ((_zenType: _zenValue: let force = type: value: if type.name == "anything" then true else if type.name == "listOf" then builtins.all (force type.nestedTypes.elemType) value else if type.name == "attrsOf" then builtins.all (force type.nestedTypes.elemType) (builtins.attrValues value) else if type.name == "either" then force (if type.nestedTypes.left.check value then type.nestedTypes.left else type.nestedTypes.right) value else builtins.seq value true; in builtins.seq (force _zenType _zenValue) _zenValue) ((lib.types.addCheck lib.types.unspecified builtins.isFunction)) ((lib.evalModules { modules = [ { options.value = lib.mkOption { type = (lib.types.addCheck lib.types.unspecified builtins.isFunction); }; config.value = (s: (let
  hex = ((lib.removePrefix "#") s);
  len = (lib.stringLength hex);
  norm = (v: (v / 255.0));
in (((lib.throwIfNot (((len == 6) || (len == 8)))) "Invalid hex color: '${((value: let kind = builtins.typeOf value; in if kind == "string" then value else if kind == "bool" || kind == "int" || kind == "float" then builtins.toJSON value else if kind == "path" then "${value}" else if kind == "set" && (value.type or null) == "derivation" && builtins.isString (value.outPath or null) then value.outPath else throw "/nix/store/59qqzf108ga8h2qmsjizzsn2p7i889xx-zenpkgs-dsl-source/modules/desktops/gnome/extensions/coverflow-alt-tab.zmdl:30: string interpolation requires a scalar, path, or package") (s))}'. Must be 6 (RRGGBB) or 8 (RRGGBBAA) characters") ((if (len == 6) then [
  ((norm ((parseHexByte ((((lib.substring 0) 2) hex))))))
  ((norm ((parseHexByte ((((lib.substring 2) 2) hex))))))
  ((norm ((parseHexByte ((((lib.substring 4) 2) hex))))))
  1.0
] else [
  ((norm ((parseHexByte ((((lib.substring 0) 2) hex))))))
  ((norm ((parseHexByte ((((lib.substring 2) 2) hex))))))
  ((norm ((parseHexByte ((((lib.substring 4) 2) hex))))))
  ((norm ((parseHexByte ((((lib.substring 6) 2) hex))))))
]))))); } ]; }).config.value))); normalizeColor = (builtins.addErrorContext "_let normalizeColor annotation mismatch: /nix/store/59qqzf108ga8h2qmsjizzsn2p7i889xx-zenpkgs-dsl-source/modules/desktops/gnome/extensions/coverflow-alt-tab.zmdl:33:1" ((_zenType: _zenValue: let force = type: value: if type.name == "anything" then true else if type.name == "listOf" then builtins.all (force type.nestedTypes.elemType) value else if type.name == "attrsOf" then builtins.all (force type.nestedTypes.elemType) (builtins.attrValues value) else if type.name == "either" then force (if type.nestedTypes.left.check value then type.nestedTypes.left else type.nestedTypes.right) value else builtins.seq value true; in builtins.seq (force _zenType _zenValue) _zenValue) ((lib.types.addCheck lib.types.unspecified builtins.isFunction)) ((lib.evalModules { modules = [ { options.value = lib.mkOption { type = (lib.types.addCheck lib.types.unspecified builtins.isFunction); }; config.value = (value: (let
  tuple = (if (lib.isString value) then ((lib.match "[[:space:]]*\\(([^()]*)\\)[[:space:]]*") value) else null);
  values = (if (lib.isList value) then value else (if ((lib.isString value) && ((lib.hasPrefix "#") value)) then (parseHexColor value) else (((lib.throwIfNot ((tuple != null))) "Coverflow color must be a hex color, RGB list, or RGB tuple string") ((lib.fromJSON "[${((value: let kind = builtins.typeOf value; in if kind == "string" then value else if kind == "bool" || kind == "int" || kind == "float" then builtins.toJSON value else if kind == "path" then "${value}" else if kind == "set" && (value.type or null) == "derivation" && builtins.isString (value.outPath or null) then value.outPath else throw "/nix/store/59qqzf108ga8h2qmsjizzsn2p7i889xx-zenpkgs-dsl-source/modules/desktops/gnome/extensions/coverflow-alt-tab.zmdl:39: string interpolation requires a scalar, path, or package") (((lib.elemAt tuple) 0)))}]")))));
  valid = ((((lib.isList values) && ((lib.length values) >= 3)) && (((tuple == null) || ((lib.length values) == 3)))) && ((lib.all ((channel: (((((lib.isInt channel) || (lib.isFloat channel))) && (channel >= 0)) && (channel <= 1))))) values));
in (((lib.throwIfNot valid) "Coverflow color requires RGB channels in [0, 1] (exactly three in tuple strings)") ((lib.gvariant.mkTuple (((lib.map ((channel: (lib.gvariant.mkDouble ((channel + 0.0)))))) (((lib.take 3) values))))))))); } ]; }).config.value))); in (lib.mkIf ((cfg.enable)) {
      environment.systemPackages = [
        pkgs.zenos.byCategories.desktops.gnome.extensions.coverflow-alt-tab
      ];
    }))
    (let hexToDecMap = (builtins.addErrorContext "_let hexToDecMap annotation mismatch: /nix/store/59qqzf108ga8h2qmsjizzsn2p7i889xx-zenpkgs-dsl-source/modules/desktops/gnome/extensions/coverflow-alt-tab.zmdl:20:1" ((_zenType: _zenValue: let force = type: value: if type.name == "anything" then true else if type.name == "listOf" then builtins.all (force type.nestedTypes.elemType) value else if type.name == "attrsOf" then builtins.all (force type.nestedTypes.elemType) (builtins.attrValues value) else if type.name == "either" then force (if type.nestedTypes.left.check value then type.nestedTypes.left else type.nestedTypes.right) value else builtins.seq value true; in builtins.seq (force _zenType _zenValue) _zenValue) ((lib.types.attrsOf lib.types.int)) ((lib.evalModules { modules = [ { options.value = lib.mkOption { type = (lib.types.attrsOf lib.types.int); }; config.value = {
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
}; } ]; }).config.value))); hexCharToInt = (builtins.addErrorContext "_let hexCharToInt annotation mismatch: /nix/store/59qqzf108ga8h2qmsjizzsn2p7i889xx-zenpkgs-dsl-source/modules/desktops/gnome/extensions/coverflow-alt-tab.zmdl:21:1" ((_zenType: _zenValue: let force = type: value: if type.name == "anything" then true else if type.name == "listOf" then builtins.all (force type.nestedTypes.elemType) value else if type.name == "attrsOf" then builtins.all (force type.nestedTypes.elemType) (builtins.attrValues value) else if type.name == "either" then force (if type.nestedTypes.left.check value then type.nestedTypes.left else type.nestedTypes.right) value else builtins.seq value true; in builtins.seq (force _zenType _zenValue) _zenValue) ((lib.types.addCheck lib.types.unspecified builtins.isFunction)) ((lib.evalModules { modules = [ { options.value = lib.mkOption { type = (lib.types.addCheck lib.types.unspecified builtins.isFunction); }; config.value = (c: (((lib.throwIfNot (((lib.hasAttr c) hexToDecMap))) "Invalid hex character: ${((value: let kind = builtins.typeOf value; in if kind == "string" then value else if kind == "bool" || kind == "int" || kind == "float" then builtins.toJSON value else if kind == "path" then "${value}" else if kind == "set" && (value.type or null) == "derivation" && builtins.isString (value.outPath or null) then value.outPath else throw "/nix/store/59qqzf108ga8h2qmsjizzsn2p7i889xx-zenpkgs-dsl-source/modules/desktops/gnome/extensions/coverflow-alt-tab.zmdl:22: string interpolation requires a scalar, path, or package") (c))}") (((lib.getAttr c) hexToDecMap)))); } ]; }).config.value))); parseHexByte = (builtins.addErrorContext "_let parseHexByte annotation mismatch: /nix/store/59qqzf108ga8h2qmsjizzsn2p7i889xx-zenpkgs-dsl-source/modules/desktops/gnome/extensions/coverflow-alt-tab.zmdl:23:1" ((_zenType: _zenValue: let force = type: value: if type.name == "anything" then true else if type.name == "listOf" then builtins.all (force type.nestedTypes.elemType) value else if type.name == "attrsOf" then builtins.all (force type.nestedTypes.elemType) (builtins.attrValues value) else if type.name == "either" then force (if type.nestedTypes.left.check value then type.nestedTypes.left else type.nestedTypes.right) value else builtins.seq value true; in builtins.seq (force _zenType _zenValue) _zenValue) ((lib.types.addCheck lib.types.unspecified builtins.isFunction)) ((lib.evalModules { modules = [ { options.value = lib.mkOption { type = (lib.types.addCheck lib.types.unspecified builtins.isFunction); }; config.value = (s: ((((hexCharToInt ((((lib.substring 0) 1) s))) * 16)) + (hexCharToInt ((((lib.substring 1) 1) s))))); } ]; }).config.value))); parseHexColor = (builtins.addErrorContext "_let parseHexColor annotation mismatch: /nix/store/59qqzf108ga8h2qmsjizzsn2p7i889xx-zenpkgs-dsl-source/modules/desktops/gnome/extensions/coverflow-alt-tab.zmdl:24:1" ((_zenType: _zenValue: let force = type: value: if type.name == "anything" then true else if type.name == "listOf" then builtins.all (force type.nestedTypes.elemType) value else if type.name == "attrsOf" then builtins.all (force type.nestedTypes.elemType) (builtins.attrValues value) else if type.name == "either" then force (if type.nestedTypes.left.check value then type.nestedTypes.left else type.nestedTypes.right) value else builtins.seq value true; in builtins.seq (force _zenType _zenValue) _zenValue) ((lib.types.addCheck lib.types.unspecified builtins.isFunction)) ((lib.evalModules { modules = [ { options.value = lib.mkOption { type = (lib.types.addCheck lib.types.unspecified builtins.isFunction); }; config.value = (s: (let
  hex = ((lib.removePrefix "#") s);
  len = (lib.stringLength hex);
  norm = (v: (v / 255.0));
in (((lib.throwIfNot (((len == 6) || (len == 8)))) "Invalid hex color: '${((value: let kind = builtins.typeOf value; in if kind == "string" then value else if kind == "bool" || kind == "int" || kind == "float" then builtins.toJSON value else if kind == "path" then "${value}" else if kind == "set" && (value.type or null) == "derivation" && builtins.isString (value.outPath or null) then value.outPath else throw "/nix/store/59qqzf108ga8h2qmsjizzsn2p7i889xx-zenpkgs-dsl-source/modules/desktops/gnome/extensions/coverflow-alt-tab.zmdl:30: string interpolation requires a scalar, path, or package") (s))}'. Must be 6 (RRGGBB) or 8 (RRGGBBAA) characters") ((if (len == 6) then [
  ((norm ((parseHexByte ((((lib.substring 0) 2) hex))))))
  ((norm ((parseHexByte ((((lib.substring 2) 2) hex))))))
  ((norm ((parseHexByte ((((lib.substring 4) 2) hex))))))
  1.0
] else [
  ((norm ((parseHexByte ((((lib.substring 0) 2) hex))))))
  ((norm ((parseHexByte ((((lib.substring 2) 2) hex))))))
  ((norm ((parseHexByte ((((lib.substring 4) 2) hex))))))
  ((norm ((parseHexByte ((((lib.substring 6) 2) hex))))))
]))))); } ]; }).config.value))); normalizeColor = (builtins.addErrorContext "_let normalizeColor annotation mismatch: /nix/store/59qqzf108ga8h2qmsjizzsn2p7i889xx-zenpkgs-dsl-source/modules/desktops/gnome/extensions/coverflow-alt-tab.zmdl:33:1" ((_zenType: _zenValue: let force = type: value: if type.name == "anything" then true else if type.name == "listOf" then builtins.all (force type.nestedTypes.elemType) value else if type.name == "attrsOf" then builtins.all (force type.nestedTypes.elemType) (builtins.attrValues value) else if type.name == "either" then force (if type.nestedTypes.left.check value then type.nestedTypes.left else type.nestedTypes.right) value else builtins.seq value true; in builtins.seq (force _zenType _zenValue) _zenValue) ((lib.types.addCheck lib.types.unspecified builtins.isFunction)) ((lib.evalModules { modules = [ { options.value = lib.mkOption { type = (lib.types.addCheck lib.types.unspecified builtins.isFunction); }; config.value = (value: (let
  tuple = (if (lib.isString value) then ((lib.match "[[:space:]]*\\(([^()]*)\\)[[:space:]]*") value) else null);
  values = (if (lib.isList value) then value else (if ((lib.isString value) && ((lib.hasPrefix "#") value)) then (parseHexColor value) else (((lib.throwIfNot ((tuple != null))) "Coverflow color must be a hex color, RGB list, or RGB tuple string") ((lib.fromJSON "[${((value: let kind = builtins.typeOf value; in if kind == "string" then value else if kind == "bool" || kind == "int" || kind == "float" then builtins.toJSON value else if kind == "path" then "${value}" else if kind == "set" && (value.type or null) == "derivation" && builtins.isString (value.outPath or null) then value.outPath else throw "/nix/store/59qqzf108ga8h2qmsjizzsn2p7i889xx-zenpkgs-dsl-source/modules/desktops/gnome/extensions/coverflow-alt-tab.zmdl:39: string interpolation requires a scalar, path, or package") (((lib.elemAt tuple) 0)))}]")))));
  valid = ((((lib.isList values) && ((lib.length values) >= 3)) && (((tuple == null) || ((lib.length values) == 3)))) && ((lib.all ((channel: (((((lib.isInt channel) || (lib.isFloat channel))) && (channel >= 0)) && (channel <= 1))))) values));
in (((lib.throwIfNot valid) "Coverflow color requires RGB channels in [0, 1] (exactly three in tuple strings)") ((lib.gvariant.mkTuple (((lib.map ((channel: (lib.gvariant.mkDouble ((channel + 0.0)))))) (((lib.take 3) values))))))))); } ]; }).config.value))); in (lib.mkIf ((cfg.enable)) { home-manager.sharedModules = [ {
      dconf.settings."org/gnome/shell".enabled-extensions = [
        pkgs.zenos.byCategories.desktops.gnome.extensions.coverflow-alt-tab.extensionUuid
      ];
      dconf.settings."org/gnome/shell/extensions/coverflowalttab" = {
        hide-panel = cfg.hide-panel;
        enforce-primary-monitor = cfg.enforce-primary-monitor;
        animation-time = cfg.animation-time;
        dim-factor = cfg.dim-factor;
        position = cfg.position;
        offset = (lib.gvariant.mkInt32 cfg.offset);
        icon-style = cfg.icon-style;
        overlay-icon-opacity = cfg.overlay-icon-opacity;
        overlay-icon-size = cfg.overlay-icon-size;
        switcher-style = cfg.switcher-style;
        easing-function = cfg.easing-function;
        current-workspace-only = cfg.current-workspace-only;
        switch-per-monitor = cfg.switch-per-monitor;
        icon-has-shadow = cfg.icon-has-shadow;
        randomize-animation-times = cfg.randomize-animation-times;
        preview-to-monitor-ratio = cfg.preview-to-monitor-ratio;
        coverflow-preview-scaling-factor = cfg.preview-scaling-factor;
        coverflow-window-angle = cfg.coverflow-window-angle;
        coverflow-window-offset-width = cfg.coverflow-window-offset-width;
        bind-to-switch-applications = cfg.bind-to-switch-applications;
        bind-to-switch-windows = cfg.bind-to-switch-windows;
        highlight-mouse-over = cfg.highlight-mouse-over;
        highlight-use-theme-color = cfg.highlight-use-theme-color;
        raise-mouse-over = cfg.raise-mouse-over;
        perspective-correction-method = cfg.perspective-correction-method;
        desaturate-factor = cfg.desaturate-factor;
        blur-radius = cfg.blur-radius;
        switcher-looping-method = cfg.switcher-looping-method;
        switch-application-behaves-like-switch-windows = cfg.switch-application-behaves-like-switch-windows;
        use-tint = cfg.use-tint;
        tint-color = (normalizeColor cfg.tint-color);
        switcher-background-color = (normalizeColor cfg.switcher-background-color);
        tint-blend = cfg.tint-blend;
        tint-use-theme-color = cfg.tint-use-theme-color;
        use-glitch-effect = cfg.use-glitch-effect;
        invert-swipes = cfg.invert-swipes;
        highlight-color = (normalizeColor cfg.highlight-color);
        coverflow-switch-windows = cfg.coverflow-switch-windows;
        coverflow-switch-windows-backward = cfg.coverflow-switch-windows-backward;
        coverflow-switch-applications = cfg.coverflow-switch-applications;
        coverflow-switch-applications-backward = cfg.coverflow-switch-applications-backward;
        prefs-default-width = cfg.prefs-default-width;
        prefs-default-height = cfg.prefs-default-height;
        verbose-logging = cfg.verbose-logging;
        icon-add-remove-effects = cfg.icon-add-remove-effects;
      };
    } ]; }))
  ];
}
