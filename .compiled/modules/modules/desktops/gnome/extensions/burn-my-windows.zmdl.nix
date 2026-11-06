{ config, lib, pkgs, maintainers ? lib.maintainers, licenses ? lib.licenses, ... }:
let
  cfg = config.zenos.desktops.gnome.extensions.burn-my-windows;
  name = "burn-my-windows";
  serializeFloat = (builtins.addErrorContext "_let serializeFloat annotation mismatch: /nix/store/59qqzf108ga8h2qmsjizzsn2p7i889xx-zenpkgs-dsl-source/modules/desktops/gnome/extensions/burn-my-windows.zmdl:20:1" ((_zenType: _zenValue: let force = type: value: if type.name == "anything" then true else if type.name == "listOf" then builtins.all (force type.nestedTypes.elemType) value else if type.name == "attrsOf" then builtins.all (force type.nestedTypes.elemType) (builtins.attrValues value) else if type.name == "either" then force (if type.nestedTypes.left.check value then type.nestedTypes.left else type.nestedTypes.right) value else builtins.seq value true; in builtins.seq (force _zenType _zenValue) _zenValue) ((lib.types.addCheck lib.types.unspecified builtins.isFunction)) ((lib.evalModules { modules = [ { options.value = lib.mkOption { type = (lib.types.addCheck lib.types.unspecified builtins.isFunction); }; config.value = (v: (let
    s = (lib.toString v);
  in (if ((lib.hasInfix ".") s) then s else "${((value: let kind = builtins.typeOf value; in if kind == "string" then value else if kind == "bool" || kind == "int" || kind == "float" then builtins.toJSON value else if kind == "path" then "${value}" else if kind == "set" && (value.type or null) == "derivation" && builtins.isString (value.outPath or null) then value.outPath else throw "/nix/store/59qqzf108ga8h2qmsjizzsn2p7i889xx-zenpkgs-dsl-source/modules/desktops/gnome/extensions/burn-my-windows.zmdl:21: string interpolation requires a scalar, path, or package") (s))}.0"))); } ]; }).config.value)));
  serializeIniValue = (builtins.addErrorContext "_let serializeIniValue annotation mismatch: /nix/store/59qqzf108ga8h2qmsjizzsn2p7i889xx-zenpkgs-dsl-source/modules/desktops/gnome/extensions/burn-my-windows.zmdl:22:1" ((_zenType: _zenValue: let force = type: value: if type.name == "anything" then true else if type.name == "listOf" then builtins.all (force type.nestedTypes.elemType) value else if type.name == "attrsOf" then builtins.all (force type.nestedTypes.elemType) (builtins.attrValues value) else if type.name == "either" then force (if type.nestedTypes.left.check value then type.nestedTypes.left else type.nestedTypes.right) value else builtins.seq value true; in builtins.seq (force _zenType _zenValue) _zenValue) ((lib.types.addCheck lib.types.unspecified builtins.isFunction)) ((lib.evalModules { modules = [ { options.value = lib.mkOption { type = (lib.types.addCheck lib.types.unspecified builtins.isFunction); }; config.value = (v: (if (lib.isBool v) then ((if v then "true" else "false")) else (if (lib.isFloat v) then (serializeFloat v) else (lib.toString v)))); } ]; }).config.value)));
  generateProfileContent = (builtins.addErrorContext "_let generateProfileContent annotation mismatch: /nix/store/59qqzf108ga8h2qmsjizzsn2p7i889xx-zenpkgs-dsl-source/modules/desktops/gnome/extensions/burn-my-windows.zmdl:26:1" ((_zenType: _zenValue: let force = type: value: if type.name == "anything" then true else if type.name == "listOf" then builtins.all (force type.nestedTypes.elemType) value else if type.name == "attrsOf" then builtins.all (force type.nestedTypes.elemType) (builtins.attrValues value) else if type.name == "either" then force (if type.nestedTypes.left.check value then type.nestedTypes.left else type.nestedTypes.right) value else builtins.seq value true; in builtins.seq (force _zenType _zenValue) _zenValue) ((lib.types.addCheck lib.types.unspecified builtins.isFunction)) ((lib.evalModules { modules = [ { options.value = lib.mkOption { type = (lib.types.addCheck lib.types.unspecified builtins.isFunction); }; config.value = (settings: "\n  [burn-my-windows-profile]\n  ${((value: let kind = builtins.typeOf value; in if kind == "string" then value else if kind == "bool" || kind == "int" || kind == "float" then builtins.toJSON value else if kind == "path" then "${value}" else if kind == "set" && (value.type or null) == "derivation" && builtins.isString (value.outPath or null) then value.outPath else throw "/nix/store/59qqzf108ga8h2qmsjizzsn2p7i889xx-zenpkgs-dsl-source/modules/desktops/gnome/extensions/burn-my-windows.zmdl:28: string interpolation requires a scalar, path, or package") (((lib.concatStringsSep "\n") (((lib.mapAttrsToList ((k: (v: "${((value: let kind = builtins.typeOf value; in if kind == "string" then value else if kind == "bool" || kind == "int" || kind == "float" then builtins.toJSON value else if kind == "path" then "${value}" else if kind == "set" && (value.type or null) == "derivation" && builtins.isString (value.outPath or null) then value.outPath else throw "/nix/store/59qqzf108ga8h2qmsjizzsn2p7i889xx-zenpkgs-dsl-source/modules/desktops/gnome/extensions/burn-my-windows.zmdl:28: string interpolation requires a scalar, path, or package") (k))}=${((value: let kind = builtins.typeOf value; in if kind == "string" then value else if kind == "bool" || kind == "int" || kind == "float" then builtins.toJSON value else if kind == "path" then "${value}" else if kind == "set" && (value.type or null) == "derivation" && builtins.isString (value.outPath or null) then value.outPath else throw "/nix/store/59qqzf108ga8h2qmsjizzsn2p7i889xx-zenpkgs-dsl-source/modules/desktops/gnome/extensions/burn-my-windows.zmdl:28: string interpolation requires a scalar, path, or package") ((serializeIniValue v)))}")))) settings)))))}\n"); } ]; }).config.value)));
  managedProfile = (builtins.addErrorContext "_let managedProfile annotation mismatch: /nix/store/59qqzf108ga8h2qmsjizzsn2p7i889xx-zenpkgs-dsl-source/modules/desktops/gnome/extensions/burn-my-windows.zmdl:30:1" ((_zenType: _zenValue: let force = type: value: if type.name == "anything" then true else if type.name == "listOf" then builtins.all (force type.nestedTypes.elemType) value else if type.name == "attrsOf" then builtins.all (force type.nestedTypes.elemType) (builtins.attrValues value) else if type.name == "either" then force (if type.nestedTypes.left.check value then type.nestedTypes.left else type.nestedTypes.right) value else builtins.seq value true; in builtins.seq (force _zenType _zenValue) _zenValue) (lib.types.package) ((lib.evalModules { modules = [ { options.value = lib.mkOption { type = lib.types.package; }; config.value = ((pkgs.zenos.legacy.writeText "burn-my-windows.conf") ((generateProfileContent cfg.settings))); } ]; }).config.value)));
in
{
  options.zenos.desktops.gnome.extensions.burn-my-windows = lib.mkOption { type = (lib.types.submodule ({ ... }: (let serializeFloat = (builtins.addErrorContext "_let serializeFloat annotation mismatch: /nix/store/59qqzf108ga8h2qmsjizzsn2p7i889xx-zenpkgs-dsl-source/modules/desktops/gnome/extensions/burn-my-windows.zmdl:20:1" ((_zenType: _zenValue: let force = type: value: if type.name == "anything" then true else if type.name == "listOf" then builtins.all (force type.nestedTypes.elemType) value else if type.name == "attrsOf" then builtins.all (force type.nestedTypes.elemType) (builtins.attrValues value) else if type.name == "either" then force (if type.nestedTypes.left.check value then type.nestedTypes.left else type.nestedTypes.right) value else builtins.seq value true; in builtins.seq (force _zenType _zenValue) _zenValue) ((lib.types.addCheck lib.types.unspecified builtins.isFunction)) ((lib.evalModules { modules = [ { options.value = lib.mkOption { type = (lib.types.addCheck lib.types.unspecified builtins.isFunction); }; config.value = (v: (let
        s = (lib.toString v);
      in (if ((lib.hasInfix ".") s) then s else "${((value: let kind = builtins.typeOf value; in if kind == "string" then value else if kind == "bool" || kind == "int" || kind == "float" then builtins.toJSON value else if kind == "path" then "${value}" else if kind == "set" && (value.type or null) == "derivation" && builtins.isString (value.outPath or null) then value.outPath else throw "/nix/store/59qqzf108ga8h2qmsjizzsn2p7i889xx-zenpkgs-dsl-source/modules/desktops/gnome/extensions/burn-my-windows.zmdl:21: string interpolation requires a scalar, path, or package") (s))}.0"))); } ]; }).config.value))); serializeIniValue = (builtins.addErrorContext "_let serializeIniValue annotation mismatch: /nix/store/59qqzf108ga8h2qmsjizzsn2p7i889xx-zenpkgs-dsl-source/modules/desktops/gnome/extensions/burn-my-windows.zmdl:22:1" ((_zenType: _zenValue: let force = type: value: if type.name == "anything" then true else if type.name == "listOf" then builtins.all (force type.nestedTypes.elemType) value else if type.name == "attrsOf" then builtins.all (force type.nestedTypes.elemType) (builtins.attrValues value) else if type.name == "either" then force (if type.nestedTypes.left.check value then type.nestedTypes.left else type.nestedTypes.right) value else builtins.seq value true; in builtins.seq (force _zenType _zenValue) _zenValue) ((lib.types.addCheck lib.types.unspecified builtins.isFunction)) ((lib.evalModules { modules = [ { options.value = lib.mkOption { type = (lib.types.addCheck lib.types.unspecified builtins.isFunction); }; config.value = (v: (if (lib.isBool v) then ((if v then "true" else "false")) else (if (lib.isFloat v) then (serializeFloat v) else (lib.toString v)))); } ]; }).config.value))); generateProfileContent = (builtins.addErrorContext "_let generateProfileContent annotation mismatch: /nix/store/59qqzf108ga8h2qmsjizzsn2p7i889xx-zenpkgs-dsl-source/modules/desktops/gnome/extensions/burn-my-windows.zmdl:26:1" ((_zenType: _zenValue: let force = type: value: if type.name == "anything" then true else if type.name == "listOf" then builtins.all (force type.nestedTypes.elemType) value else if type.name == "attrsOf" then builtins.all (force type.nestedTypes.elemType) (builtins.attrValues value) else if type.name == "either" then force (if type.nestedTypes.left.check value then type.nestedTypes.left else type.nestedTypes.right) value else builtins.seq value true; in builtins.seq (force _zenType _zenValue) _zenValue) ((lib.types.addCheck lib.types.unspecified builtins.isFunction)) ((lib.evalModules { modules = [ { options.value = lib.mkOption { type = (lib.types.addCheck lib.types.unspecified builtins.isFunction); }; config.value = (settings: "\n  [burn-my-windows-profile]\n  ${((value: let kind = builtins.typeOf value; in if kind == "string" then value else if kind == "bool" || kind == "int" || kind == "float" then builtins.toJSON value else if kind == "path" then "${value}" else if kind == "set" && (value.type or null) == "derivation" && builtins.isString (value.outPath or null) then value.outPath else throw "/nix/store/59qqzf108ga8h2qmsjizzsn2p7i889xx-zenpkgs-dsl-source/modules/desktops/gnome/extensions/burn-my-windows.zmdl:28: string interpolation requires a scalar, path, or package") (((lib.concatStringsSep "\n") (((lib.mapAttrsToList ((k: (v: "${((value: let kind = builtins.typeOf value; in if kind == "string" then value else if kind == "bool" || kind == "int" || kind == "float" then builtins.toJSON value else if kind == "path" then "${value}" else if kind == "set" && (value.type or null) == "derivation" && builtins.isString (value.outPath or null) then value.outPath else throw "/nix/store/59qqzf108ga8h2qmsjizzsn2p7i889xx-zenpkgs-dsl-source/modules/desktops/gnome/extensions/burn-my-windows.zmdl:28: string interpolation requires a scalar, path, or package") (k))}=${((value: let kind = builtins.typeOf value; in if kind == "string" then value else if kind == "bool" || kind == "int" || kind == "float" then builtins.toJSON value else if kind == "path" then "${value}" else if kind == "set" && (value.type or null) == "derivation" && builtins.isString (value.outPath or null) then value.outPath else throw "/nix/store/59qqzf108ga8h2qmsjizzsn2p7i889xx-zenpkgs-dsl-source/modules/desktops/gnome/extensions/burn-my-windows.zmdl:28: string interpolation requires a scalar, path, or package") ((serializeIniValue v)))}")))) settings)))))}\n"); } ]; }).config.value))); managedProfile = (builtins.addErrorContext "_let managedProfile annotation mismatch: /nix/store/59qqzf108ga8h2qmsjizzsn2p7i889xx-zenpkgs-dsl-source/modules/desktops/gnome/extensions/burn-my-windows.zmdl:30:1" ((_zenType: _zenValue: let force = type: value: if type.name == "anything" then true else if type.name == "listOf" then builtins.all (force type.nestedTypes.elemType) value else if type.name == "attrsOf" then builtins.all (force type.nestedTypes.elemType) (builtins.attrValues value) else if type.name == "either" then force (if type.nestedTypes.left.check value then type.nestedTypes.left else type.nestedTypes.right) value else builtins.seq value true; in builtins.seq (force _zenType _zenValue) _zenValue) (lib.types.package) ((lib.evalModules { modules = [ { options.value = lib.mkOption { type = lib.types.package; }; config.value = ((pkgs.zenos.legacy.writeText "burn-my-windows.conf") ((generateProfileContent cfg.settings))); } ]; }).config.value))); in { options = { active-profile = lib.mkOption { type = lib.types.str; default = ""; description = "\n  Currently selected animation profile\n\n  Absolute path to the active effect profile. When settings are supplied, point\n   this at burn-my-windows/profiles/nix-managed.conf under the user's XDG config directory.\n   With settings but no explicit path, the generated store profile is used.\n"; }; configure = lib.mkOption { type = lib.types.bool; default = cfg.enable; description = "Write settings and the managed profile without activating the extension."; }; enable = lib.mkOption { type = lib.types.bool; default = false; description = "Whether to enable Burn My Windows GNOME extension configuration."; }; last-extension-version = lib.mkOption { type = lib.types.int; default = 0; description = "\n  Internal version of the extension core\n\n  Tracks the version of the extension code for compatibility checks.\n"; }; last-prefs-version = lib.mkOption { type = lib.types.int; default = 0; description = "\n  Internal version of last used preferences\n\n  Tracks updates between the preferences dialog and the extension core.\n"; }; prefs-open-count = lib.mkOption { type = lib.types.int; default = 0; description = "\n  Preferences dialog interaction counter\n\n  Tracks how many times the settings interface has been opened.\n"; }; preview-effect = lib.mkOption { type = lib.types.str; default = ""; description = "\n  Nickname of the effect for preview\n\n  The effect with this nick will be used for the next window animation.\n"; }; settings = lib.mkOption { type = (lib.types.attrsOf (lib.types.either lib.types.bool (lib.types.either lib.types.int (lib.types.either lib.types.float lib.types.str)))); default = { }; description = "\n      Declarative effect parameters for the managed profile\n\n      Generates a custom INI profile at `~/.config/burn-my-windows/profiles/nix-managed.conf`.\n    "; example = {
  fire-enable-effect = true;
  doom-enable-effect = true;
  glide-animation-time = 150;
}; }; show-support-dialog = lib.mkOption { type = lib.types.bool; default = true; description = "\n  Display the ask-for-support dialog\n\n  Whether to allow the extension to show its periodic donation dialog.\n"; }; test-mode = lib.mkOption { type = lib.types.bool; default = false; description = "\n  Enable single-frame animation testing\n\n  If set to true, all animations will show only one still frame.\n"; }; }; }))); default = { }; };
  config = lib.mkMerge [
    { _module.args.zenlang.descriptors.desktops.gnome.extensions.burn-my-windows = {
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
            value = "\n    Retro window opening and closing animations for GNOME\n\n    This module installs and configures the **Burn My Windows** extension for GNOME.\n    It adds retro-style window opening and closing effects, such as fire,\n    tv-glitch, and hexagon.\n\n    **Features:**\n    - Configure active effects and profiles.\n    - Generate custom Nix-managed effect profiles.\n  ";
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
            value = "Retro window opening and closing animations for GNOME";
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
    moduleIdentity = "zenos.desktops.gnome.extensions.burn-my-windows";
    modulePath = [
      "desktops"
      "gnome"
      "extensions"
      "burn-my-windows"
    ];
    nodeMetadata = [
      {
        metadata = {
          description = {
            multiline = true;
            parts = [
              {
                type = "text";
                value = "\n    Retro window opening and closing animations for GNOME\n\n    This module installs and configures the **Burn My Windows** extension for GNOME.\n    It adds retro-style window opening and closing effects, such as fire,\n    tv-glitch, and hexagon.\n\n    **Features:**\n    - Configure active effects and profiles.\n    - Generate custom Nix-managed effect profiles.\n  ";
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
                value = "Retro window opening and closing animations for GNOME";
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
                value = "Whether to enable Burn My Windows GNOME extension configuration.";
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
                value = "Write settings and the managed profile without activating the extension.";
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
                value = "\n  Currently selected animation profile\n\n  Absolute path to the active effect profile. When settings are supplied, point\n   this at burn-my-windows/profiles/nix-managed.conf under the user's XDG config directory.\n   With settings but no explicit path, the generated store profile is used.\n";
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
          "active-profile"
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
                value = "\n  Nickname of the effect for preview\n\n  The effect with this nick will be used for the next window animation.\n";
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
          "preview-effect"
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
                value = "\n  Enable single-frame animation testing\n\n  If set to true, all animations will show only one still frame.\n";
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
          "test-mode"
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
                value = "\n  Display the ask-for-support dialog\n\n  Whether to allow the extension to show its periodic donation dialog.\n";
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
          "show-support-dialog"
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
                value = "\n  Internal version of last used preferences\n\n  Tracks updates between the preferences dialog and the extension core.\n";
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
          "last-prefs-version"
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
                value = "\n  Internal version of the extension core\n\n  Tracks the version of the extension code for compatibility checks.\n";
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
          "last-extension-version"
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
                value = "\n  Preferences dialog interaction counter\n\n  Tracks how many times the settings interface has been opened.\n";
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
          "prefs-open-count"
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
                value = "\n      Declarative effect parameters for the managed profile\n\n      Generates a custom INI profile at `~/.config/burn-my-windows/profiles/nix-managed.conf`.\n    ";
              }
            ];
            type = "string";
          };
          example = {
            recursive = false;
            statements = [
              {
                operator = "=";
                target = [
                  {
                    kind = "identifier";
                    value = "fire-enable-effect";
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
                    value = "doom-enable-effect";
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
                    value = "glide-animation-time";
                  }
                ];
                type = "assignment";
                value = {
                  kind = "integer";
                  type = "literal";
                  value = 150;
                };
              }
            ];
            type = "attr-set";
          };
          type = {
            arguments = [
              {
                items = [
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
                                  value = "bool";
                                }
                              ];
                              type = "variable";
                            }
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
                            value = "either";
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
          "settings"
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
                    value = "Retro window opening and closing animations for GNOME";
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
                    value = "\n    Retro window opening and closing animations for GNOME\n\n    This module installs and configures the **Burn My Windows** extension for GNOME.\n    It adds retro-style window opening and closing effects, such as fire,\n    tv-glitch, and hexagon.\n\n    **Features:**\n    - Configure active effects and profiles.\n    - Generate custom Nix-managed effect profiles.\n  ";
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
                  value = "value";
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
        name = "serializeIniValue";
        type = "let-binding";
        value = {
          body = {
            condition = {
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
                    value = "isBool";
                  }
                ];
                type = "variable";
              };
              type = "call";
            };
            "else" = {
              condition = {
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
                      value = "isFloat";
                    }
                  ];
                  type = "variable";
                };
                type = "call";
              };
              "else" = {
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
              "then" = {
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
            "then" = {
              type = "group";
              value = {
                condition = {
                  path = [
                    {
                      kind = "identifier";
                      value = "v";
                    }
                  ];
                  type = "reference";
                };
                "else" = {
                  multiline = false;
                  parts = [
                    {
                      type = "text";
                      value = "false";
                    }
                  ];
                  type = "string";
                };
                "then" = {
                  multiline = false;
                  parts = [
                    {
                      type = "text";
                      value = "true";
                    }
                  ];
                  type = "string";
                };
                type = "if";
              };
            };
            type = "if";
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
                  value = "settings";
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
        name = "generateProfileContent";
        type = "let-binding";
        value = {
          body = {
            multiline = true;
            parts = [
              {
                type = "text";
                value = "\n  [burn-my-windows-profile]\n  ";
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
                                value = "settings";
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
                                          path = [
                                            {
                                              kind = "identifier";
                                              value = "k";
                                            }
                                          ];
                                          type = "reference";
                                        };
                                        type = "interpolation";
                                      }
                                      {
                                        type = "text";
                                        value = "=";
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
                                            name = "v";
                                            path = [
                                              {
                                                kind = "identifier";
                                                value = "serializeIniValue";
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
                            value = "\n";
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
                value = "\n";
              }
            ];
            type = "string";
          };
          form = "identifier";
          parameters = [
            {
              default = null;
              name = "settings";
              variadic = false;
            }
          ];
          type = "lambda";
        };
      }
      {
        annotation = {
          name = "type";
          path = [
            {
              kind = "identifier";
              value = "package";
            }
          ];
          type = "variable";
        };
        name = "managedProfile";
        type = "let-binding";
        value = {
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
                        value = "settings";
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
                      value = "generateProfileContent";
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
                    value = "burn-my-windows.conf";
                  }
                ];
                type = "string";
              }
            ];
            callee = {
              name = "pkgs";
              path = [
                {
                  kind = "identifier";
                  value = "legacy";
                }
                {
                  kind = "identifier";
                  value = "writeText";
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
                            value = "Whether to enable Burn My Windows GNOME extension configuration.";
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
                                value = "burn-my-windows";
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
                                value = "burn-my-windows";
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
                            value = "Write settings and the managed profile without activating the extension.";
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
                        {
                          kind = "identifier";
                          value = "settings";
                        }
                        {
                          kind = "string";
                          value = "org/gnome/shell/extensions/burn-my-windows";
                        }
                      ];
                      type = "assignment";
                      value = {
                        recursive = false;
                        statements = [
                          {
                            operator = "=";
                            target = [
                              {
                                kind = "identifier";
                                value = "active-profile";
                              }
                            ];
                            type = "assignment";
                            value = {
                              condition = {
                                left = {
                                  left = {
                                    name = "path";
                                    path = [
                                      {
                                        kind = "identifier";
                                        value = "active-profile";
                                      }
                                    ];
                                    type = "variable";
                                  };
                                  operator = "!=";
                                  right = {
                                    multiline = false;
                                    parts = [ ];
                                    type = "string";
                                  };
                                  type = "binary";
                                };
                                operator = "||";
                                right = {
                                  left = {
                                    name = "path";
                                    path = [
                                      {
                                        kind = "identifier";
                                        value = "settings";
                                      }
                                    ];
                                    type = "variable";
                                  };
                                  operator = "==";
                                  right = {
                                    recursive = false;
                                    statements = [ ];
                                    type = "attr-set";
                                  };
                                  type = "binary";
                                };
                                type = "binary";
                              };
                              "else" = {
                                multiline = false;
                                parts = [
                                  {
                                    expression = {
                                      name = "v";
                                      path = [
                                        {
                                          kind = "identifier";
                                          value = "managedProfile";
                                        }
                                      ];
                                      type = "variable";
                                    };
                                    type = "interpolation";
                                  }
                                ];
                                type = "string";
                              };
                              "then" = {
                                name = "path";
                                path = [
                                  {
                                    kind = "identifier";
                                    value = "active-profile";
                                  }
                                ];
                                type = "variable";
                              };
                              type = "if";
                            };
                          }
                          {
                            operator = "=";
                            target = [
                              {
                                kind = "identifier";
                                value = "preview-effect";
                              }
                            ];
                            type = "assignment";
                            value = {
                              name = "path";
                              path = [
                                {
                                  kind = "identifier";
                                  value = "preview-effect";
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
                                value = "test-mode";
                              }
                            ];
                            type = "assignment";
                            value = {
                              name = "path";
                              path = [
                                {
                                  kind = "identifier";
                                  value = "test-mode";
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
                                value = "show-support-dialog";
                              }
                            ];
                            type = "assignment";
                            value = {
                              name = "path";
                              path = [
                                {
                                  kind = "identifier";
                                  value = "show-support-dialog";
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
                                value = "last-prefs-version";
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
                                      value = "last-prefs-version";
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
                                value = "last-extension-version";
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
                                      value = "last-extension-version";
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
                                value = "prefs-open-count";
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
                                      value = "prefs-open-count";
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
                        ];
                        type = "attr-set";
                      };
                    }
                    {
                      operator = "=";
                      target = [
                        {
                          kind = "identifier";
                          value = "xdg";
                        }
                        {
                          kind = "identifier";
                          value = "configFile";
                        }
                        {
                          kind = "string";
                          value = "burn-my-windows/profiles/nix-managed.conf";
                        }
                      ];
                      type = "assignment";
                      value = {
                        arguments = [
                          {
                            recursive = false;
                            statements = [
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
                                  arguments = [
                                    {
                                      name = "path";
                                      path = [
                                        {
                                          kind = "identifier";
                                          value = "settings";
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
                                        value = "generateProfileContent";
                                      }
                                    ];
                                    type = "variable";
                                  };
                                  type = "call";
                                };
                              }
                            ];
                            type = "attr-set";
                          }
                        ];
                        callee = {
                          arguments = [
                            {
                              type = "group";
                              value = {
                                left = {
                                  name = "path";
                                  path = [
                                    {
                                      kind = "identifier";
                                      value = "settings";
                                    }
                                  ];
                                  type = "variable";
                                };
                                operator = "!=";
                                right = {
                                  recursive = false;
                                  statements = [ ];
                                  type = "attr-set";
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
                                value = "mkIf";
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
            value = "active-profile";
          }
        ];
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
                          value = "\n  Currently selected animation profile\n\n  Absolute path to the active effect profile. When settings are supplied, point\n   this at burn-my-windows/profiles/nix-managed.conf under the user's XDG config directory.\n   With settings but no explicit path, the generated store profile is used.\n";
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
            value = "preview-effect";
          }
        ];
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
                          value = "\n  Nickname of the effect for preview\n\n  The effect with this nick will be used for the next window animation.\n";
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
            value = "test-mode";
          }
        ];
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
                          value = "\n  Enable single-frame animation testing\n\n  If set to true, all animations will show only one still frame.\n";
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
            value = "show-support-dialog";
          }
        ];
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
                          value = "\n  Display the ask-for-support dialog\n\n  Whether to allow the extension to show its periodic donation dialog.\n";
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
            value = "last-prefs-version";
          }
        ];
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
                          value = "\n  Internal version of last used preferences\n\n  Tracks updates between the preferences dialog and the extension core.\n";
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
            value = "last-extension-version";
          }
        ];
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
                          value = "\n  Internal version of the extension core\n\n  Tracks the version of the extension code for compatibility checks.\n";
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
            value = "prefs-open-count";
          }
        ];
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
                          value = "\n  Preferences dialog interaction counter\n\n  Tracks how many times the settings interface has been opened.\n";
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
                                            value = "bool";
                                          }
                                        ];
                                        type = "variable";
                                      }
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
                                      value = "either";
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
                          value = "\n      Declarative effect parameters for the managed profile\n\n      Generates a custom INI profile at `~/.config/burn-my-windows/profiles/nix-managed.conf`.\n    ";
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
                        value = "example";
                      }
                    ];
                    type = "assignment";
                    value = {
                      recursive = false;
                      statements = [
                        {
                          operator = "=";
                          target = [
                            {
                              kind = "identifier";
                              value = "fire-enable-effect";
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
                              value = "doom-enable-effect";
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
                              value = "glide-animation-time";
                            }
                          ];
                          type = "assignment";
                          value = {
                            kind = "integer";
                            type = "literal";
                            value = 150;
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
    (let serializeFloat = (builtins.addErrorContext "_let serializeFloat annotation mismatch: /nix/store/59qqzf108ga8h2qmsjizzsn2p7i889xx-zenpkgs-dsl-source/modules/desktops/gnome/extensions/burn-my-windows.zmdl:20:1" ((_zenType: _zenValue: let force = type: value: if type.name == "anything" then true else if type.name == "listOf" then builtins.all (force type.nestedTypes.elemType) value else if type.name == "attrsOf" then builtins.all (force type.nestedTypes.elemType) (builtins.attrValues value) else if type.name == "either" then force (if type.nestedTypes.left.check value then type.nestedTypes.left else type.nestedTypes.right) value else builtins.seq value true; in builtins.seq (force _zenType _zenValue) _zenValue) ((lib.types.addCheck lib.types.unspecified builtins.isFunction)) ((lib.evalModules { modules = [ { options.value = lib.mkOption { type = (lib.types.addCheck lib.types.unspecified builtins.isFunction); }; config.value = (v: (let
  s = (lib.toString v);
in (if ((lib.hasInfix ".") s) then s else "${((value: let kind = builtins.typeOf value; in if kind == "string" then value else if kind == "bool" || kind == "int" || kind == "float" then builtins.toJSON value else if kind == "path" then "${value}" else if kind == "set" && (value.type or null) == "derivation" && builtins.isString (value.outPath or null) then value.outPath else throw "/nix/store/59qqzf108ga8h2qmsjizzsn2p7i889xx-zenpkgs-dsl-source/modules/desktops/gnome/extensions/burn-my-windows.zmdl:21: string interpolation requires a scalar, path, or package") (s))}.0"))); } ]; }).config.value))); serializeIniValue = (builtins.addErrorContext "_let serializeIniValue annotation mismatch: /nix/store/59qqzf108ga8h2qmsjizzsn2p7i889xx-zenpkgs-dsl-source/modules/desktops/gnome/extensions/burn-my-windows.zmdl:22:1" ((_zenType: _zenValue: let force = type: value: if type.name == "anything" then true else if type.name == "listOf" then builtins.all (force type.nestedTypes.elemType) value else if type.name == "attrsOf" then builtins.all (force type.nestedTypes.elemType) (builtins.attrValues value) else if type.name == "either" then force (if type.nestedTypes.left.check value then type.nestedTypes.left else type.nestedTypes.right) value else builtins.seq value true; in builtins.seq (force _zenType _zenValue) _zenValue) ((lib.types.addCheck lib.types.unspecified builtins.isFunction)) ((lib.evalModules { modules = [ { options.value = lib.mkOption { type = (lib.types.addCheck lib.types.unspecified builtins.isFunction); }; config.value = (v: (if (lib.isBool v) then ((if v then "true" else "false")) else (if (lib.isFloat v) then (serializeFloat v) else (lib.toString v)))); } ]; }).config.value))); generateProfileContent = (builtins.addErrorContext "_let generateProfileContent annotation mismatch: /nix/store/59qqzf108ga8h2qmsjizzsn2p7i889xx-zenpkgs-dsl-source/modules/desktops/gnome/extensions/burn-my-windows.zmdl:26:1" ((_zenType: _zenValue: let force = type: value: if type.name == "anything" then true else if type.name == "listOf" then builtins.all (force type.nestedTypes.elemType) value else if type.name == "attrsOf" then builtins.all (force type.nestedTypes.elemType) (builtins.attrValues value) else if type.name == "either" then force (if type.nestedTypes.left.check value then type.nestedTypes.left else type.nestedTypes.right) value else builtins.seq value true; in builtins.seq (force _zenType _zenValue) _zenValue) ((lib.types.addCheck lib.types.unspecified builtins.isFunction)) ((lib.evalModules { modules = [ { options.value = lib.mkOption { type = (lib.types.addCheck lib.types.unspecified builtins.isFunction); }; config.value = (settings: "\n  [burn-my-windows-profile]\n  ${((value: let kind = builtins.typeOf value; in if kind == "string" then value else if kind == "bool" || kind == "int" || kind == "float" then builtins.toJSON value else if kind == "path" then "${value}" else if kind == "set" && (value.type or null) == "derivation" && builtins.isString (value.outPath or null) then value.outPath else throw "/nix/store/59qqzf108ga8h2qmsjizzsn2p7i889xx-zenpkgs-dsl-source/modules/desktops/gnome/extensions/burn-my-windows.zmdl:28: string interpolation requires a scalar, path, or package") (((lib.concatStringsSep "\n") (((lib.mapAttrsToList ((k: (v: "${((value: let kind = builtins.typeOf value; in if kind == "string" then value else if kind == "bool" || kind == "int" || kind == "float" then builtins.toJSON value else if kind == "path" then "${value}" else if kind == "set" && (value.type or null) == "derivation" && builtins.isString (value.outPath or null) then value.outPath else throw "/nix/store/59qqzf108ga8h2qmsjizzsn2p7i889xx-zenpkgs-dsl-source/modules/desktops/gnome/extensions/burn-my-windows.zmdl:28: string interpolation requires a scalar, path, or package") (k))}=${((value: let kind = builtins.typeOf value; in if kind == "string" then value else if kind == "bool" || kind == "int" || kind == "float" then builtins.toJSON value else if kind == "path" then "${value}" else if kind == "set" && (value.type or null) == "derivation" && builtins.isString (value.outPath or null) then value.outPath else throw "/nix/store/59qqzf108ga8h2qmsjizzsn2p7i889xx-zenpkgs-dsl-source/modules/desktops/gnome/extensions/burn-my-windows.zmdl:28: string interpolation requires a scalar, path, or package") ((serializeIniValue v)))}")))) settings)))))}\n"); } ]; }).config.value))); managedProfile = (builtins.addErrorContext "_let managedProfile annotation mismatch: /nix/store/59qqzf108ga8h2qmsjizzsn2p7i889xx-zenpkgs-dsl-source/modules/desktops/gnome/extensions/burn-my-windows.zmdl:30:1" ((_zenType: _zenValue: let force = type: value: if type.name == "anything" then true else if type.name == "listOf" then builtins.all (force type.nestedTypes.elemType) value else if type.name == "attrsOf" then builtins.all (force type.nestedTypes.elemType) (builtins.attrValues value) else if type.name == "either" then force (if type.nestedTypes.left.check value then type.nestedTypes.left else type.nestedTypes.right) value else builtins.seq value true; in builtins.seq (force _zenType _zenValue) _zenValue) (lib.types.package) ((lib.evalModules { modules = [ { options.value = lib.mkOption { type = lib.types.package; }; config.value = ((pkgs.zenos.legacy.writeText "burn-my-windows.conf") ((generateProfileContent cfg.settings))); } ]; }).config.value))); in (lib.mkIf ((cfg.enable)) {
      environment.systemPackages = [
        pkgs.zenos.byCategories.desktops.gnome.extensions.burn-my-windows
      ];
    }))
    (let serializeFloat = (builtins.addErrorContext "_let serializeFloat annotation mismatch: /nix/store/59qqzf108ga8h2qmsjizzsn2p7i889xx-zenpkgs-dsl-source/modules/desktops/gnome/extensions/burn-my-windows.zmdl:20:1" ((_zenType: _zenValue: let force = type: value: if type.name == "anything" then true else if type.name == "listOf" then builtins.all (force type.nestedTypes.elemType) value else if type.name == "attrsOf" then builtins.all (force type.nestedTypes.elemType) (builtins.attrValues value) else if type.name == "either" then force (if type.nestedTypes.left.check value then type.nestedTypes.left else type.nestedTypes.right) value else builtins.seq value true; in builtins.seq (force _zenType _zenValue) _zenValue) ((lib.types.addCheck lib.types.unspecified builtins.isFunction)) ((lib.evalModules { modules = [ { options.value = lib.mkOption { type = (lib.types.addCheck lib.types.unspecified builtins.isFunction); }; config.value = (v: (let
  s = (lib.toString v);
in (if ((lib.hasInfix ".") s) then s else "${((value: let kind = builtins.typeOf value; in if kind == "string" then value else if kind == "bool" || kind == "int" || kind == "float" then builtins.toJSON value else if kind == "path" then "${value}" else if kind == "set" && (value.type or null) == "derivation" && builtins.isString (value.outPath or null) then value.outPath else throw "/nix/store/59qqzf108ga8h2qmsjizzsn2p7i889xx-zenpkgs-dsl-source/modules/desktops/gnome/extensions/burn-my-windows.zmdl:21: string interpolation requires a scalar, path, or package") (s))}.0"))); } ]; }).config.value))); serializeIniValue = (builtins.addErrorContext "_let serializeIniValue annotation mismatch: /nix/store/59qqzf108ga8h2qmsjizzsn2p7i889xx-zenpkgs-dsl-source/modules/desktops/gnome/extensions/burn-my-windows.zmdl:22:1" ((_zenType: _zenValue: let force = type: value: if type.name == "anything" then true else if type.name == "listOf" then builtins.all (force type.nestedTypes.elemType) value else if type.name == "attrsOf" then builtins.all (force type.nestedTypes.elemType) (builtins.attrValues value) else if type.name == "either" then force (if type.nestedTypes.left.check value then type.nestedTypes.left else type.nestedTypes.right) value else builtins.seq value true; in builtins.seq (force _zenType _zenValue) _zenValue) ((lib.types.addCheck lib.types.unspecified builtins.isFunction)) ((lib.evalModules { modules = [ { options.value = lib.mkOption { type = (lib.types.addCheck lib.types.unspecified builtins.isFunction); }; config.value = (v: (if (lib.isBool v) then ((if v then "true" else "false")) else (if (lib.isFloat v) then (serializeFloat v) else (lib.toString v)))); } ]; }).config.value))); generateProfileContent = (builtins.addErrorContext "_let generateProfileContent annotation mismatch: /nix/store/59qqzf108ga8h2qmsjizzsn2p7i889xx-zenpkgs-dsl-source/modules/desktops/gnome/extensions/burn-my-windows.zmdl:26:1" ((_zenType: _zenValue: let force = type: value: if type.name == "anything" then true else if type.name == "listOf" then builtins.all (force type.nestedTypes.elemType) value else if type.name == "attrsOf" then builtins.all (force type.nestedTypes.elemType) (builtins.attrValues value) else if type.name == "either" then force (if type.nestedTypes.left.check value then type.nestedTypes.left else type.nestedTypes.right) value else builtins.seq value true; in builtins.seq (force _zenType _zenValue) _zenValue) ((lib.types.addCheck lib.types.unspecified builtins.isFunction)) ((lib.evalModules { modules = [ { options.value = lib.mkOption { type = (lib.types.addCheck lib.types.unspecified builtins.isFunction); }; config.value = (settings: "\n  [burn-my-windows-profile]\n  ${((value: let kind = builtins.typeOf value; in if kind == "string" then value else if kind == "bool" || kind == "int" || kind == "float" then builtins.toJSON value else if kind == "path" then "${value}" else if kind == "set" && (value.type or null) == "derivation" && builtins.isString (value.outPath or null) then value.outPath else throw "/nix/store/59qqzf108ga8h2qmsjizzsn2p7i889xx-zenpkgs-dsl-source/modules/desktops/gnome/extensions/burn-my-windows.zmdl:28: string interpolation requires a scalar, path, or package") (((lib.concatStringsSep "\n") (((lib.mapAttrsToList ((k: (v: "${((value: let kind = builtins.typeOf value; in if kind == "string" then value else if kind == "bool" || kind == "int" || kind == "float" then builtins.toJSON value else if kind == "path" then "${value}" else if kind == "set" && (value.type or null) == "derivation" && builtins.isString (value.outPath or null) then value.outPath else throw "/nix/store/59qqzf108ga8h2qmsjizzsn2p7i889xx-zenpkgs-dsl-source/modules/desktops/gnome/extensions/burn-my-windows.zmdl:28: string interpolation requires a scalar, path, or package") (k))}=${((value: let kind = builtins.typeOf value; in if kind == "string" then value else if kind == "bool" || kind == "int" || kind == "float" then builtins.toJSON value else if kind == "path" then "${value}" else if kind == "set" && (value.type or null) == "derivation" && builtins.isString (value.outPath or null) then value.outPath else throw "/nix/store/59qqzf108ga8h2qmsjizzsn2p7i889xx-zenpkgs-dsl-source/modules/desktops/gnome/extensions/burn-my-windows.zmdl:28: string interpolation requires a scalar, path, or package") ((serializeIniValue v)))}")))) settings)))))}\n"); } ]; }).config.value))); managedProfile = (builtins.addErrorContext "_let managedProfile annotation mismatch: /nix/store/59qqzf108ga8h2qmsjizzsn2p7i889xx-zenpkgs-dsl-source/modules/desktops/gnome/extensions/burn-my-windows.zmdl:30:1" ((_zenType: _zenValue: let force = type: value: if type.name == "anything" then true else if type.name == "listOf" then builtins.all (force type.nestedTypes.elemType) value else if type.name == "attrsOf" then builtins.all (force type.nestedTypes.elemType) (builtins.attrValues value) else if type.name == "either" then force (if type.nestedTypes.left.check value then type.nestedTypes.left else type.nestedTypes.right) value else builtins.seq value true; in builtins.seq (force _zenType _zenValue) _zenValue) (lib.types.package) ((lib.evalModules { modules = [ { options.value = lib.mkOption { type = lib.types.package; }; config.value = ((pkgs.zenos.legacy.writeText "burn-my-windows.conf") ((generateProfileContent cfg.settings))); } ]; }).config.value))); in (lib.mkIf ((cfg.enable)) { home-manager.sharedModules = [ {
      dconf.settings."org/gnome/shell".enabled-extensions = [
        pkgs.zenos.byCategories.desktops.gnome.extensions.burn-my-windows.extensionUuid
      ];
    } ]; }))
    (let serializeFloat = (builtins.addErrorContext "_let serializeFloat annotation mismatch: /nix/store/59qqzf108ga8h2qmsjizzsn2p7i889xx-zenpkgs-dsl-source/modules/desktops/gnome/extensions/burn-my-windows.zmdl:20:1" ((_zenType: _zenValue: let force = type: value: if type.name == "anything" then true else if type.name == "listOf" then builtins.all (force type.nestedTypes.elemType) value else if type.name == "attrsOf" then builtins.all (force type.nestedTypes.elemType) (builtins.attrValues value) else if type.name == "either" then force (if type.nestedTypes.left.check value then type.nestedTypes.left else type.nestedTypes.right) value else builtins.seq value true; in builtins.seq (force _zenType _zenValue) _zenValue) ((lib.types.addCheck lib.types.unspecified builtins.isFunction)) ((lib.evalModules { modules = [ { options.value = lib.mkOption { type = (lib.types.addCheck lib.types.unspecified builtins.isFunction); }; config.value = (v: (let
  s = (lib.toString v);
in (if ((lib.hasInfix ".") s) then s else "${((value: let kind = builtins.typeOf value; in if kind == "string" then value else if kind == "bool" || kind == "int" || kind == "float" then builtins.toJSON value else if kind == "path" then "${value}" else if kind == "set" && (value.type or null) == "derivation" && builtins.isString (value.outPath or null) then value.outPath else throw "/nix/store/59qqzf108ga8h2qmsjizzsn2p7i889xx-zenpkgs-dsl-source/modules/desktops/gnome/extensions/burn-my-windows.zmdl:21: string interpolation requires a scalar, path, or package") (s))}.0"))); } ]; }).config.value))); serializeIniValue = (builtins.addErrorContext "_let serializeIniValue annotation mismatch: /nix/store/59qqzf108ga8h2qmsjizzsn2p7i889xx-zenpkgs-dsl-source/modules/desktops/gnome/extensions/burn-my-windows.zmdl:22:1" ((_zenType: _zenValue: let force = type: value: if type.name == "anything" then true else if type.name == "listOf" then builtins.all (force type.nestedTypes.elemType) value else if type.name == "attrsOf" then builtins.all (force type.nestedTypes.elemType) (builtins.attrValues value) else if type.name == "either" then force (if type.nestedTypes.left.check value then type.nestedTypes.left else type.nestedTypes.right) value else builtins.seq value true; in builtins.seq (force _zenType _zenValue) _zenValue) ((lib.types.addCheck lib.types.unspecified builtins.isFunction)) ((lib.evalModules { modules = [ { options.value = lib.mkOption { type = (lib.types.addCheck lib.types.unspecified builtins.isFunction); }; config.value = (v: (if (lib.isBool v) then ((if v then "true" else "false")) else (if (lib.isFloat v) then (serializeFloat v) else (lib.toString v)))); } ]; }).config.value))); generateProfileContent = (builtins.addErrorContext "_let generateProfileContent annotation mismatch: /nix/store/59qqzf108ga8h2qmsjizzsn2p7i889xx-zenpkgs-dsl-source/modules/desktops/gnome/extensions/burn-my-windows.zmdl:26:1" ((_zenType: _zenValue: let force = type: value: if type.name == "anything" then true else if type.name == "listOf" then builtins.all (force type.nestedTypes.elemType) value else if type.name == "attrsOf" then builtins.all (force type.nestedTypes.elemType) (builtins.attrValues value) else if type.name == "either" then force (if type.nestedTypes.left.check value then type.nestedTypes.left else type.nestedTypes.right) value else builtins.seq value true; in builtins.seq (force _zenType _zenValue) _zenValue) ((lib.types.addCheck lib.types.unspecified builtins.isFunction)) ((lib.evalModules { modules = [ { options.value = lib.mkOption { type = (lib.types.addCheck lib.types.unspecified builtins.isFunction); }; config.value = (settings: "\n  [burn-my-windows-profile]\n  ${((value: let kind = builtins.typeOf value; in if kind == "string" then value else if kind == "bool" || kind == "int" || kind == "float" then builtins.toJSON value else if kind == "path" then "${value}" else if kind == "set" && (value.type or null) == "derivation" && builtins.isString (value.outPath or null) then value.outPath else throw "/nix/store/59qqzf108ga8h2qmsjizzsn2p7i889xx-zenpkgs-dsl-source/modules/desktops/gnome/extensions/burn-my-windows.zmdl:28: string interpolation requires a scalar, path, or package") (((lib.concatStringsSep "\n") (((lib.mapAttrsToList ((k: (v: "${((value: let kind = builtins.typeOf value; in if kind == "string" then value else if kind == "bool" || kind == "int" || kind == "float" then builtins.toJSON value else if kind == "path" then "${value}" else if kind == "set" && (value.type or null) == "derivation" && builtins.isString (value.outPath or null) then value.outPath else throw "/nix/store/59qqzf108ga8h2qmsjizzsn2p7i889xx-zenpkgs-dsl-source/modules/desktops/gnome/extensions/burn-my-windows.zmdl:28: string interpolation requires a scalar, path, or package") (k))}=${((value: let kind = builtins.typeOf value; in if kind == "string" then value else if kind == "bool" || kind == "int" || kind == "float" then builtins.toJSON value else if kind == "path" then "${value}" else if kind == "set" && (value.type or null) == "derivation" && builtins.isString (value.outPath or null) then value.outPath else throw "/nix/store/59qqzf108ga8h2qmsjizzsn2p7i889xx-zenpkgs-dsl-source/modules/desktops/gnome/extensions/burn-my-windows.zmdl:28: string interpolation requires a scalar, path, or package") ((serializeIniValue v)))}")))) settings)))))}\n"); } ]; }).config.value))); managedProfile = (builtins.addErrorContext "_let managedProfile annotation mismatch: /nix/store/59qqzf108ga8h2qmsjizzsn2p7i889xx-zenpkgs-dsl-source/modules/desktops/gnome/extensions/burn-my-windows.zmdl:30:1" ((_zenType: _zenValue: let force = type: value: if type.name == "anything" then true else if type.name == "listOf" then builtins.all (force type.nestedTypes.elemType) value else if type.name == "attrsOf" then builtins.all (force type.nestedTypes.elemType) (builtins.attrValues value) else if type.name == "either" then force (if type.nestedTypes.left.check value then type.nestedTypes.left else type.nestedTypes.right) value else builtins.seq value true; in builtins.seq (force _zenType _zenValue) _zenValue) (lib.types.package) ((lib.evalModules { modules = [ { options.value = lib.mkOption { type = lib.types.package; }; config.value = ((pkgs.zenos.legacy.writeText "burn-my-windows.conf") ((generateProfileContent cfg.settings))); } ]; }).config.value))); in (lib.mkIf ((cfg.configure)) { home-manager.sharedModules = [ {
      dconf.settings."org/gnome/shell/extensions/burn-my-windows" = {
        active-profile = (if ((cfg.active-profile != "") || (cfg.settings == { })) then cfg.active-profile else "${((value: let kind = builtins.typeOf value; in if kind == "string" then value else if kind == "bool" || kind == "int" || kind == "float" then builtins.toJSON value else if kind == "path" then "${value}" else if kind == "set" && (value.type or null) == "derivation" && builtins.isString (value.outPath or null) then value.outPath else throw "/nix/store/59qqzf108ga8h2qmsjizzsn2p7i889xx-zenpkgs-dsl-source/modules/desktops/gnome/extensions/burn-my-windows.zmdl:48: string interpolation requires a scalar, path, or package") (managedProfile))}");
        preview-effect = cfg.preview-effect;
        test-mode = cfg.test-mode;
        show-support-dialog = cfg.show-support-dialog;
        last-prefs-version = (lib.gvariant.mkInt32 cfg.last-prefs-version);
        last-extension-version = (lib.gvariant.mkInt32 cfg.last-extension-version);
        prefs-open-count = (lib.gvariant.mkInt32 cfg.prefs-open-count);
      };
      xdg.configFile."burn-my-windows/profiles/nix-managed.conf" = ((lib.mkIf ((cfg.settings != { }))) {
        text = (generateProfileContent cfg.settings);
      });
    } ]; }))
  ];
}
