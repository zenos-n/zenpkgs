{ config, lib, pkgs, maintainers ? lib.maintainers, licenses ? lib.licenses, ... }:
let
  cfg = config.zenos.desktops.gnome.extensions.weather-or-not;
  name = "weather-or-not";
in
{
  options.zenos.desktops.gnome.extensions.weather-or-not = lib.mkOption { type = (lib.types.submodule ({ ... }: { options = { enable = lib.mkOption { type = lib.types.bool; default = false; description = "Weather Or Not GNOME extension configuration"; }; position = lib.mkOption { type = (lib.types.enum [
  "left"
  "clock-left"
  "clock-left-centered"
  "clock-right-centered"
  "clock-right"
  "right"
]); default = "clock-right"; description = "\n  Panel anchor position for the weather icon\n\n  Determines where the weather information is rendered relative to the\n  system clock or panel edges.\n"; }; }; })); default = { }; };
  config = lib.mkMerge [
    { _module.args.zenlang.descriptors.desktops.gnome.extensions.weather-or-not = {
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
            value = "\n    Flexible weather indicator positioning for the panel\n\n    This module installs and configures the **Weather Or Not** extension for GNOME.\n    It allows you to decouple the weather indicator from the date menu and place\n    it in various positions across the top bar.\n\n    **Features:**\n    - Move weather to the left, center, or right of the clock.\n    - Integrated panel alignment options.\n  ";
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
            value = "Flexible weather indicator positioning for the panel";
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
    moduleIdentity = "zenos.desktops.gnome.extensions.weather-or-not";
    modulePath = [
      "desktops"
      "gnome"
      "extensions"
      "weather-or-not"
    ];
    nodeMetadata = [
      {
        metadata = {
          description = {
            multiline = true;
            parts = [
              {
                type = "text";
                value = "\n    Flexible weather indicator positioning for the panel\n\n    This module installs and configures the **Weather Or Not** extension for GNOME.\n    It allows you to decouple the weather indicator from the date menu and place\n    it in various positions across the top bar.\n\n    **Features:**\n    - Move weather to the left, center, or right of the clock.\n    - Integrated panel alignment options.\n  ";
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
                value = "Flexible weather indicator positioning for the panel";
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
                value = "Weather Or Not GNOME extension configuration";
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
            parts = [
              {
                type = "text";
                value = "clock-right";
              }
            ];
            type = "string";
          };
          description = {
            multiline = true;
            parts = [
              {
                type = "text";
                value = "\n  Panel anchor position for the weather icon\n\n  Determines where the weather information is rendered relative to the\n  system clock or panel edges.\n";
              }
            ];
            type = "string";
          };
          type = {
            arguments = [
              {
                items = [
                  {
                    multiline = false;
                    parts = [
                      {
                        type = "text";
                        value = "left";
                      }
                    ];
                    type = "string";
                  }
                  {
                    multiline = false;
                    parts = [
                      {
                        type = "text";
                        value = "clock-left";
                      }
                    ];
                    type = "string";
                  }
                  {
                    multiline = false;
                    parts = [
                      {
                        type = "text";
                        value = "clock-left-centered";
                      }
                    ];
                    type = "string";
                  }
                  {
                    multiline = false;
                    parts = [
                      {
                        type = "text";
                        value = "clock-right-centered";
                      }
                    ];
                    type = "string";
                  }
                  {
                    multiline = false;
                    parts = [
                      {
                        type = "text";
                        value = "clock-right";
                      }
                    ];
                    type = "string";
                  }
                  {
                    multiline = false;
                    parts = [
                      {
                        type = "text";
                        value = "right";
                      }
                    ];
                    type = "string";
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
                  value = "enum";
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
          "position"
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
                    value = "Flexible weather indicator positioning for the panel";
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
                    value = "\n    Flexible weather indicator positioning for the panel\n\n    This module installs and configures the **Weather Or Not** extension for GNOME.\n    It allows you to decouple the weather indicator from the date menu and place\n    it in various positions across the top bar.\n\n    **Features:**\n    - Move weather to the left, center, or right of the clock.\n    - Integrated panel alignment options.\n  ";
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
                                value = "weather-or-not";
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
                            value = "Weather Or Not GNOME extension configuration";
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
                                value = "weather-or-not";
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
                                    value = "org/gnome/shell/extensions/weatherornot";
                                  }
                                  {
                                    kind = "identifier";
                                    value = "position";
                                  }
                                ];
                                type = "assignment";
                                value = {
                                  name = "path";
                                  path = [
                                    {
                                      kind = "identifier";
                                      value = "position";
                                    }
                                  ];
                                  type = "variable";
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
      {
        operator = "=";
        target = [
          {
            kind = "identifier";
            value = "position";
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
                              multiline = false;
                              parts = [
                                {
                                  type = "text";
                                  value = "left";
                                }
                              ];
                              type = "string";
                            }
                            {
                              multiline = false;
                              parts = [
                                {
                                  type = "text";
                                  value = "clock-left";
                                }
                              ];
                              type = "string";
                            }
                            {
                              multiline = false;
                              parts = [
                                {
                                  type = "text";
                                  value = "clock-left-centered";
                                }
                              ];
                              type = "string";
                            }
                            {
                              multiline = false;
                              parts = [
                                {
                                  type = "text";
                                  value = "clock-right-centered";
                                }
                              ];
                              type = "string";
                            }
                            {
                              multiline = false;
                              parts = [
                                {
                                  type = "text";
                                  value = "clock-right";
                                }
                              ];
                              type = "string";
                            }
                            {
                              multiline = false;
                              parts = [
                                {
                                  type = "text";
                                  value = "right";
                                }
                              ];
                              type = "string";
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
                            value = "enum";
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
                      multiline = false;
                      parts = [
                        {
                          type = "text";
                          value = "clock-right";
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
                          value = "\n  Panel anchor position for the weather icon\n\n  Determines where the weather information is rendered relative to the\n  system clock or panel edges.\n";
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
    (lib.mkIf ((cfg.enable)) { home-manager.sharedModules = [ {
      dconf.settings."org/gnome/shell".enabled-extensions = [
        pkgs.zenos.legacy.gnomeExtensions.weather-or-not.extensionUuid
      ];
    } ]; })
    (lib.mkIf ((cfg.enable)) {
      environment.systemPackages = [
        pkgs.zenos.legacy.gnomeExtensions.weather-or-not
      ];
      programs.dconf.profiles.user.databases = [
        {
          settings."org/gnome/shell/extensions/weatherornot".position = cfg.position;
        }
      ];
    })
  ];
}
