{ config, lib, pkgs, maintainers ? lib.maintainers, licenses ? lib.licenses, ... }:
let
  cfg = config.zenos.desktops.gnome.extensions.rounded-window-corners-reborn;
  name = "rounded-window-corners-reborn";
  toRgbaList = (builtins.addErrorContext "_let toRgbaList annotation mismatch: /nix/store/59qqzf108ga8h2qmsjizzsn2p7i889xx-zenpkgs-dsl-source/modules/desktops/gnome/extensions/rounded-window-corners-reborn.zmdl:25:1" ((_zenType: _zenValue: let force = type: value: if type.name == "anything" then true else if type.name == "listOf" then builtins.all (force type.nestedTypes.elemType) value else if type.name == "attrsOf" then builtins.all (force type.nestedTypes.elemType) (builtins.attrValues value) else if type.name == "either" then force (if type.nestedTypes.left.check value then type.nestedTypes.left else type.nestedTypes.right) value else builtins.seq value true; in builtins.seq (force _zenType _zenValue) _zenValue) ((lib.types.addCheck lib.types.unspecified builtins.isFunction)) ((lib.evalModules { modules = [ { options.value = lib.mkOption { type = (lib.types.addCheck lib.types.unspecified builtins.isFunction); }; config.value = (value: (if ((lib.isString value) && ((lib.hasPrefix "#") value)) then (let
    hex = ((lib.removePrefix "#") value);
    red = (((lib.fromHexString ((((lib.substring 0) 2) hex)))) / 255.0);
    green = (((lib.fromHexString ((((lib.substring 2) 2) hex)))) / 255.0);
    blue = (((lib.fromHexString ((((lib.substring 4) 2) hex)))) / 255.0);
    alpha = (if ((lib.stringLength hex) == 8) then (((lib.fromHexString ((((lib.substring 6) 2) hex)))) / 255.0) else 1.0);
  in [
    red
    green
    blue
    alpha
  ]) else value)); } ]; }).config.value)));
  toVariant = (builtins.addErrorContext "_let toVariant annotation mismatch: /nix/store/59qqzf108ga8h2qmsjizzsn2p7i889xx-zenpkgs-dsl-source/modules/desktops/gnome/extensions/rounded-window-corners-reborn.zmdl:37:1" ((_zenType: _zenValue: let force = type: value: if type.name == "anything" then true else if type.name == "listOf" then builtins.all (force type.nestedTypes.elemType) value else if type.name == "attrsOf" then builtins.all (force type.nestedTypes.elemType) (builtins.attrValues value) else if type.name == "either" then force (if type.nestedTypes.left.check value then type.nestedTypes.left else type.nestedTypes.right) value else builtins.seq value true; in builtins.seq (force _zenType _zenValue) _zenValue) ((lib.types.addCheck lib.types.unspecified builtins.isFunction)) ((lib.evalModules { modules = [ { options.value = lib.mkOption { type = (lib.types.addCheck lib.types.unspecified builtins.isFunction); }; config.value = (let
    convert = (value: (if ((lib.isAttrs value) && (!((lib.gvariant.isGVariant value)))) then (if (value == { }) then (lib.gvariant.mkEmptyArray "{sv}") else (lib.gvariant.mkArray (((lib.mapAttrsToList ((key: (item: ((lib.gvariant.mkDictionaryEntry key) ((lib.gvariant.mkVariant ((convert item))))))))) value)))) else (if (lib.isInt value) then (lib.gvariant.mkInt32 value) else (lib.gvariant.mkValue value))));
  in convert); } ]; }).config.value)));
  shadow = (builtins.addErrorContext "_let shadow annotation mismatch: /nix/store/59qqzf108ga8h2qmsjizzsn2p7i889xx-zenpkgs-dsl-source/modules/desktops/gnome/extensions/rounded-window-corners-reborn.zmdl:47:1" ((_zenType: _zenValue: let force = type: value: if type.name == "anything" then true else if type.name == "listOf" then builtins.all (force type.nestedTypes.elemType) value else if type.name == "attrsOf" then builtins.all (force type.nestedTypes.elemType) (builtins.attrValues value) else if type.name == "either" then force (if type.nestedTypes.left.check value then type.nestedTypes.left else type.nestedTypes.right) value else builtins.seq value true; in builtins.seq (force _zenType _zenValue) _zenValue) ((lib.types.addCheck lib.types.unspecified builtins.isFunction)) ((lib.evalModules { modules = [ { options.value = lib.mkOption { type = (lib.types.addCheck lib.types.unspecified builtins.isFunction); }; config.value = (json: (lib.gvariant.mkArray (((lib.mapAttrsToList ((key: (value: ((lib.gvariant.mkDictionaryEntry key) ((lib.gvariant.mkInt32 value))))))) ((lib.fromJSON json)))))); } ]; }).config.value)));
in
{
  options.zenos.desktops.gnome.extensions.rounded-window-corners-reborn = lib.mkOption { type = (lib.types.submodule ({ ... }: (let toRgbaList = (builtins.addErrorContext "_let toRgbaList annotation mismatch: /nix/store/59qqzf108ga8h2qmsjizzsn2p7i889xx-zenpkgs-dsl-source/modules/desktops/gnome/extensions/rounded-window-corners-reborn.zmdl:25:1" ((_zenType: _zenValue: let force = type: value: if type.name == "anything" then true else if type.name == "listOf" then builtins.all (force type.nestedTypes.elemType) value else if type.name == "attrsOf" then builtins.all (force type.nestedTypes.elemType) (builtins.attrValues value) else if type.name == "either" then force (if type.nestedTypes.left.check value then type.nestedTypes.left else type.nestedTypes.right) value else builtins.seq value true; in builtins.seq (force _zenType _zenValue) _zenValue) ((lib.types.addCheck lib.types.unspecified builtins.isFunction)) ((lib.evalModules { modules = [ { options.value = lib.mkOption { type = (lib.types.addCheck lib.types.unspecified builtins.isFunction); }; config.value = (value: (if ((lib.isString value) && ((lib.hasPrefix "#") value)) then (let
        hex = ((lib.removePrefix "#") value);
        red = (((lib.fromHexString ((((lib.substring 0) 2) hex)))) / 255.0);
        green = (((lib.fromHexString ((((lib.substring 2) 2) hex)))) / 255.0);
        blue = (((lib.fromHexString ((((lib.substring 4) 2) hex)))) / 255.0);
        alpha = (if ((lib.stringLength hex) == 8) then (((lib.fromHexString ((((lib.substring 6) 2) hex)))) / 255.0) else 1.0);
      in [
        red
        green
        blue
        alpha
      ]) else value)); } ]; }).config.value))); toVariant = (builtins.addErrorContext "_let toVariant annotation mismatch: /nix/store/59qqzf108ga8h2qmsjizzsn2p7i889xx-zenpkgs-dsl-source/modules/desktops/gnome/extensions/rounded-window-corners-reborn.zmdl:37:1" ((_zenType: _zenValue: let force = type: value: if type.name == "anything" then true else if type.name == "listOf" then builtins.all (force type.nestedTypes.elemType) value else if type.name == "attrsOf" then builtins.all (force type.nestedTypes.elemType) (builtins.attrValues value) else if type.name == "either" then force (if type.nestedTypes.left.check value then type.nestedTypes.left else type.nestedTypes.right) value else builtins.seq value true; in builtins.seq (force _zenType _zenValue) _zenValue) ((lib.types.addCheck lib.types.unspecified builtins.isFunction)) ((lib.evalModules { modules = [ { options.value = lib.mkOption { type = (lib.types.addCheck lib.types.unspecified builtins.isFunction); }; config.value = (let
        convert = (value: (if ((lib.isAttrs value) && (!((lib.gvariant.isGVariant value)))) then (if (value == { }) then (lib.gvariant.mkEmptyArray "{sv}") else (lib.gvariant.mkArray (((lib.mapAttrsToList ((key: (item: ((lib.gvariant.mkDictionaryEntry key) ((lib.gvariant.mkVariant ((convert item))))))))) value)))) else (if (lib.isInt value) then (lib.gvariant.mkInt32 value) else (lib.gvariant.mkValue value))));
      in convert); } ]; }).config.value))); shadow = (builtins.addErrorContext "_let shadow annotation mismatch: /nix/store/59qqzf108ga8h2qmsjizzsn2p7i889xx-zenpkgs-dsl-source/modules/desktops/gnome/extensions/rounded-window-corners-reborn.zmdl:47:1" ((_zenType: _zenValue: let force = type: value: if type.name == "anything" then true else if type.name == "listOf" then builtins.all (force type.nestedTypes.elemType) value else if type.name == "attrsOf" then builtins.all (force type.nestedTypes.elemType) (builtins.attrValues value) else if type.name == "either" then force (if type.nestedTypes.left.check value then type.nestedTypes.left else type.nestedTypes.right) value else builtins.seq value true; in builtins.seq (force _zenType _zenValue) _zenValue) ((lib.types.addCheck lib.types.unspecified builtins.isFunction)) ((lib.evalModules { modules = [ { options.value = lib.mkOption { type = (lib.types.addCheck lib.types.unspecified builtins.isFunction); }; config.value = (json: (lib.gvariant.mkArray (((lib.mapAttrsToList ((key: (value: ((lib.gvariant.mkDictionaryEntry key) ((lib.gvariant.mkInt32 value))))))) ((lib.fromJSON json)))))); } ]; }).config.value))); in { options = { custom-settings = lib.mkOption { type = (lib.types.attrsOf lib.types.attrs); default = { }; description = "\n      Per-application visual overrides\n\n      Dictionary mapping application IDs to specific rounding\n      and border configurations.\n    "; }; enable = lib.mkOption { type = lib.types.bool; default = false; description = "Rounded Window Corners Reborn configuration"; }; focused-shadow = lib.mkOption { type = lib.types.str; default = "{}"; description = "JSON configuration for active window drop shadows"; }; general = lib.mkOption { type = (lib.types.submodule ({ ... }: { options = { debug = lib.mkOption { type = lib.types.bool; default = false; description = "Enable verbose console debugging"; }; preferences-entry = lib.mkOption { type = lib.types.bool; default = true; description = "Display extension settings in the app grid"; }; settings-version = lib.mkOption { type = lib.types.int; default = 7; description = "Version of the rounded-corner settings schema"; }; tweak-kitty = lib.mkOption { type = lib.types.bool; default = false; description = "Enable specialized rendering hacks for Kitty terminal"; }; }; })); default = { }; }; settings = lib.mkOption { type = (lib.types.submodule ({ ... }: { options = { border-color = lib.mkOption { type = (lib.types.either (lib.types.listOf lib.types.float) lib.types.str); default = [
  1.0
  1.0
  1.0
  1.0
]; description = "CSS color for the border"; }; border-radius = lib.mkOption { type = lib.types.int; default = 12; description = "Pixel radius for corner rounding"; }; border-size = lib.mkOption { type = lib.types.int; default = 0; description = "Outer pixel border thickness"; }; keep-rounded-corners = lib.mkOption { type = lib.types.bool; default = false; description = "Preserve rounding for maximized windows"; }; padding = lib.mkOption { type = (lib.types.attrsOf lib.types.int); default = {
  left = 1;
  right = 1;
  top = 1;
  bottom = 1;
}; description = "Internal padding values"; }; smoothing = lib.mkOption { type = lib.types.float; default = 0.0; description = "Curvature smoothing factor (anti-aliasing)"; }; }; })); default = { }; }; skip-libadwaita-app = lib.mkOption { type = lib.types.bool; default = false; description = "\n  Ignore modern Libadwaita applications\n\n  Whether to skip applications that already provide their own\n  native corner rounding.\n"; }; unfocused-shadow = lib.mkOption { type = lib.types.str; default = "{}"; description = "JSON configuration for inactive window drop shadows"; }; }; }))); default = { }; };
  config = lib.mkMerge [
    { _module.args.zenlang.descriptors.desktops.gnome.extensions.rounded-window-corners-reborn = {
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
            value = "\n    Consistent corner rounding for all window types in GNOME\n\n    This module installs and configures **Rounded Window Corners Reborn**. It brings\n    consistent rounded corners to all applications, including legacy GTK3/4\n    and non-GTK windows.\n\n    **Features:**\n    - Global corner rounding with custom radius.\n    - Per-application setting overrides.\n    - Custom shadow and border configurations.\n    - Special tweaks for Kitty terminal compatibility.\n  ";
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
            value = "Consistent corner rounding for all window types in GNOME";
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
    moduleIdentity = "zenos.desktops.gnome.extensions.rounded-window-corners-reborn";
    modulePath = [
      "desktops"
      "gnome"
      "extensions"
      "rounded-window-corners-reborn"
    ];
    nodeMetadata = [
      {
        metadata = {
          description = {
            multiline = true;
            parts = [
              {
                type = "text";
                value = "\n    Consistent corner rounding for all window types in GNOME\n\n    This module installs and configures **Rounded Window Corners Reborn**. It brings\n    consistent rounded corners to all applications, including legacy GTK3/4\n    and non-GTK windows.\n\n    **Features:**\n    - Global corner rounding with custom radius.\n    - Per-application setting overrides.\n    - Custom shadow and border configurations.\n    - Special tweaks for Kitty terminal compatibility.\n  ";
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
                value = "Consistent corner rounding for all window types in GNOME";
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
                value = "Rounded Window Corners Reborn configuration";
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
            kind = "false";
            type = "literal";
            value = false;
          };
          description = {
            multiline = true;
            parts = [
              {
                type = "text";
                value = "\n  Ignore modern Libadwaita applications\n\n  Whether to skip applications that already provide their own\n  native corner rounding.\n";
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
          "skip-libadwaita-app"
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
                value = "JSON configuration for active window drop shadows";
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
          "focused-shadow"
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
                value = "JSON configuration for inactive window drop shadows";
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
          "unfocused-shadow"
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
            kind = "false";
            type = "literal";
            value = false;
          };
          description = {
            multiline = true;
            parts = [
              {
                type = "text";
                value = "Enable verbose console debugging";
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
          "debug"
        ];
      }
      {
        metadata = {
          default = {
            kind = "integer";
            type = "literal";
            value = 7;
          };
          description = {
            multiline = true;
            parts = [
              {
                type = "text";
                value = "Version of the rounded-corner settings schema";
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
          "settings-version"
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
                value = "Enable specialized rendering hacks for Kitty terminal";
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
          "tweak-kitty"
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
                value = "Display extension settings in the app grid";
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
          "preferences-entry"
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
          "settings"
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
                    value = "left";
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
                    value = "right";
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
                    value = "top";
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
                    value = "bottom";
                  }
                ];
                type = "assignment";
                value = {
                  kind = "integer";
                  type = "literal";
                  value = 1;
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
                value = "Internal padding values";
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
          "settings"
          "padding"
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
                value = "Preserve rounding for maximized windows";
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
          "settings"
          "keep-rounded-corners"
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
                value = "Outer pixel border thickness";
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
          "settings"
          "border-size"
        ];
      }
      {
        metadata = {
          default = {
            items = [
              {
                kind = "float";
                type = "literal";
                value = 1.0;
              }
              {
                kind = "float";
                type = "literal";
                value = 1.0;
              }
              {
                kind = "float";
                type = "literal";
                value = 1.0;
              }
              {
                kind = "float";
                type = "literal";
                value = 1.0;
              }
            ];
            type = "list";
          };
          description = {
            multiline = true;
            parts = [
              {
                type = "text";
                value = "CSS color for the border";
              }
            ];
            type = "string";
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
          zenosVersion = {
            kind = "version";
            type = "literal";
            value = "1.0.0Na";
          };
        };
        path = [
          "settings"
          "border-color"
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
                value = "Pixel radius for corner rounding";
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
          "settings"
          "border-radius"
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
                value = "Curvature smoothing factor (anti-aliasing)";
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
          "settings"
          "smoothing"
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
                value = "\n      Per-application visual overrides\n\n      Dictionary mapping application IDs to specific rounding\n      and border configurations.\n    ";
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
                        value = "set";
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
          "custom-settings"
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
                    value = "Consistent corner rounding for all window types in GNOME";
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
                    value = "\n    Consistent corner rounding for all window types in GNOME\n\n    This module installs and configures **Rounded Window Corners Reborn**. It brings\n    consistent rounded corners to all applications, including legacy GTK3/4\n    and non-GTK windows.\n\n    **Features:**\n    - Global corner rounding with custom radius.\n    - Per-application setting overrides.\n    - Custom shadow and border configurations.\n    - Special tweaks for Kitty terminal compatibility.\n  ";
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
                value = "function";
              }
            ];
            type = "variable";
          };
          type = "call";
        };
        name = "toRgbaList";
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
                items = [
                  {
                    path = [
                      {
                        kind = "identifier";
                        value = "red";
                      }
                    ];
                    type = "reference";
                  }
                  {
                    path = [
                      {
                        kind = "identifier";
                        value = "green";
                      }
                    ];
                    type = "reference";
                  }
                  {
                    path = [
                      {
                        kind = "identifier";
                        value = "blue";
                      }
                    ];
                    type = "reference";
                  }
                  {
                    path = [
                      {
                        kind = "identifier";
                        value = "alpha";
                      }
                    ];
                    type = "reference";
                  }
                ];
                type = "list";
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
                      value = "red";
                    }
                  ];
                  type = "assignment";
                  value = {
                    left = {
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
                          name = "lib";
                          path = [
                            {
                              kind = "identifier";
                              value = "fromHexString";
                            }
                          ];
                          type = "variable";
                        };
                        type = "call";
                      };
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
                {
                  operator = "=";
                  target = [
                    {
                      kind = "identifier";
                      value = "green";
                    }
                  ];
                  type = "assignment";
                  value = {
                    left = {
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
                          name = "lib";
                          path = [
                            {
                              kind = "identifier";
                              value = "fromHexString";
                            }
                          ];
                          type = "variable";
                        };
                        type = "call";
                      };
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
                {
                  operator = "=";
                  target = [
                    {
                      kind = "identifier";
                      value = "blue";
                    }
                  ];
                  type = "assignment";
                  value = {
                    left = {
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
                          name = "lib";
                          path = [
                            {
                              kind = "identifier";
                              value = "fromHexString";
                            }
                          ];
                          type = "variable";
                        };
                        type = "call";
                      };
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
                {
                  operator = "=";
                  target = [
                    {
                      kind = "identifier";
                      value = "alpha";
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
                      kind = "float";
                      type = "literal";
                      value = 1.0;
                    };
                    "then" = {
                      left = {
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
                            name = "lib";
                            path = [
                              {
                                kind = "identifier";
                                value = "fromHexString";
                              }
                            ];
                            type = "variable";
                          };
                          type = "call";
                        };
                      };
                      operator = "/";
                      right = {
                        kind = "float";
                        type = "literal";
                        value = 255.0;
                      };
                      type = "binary";
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
        name = "toVariant";
        type = "let-binding";
        value = {
          body = {
            path = [
              {
                kind = "identifier";
                value = "convert";
              }
            ];
            type = "reference";
          };
          statements = [
            {
              operator = "=";
              target = [
                {
                  kind = "identifier";
                  value = "convert";
                }
              ];
              type = "assignment";
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
                            value = "isAttrs";
                          }
                        ];
                        type = "variable";
                      };
                      type = "call";
                    };
                    operator = "&&";
                    right = {
                      operand = {
                        type = "group";
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
                                value = "gvariant";
                              }
                              {
                                kind = "identifier";
                                value = "isGVariant";
                              }
                            ];
                            type = "variable";
                          };
                          type = "call";
                        };
                      };
                      operator = "!";
                      type = "unary";
                    };
                    type = "binary";
                  };
                  "else" = {
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
                            value = "isInt";
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
                            value = "gvariant";
                          }
                          {
                            kind = "identifier";
                            value = "mkValue";
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
                    type = "if";
                  };
                  "then" = {
                    condition = {
                      left = {
                        path = [
                          {
                            kind = "identifier";
                            value = "value";
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
                      arguments = [
                        {
                          type = "group";
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
                                  type = "group";
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
                                                        path = [
                                                          {
                                                            kind = "identifier";
                                                            value = "item";
                                                          }
                                                        ];
                                                        type = "reference";
                                                      }
                                                    ];
                                                    callee = {
                                                      path = [
                                                        {
                                                          kind = "identifier";
                                                          value = "convert";
                                                        }
                                                      ];
                                                      type = "reference";
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
                                                    value = "mkVariant";
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
                                              path = [
                                                {
                                                  kind = "identifier";
                                                  value = "key";
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
                                                value = "gvariant";
                                              }
                                              {
                                                kind = "identifier";
                                                value = "mkDictionaryEntry";
                                              }
                                            ];
                                            type = "variable";
                                          };
                                          type = "call";
                                        };
                                        type = "call";
                                      };
                                      form = "identifier";
                                      parameters = [
                                        {
                                          default = null;
                                          name = "item";
                                          variadic = false;
                                        }
                                      ];
                                      type = "lambda";
                                    };
                                    form = "identifier";
                                    parameters = [
                                      {
                                        default = null;
                                        name = "key";
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
                        name = "lib";
                        path = [
                          {
                            kind = "identifier";
                            value = "gvariant";
                          }
                          {
                            kind = "identifier";
                            value = "mkArray";
                          }
                        ];
                        type = "variable";
                      };
                      type = "call";
                    };
                    "then" = {
                      arguments = [
                        {
                          multiline = false;
                          parts = [
                            {
                              type = "text";
                              value = "{sv}";
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
                            value = "gvariant";
                          }
                          {
                            kind = "identifier";
                            value = "mkEmptyArray";
                          }
                        ];
                        type = "variable";
                      };
                      type = "call";
                    };
                    type = "if";
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
          ];
          type = "let";
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
                  value = "json";
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
        name = "shadow";
        type = "let-binding";
        value = {
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
                            path = [
                              {
                                kind = "identifier";
                                value = "json";
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
                        type = "group";
                        value = {
                          body = {
                            body = {
                              arguments = [
                                {
                                  type = "group";
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
                              callee = {
                                arguments = [
                                  {
                                    path = [
                                      {
                                        kind = "identifier";
                                        value = "key";
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
                                      value = "gvariant";
                                    }
                                    {
                                      kind = "identifier";
                                      value = "mkDictionaryEntry";
                                    }
                                  ];
                                  type = "variable";
                                };
                                type = "call";
                              };
                              type = "call";
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
                          form = "identifier";
                          parameters = [
                            {
                              default = null;
                              name = "key";
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
              name = "lib";
              path = [
                {
                  kind = "identifier";
                  value = "gvariant";
                }
                {
                  kind = "identifier";
                  value = "mkArray";
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
              name = "json";
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
                            value = "Rounded Window Corners Reborn configuration";
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
                                value = "rounded-window-corners-reborn";
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
                                value = "rounded-window-corners-reborn";
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
                          value = "org/gnome/shell/extensions/rounded-window-corners-reborn";
                        }
                      ];
                      type = "assignment";
                      value = {
                        left = {
                          left = {
                            recursive = false;
                            statements = [
                              {
                                operator = "=";
                                target = [
                                  {
                                    kind = "identifier";
                                    value = "border-width";
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
                                        {
                                          kind = "identifier";
                                          value = "border-size";
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
                                    value = "settings-version";
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
                                          value = "settings-version";
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
                                    value = "skip-libadwaita-app";
                                  }
                                ];
                                type = "assignment";
                                value = {
                                  name = "path";
                                  path = [
                                    {
                                      kind = "identifier";
                                      value = "skip-libadwaita-app";
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
                                    value = "debug-mode";
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
                                      value = "debug";
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
                                    value = "tweak-kitty-terminal";
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
                                      value = "tweak-kitty";
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
                                    value = "global-rounded-corner-settings";
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
                                              value = "padding";
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
                                                  {
                                                    kind = "identifier";
                                                    value = "padding";
                                                  }
                                                ];
                                                type = "variable";
                                              }
                                            ];
                                            callee = {
                                              arguments = [
                                                {
                                                  type = "group";
                                                  value = {
                                                    body = {
                                                      body = {
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
                                                    form = "identifier";
                                                    parameters = [
                                                      {
                                                        default = null;
                                                        name = "_";
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
                                                    value = "mapAttrs";
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
                                              value = "keepRoundedCorners";
                                            }
                                          ];
                                          type = "assignment";
                                          value = {
                                            recursive = false;
                                            statements = [
                                              {
                                                operator = "=";
                                                target = [
                                                  {
                                                    kind = "identifier";
                                                    value = "maximized";
                                                  }
                                                ];
                                                type = "assignment";
                                                value = {
                                                  name = "path";
                                                  path = [
                                                    {
                                                      kind = "identifier";
                                                      value = "settings";
                                                    }
                                                    {
                                                      kind = "identifier";
                                                      value = "keep-rounded-corners";
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
                                                    value = "fullscreen";
                                                  }
                                                ];
                                                type = "assignment";
                                                value = {
                                                  name = "path";
                                                  path = [
                                                    {
                                                      kind = "identifier";
                                                      value = "settings";
                                                    }
                                                    {
                                                      kind = "identifier";
                                                      value = "keep-rounded-corners";
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
                                          operator = "=";
                                          target = [
                                            {
                                              kind = "identifier";
                                              value = "borderRadius";
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
                                                  {
                                                    kind = "identifier";
                                                    value = "border-radius";
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
                                              value = "smoothing";
                                            }
                                          ];
                                          type = "assignment";
                                          value = {
                                            name = "path";
                                            path = [
                                              {
                                                kind = "identifier";
                                                value = "settings";
                                              }
                                              {
                                                kind = "identifier";
                                                value = "smoothing";
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
                                              value = "borderColor";
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
                                                  {
                                                    kind = "identifier";
                                                    value = "border-color";
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
                                                  value = "toRgbaList";
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
                                              value = "enabled";
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
                                    }
                                  ];
                                  callee = {
                                    name = "v";
                                    path = [
                                      {
                                        kind = "identifier";
                                        value = "toVariant";
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
                                    value = "custom-rounded-corner-settings";
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
                                          value = "custom-settings";
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
                                        value = "toVariant";
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
                          operator = "//";
                          right = {
                            type = "group";
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
                                          value = "focused-shadow";
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
                                                value = "focused-shadow";
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
                                              value = "shadow";
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
                                            value = "focused-shadow";
                                          }
                                        ];
                                        type = "variable";
                                      };
                                      operator = "!=";
                                      right = {
                                        multiline = false;
                                        parts = [
                                          {
                                            type = "text";
                                            value = "{}";
                                          }
                                        ];
                                        type = "string";
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
                                      value = "optionalAttrs";
                                    }
                                  ];
                                  type = "variable";
                                };
                                type = "call";
                              };
                              type = "call";
                            };
                          };
                          type = "binary";
                        };
                        operator = "//";
                        right = {
                          type = "group";
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
                                        value = "unfocused-shadow";
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
                                              value = "unfocused-shadow";
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
                                            value = "shadow";
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
                                          value = "unfocused-shadow";
                                        }
                                      ];
                                      type = "variable";
                                    };
                                    operator = "!=";
                                    right = {
                                      multiline = false;
                                      parts = [
                                        {
                                          type = "text";
                                          value = "{}";
                                        }
                                      ];
                                      type = "string";
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
                                    value = "optionalAttrs";
                                  }
                                ];
                                type = "variable";
                              };
                              type = "call";
                            };
                            type = "call";
                          };
                        };
                        type = "binary";
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
            value = "skip-libadwaita-app";
          }
        ];
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
                          value = "\n  Ignore modern Libadwaita applications\n\n  Whether to skip applications that already provide their own\n  native corner rounding.\n";
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
            value = "focused-shadow";
          }
        ];
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
                          value = "JSON configuration for active window drop shadows";
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
            value = "unfocused-shadow";
          }
        ];
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
                          value = "JSON configuration for inactive window drop shadows";
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
                  value = "debug";
                }
              ];
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
                                value = "Enable verbose console debugging";
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
                  value = "settings-version";
                }
              ];
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
                            value = 7;
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
                                value = "Version of the rounded-corner settings schema";
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
                  value = "tweak-kitty";
                }
              ];
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
                                value = "Enable specialized rendering hacks for Kitty terminal";
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
                  value = "preferences-entry";
                }
              ];
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
                                value = "Display extension settings in the app grid";
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
                  value = "padding";
                }
              ];
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
                                    value = "left";
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
                                    value = "right";
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
                                    value = "top";
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
                                    value = "bottom";
                                  }
                                ];
                                type = "assignment";
                                value = {
                                  kind = "integer";
                                  type = "literal";
                                  value = 1;
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
                                value = "Internal padding values";
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
                  value = "keep-rounded-corners";
                }
              ];
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
                                value = "Preserve rounding for maximized windows";
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
                  value = "border-size";
                }
              ];
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
                                value = "Outer pixel border thickness";
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
                  value = "border-color";
                }
              ];
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
                                kind = "float";
                                type = "literal";
                                value = 1.0;
                              }
                              {
                                kind = "float";
                                type = "literal";
                                value = 1.0;
                              }
                              {
                                kind = "float";
                                type = "literal";
                                value = 1.0;
                              }
                              {
                                kind = "float";
                                type = "literal";
                                value = 1.0;
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
                                value = "CSS color for the border";
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
                  value = "border-radius";
                }
              ];
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
                                value = "Pixel radius for corner rounding";
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
                  value = "smoothing";
                }
              ];
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
                                value = "Curvature smoothing factor (anti-aliasing)";
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
            value = "custom-settings";
          }
        ];
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
                                  value = "set";
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
                          value = "\n      Per-application visual overrides\n\n      Dictionary mapping application IDs to specific rounding\n      and border configurations.\n    ";
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
    (let toRgbaList = (builtins.addErrorContext "_let toRgbaList annotation mismatch: /nix/store/59qqzf108ga8h2qmsjizzsn2p7i889xx-zenpkgs-dsl-source/modules/desktops/gnome/extensions/rounded-window-corners-reborn.zmdl:25:1" ((_zenType: _zenValue: let force = type: value: if type.name == "anything" then true else if type.name == "listOf" then builtins.all (force type.nestedTypes.elemType) value else if type.name == "attrsOf" then builtins.all (force type.nestedTypes.elemType) (builtins.attrValues value) else if type.name == "either" then force (if type.nestedTypes.left.check value then type.nestedTypes.left else type.nestedTypes.right) value else builtins.seq value true; in builtins.seq (force _zenType _zenValue) _zenValue) ((lib.types.addCheck lib.types.unspecified builtins.isFunction)) ((lib.evalModules { modules = [ { options.value = lib.mkOption { type = (lib.types.addCheck lib.types.unspecified builtins.isFunction); }; config.value = (value: (if ((lib.isString value) && ((lib.hasPrefix "#") value)) then (let
  hex = ((lib.removePrefix "#") value);
  red = (((lib.fromHexString ((((lib.substring 0) 2) hex)))) / 255.0);
  green = (((lib.fromHexString ((((lib.substring 2) 2) hex)))) / 255.0);
  blue = (((lib.fromHexString ((((lib.substring 4) 2) hex)))) / 255.0);
  alpha = (if ((lib.stringLength hex) == 8) then (((lib.fromHexString ((((lib.substring 6) 2) hex)))) / 255.0) else 1.0);
in [
  red
  green
  blue
  alpha
]) else value)); } ]; }).config.value))); toVariant = (builtins.addErrorContext "_let toVariant annotation mismatch: /nix/store/59qqzf108ga8h2qmsjizzsn2p7i889xx-zenpkgs-dsl-source/modules/desktops/gnome/extensions/rounded-window-corners-reborn.zmdl:37:1" ((_zenType: _zenValue: let force = type: value: if type.name == "anything" then true else if type.name == "listOf" then builtins.all (force type.nestedTypes.elemType) value else if type.name == "attrsOf" then builtins.all (force type.nestedTypes.elemType) (builtins.attrValues value) else if type.name == "either" then force (if type.nestedTypes.left.check value then type.nestedTypes.left else type.nestedTypes.right) value else builtins.seq value true; in builtins.seq (force _zenType _zenValue) _zenValue) ((lib.types.addCheck lib.types.unspecified builtins.isFunction)) ((lib.evalModules { modules = [ { options.value = lib.mkOption { type = (lib.types.addCheck lib.types.unspecified builtins.isFunction); }; config.value = (let
  convert = (value: (if ((lib.isAttrs value) && (!((lib.gvariant.isGVariant value)))) then (if (value == { }) then (lib.gvariant.mkEmptyArray "{sv}") else (lib.gvariant.mkArray (((lib.mapAttrsToList ((key: (item: ((lib.gvariant.mkDictionaryEntry key) ((lib.gvariant.mkVariant ((convert item))))))))) value)))) else (if (lib.isInt value) then (lib.gvariant.mkInt32 value) else (lib.gvariant.mkValue value))));
in convert); } ]; }).config.value))); shadow = (builtins.addErrorContext "_let shadow annotation mismatch: /nix/store/59qqzf108ga8h2qmsjizzsn2p7i889xx-zenpkgs-dsl-source/modules/desktops/gnome/extensions/rounded-window-corners-reborn.zmdl:47:1" ((_zenType: _zenValue: let force = type: value: if type.name == "anything" then true else if type.name == "listOf" then builtins.all (force type.nestedTypes.elemType) value else if type.name == "attrsOf" then builtins.all (force type.nestedTypes.elemType) (builtins.attrValues value) else if type.name == "either" then force (if type.nestedTypes.left.check value then type.nestedTypes.left else type.nestedTypes.right) value else builtins.seq value true; in builtins.seq (force _zenType _zenValue) _zenValue) ((lib.types.addCheck lib.types.unspecified builtins.isFunction)) ((lib.evalModules { modules = [ { options.value = lib.mkOption { type = (lib.types.addCheck lib.types.unspecified builtins.isFunction); }; config.value = (json: (lib.gvariant.mkArray (((lib.mapAttrsToList ((key: (value: ((lib.gvariant.mkDictionaryEntry key) ((lib.gvariant.mkInt32 value))))))) ((lib.fromJSON json)))))); } ]; }).config.value))); in (lib.mkIf ((cfg.enable)) {
      environment.systemPackages = [
        pkgs.zenos.byCategories.desktops.gnome.extensions.rounded-window-corners-reborn
      ];
    }))
    (let toRgbaList = (builtins.addErrorContext "_let toRgbaList annotation mismatch: /nix/store/59qqzf108ga8h2qmsjizzsn2p7i889xx-zenpkgs-dsl-source/modules/desktops/gnome/extensions/rounded-window-corners-reborn.zmdl:25:1" ((_zenType: _zenValue: let force = type: value: if type.name == "anything" then true else if type.name == "listOf" then builtins.all (force type.nestedTypes.elemType) value else if type.name == "attrsOf" then builtins.all (force type.nestedTypes.elemType) (builtins.attrValues value) else if type.name == "either" then force (if type.nestedTypes.left.check value then type.nestedTypes.left else type.nestedTypes.right) value else builtins.seq value true; in builtins.seq (force _zenType _zenValue) _zenValue) ((lib.types.addCheck lib.types.unspecified builtins.isFunction)) ((lib.evalModules { modules = [ { options.value = lib.mkOption { type = (lib.types.addCheck lib.types.unspecified builtins.isFunction); }; config.value = (value: (if ((lib.isString value) && ((lib.hasPrefix "#") value)) then (let
  hex = ((lib.removePrefix "#") value);
  red = (((lib.fromHexString ((((lib.substring 0) 2) hex)))) / 255.0);
  green = (((lib.fromHexString ((((lib.substring 2) 2) hex)))) / 255.0);
  blue = (((lib.fromHexString ((((lib.substring 4) 2) hex)))) / 255.0);
  alpha = (if ((lib.stringLength hex) == 8) then (((lib.fromHexString ((((lib.substring 6) 2) hex)))) / 255.0) else 1.0);
in [
  red
  green
  blue
  alpha
]) else value)); } ]; }).config.value))); toVariant = (builtins.addErrorContext "_let toVariant annotation mismatch: /nix/store/59qqzf108ga8h2qmsjizzsn2p7i889xx-zenpkgs-dsl-source/modules/desktops/gnome/extensions/rounded-window-corners-reborn.zmdl:37:1" ((_zenType: _zenValue: let force = type: value: if type.name == "anything" then true else if type.name == "listOf" then builtins.all (force type.nestedTypes.elemType) value else if type.name == "attrsOf" then builtins.all (force type.nestedTypes.elemType) (builtins.attrValues value) else if type.name == "either" then force (if type.nestedTypes.left.check value then type.nestedTypes.left else type.nestedTypes.right) value else builtins.seq value true; in builtins.seq (force _zenType _zenValue) _zenValue) ((lib.types.addCheck lib.types.unspecified builtins.isFunction)) ((lib.evalModules { modules = [ { options.value = lib.mkOption { type = (lib.types.addCheck lib.types.unspecified builtins.isFunction); }; config.value = (let
  convert = (value: (if ((lib.isAttrs value) && (!((lib.gvariant.isGVariant value)))) then (if (value == { }) then (lib.gvariant.mkEmptyArray "{sv}") else (lib.gvariant.mkArray (((lib.mapAttrsToList ((key: (item: ((lib.gvariant.mkDictionaryEntry key) ((lib.gvariant.mkVariant ((convert item))))))))) value)))) else (if (lib.isInt value) then (lib.gvariant.mkInt32 value) else (lib.gvariant.mkValue value))));
in convert); } ]; }).config.value))); shadow = (builtins.addErrorContext "_let shadow annotation mismatch: /nix/store/59qqzf108ga8h2qmsjizzsn2p7i889xx-zenpkgs-dsl-source/modules/desktops/gnome/extensions/rounded-window-corners-reborn.zmdl:47:1" ((_zenType: _zenValue: let force = type: value: if type.name == "anything" then true else if type.name == "listOf" then builtins.all (force type.nestedTypes.elemType) value else if type.name == "attrsOf" then builtins.all (force type.nestedTypes.elemType) (builtins.attrValues value) else if type.name == "either" then force (if type.nestedTypes.left.check value then type.nestedTypes.left else type.nestedTypes.right) value else builtins.seq value true; in builtins.seq (force _zenType _zenValue) _zenValue) ((lib.types.addCheck lib.types.unspecified builtins.isFunction)) ((lib.evalModules { modules = [ { options.value = lib.mkOption { type = (lib.types.addCheck lib.types.unspecified builtins.isFunction); }; config.value = (json: (lib.gvariant.mkArray (((lib.mapAttrsToList ((key: (value: ((lib.gvariant.mkDictionaryEntry key) ((lib.gvariant.mkInt32 value))))))) ((lib.fromJSON json)))))); } ]; }).config.value))); in (lib.mkIf ((cfg.enable)) { home-manager.sharedModules = [ {
      dconf.settings."org/gnome/shell".enabled-extensions = [
        pkgs.zenos.byCategories.desktops.gnome.extensions.rounded-window-corners-reborn.extensionUuid
      ];
      dconf.settings."org/gnome/shell/extensions/rounded-window-corners-reborn" = (({
        border-width = (lib.gvariant.mkInt32 cfg.settings.border-size);
        settings-version = (lib.gvariant.mkUint32 cfg.general.settings-version);
        skip-libadwaita-app = cfg.skip-libadwaita-app;
        debug-mode = cfg.general.debug;
        tweak-kitty-terminal = cfg.general.tweak-kitty;
        global-rounded-corner-settings = (toVariant {
          padding = ((lib.mapAttrs ((_: (value: (lib.gvariant.mkUint32 value))))) cfg.settings.padding);
          keepRoundedCorners = {
            maximized = cfg.settings.keep-rounded-corners;
            fullscreen = cfg.settings.keep-rounded-corners;
          };
          borderRadius = (lib.gvariant.mkUint32 cfg.settings.border-radius);
          smoothing = cfg.settings.smoothing;
          borderColor = (toRgbaList cfg.settings.border-color);
          enabled = true;
        });
        custom-rounded-corner-settings = (toVariant cfg.custom-settings);
      } // (((lib.optionalAttrs ((cfg.focused-shadow != "{}"))) {
        focused-shadow = (shadow cfg.focused-shadow);
      }))) // (((lib.optionalAttrs ((cfg.unfocused-shadow != "{}"))) {
        unfocused-shadow = (shadow cfg.unfocused-shadow);
      })));
    } ]; }))
  ];
}
