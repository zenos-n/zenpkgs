{ config, lib, pkgs, maintainers ? lib.maintainers, licenses ? lib.licenses, ... }:
let
  cfg = config.zenos.system.oobe;
  name = "oobe";
  extensionUuid = (builtins.addErrorContext "_let extensionUuid annotation mismatch: /nix/store/59qqzf108ga8h2qmsjizzsn2p7i889xx-zenpkgs-dsl-source/modules/system/oobe.zmdl:17:1" ((_zenType: _zenValue: let force = type: value: if type.name == "anything" then true else if type.name == "listOf" then builtins.all (force type.nestedTypes.elemType) value else if type.name == "attrsOf" then builtins.all (force type.nestedTypes.elemType) (builtins.attrValues value) else if type.name == "either" then force (if type.nestedTypes.left.check value then type.nestedTypes.left else type.nestedTypes.right) value else builtins.seq value true; in builtins.seq (force _zenType _zenValue) _zenValue) (lib.types.str) ((lib.evalModules { modules = [ { options.value = lib.mkOption { type = lib.types.str; }; config.value = "zenos-oobe-mode@neg-zero.com"; } ]; }).config.value)));
  servicePath = (builtins.addErrorContext "_let servicePath annotation mismatch: /nix/store/59qqzf108ga8h2qmsjizzsn2p7i889xx-zenpkgs-dsl-source/modules/system/oobe.zmdl:18:1" ((_zenType: _zenValue: let force = type: value: if type.name == "anything" then true else if type.name == "listOf" then builtins.all (force type.nestedTypes.elemType) value else if type.name == "attrsOf" then builtins.all (force type.nestedTypes.elemType) (builtins.attrValues value) else if type.name == "either" then force (if type.nestedTypes.left.check value then type.nestedTypes.left else type.nestedTypes.right) value else builtins.seq value true; in builtins.seq (force _zenType _zenValue) _zenValue) (lib.types.str) ((lib.evalModules { modules = [ { options.value = lib.mkOption { type = lib.types.str; }; config.value = "/run/wrappers/bin:/run/current-system/sw/bin"; } ]; }).config.value)));
  oobeHome = (builtins.addErrorContext "_let oobeHome annotation mismatch: /nix/store/59qqzf108ga8h2qmsjizzsn2p7i889xx-zenpkgs-dsl-source/modules/system/oobe.zmdl:19:1" ((_zenType: _zenValue: let force = type: value: if type.name == "anything" then true else if type.name == "listOf" then builtins.all (force type.nestedTypes.elemType) value else if type.name == "attrsOf" then builtins.all (force type.nestedTypes.elemType) (builtins.attrValues value) else if type.name == "either" then force (if type.nestedTypes.left.check value then type.nestedTypes.left else type.nestedTypes.right) value else builtins.seq value true; in builtins.seq (force _zenType _zenValue) _zenValue) (lib.types.str) ((lib.evalModules { modules = [ { options.value = lib.mkOption { type = lib.types.str; }; config.value = "/run/zenos-oobe"; } ]; }).config.value)));
  blackWallpaper = (builtins.addErrorContext "_let blackWallpaper annotation mismatch: /nix/store/59qqzf108ga8h2qmsjizzsn2p7i889xx-zenpkgs-dsl-source/modules/system/oobe.zmdl:20:1" ((_zenType: _zenValue: let force = type: value: if type.name == "anything" then true else if type.name == "listOf" then builtins.all (force type.nestedTypes.elemType) value else if type.name == "attrsOf" then builtins.all (force type.nestedTypes.elemType) (builtins.attrValues value) else if type.name == "either" then force (if type.nestedTypes.left.check value then type.nestedTypes.left else type.nestedTypes.right) value else builtins.seq value true; in builtins.seq (force _zenType _zenValue) _zenValue) (lib.types.package) ((lib.evalModules { modules = [ { options.value = lib.mkOption { type = lib.types.package; }; config.value = ((pkgs.zenos.legacy.writeText "zenos-oobe-black.svg") "\n  <svg xmlns=\"http://www.w3.org/2000/svg\" width=\"1\" height=\"1\">\n    <rect width=\"1\" height=\"1\" fill=\"#000000\"/>\n  </svg>\n"); } ]; }).config.value)));
in
{
  options.zenos.system.oobe = lib.mkOption { type = (lib.types.submodule ({ ... }: (let extensionUuid = (builtins.addErrorContext "_let extensionUuid annotation mismatch: /nix/store/59qqzf108ga8h2qmsjizzsn2p7i889xx-zenpkgs-dsl-source/modules/system/oobe.zmdl:17:1" ((_zenType: _zenValue: let force = type: value: if type.name == "anything" then true else if type.name == "listOf" then builtins.all (force type.nestedTypes.elemType) value else if type.name == "attrsOf" then builtins.all (force type.nestedTypes.elemType) (builtins.attrValues value) else if type.name == "either" then force (if type.nestedTypes.left.check value then type.nestedTypes.left else type.nestedTypes.right) value else builtins.seq value true; in builtins.seq (force _zenType _zenValue) _zenValue) (lib.types.str) ((lib.evalModules { modules = [ { options.value = lib.mkOption { type = lib.types.str; }; config.value = "zenos-oobe-mode@neg-zero.com"; } ]; }).config.value))); servicePath = (builtins.addErrorContext "_let servicePath annotation mismatch: /nix/store/59qqzf108ga8h2qmsjizzsn2p7i889xx-zenpkgs-dsl-source/modules/system/oobe.zmdl:18:1" ((_zenType: _zenValue: let force = type: value: if type.name == "anything" then true else if type.name == "listOf" then builtins.all (force type.nestedTypes.elemType) value else if type.name == "attrsOf" then builtins.all (force type.nestedTypes.elemType) (builtins.attrValues value) else if type.name == "either" then force (if type.nestedTypes.left.check value then type.nestedTypes.left else type.nestedTypes.right) value else builtins.seq value true; in builtins.seq (force _zenType _zenValue) _zenValue) (lib.types.str) ((lib.evalModules { modules = [ { options.value = lib.mkOption { type = lib.types.str; }; config.value = "/run/wrappers/bin:/run/current-system/sw/bin"; } ]; }).config.value))); oobeHome = (builtins.addErrorContext "_let oobeHome annotation mismatch: /nix/store/59qqzf108ga8h2qmsjizzsn2p7i889xx-zenpkgs-dsl-source/modules/system/oobe.zmdl:19:1" ((_zenType: _zenValue: let force = type: value: if type.name == "anything" then true else if type.name == "listOf" then builtins.all (force type.nestedTypes.elemType) value else if type.name == "attrsOf" then builtins.all (force type.nestedTypes.elemType) (builtins.attrValues value) else if type.name == "either" then force (if type.nestedTypes.left.check value then type.nestedTypes.left else type.nestedTypes.right) value else builtins.seq value true; in builtins.seq (force _zenType _zenValue) _zenValue) (lib.types.str) ((lib.evalModules { modules = [ { options.value = lib.mkOption { type = lib.types.str; }; config.value = "/run/zenos-oobe"; } ]; }).config.value))); blackWallpaper = (builtins.addErrorContext "_let blackWallpaper annotation mismatch: /nix/store/59qqzf108ga8h2qmsjizzsn2p7i889xx-zenpkgs-dsl-source/modules/system/oobe.zmdl:20:1" ((_zenType: _zenValue: let force = type: value: if type.name == "anything" then true else if type.name == "listOf" then builtins.all (force type.nestedTypes.elemType) value else if type.name == "attrsOf" then builtins.all (force type.nestedTypes.elemType) (builtins.attrValues value) else if type.name == "either" then force (if type.nestedTypes.left.check value then type.nestedTypes.left else type.nestedTypes.right) value else builtins.seq value true; in builtins.seq (force _zenType _zenValue) _zenValue) (lib.types.package) ((lib.evalModules { modules = [ { options.value = lib.mkOption { type = lib.types.package; }; config.value = ((pkgs.zenos.legacy.writeText "zenos-oobe-black.svg") "\n  <svg xmlns=\"http://www.w3.org/2000/svg\" width=\"1\" height=\"1\">\n    <rect width=\"1\" height=\"1\" fill=\"#000000\"/>\n  </svg>\n"); } ]; }).config.value))); in { options = { authorizedKeys = lib.mkOption { type = (lib.types.listOf lib.types.str); default = [ ]; }; enable = lib.mkOption { type = lib.types.bool; default = config.zenos.system.oobeMode; }; extensionPackage = lib.mkOption { type = lib.types.package; default = pkgs.zenos.byCategories.system.zenos-oobe-mode; example = "pkgs.zenos.oobe-extension"; }; extraExtensionPackages = lib.mkOption { type = (lib.types.listOf lib.types.package); default = [
  pkgs.zenos.byCategories.desktops.gnome.extensions.date-menu-formatter
  pkgs.zenos.byCategories.desktops.gnome.extensions.user-themes
]; }; extraExtensionUuids = lib.mkOption { type = (lib.types.listOf lib.types.str); default = [
  "date-menu-formatter@marcinjakubowski.github.com"
  "user-theme@gnome-shell-extensions.gcampax.github.com"
]; }; setupPackage = lib.mkOption { type = lib.types.package; default = pkgs.zenos.byCategories.apps.system.zenos-setup; example = "pkgs.zenos.setup"; }; userName = lib.mkOption { type = lib.types.str; default = "zenos"; }; }; }))); default = { }; };
  config = lib.mkMerge [
    { _module.args.zenlang.descriptors.system.oobe = {
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
            value = "\n    Creates a disposable GNOME setup account and session, starts the Setup app,\n    locks down the shell, and prepares runtime directories.\n  ";
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
            value = "linux";
          }
        ];
        type = "variable";
      };
      summary = {
        multiline = false;
        parts = [
          {
            type = "text";
            value = "Temporary ZenOS out-of-box experience";
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
    moduleIdentity = "zenos.system.oobe";
    modulePath = [
      "system"
      "oobe"
    ];
    nodeMetadata = [
      {
        metadata = {
          description = {
            multiline = true;
            parts = [
              {
                type = "text";
                value = "\n    Creates a disposable GNOME setup account and session, starts the Setup app,\n    locks down the shell, and prepares runtime directories.\n  ";
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
                value = "linux";
              }
            ];
            type = "variable";
          };
          summary = {
            multiline = false;
            parts = [
              {
                type = "text";
                value = "Temporary ZenOS out-of-box experience";
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
          default = {
            name = "cfg";
            path = [
              {
                kind = "identifier";
                value = "system";
              }
              {
                kind = "identifier";
                value = "oobeMode";
              }
            ];
            type = "variable";
          };
          summary = {
            multiline = false;
            parts = [
              {
                type = "text";
                value = "Enable the temporary ZenOS out-of-box experience";
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
            name = "pkgs";
            path = [
              {
                kind = "identifier";
                value = "zenos";
              }
              {
                kind = "identifier";
                value = "byCategories";
              }
              {
                kind = "identifier";
                value = "apps";
              }
              {
                kind = "identifier";
                value = "system";
              }
              {
                kind = "identifier";
                value = "zenos-setup";
              }
            ];
            type = "variable";
          };
          example = {
            multiline = false;
            parts = [
              {
                type = "text";
                value = "pkgs.zenos.setup";
              }
            ];
            type = "string";
          };
          summary = {
            multiline = false;
            parts = [
              {
                type = "text";
                value = "Setup application package launched by OOBE";
              }
            ];
            type = "string";
          };
          type = {
            name = "type";
            path = [
              {
                kind = "identifier";
                value = "package";
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
          "setupPackage"
        ];
      }
      {
        metadata = {
          default = {
            name = "pkgs";
            path = [
              {
                kind = "identifier";
                value = "zenos";
              }
              {
                kind = "identifier";
                value = "byCategories";
              }
              {
                kind = "identifier";
                value = "system";
              }
              {
                kind = "identifier";
                value = "zenos-oobe-mode";
              }
            ];
            type = "variable";
          };
          example = {
            multiline = false;
            parts = [
              {
                type = "text";
                value = "pkgs.zenos.oobe-extension";
              }
            ];
            type = "string";
          };
          summary = {
            multiline = false;
            parts = [
              {
                type = "text";
                value = "GNOME Shell extension and mode package for OOBE";
              }
            ];
            type = "string";
          };
          type = {
            name = "type";
            path = [
              {
                kind = "identifier";
                value = "package";
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
          "extensionPackage"
        ];
      }
      {
        metadata = {
          default = {
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
                    value = "date-menu-formatter";
                  }
                ];
                type = "variable";
              }
              {
                name = "pkgs";
                path = [
                  {
                    kind = "identifier";
                    value = "zenos";
                  }
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
                    value = "user-themes";
                  }
                ];
                type = "variable";
              }
            ];
            type = "list";
          };
          summary = {
            multiline = false;
            parts = [
              {
                type = "text";
                value = "Additional OOBE GNOME extension packages";
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
                        value = "package";
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
          "extraExtensionPackages"
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
                    value = "date-menu-formatter@marcinjakubowski.github.com";
                  }
                ];
                type = "string";
              }
              {
                multiline = false;
                parts = [
                  {
                    type = "text";
                    value = "user-theme@gnome-shell-extensions.gcampax.github.com";
                  }
                ];
                type = "string";
              }
            ];
            type = "list";
          };
          summary = {
            multiline = false;
            parts = [
              {
                type = "text";
                value = "Additional OOBE GNOME extension UUIDs";
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
          "extraExtensionUuids"
        ];
      }
      {
        metadata = {
          default = {
            items = [ ];
            type = "list";
          };
          summary = {
            multiline = false;
            parts = [
              {
                type = "text";
                value = "SSH keys accepted by the OOBE account";
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
          "authorizedKeys"
        ];
      }
      {
        metadata = {
          default = {
            multiline = false;
            parts = [
              {
                type = "text";
                value = "zenos";
              }
            ];
            type = "string";
          };
          summary = {
            multiline = false;
            parts = [
              {
                type = "text";
                value = "Temporary OOBE account name";
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
          "userName"
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
                    value = "Temporary ZenOS out-of-box experience";
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
                    value = "\n    Creates a disposable GNOME setup account and session, starts the Setup app,\n    locks down the shell, and prepares runtime directories.\n  ";
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
                    value = "linux";
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
          name = "type";
          path = [
            {
              kind = "identifier";
              value = "string";
            }
          ];
          type = "variable";
        };
        name = "extensionUuid";
        type = "let-binding";
        value = {
          multiline = false;
          parts = [
            {
              type = "text";
              value = "zenos-oobe-mode@neg-zero.com";
            }
          ];
          type = "string";
        };
      }
      {
        annotation = {
          name = "type";
          path = [
            {
              kind = "identifier";
              value = "string";
            }
          ];
          type = "variable";
        };
        name = "servicePath";
        type = "let-binding";
        value = {
          multiline = false;
          parts = [
            {
              type = "text";
              value = "/run/wrappers/bin:/run/current-system/sw/bin";
            }
          ];
          type = "string";
        };
      }
      {
        annotation = {
          name = "type";
          path = [
            {
              kind = "identifier";
              value = "string";
            }
          ];
          type = "variable";
        };
        name = "oobeHome";
        type = "let-binding";
        value = {
          multiline = false;
          parts = [
            {
              type = "text";
              value = "/run/zenos-oobe";
            }
          ];
          type = "string";
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
        name = "blackWallpaper";
        type = "let-binding";
        value = {
          arguments = [
            {
              multiline = true;
              parts = [
                {
                  type = "text";
                  value = "\n  <svg xmlns=\"http://www.w3.org/2000/svg\" width=\"1\" height=\"1\">\n    <rect width=\"1\" height=\"1\" fill=\"#000000\"/>\n  </svg>\n";
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
                    value = "zenos-oobe-black.svg";
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
                  value = "zenos";
                }
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
                          value = "default";
                        }
                      ];
                      type = "assignment";
                      value = {
                        name = "cfg";
                        path = [
                          {
                            kind = "identifier";
                            value = "system";
                          }
                          {
                            kind = "identifier";
                            value = "oobeMode";
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
                          value = "summary";
                        }
                      ];
                      type = "assignment";
                      value = {
                        multiline = false;
                        parts = [
                          {
                            type = "text";
                            value = "Enable the temporary ZenOS out-of-box experience";
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
                          value = "services";
                        }
                        {
                          kind = "identifier";
                          value = "desktopManager";
                        }
                        {
                          kind = "identifier";
                          value = "gnome";
                        }
                        {
                          kind = "identifier";
                          value = "enable";
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
                          value = "services";
                        }
                        {
                          kind = "identifier";
                          value = "displayManager";
                        }
                      ];
                      type = "assignment";
                      value = {
                        recursive = false;
                        statements = [
                          {
                            operator = "=";
                            target = [
                              {
                                kind = "identifier";
                                value = "gdm";
                              }
                              {
                                kind = "identifier";
                                value = "enable";
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
                                    value = "mkForce";
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
                                value = "sddm";
                              }
                              {
                                kind = "identifier";
                                value = "enable";
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
                                    value = "mkForce";
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
                                value = "plasma-login-manager";
                              }
                              {
                                kind = "identifier";
                                value = "enable";
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
                                    value = "mkForce";
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
                                value = "autoLogin";
                              }
                              {
                                kind = "identifier";
                                value = "enable";
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
                                    value = "mkForce";
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
                                value = "autoLogin";
                              }
                              {
                                kind = "identifier";
                                value = "user";
                              }
                            ];
                            type = "assignment";
                            value = {
                              arguments = [
                                {
                                  kind = "null";
                                  type = "literal";
                                  value = null;
                                }
                              ];
                              callee = {
                                name = "lib";
                                path = [
                                  {
                                    kind = "identifier";
                                    value = "mkForce";
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
                          value = "services";
                        }
                        {
                          kind = "identifier";
                          value = "xserver";
                        }
                        {
                          kind = "identifier";
                          value = "displayManager";
                        }
                        {
                          kind = "identifier";
                          value = "lightdm";
                        }
                        {
                          kind = "identifier";
                          value = "enable";
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
                              value = "mkForce";
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
                          value = "services";
                        }
                        {
                          kind = "identifier";
                          value = "openssh";
                        }
                      ];
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
                                value = "openFirewall";
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
                                      value = "KbdInteractiveAuthentication";
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
                                      value = "PasswordAuthentication";
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
                                      value = "PermitEmptyPasswords";
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
                                      value = "PermitRootLogin";
                                    }
                                  ];
                                  type = "assignment";
                                  value = {
                                    multiline = false;
                                    parts = [
                                      {
                                        type = "text";
                                        value = "no";
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
                          value = "services";
                        }
                        {
                          kind = "identifier";
                          value = "gnome";
                        }
                        {
                          kind = "identifier";
                          value = "gnome-initial-setup";
                        }
                        {
                          kind = "identifier";
                          value = "enable";
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
                          value = "services";
                        }
                        {
                          kind = "identifier";
                          value = "greetd";
                        }
                      ];
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
                                value = "restart";
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
                                      value = "initial_session";
                                    }
                                  ];
                                  type = "assignment";
                                  value = {
                                    recursive = false;
                                    statements = [
                                      {
                                        operator = "=";
                                        target = [
                                          {
                                            kind = "identifier";
                                            value = "user";
                                          }
                                        ];
                                        type = "assignment";
                                        value = {
                                          name = "path";
                                          path = [
                                            {
                                              kind = "identifier";
                                              value = "userName";
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
                                      value = "default_session";
                                    }
                                  ];
                                  type = "assignment";
                                  value = {
                                    recursive = false;
                                    statements = [
                                      {
                                        operator = "=";
                                        target = [
                                          {
                                            kind = "identifier";
                                            value = "user";
                                          }
                                        ];
                                        type = "assignment";
                                        value = {
                                          name = "path";
                                          path = [
                                            {
                                              kind = "identifier";
                                              value = "userName";
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
                          value = "systemd";
                        }
                        {
                          kind = "identifier";
                          value = "services";
                        }
                        {
                          kind = "identifier";
                          value = "greetd";
                        }
                        {
                          kind = "identifier";
                          value = "environment";
                        }
                      ];
                      type = "assignment";
                      value = {
                        recursive = false;
                        statements = [
                          {
                            operator = "=";
                            target = [
                              {
                                kind = "identifier";
                                value = "XDG_SESSION_TYPE";
                              }
                            ];
                            type = "assignment";
                            value = {
                              multiline = false;
                              parts = [
                                {
                                  type = "text";
                                  value = "wayland";
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
                                value = "XDG_SESSION_CLASS";
                              }
                            ];
                            type = "assignment";
                            value = {
                              multiline = false;
                              parts = [
                                {
                                  type = "text";
                                  value = "user";
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
                                value = "XDG_SESSION_DESKTOP";
                              }
                            ];
                            type = "assignment";
                            value = {
                              multiline = false;
                              parts = [
                                {
                                  type = "text";
                                  value = "GNOME";
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
                      operator = "=";
                      target = [
                        {
                          kind = "identifier";
                          value = "environment";
                        }
                        {
                          kind = "identifier";
                          value = "etc";
                        }
                        {
                          kind = "string";
                          value = "xdg/gnome-session/sessions/zenos-oobe.session";
                        }
                        {
                          kind = "identifier";
                          value = "text";
                        }
                      ];
                      type = "assignment";
                      value = {
                        multiline = true;
                        parts = [
                          {
                            type = "text";
                            value = "\n      [GNOME Session]\n      Name=ZenOS OOBE\n    ";
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
                          value = "systemd";
                        }
                        {
                          kind = "identifier";
                          value = "user";
                        }
                        {
                          kind = "identifier";
                          value = "targets";
                        }
                        {
                          kind = "string";
                          value = "gnome-session@zenos-oobe";
                        }
                      ];
                      type = "assignment";
                      value = {
                        recursive = false;
                        statements = [
                          {
                            operator = "=";
                            target = [
                              {
                                kind = "identifier";
                                value = "overrideStrategy";
                              }
                            ];
                            type = "assignment";
                            value = {
                              multiline = false;
                              parts = [
                                {
                                  type = "text";
                                  value = "asDropin";
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
                                value = "unitConfig";
                              }
                              {
                                kind = "identifier";
                                value = "Requires";
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
                                      value = "gnome-session-services.target";
                                    }
                                  ];
                                  type = "string";
                                }
                                {
                                  multiline = false;
                                  parts = [
                                    {
                                      type = "text";
                                      value = "org.gnome.Shell@zenos-oobe.service";
                                    }
                                  ];
                                  type = "string";
                                }
                              ];
                              type = "list";
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
                          kind = "string";
                          value = "org.gnome.Shell@zenos-oobe";
                        }
                      ];
                      type = "assignment";
                      value = {
                        recursive = false;
                        statements = [
                          {
                            operator = "=";
                            target = [
                              {
                                kind = "identifier";
                                value = "overrideStrategy";
                              }
                            ];
                            type = "assignment";
                            value = {
                              multiline = false;
                              parts = [
                                {
                                  type = "text";
                                  value = "asDropin";
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
                                value = "environment";
                              }
                            ];
                            type = "assignment";
                            value = {
                              recursive = false;
                              statements = [
                                {
                                  operator = "=";
                                  target = [
                                    {
                                      kind = "identifier";
                                      value = "PATH";
                                    }
                                  ];
                                  type = "assignment";
                                  value = {
                                    arguments = [
                                      {
                                        name = "v";
                                        path = [
                                          {
                                            kind = "identifier";
                                            value = "servicePath";
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
                                          value = "mkForce";
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
                                      value = "ZENOS_OOBE";
                                    }
                                  ];
                                  type = "assignment";
                                  value = {
                                    multiline = false;
                                    parts = [
                                      {
                                        type = "text";
                                        value = "1";
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
                                      value = "GNOME_SHELL_SESSION_MODE";
                                    }
                                  ];
                                  type = "assignment";
                                  value = {
                                    multiline = false;
                                    parts = [
                                      {
                                        type = "text";
                                        value = "zenos-oobe";
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
                          value = "zenos-oobe";
                        }
                      ];
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
                                  value = "ZenOS out-of-box experience";
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
                                value = "after";
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
                                      value = "gnome-session.target";
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
                                value = "path";
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
                                value = "environment";
                              }
                            ];
                            type = "assignment";
                            value = {
                              recursive = false;
                              statements = [
                                {
                                  operator = "=";
                                  target = [
                                    {
                                      kind = "identifier";
                                      value = "PATH";
                                    }
                                  ];
                                  type = "assignment";
                                  value = {
                                    arguments = [
                                      {
                                        name = "v";
                                        path = [
                                          {
                                            kind = "identifier";
                                            value = "servicePath";
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
                                          value = "mkForce";
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
                                      value = "ZENOS_OOBE";
                                    }
                                  ];
                                  type = "assignment";
                                  value = {
                                    multiline = false;
                                    parts = [
                                      {
                                        type = "text";
                                        value = "1";
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
                                      value = "ZENOS_SETUP_DRY_RUN";
                                    }
                                  ];
                                  type = "assignment";
                                  value = {
                                    multiline = false;
                                    parts = [
                                      {
                                        type = "text";
                                        value = "0";
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
                                      value = "GI_TYPELIB_PATH";
                                    }
                                  ];
                                  type = "assignment";
                                  value = {
                                    arguments = [
                                      {
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
                                                value = "gnome-desktop";
                                              }
                                            ];
                                            type = "variable";
                                          }
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
                                                value = "libgweather";
                                              }
                                            ];
                                            type = "variable";
                                          }
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
                                                value = "networkmanager";
                                              }
                                            ];
                                            type = "variable";
                                          }
                                        ];
                                        type = "list";
                                      }
                                    ];
                                    callee = {
                                      arguments = [
                                        {
                                          multiline = false;
                                          parts = [
                                            {
                                              type = "text";
                                              value = "lib/girepository-1.0";
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
                                            value = "makeSearchPath";
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
                          }
                          {
                            operator = "=";
                            target = [
                              {
                                kind = "identifier";
                                value = "unitConfig";
                              }
                              {
                                kind = "identifier";
                                value = "ConditionUser";
                              }
                            ];
                            type = "assignment";
                            value = {
                              name = "path";
                              path = [
                                {
                                  kind = "identifier";
                                  value = "userName";
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
                                        value = "exec";
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
                                      value = "ExecStart";
                                    }
                                  ];
                                  type = "assignment";
                                  value = {
                                    multiline = false;
                                    parts = [
                                      {
                                        expression = {
                                          arguments = [
                                            {
                                              name = "path";
                                              path = [
                                                {
                                                  kind = "identifier";
                                                  value = "setupPackage";
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
                                                value = "getExe";
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
                                        value = " --oobe";
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
                                      value = "Restart";
                                    }
                                  ];
                                  type = "assignment";
                                  value = {
                                    multiline = false;
                                    parts = [
                                      {
                                        type = "text";
                                        value = "on-failure";
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
                                      value = "RestartSec";
                                    }
                                  ];
                                  type = "assignment";
                                  value = {
                                    kind = "integer";
                                    type = "literal";
                                    value = 2;
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
                          value = "users";
                        }
                        {
                          kind = "identifier";
                          value = "mutableUsers";
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
                          value = "users";
                        }
                        {
                          kind = "identifier";
                          value = "users";
                        }
                        {
                          kind = "identifier";
                          value = "root";
                        }
                        {
                          kind = "identifier";
                          value = "hashedPassword";
                        }
                      ];
                      type = "assignment";
                      value = {
                        multiline = false;
                        parts = [
                          {
                            type = "text";
                            value = "!";
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
                          value = "users";
                        }
                        {
                          kind = "identifier";
                          value = "users";
                        }
                        {
                          kind = "dynamic";
                          value = {
                            name = "path";
                            path = [
                              {
                                kind = "identifier";
                                value = "userName";
                              }
                            ];
                            type = "variable";
                          };
                        }
                      ];
                      type = "assignment";
                      value = {
                        recursive = false;
                        statements = [
                          {
                            operator = "=";
                            target = [
                              {
                                kind = "identifier";
                                value = "isNormalUser";
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
                              multiline = false;
                              parts = [
                                {
                                  type = "text";
                                  value = "ZenOS Setup";
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
                                value = "home";
                              }
                            ];
                            type = "assignment";
                            value = {
                              name = "v";
                              path = [
                                {
                                  kind = "identifier";
                                  value = "oobeHome";
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
                                value = "createHome";
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
                                value = "homeMode";
                              }
                            ];
                            type = "assignment";
                            value = {
                              multiline = false;
                              parts = [
                                {
                                  type = "text";
                                  value = "0700";
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
                                value = "hashedPassword";
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
                                value = "openssh";
                              }
                              {
                                kind = "identifier";
                                value = "authorizedKeys";
                              }
                              {
                                kind = "identifier";
                                value = "keys";
                              }
                            ];
                            type = "assignment";
                            value = {
                              name = "path";
                              path = [
                                {
                                  kind = "identifier";
                                  value = "authorizedKeys";
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
                                value = "extraGroups";
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
                                      value = "input";
                                    }
                                  ];
                                  type = "string";
                                }
                                {
                                  multiline = false;
                                  parts = [
                                    {
                                      type = "text";
                                      value = "networkmanager";
                                    }
                                  ];
                                  type = "string";
                                }
                                {
                                  multiline = false;
                                  parts = [
                                    {
                                      type = "text";
                                      value = "video";
                                    }
                                  ];
                                  type = "string";
                                }
                                {
                                  multiline = false;
                                  parts = [
                                    {
                                      type = "text";
                                      value = "wheel";
                                    }
                                  ];
                                  type = "string";
                                }
                              ];
                              type = "list";
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
                          value = "environment";
                        }
                      ];
                      type = "assignment";
                      value = {
                        recursive = false;
                        statements = [
                          {
                            operator = "=";
                            target = [
                              {
                                kind = "identifier";
                                value = "systemPackages";
                              }
                            ];
                            type = "assignment";
                            value = {
                              body = {
                                left = {
                                  left = {
                                    items = [
                                      {
                                        path = [
                                          {
                                            kind = "identifier";
                                            value = "acl";
                                          }
                                        ];
                                        type = "reference";
                                      }
                                      {
                                        path = [
                                          {
                                            kind = "identifier";
                                            value = "attr";
                                          }
                                        ];
                                        type = "reference";
                                      }
                                      {
                                        path = [
                                          {
                                            kind = "identifier";
                                            value = "bashInteractive";
                                          }
                                        ];
                                        type = "reference";
                                      }
                                      {
                                        path = [
                                          {
                                            kind = "identifier";
                                            value = "bzip2";
                                          }
                                        ];
                                        type = "reference";
                                      }
                                      {
                                        path = [
                                          {
                                            kind = "identifier";
                                            value = "coreutils-full";
                                          }
                                        ];
                                        type = "reference";
                                      }
                                      {
                                        path = [
                                          {
                                            kind = "identifier";
                                            value = "cpio";
                                          }
                                        ];
                                        type = "reference";
                                      }
                                      {
                                        path = [
                                          {
                                            kind = "identifier";
                                            value = "curl";
                                          }
                                        ];
                                        type = "reference";
                                      }
                                      {
                                        path = [
                                          {
                                            kind = "identifier";
                                            value = "diffutils";
                                          }
                                        ];
                                        type = "reference";
                                      }
                                      {
                                        path = [
                                          {
                                            kind = "identifier";
                                            value = "findutils";
                                          }
                                        ];
                                        type = "reference";
                                      }
                                      {
                                        path = [
                                          {
                                            kind = "identifier";
                                            value = "gawk";
                                          }
                                        ];
                                        type = "reference";
                                      }
                                      {
                                        path = [
                                          {
                                            kind = "identifier";
                                            value = "getent";
                                          }
                                        ];
                                        type = "reference";
                                      }
                                      {
                                        path = [
                                          {
                                            kind = "identifier";
                                            value = "getconf";
                                          }
                                        ];
                                        type = "reference";
                                      }
                                      {
                                        path = [
                                          {
                                            kind = "identifier";
                                            value = "gnugrep";
                                          }
                                        ];
                                        type = "reference";
                                      }
                                      {
                                        path = [
                                          {
                                            kind = "identifier";
                                            value = "gnupatch";
                                          }
                                        ];
                                        type = "reference";
                                      }
                                      {
                                        path = [
                                          {
                                            kind = "identifier";
                                            value = "gnused";
                                          }
                                        ];
                                        type = "reference";
                                      }
                                      {
                                        path = [
                                          {
                                            kind = "identifier";
                                            value = "gnutar";
                                          }
                                        ];
                                        type = "reference";
                                      }
                                      {
                                        path = [
                                          {
                                            kind = "identifier";
                                            value = "gzip";
                                          }
                                        ];
                                        type = "reference";
                                      }
                                      {
                                        path = [
                                          {
                                            kind = "identifier";
                                            value = "xz";
                                          }
                                        ];
                                        type = "reference";
                                      }
                                      {
                                        path = [
                                          {
                                            kind = "identifier";
                                            value = "less";
                                          }
                                        ];
                                        type = "reference";
                                      }
                                      {
                                        path = [
                                          {
                                            kind = "identifier";
                                            value = "libcap";
                                          }
                                        ];
                                        type = "reference";
                                      }
                                      {
                                        path = [
                                          {
                                            kind = "identifier";
                                            value = "ncurses";
                                          }
                                        ];
                                        type = "reference";
                                      }
                                      {
                                        path = [
                                          {
                                            kind = "identifier";
                                            value = "netcat";
                                          }
                                        ];
                                        type = "reference";
                                      }
                                      {
                                        path = [
                                          {
                                            kind = "identifier";
                                            value = "mkpasswd";
                                          }
                                        ];
                                        type = "reference";
                                      }
                                      {
                                        path = [
                                          {
                                            kind = "identifier";
                                            value = "procps";
                                          }
                                        ];
                                        type = "reference";
                                      }
                                      {
                                        path = [
                                          {
                                            kind = "identifier";
                                            value = "su";
                                          }
                                        ];
                                        type = "reference";
                                      }
                                      {
                                        path = [
                                          {
                                            kind = "identifier";
                                            value = "time";
                                          }
                                        ];
                                        type = "reference";
                                      }
                                      {
                                        path = [
                                          {
                                            kind = "identifier";
                                            value = "util-linux";
                                          }
                                        ];
                                        type = "reference";
                                      }
                                      {
                                        path = [
                                          {
                                            kind = "identifier";
                                            value = "which";
                                          }
                                        ];
                                        type = "reference";
                                      }
                                      {
                                        path = [
                                          {
                                            kind = "identifier";
                                            value = "zstd";
                                          }
                                        ];
                                        type = "reference";
                                      }
                                      {
                                        path = [
                                          {
                                            kind = "identifier";
                                            value = "perl";
                                          }
                                        ];
                                        type = "reference";
                                      }
                                      {
                                        path = [
                                          {
                                            kind = "identifier";
                                            value = "rsync";
                                          }
                                        ];
                                        type = "reference";
                                      }
                                      {
                                        path = [
                                          {
                                            kind = "identifier";
                                            value = "strace";
                                          }
                                        ];
                                        type = "reference";
                                      }
                                      {
                                        path = [
                                          {
                                            kind = "identifier";
                                            value = "atkinson-hyperlegible-next";
                                          }
                                        ];
                                        type = "reference";
                                      }
                                      {
                                        path = [
                                          {
                                            kind = "identifier";
                                            value = "google-cursor";
                                          }
                                        ];
                                        type = "reference";
                                      }
                                      {
                                        path = [
                                          {
                                            kind = "identifier";
                                            value = "nerd-fonts";
                                          }
                                          {
                                            kind = "identifier";
                                            value = "atkynson-mono";
                                          }
                                        ];
                                        type = "reference";
                                      }
                                    ];
                                    type = "list";
                                  };
                                  operator = "++";
                                  right = {
                                    items = [
                                      {
                                        name = "path";
                                        path = [
                                          {
                                            kind = "identifier";
                                            value = "extensionPackage";
                                          }
                                        ];
                                        type = "variable";
                                      }
                                      {
                                        name = "path";
                                        path = [
                                          {
                                            kind = "identifier";
                                            value = "setupPackage";
                                          }
                                        ];
                                        type = "variable";
                                      }
                                    ];
                                    type = "list";
                                  };
                                  type = "binary";
                                };
                                operator = "++";
                                right = {
                                  name = "path";
                                  path = [
                                    {
                                      kind = "identifier";
                                      value = "extraExtensionPackages";
                                    }
                                  ];
                                  type = "variable";
                                };
                                type = "binary";
                              };
                              scope = {
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
                                ];
                                type = "variable";
                              };
                              type = "with";
                            };
                          }
                          {
                            operator = "=";
                            target = [
                              {
                                kind = "identifier";
                                value = "pathsToLink";
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
                                      value = "/bin";
                                    }
                                  ];
                                  type = "string";
                                }
                                {
                                  multiline = false;
                                  parts = [
                                    {
                                      type = "text";
                                      value = "/sbin";
                                    }
                                  ];
                                  type = "string";
                                }
                                {
                                  multiline = false;
                                  parts = [
                                    {
                                      type = "text";
                                      value = "/lib";
                                    }
                                  ];
                                  type = "string";
                                }
                                {
                                  multiline = false;
                                  parts = [
                                    {
                                      type = "text";
                                      value = "/libexec";
                                    }
                                  ];
                                  type = "string";
                                }
                                {
                                  multiline = false;
                                  parts = [
                                    {
                                      type = "text";
                                      value = "/share";
                                    }
                                  ];
                                  type = "string";
                                }
                                {
                                  multiline = false;
                                  parts = [
                                    {
                                      type = "text";
                                      value = "/share/gnome-shell/extensions";
                                    }
                                  ];
                                  type = "string";
                                }
                                {
                                  multiline = false;
                                  parts = [
                                    {
                                      type = "text";
                                      value = "/share/gnome-shell/modes";
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
                                value = "gnome";
                              }
                              {
                                kind = "identifier";
                                value = "excludePackages";
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
                                      value = "gnome-tour";
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
                    }
                    {
                      operator = "=";
                      target = [
                        {
                          kind = "identifier";
                          value = "fonts";
                        }
                      ];
                      type = "assignment";
                      value = {
                        recursive = false;
                        statements = [
                          {
                            operator = "=";
                            target = [
                              {
                                kind = "identifier";
                                value = "packages";
                              }
                            ];
                            type = "assignment";
                            value = {
                              body = {
                                items = [
                                  {
                                    path = [
                                      {
                                        kind = "identifier";
                                        value = "atkinson-hyperlegible-next";
                                      }
                                    ];
                                    type = "reference";
                                  }
                                  {
                                    path = [
                                      {
                                        kind = "identifier";
                                        value = "nerd-fonts";
                                      }
                                      {
                                        kind = "identifier";
                                        value = "atkynson-mono";
                                      }
                                    ];
                                    type = "reference";
                                  }
                                ];
                                type = "list";
                              };
                              scope = {
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
                                ];
                                type = "variable";
                              };
                              type = "with";
                            };
                          }
                          {
                            operator = "=";
                            target = [
                              {
                                kind = "identifier";
                                value = "fontconfig";
                              }
                              {
                                kind = "identifier";
                                value = "defaultFonts";
                              }
                            ];
                            type = "assignment";
                            value = {
                              recursive = false;
                              statements = [
                                {
                                  operator = "=";
                                  target = [
                                    {
                                      kind = "identifier";
                                      value = "sansSerif";
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
                                            value = "Atkinson Hyperlegible Next";
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
                                      value = "monospace";
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
                                            value = "AtkynsonMono NF";
                                          }
                                        ];
                                        type = "string";
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
                    {
                      operator = "=";
                      target = [
                        {
                          kind = "identifier";
                          value = "hardware";
                        }
                        {
                          kind = "identifier";
                          value = "graphics";
                        }
                        {
                          kind = "identifier";
                          value = "enable";
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
                          value = "security";
                        }
                        {
                          kind = "identifier";
                          value = "sudo";
                        }
                        {
                          kind = "identifier";
                          value = "wheelNeedsPassword";
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
                          value = "system";
                        }
                        {
                          kind = "identifier";
                          value = "extraDependencies";
                        }
                      ];
                      type = "assignment";
                      value = {
                        items = [
                          {
                            name = "path";
                            path = [
                              {
                                kind = "identifier";
                                value = "setupPackage";
                              }
                              {
                                kind = "identifier";
                                value = "src";
                              }
                            ];
                            type = "variable";
                          }
                          {
                            name = "path";
                            path = [
                              {
                                kind = "identifier";
                                value = "extensionPackage";
                              }
                              {
                                kind = "identifier";
                                value = "src";
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
                          value = "enable";
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
                          value = "home-manager";
                        }
                        {
                          kind = "identifier";
                          value = "users";
                        }
                        {
                          kind = "dynamic";
                          value = {
                            name = "path";
                            path = [
                              {
                                kind = "identifier";
                                value = "userName";
                              }
                            ];
                            type = "variable";
                          };
                        }
                      ];
                      type = "assignment";
                      value = {
                        recursive = false;
                        statements = [
                          {
                            operator = "=";
                            target = [
                              {
                                kind = "identifier";
                                value = "home";
                              }
                            ];
                            type = "assignment";
                            value = {
                              recursive = false;
                              statements = [
                                {
                                  operator = "=";
                                  target = [
                                    {
                                      kind = "identifier";
                                      value = "stateVersion";
                                    }
                                  ];
                                  type = "assignment";
                                  value = {
                                    multiline = false;
                                    parts = [
                                      {
                                        type = "text";
                                        value = "26.05";
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
                                      value = "username";
                                    }
                                  ];
                                  type = "assignment";
                                  value = {
                                    name = "path";
                                    path = [
                                      {
                                        kind = "identifier";
                                        value = "userName";
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
                                      value = "homeDirectory";
                                    }
                                  ];
                                  type = "assignment";
                                  value = {
                                    name = "v";
                                    path = [
                                      {
                                        kind = "identifier";
                                        value = "oobeHome";
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
                                value = "xdg";
                              }
                            ];
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
                                      value = "configHome";
                                    }
                                  ];
                                  type = "assignment";
                                  value = {
                                    multiline = false;
                                    parts = [
                                      {
                                        expression = {
                                          name = "v";
                                          path = [
                                            {
                                              kind = "identifier";
                                              value = "oobeHome";
                                            }
                                          ];
                                          type = "variable";
                                        };
                                        type = "interpolation";
                                      }
                                      {
                                        type = "text";
                                        value = "/.private/Config";
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
                                      value = "dataHome";
                                    }
                                  ];
                                  type = "assignment";
                                  value = {
                                    multiline = false;
                                    parts = [
                                      {
                                        expression = {
                                          name = "v";
                                          path = [
                                            {
                                              kind = "identifier";
                                              value = "oobeHome";
                                            }
                                          ];
                                          type = "variable";
                                        };
                                        type = "interpolation";
                                      }
                                      {
                                        type = "text";
                                        value = "/.private/Packages";
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
                                      value = "cacheHome";
                                    }
                                  ];
                                  type = "assignment";
                                  value = {
                                    multiline = false;
                                    parts = [
                                      {
                                        expression = {
                                          name = "v";
                                          path = [
                                            {
                                              kind = "identifier";
                                              value = "oobeHome";
                                            }
                                          ];
                                          type = "variable";
                                        };
                                        type = "interpolation";
                                      }
                                      {
                                        type = "text";
                                        value = "/.private/Live";
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
                                      value = "stateHome";
                                    }
                                  ];
                                  type = "assignment";
                                  value = {
                                    multiline = false;
                                    parts = [
                                      {
                                        expression = {
                                          name = "v";
                                          path = [
                                            {
                                              kind = "identifier";
                                              value = "oobeHome";
                                            }
                                          ];
                                          type = "variable";
                                        };
                                        type = "interpolation";
                                      }
                                      {
                                        type = "text";
                                        value = "/.private/State";
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
                            operator = "=";
                            target = [
                              {
                                kind = "identifier";
                                value = "xdg";
                              }
                              {
                                kind = "identifier";
                                value = "dataFile";
                              }
                              {
                                kind = "string";
                                value = "themes/ClockOverride/gnome-shell/gnome-shell.css";
                              }
                              {
                                kind = "identifier";
                                value = "text";
                              }
                            ];
                            type = "assignment";
                            value = {
                              multiline = true;
                              parts = [
                                {
                                  type = "text";
                                  value = "\n        @import url(\"resource:///org/gnome/shell/theme/default.css\");\n        .clock-display {\n          font-family: \"Zero\", sans-serif !important;\n          font-size: 12px;\n          font-style: normal !important;\n          font-weight: normal !important;\n          letter-spacing: 0 !important;\n        }\n      ";
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
                                          value = "org/gnome/shell";
                                        }
                                      ];
                                      type = "assignment";
                                      value = {
                                        recursive = false;
                                        statements = [
                                          {
                                            operator = "=";
                                            target = [
                                              {
                                                kind = "identifier";
                                                value = "disable-user-extensions";
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
                                                value = "enabled-extensions";
                                              }
                                            ];
                                            type = "assignment";
                                            value = {
                                              left = {
                                                name = "path";
                                                path = [
                                                  {
                                                    kind = "identifier";
                                                    value = "extraExtensionUuids";
                                                  }
                                                ];
                                                type = "variable";
                                              };
                                              operator = "++";
                                              right = {
                                                items = [
                                                  {
                                                    name = "v";
                                                    path = [
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
                                              type = "binary";
                                            };
                                          }
                                          {
                                            operator = "=";
                                            target = [
                                              {
                                                kind = "identifier";
                                                value = "favorite-apps";
                                              }
                                            ];
                                            type = "assignment";
                                            value = {
                                              arguments = [
                                                {
                                                  name = "lib";
                                                  path = [
                                                    {
                                                      kind = "identifier";
                                                      value = "gvariant";
                                                    }
                                                    {
                                                      kind = "identifier";
                                                      value = "type";
                                                    }
                                                    {
                                                      kind = "identifier";
                                                      value = "string";
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
                                                    value = "mkEmptyArray";
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
                                          value = "org/gnome/desktop/interface";
                                        }
                                      ];
                                      type = "assignment";
                                      value = {
                                        recursive = false;
                                        statements = [
                                          {
                                            operator = "=";
                                            target = [
                                              {
                                                kind = "identifier";
                                                value = "color-scheme";
                                              }
                                            ];
                                            type = "assignment";
                                            value = {
                                              multiline = false;
                                              parts = [
                                                {
                                                  type = "text";
                                                  value = "prefer-dark";
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
                                                value = "enable-animations";
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
                                                value = "cursor-theme";
                                              }
                                            ];
                                            type = "assignment";
                                            value = {
                                              multiline = false;
                                              parts = [
                                                {
                                                  type = "text";
                                                  value = "GoogleDot-Black";
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
                                                value = "cursor-size";
                                              }
                                            ];
                                            type = "assignment";
                                            value = {
                                              arguments = [
                                                {
                                                  kind = "integer";
                                                  type = "literal";
                                                  value = 24;
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
                                                value = "font-name";
                                              }
                                            ];
                                            type = "assignment";
                                            value = {
                                              multiline = false;
                                              parts = [
                                                {
                                                  type = "text";
                                                  value = "Atkinson Hyperlegible Next 11";
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
                                                value = "document-font-name";
                                              }
                                            ];
                                            type = "assignment";
                                            value = {
                                              multiline = false;
                                              parts = [
                                                {
                                                  type = "text";
                                                  value = "Atkinson Hyperlegible Next 11";
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
                                                value = "monospace-font-name";
                                              }
                                            ];
                                            type = "assignment";
                                            value = {
                                              multiline = false;
                                              parts = [
                                                {
                                                  type = "text";
                                                  value = "AtkynsonMono NF 11";
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
                                      operator = "=";
                                      target = [
                                        {
                                          kind = "string";
                                          value = "org/gnome/desktop/background";
                                        }
                                      ];
                                      type = "assignment";
                                      value = {
                                        recursive = false;
                                        statements = [
                                          {
                                            operator = "=";
                                            target = [
                                              {
                                                kind = "identifier";
                                                value = "color-shading-type";
                                              }
                                            ];
                                            type = "assignment";
                                            value = {
                                              multiline = false;
                                              parts = [
                                                {
                                                  type = "text";
                                                  value = "solid";
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
                                                value = "picture-options";
                                              }
                                            ];
                                            type = "assignment";
                                            value = {
                                              multiline = false;
                                              parts = [
                                                {
                                                  type = "text";
                                                  value = "none";
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
                                                value = "picture-uri";
                                              }
                                            ];
                                            type = "assignment";
                                            value = {
                                              multiline = false;
                                              parts = [
                                                {
                                                  type = "text";
                                                  value = "file://";
                                                }
                                                {
                                                  expression = {
                                                    name = "v";
                                                    path = [
                                                      {
                                                        kind = "identifier";
                                                        value = "blackWallpaper";
                                                      }
                                                    ];
                                                    type = "variable";
                                                  };
                                                  type = "interpolation";
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
                                                value = "picture-uri-dark";
                                              }
                                            ];
                                            type = "assignment";
                                            value = {
                                              multiline = false;
                                              parts = [
                                                {
                                                  type = "text";
                                                  value = "file://";
                                                }
                                                {
                                                  expression = {
                                                    name = "v";
                                                    path = [
                                                      {
                                                        kind = "identifier";
                                                        value = "blackWallpaper";
                                                      }
                                                    ];
                                                    type = "variable";
                                                  };
                                                  type = "interpolation";
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
                                                value = "primary-color";
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
                                                value = "secondary-color";
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
                                        ];
                                        type = "attr-set";
                                      };
                                    }
                                    {
                                      operator = "=";
                                      target = [
                                        {
                                          kind = "string";
                                          value = "org/gnome/desktop/lockdown";
                                        }
                                      ];
                                      type = "assignment";
                                      value = {
                                        recursive = false;
                                        statements = [
                                          {
                                            operator = "=";
                                            target = [
                                              {
                                                kind = "identifier";
                                                value = "disable-lock-screen";
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
                                                value = "disable-log-out";
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
                                                value = "disable-user-switching";
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
                                          kind = "string";
                                          value = "org/gnome/desktop/session";
                                        }
                                        {
                                          kind = "identifier";
                                          value = "idle-delay";
                                        }
                                      ];
                                      type = "assignment";
                                      value = {
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
                                          kind = "string";
                                          value = "org/gnome/desktop/screensaver";
                                        }
                                        {
                                          kind = "identifier";
                                          value = "lock-enabled";
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
                                          kind = "string";
                                          value = "org/gnome/shell/extensions/user-theme";
                                        }
                                        {
                                          kind = "identifier";
                                          value = "name";
                                        }
                                      ];
                                      type = "assignment";
                                      value = {
                                        multiline = false;
                                        parts = [
                                          {
                                            type = "text";
                                            value = "ClockOverride";
                                          }
                                        ];
                                        type = "string";
                                      };
                                    }
                                    {
                                      operator = "=";
                                      target = [
                                        {
                                          kind = "string";
                                          value = "org/gnome/shell/extensions/date-menu-formatter";
                                        }
                                      ];
                                      type = "assignment";
                                      value = {
                                        recursive = false;
                                        statements = [
                                          {
                                            operator = "=";
                                            target = [
                                              {
                                                kind = "identifier";
                                                value = "formatter";
                                              }
                                            ];
                                            type = "assignment";
                                            value = {
                                              multiline = false;
                                              parts = [
                                                {
                                                  type = "text";
                                                  value = "01_luxon";
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
                                                value = "pattern";
                                              }
                                            ];
                                            type = "assignment";
                                            value = {
                                              multiline = false;
                                              parts = [
                                                {
                                                  type = "text";
                                                  value = "dd.MM  HH:mm";
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
                                                value = "font-size";
                                              }
                                            ];
                                            type = "assignment";
                                            value = {
                                              arguments = [
                                                {
                                                  kind = "integer";
                                                  type = "literal";
                                                  value = 12;
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
                                                value = "update-level";
                                              }
                                            ];
                                            type = "assignment";
                                            value = {
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
                                                value = "text-align";
                                              }
                                            ];
                                            type = "assignment";
                                            value = {
                                              multiline = false;
                                              parts = [
                                                {
                                                  type = "text";
                                                  value = "center";
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
                                      operator = "=";
                                      target = [
                                        {
                                          kind = "string";
                                          value = "org/gnome/settings-daemon/plugins/power";
                                        }
                                      ];
                                      type = "assignment";
                                      value = {
                                        recursive = false;
                                        statements = [
                                          {
                                            operator = "=";
                                            target = [
                                              {
                                                kind = "identifier";
                                                value = "sleep-inactive-ac-type";
                                              }
                                            ];
                                            type = "assignment";
                                            value = {
                                              multiline = false;
                                              parts = [
                                                {
                                                  type = "text";
                                                  value = "nothing";
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
                                                value = "sleep-inactive-battery-type";
                                              }
                                            ];
                                            type = "assignment";
                                            value = {
                                              multiline = false;
                                              parts = [
                                                {
                                                  type = "text";
                                                  value = "nothing";
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
                                    value = "locks";
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
                                          value = "/org/gnome/shell/disable-user-extensions";
                                        }
                                      ];
                                      type = "string";
                                    }
                                    {
                                      multiline = false;
                                      parts = [
                                        {
                                          type = "text";
                                          value = "/org/gnome/shell/enabled-extensions";
                                        }
                                      ];
                                      type = "string";
                                    }
                                  ];
                                  type = "list";
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
                          value = "tmpfiles";
                        }
                        {
                          kind = "identifier";
                          value = "rules";
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
                                value = "d ";
                              }
                              {
                                expression = {
                                  name = "v";
                                  path = [
                                    {
                                      kind = "identifier";
                                      value = "oobeHome";
                                    }
                                  ];
                                  type = "variable";
                                };
                                type = "interpolation";
                              }
                              {
                                type = "text";
                                value = "/.private 0700 ";
                              }
                              {
                                expression = {
                                  name = "path";
                                  path = [
                                    {
                                      kind = "identifier";
                                      value = "userName";
                                    }
                                  ];
                                  type = "variable";
                                };
                                type = "interpolation";
                              }
                              {
                                type = "text";
                                value = " users -";
                              }
                            ];
                            type = "string";
                          }
                          {
                            multiline = false;
                            parts = [
                              {
                                type = "text";
                                value = "d ";
                              }
                              {
                                expression = {
                                  name = "v";
                                  path = [
                                    {
                                      kind = "identifier";
                                      value = "oobeHome";
                                    }
                                  ];
                                  type = "variable";
                                };
                                type = "interpolation";
                              }
                              {
                                type = "text";
                                value = "/.private/Packages 0700 ";
                              }
                              {
                                expression = {
                                  name = "path";
                                  path = [
                                    {
                                      kind = "identifier";
                                      value = "userName";
                                    }
                                  ];
                                  type = "variable";
                                };
                                type = "interpolation";
                              }
                              {
                                type = "text";
                                value = " users -";
                              }
                            ];
                            type = "string";
                          }
                          {
                            multiline = false;
                            parts = [
                              {
                                type = "text";
                                value = "d ";
                              }
                              {
                                expression = {
                                  name = "v";
                                  path = [
                                    {
                                      kind = "identifier";
                                      value = "oobeHome";
                                    }
                                  ];
                                  type = "variable";
                                };
                                type = "interpolation";
                              }
                              {
                                type = "text";
                                value = "/.private/Packages/gnome-shell 0700 ";
                              }
                              {
                                expression = {
                                  name = "path";
                                  path = [
                                    {
                                      kind = "identifier";
                                      value = "userName";
                                    }
                                  ];
                                  type = "variable";
                                };
                                type = "interpolation";
                              }
                              {
                                type = "text";
                                value = " users -";
                              }
                            ];
                            type = "string";
                          }
                          {
                            multiline = false;
                            parts = [
                              {
                                type = "text";
                                value = "f ";
                              }
                              {
                                expression = {
                                  name = "v";
                                  path = [
                                    {
                                      kind = "identifier";
                                      value = "oobeHome";
                                    }
                                  ];
                                  type = "variable";
                                };
                                type = "interpolation";
                              }
                              {
                                type = "text";
                                value = "/.private/Packages/gnome-shell/lock-warning-shown 0600 ";
                              }
                              {
                                expression = {
                                  name = "path";
                                  path = [
                                    {
                                      kind = "identifier";
                                      value = "userName";
                                    }
                                  ];
                                  type = "variable";
                                };
                                type = "interpolation";
                              }
                              {
                                type = "text";
                                value = " users -";
                              }
                            ];
                            type = "string";
                          }
                          {
                            multiline = false;
                            parts = [
                              {
                                type = "text";
                                value = "z /etc/ZenOS 0755 ";
                              }
                              {
                                expression = {
                                  name = "path";
                                  path = [
                                    {
                                      kind = "identifier";
                                      value = "userName";
                                    }
                                  ];
                                  type = "variable";
                                };
                                type = "interpolation";
                              }
                              {
                                type = "text";
                                value = " users -";
                              }
                            ];
                            type = "string";
                          }
                          {
                            multiline = false;
                            parts = [
                              {
                                type = "text";
                                value = "Z /etc/ZenOS - ";
                              }
                              {
                                expression = {
                                  name = "path";
                                  path = [
                                    {
                                      kind = "identifier";
                                      value = "userName";
                                    }
                                  ];
                                  type = "variable";
                                };
                                type = "interpolation";
                              }
                              {
                                type = "text";
                                value = " users -";
                              }
                            ];
                            type = "string";
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
            value = "setupPackage";
          }
        ];
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
                          value = "package";
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
                      name = "pkgs";
                      path = [
                        {
                          kind = "identifier";
                          value = "zenos";
                        }
                        {
                          kind = "identifier";
                          value = "byCategories";
                        }
                        {
                          kind = "identifier";
                          value = "apps";
                        }
                        {
                          kind = "identifier";
                          value = "system";
                        }
                        {
                          kind = "identifier";
                          value = "zenos-setup";
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
                        value = "summary";
                      }
                    ];
                    type = "assignment";
                    value = {
                      multiline = false;
                      parts = [
                        {
                          type = "text";
                          value = "Setup application package launched by OOBE";
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
                      multiline = false;
                      parts = [
                        {
                          type = "text";
                          value = "pkgs.zenos.setup";
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
            value = "extensionPackage";
          }
        ];
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
                          value = "package";
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
                      name = "pkgs";
                      path = [
                        {
                          kind = "identifier";
                          value = "zenos";
                        }
                        {
                          kind = "identifier";
                          value = "byCategories";
                        }
                        {
                          kind = "identifier";
                          value = "system";
                        }
                        {
                          kind = "identifier";
                          value = "zenos-oobe-mode";
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
                        value = "summary";
                      }
                    ];
                    type = "assignment";
                    value = {
                      multiline = false;
                      parts = [
                        {
                          type = "text";
                          value = "GNOME Shell extension and mode package for OOBE";
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
                      multiline = false;
                      parts = [
                        {
                          type = "text";
                          value = "pkgs.zenos.oobe-extension";
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
            value = "extraExtensionPackages";
          }
        ];
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
                                  value = "package";
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
                          name = "pkgs";
                          path = [
                            {
                              kind = "identifier";
                              value = "zenos";
                            }
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
                              value = "date-menu-formatter";
                            }
                          ];
                          type = "variable";
                        }
                        {
                          name = "pkgs";
                          path = [
                            {
                              kind = "identifier";
                              value = "zenos";
                            }
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
                              value = "user-themes";
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
                        value = "summary";
                      }
                    ];
                    type = "assignment";
                    value = {
                      multiline = false;
                      parts = [
                        {
                          type = "text";
                          value = "Additional OOBE GNOME extension packages";
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
            value = "extraExtensionUuids";
          }
        ];
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
                              value = "date-menu-formatter@marcinjakubowski.github.com";
                            }
                          ];
                          type = "string";
                        }
                        {
                          multiline = false;
                          parts = [
                            {
                              type = "text";
                              value = "user-theme@gnome-shell-extensions.gcampax.github.com";
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
                        value = "summary";
                      }
                    ];
                    type = "assignment";
                    value = {
                      multiline = false;
                      parts = [
                        {
                          type = "text";
                          value = "Additional OOBE GNOME extension UUIDs";
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
            value = "authorizedKeys";
          }
        ];
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
                      items = [ ];
                      type = "list";
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
                          value = "SSH keys accepted by the OOBE account";
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
            value = "userName";
          }
        ];
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
                          value = "zenos";
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
                        value = "summary";
                      }
                    ];
                    type = "assignment";
                    value = {
                      multiline = false;
                      parts = [
                        {
                          type = "text";
                          value = "Temporary OOBE account name";
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
    (let extensionUuid = (builtins.addErrorContext "_let extensionUuid annotation mismatch: /nix/store/59qqzf108ga8h2qmsjizzsn2p7i889xx-zenpkgs-dsl-source/modules/system/oobe.zmdl:17:1" ((_zenType: _zenValue: let force = type: value: if type.name == "anything" then true else if type.name == "listOf" then builtins.all (force type.nestedTypes.elemType) value else if type.name == "attrsOf" then builtins.all (force type.nestedTypes.elemType) (builtins.attrValues value) else if type.name == "either" then force (if type.nestedTypes.left.check value then type.nestedTypes.left else type.nestedTypes.right) value else builtins.seq value true; in builtins.seq (force _zenType _zenValue) _zenValue) (lib.types.str) ((lib.evalModules { modules = [ { options.value = lib.mkOption { type = lib.types.str; }; config.value = "zenos-oobe-mode@neg-zero.com"; } ]; }).config.value))); servicePath = (builtins.addErrorContext "_let servicePath annotation mismatch: /nix/store/59qqzf108ga8h2qmsjizzsn2p7i889xx-zenpkgs-dsl-source/modules/system/oobe.zmdl:18:1" ((_zenType: _zenValue: let force = type: value: if type.name == "anything" then true else if type.name == "listOf" then builtins.all (force type.nestedTypes.elemType) value else if type.name == "attrsOf" then builtins.all (force type.nestedTypes.elemType) (builtins.attrValues value) else if type.name == "either" then force (if type.nestedTypes.left.check value then type.nestedTypes.left else type.nestedTypes.right) value else builtins.seq value true; in builtins.seq (force _zenType _zenValue) _zenValue) (lib.types.str) ((lib.evalModules { modules = [ { options.value = lib.mkOption { type = lib.types.str; }; config.value = "/run/wrappers/bin:/run/current-system/sw/bin"; } ]; }).config.value))); oobeHome = (builtins.addErrorContext "_let oobeHome annotation mismatch: /nix/store/59qqzf108ga8h2qmsjizzsn2p7i889xx-zenpkgs-dsl-source/modules/system/oobe.zmdl:19:1" ((_zenType: _zenValue: let force = type: value: if type.name == "anything" then true else if type.name == "listOf" then builtins.all (force type.nestedTypes.elemType) value else if type.name == "attrsOf" then builtins.all (force type.nestedTypes.elemType) (builtins.attrValues value) else if type.name == "either" then force (if type.nestedTypes.left.check value then type.nestedTypes.left else type.nestedTypes.right) value else builtins.seq value true; in builtins.seq (force _zenType _zenValue) _zenValue) (lib.types.str) ((lib.evalModules { modules = [ { options.value = lib.mkOption { type = lib.types.str; }; config.value = "/run/zenos-oobe"; } ]; }).config.value))); blackWallpaper = (builtins.addErrorContext "_let blackWallpaper annotation mismatch: /nix/store/59qqzf108ga8h2qmsjizzsn2p7i889xx-zenpkgs-dsl-source/modules/system/oobe.zmdl:20:1" ((_zenType: _zenValue: let force = type: value: if type.name == "anything" then true else if type.name == "listOf" then builtins.all (force type.nestedTypes.elemType) value else if type.name == "attrsOf" then builtins.all (force type.nestedTypes.elemType) (builtins.attrValues value) else if type.name == "either" then force (if type.nestedTypes.left.check value then type.nestedTypes.left else type.nestedTypes.right) value else builtins.seq value true; in builtins.seq (force _zenType _zenValue) _zenValue) (lib.types.package) ((lib.evalModules { modules = [ { options.value = lib.mkOption { type = lib.types.package; }; config.value = ((pkgs.zenos.legacy.writeText "zenos-oobe-black.svg") "\n  <svg xmlns=\"http://www.w3.org/2000/svg\" width=\"1\" height=\"1\">\n    <rect width=\"1\" height=\"1\" fill=\"#000000\"/>\n  </svg>\n"); } ]; }).config.value))); in (lib.mkIf ((cfg.enable)) {
      services.desktopManager.gnome.enable = true;
      services.displayManager = {
        gdm.enable = (lib.mkForce false);
        sddm.enable = (lib.mkForce false);
        plasma-login-manager.enable = (lib.mkForce false);
        autoLogin.enable = (lib.mkForce false);
        autoLogin.user = (lib.mkForce null);
      };
      services.xserver.displayManager.lightdm.enable = (lib.mkForce false);
      services.openssh = {
        enable = true;
        openFirewall = true;
        settings = {
          KbdInteractiveAuthentication = false;
          PasswordAuthentication = true;
          PermitEmptyPasswords = true;
          PermitRootLogin = "no";
        };
      };
      services.gnome.gnome-initial-setup.enable = false;
      services.greetd = {
        enable = true;
        restart = false;
        settings = {
          initial_session = {
            user = cfg.userName;
          };
          default_session = {
            user = cfg.userName;
          };
        };
      };
      systemd.services.greetd.environment = {
        XDG_SESSION_TYPE = "wayland";
        XDG_SESSION_CLASS = "user";
        XDG_SESSION_DESKTOP = "GNOME";
      };
      environment.etc."xdg/gnome-session/sessions/zenos-oobe.session".text = "\n      [GNOME Session]\n      Name=ZenOS OOBE\n    ";
      systemd.user.targets."gnome-session@zenos-oobe" = {
        overrideStrategy = "asDropin";
        unitConfig.Requires = [
          "gnome-session-services.target"
          "org.gnome.Shell@zenos-oobe.service"
        ];
      };
      systemd.user.services."org.gnome.Shell@zenos-oobe" = {
        overrideStrategy = "asDropin";
        environment = {
          PATH = (lib.mkForce servicePath);
          ZENOS_OOBE = "1";
          GNOME_SHELL_SESSION_MODE = "zenos-oobe";
        };
      };
      systemd.user.services.zenos-oobe = {
        description = "ZenOS out-of-box experience";
        wantedBy = [
          "graphical-session.target"
        ];
        after = [
          "gnome-session.target"
        ];
        partOf = [
          "graphical-session.target"
        ];
        path = [ ];
        environment = {
          PATH = (lib.mkForce servicePath);
          ZENOS_OOBE = "1";
          ZENOS_SETUP_DRY_RUN = "0";
          GI_TYPELIB_PATH = ((lib.makeSearchPath "lib/girepository-1.0") [
            pkgs.zenos.legacy.gnome-desktop
            pkgs.zenos.legacy.libgweather
            pkgs.zenos.legacy.networkmanager
          ]);
        };
        unitConfig.ConditionUser = cfg.userName;
        serviceConfig = {
          Type = "exec";
          ExecStart = "${((value: let kind = builtins.typeOf value; in if kind == "string" then value else if kind == "bool" || kind == "int" || kind == "float" then builtins.toJSON value else if kind == "path" then "${value}" else if kind == "set" && (value.type or null) == "derivation" && builtins.isString (value.outPath or null) then value.outPath else throw "/nix/store/59qqzf108ga8h2qmsjizzsn2p7i889xx-zenpkgs-dsl-source/modules/system/oobe.zmdl:102: string interpolation requires a scalar, path, or package") ((lib.getExe cfg.setupPackage)))} --oobe";
          Restart = "on-failure";
          RestartSec = 2;
        };
      };
      users.mutableUsers = false;
      users.users.root.hashedPassword = "!";
      users.users.${cfg.userName} = {
        isNormalUser = true;
        description = "ZenOS Setup";
        home = oobeHome;
        createHome = true;
        homeMode = "0700";
        hashedPassword = "";
        openssh.authorizedKeys.keys = cfg.authorizedKeys;
        extraGroups = [
          "input"
          "networkmanager"
          "video"
          "wheel"
        ];
      };
      environment = {
        systemPackages = (with pkgs.zenos.legacy; (([
          acl
          attr
          bashInteractive
          bzip2
          coreutils-full
          cpio
          curl
          diffutils
          findutils
          gawk
          getent
          getconf
          gnugrep
          gnupatch
          gnused
          gnutar
          gzip
          xz
          less
          libcap
          ncurses
          netcat
          mkpasswd
          procps
          su
          time
          util-linux
          which
          zstd
          perl
          rsync
          strace
          atkinson-hyperlegible-next
          google-cursor
          nerd-fonts.atkynson-mono
        ] ++ [
          cfg.extensionPackage
          cfg.setupPackage
        ]) ++ cfg.extraExtensionPackages));
        pathsToLink = [
          "/bin"
          "/sbin"
          "/lib"
          "/libexec"
          "/share"
          "/share/gnome-shell/extensions"
          "/share/gnome-shell/modes"
        ];
        gnome.excludePackages = [
          pkgs.zenos.legacy.gnome-tour
        ];
      };
      fonts = {
        packages = (with pkgs.zenos.legacy; [
          atkinson-hyperlegible-next
          nerd-fonts.atkynson-mono
        ]);
        fontconfig.defaultFonts = {
          sansSerif = [
            "Atkinson Hyperlegible Next"
          ];
          monospace = [
            "AtkynsonMono NF"
          ];
        };
      };
      hardware.graphics.enable = true;
      security.sudo.wheelNeedsPassword = false;
      system.extraDependencies = [
        cfg.setupPackage.src
        cfg.extensionPackage.src
      ];
      programs.dconf.enable = true;
      home-manager.users.${cfg.userName} = {
        home = {
          stateVersion = "26.05";
          username = cfg.userName;
          homeDirectory = oobeHome;
        };
        xdg = {
          enable = true;
          configHome = "${((value: let kind = builtins.typeOf value; in if kind == "string" then value else if kind == "bool" || kind == "int" || kind == "float" then builtins.toJSON value else if kind == "path" then "${value}" else if kind == "set" && (value.type or null) == "derivation" && builtins.isString (value.outPath or null) then value.outPath else throw "/nix/store/59qqzf108ga8h2qmsjizzsn2p7i889xx-zenpkgs-dsl-source/modules/system/oobe.zmdl:159: string interpolation requires a scalar, path, or package") (oobeHome))}/.private/Config";
          dataHome = "${((value: let kind = builtins.typeOf value; in if kind == "string" then value else if kind == "bool" || kind == "int" || kind == "float" then builtins.toJSON value else if kind == "path" then "${value}" else if kind == "set" && (value.type or null) == "derivation" && builtins.isString (value.outPath or null) then value.outPath else throw "/nix/store/59qqzf108ga8h2qmsjizzsn2p7i889xx-zenpkgs-dsl-source/modules/system/oobe.zmdl:160: string interpolation requires a scalar, path, or package") (oobeHome))}/.private/Packages";
          cacheHome = "${((value: let kind = builtins.typeOf value; in if kind == "string" then value else if kind == "bool" || kind == "int" || kind == "float" then builtins.toJSON value else if kind == "path" then "${value}" else if kind == "set" && (value.type or null) == "derivation" && builtins.isString (value.outPath or null) then value.outPath else throw "/nix/store/59qqzf108ga8h2qmsjizzsn2p7i889xx-zenpkgs-dsl-source/modules/system/oobe.zmdl:161: string interpolation requires a scalar, path, or package") (oobeHome))}/.private/Live";
          stateHome = "${((value: let kind = builtins.typeOf value; in if kind == "string" then value else if kind == "bool" || kind == "int" || kind == "float" then builtins.toJSON value else if kind == "path" then "${value}" else if kind == "set" && (value.type or null) == "derivation" && builtins.isString (value.outPath or null) then value.outPath else throw "/nix/store/59qqzf108ga8h2qmsjizzsn2p7i889xx-zenpkgs-dsl-source/modules/system/oobe.zmdl:162: string interpolation requires a scalar, path, or package") (oobeHome))}/.private/State";
        };
        xdg.dataFile."themes/ClockOverride/gnome-shell/gnome-shell.css".text = "\n        @import url(\"resource:///org/gnome/shell/theme/default.css\");\n        .clock-display {\n          font-family: \"Zero\", sans-serif !important;\n          font-size: 12px;\n          font-style: normal !important;\n          font-weight: normal !important;\n          letter-spacing: 0 !important;\n        }\n      ";
      };
      programs.dconf.profiles.user.databases = [
        {
          settings = {
            "org/gnome/shell" = {
              disable-user-extensions = false;
              enabled-extensions = (cfg.extraExtensionUuids ++ [
                extensionUuid
              ]);
              favorite-apps = (lib.gvariant.mkEmptyArray lib.gvariant.type.string);
            };
            "org/gnome/desktop/interface" = {
              color-scheme = "prefer-dark";
              enable-animations = true;
              cursor-theme = "GoogleDot-Black";
              cursor-size = (lib.gvariant.mkInt32 24);
              font-name = "Atkinson Hyperlegible Next 11";
              document-font-name = "Atkinson Hyperlegible Next 11";
              monospace-font-name = "AtkynsonMono NF 11";
            };
            "org/gnome/desktop/background" = {
              color-shading-type = "solid";
              picture-options = "none";
              picture-uri = "file://${((value: let kind = builtins.typeOf value; in if kind == "string" then value else if kind == "bool" || kind == "int" || kind == "float" then builtins.toJSON value else if kind == "path" then "${value}" else if kind == "set" && (value.type or null) == "derivation" && builtins.isString (value.outPath or null) then value.outPath else throw "/nix/store/59qqzf108ga8h2qmsjizzsn2p7i889xx-zenpkgs-dsl-source/modules/system/oobe.zmdl:195: string interpolation requires a scalar, path, or package") (blackWallpaper))}";
              picture-uri-dark = "file://${((value: let kind = builtins.typeOf value; in if kind == "string" then value else if kind == "bool" || kind == "int" || kind == "float" then builtins.toJSON value else if kind == "path" then "${value}" else if kind == "set" && (value.type or null) == "derivation" && builtins.isString (value.outPath or null) then value.outPath else throw "/nix/store/59qqzf108ga8h2qmsjizzsn2p7i889xx-zenpkgs-dsl-source/modules/system/oobe.zmdl:196: string interpolation requires a scalar, path, or package") (blackWallpaper))}";
              primary-color = "#000000";
              secondary-color = "#000000";
            };
            "org/gnome/desktop/lockdown" = {
              disable-lock-screen = true;
              disable-log-out = true;
              disable-user-switching = true;
            };
            "org/gnome/desktop/session".idle-delay = (lib.gvariant.mkUint32 0);
            "org/gnome/desktop/screensaver".lock-enabled = false;
            "org/gnome/shell/extensions/user-theme".name = "ClockOverride";
            "org/gnome/shell/extensions/date-menu-formatter" = {
              formatter = "01_luxon";
              pattern = "dd.MM  HH:mm";
              font-size = (lib.gvariant.mkInt32 12);
              update-level = (lib.gvariant.mkInt32 1);
              text-align = "center";
            };
            "org/gnome/settings-daemon/plugins/power" = {
              sleep-inactive-ac-type = "nothing";
              sleep-inactive-battery-type = "nothing";
            };
          };
          locks = [
            "/org/gnome/shell/disable-user-extensions"
            "/org/gnome/shell/enabled-extensions"
          ];
        }
      ];
      systemd.tmpfiles.rules = [
        "d ${((value: let kind = builtins.typeOf value; in if kind == "string" then value else if kind == "bool" || kind == "int" || kind == "float" then builtins.toJSON value else if kind == "path" then "${value}" else if kind == "set" && (value.type or null) == "derivation" && builtins.isString (value.outPath or null) then value.outPath else throw "/nix/store/59qqzf108ga8h2qmsjizzsn2p7i889xx-zenpkgs-dsl-source/modules/system/oobe.zmdl:227: string interpolation requires a scalar, path, or package") (oobeHome))}/.private 0700 ${((value: let kind = builtins.typeOf value; in if kind == "string" then value else if kind == "bool" || kind == "int" || kind == "float" then builtins.toJSON value else if kind == "path" then "${value}" else if kind == "set" && (value.type or null) == "derivation" && builtins.isString (value.outPath or null) then value.outPath else throw "/nix/store/59qqzf108ga8h2qmsjizzsn2p7i889xx-zenpkgs-dsl-source/modules/system/oobe.zmdl:227: string interpolation requires a scalar, path, or package") (cfg.userName))} users -"
        "d ${((value: let kind = builtins.typeOf value; in if kind == "string" then value else if kind == "bool" || kind == "int" || kind == "float" then builtins.toJSON value else if kind == "path" then "${value}" else if kind == "set" && (value.type or null) == "derivation" && builtins.isString (value.outPath or null) then value.outPath else throw "/nix/store/59qqzf108ga8h2qmsjizzsn2p7i889xx-zenpkgs-dsl-source/modules/system/oobe.zmdl:228: string interpolation requires a scalar, path, or package") (oobeHome))}/.private/Packages 0700 ${((value: let kind = builtins.typeOf value; in if kind == "string" then value else if kind == "bool" || kind == "int" || kind == "float" then builtins.toJSON value else if kind == "path" then "${value}" else if kind == "set" && (value.type or null) == "derivation" && builtins.isString (value.outPath or null) then value.outPath else throw "/nix/store/59qqzf108ga8h2qmsjizzsn2p7i889xx-zenpkgs-dsl-source/modules/system/oobe.zmdl:228: string interpolation requires a scalar, path, or package") (cfg.userName))} users -"
        "d ${((value: let kind = builtins.typeOf value; in if kind == "string" then value else if kind == "bool" || kind == "int" || kind == "float" then builtins.toJSON value else if kind == "path" then "${value}" else if kind == "set" && (value.type or null) == "derivation" && builtins.isString (value.outPath or null) then value.outPath else throw "/nix/store/59qqzf108ga8h2qmsjizzsn2p7i889xx-zenpkgs-dsl-source/modules/system/oobe.zmdl:229: string interpolation requires a scalar, path, or package") (oobeHome))}/.private/Packages/gnome-shell 0700 ${((value: let kind = builtins.typeOf value; in if kind == "string" then value else if kind == "bool" || kind == "int" || kind == "float" then builtins.toJSON value else if kind == "path" then "${value}" else if kind == "set" && (value.type or null) == "derivation" && builtins.isString (value.outPath or null) then value.outPath else throw "/nix/store/59qqzf108ga8h2qmsjizzsn2p7i889xx-zenpkgs-dsl-source/modules/system/oobe.zmdl:229: string interpolation requires a scalar, path, or package") (cfg.userName))} users -"
        "f ${((value: let kind = builtins.typeOf value; in if kind == "string" then value else if kind == "bool" || kind == "int" || kind == "float" then builtins.toJSON value else if kind == "path" then "${value}" else if kind == "set" && (value.type or null) == "derivation" && builtins.isString (value.outPath or null) then value.outPath else throw "/nix/store/59qqzf108ga8h2qmsjizzsn2p7i889xx-zenpkgs-dsl-source/modules/system/oobe.zmdl:230: string interpolation requires a scalar, path, or package") (oobeHome))}/.private/Packages/gnome-shell/lock-warning-shown 0600 ${((value: let kind = builtins.typeOf value; in if kind == "string" then value else if kind == "bool" || kind == "int" || kind == "float" then builtins.toJSON value else if kind == "path" then "${value}" else if kind == "set" && (value.type or null) == "derivation" && builtins.isString (value.outPath or null) then value.outPath else throw "/nix/store/59qqzf108ga8h2qmsjizzsn2p7i889xx-zenpkgs-dsl-source/modules/system/oobe.zmdl:230: string interpolation requires a scalar, path, or package") (cfg.userName))} users -"
        "z /etc/ZenOS 0755 ${((value: let kind = builtins.typeOf value; in if kind == "string" then value else if kind == "bool" || kind == "int" || kind == "float" then builtins.toJSON value else if kind == "path" then "${value}" else if kind == "set" && (value.type or null) == "derivation" && builtins.isString (value.outPath or null) then value.outPath else throw "/nix/store/59qqzf108ga8h2qmsjizzsn2p7i889xx-zenpkgs-dsl-source/modules/system/oobe.zmdl:231: string interpolation requires a scalar, path, or package") (cfg.userName))} users -"
        "Z /etc/ZenOS - ${((value: let kind = builtins.typeOf value; in if kind == "string" then value else if kind == "bool" || kind == "int" || kind == "float" then builtins.toJSON value else if kind == "path" then "${value}" else if kind == "set" && (value.type or null) == "derivation" && builtins.isString (value.outPath or null) then value.outPath else throw "/nix/store/59qqzf108ga8h2qmsjizzsn2p7i889xx-zenpkgs-dsl-source/modules/system/oobe.zmdl:232: string interpolation requires a scalar, path, or package") (cfg.userName))} users -"
      ];
    }))
  ];
}
