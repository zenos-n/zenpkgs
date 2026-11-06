{ config, lib, pkgs, maintainers ? lib.maintainers, licenses ? lib.licenses, ... }:
let
  cfg = config.zenos.desktops.gnome.tweaks.zero-clock;
  name = "zero-clock";
in
{
  options.zenos.desktops.gnome.tweaks.zero-clock = lib.mkOption { type = (lib.types.submodule ({ ... }: { options = { enable = lib.mkOption { type = lib.types.bool; default = false; }; }; })); default = { }; };
  config = lib.mkMerge [
    { _module.args.zenlang.descriptors.desktops.gnome.tweaks.zero-clock = {
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
            value = "\n    Applies Zero Mono Thin to the lock-screen time and Zero to the lock-screen\n    date and top-bar clock through GNOME extensions.\n  ";
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
            value = "GNOME lock-screen and top-bar clock font tweak";
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
    moduleIdentity = "zenos.desktops.gnome.tweaks.zero-clock";
    modulePath = [
      "desktops"
      "gnome"
      "tweaks"
      "zero-clock"
    ];
    nodeMetadata = [
      {
        metadata = {
          description = {
            multiline = true;
            parts = [
              {
                type = "text";
                value = "\n    Applies Zero Mono Thin to the lock-screen time and Zero to the lock-screen\n    date and top-bar clock through GNOME extensions.\n  ";
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
                value = "GNOME lock-screen and top-bar clock font tweak";
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
                value = "Enable the Zero GNOME clock font tweak";
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
                    value = "GNOME lock-screen and top-bar clock font tweak";
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
                    value = "\n    Applies Zero Mono Thin to the lock-screen time and Zero to the lock-screen\n    date and top-bar clock through GNOME extensions.\n  ";
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
                            value = "Enable the Zero GNOME clock font tweak";
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
                                value = "mono-thin";
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
                          value = "zenos";
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
                      ];
                      type = "assignment";
                      value = {
                        recursive = false;
                        statements = [
                          {
                            operator = "=";
                            target = [
                              {
                                kind = "identifier";
                                value = "customize-clock-on-lockscreen";
                              }
                            ];
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
                                            value = "text";
                                          }
                                        ];
                                        type = "assignment";
                                        value = {
                                          multiline = false;
                                          parts = [
                                            {
                                              type = "text";
                                              value = "%H%n%M";
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
                                                  value = "family";
                                                }
                                              ];
                                              type = "assignment";
                                              value = {
                                                multiline = false;
                                                parts = [
                                                  {
                                                    type = "text";
                                                    value = "Zero Mono Thin";
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
                                                  value = "weight";
                                                }
                                              ];
                                              type = "assignment";
                                              value = {
                                                multiline = false;
                                                parts = [
                                                  {
                                                    type = "text";
                                                    value = "100";
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
                                                  value = "size";
                                                }
                                              ];
                                              type = "assignment";
                                              value = {
                                                kind = "integer";
                                                type = "literal";
                                                value = 84;
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
                                            value = "text";
                                          }
                                        ];
                                        type = "assignment";
                                        value = {
                                          multiline = false;
                                          parts = [
                                            {
                                              type = "text";
                                              value = "%d.%m.%Y";
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
                                                  value = "family";
                                                }
                                              ];
                                              type = "assignment";
                                              value = {
                                                multiline = false;
                                                parts = [
                                                  {
                                                    type = "text";
                                                    value = "Zero";
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
                                                  value = "weight";
                                                }
                                              ];
                                              type = "assignment";
                                              value = {
                                                multiline = false;
                                                parts = [
                                                  {
                                                    type = "text";
                                                    value = "100";
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
                                                  value = "size";
                                                }
                                              ];
                                              type = "assignment";
                                              value = {
                                                kind = "integer";
                                                type = "literal";
                                                value = 24;
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
                                value = "user-themes";
                              }
                            ];
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
                                      value = "theme";
                                    }
                                    {
                                      kind = "identifier";
                                      value = "cssOverride";
                                    }
                                  ];
                                  type = "assignment";
                                  value = {
                                    multiline = true;
                                    parts = [
                                      {
                                        type = "text";
                                        value = "\n          /* The Top Bar Clock */\n          .clock-display {\n              font-family: 'Zero', sans-serif !important;\n              font-weight: normal !important;\n              font-style: normal !important;\n              font-size: 12px;\n          }\n        ";
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
    ];
  }; }
    (lib.mkIf ((cfg.enable)) {
      fonts.packages = [
        pkgs.zenos.byCategories.theming.fonts.zero.regular
        pkgs.zenos.byCategories.theming.fonts.zero.mono-thin
      ];
      zenos.desktops.gnome.extensions = {
        customize-clock-on-lockscreen = {
          enable = true;
          time = {
            enable = true;
            text = "%H%n%M";
            font = {
              family = "Zero Mono Thin";
              weight = "100";
              size = 84;
            };
          };
          date = {
            enable = true;
            text = "%d.%m.%Y";
            font = {
              family = "Zero";
              weight = "100";
              size = 24;
            };
          };
        };
        user-themes = {
          enable = true;
          theme.cssOverride = "\n          /* The Top Bar Clock */\n          .clock-display {\n              font-family: 'Zero', sans-serif !important;\n              font-weight: normal !important;\n              font-style: normal !important;\n              font-size: 12px;\n          }\n        ";
        };
      };
    })
  ];
}
