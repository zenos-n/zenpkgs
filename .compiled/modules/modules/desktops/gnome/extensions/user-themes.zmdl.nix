{ config, lib, pkgs, maintainers ? lib.maintainers, licenses ? lib.licenses, ... }:
let
  cfg = config.zenos.desktops.gnome.extensions.user-themes;
  name = "user-themes";
  effectiveName = (builtins.addErrorContext "_let effectiveName annotation mismatch: /nix/store/59qqzf108ga8h2qmsjizzsn2p7i889xx-zenpkgs-dsl-source/modules/desktops/gnome/extensions/user-themes.zmdl:21:1" ((_zenType: _zenValue: let force = type: value: if type.name == "anything" then true else if type.name == "listOf" then builtins.all (force type.nestedTypes.elemType) value else if type.name == "attrsOf" then builtins.all (force type.nestedTypes.elemType) (builtins.attrValues value) else if type.name == "either" then force (if type.nestedTypes.left.check value then type.nestedTypes.left else type.nestedTypes.right) value else builtins.seq value true; in builtins.seq (force _zenType _zenValue) _zenValue) (lib.types.str) ((lib.evalModules { modules = [ { options.value = lib.mkOption { type = lib.types.str; }; config.value = (if (cfg.theme.cssOverride != "") then ((if (cfg.name != "") then cfg.name else "zenos-override")) else cfg.name); } ]; }).config.value)));
  generatedTheme = (builtins.addErrorContext "_let generatedTheme annotation mismatch: /nix/store/59qqzf108ga8h2qmsjizzsn2p7i889xx-zenpkgs-dsl-source/modules/desktops/gnome/extensions/user-themes.zmdl:26:1" ((_zenType: _zenValue: let force = type: value: if type.name == "anything" then true else if type.name == "listOf" then builtins.all (force type.nestedTypes.elemType) value else if type.name == "attrsOf" then builtins.all (force type.nestedTypes.elemType) (builtins.attrValues value) else if type.name == "either" then force (if type.nestedTypes.left.check value then type.nestedTypes.left else type.nestedTypes.right) value else builtins.seq value true; in builtins.seq (force _zenType _zenValue) _zenValue) (lib.types.package) ((lib.evalModules { modules = [ { options.value = lib.mkOption { type = lib.types.package; }; config.value = (pkgs.zenos.legacy.writeTextFile {
    name = "zenos-generated-theme";
    destination = "/share/themes/${((value: let kind = builtins.typeOf value; in if kind == "string" then value else if kind == "bool" || kind == "int" || kind == "float" then builtins.toJSON value else if kind == "path" then "${value}" else if kind == "set" && (value.type or null) == "derivation" && builtins.isString (value.outPath or null) then value.outPath else throw "/nix/store/59qqzf108ga8h2qmsjizzsn2p7i889xx-zenpkgs-dsl-source/modules/desktops/gnome/extensions/user-themes.zmdl:28: string interpolation requires a scalar, path, or package") (effectiveName))}/gnome-shell/gnome-shell.css";
    text = "\n    /* Default GNOME Shell Theme */\n    @import url(\"resource:///org/gnome/shell/theme/default.css\");\n\n    /* Parent/Active Theme Import (if specified) */\n    ${((value: let kind = builtins.typeOf value; in if kind == "string" then value else if kind == "bool" || kind == "int" || kind == "float" then builtins.toJSON value else if kind == "path" then "${value}" else if kind == "set" && (value.type or null) == "derivation" && builtins.isString (value.outPath or null) then value.outPath else throw "/nix/store/59qqzf108ga8h2qmsjizzsn2p7i889xx-zenpkgs-dsl-source/modules/desktops/gnome/extensions/user-themes.zmdl:34: string interpolation requires a scalar, path, or package") (((lib.optionalString ((cfg.theme.activeTheme != ""))) "\n      @import url(\"file:///run/current-system/sw/share/themes/${((value: let kind = builtins.typeOf value; in if kind == "string" then value else if kind == "bool" || kind == "int" || kind == "float" then builtins.toJSON value else if kind == "path" then "${value}" else if kind == "set" && (value.type or null) == "derivation" && builtins.isString (value.outPath or null) then value.outPath else throw "/nix/store/59qqzf108ga8h2qmsjizzsn2p7i889xx-zenpkgs-dsl-source/modules/desktops/gnome/extensions/user-themes.zmdl:35: string interpolation requires a scalar, path, or package") (cfg.theme.activeTheme))}/gnome-shell/gnome-shell.css\");\n    ")))}\n\n    /* Zenos CSS Overrides */\n    ${((value: let kind = builtins.typeOf value; in if kind == "string" then value else if kind == "bool" || kind == "int" || kind == "float" then builtins.toJSON value else if kind == "path" then "${value}" else if kind == "set" && (value.type or null) == "derivation" && builtins.isString (value.outPath or null) then value.outPath else throw "/nix/store/59qqzf108ga8h2qmsjizzsn2p7i889xx-zenpkgs-dsl-source/modules/desktops/gnome/extensions/user-themes.zmdl:39: string interpolation requires a scalar, path, or package") (cfg.theme.cssOverride))}\n  ";
  }); } ]; }).config.value)));
in
{
  options.zenos.desktops.gnome.extensions.user-themes = lib.mkOption { type = (lib.types.submodule ({ ... }: (let effectiveName = (builtins.addErrorContext "_let effectiveName annotation mismatch: /nix/store/59qqzf108ga8h2qmsjizzsn2p7i889xx-zenpkgs-dsl-source/modules/desktops/gnome/extensions/user-themes.zmdl:21:1" ((_zenType: _zenValue: let force = type: value: if type.name == "anything" then true else if type.name == "listOf" then builtins.all (force type.nestedTypes.elemType) value else if type.name == "attrsOf" then builtins.all (force type.nestedTypes.elemType) (builtins.attrValues value) else if type.name == "either" then force (if type.nestedTypes.left.check value then type.nestedTypes.left else type.nestedTypes.right) value else builtins.seq value true; in builtins.seq (force _zenType _zenValue) _zenValue) (lib.types.str) ((lib.evalModules { modules = [ { options.value = lib.mkOption { type = lib.types.str; }; config.value = (if (cfg.theme.cssOverride != "") then ((if (cfg.name != "") then cfg.name else "zenos-override")) else cfg.name); } ]; }).config.value))); generatedTheme = (builtins.addErrorContext "_let generatedTheme annotation mismatch: /nix/store/59qqzf108ga8h2qmsjizzsn2p7i889xx-zenpkgs-dsl-source/modules/desktops/gnome/extensions/user-themes.zmdl:26:1" ((_zenType: _zenValue: let force = type: value: if type.name == "anything" then true else if type.name == "listOf" then builtins.all (force type.nestedTypes.elemType) value else if type.name == "attrsOf" then builtins.all (force type.nestedTypes.elemType) (builtins.attrValues value) else if type.name == "either" then force (if type.nestedTypes.left.check value then type.nestedTypes.left else type.nestedTypes.right) value else builtins.seq value true; in builtins.seq (force _zenType _zenValue) _zenValue) (lib.types.package) ((lib.evalModules { modules = [ { options.value = lib.mkOption { type = lib.types.package; }; config.value = (pkgs.zenos.legacy.writeTextFile {
        name = "zenos-generated-theme";
        destination = "/share/themes/${((value: let kind = builtins.typeOf value; in if kind == "string" then value else if kind == "bool" || kind == "int" || kind == "float" then builtins.toJSON value else if kind == "path" then "${value}" else if kind == "set" && (value.type or null) == "derivation" && builtins.isString (value.outPath or null) then value.outPath else throw "/nix/store/59qqzf108ga8h2qmsjizzsn2p7i889xx-zenpkgs-dsl-source/modules/desktops/gnome/extensions/user-themes.zmdl:28: string interpolation requires a scalar, path, or package") (effectiveName))}/gnome-shell/gnome-shell.css";
        text = "\n    /* Default GNOME Shell Theme */\n    @import url(\"resource:///org/gnome/shell/theme/default.css\");\n\n    /* Parent/Active Theme Import (if specified) */\n    ${((value: let kind = builtins.typeOf value; in if kind == "string" then value else if kind == "bool" || kind == "int" || kind == "float" then builtins.toJSON value else if kind == "path" then "${value}" else if kind == "set" && (value.type or null) == "derivation" && builtins.isString (value.outPath or null) then value.outPath else throw "/nix/store/59qqzf108ga8h2qmsjizzsn2p7i889xx-zenpkgs-dsl-source/modules/desktops/gnome/extensions/user-themes.zmdl:34: string interpolation requires a scalar, path, or package") (((lib.optionalString ((cfg.theme.activeTheme != ""))) "\n      @import url(\"file:///run/current-system/sw/share/themes/${((value: let kind = builtins.typeOf value; in if kind == "string" then value else if kind == "bool" || kind == "int" || kind == "float" then builtins.toJSON value else if kind == "path" then "${value}" else if kind == "set" && (value.type or null) == "derivation" && builtins.isString (value.outPath or null) then value.outPath else throw "/nix/store/59qqzf108ga8h2qmsjizzsn2p7i889xx-zenpkgs-dsl-source/modules/desktops/gnome/extensions/user-themes.zmdl:35: string interpolation requires a scalar, path, or package") (cfg.theme.activeTheme))}/gnome-shell/gnome-shell.css\");\n    ")))}\n\n    /* Zenos CSS Overrides */\n    ${((value: let kind = builtins.typeOf value; in if kind == "string" then value else if kind == "bool" || kind == "int" || kind == "float" then builtins.toJSON value else if kind == "path" then "${value}" else if kind == "set" && (value.type or null) == "derivation" && builtins.isString (value.outPath or null) then value.outPath else throw "/nix/store/59qqzf108ga8h2qmsjizzsn2p7i889xx-zenpkgs-dsl-source/modules/desktops/gnome/extensions/user-themes.zmdl:39: string interpolation requires a scalar, path, or package") (cfg.theme.cssOverride))}\n  ";
      }); } ]; }).config.value))); in { options = { enable = lib.mkOption { type = lib.types.bool; default = false; description = "User Theme GNOME extension configuration"; }; name = lib.mkOption { type = lib.types.str; default = ""; description = "\n  Identifier for the shell theme to apply\n\n  The name of the theme directory found in /share/themes. If using\n  `cssOverride`, this becomes the directory name of the generated theme.\n"; }; theme = lib.mkOption { type = (lib.types.submodule ({ ... }: { options = { activeTheme = lib.mkOption { type = lib.types.str; default = ""; description = "\n  Base theme for CSS inheritance\n\n  The name of an installed theme (e.g., 'Orchis-Dark') to use as a\n  parent. This theme must be present in the system packages.\n"; }; cssOverride = lib.mkOption { type = lib.types.str; default = ""; description = "\n  Custom CSS rules for GNOME Shell\n\n  Raw CSS content to be appended to the shell's stylesheet. If\n  provided, a synthetic theme package is automatically generated.\n"; }; }; })); default = { }; }; }; }))); default = { }; };
  config = lib.mkMerge [
    { _module.args.zenlang.descriptors.desktops.gnome.extensions.user-themes = {
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
            value = "\n    Shell theme customization and dynamic theme generation\n\n    This module installs and configures the **User Themes** extension for GNOME.\n    It allows loading custom shell themes from the user's home directory and provides\n    logic to generate dynamic CSS overrides on top of existing themes.\n\n    **Features:**\n    - Enable custom GNOME Shell themes via dconf.\n    - Declaratively append CSS to themes using `cssOverride`.\n    - Inherit from installed system themes like Orchis or WhiteSur.\n  ";
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
            value = "Shell theme customization and dynamic theme generation";
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
    moduleIdentity = "zenos.desktops.gnome.extensions.user-themes";
    modulePath = [
      "desktops"
      "gnome"
      "extensions"
      "user-themes"
    ];
    nodeMetadata = [
      {
        metadata = {
          description = {
            multiline = true;
            parts = [
              {
                type = "text";
                value = "\n    Shell theme customization and dynamic theme generation\n\n    This module installs and configures the **User Themes** extension for GNOME.\n    It allows loading custom shell themes from the user's home directory and provides\n    logic to generate dynamic CSS overrides on top of existing themes.\n\n    **Features:**\n    - Enable custom GNOME Shell themes via dconf.\n    - Declaratively append CSS to themes using `cssOverride`.\n    - Inherit from installed system themes like Orchis or WhiteSur.\n  ";
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
                value = "Shell theme customization and dynamic theme generation";
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
                value = "User Theme GNOME extension configuration";
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
            multiline = false;
            parts = [ ];
            type = "string";
          };
          description = {
            multiline = true;
            parts = [
              {
                type = "text";
                value = "\n  Identifier for the shell theme to apply\n\n  The name of the theme directory found in /share/themes. If using\n  `cssOverride`, this becomes the directory name of the generated theme.\n";
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
          "name"
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
          "theme"
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
                value = "\n  Base theme for CSS inheritance\n\n  The name of an installed theme (e.g., 'Orchis-Dark') to use as a\n  parent. This theme must be present in the system packages.\n";
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
          "theme"
          "activeTheme"
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
                value = "\n  Custom CSS rules for GNOME Shell\n\n  Raw CSS content to be appended to the shell's stylesheet. If\n  provided, a synthetic theme package is automatically generated.\n";
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
          "theme"
          "cssOverride"
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
                    value = "Shell theme customization and dynamic theme generation";
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
                    value = "\n    Shell theme customization and dynamic theme generation\n\n    This module installs and configures the **User Themes** extension for GNOME.\n    It allows loading custom shell themes from the user's home directory and provides\n    logic to generate dynamic CSS overrides on top of existing themes.\n\n    **Features:**\n    - Enable custom GNOME Shell themes via dconf.\n    - Declaratively append CSS to themes using `cssOverride`.\n    - Inherit from installed system themes like Orchis or WhiteSur.\n  ";
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
          name = "type";
          path = [
            {
              kind = "identifier";
              value = "string";
            }
          ];
          type = "variable";
        };
        name = "effectiveName";
        type = "let-binding";
        value = {
          condition = {
            left = {
              name = "path";
              path = [
                {
                  kind = "identifier";
                  value = "theme";
                }
                {
                  kind = "identifier";
                  value = "cssOverride";
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
          "else" = {
            name = "path";
            path = [
              {
                kind = "identifier";
                value = "name";
              }
            ];
            type = "variable";
          };
          "then" = {
            type = "group";
            value = {
              condition = {
                left = {
                  name = "path";
                  path = [
                    {
                      kind = "identifier";
                      value = "name";
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
              "else" = {
                multiline = false;
                parts = [
                  {
                    type = "text";
                    value = "zenos-override";
                  }
                ];
                type = "string";
              };
              "then" = {
                name = "path";
                path = [
                  {
                    kind = "identifier";
                    value = "name";
                  }
                ];
                type = "variable";
              };
              type = "if";
            };
          };
          type = "if";
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
        name = "generatedTheme";
        type = "let-binding";
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
                      value = "name";
                    }
                  ];
                  type = "assignment";
                  value = {
                    multiline = false;
                    parts = [
                      {
                        type = "text";
                        value = "zenos-generated-theme";
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
                      value = "destination";
                    }
                  ];
                  type = "assignment";
                  value = {
                    multiline = false;
                    parts = [
                      {
                        type = "text";
                        value = "/share/themes/";
                      }
                      {
                        expression = {
                          name = "v";
                          path = [
                            {
                              kind = "identifier";
                              value = "effectiveName";
                            }
                          ];
                          type = "variable";
                        };
                        type = "interpolation";
                      }
                      {
                        type = "text";
                        value = "/gnome-shell/gnome-shell.css";
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
                      value = "text";
                    }
                  ];
                  type = "assignment";
                  value = {
                    multiline = true;
                    parts = [
                      {
                        type = "text";
                        value = "\n    /* Default GNOME Shell Theme */\n    @import url(\"resource:///org/gnome/shell/theme/default.css\");\n\n    /* Parent/Active Theme Import (if specified) */\n    ";
                      }
                      {
                        expression = {
                          arguments = [
                            {
                              multiline = true;
                              parts = [
                                {
                                  type = "text";
                                  value = "\n      @import url(\"file:///run/current-system/sw/share/themes/";
                                }
                                {
                                  expression = {
                                    name = "path";
                                    path = [
                                      {
                                        kind = "identifier";
                                        value = "theme";
                                      }
                                      {
                                        kind = "identifier";
                                        value = "activeTheme";
                                      }
                                    ];
                                    type = "variable";
                                  };
                                  type = "interpolation";
                                }
                                {
                                  type = "text";
                                  value = "/gnome-shell/gnome-shell.css\");\n    ";
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
                                    name = "path";
                                    path = [
                                      {
                                        kind = "identifier";
                                        value = "theme";
                                      }
                                      {
                                        kind = "identifier";
                                        value = "activeTheme";
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
                              }
                            ];
                            callee = {
                              name = "lib";
                              path = [
                                {
                                  kind = "identifier";
                                  value = "optionalString";
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
                        value = "\n\n    /* Zenos CSS Overrides */\n    ";
                      }
                      {
                        expression = {
                          name = "path";
                          path = [
                            {
                              kind = "identifier";
                              value = "theme";
                            }
                            {
                              kind = "identifier";
                              value = "cssOverride";
                            }
                          ];
                          type = "variable";
                        };
                        type = "interpolation";
                      }
                      {
                        type = "text";
                        value = "\n  ";
                      }
                    ];
                    type = "string";
                  };
                }
              ];
              type = "attr-set";
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
                value = "writeTextFile";
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
                            value = "User Theme GNOME extension configuration";
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
                        left = {
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
                                  value = "user-themes";
                                }
                              ];
                              type = "variable";
                            }
                          ];
                          type = "list";
                        };
                        operator = "++";
                        right = {
                          type = "group";
                          value = {
                            arguments = [
                              {
                                name = "v";
                                path = [
                                  {
                                    kind = "identifier";
                                    value = "generatedTheme";
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
                                    left = {
                                      name = "path";
                                      path = [
                                        {
                                          kind = "identifier";
                                          value = "theme";
                                        }
                                        {
                                          kind = "identifier";
                                          value = "cssOverride";
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
                                }
                              ];
                              callee = {
                                name = "lib";
                                path = [
                                  {
                                    kind = "identifier";
                                    value = "optional";
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
                                value = "user-themes";
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
                          value = "org/gnome/shell/extensions/user-theme";
                        }
                        {
                          kind = "identifier";
                          value = "name";
                        }
                      ];
                      type = "assignment";
                      value = {
                        name = "v";
                        path = [
                          {
                            kind = "identifier";
                            value = "effectiveName";
                          }
                        ];
                        type = "variable";
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
            value = "name";
          }
        ];
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
                          value = "\n  Identifier for the shell theme to apply\n\n  The name of the theme directory found in /share/themes. If using\n  `cssOverride`, this becomes the directory name of the generated theme.\n";
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
            value = "theme";
          }
        ];
        type = "assignment";
        value = {
          recursive = false;
          statements = [
            {
              operator = "=";
              target = [
                {
                  kind = "identifier";
                  value = "activeTheme";
                }
              ];
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
                                value = "\n  Base theme for CSS inheritance\n\n  The name of an installed theme (e.g., 'Orchis-Dark') to use as a\n  parent. This theme must be present in the system packages.\n";
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
                  value = "cssOverride";
                }
              ];
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
                                value = "\n  Custom CSS rules for GNOME Shell\n\n  Raw CSS content to be appended to the shell's stylesheet. If\n  provided, a synthetic theme package is automatically generated.\n";
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
    (let effectiveName = (builtins.addErrorContext "_let effectiveName annotation mismatch: /nix/store/59qqzf108ga8h2qmsjizzsn2p7i889xx-zenpkgs-dsl-source/modules/desktops/gnome/extensions/user-themes.zmdl:21:1" ((_zenType: _zenValue: let force = type: value: if type.name == "anything" then true else if type.name == "listOf" then builtins.all (force type.nestedTypes.elemType) value else if type.name == "attrsOf" then builtins.all (force type.nestedTypes.elemType) (builtins.attrValues value) else if type.name == "either" then force (if type.nestedTypes.left.check value then type.nestedTypes.left else type.nestedTypes.right) value else builtins.seq value true; in builtins.seq (force _zenType _zenValue) _zenValue) (lib.types.str) ((lib.evalModules { modules = [ { options.value = lib.mkOption { type = lib.types.str; }; config.value = (if (cfg.theme.cssOverride != "") then ((if (cfg.name != "") then cfg.name else "zenos-override")) else cfg.name); } ]; }).config.value))); generatedTheme = (builtins.addErrorContext "_let generatedTheme annotation mismatch: /nix/store/59qqzf108ga8h2qmsjizzsn2p7i889xx-zenpkgs-dsl-source/modules/desktops/gnome/extensions/user-themes.zmdl:26:1" ((_zenType: _zenValue: let force = type: value: if type.name == "anything" then true else if type.name == "listOf" then builtins.all (force type.nestedTypes.elemType) value else if type.name == "attrsOf" then builtins.all (force type.nestedTypes.elemType) (builtins.attrValues value) else if type.name == "either" then force (if type.nestedTypes.left.check value then type.nestedTypes.left else type.nestedTypes.right) value else builtins.seq value true; in builtins.seq (force _zenType _zenValue) _zenValue) (lib.types.package) ((lib.evalModules { modules = [ { options.value = lib.mkOption { type = lib.types.package; }; config.value = (pkgs.zenos.legacy.writeTextFile {
  name = "zenos-generated-theme";
  destination = "/share/themes/${((value: let kind = builtins.typeOf value; in if kind == "string" then value else if kind == "bool" || kind == "int" || kind == "float" then builtins.toJSON value else if kind == "path" then "${value}" else if kind == "set" && (value.type or null) == "derivation" && builtins.isString (value.outPath or null) then value.outPath else throw "/nix/store/59qqzf108ga8h2qmsjizzsn2p7i889xx-zenpkgs-dsl-source/modules/desktops/gnome/extensions/user-themes.zmdl:28: string interpolation requires a scalar, path, or package") (effectiveName))}/gnome-shell/gnome-shell.css";
  text = "\n    /* Default GNOME Shell Theme */\n    @import url(\"resource:///org/gnome/shell/theme/default.css\");\n\n    /* Parent/Active Theme Import (if specified) */\n    ${((value: let kind = builtins.typeOf value; in if kind == "string" then value else if kind == "bool" || kind == "int" || kind == "float" then builtins.toJSON value else if kind == "path" then "${value}" else if kind == "set" && (value.type or null) == "derivation" && builtins.isString (value.outPath or null) then value.outPath else throw "/nix/store/59qqzf108ga8h2qmsjizzsn2p7i889xx-zenpkgs-dsl-source/modules/desktops/gnome/extensions/user-themes.zmdl:34: string interpolation requires a scalar, path, or package") (((lib.optionalString ((cfg.theme.activeTheme != ""))) "\n      @import url(\"file:///run/current-system/sw/share/themes/${((value: let kind = builtins.typeOf value; in if kind == "string" then value else if kind == "bool" || kind == "int" || kind == "float" then builtins.toJSON value else if kind == "path" then "${value}" else if kind == "set" && (value.type or null) == "derivation" && builtins.isString (value.outPath or null) then value.outPath else throw "/nix/store/59qqzf108ga8h2qmsjizzsn2p7i889xx-zenpkgs-dsl-source/modules/desktops/gnome/extensions/user-themes.zmdl:35: string interpolation requires a scalar, path, or package") (cfg.theme.activeTheme))}/gnome-shell/gnome-shell.css\");\n    ")))}\n\n    /* Zenos CSS Overrides */\n    ${((value: let kind = builtins.typeOf value; in if kind == "string" then value else if kind == "bool" || kind == "int" || kind == "float" then builtins.toJSON value else if kind == "path" then "${value}" else if kind == "set" && (value.type or null) == "derivation" && builtins.isString (value.outPath or null) then value.outPath else throw "/nix/store/59qqzf108ga8h2qmsjizzsn2p7i889xx-zenpkgs-dsl-source/modules/desktops/gnome/extensions/user-themes.zmdl:39: string interpolation requires a scalar, path, or package") (cfg.theme.cssOverride))}\n  ";
}); } ]; }).config.value))); in (lib.mkIf ((cfg.enable)) {
      environment.systemPackages = ([
        pkgs.zenos.byCategories.desktops.gnome.extensions.user-themes
      ] ++ (((lib.optional ((cfg.theme.cssOverride != ""))) generatedTheme)));
    }))
    (let effectiveName = (builtins.addErrorContext "_let effectiveName annotation mismatch: /nix/store/59qqzf108ga8h2qmsjizzsn2p7i889xx-zenpkgs-dsl-source/modules/desktops/gnome/extensions/user-themes.zmdl:21:1" ((_zenType: _zenValue: let force = type: value: if type.name == "anything" then true else if type.name == "listOf" then builtins.all (force type.nestedTypes.elemType) value else if type.name == "attrsOf" then builtins.all (force type.nestedTypes.elemType) (builtins.attrValues value) else if type.name == "either" then force (if type.nestedTypes.left.check value then type.nestedTypes.left else type.nestedTypes.right) value else builtins.seq value true; in builtins.seq (force _zenType _zenValue) _zenValue) (lib.types.str) ((lib.evalModules { modules = [ { options.value = lib.mkOption { type = lib.types.str; }; config.value = (if (cfg.theme.cssOverride != "") then ((if (cfg.name != "") then cfg.name else "zenos-override")) else cfg.name); } ]; }).config.value))); generatedTheme = (builtins.addErrorContext "_let generatedTheme annotation mismatch: /nix/store/59qqzf108ga8h2qmsjizzsn2p7i889xx-zenpkgs-dsl-source/modules/desktops/gnome/extensions/user-themes.zmdl:26:1" ((_zenType: _zenValue: let force = type: value: if type.name == "anything" then true else if type.name == "listOf" then builtins.all (force type.nestedTypes.elemType) value else if type.name == "attrsOf" then builtins.all (force type.nestedTypes.elemType) (builtins.attrValues value) else if type.name == "either" then force (if type.nestedTypes.left.check value then type.nestedTypes.left else type.nestedTypes.right) value else builtins.seq value true; in builtins.seq (force _zenType _zenValue) _zenValue) (lib.types.package) ((lib.evalModules { modules = [ { options.value = lib.mkOption { type = lib.types.package; }; config.value = (pkgs.zenos.legacy.writeTextFile {
  name = "zenos-generated-theme";
  destination = "/share/themes/${((value: let kind = builtins.typeOf value; in if kind == "string" then value else if kind == "bool" || kind == "int" || kind == "float" then builtins.toJSON value else if kind == "path" then "${value}" else if kind == "set" && (value.type or null) == "derivation" && builtins.isString (value.outPath or null) then value.outPath else throw "/nix/store/59qqzf108ga8h2qmsjizzsn2p7i889xx-zenpkgs-dsl-source/modules/desktops/gnome/extensions/user-themes.zmdl:28: string interpolation requires a scalar, path, or package") (effectiveName))}/gnome-shell/gnome-shell.css";
  text = "\n    /* Default GNOME Shell Theme */\n    @import url(\"resource:///org/gnome/shell/theme/default.css\");\n\n    /* Parent/Active Theme Import (if specified) */\n    ${((value: let kind = builtins.typeOf value; in if kind == "string" then value else if kind == "bool" || kind == "int" || kind == "float" then builtins.toJSON value else if kind == "path" then "${value}" else if kind == "set" && (value.type or null) == "derivation" && builtins.isString (value.outPath or null) then value.outPath else throw "/nix/store/59qqzf108ga8h2qmsjizzsn2p7i889xx-zenpkgs-dsl-source/modules/desktops/gnome/extensions/user-themes.zmdl:34: string interpolation requires a scalar, path, or package") (((lib.optionalString ((cfg.theme.activeTheme != ""))) "\n      @import url(\"file:///run/current-system/sw/share/themes/${((value: let kind = builtins.typeOf value; in if kind == "string" then value else if kind == "bool" || kind == "int" || kind == "float" then builtins.toJSON value else if kind == "path" then "${value}" else if kind == "set" && (value.type or null) == "derivation" && builtins.isString (value.outPath or null) then value.outPath else throw "/nix/store/59qqzf108ga8h2qmsjizzsn2p7i889xx-zenpkgs-dsl-source/modules/desktops/gnome/extensions/user-themes.zmdl:35: string interpolation requires a scalar, path, or package") (cfg.theme.activeTheme))}/gnome-shell/gnome-shell.css\");\n    ")))}\n\n    /* Zenos CSS Overrides */\n    ${((value: let kind = builtins.typeOf value; in if kind == "string" then value else if kind == "bool" || kind == "int" || kind == "float" then builtins.toJSON value else if kind == "path" then "${value}" else if kind == "set" && (value.type or null) == "derivation" && builtins.isString (value.outPath or null) then value.outPath else throw "/nix/store/59qqzf108ga8h2qmsjizzsn2p7i889xx-zenpkgs-dsl-source/modules/desktops/gnome/extensions/user-themes.zmdl:39: string interpolation requires a scalar, path, or package") (cfg.theme.cssOverride))}\n  ";
}); } ]; }).config.value))); in (lib.mkIf ((cfg.enable)) { home-manager.sharedModules = [ {
      dconf.settings."org/gnome/shell".enabled-extensions = [
        pkgs.zenos.byCategories.desktops.gnome.extensions.user-themes.extensionUuid
      ];
      dconf.settings."org/gnome/shell/extensions/user-theme".name = effectiveName;
    } ]; }))
  ];
}
