{ config, lib, pkgs, maintainers ? lib.maintainers, licenses ? lib.licenses, ... }:
let
  cfg = config.zenos.desktops.gnome.tweaks.zenos-extensions;
  name = "zenos-extensions";
in
{
  options.zenos.desktops.gnome.tweaks.zenos-extensions = lib.mkOption { type = (lib.types.submodule ({ ... }: { options = { enable = lib.mkOption { type = lib.types.bool; default = false; }; options = lib.mkOption { type = (lib.types.submodule ({ ... }: { options = { enable = lib.mkOption { type = lib.types.bool; default = true; }; excludedExtensions = lib.mkOption { type = (lib.types.listOf lib.types.str); default = [ ]; }; extensionConfig = lib.mkOption { type = (lib.types.submodule ({ ... }: { options = { enable = lib.mkOption { type = lib.types.bool; default = true; }; }; })); default = { }; }; }; })); default = { }; }; }; })); default = { }; };
  config = lib.mkMerge [
    { _module.args.zenlang.descriptors.desktops.gnome.tweaks.zenos-extensions = {
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
            value = "\n    Enables the curated extension collection, honors name-based exclusions, and\n    applies the contributor module's default settings when requested.\n  ";
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
            value = "Curated ZenOS GNOME extension set";
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
    moduleIdentity = "zenos.desktops.gnome.tweaks.zenos-extensions";
    modulePath = [
      "desktops"
      "gnome"
      "tweaks"
      "zenos-extensions"
    ];
    nodeMetadata = [
      {
        metadata = {
          description = {
            multiline = true;
            parts = [
              {
                type = "text";
                value = "\n    Enables the curated extension collection, honors name-based exclusions, and\n    applies the contributor module's default settings when requested.\n  ";
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
                value = "Curated ZenOS GNOME extension set";
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
                value = "Enable the curated ZenOS GNOME extension set";
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
          "options"
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
                value = "Install curated ZenOS GNOME extensions";
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
          "options"
          "enable"
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
                value = "Curated extensions excluded by name";
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
          "options"
          "excludedExtensions"
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
          "options"
          "extensionConfig"
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
                value = "Apply default ZenOS extension settings";
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
          "options"
          "extensionConfig"
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
                    value = "Curated ZenOS GNOME extension set";
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
                    value = "\n    Enables the curated extension collection, honors name-based exclusions, and\n    applies the contributor module's default settings when requested.\n  ";
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
                            value = "Enable the curated ZenOS GNOME extension set";
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
                        left = {
                          recursive = false;
                          statements = [
                            {
                              operator = "=";
                              target = [
                                {
                                  kind = "identifier";
                                  value = "user-themes";
                                }
                                {
                                  kind = "identifier";
                                  value = "enable";
                                }
                              ];
                              type = "assignment";
                              value = {
                                operand = {
                                  type = "group";
                                  value = {
                                    arguments = [
                                      {
                                        name = "path";
                                        path = [
                                          {
                                            kind = "identifier";
                                            value = "options";
                                          }
                                          {
                                            kind = "identifier";
                                            value = "excludedExtensions";
                                          }
                                        ];
                                        type = "variable";
                                      }
                                    ];
                                    callee = {
                                      arguments = [
                                        {
                                          multiline = false;
                                          parts = [
                                            {
                                              type = "text";
                                              value = "user-themes";
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
                                            value = "elem";
                                          }
                                        ];
                                        type = "variable";
                                      };
                                      type = "call";
                                    };
                                    type = "call";
                                  };
                                };
                                operator = "!";
                                type = "unary";
                              };
                            }
                            {
                              operator = "=";
                              target = [
                                {
                                  kind = "identifier";
                                  value = "app-hider";
                                }
                                {
                                  kind = "identifier";
                                  value = "enable";
                                }
                              ];
                              type = "assignment";
                              value = {
                                operand = {
                                  type = "group";
                                  value = {
                                    arguments = [
                                      {
                                        name = "path";
                                        path = [
                                          {
                                            kind = "identifier";
                                            value = "options";
                                          }
                                          {
                                            kind = "identifier";
                                            value = "excludedExtensions";
                                          }
                                        ];
                                        type = "variable";
                                      }
                                    ];
                                    callee = {
                                      arguments = [
                                        {
                                          multiline = false;
                                          parts = [
                                            {
                                              type = "text";
                                              value = "app-hider";
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
                                            value = "elem";
                                          }
                                        ];
                                        type = "variable";
                                      };
                                      type = "call";
                                    };
                                    type = "call";
                                  };
                                };
                                operator = "!";
                                type = "unary";
                              };
                            }
                            {
                              operator = "=";
                              target = [
                                {
                                  kind = "identifier";
                                  value = "hide-minimized";
                                }
                                {
                                  kind = "identifier";
                                  value = "enable";
                                }
                              ];
                              type = "assignment";
                              value = {
                                operand = {
                                  type = "group";
                                  value = {
                                    arguments = [
                                      {
                                        name = "path";
                                        path = [
                                          {
                                            kind = "identifier";
                                            value = "options";
                                          }
                                          {
                                            kind = "identifier";
                                            value = "excludedExtensions";
                                          }
                                        ];
                                        type = "variable";
                                      }
                                    ];
                                    callee = {
                                      arguments = [
                                        {
                                          multiline = false;
                                          parts = [
                                            {
                                              type = "text";
                                              value = "hide-minimized";
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
                                            value = "elem";
                                          }
                                        ];
                                        type = "variable";
                                      };
                                      type = "call";
                                    };
                                    type = "call";
                                  };
                                };
                                operator = "!";
                                type = "unary";
                              };
                            }
                            {
                              operator = "=";
                              target = [
                                {
                                  kind = "identifier";
                                  value = "hide-cursor";
                                }
                                {
                                  kind = "identifier";
                                  value = "enable";
                                }
                              ];
                              type = "assignment";
                              value = {
                                operand = {
                                  type = "group";
                                  value = {
                                    arguments = [
                                      {
                                        name = "path";
                                        path = [
                                          {
                                            kind = "identifier";
                                            value = "options";
                                          }
                                          {
                                            kind = "identifier";
                                            value = "excludedExtensions";
                                          }
                                        ];
                                        type = "variable";
                                      }
                                    ];
                                    callee = {
                                      arguments = [
                                        {
                                          multiline = false;
                                          parts = [
                                            {
                                              type = "text";
                                              value = "hide-cursor";
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
                                            value = "elem";
                                          }
                                        ];
                                        type = "variable";
                                      };
                                      type = "call";
                                    };
                                    type = "call";
                                  };
                                };
                                operator = "!";
                                type = "unary";
                              };
                            }
                            {
                              operator = "=";
                              target = [
                                {
                                  kind = "identifier";
                                  value = "burn-my-windows";
                                }
                                {
                                  kind = "identifier";
                                  value = "enable";
                                }
                              ];
                              type = "assignment";
                              value = {
                                operand = {
                                  type = "group";
                                  value = {
                                    arguments = [
                                      {
                                        name = "path";
                                        path = [
                                          {
                                            kind = "identifier";
                                            value = "options";
                                          }
                                          {
                                            kind = "identifier";
                                            value = "excludedExtensions";
                                          }
                                        ];
                                        type = "variable";
                                      }
                                    ];
                                    callee = {
                                      arguments = [
                                        {
                                          multiline = false;
                                          parts = [
                                            {
                                              type = "text";
                                              value = "burn-my-windows";
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
                                            value = "elem";
                                          }
                                        ];
                                        type = "variable";
                                      };
                                      type = "call";
                                    };
                                    type = "call";
                                  };
                                };
                                operator = "!";
                                type = "unary";
                              };
                            }
                            {
                              operator = "=";
                              target = [
                                {
                                  kind = "identifier";
                                  value = "compiz-windows-effect";
                                }
                                {
                                  kind = "identifier";
                                  value = "enable";
                                }
                              ];
                              type = "assignment";
                              value = {
                                operand = {
                                  type = "group";
                                  value = {
                                    arguments = [
                                      {
                                        name = "path";
                                        path = [
                                          {
                                            kind = "identifier";
                                            value = "options";
                                          }
                                          {
                                            kind = "identifier";
                                            value = "excludedExtensions";
                                          }
                                        ];
                                        type = "variable";
                                      }
                                    ];
                                    callee = {
                                      arguments = [
                                        {
                                          multiline = false;
                                          parts = [
                                            {
                                              type = "text";
                                              value = "compiz-windows-effect";
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
                                            value = "elem";
                                          }
                                        ];
                                        type = "variable";
                                      };
                                      type = "call";
                                    };
                                    type = "call";
                                  };
                                };
                                operator = "!";
                                type = "unary";
                              };
                            }
                            {
                              operator = "=";
                              target = [
                                {
                                  kind = "identifier";
                                  value = "compiz-alike-magic-lamp-effect";
                                }
                                {
                                  kind = "identifier";
                                  value = "enable";
                                }
                              ];
                              type = "assignment";
                              value = {
                                operand = {
                                  type = "group";
                                  value = {
                                    arguments = [
                                      {
                                        name = "path";
                                        path = [
                                          {
                                            kind = "identifier";
                                            value = "options";
                                          }
                                          {
                                            kind = "identifier";
                                            value = "excludedExtensions";
                                          }
                                        ];
                                        type = "variable";
                                      }
                                    ];
                                    callee = {
                                      arguments = [
                                        {
                                          multiline = false;
                                          parts = [
                                            {
                                              type = "text";
                                              value = "compiz-alike-magic-lamp-effect";
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
                                            value = "elem";
                                          }
                                        ];
                                        type = "variable";
                                      };
                                      type = "call";
                                    };
                                    type = "call";
                                  };
                                };
                                operator = "!";
                                type = "unary";
                              };
                            }
                            {
                              operator = "=";
                              target = [
                                {
                                  kind = "identifier";
                                  value = "rounded-window-corners-reborn";
                                }
                                {
                                  kind = "identifier";
                                  value = "enable";
                                }
                              ];
                              type = "assignment";
                              value = {
                                operand = {
                                  type = "group";
                                  value = {
                                    arguments = [
                                      {
                                        name = "path";
                                        path = [
                                          {
                                            kind = "identifier";
                                            value = "options";
                                          }
                                          {
                                            kind = "identifier";
                                            value = "excludedExtensions";
                                          }
                                        ];
                                        type = "variable";
                                      }
                                    ];
                                    callee = {
                                      arguments = [
                                        {
                                          multiline = false;
                                          parts = [
                                            {
                                              type = "text";
                                              value = "rounded-window-corners-reborn";
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
                                            value = "elem";
                                          }
                                        ];
                                        type = "variable";
                                      };
                                      type = "call";
                                    };
                                    type = "call";
                                  };
                                };
                                operator = "!";
                                type = "unary";
                              };
                            }
                            {
                              operator = "=";
                              target = [
                                {
                                  kind = "identifier";
                                  value = "alphabetical-app-grid";
                                }
                                {
                                  kind = "identifier";
                                  value = "enable";
                                }
                              ];
                              type = "assignment";
                              value = {
                                operand = {
                                  type = "group";
                                  value = {
                                    arguments = [
                                      {
                                        name = "path";
                                        path = [
                                          {
                                            kind = "identifier";
                                            value = "options";
                                          }
                                          {
                                            kind = "identifier";
                                            value = "excludedExtensions";
                                          }
                                        ];
                                        type = "variable";
                                      }
                                    ];
                                    callee = {
                                      arguments = [
                                        {
                                          multiline = false;
                                          parts = [
                                            {
                                              type = "text";
                                              value = "alphabetical-app-grid";
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
                                            value = "elem";
                                          }
                                        ];
                                        type = "variable";
                                      };
                                      type = "call";
                                    };
                                    type = "call";
                                  };
                                };
                                operator = "!";
                                type = "unary";
                              };
                            }
                            {
                              operator = "=";
                              target = [
                                {
                                  kind = "identifier";
                                  value = "category-sorted-app-grid";
                                }
                                {
                                  kind = "identifier";
                                  value = "enable";
                                }
                              ];
                              type = "assignment";
                              value = {
                                operand = {
                                  type = "group";
                                  value = {
                                    arguments = [
                                      {
                                        name = "path";
                                        path = [
                                          {
                                            kind = "identifier";
                                            value = "options";
                                          }
                                          {
                                            kind = "identifier";
                                            value = "excludedExtensions";
                                          }
                                        ];
                                        type = "variable";
                                      }
                                    ];
                                    callee = {
                                      arguments = [
                                        {
                                          multiline = false;
                                          parts = [
                                            {
                                              type = "text";
                                              value = "category-sorted-app-grid";
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
                                            value = "elem";
                                          }
                                        ];
                                        type = "variable";
                                      };
                                      type = "call";
                                    };
                                    type = "call";
                                  };
                                };
                                operator = "!";
                                type = "unary";
                              };
                            }
                            {
                              operator = "=";
                              target = [
                                {
                                  kind = "identifier";
                                  value = "coverflow-alt-tab";
                                }
                                {
                                  kind = "identifier";
                                  value = "enable";
                                }
                              ];
                              type = "assignment";
                              value = {
                                operand = {
                                  type = "group";
                                  value = {
                                    arguments = [
                                      {
                                        name = "path";
                                        path = [
                                          {
                                            kind = "identifier";
                                            value = "options";
                                          }
                                          {
                                            kind = "identifier";
                                            value = "excludedExtensions";
                                          }
                                        ];
                                        type = "variable";
                                      }
                                    ];
                                    callee = {
                                      arguments = [
                                        {
                                          multiline = false;
                                          parts = [
                                            {
                                              type = "text";
                                              value = "coverflow-alt-tab";
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
                                            value = "elem";
                                          }
                                        ];
                                        type = "variable";
                                      };
                                      type = "call";
                                    };
                                    type = "call";
                                  };
                                };
                                operator = "!";
                                type = "unary";
                              };
                            }
                            {
                              operator = "=";
                              target = [
                                {
                                  kind = "identifier";
                                  value = "hide-top-bar";
                                }
                                {
                                  kind = "identifier";
                                  value = "enable";
                                }
                              ];
                              type = "assignment";
                              value = {
                                operand = {
                                  type = "group";
                                  value = {
                                    arguments = [
                                      {
                                        name = "path";
                                        path = [
                                          {
                                            kind = "identifier";
                                            value = "options";
                                          }
                                          {
                                            kind = "identifier";
                                            value = "excludedExtensions";
                                          }
                                        ];
                                        type = "variable";
                                      }
                                    ];
                                    callee = {
                                      arguments = [
                                        {
                                          multiline = false;
                                          parts = [
                                            {
                                              type = "text";
                                              value = "hide-top-bar";
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
                                            value = "elem";
                                          }
                                        ];
                                        type = "variable";
                                      };
                                      type = "call";
                                    };
                                    type = "call";
                                  };
                                };
                                operator = "!";
                                type = "unary";
                              };
                            }
                            {
                              operator = "=";
                              target = [
                                {
                                  kind = "identifier";
                                  value = "mouse-tail";
                                }
                                {
                                  kind = "identifier";
                                  value = "enable";
                                }
                              ];
                              type = "assignment";
                              value = {
                                operand = {
                                  type = "group";
                                  value = {
                                    arguments = [
                                      {
                                        name = "path";
                                        path = [
                                          {
                                            kind = "identifier";
                                            value = "options";
                                          }
                                          {
                                            kind = "identifier";
                                            value = "excludedExtensions";
                                          }
                                        ];
                                        type = "variable";
                                      }
                                    ];
                                    callee = {
                                      arguments = [
                                        {
                                          multiline = false;
                                          parts = [
                                            {
                                              type = "text";
                                              value = "mouse-tail";
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
                                            value = "elem";
                                          }
                                        ];
                                        type = "variable";
                                      };
                                      type = "call";
                                    };
                                    type = "call";
                                  };
                                };
                                operator = "!";
                                type = "unary";
                              };
                            }
                            {
                              operator = "=";
                              target = [
                                {
                                  kind = "identifier";
                                  value = "window-is-ready-remover";
                                }
                                {
                                  kind = "identifier";
                                  value = "enable";
                                }
                              ];
                              type = "assignment";
                              value = {
                                operand = {
                                  type = "group";
                                  value = {
                                    arguments = [
                                      {
                                        name = "path";
                                        path = [
                                          {
                                            kind = "identifier";
                                            value = "options";
                                          }
                                          {
                                            kind = "identifier";
                                            value = "excludedExtensions";
                                          }
                                        ];
                                        type = "variable";
                                      }
                                    ];
                                    callee = {
                                      arguments = [
                                        {
                                          multiline = false;
                                          parts = [
                                            {
                                              type = "text";
                                              value = "window-is-ready-remover";
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
                                            value = "elem";
                                          }
                                        ];
                                        type = "variable";
                                      };
                                      type = "call";
                                    };
                                    type = "call";
                                  };
                                };
                                operator = "!";
                                type = "unary";
                              };
                            }
                            {
                              operator = "=";
                              target = [
                                {
                                  kind = "identifier";
                                  value = "date-menu-formatter";
                                }
                                {
                                  kind = "identifier";
                                  value = "enable";
                                }
                              ];
                              type = "assignment";
                              value = {
                                operand = {
                                  type = "group";
                                  value = {
                                    arguments = [
                                      {
                                        name = "path";
                                        path = [
                                          {
                                            kind = "identifier";
                                            value = "options";
                                          }
                                          {
                                            kind = "identifier";
                                            value = "excludedExtensions";
                                          }
                                        ];
                                        type = "variable";
                                      }
                                    ];
                                    callee = {
                                      arguments = [
                                        {
                                          multiline = false;
                                          parts = [
                                            {
                                              type = "text";
                                              value = "date-menu-formatter";
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
                                            value = "elem";
                                          }
                                        ];
                                        type = "variable";
                                      };
                                      type = "call";
                                    };
                                    type = "call";
                                  };
                                };
                                operator = "!";
                                type = "unary";
                              };
                            }
                            {
                              operator = "=";
                              target = [
                                {
                                  kind = "identifier";
                                  value = "gsconnect";
                                }
                                {
                                  kind = "identifier";
                                  value = "enable";
                                }
                              ];
                              type = "assignment";
                              value = {
                                operand = {
                                  type = "group";
                                  value = {
                                    arguments = [
                                      {
                                        name = "path";
                                        path = [
                                          {
                                            kind = "identifier";
                                            value = "options";
                                          }
                                          {
                                            kind = "identifier";
                                            value = "excludedExtensions";
                                          }
                                        ];
                                        type = "variable";
                                      }
                                    ];
                                    callee = {
                                      arguments = [
                                        {
                                          multiline = false;
                                          parts = [
                                            {
                                              type = "text";
                                              value = "gsconnect";
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
                                            value = "elem";
                                          }
                                        ];
                                        type = "variable";
                                      };
                                      type = "call";
                                    };
                                    type = "call";
                                  };
                                };
                                operator = "!";
                                type = "unary";
                              };
                            }
                            {
                              operator = "=";
                              target = [
                                {
                                  kind = "identifier";
                                  value = "clipboard-indicator";
                                }
                                {
                                  kind = "identifier";
                                  value = "enable";
                                }
                              ];
                              type = "assignment";
                              value = {
                                operand = {
                                  type = "group";
                                  value = {
                                    arguments = [
                                      {
                                        name = "path";
                                        path = [
                                          {
                                            kind = "identifier";
                                            value = "options";
                                          }
                                          {
                                            kind = "identifier";
                                            value = "excludedExtensions";
                                          }
                                        ];
                                        type = "variable";
                                      }
                                    ];
                                    callee = {
                                      arguments = [
                                        {
                                          multiline = false;
                                          parts = [
                                            {
                                              type = "text";
                                              value = "clipboard-indicator";
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
                                            value = "elem";
                                          }
                                        ];
                                        type = "variable";
                                      };
                                      type = "call";
                                    };
                                    type = "call";
                                  };
                                };
                                operator = "!";
                                type = "unary";
                              };
                            }
                            {
                              operator = "=";
                              target = [
                                {
                                  kind = "identifier";
                                  value = "notification-timeout";
                                }
                                {
                                  kind = "identifier";
                                  value = "enable";
                                }
                              ];
                              type = "assignment";
                              value = {
                                operand = {
                                  type = "group";
                                  value = {
                                    arguments = [
                                      {
                                        name = "path";
                                        path = [
                                          {
                                            kind = "identifier";
                                            value = "options";
                                          }
                                          {
                                            kind = "identifier";
                                            value = "excludedExtensions";
                                          }
                                        ];
                                        type = "variable";
                                      }
                                    ];
                                    callee = {
                                      arguments = [
                                        {
                                          multiline = false;
                                          parts = [
                                            {
                                              type = "text";
                                              value = "notification-timeout";
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
                                            value = "elem";
                                          }
                                        ];
                                        type = "variable";
                                      };
                                      type = "call";
                                    };
                                    type = "call";
                                  };
                                };
                                operator = "!";
                                type = "unary";
                              };
                            }
                            {
                              operator = "=";
                              target = [
                                {
                                  kind = "identifier";
                                  value = "forge";
                                }
                                {
                                  kind = "identifier";
                                  value = "enable";
                                }
                              ];
                              type = "assignment";
                              value = {
                                operand = {
                                  type = "group";
                                  value = {
                                    arguments = [
                                      {
                                        name = "path";
                                        path = [
                                          {
                                            kind = "identifier";
                                            value = "options";
                                          }
                                          {
                                            kind = "identifier";
                                            value = "excludedExtensions";
                                          }
                                        ];
                                        type = "variable";
                                      }
                                    ];
                                    callee = {
                                      arguments = [
                                        {
                                          multiline = false;
                                          parts = [
                                            {
                                              type = "text";
                                              value = "forge";
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
                                            value = "elem";
                                          }
                                        ];
                                        type = "variable";
                                      };
                                      type = "call";
                                    };
                                    type = "call";
                                  };
                                };
                                operator = "!";
                                type = "unary";
                              };
                            }
                            {
                              operator = "=";
                              target = [
                                {
                                  kind = "identifier";
                                  value = "zenlink-indicator";
                                }
                                {
                                  kind = "identifier";
                                  value = "enable";
                                }
                              ];
                              type = "assignment";
                              value = {
                                operand = {
                                  type = "group";
                                  value = {
                                    arguments = [
                                      {
                                        name = "path";
                                        path = [
                                          {
                                            kind = "identifier";
                                            value = "options";
                                          }
                                          {
                                            kind = "identifier";
                                            value = "excludedExtensions";
                                          }
                                        ];
                                        type = "variable";
                                      }
                                    ];
                                    callee = {
                                      arguments = [
                                        {
                                          multiline = false;
                                          parts = [
                                            {
                                              type = "text";
                                              value = "zenlink-indicator";
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
                                            value = "elem";
                                          }
                                        ];
                                        type = "variable";
                                      };
                                      type = "call";
                                    };
                                    type = "call";
                                  };
                                };
                                operator = "!";
                                type = "unary";
                              };
                            }
                            {
                              operator = "=";
                              target = [
                                {
                                  kind = "identifier";
                                  value = "blur-my-shell";
                                }
                                {
                                  kind = "identifier";
                                  value = "enable";
                                }
                              ];
                              type = "assignment";
                              value = {
                                operand = {
                                  type = "group";
                                  value = {
                                    arguments = [
                                      {
                                        name = "path";
                                        path = [
                                          {
                                            kind = "identifier";
                                            value = "options";
                                          }
                                          {
                                            kind = "identifier";
                                            value = "excludedExtensions";
                                          }
                                        ];
                                        type = "variable";
                                      }
                                    ];
                                    callee = {
                                      arguments = [
                                        {
                                          multiline = false;
                                          parts = [
                                            {
                                              type = "text";
                                              value = "blur-my-shell";
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
                                            value = "elem";
                                          }
                                        ];
                                        type = "variable";
                                      };
                                      type = "call";
                                    };
                                    type = "call";
                                  };
                                };
                                operator = "!";
                                type = "unary";
                              };
                            }
                          ];
                          type = "attr-set";
                        };
                        operator = "//";
                        right = {
                          type = "group";
                          value = {
                            condition = {
                              name = "path";
                              path = [
                                {
                                  kind = "identifier";
                                  value = "options";
                                }
                                {
                                  kind = "identifier";
                                  value = "extensionConfig";
                                }
                                {
                                  kind = "identifier";
                                  value = "enable";
                                }
                              ];
                              type = "variable";
                            };
                            "else" = {
                              recursive = false;
                              statements = [ ];
                              type = "attr-set";
                            };
                            "then" = {
                              recursive = false;
                              statements = [
                                {
                                  operator = "=";
                                  target = [
                                    {
                                      kind = "identifier";
                                      value = "app-hider";
                                    }
                                    {
                                      kind = "identifier";
                                      value = "hidden-apps";
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
                                            value = "vesktop.desktop";
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
                                      value = "burn-my-windows";
                                    }
                                  ];
                                  type = "assignment";
                                  value = {
                                    recursive = false;
                                    statements = [
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
                                          kind = "integer";
                                          type = "literal";
                                          value = 2;
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
                                          kind = "integer";
                                          type = "literal";
                                          value = 47;
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
                                          kind = "integer";
                                          type = "literal";
                                          value = 47;
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
                                                  value = "apparition-enable-effect";
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
                                                  value = "fire-enable-effect";
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
                                                  value = "aura-glow-enable-effect";
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
                                                  value = "broken-glass-enable-effect";
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
                                                  value = "doom-enable-effect";
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
                                                  value = "energize-a-enable-effect";
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
                                                  value = "energize-b-enable-effect";
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
                                                  value = "focus-enable-effect";
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
                                                  value = "glide-enable-effect";
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
                                                  value = "glitch-enable-effect";
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
                                                  value = "hexagon-enable-effect";
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
                                                  value = "incinerate-enable-effect";
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
                                                  value = "matrix-enable-effect";
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
                                                  value = "mushroom-enable-effect";
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
                                                  value = "paint-brush-enable-effect";
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
                                                  value = "pixelate-enable-effect";
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
                                                  value = "pixel-wheel-enable-effect";
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
                                                  value = "pixel-wipe-enable-effect";
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
                                                  value = "portal-enable-effect";
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
                                                  value = "rgbwarp-enable-effect";
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
                                                  value = "snap-enable-effect";
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
                                                  value = "team-rocket-enable-effect";
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
                                                  value = "trex-enable-effect";
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
                                                  value = "tv-enable-effect";
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
                                                  value = "tv-glitch-enable-effect";
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
                                                  value = "wisps-enable-effect";
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
                                                  value = "glide-scale";
                                                }
                                              ];
                                              type = "assignment";
                                              value = {
                                                kind = "float";
                                                type = "literal";
                                                value = 0.7;
                                              };
                                            }
                                            {
                                              operator = "=";
                                              target = [
                                                {
                                                  kind = "identifier";
                                                  value = "glide-squish";
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
                                                  value = "glide-tilt";
                                                }
                                              ];
                                              type = "assignment";
                                              value = {
                                                operand = {
                                                  kind = "float";
                                                  type = "literal";
                                                  value = 1.0;
                                                };
                                                operator = "-";
                                                type = "unary";
                                              };
                                            }
                                            {
                                              operator = "=";
                                              target = [
                                                {
                                                  kind = "identifier";
                                                  value = "glide-shift";
                                                }
                                              ];
                                              type = "assignment";
                                              value = {
                                                operand = {
                                                  kind = "float";
                                                  type = "literal";
                                                  value = 0.2;
                                                };
                                                operator = "-";
                                                type = "unary";
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
                                {
                                  operator = "=";
                                  target = [
                                    {
                                      kind = "identifier";
                                      value = "compiz-windows-effect";
                                    }
                                  ];
                                  type = "assignment";
                                  value = {
                                    recursive = false;
                                    statements = [
                                      {
                                        operator = "=";
                                        target = [
                                          {
                                            kind = "identifier";
                                            value = "friction";
                                          }
                                        ];
                                        type = "assignment";
                                        value = {
                                          kind = "float";
                                          type = "literal";
                                          value = 5.0;
                                        };
                                      }
                                      {
                                        operator = "=";
                                        target = [
                                          {
                                            kind = "identifier";
                                            value = "mass";
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
                                            value = "resize-effect";
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
                                            value = "speedup-factor-divider";
                                          }
                                        ];
                                        type = "assignment";
                                        value = {
                                          kind = "float";
                                          type = "literal";
                                          value = 5.0;
                                        };
                                      }
                                      {
                                        operator = "=";
                                        target = [
                                          {
                                            kind = "identifier";
                                            value = "spring-k";
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
                                      value = "rounded-window-corners-reborn";
                                    }
                                  ];
                                  type = "assignment";
                                  value = {
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
                                            value = "global-rounded-corner-settings";
                                          }
                                        ];
                                        type = "assignment";
                                        value = {
                                          recursive = false;
                                          statements = [
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
                                                  value = "smoothing";
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
                                                  value = "borderColor";
                                                }
                                              ];
                                              type = "assignment";
                                              value = {
                                                multiline = false;
                                                parts = [
                                                  {
                                                    type = "text";
                                                    value = "#ffffff12";
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
                                                        value = "fullscreen";
                                                      }
                                                    ];
                                                    type = "assignment";
                                                    value = {
                                                      kind = "false";
                                                      type = "literal";
                                                      value = false;
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
                                      value = "alphabetical-app-grid";
                                    }
                                    {
                                      kind = "identifier";
                                      value = "folder-order-position";
                                    }
                                  ];
                                  type = "assignment";
                                  value = {
                                    multiline = false;
                                    parts = [
                                      {
                                        type = "text";
                                        value = "end";
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
                                      value = "coverflow-alt-tab";
                                    }
                                  ];
                                  type = "assignment";
                                  value = {
                                    recursive = false;
                                    statements = [
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
                                            value = "icon-style";
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
                                            value = "switcher-background-color";
                                          }
                                        ];
                                        type = "assignment";
                                        value = {
                                          multiline = false;
                                          parts = [
                                            {
                                              type = "text";
                                              value = "#ffffff";
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
                                            value = "use-glitch-effect";
                                          }
                                        ];
                                        type = "assignment";
                                        value = {
                                          kind = "false";
                                          type = "literal";
                                          value = false;
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
                                      value = "hide-top-bar";
                                    }
                                  ];
                                  type = "assignment";
                                  value = {
                                    recursive = false;
                                    statements = [
                                      {
                                        operator = "=";
                                        target = [
                                          {
                                            kind = "identifier";
                                            value = "enable-intellihide";
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
                                            value = "mouse-sensitive";
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
                                            value = "mouse-sensitive-fullscreen-window";
                                          }
                                        ];
                                        type = "assignment";
                                        value = {
                                          kind = "false";
                                          type = "literal";
                                          value = false;
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
                                      value = "date-menu-formatter";
                                    }
                                  ];
                                  type = "assignment";
                                  value = {
                                    recursive = false;
                                    statements = [
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
                                      value = "notification-timeout";
                                    }
                                    {
                                      kind = "identifier";
                                      value = "timeout";
                                    }
                                  ];
                                  type = "assignment";
                                  value = {
                                    kind = "integer";
                                    type = "literal";
                                    value = 2000;
                                  };
                                }
                                {
                                  operator = "=";
                                  target = [
                                    {
                                      kind = "identifier";
                                      value = "forge";
                                    }
                                  ];
                                  type = "assignment";
                                  value = {
                                    recursive = false;
                                    statements = [
                                      {
                                        operator = "=";
                                        target = [
                                          {
                                            kind = "identifier";
                                            value = "css-last-update";
                                          }
                                        ];
                                        type = "assignment";
                                        value = {
                                          kind = "integer";
                                          type = "literal";
                                          value = 37;
                                        };
                                      }
                                      {
                                        operator = "=";
                                        target = [
                                          {
                                            kind = "identifier";
                                            value = "dnd-center-layout";
                                          }
                                        ];
                                        type = "assignment";
                                        value = {
                                          multiline = false;
                                          parts = [
                                            {
                                              type = "text";
                                              value = "swap";
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
                                            value = "float-always-on-top-enabled";
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
                                            value = "focus-border-toggle";
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
                                            value = "quick-settings-enabled";
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
                                            value = "split-border-toggle";
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
                                            value = "stacked-tiling-mode-enabled";
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
                                            value = "tabbed-tiling-mode-enabled";
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
                                            value = "window-gap-size";
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
                                      value = "blur-my-shell";
                                    }
                                  ];
                                  type = "assignment";
                                  value = {
                                    recursive = false;
                                    statements = [
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
                                                  value = "settings-version";
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
                                                  kind = "identifier";
                                                  value = "pipelines";
                                                }
                                              ];
                                              type = "assignment";
                                              value = {
                                                recursive = false;
                                                statements = [
                                                  {
                                                    operator = "=";
                                                    target = [
                                                      {
                                                        kind = "identifier";
                                                        value = "pipeline_default";
                                                      }
                                                    ];
                                                    type = "assignment";
                                                    value = {
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
                                                                value = "Default";
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
                                                              value = "effects";
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
                                                                        value = "blur";
                                                                      }
                                                                      {
                                                                        kind = "identifier";
                                                                        value = "gaussian";
                                                                      }
                                                                    ];
                                                                    type = "assignment";
                                                                    value = {
                                                                      recursive = false;
                                                                      statements = [
                                                                        {
                                                                          operator = "=";
                                                                          target = [
                                                                            {
                                                                              kind = "identifier";
                                                                              value = "radius";
                                                                            }
                                                                          ];
                                                                          type = "assignment";
                                                                          value = {
                                                                            kind = "integer";
                                                                            type = "literal";
                                                                            value = 30;
                                                                          };
                                                                        }
                                                                        {
                                                                          operator = "=";
                                                                          target = [
                                                                            {
                                                                              kind = "identifier";
                                                                              value = "brightness";
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
                                                                              value = "unscaled_radius";
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
                                                                ];
                                                                type = "attr-set";
                                                              }
                                                              {
                                                                recursive = false;
                                                                statements = [
                                                                  {
                                                                    operator = "=";
                                                                    target = [
                                                                      {
                                                                        kind = "identifier";
                                                                        value = "noise";
                                                                      }
                                                                    ];
                                                                    type = "assignment";
                                                                    value = {
                                                                      recursive = false;
                                                                      statements = [ ];
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
                                                      ];
                                                      type = "attr-set";
                                                    };
                                                  }
                                                  {
                                                    operator = "=";
                                                    target = [
                                                      {
                                                        kind = "identifier";
                                                        value = "pipeline_default_rounded";
                                                      }
                                                    ];
                                                    type = "assignment";
                                                    value = {
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
                                                                value = "Default rounded";
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
                                                              value = "effects";
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
                                                                        value = "blur";
                                                                      }
                                                                      {
                                                                        kind = "identifier";
                                                                        value = "gaussian";
                                                                      }
                                                                    ];
                                                                    type = "assignment";
                                                                    value = {
                                                                      recursive = false;
                                                                      statements = [
                                                                        {
                                                                          operator = "=";
                                                                          target = [
                                                                            {
                                                                              kind = "identifier";
                                                                              value = "radius";
                                                                            }
                                                                          ];
                                                                          type = "assignment";
                                                                          value = {
                                                                            kind = "integer";
                                                                            type = "literal";
                                                                            value = 30;
                                                                          };
                                                                        }
                                                                        {
                                                                          operator = "=";
                                                                          target = [
                                                                            {
                                                                              kind = "identifier";
                                                                              value = "brightness";
                                                                            }
                                                                          ];
                                                                          type = "assignment";
                                                                          value = {
                                                                            kind = "float";
                                                                            type = "literal";
                                                                            value = 0.6;
                                                                          };
                                                                        }
                                                                      ];
                                                                      type = "attr-set";
                                                                    };
                                                                  }
                                                                ];
                                                                type = "attr-set";
                                                              }
                                                              {
                                                                recursive = false;
                                                                statements = [
                                                                  {
                                                                    operator = "=";
                                                                    target = [
                                                                      {
                                                                        kind = "identifier";
                                                                        value = "corner";
                                                                      }
                                                                      {
                                                                        kind = "identifier";
                                                                        value = "radius";
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
                                      }
                                      {
                                        operator = "=";
                                        target = [
                                          {
                                            kind = "identifier";
                                            value = "appfolder";
                                          }
                                        ];
                                        type = "assignment";
                                        value = {
                                          recursive = false;
                                          statements = [
                                            {
                                              operator = "=";
                                              target = [
                                                {
                                                  kind = "identifier";
                                                  value = "brightness";
                                                }
                                              ];
                                              type = "assignment";
                                              value = {
                                                kind = "float";
                                                type = "literal";
                                                value = 0.6;
                                              };
                                            }
                                            {
                                              operator = "=";
                                              target = [
                                                {
                                                  kind = "identifier";
                                                  value = "sigma";
                                                }
                                              ];
                                              type = "assignment";
                                              value = {
                                                kind = "integer";
                                                type = "literal";
                                                value = 60;
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
                                            value = "coverflow-alt-tab";
                                          }
                                          {
                                            kind = "identifier";
                                            value = "pipeline";
                                          }
                                        ];
                                        type = "assignment";
                                        value = {
                                          multiline = false;
                                          parts = [
                                            {
                                              type = "text";
                                              value = "pipeline_default";
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
                                            value = "lockscreen";
                                          }
                                          {
                                            kind = "identifier";
                                            value = "pipeline";
                                          }
                                        ];
                                        type = "assignment";
                                        value = {
                                          multiline = false;
                                          parts = [
                                            {
                                              type = "text";
                                              value = "pipeline_default";
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
                                            value = "overview";
                                          }
                                          {
                                            kind = "identifier";
                                            value = "pipeline";
                                          }
                                        ];
                                        type = "assignment";
                                        value = {
                                          multiline = false;
                                          parts = [
                                            {
                                              type = "text";
                                              value = "pipeline_default";
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
                                            value = "panel";
                                          }
                                          {
                                            kind = "identifier";
                                            value = "blur";
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
                                            value = "screenshot";
                                          }
                                          {
                                            kind = "identifier";
                                            value = "pipeline";
                                          }
                                        ];
                                        type = "assignment";
                                        value = {
                                          multiline = false;
                                          parts = [
                                            {
                                              type = "text";
                                              value = "pipeline_default";
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
                                            value = "window-list";
                                          }
                                        ];
                                        type = "assignment";
                                        value = {
                                          recursive = false;
                                          statements = [
                                            {
                                              operator = "=";
                                              target = [
                                                {
                                                  kind = "identifier";
                                                  value = "brightness";
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
                                                  value = "sigma";
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
                                    ];
                                    type = "attr-set";
                                  };
                                }
                              ];
                              type = "attr-set";
                            };
                            type = "if";
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
            value = "options";
          }
        ];
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
                                value = "Install curated ZenOS GNOME extensions";
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
                  value = "excludedExtensions";
                }
              ];
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
                                value = "Curated extensions excluded by name";
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
                  value = "extensionConfig";
                }
              ];
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
                                      value = "Apply default ZenOS extension settings";
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
    ];
  }; }
    (lib.mkIf ((cfg.enable)) {
      zenos.desktops.gnome.extensions = ({
        user-themes.enable = (!(((lib.elem "user-themes") cfg.options.excludedExtensions)));
        app-hider.enable = (!(((lib.elem "app-hider") cfg.options.excludedExtensions)));
        hide-minimized.enable = (!(((lib.elem "hide-minimized") cfg.options.excludedExtensions)));
        hide-cursor.enable = (!(((lib.elem "hide-cursor") cfg.options.excludedExtensions)));
        burn-my-windows.enable = (!(((lib.elem "burn-my-windows") cfg.options.excludedExtensions)));
        compiz-windows-effect.enable = (!(((lib.elem "compiz-windows-effect") cfg.options.excludedExtensions)));
        compiz-alike-magic-lamp-effect.enable = (!(((lib.elem "compiz-alike-magic-lamp-effect") cfg.options.excludedExtensions)));
        rounded-window-corners-reborn.enable = (!(((lib.elem "rounded-window-corners-reborn") cfg.options.excludedExtensions)));
        alphabetical-app-grid.enable = (!(((lib.elem "alphabetical-app-grid") cfg.options.excludedExtensions)));
        category-sorted-app-grid.enable = (!(((lib.elem "category-sorted-app-grid") cfg.options.excludedExtensions)));
        coverflow-alt-tab.enable = (!(((lib.elem "coverflow-alt-tab") cfg.options.excludedExtensions)));
        hide-top-bar.enable = (!(((lib.elem "hide-top-bar") cfg.options.excludedExtensions)));
        mouse-tail.enable = (!(((lib.elem "mouse-tail") cfg.options.excludedExtensions)));
        window-is-ready-remover.enable = (!(((lib.elem "window-is-ready-remover") cfg.options.excludedExtensions)));
        date-menu-formatter.enable = (!(((lib.elem "date-menu-formatter") cfg.options.excludedExtensions)));
        gsconnect.enable = (!(((lib.elem "gsconnect") cfg.options.excludedExtensions)));
        clipboard-indicator.enable = (!(((lib.elem "clipboard-indicator") cfg.options.excludedExtensions)));
        notification-timeout.enable = (!(((lib.elem "notification-timeout") cfg.options.excludedExtensions)));
        forge.enable = (!(((lib.elem "forge") cfg.options.excludedExtensions)));
        zenlink-indicator.enable = (!(((lib.elem "zenlink-indicator") cfg.options.excludedExtensions)));
        blur-my-shell.enable = (!(((lib.elem "blur-my-shell") cfg.options.excludedExtensions)));
      } // ((if cfg.options.extensionConfig.enable then {
        app-hider.hidden-apps = [
          "vesktop.desktop"
        ];
        burn-my-windows = {
          prefs-open-count = 2;
          last-extension-version = 47;
          last-prefs-version = 47;
          settings = {
            apparition-enable-effect = false;
            fire-enable-effect = false;
            aura-glow-enable-effect = false;
            broken-glass-enable-effect = false;
            doom-enable-effect = false;
            energize-a-enable-effect = false;
            energize-b-enable-effect = false;
            focus-enable-effect = false;
            glide-enable-effect = true;
            glitch-enable-effect = false;
            hexagon-enable-effect = false;
            incinerate-enable-effect = false;
            matrix-enable-effect = false;
            mushroom-enable-effect = false;
            paint-brush-enable-effect = false;
            pixelate-enable-effect = false;
            pixel-wheel-enable-effect = false;
            pixel-wipe-enable-effect = false;
            portal-enable-effect = false;
            rgbwarp-enable-effect = false;
            snap-enable-effect = false;
            team-rocket-enable-effect = false;
            trex-enable-effect = false;
            tv-enable-effect = false;
            tv-glitch-enable-effect = false;
            wisps-enable-effect = false;
            glide-scale = 0.7;
            glide-squish = 1.0;
            glide-tilt = (-1.0);
            glide-shift = (-0.2);
            glide-animation-time = 150;
          };
        };
        compiz-windows-effect = {
          friction = 5.0;
          mass = 50.0;
          resize-effect = true;
          speedup-factor-divider = 5.0;
          spring-k = 2.0;
        };
        rounded-window-corners-reborn = {
          border-width = 1;
          global-rounded-corner-settings = {
            enabled = true;
            borderRadius = 12;
            smoothing = 0;
            borderColor = "#ffffff12";
            padding = {
              left = 1;
              right = 1;
              top = 1;
              bottom = 1;
            };
            keepRoundedCorners = {
              maximized = false;
              fullscreen = false;
            };
          };
        };
        alphabetical-app-grid.folder-order-position = "end";
        coverflow-alt-tab = {
          desaturate-factor = 0.0;
          icon-style = "Classic";
          switcher-background-color = "#ffffff";
          use-glitch-effect = false;
        };
        hide-top-bar = {
          enable-intellihide = false;
          mouse-sensitive = true;
          mouse-sensitive-fullscreen-window = false;
        };
        date-menu-formatter = {
          pattern = "dd.MM  HH:mm";
          formatter = "01_luxon";
          text-align = "center";
          update-level = 1;
        };
        notification-timeout.timeout = 2000;
        forge = {
          css-last-update = 37;
          dnd-center-layout = "swap";
          float-always-on-top-enabled = false;
          focus-border-toggle = false;
          quick-settings-enabled = false;
          split-border-toggle = false;
          stacked-tiling-mode-enabled = false;
          tabbed-tiling-mode-enabled = false;
          window-gap-size = 4;
        };
        blur-my-shell = {
          general = {
            settings-version = 2;
            pipelines = {
              pipeline_default = {
                name = "Default";
                effects = [
                  {
                    blur.gaussian = {
                      radius = 30;
                      brightness = 0.3;
                      unscaled_radius = 100;
                    };
                  }
                  {
                    noise = { };
                  }
                ];
              };
              pipeline_default_rounded = {
                name = "Default rounded";
                effects = [
                  {
                    blur.gaussian = {
                      radius = 30;
                      brightness = 0.6;
                    };
                  }
                  {
                    corner.radius = 24;
                  }
                ];
              };
            };
          };
          appfolder = {
            brightness = 0.6;
            sigma = 60;
          };
          coverflow-alt-tab.pipeline = "pipeline_default";
          lockscreen.pipeline = "pipeline_default";
          overview.pipeline = "pipeline_default";
          panel.blur = false;
          screenshot.pipeline = "pipeline_default";
          window-list = {
            brightness = 0.3;
            sigma = 100;
          };
        };
      } else { })));
    })
  ];
}
