{ config, lib, pkgs, maintainers ? lib.maintainers, licenses ? lib.licenses, ... }:
let
  cfg = config.zenos.desktops.gnome.tweaks.blackbox-settings;
  name = "blackbox-settings";
in
{
  options.zenos.desktops.gnome.tweaks.blackbox-settings = lib.mkOption { type = (lib.types.submodule ({ ... }: { options = { enable = lib.mkOption { type = lib.types.bool; default = false; }; }; })); default = { }; };
  config = lib.mkMerge [
    { _module.args.zenlang.descriptors.desktops.gnome.tweaks.blackbox-settings = {
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
            value = "\n    Installs BlackBox and Atkynson Mono, then configures its font, window size,\n    padding, header bar, and floating controls through dconf.\n  ";
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
            value = "Native BlackBox terminal theming for ZenOS";
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
    moduleIdentity = "zenos.desktops.gnome.tweaks.blackbox-settings";
    modulePath = [
      "desktops"
      "gnome"
      "tweaks"
      "blackbox-settings"
    ];
    nodeMetadata = [
      {
        metadata = {
          description = {
            multiline = true;
            parts = [
              {
                type = "text";
                value = "\n    Installs BlackBox and Atkynson Mono, then configures its font, window size,\n    padding, header bar, and floating controls through dconf.\n  ";
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
                value = "Native BlackBox terminal theming for ZenOS";
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
                value = "Enable BlackBox terminal theming";
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
                    value = "Native BlackBox terminal theming for ZenOS";
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
                    value = "\n    Installs BlackBox and Atkynson Mono, then configures its font, window size,\n    padding, header bar, and floating controls through dconf.\n  ";
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
                            value = "Enable BlackBox terminal theming";
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
                                value = "blackbox-terminal";
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
                                    value = "com/raggesilver/BlackBox";
                                  }
                                ];
                                type = "assignment";
                                value = {
                                  recursive = false;
                                  statements = [
                                    {
                                      operator = "=";
                                      target = [
                                        {
                                          kind = "identifier";
                                          value = "floating-controls";
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
                                          value = "font";
                                        }
                                      ];
                                      type = "assignment";
                                      value = {
                                        multiline = false;
                                        parts = [
                                          {
                                            type = "text";
                                            value = "Atkynson Mono NF 11";
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
                                          value = "show-headerbar";
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
                                          value = "terminal-padding";
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
                                                      kind = "integer";
                                                      type = "literal";
                                                      value = 5;
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
                                                type = "group";
                                                value = {
                                                  arguments = [
                                                    {
                                                      kind = "integer";
                                                      type = "literal";
                                                      value = 5;
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
                                                type = "group";
                                                value = {
                                                  arguments = [
                                                    {
                                                      kind = "integer";
                                                      type = "literal";
                                                      value = 5;
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
                                                type = "group";
                                                value = {
                                                  arguments = [
                                                    {
                                                      kind = "integer";
                                                      type = "literal";
                                                      value = 5;
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
                                            ];
                                            type = "list";
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
                                    {
                                      operator = "=";
                                      target = [
                                        {
                                          kind = "identifier";
                                          value = "window-height";
                                        }
                                      ];
                                      type = "assignment";
                                      value = {
                                        arguments = [
                                          {
                                            kind = "integer";
                                            type = "literal";
                                            value = 550;
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
                                          value = "window-width";
                                        }
                                      ];
                                      type = "assignment";
                                      value = {
                                        arguments = [
                                          {
                                            kind = "integer";
                                            type = "literal";
                                            value = 900;
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
      environment.systemPackages = [
        pkgs.zenos.legacy.blackbox-terminal
        pkgs.zenos.legacy.nerd-fonts.atkynson-mono
      ];
      programs.dconf.profiles.user.databases = [
        {
          settings."com/raggesilver/BlackBox" = {
            floating-controls = true;
            font = "Atkynson Mono NF 11";
            show-headerbar = false;
            terminal-padding = (lib.gvariant.mkTuple [
              ((lib.gvariant.mkUint32 5))
              ((lib.gvariant.mkUint32 5))
              ((lib.gvariant.mkUint32 5))
              ((lib.gvariant.mkUint32 5))
            ]);
            window-height = (lib.gvariant.mkUint32 550);
            window-width = (lib.gvariant.mkUint32 900);
          };
        }
      ];
    })
  ];
}
