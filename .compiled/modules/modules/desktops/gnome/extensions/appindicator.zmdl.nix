{ config, lib, pkgs, maintainers ? lib.maintainers, licenses ? lib.licenses, ... }:
let
  cfg = config.zenos.desktops.gnome.extensions.appindicator;
  name = "appindicator";
  mkGVariantString = (builtins.addErrorContext "_let mkGVariantString annotation mismatch: /nix/store/3ni594f60hm22hcrazxd35dmk7pwi61m-zenpkgs-dsl-source/modules/desktops/gnome/extensions/appindicator.zmdl:20:1" ((_zenType: _zenValue: let force = type: value: if type.name == "anything" then true else if type.name == "listOf" then builtins.all (force type.nestedTypes.elemType) value else if type.name == "attrsOf" then builtins.all (force type.nestedTypes.elemType) (builtins.attrValues value) else if type.name == "either" then force (if type.nestedTypes.left.check value then type.nestedTypes.left else type.nestedTypes.right) value else builtins.seq value true; in builtins.seq (force _zenType _zenValue) _zenValue) ((lib.types.addCheck lib.types.unspecified builtins.isFunction)) ((lib.evalModules { modules = [ { options.value = lib.mkOption { type = (lib.types.addCheck lib.types.unspecified builtins.isFunction); }; config.value = (v: "'${((value: let kind = builtins.typeOf value; in if kind == "string" then value else if kind == "bool" || kind == "int" || kind == "float" then builtins.toJSON value else if kind == "path" then "${value}" else if kind == "set" && (value.type or null) == "derivation" && builtins.isString (value.outPath or null) then value.outPath else throw "/nix/store/3ni594f60hm22hcrazxd35dmk7pwi61m-zenpkgs-dsl-source/modules/desktops/gnome/extensions/appindicator.zmdl:20: string interpolation requires a scalar, path, or package") (v))}'"); } ]; }).config.value)));
  serializeTuple = (builtins.addErrorContext "_let serializeTuple annotation mismatch: /nix/store/3ni594f60hm22hcrazxd35dmk7pwi61m-zenpkgs-dsl-source/modules/desktops/gnome/extensions/appindicator.zmdl:21:1" ((_zenType: _zenValue: let force = type: value: if type.name == "anything" then true else if type.name == "listOf" then builtins.all (force type.nestedTypes.elemType) value else if type.name == "attrsOf" then builtins.all (force type.nestedTypes.elemType) (builtins.attrValues value) else if type.name == "either" then force (if type.nestedTypes.left.check value then type.nestedTypes.left else type.nestedTypes.right) value else builtins.seq value true; in builtins.seq (force _zenType _zenValue) _zenValue) ((lib.types.addCheck lib.types.unspecified builtins.isFunction)) ((lib.evalModules { modules = [ { options.value = lib.mkOption { type = (lib.types.addCheck lib.types.unspecified builtins.isFunction); }; config.value = (tuple: (((lib.throwIfNot (((lib.length tuple) == 3))) "Custom icon tuple must have exactly 3 strings: [ id icon path ]") "(${((value: let kind = builtins.typeOf value; in if kind == "string" then value else if kind == "bool" || kind == "int" || kind == "float" then builtins.toJSON value else if kind == "path" then "${value}" else if kind == "set" && (value.type or null) == "derivation" && builtins.isString (value.outPath or null) then value.outPath else throw "/nix/store/3ni594f60hm22hcrazxd35dmk7pwi61m-zenpkgs-dsl-source/modules/desktops/gnome/extensions/appindicator.zmdl:24: string interpolation requires a scalar, path, or package") (((lib.concatStringsSep ", ") (((lib.map mkGVariantString) tuple)))))})")); } ]; }).config.value)));
  serializeCustomIcons = (builtins.addErrorContext "_let serializeCustomIcons annotation mismatch: /nix/store/3ni594f60hm22hcrazxd35dmk7pwi61m-zenpkgs-dsl-source/modules/desktops/gnome/extensions/appindicator.zmdl:25:1" ((_zenType: _zenValue: let force = type: value: if type.name == "anything" then true else if type.name == "listOf" then builtins.all (force type.nestedTypes.elemType) value else if type.name == "attrsOf" then builtins.all (force type.nestedTypes.elemType) (builtins.attrValues value) else if type.name == "either" then force (if type.nestedTypes.left.check value then type.nestedTypes.left else type.nestedTypes.right) value else builtins.seq value true; in builtins.seq (force _zenType _zenValue) _zenValue) ((lib.types.addCheck lib.types.unspecified builtins.isFunction)) ((lib.evalModules { modules = [ { options.value = lib.mkOption { type = (lib.types.addCheck lib.types.unspecified builtins.isFunction); }; config.value = (icons: (if (icons == [ ]) then "@a(sss) []" else "[${((value: let kind = builtins.typeOf value; in if kind == "string" then value else if kind == "bool" || kind == "int" || kind == "float" then builtins.toJSON value else if kind == "path" then "${value}" else if kind == "set" && (value.type or null) == "derivation" && builtins.isString (value.outPath or null) then value.outPath else throw "/nix/store/3ni594f60hm22hcrazxd35dmk7pwi61m-zenpkgs-dsl-source/modules/desktops/gnome/extensions/appindicator.zmdl:27: string interpolation requires a scalar, path, or package") (((lib.concatStringsSep ", ") (((lib.map serializeTuple) icons)))))}]")); } ]; }).config.value)));
in
{
  options.zenos.desktops.gnome.extensions.appindicator = lib.mkOption { type = (lib.types.submodule ({ ... }: (let mkGVariantString = (builtins.addErrorContext "_let mkGVariantString annotation mismatch: /nix/store/3ni594f60hm22hcrazxd35dmk7pwi61m-zenpkgs-dsl-source/modules/desktops/gnome/extensions/appindicator.zmdl:20:1" ((_zenType: _zenValue: let force = type: value: if type.name == "anything" then true else if type.name == "listOf" then builtins.all (force type.nestedTypes.elemType) value else if type.name == "attrsOf" then builtins.all (force type.nestedTypes.elemType) (builtins.attrValues value) else if type.name == "either" then force (if type.nestedTypes.left.check value then type.nestedTypes.left else type.nestedTypes.right) value else builtins.seq value true; in builtins.seq (force _zenType _zenValue) _zenValue) ((lib.types.addCheck lib.types.unspecified builtins.isFunction)) ((lib.evalModules { modules = [ { options.value = lib.mkOption { type = (lib.types.addCheck lib.types.unspecified builtins.isFunction); }; config.value = (v: "'${((value: let kind = builtins.typeOf value; in if kind == "string" then value else if kind == "bool" || kind == "int" || kind == "float" then builtins.toJSON value else if kind == "path" then "${value}" else if kind == "set" && (value.type or null) == "derivation" && builtins.isString (value.outPath or null) then value.outPath else throw "/nix/store/3ni594f60hm22hcrazxd35dmk7pwi61m-zenpkgs-dsl-source/modules/desktops/gnome/extensions/appindicator.zmdl:20: string interpolation requires a scalar, path, or package") (v))}'"); } ]; }).config.value))); serializeTuple = (builtins.addErrorContext "_let serializeTuple annotation mismatch: /nix/store/3ni594f60hm22hcrazxd35dmk7pwi61m-zenpkgs-dsl-source/modules/desktops/gnome/extensions/appindicator.zmdl:21:1" ((_zenType: _zenValue: let force = type: value: if type.name == "anything" then true else if type.name == "listOf" then builtins.all (force type.nestedTypes.elemType) value else if type.name == "attrsOf" then builtins.all (force type.nestedTypes.elemType) (builtins.attrValues value) else if type.name == "either" then force (if type.nestedTypes.left.check value then type.nestedTypes.left else type.nestedTypes.right) value else builtins.seq value true; in builtins.seq (force _zenType _zenValue) _zenValue) ((lib.types.addCheck lib.types.unspecified builtins.isFunction)) ((lib.evalModules { modules = [ { options.value = lib.mkOption { type = (lib.types.addCheck lib.types.unspecified builtins.isFunction); }; config.value = (tuple: (((lib.throwIfNot (((lib.length tuple) == 3))) "Custom icon tuple must have exactly 3 strings: [ id icon path ]") "(${((value: let kind = builtins.typeOf value; in if kind == "string" then value else if kind == "bool" || kind == "int" || kind == "float" then builtins.toJSON value else if kind == "path" then "${value}" else if kind == "set" && (value.type or null) == "derivation" && builtins.isString (value.outPath or null) then value.outPath else throw "/nix/store/3ni594f60hm22hcrazxd35dmk7pwi61m-zenpkgs-dsl-source/modules/desktops/gnome/extensions/appindicator.zmdl:24: string interpolation requires a scalar, path, or package") (((lib.concatStringsSep ", ") (((lib.map mkGVariantString) tuple)))))})")); } ]; }).config.value))); serializeCustomIcons = (builtins.addErrorContext "_let serializeCustomIcons annotation mismatch: /nix/store/3ni594f60hm22hcrazxd35dmk7pwi61m-zenpkgs-dsl-source/modules/desktops/gnome/extensions/appindicator.zmdl:25:1" ((_zenType: _zenValue: let force = type: value: if type.name == "anything" then true else if type.name == "listOf" then builtins.all (force type.nestedTypes.elemType) value else if type.name == "attrsOf" then builtins.all (force type.nestedTypes.elemType) (builtins.attrValues value) else if type.name == "either" then force (if type.nestedTypes.left.check value then type.nestedTypes.left else type.nestedTypes.right) value else builtins.seq value true; in builtins.seq (force _zenType _zenValue) _zenValue) ((lib.types.addCheck lib.types.unspecified builtins.isFunction)) ((lib.evalModules { modules = [ { options.value = lib.mkOption { type = (lib.types.addCheck lib.types.unspecified builtins.isFunction); }; config.value = (icons: (if (icons == [ ]) then "@a(sss) []" else "[${((value: let kind = builtins.typeOf value; in if kind == "string" then value else if kind == "bool" || kind == "int" || kind == "float" then builtins.toJSON value else if kind == "path" then "${value}" else if kind == "set" && (value.type or null) == "derivation" && builtins.isString (value.outPath or null) then value.outPath else throw "/nix/store/3ni594f60hm22hcrazxd35dmk7pwi61m-zenpkgs-dsl-source/modules/desktops/gnome/extensions/appindicator.zmdl:27: string interpolation requires a scalar, path, or package") (((lib.concatStringsSep ", ") (((lib.map serializeTuple) icons)))))}]")); } ]; }).config.value))); in { options = { custom-icons = lib.mkOption { type = (lib.types.listOf (lib.types.listOf lib.types.str)); default = [ ]; description = "\n      Custom icon overrides\n\n      List of [id, icon, path] tuples to manually override application icons.\n    "; example = [
  [
    "skype"
    "skype-icon"
    "/path/to/icon.png"
  ]
]; }; enable = lib.mkOption { type = lib.types.bool; default = false; description = "Whether to enable AppIndicator GNOME extension configuration."; }; icon-brightness = lib.mkOption { type = lib.types.float; default = 0.0; description = "\n  Visual brightness of tray icons\n\n  Adjustment level for the brightness of displayed icons.\n"; }; icon-contrast = lib.mkOption { type = lib.types.float; default = 0.0; description = "\n  Visual contrast of tray icons\n\n  Adjustment level for the contrast of displayed icons.\n"; }; icon-opacity = lib.mkOption { type = lib.types.int; default = 240; description = "\n  Alpha transparency of tray icons\n\n  Opacity level from 0 to 255 for icons in the top bar.\n"; }; icon-saturation = lib.mkOption { type = lib.types.float; default = 0.0; description = "\n  Visual saturation of tray icons\n\n  Adjustment level for the color saturation of displayed icons.\n"; }; icon-size = lib.mkOption { type = lib.types.int; default = 0; description = "\n  Fixed size for tray icons\n\n  Icon size in pixels. A value of 0 triggers automatic sizing.\n"; }; icon-spacing = lib.mkOption { type = lib.types.int; default = 12; description = "\n  Horizontal spacing between icons\n\n  Pixel distance between individual status icons within the tray area.\n"; }; legacy-tray-enabled = lib.mkOption { type = lib.types.bool; default = true; description = "\n  Enable legacy tray icon support\n\n  Whether to support older application status icons in the top bar.\n"; }; tray-order = lib.mkOption { type = lib.types.int; default = 1; description = "\n  Ordering index in the panel\n\n  Relative order for placement among other panel items.\n"; }; tray-pos = lib.mkOption { type = lib.types.str; default = "right"; description = "\n  Vertical alignment in the panel\n\n  Panel box position for the tray icons (e.g., 'left', 'right').\n"; }; }; }))); default = { }; };
  config = lib.mkMerge [
    { _module.args.zenlang.descriptors.desktops.gnome.extensions.appindicator = {
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
            value = "\n    System tray icon support for the GNOME top bar\n\n    This module installs and configures the **AppIndicator and KStatusNotifierItem Support** extension for GNOME. It re-enables the system tray, allowing applications to\n    display icons and menus in the top bar.\n\n    **Features:**\n    - Restores legacy tray icon support.\n    - Customizable icon appearance (saturation, brightness, opacity).\n    - Configurable tray positioning.\n  ";
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
            value = "System tray icon support for the GNOME top bar";
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
    moduleIdentity = "zenos.desktops.gnome.extensions.appindicator";
    modulePath = [
      "desktops"
      "gnome"
      "extensions"
      "appindicator"
    ];
    nodeMetadata = [
      {
        metadata = {
          description = {
            multiline = true;
            parts = [
              {
                type = "text";
                value = "\n    System tray icon support for the GNOME top bar\n\n    This module installs and configures the **AppIndicator and KStatusNotifierItem Support** extension for GNOME. It re-enables the system tray, allowing applications to\n    display icons and menus in the top bar.\n\n    **Features:**\n    - Restores legacy tray icon support.\n    - Customizable icon appearance (saturation, brightness, opacity).\n    - Configurable tray positioning.\n  ";
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
                value = "System tray icon support for the GNOME top bar";
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
                value = "Whether to enable AppIndicator GNOME extension configuration.";
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
                value = "\n  Enable legacy tray icon support\n\n  Whether to support older application status icons in the top bar.\n";
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
          "legacy-tray-enabled"
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
                value = "\n  Visual saturation of tray icons\n\n  Adjustment level for the color saturation of displayed icons.\n";
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
          "icon-saturation"
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
                value = "\n  Visual brightness of tray icons\n\n  Adjustment level for the brightness of displayed icons.\n";
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
          "icon-brightness"
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
                value = "\n  Visual contrast of tray icons\n\n  Adjustment level for the contrast of displayed icons.\n";
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
          "icon-contrast"
        ];
      }
      {
        metadata = {
          default = {
            kind = "integer";
            type = "literal";
            value = 240;
          };
          description = {
            multiline = true;
            parts = [
              {
                type = "text";
                value = "\n  Alpha transparency of tray icons\n\n  Opacity level from 0 to 255 for icons in the top bar.\n";
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
          "icon-opacity"
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
                value = "\n  Fixed size for tray icons\n\n  Icon size in pixels. A value of 0 triggers automatic sizing.\n";
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
          "icon-size"
        ];
      }
      {
        metadata = {
          default = {
            kind = "integer";
            type = "literal";
            value = 12;
          };
          description = {
            multiline = true;
            parts = [
              {
                type = "text";
                value = "\n  Horizontal spacing between icons\n\n  Pixel distance between individual status icons within the tray area.\n";
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
          "icon-spacing"
        ];
      }
      {
        metadata = {
          default = {
            multiline = false;
            parts = [
              {
                type = "text";
                value = "right";
              }
            ];
            type = "string";
          };
          description = {
            multiline = true;
            parts = [
              {
                type = "text";
                value = "\n  Vertical alignment in the panel\n\n  Panel box position for the tray icons (e.g., 'left', 'right').\n";
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
          "tray-pos"
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
                value = "\n  Ordering index in the panel\n\n  Relative order for placement among other panel items.\n";
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
          "tray-order"
        ];
      }
      {
        metadata = {
          default = {
            items = [ ];
            type = "list";
          };
          description = {
            multiline = true;
            parts = [
              {
                type = "text";
                value = "\n      Custom icon overrides\n\n      List of [id, icon, path] tuples to manually override application icons.\n    ";
              }
            ];
            type = "string";
          };
          example = {
            items = [
              {
                items = [
                  {
                    multiline = false;
                    parts = [
                      {
                        type = "text";
                        value = "skype";
                      }
                    ];
                    type = "string";
                  }
                  {
                    multiline = false;
                    parts = [
                      {
                        type = "text";
                        value = "skype-icon";
                      }
                    ];
                    type = "string";
                  }
                  {
                    multiline = false;
                    parts = [
                      {
                        type = "text";
                        value = "/path/to/icon.png";
                      }
                    ];
                    type = "string";
                  }
                ];
                type = "list";
              }
            ];
            type = "list";
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
          "custom-icons"
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
                    value = "System tray icon support for the GNOME top bar";
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
                    value = "\n    System tray icon support for the GNOME top bar\n\n    This module installs and configures the **AppIndicator and KStatusNotifierItem Support** extension for GNOME. It re-enables the system tray, allowing applications to\n    display icons and menus in the top bar.\n\n    **Features:**\n    - Restores legacy tray icon support.\n    - Customizable icon appearance (saturation, brightness, opacity).\n    - Configurable tray positioning.\n  ";
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
                  value = "tuple";
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
        name = "serializeTuple";
        type = "let-binding";
        value = {
          body = {
            arguments = [
              {
                multiline = false;
                parts = [
                  {
                    type = "text";
                    value = "(";
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
                                    value = "tuple";
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
                                      value = "mkGVariantString";
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
                    value = ")";
                  }
                ];
                type = "string";
              }
            ];
            callee = {
              arguments = [
                {
                  multiline = false;
                  parts = [
                    {
                      type = "text";
                      value = "Custom icon tuple must have exactly 3 strings: [ id icon path ]";
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
              name = "tuple";
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
                  value = "icons";
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
        name = "serializeCustomIcons";
        type = "let-binding";
        value = {
          body = {
            condition = {
              left = {
                path = [
                  {
                    kind = "identifier";
                    value = "icons";
                  }
                ];
                type = "reference";
              };
              operator = "==";
              right = {
                items = [ ];
                type = "list";
              };
              type = "binary";
            };
            "else" = {
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
                        type = "group";
                        value = {
                          arguments = [
                            {
                              path = [
                                {
                                  kind = "identifier";
                                  value = "icons";
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
                                    value = "serializeTuple";
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
                  value = "]";
                }
              ];
              type = "string";
            };
            "then" = {
              multiline = false;
              parts = [
                {
                  type = "text";
                  value = "@a(sss) []";
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
              name = "icons";
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
                                value = "appindicator";
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
                            value = "Whether to enable AppIndicator GNOME extension configuration.";
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
                                value = "appindicator";
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
                                    value = "org/gnome/shell/extensions/appindicator";
                                  }
                                ];
                                type = "assignment";
                                value = {
                                  recursive = false;
                                  statements = [
                                    {
                                      operator = "=";
                                      target = [
                                        {
                                          kind = "identifier";
                                          value = "legacy-tray-enabled";
                                        }
                                      ];
                                      type = "assignment";
                                      value = {
                                        name = "path";
                                        path = [
                                          {
                                            kind = "identifier";
                                            value = "legacy-tray-enabled";
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
                                          value = "icon-saturation";
                                        }
                                      ];
                                      type = "assignment";
                                      value = {
                                        name = "path";
                                        path = [
                                          {
                                            kind = "identifier";
                                            value = "icon-saturation";
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
                                          value = "icon-brightness";
                                        }
                                      ];
                                      type = "assignment";
                                      value = {
                                        name = "path";
                                        path = [
                                          {
                                            kind = "identifier";
                                            value = "icon-brightness";
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
                                          value = "icon-contrast";
                                        }
                                      ];
                                      type = "assignment";
                                      value = {
                                        name = "path";
                                        path = [
                                          {
                                            kind = "identifier";
                                            value = "icon-contrast";
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
                                          value = "icon-opacity";
                                        }
                                      ];
                                      type = "assignment";
                                      value = {
                                        name = "path";
                                        path = [
                                          {
                                            kind = "identifier";
                                            value = "icon-opacity";
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
                                          value = "icon-size";
                                        }
                                      ];
                                      type = "assignment";
                                      value = {
                                        name = "path";
                                        path = [
                                          {
                                            kind = "identifier";
                                            value = "icon-size";
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
                                          value = "icon-spacing";
                                        }
                                      ];
                                      type = "assignment";
                                      value = {
                                        name = "path";
                                        path = [
                                          {
                                            kind = "identifier";
                                            value = "icon-spacing";
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
                                          value = "tray-pos";
                                        }
                                      ];
                                      type = "assignment";
                                      value = {
                                        name = "path";
                                        path = [
                                          {
                                            kind = "identifier";
                                            value = "tray-pos";
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
                                          value = "tray-order";
                                        }
                                      ];
                                      type = "assignment";
                                      value = {
                                        name = "path";
                                        path = [
                                          {
                                            kind = "identifier";
                                            value = "tray-order";
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
                          value = "appindicator-setup";
                        }
                      ];
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
                                  value = "Apply AppIndicator specific configuration";
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
                                  value = "\n        ";
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
                                  value = "/bin/dconf write /org/gnome/shell/extensions/appindicator/custom-icons ";
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
                                                  value = "custom-icons";
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
                                                value = "serializeCustomIcons";
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
                                  value = "\n      ";
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
            value = "legacy-tray-enabled";
          }
        ];
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
                          value = "\n  Enable legacy tray icon support\n\n  Whether to support older application status icons in the top bar.\n";
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
            value = "icon-saturation";
          }
        ];
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
                          value = "\n  Visual saturation of tray icons\n\n  Adjustment level for the color saturation of displayed icons.\n";
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
            value = "icon-brightness";
          }
        ];
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
                          value = "\n  Visual brightness of tray icons\n\n  Adjustment level for the brightness of displayed icons.\n";
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
            value = "icon-contrast";
          }
        ];
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
                          value = "\n  Visual contrast of tray icons\n\n  Adjustment level for the contrast of displayed icons.\n";
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
            value = "icon-opacity";
          }
        ];
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
                      value = 240;
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
                          value = "\n  Alpha transparency of tray icons\n\n  Opacity level from 0 to 255 for icons in the top bar.\n";
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
            value = "icon-size";
          }
        ];
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
                          value = "\n  Fixed size for tray icons\n\n  Icon size in pixels. A value of 0 triggers automatic sizing.\n";
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
            value = "icon-spacing";
          }
        ];
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
                      value = 12;
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
                          value = "\n  Horizontal spacing between icons\n\n  Pixel distance between individual status icons within the tray area.\n";
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
            value = "tray-pos";
          }
        ];
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
                          value = "right";
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
                          value = "\n  Vertical alignment in the panel\n\n  Panel box position for the tray icons (e.g., 'left', 'right').\n";
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
            value = "tray-order";
          }
        ];
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
                          value = "\n  Ordering index in the panel\n\n  Relative order for placement among other panel items.\n";
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
            value = "custom-icons";
          }
        ];
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
                      items = [ ];
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
                          value = "\n      Custom icon overrides\n\n      List of [id, icon, path] tuples to manually override application icons.\n    ";
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
                      items = [
                        {
                          items = [
                            {
                              multiline = false;
                              parts = [
                                {
                                  type = "text";
                                  value = "skype";
                                }
                              ];
                              type = "string";
                            }
                            {
                              multiline = false;
                              parts = [
                                {
                                  type = "text";
                                  value = "skype-icon";
                                }
                              ];
                              type = "string";
                            }
                            {
                              multiline = false;
                              parts = [
                                {
                                  type = "text";
                                  value = "/path/to/icon.png";
                                }
                              ];
                              type = "string";
                            }
                          ];
                          type = "list";
                        }
                      ];
                      type = "list";
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
    (let mkGVariantString = (builtins.addErrorContext "_let mkGVariantString annotation mismatch: /nix/store/3ni594f60hm22hcrazxd35dmk7pwi61m-zenpkgs-dsl-source/modules/desktops/gnome/extensions/appindicator.zmdl:20:1" ((_zenType: _zenValue: let force = type: value: if type.name == "anything" then true else if type.name == "listOf" then builtins.all (force type.nestedTypes.elemType) value else if type.name == "attrsOf" then builtins.all (force type.nestedTypes.elemType) (builtins.attrValues value) else if type.name == "either" then force (if type.nestedTypes.left.check value then type.nestedTypes.left else type.nestedTypes.right) value else builtins.seq value true; in builtins.seq (force _zenType _zenValue) _zenValue) ((lib.types.addCheck lib.types.unspecified builtins.isFunction)) ((lib.evalModules { modules = [ { options.value = lib.mkOption { type = (lib.types.addCheck lib.types.unspecified builtins.isFunction); }; config.value = (v: "'${((value: let kind = builtins.typeOf value; in if kind == "string" then value else if kind == "bool" || kind == "int" || kind == "float" then builtins.toJSON value else if kind == "path" then "${value}" else if kind == "set" && (value.type or null) == "derivation" && builtins.isString (value.outPath or null) then value.outPath else throw "/nix/store/3ni594f60hm22hcrazxd35dmk7pwi61m-zenpkgs-dsl-source/modules/desktops/gnome/extensions/appindicator.zmdl:20: string interpolation requires a scalar, path, or package") (v))}'"); } ]; }).config.value))); serializeTuple = (builtins.addErrorContext "_let serializeTuple annotation mismatch: /nix/store/3ni594f60hm22hcrazxd35dmk7pwi61m-zenpkgs-dsl-source/modules/desktops/gnome/extensions/appindicator.zmdl:21:1" ((_zenType: _zenValue: let force = type: value: if type.name == "anything" then true else if type.name == "listOf" then builtins.all (force type.nestedTypes.elemType) value else if type.name == "attrsOf" then builtins.all (force type.nestedTypes.elemType) (builtins.attrValues value) else if type.name == "either" then force (if type.nestedTypes.left.check value then type.nestedTypes.left else type.nestedTypes.right) value else builtins.seq value true; in builtins.seq (force _zenType _zenValue) _zenValue) ((lib.types.addCheck lib.types.unspecified builtins.isFunction)) ((lib.evalModules { modules = [ { options.value = lib.mkOption { type = (lib.types.addCheck lib.types.unspecified builtins.isFunction); }; config.value = (tuple: (((lib.throwIfNot (((lib.length tuple) == 3))) "Custom icon tuple must have exactly 3 strings: [ id icon path ]") "(${((value: let kind = builtins.typeOf value; in if kind == "string" then value else if kind == "bool" || kind == "int" || kind == "float" then builtins.toJSON value else if kind == "path" then "${value}" else if kind == "set" && (value.type or null) == "derivation" && builtins.isString (value.outPath or null) then value.outPath else throw "/nix/store/3ni594f60hm22hcrazxd35dmk7pwi61m-zenpkgs-dsl-source/modules/desktops/gnome/extensions/appindicator.zmdl:24: string interpolation requires a scalar, path, or package") (((lib.concatStringsSep ", ") (((lib.map mkGVariantString) tuple)))))})")); } ]; }).config.value))); serializeCustomIcons = (builtins.addErrorContext "_let serializeCustomIcons annotation mismatch: /nix/store/3ni594f60hm22hcrazxd35dmk7pwi61m-zenpkgs-dsl-source/modules/desktops/gnome/extensions/appindicator.zmdl:25:1" ((_zenType: _zenValue: let force = type: value: if type.name == "anything" then true else if type.name == "listOf" then builtins.all (force type.nestedTypes.elemType) value else if type.name == "attrsOf" then builtins.all (force type.nestedTypes.elemType) (builtins.attrValues value) else if type.name == "either" then force (if type.nestedTypes.left.check value then type.nestedTypes.left else type.nestedTypes.right) value else builtins.seq value true; in builtins.seq (force _zenType _zenValue) _zenValue) ((lib.types.addCheck lib.types.unspecified builtins.isFunction)) ((lib.evalModules { modules = [ { options.value = lib.mkOption { type = (lib.types.addCheck lib.types.unspecified builtins.isFunction); }; config.value = (icons: (if (icons == [ ]) then "@a(sss) []" else "[${((value: let kind = builtins.typeOf value; in if kind == "string" then value else if kind == "bool" || kind == "int" || kind == "float" then builtins.toJSON value else if kind == "path" then "${value}" else if kind == "set" && (value.type or null) == "derivation" && builtins.isString (value.outPath or null) then value.outPath else throw "/nix/store/3ni594f60hm22hcrazxd35dmk7pwi61m-zenpkgs-dsl-source/modules/desktops/gnome/extensions/appindicator.zmdl:27: string interpolation requires a scalar, path, or package") (((lib.concatStringsSep ", ") (((lib.map serializeTuple) icons)))))}]")); } ]; }).config.value))); in (lib.mkIf ((cfg.enable)) { home-manager.sharedModules = [ {
      dconf.settings."org/gnome/shell".enabled-extensions = [
        pkgs.zenos.legacy.gnomeExtensions.appindicator.extensionUuid
      ];
    } ]; }))
    (let mkGVariantString = (builtins.addErrorContext "_let mkGVariantString annotation mismatch: /nix/store/3ni594f60hm22hcrazxd35dmk7pwi61m-zenpkgs-dsl-source/modules/desktops/gnome/extensions/appindicator.zmdl:20:1" ((_zenType: _zenValue: let force = type: value: if type.name == "anything" then true else if type.name == "listOf" then builtins.all (force type.nestedTypes.elemType) value else if type.name == "attrsOf" then builtins.all (force type.nestedTypes.elemType) (builtins.attrValues value) else if type.name == "either" then force (if type.nestedTypes.left.check value then type.nestedTypes.left else type.nestedTypes.right) value else builtins.seq value true; in builtins.seq (force _zenType _zenValue) _zenValue) ((lib.types.addCheck lib.types.unspecified builtins.isFunction)) ((lib.evalModules { modules = [ { options.value = lib.mkOption { type = (lib.types.addCheck lib.types.unspecified builtins.isFunction); }; config.value = (v: "'${((value: let kind = builtins.typeOf value; in if kind == "string" then value else if kind == "bool" || kind == "int" || kind == "float" then builtins.toJSON value else if kind == "path" then "${value}" else if kind == "set" && (value.type or null) == "derivation" && builtins.isString (value.outPath or null) then value.outPath else throw "/nix/store/3ni594f60hm22hcrazxd35dmk7pwi61m-zenpkgs-dsl-source/modules/desktops/gnome/extensions/appindicator.zmdl:20: string interpolation requires a scalar, path, or package") (v))}'"); } ]; }).config.value))); serializeTuple = (builtins.addErrorContext "_let serializeTuple annotation mismatch: /nix/store/3ni594f60hm22hcrazxd35dmk7pwi61m-zenpkgs-dsl-source/modules/desktops/gnome/extensions/appindicator.zmdl:21:1" ((_zenType: _zenValue: let force = type: value: if type.name == "anything" then true else if type.name == "listOf" then builtins.all (force type.nestedTypes.elemType) value else if type.name == "attrsOf" then builtins.all (force type.nestedTypes.elemType) (builtins.attrValues value) else if type.name == "either" then force (if type.nestedTypes.left.check value then type.nestedTypes.left else type.nestedTypes.right) value else builtins.seq value true; in builtins.seq (force _zenType _zenValue) _zenValue) ((lib.types.addCheck lib.types.unspecified builtins.isFunction)) ((lib.evalModules { modules = [ { options.value = lib.mkOption { type = (lib.types.addCheck lib.types.unspecified builtins.isFunction); }; config.value = (tuple: (((lib.throwIfNot (((lib.length tuple) == 3))) "Custom icon tuple must have exactly 3 strings: [ id icon path ]") "(${((value: let kind = builtins.typeOf value; in if kind == "string" then value else if kind == "bool" || kind == "int" || kind == "float" then builtins.toJSON value else if kind == "path" then "${value}" else if kind == "set" && (value.type or null) == "derivation" && builtins.isString (value.outPath or null) then value.outPath else throw "/nix/store/3ni594f60hm22hcrazxd35dmk7pwi61m-zenpkgs-dsl-source/modules/desktops/gnome/extensions/appindicator.zmdl:24: string interpolation requires a scalar, path, or package") (((lib.concatStringsSep ", ") (((lib.map mkGVariantString) tuple)))))})")); } ]; }).config.value))); serializeCustomIcons = (builtins.addErrorContext "_let serializeCustomIcons annotation mismatch: /nix/store/3ni594f60hm22hcrazxd35dmk7pwi61m-zenpkgs-dsl-source/modules/desktops/gnome/extensions/appindicator.zmdl:25:1" ((_zenType: _zenValue: let force = type: value: if type.name == "anything" then true else if type.name == "listOf" then builtins.all (force type.nestedTypes.elemType) value else if type.name == "attrsOf" then builtins.all (force type.nestedTypes.elemType) (builtins.attrValues value) else if type.name == "either" then force (if type.nestedTypes.left.check value then type.nestedTypes.left else type.nestedTypes.right) value else builtins.seq value true; in builtins.seq (force _zenType _zenValue) _zenValue) ((lib.types.addCheck lib.types.unspecified builtins.isFunction)) ((lib.evalModules { modules = [ { options.value = lib.mkOption { type = (lib.types.addCheck lib.types.unspecified builtins.isFunction); }; config.value = (icons: (if (icons == [ ]) then "@a(sss) []" else "[${((value: let kind = builtins.typeOf value; in if kind == "string" then value else if kind == "bool" || kind == "int" || kind == "float" then builtins.toJSON value else if kind == "path" then "${value}" else if kind == "set" && (value.type or null) == "derivation" && builtins.isString (value.outPath or null) then value.outPath else throw "/nix/store/3ni594f60hm22hcrazxd35dmk7pwi61m-zenpkgs-dsl-source/modules/desktops/gnome/extensions/appindicator.zmdl:27: string interpolation requires a scalar, path, or package") (((lib.concatStringsSep ", ") (((lib.map serializeTuple) icons)))))}]")); } ]; }).config.value))); in (lib.mkIf ((cfg.enable)) {
      environment.systemPackages = [
        pkgs.zenos.legacy.gnomeExtensions.appindicator
      ];
      programs.dconf.profiles.user.databases = [
        {
          settings."org/gnome/shell/extensions/appindicator" = {
            legacy-tray-enabled = cfg.legacy-tray-enabled;
            icon-saturation = cfg.icon-saturation;
            icon-brightness = cfg.icon-brightness;
            icon-contrast = cfg.icon-contrast;
            icon-opacity = cfg.icon-opacity;
            icon-size = cfg.icon-size;
            icon-spacing = cfg.icon-spacing;
            tray-pos = cfg.tray-pos;
            tray-order = cfg.tray-order;
          };
        }
      ];
      systemd.user.services.appindicator-setup = {
        description = "Apply AppIndicator specific configuration";
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
        script = "\n        ${((value: let kind = builtins.typeOf value; in if kind == "string" then value else if kind == "bool" || kind == "int" || kind == "float" then builtins.toJSON value else if kind == "path" then "${value}" else if kind == "set" && (value.type or null) == "derivation" && builtins.isString (value.outPath or null) then value.outPath else throw "/nix/store/3ni594f60hm22hcrazxd35dmk7pwi61m-zenpkgs-dsl-source/modules/desktops/gnome/extensions/appindicator.zmdl:55: string interpolation requires a scalar, path, or package") (pkgs.zenos.legacy.dconf))}/bin/dconf write /org/gnome/shell/extensions/appindicator/custom-icons ${((value: let kind = builtins.typeOf value; in if kind == "string" then value else if kind == "bool" || kind == "int" || kind == "float" then builtins.toJSON value else if kind == "path" then "${value}" else if kind == "set" && (value.type or null) == "derivation" && builtins.isString (value.outPath or null) then value.outPath else throw "/nix/store/3ni594f60hm22hcrazxd35dmk7pwi61m-zenpkgs-dsl-source/modules/desktops/gnome/extensions/appindicator.zmdl:55: string interpolation requires a scalar, path, or package") ((lib.escapeShellArg ((serializeCustomIcons cfg.custom-icons)))))}\n      ";
      };
    }))
  ];
}
