{ config, lib, pkgs, maintainers ? lib.maintainers, licenses ? lib.licenses, ... }:
let
  cfg = config.zenos.desktops.gnome.tweaks.firefox-theming;
  name = "firefox-theming";
  gnomeThemeRepo = (builtins.addErrorContext "_let gnomeThemeRepo annotation mismatch: /nix/store/59qqzf108ga8h2qmsjizzsn2p7i889xx-zenpkgs-dsl-source/modules/desktops/gnome/tweaks/firefox-theming.zmdl:16:1" ((_zenType: _zenValue: let force = type: value: if type.name == "anything" then true else if type.name == "listOf" then builtins.all (force type.nestedTypes.elemType) value else if type.name == "attrsOf" then builtins.all (force type.nestedTypes.elemType) (builtins.attrValues value) else if type.name == "either" then force (if type.nestedTypes.left.check value then type.nestedTypes.left else type.nestedTypes.right) value else builtins.seq value true; in builtins.seq (force _zenType _zenValue) _zenValue) (lib.types.package) ((lib.evalModules { modules = [ { options.value = lib.mkOption { type = lib.types.package; }; config.value = (pkgs.zenos.legacy.fetchFromGitHub {
    owner = "rafaelmardojai";
    repo = "firefox-gnome-theme";
    rev = "v143";
    sha256 = "sha256-0E3TqvXAy81qeM/jZXWWOTZ14Hs1RT7o78UyZM+Jbr4=";
  }); } ]; }).config.value)));
  customChromeCss = (builtins.addErrorContext "_let customChromeCss annotation mismatch: /nix/store/59qqzf108ga8h2qmsjizzsn2p7i889xx-zenpkgs-dsl-source/modules/desktops/gnome/tweaks/firefox-theming.zmdl:23:1" ((_zenType: _zenValue: let force = type: value: if type.name == "anything" then true else if type.name == "listOf" then builtins.all (force type.nestedTypes.elemType) value else if type.name == "attrsOf" then builtins.all (force type.nestedTypes.elemType) (builtins.attrValues value) else if type.name == "either" then force (if type.nestedTypes.left.check value then type.nestedTypes.left else type.nestedTypes.right) value else builtins.seq value true; in builtins.seq (force _zenType _zenValue) _zenValue) (lib.types.package) ((lib.evalModules { modules = [ { options.value = lib.mkOption { type = lib.types.package; }; config.value = ((pkgs.zenos.legacy.writeText "userChrome.css") "\n  @import \"gnome-theme/userChrome.css\";\n"); } ]; }).config.value)));
  customContentCss = (builtins.addErrorContext "_let customContentCss annotation mismatch: /nix/store/59qqzf108ga8h2qmsjizzsn2p7i889xx-zenpkgs-dsl-source/modules/desktops/gnome/tweaks/firefox-theming.zmdl:27:1" ((_zenType: _zenValue: let force = type: value: if type.name == "anything" then true else if type.name == "listOf" then builtins.all (force type.nestedTypes.elemType) value else if type.name == "attrsOf" then builtins.all (force type.nestedTypes.elemType) (builtins.attrValues value) else if type.name == "either" then force (if type.nestedTypes.left.check value then type.nestedTypes.left else type.nestedTypes.right) value else builtins.seq value true; in builtins.seq (force _zenType _zenValue) _zenValue) (lib.types.package) ((lib.evalModules { modules = [ { options.value = lib.mkOption { type = lib.types.package; }; config.value = ((pkgs.zenos.legacy.writeText "userContent.css") "\n  @import \"gnome-theme/userContent.css\";\n"); } ]; }).config.value)));
in
{
  options.zenos.desktops.gnome.tweaks.firefox-theming = lib.mkOption { type = (lib.types.submodule ({ ... }: (let gnomeThemeRepo = (builtins.addErrorContext "_let gnomeThemeRepo annotation mismatch: /nix/store/59qqzf108ga8h2qmsjizzsn2p7i889xx-zenpkgs-dsl-source/modules/desktops/gnome/tweaks/firefox-theming.zmdl:16:1" ((_zenType: _zenValue: let force = type: value: if type.name == "anything" then true else if type.name == "listOf" then builtins.all (force type.nestedTypes.elemType) value else if type.name == "attrsOf" then builtins.all (force type.nestedTypes.elemType) (builtins.attrValues value) else if type.name == "either" then force (if type.nestedTypes.left.check value then type.nestedTypes.left else type.nestedTypes.right) value else builtins.seq value true; in builtins.seq (force _zenType _zenValue) _zenValue) (lib.types.package) ((lib.evalModules { modules = [ { options.value = lib.mkOption { type = lib.types.package; }; config.value = (pkgs.zenos.legacy.fetchFromGitHub {
        owner = "rafaelmardojai";
        repo = "firefox-gnome-theme";
        rev = "v143";
        sha256 = "sha256-0E3TqvXAy81qeM/jZXWWOTZ14Hs1RT7o78UyZM+Jbr4=";
      }); } ]; }).config.value))); customChromeCss = (builtins.addErrorContext "_let customChromeCss annotation mismatch: /nix/store/59qqzf108ga8h2qmsjizzsn2p7i889xx-zenpkgs-dsl-source/modules/desktops/gnome/tweaks/firefox-theming.zmdl:23:1" ((_zenType: _zenValue: let force = type: value: if type.name == "anything" then true else if type.name == "listOf" then builtins.all (force type.nestedTypes.elemType) value else if type.name == "attrsOf" then builtins.all (force type.nestedTypes.elemType) (builtins.attrValues value) else if type.name == "either" then force (if type.nestedTypes.left.check value then type.nestedTypes.left else type.nestedTypes.right) value else builtins.seq value true; in builtins.seq (force _zenType _zenValue) _zenValue) (lib.types.package) ((lib.evalModules { modules = [ { options.value = lib.mkOption { type = lib.types.package; }; config.value = ((pkgs.zenos.legacy.writeText "userChrome.css") "\n  @import \"gnome-theme/userChrome.css\";\n"); } ]; }).config.value))); customContentCss = (builtins.addErrorContext "_let customContentCss annotation mismatch: /nix/store/59qqzf108ga8h2qmsjizzsn2p7i889xx-zenpkgs-dsl-source/modules/desktops/gnome/tweaks/firefox-theming.zmdl:27:1" ((_zenType: _zenValue: let force = type: value: if type.name == "anything" then true else if type.name == "listOf" then builtins.all (force type.nestedTypes.elemType) value else if type.name == "attrsOf" then builtins.all (force type.nestedTypes.elemType) (builtins.attrValues value) else if type.name == "either" then force (if type.nestedTypes.left.check value then type.nestedTypes.left else type.nestedTypes.right) value else builtins.seq value true; in builtins.seq (force _zenType _zenValue) _zenValue) (lib.types.package) ((lib.evalModules { modules = [ { options.value = lib.mkOption { type = lib.types.package; }; config.value = ((pkgs.zenos.legacy.writeText "userContent.css") "\n  @import \"gnome-theme/userContent.css\";\n"); } ]; }).config.value))); in { options = { enable = lib.mkOption { type = lib.types.bool; default = false; }; theme = lib.mkOption { type = (lib.types.submodule ({ ... }: { options = { bookmarksToolbarUnderTabs = lib.mkOption { type = lib.types.bool; default = true; }; hideSingleTab = lib.mkOption { type = lib.types.bool; default = true; }; normalWidthTabs = lib.mkOption { type = lib.types.bool; default = false; }; roundedBottomCorners = lib.mkOption { type = lib.types.bool; default = true; }; }; })); default = { }; }; }; }))); default = { }; };
  config = lib.mkMerge [
    { _module.args.zenlang.descriptors.desktops.gnome.tweaks.firefox-theming = {
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
            value = "\n    Fetches firefox-gnome-theme, enables Firefox profile CSS support, writes the\n    theme imports, and applies the contributor module's profile preferences.\n  ";
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
            value = "Native GNOME theming for Firefox";
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
    moduleIdentity = "zenos.desktops.gnome.tweaks.firefox-theming";
    modulePath = [
      "desktops"
      "gnome"
      "tweaks"
      "firefox-theming"
    ];
    nodeMetadata = [
      {
        metadata = {
          description = {
            multiline = true;
            parts = [
              {
                type = "text";
                value = "\n    Fetches firefox-gnome-theme, enables Firefox profile CSS support, writes the\n    theme imports, and applies the contributor module's profile preferences.\n  ";
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
                value = "Native GNOME theming for Firefox";
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
          summary = {
            multiline = false;
            parts = [
              {
                type = "text";
                value = "Enable Firefox GNOME integration";
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
          "theme"
        ];
      }
      {
        metadata = {
          default = {
            kind = "true";
            type = "literal";
            value = true;
          };
          summary = {
            multiline = false;
            parts = [
              {
                type = "text";
                value = "Hide the tab bar when one tab is open";
              }
            ];
            type = "string";
          };
          type = {
            name = "type";
            path = [
              {
                kind = "identifier";
                value = "boolean";
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
          "hideSingleTab"
        ];
      }
      {
        metadata = {
          default = {
            kind = "false";
            type = "literal";
            value = false;
          };
          summary = {
            multiline = false;
            parts = [
              {
                type = "text";
                value = "Use standard-width tabs";
              }
            ];
            type = "string";
          };
          type = {
            name = "type";
            path = [
              {
                kind = "identifier";
                value = "boolean";
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
          "normalWidthTabs"
        ];
      }
      {
        metadata = {
          default = {
            kind = "true";
            type = "literal";
            value = true;
          };
          summary = {
            multiline = false;
            parts = [
              {
                type = "text";
                value = "Place bookmarks below the tab bar";
              }
            ];
            type = "string";
          };
          type = {
            name = "type";
            path = [
              {
                kind = "identifier";
                value = "boolean";
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
          "bookmarksToolbarUnderTabs"
        ];
      }
      {
        metadata = {
          default = {
            kind = "true";
            type = "literal";
            value = true;
          };
          summary = {
            multiline = false;
            parts = [
              {
                type = "text";
                value = "Enable rounded browser bottom corners";
              }
            ];
            type = "string";
          };
          type = {
            name = "type";
            path = [
              {
                kind = "identifier";
                value = "boolean";
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
          "roundedBottomCorners"
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
                    value = "Native GNOME theming for Firefox";
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
                    value = "\n    Fetches firefox-gnome-theme, enables Firefox profile CSS support, writes the\n    theme imports, and applies the contributor module's profile preferences.\n  ";
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
              value = "package";
            }
          ];
          type = "variable";
        };
        name = "gnomeThemeRepo";
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
                      value = "owner";
                    }
                  ];
                  type = "assignment";
                  value = {
                    multiline = false;
                    parts = [
                      {
                        type = "text";
                        value = "rafaelmardojai";
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
                      value = "repo";
                    }
                  ];
                  type = "assignment";
                  value = {
                    multiline = false;
                    parts = [
                      {
                        type = "text";
                        value = "firefox-gnome-theme";
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
                      value = "rev";
                    }
                  ];
                  type = "assignment";
                  value = {
                    multiline = false;
                    parts = [
                      {
                        type = "text";
                        value = "v143";
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
                      value = "sha256";
                    }
                  ];
                  type = "assignment";
                  value = {
                    multiline = false;
                    parts = [
                      {
                        type = "text";
                        value = "sha256-0E3TqvXAy81qeM/jZXWWOTZ14Hs1RT7o78UyZM+Jbr4=";
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
                value = "fetchFromGitHub";
              }
            ];
            type = "variable";
          };
          type = "call";
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
        name = "customChromeCss";
        type = "let-binding";
        value = {
          arguments = [
            {
              multiline = true;
              parts = [
                {
                  type = "text";
                  value = "\n  @import \"gnome-theme/userChrome.css\";\n";
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
                    value = "userChrome.css";
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
        name = "customContentCss";
        type = "let-binding";
        value = {
          arguments = [
            {
              multiline = true;
              parts = [
                {
                  type = "text";
                  value = "\n  @import \"gnome-theme/userContent.css\";\n";
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
                    value = "userContent.css";
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
                          value = "summary";
                        }
                      ];
                      type = "assignment";
                      value = {
                        multiline = false;
                        parts = [
                          {
                            type = "text";
                            value = "Enable Firefox GNOME integration";
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
                          value = "programs";
                        }
                        {
                          kind = "identifier";
                          value = "firefox";
                        }
                      ];
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
                                value = "profiles";
                              }
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
                                      value = "id";
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
                                      value = "name";
                                    }
                                  ];
                                  type = "assignment";
                                  value = {
                                    multiline = false;
                                    parts = [
                                      {
                                        type = "text";
                                        value = "default";
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
                                      value = "isDefault";
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
                                            kind = "string";
                                            value = "toolkit.legacyUserProfileCustomizations.stylesheets";
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
                                            kind = "string";
                                            value = "svg.context-properties.content.enabled";
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
                                            kind = "string";
                                            value = "browser.tabs.drawInTitlebar";
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
                                            kind = "string";
                                            value = "browser.uidensity";
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
                                            value = "gnomeTheme.hideSingleTab";
                                          }
                                        ];
                                        type = "assignment";
                                        value = {
                                          name = "path";
                                          path = [
                                            {
                                              kind = "identifier";
                                              value = "theme";
                                            }
                                            {
                                              kind = "identifier";
                                              value = "hideSingleTab";
                                            }
                                          ];
                                          type = "variable";
                                        };
                                      }
                                      {
                                        operator = "=";
                                        target = [
                                          {
                                            kind = "string";
                                            value = "gnomeTheme.normalWidthTabs";
                                          }
                                        ];
                                        type = "assignment";
                                        value = {
                                          name = "path";
                                          path = [
                                            {
                                              kind = "identifier";
                                              value = "theme";
                                            }
                                            {
                                              kind = "identifier";
                                              value = "normalWidthTabs";
                                            }
                                          ];
                                          type = "variable";
                                        };
                                      }
                                      {
                                        operator = "=";
                                        target = [
                                          {
                                            kind = "string";
                                            value = "gnomeTheme.bookmarksToolbarUnderTabs";
                                          }
                                        ];
                                        type = "assignment";
                                        value = {
                                          name = "path";
                                          path = [
                                            {
                                              kind = "identifier";
                                              value = "theme";
                                            }
                                            {
                                              kind = "identifier";
                                              value = "bookmarksToolbarUnderTabs";
                                            }
                                          ];
                                          type = "variable";
                                        };
                                      }
                                      {
                                        operator = "=";
                                        target = [
                                          {
                                            kind = "string";
                                            value = "widget.gtk.rounded-bottom-corners.enabled";
                                          }
                                        ];
                                        type = "assignment";
                                        value = {
                                          name = "path";
                                          path = [
                                            {
                                              kind = "identifier";
                                              value = "theme";
                                            }
                                            {
                                              kind = "identifier";
                                              value = "roundedBottomCorners";
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
                          value = "xdg";
                        }
                        {
                          kind = "identifier";
                          value = "configFile";
                        }
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
                                value = "mozilla/firefox/default/chrome/userChrome.css";
                              }
                              {
                                kind = "identifier";
                                value = "source";
                              }
                            ];
                            type = "assignment";
                            value = {
                              name = "v";
                              path = [
                                {
                                  kind = "identifier";
                                  value = "customChromeCss";
                                }
                              ];
                              type = "variable";
                            };
                          }
                          {
                            operator = "=";
                            target = [
                              {
                                kind = "string";
                                value = "mozilla/firefox/default/chrome/userContent.css";
                              }
                              {
                                kind = "identifier";
                                value = "source";
                              }
                            ];
                            type = "assignment";
                            value = {
                              name = "v";
                              path = [
                                {
                                  kind = "identifier";
                                  value = "customContentCss";
                                }
                              ];
                              type = "variable";
                            };
                          }
                          {
                            operator = "=";
                            target = [
                              {
                                kind = "string";
                                value = "mozilla/firefox/default/chrome/gnome-theme";
                              }
                              {
                                kind = "identifier";
                                value = "source";
                              }
                            ];
                            type = "assignment";
                            value = {
                              name = "v";
                              path = [
                                {
                                  kind = "identifier";
                                  value = "gnomeThemeRepo";
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
                  value = "hideSingleTab";
                }
              ];
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
                                value = "boolean";
                              }
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
                              value = "summary";
                            }
                          ];
                          type = "assignment";
                          value = {
                            multiline = false;
                            parts = [
                              {
                                type = "text";
                                value = "Hide the tab bar when one tab is open";
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
                  value = "normalWidthTabs";
                }
              ];
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
                                value = "boolean";
                              }
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
                              value = "summary";
                            }
                          ];
                          type = "assignment";
                          value = {
                            multiline = false;
                            parts = [
                              {
                                type = "text";
                                value = "Use standard-width tabs";
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
                  value = "bookmarksToolbarUnderTabs";
                }
              ];
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
                                value = "boolean";
                              }
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
                              value = "summary";
                            }
                          ];
                          type = "assignment";
                          value = {
                            multiline = false;
                            parts = [
                              {
                                type = "text";
                                value = "Place bookmarks below the tab bar";
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
                  value = "roundedBottomCorners";
                }
              ];
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
                                value = "boolean";
                              }
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
                              value = "summary";
                            }
                          ];
                          type = "assignment";
                          value = {
                            multiline = false;
                            parts = [
                              {
                                type = "text";
                                value = "Enable rounded browser bottom corners";
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
    (let gnomeThemeRepo = (builtins.addErrorContext "_let gnomeThemeRepo annotation mismatch: /nix/store/59qqzf108ga8h2qmsjizzsn2p7i889xx-zenpkgs-dsl-source/modules/desktops/gnome/tweaks/firefox-theming.zmdl:16:1" ((_zenType: _zenValue: let force = type: value: if type.name == "anything" then true else if type.name == "listOf" then builtins.all (force type.nestedTypes.elemType) value else if type.name == "attrsOf" then builtins.all (force type.nestedTypes.elemType) (builtins.attrValues value) else if type.name == "either" then force (if type.nestedTypes.left.check value then type.nestedTypes.left else type.nestedTypes.right) value else builtins.seq value true; in builtins.seq (force _zenType _zenValue) _zenValue) (lib.types.package) ((lib.evalModules { modules = [ { options.value = lib.mkOption { type = lib.types.package; }; config.value = (pkgs.zenos.legacy.fetchFromGitHub {
  owner = "rafaelmardojai";
  repo = "firefox-gnome-theme";
  rev = "v143";
  sha256 = "sha256-0E3TqvXAy81qeM/jZXWWOTZ14Hs1RT7o78UyZM+Jbr4=";
}); } ]; }).config.value))); customChromeCss = (builtins.addErrorContext "_let customChromeCss annotation mismatch: /nix/store/59qqzf108ga8h2qmsjizzsn2p7i889xx-zenpkgs-dsl-source/modules/desktops/gnome/tweaks/firefox-theming.zmdl:23:1" ((_zenType: _zenValue: let force = type: value: if type.name == "anything" then true else if type.name == "listOf" then builtins.all (force type.nestedTypes.elemType) value else if type.name == "attrsOf" then builtins.all (force type.nestedTypes.elemType) (builtins.attrValues value) else if type.name == "either" then force (if type.nestedTypes.left.check value then type.nestedTypes.left else type.nestedTypes.right) value else builtins.seq value true; in builtins.seq (force _zenType _zenValue) _zenValue) (lib.types.package) ((lib.evalModules { modules = [ { options.value = lib.mkOption { type = lib.types.package; }; config.value = ((pkgs.zenos.legacy.writeText "userChrome.css") "\n  @import \"gnome-theme/userChrome.css\";\n"); } ]; }).config.value))); customContentCss = (builtins.addErrorContext "_let customContentCss annotation mismatch: /nix/store/59qqzf108ga8h2qmsjizzsn2p7i889xx-zenpkgs-dsl-source/modules/desktops/gnome/tweaks/firefox-theming.zmdl:27:1" ((_zenType: _zenValue: let force = type: value: if type.name == "anything" then true else if type.name == "listOf" then builtins.all (force type.nestedTypes.elemType) value else if type.name == "attrsOf" then builtins.all (force type.nestedTypes.elemType) (builtins.attrValues value) else if type.name == "either" then force (if type.nestedTypes.left.check value then type.nestedTypes.left else type.nestedTypes.right) value else builtins.seq value true; in builtins.seq (force _zenType _zenValue) _zenValue) (lib.types.package) ((lib.evalModules { modules = [ { options.value = lib.mkOption { type = lib.types.package; }; config.value = ((pkgs.zenos.legacy.writeText "userContent.css") "\n  @import \"gnome-theme/userContent.css\";\n"); } ]; }).config.value))); in (lib.mkIf ((cfg.enable)) { home-manager.sharedModules = [ {
      programs.firefox = {
        enable = true;
        profiles.default = {
          id = 0;
          name = "default";
          isDefault = true;
          settings = {
            "toolkit.legacyUserProfileCustomizations.stylesheets" = true;
            "svg.context-properties.content.enabled" = true;
            "browser.tabs.drawInTitlebar" = true;
            "browser.uidensity" = 1;
            "gnomeTheme.hideSingleTab" = cfg.theme.hideSingleTab;
            "gnomeTheme.normalWidthTabs" = cfg.theme.normalWidthTabs;
            "gnomeTheme.bookmarksToolbarUnderTabs" = cfg.theme.bookmarksToolbarUnderTabs;
            "widget.gtk.rounded-bottom-corners.enabled" = cfg.theme.roundedBottomCorners;
          };
        };
      };
      xdg.configFile = {
        "mozilla/firefox/default/chrome/userChrome.css".source = customChromeCss;
        "mozilla/firefox/default/chrome/userContent.css".source = customContentCss;
        "mozilla/firefox/default/chrome/gnome-theme".source = gnomeThemeRepo;
      };
    } ]; }))
  ];
}
