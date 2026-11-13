{ config, lib, pkgs, maintainers ? lib.maintainers, licenses ? lib.licenses, ... }:
let
  cfg = config.zenos.desktops.gnome.tweaks.zenos-fonts;
  name = "zenos-fonts";
in
{
  options.zenos.desktops.gnome.tweaks.zenos-fonts = lib.mkOption { type = (lib.types.submodule ({ ... }: { options = { enable = lib.mkOption { type = lib.types.bool; default = false; }; }; })); default = { }; };
  config = lib.mkMerge [
    { _module.args.zenlang.descriptors.desktops.gnome.tweaks.zenos-fonts = {
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
            value = "\n    Installs the Atkinson, Noto, and Zero font stack and applies matching GNOME\n    interface, document, monospace, and title-bar defaults for each user.\n  ";
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
            value = "ZenOS system typography overrides";
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
    moduleIdentity = "zenos.desktops.gnome.tweaks.zenos-fonts";
    modulePath = [
      "desktops"
      "gnome"
      "tweaks"
      "zenos-fonts"
    ];
    nodeMetadata = [
      {
        metadata = {
          description = {
            multiline = true;
            parts = [
              {
                type = "text";
                value = "\n    Installs the Atkinson, Noto, and Zero font stack and applies matching GNOME\n    interface, document, monospace, and title-bar defaults for each user.\n  ";
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
                value = "ZenOS system typography overrides";
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
                value = "Enable the ZenOS typography stack";
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
                    value = "ZenOS system typography overrides";
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
                    value = "\n    Installs the Atkinson, Noto, and Zero font stack and applies matching GNOME\n    interface, document, monospace, and title-bar defaults for each user.\n  ";
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
                            value = "Enable the ZenOS typography stack";
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
                                      value = "atkinson-hyperlegible-next";
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
                                      value = "noto-fonts";
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
                                      value = "noto-fonts-color-emoji";
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
                                      value = "nerd-fonts";
                                    }
                                    {
                                      kind = "identifier";
                                      value = "atkynson-mono";
                                    }
                                  ];
                                  type = "variable";
                                }
                                {
                                  name = "pkgs";
                                  path = [
                                    {
                                      kind = "identifier";
                                      value = "byCategories";
                                    }
                                    {
                                      kind = "identifier";
                                      value = "theming";
                                    }
                                    {
                                      kind = "identifier";
                                      value = "fonts";
                                    }
                                    {
                                      kind = "identifier";
                                      value = "zero";
                                    }
                                    {
                                      kind = "identifier";
                                      value = "regular";
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
                                value = "fontDir";
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
                                      {
                                        multiline = false;
                                        parts = [
                                          {
                                            type = "text";
                                            value = "Symbols Nerd Font";
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
                                      value = "serif";
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
                                            value = "Noto Serif";
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
                                  value = "AtkynsonMono NF 10";
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
                          value = "dconf";
                        }
                        {
                          kind = "identifier";
                          value = "settings";
                        }
                        {
                          kind = "string";
                          value = "org/gnome/desktop/wm/preferences";
                        }
                        {
                          kind = "identifier";
                          value = "titlebar-font";
                        }
                      ];
                      type = "assignment";
                      value = {
                        multiline = false;
                        parts = [
                          {
                            type = "text";
                            value = "Atkinson Hyperlegible Next Bold 11";
                          }
                        ];
                        type = "string";
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
    ];
  }; }
    (lib.mkIf ((cfg.enable)) {
      fonts = {
        packages = [
          pkgs.zenos.legacy.atkinson-hyperlegible-next
          pkgs.zenos.legacy.noto-fonts
          pkgs.zenos.legacy.noto-fonts-color-emoji
          pkgs.zenos.legacy.nerd-fonts.atkynson-mono
          pkgs.zenos.byCategories.theming.fonts.zero.regular
        ];
        fontDir.enable = true;
        fontconfig.defaultFonts = {
          monospace = [
            "AtkynsonMono NF"
          ];
          sansSerif = [
            "Atkinson Hyperlegible Next"
            "Symbols Nerd Font"
          ];
          serif = [
            "Noto Serif"
          ];
        };
      };
    })
    (lib.mkIf ((cfg.enable)) { home-manager.sharedModules = [ {
      dconf.settings."org/gnome/desktop/interface" = {
        font-name = "Atkinson Hyperlegible Next 11";
        document-font-name = "Atkinson Hyperlegible Next 11";
        monospace-font-name = "AtkynsonMono NF 10";
      };
      dconf.settings."org/gnome/desktop/wm/preferences".titlebar-font = "Atkinson Hyperlegible Next Bold 11";
    } ]; })
  ];
}
