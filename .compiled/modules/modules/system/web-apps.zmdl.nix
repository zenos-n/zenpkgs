{ config, lib, pkgs, maintainers ? lib.maintainers, licenses ? lib.licenses, ... }:
let
  cfg = config.zenos.system.web-apps;
  name = "web-apps";
in
{
  options.zenos.system.web-apps = lib.mkOption { type = (lib.types.submodule ({ ... }: { options = { enable = lib.mkOption { type = lib.types.bool; default = false; }; users = lib.mkOption { type = lib.types.attrs; default = { }; description = "Freeform values forwarded to the typed user web-apps module."; }; }; })); default = { }; };
  config = lib.mkMerge [
    { _module.args.zenlang.descriptors.system.web-apps = {
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
            value = "\n    Configures Home Manager defaults for normal users and forwards enabled per-user\n    web application settings into the user-side web-apps module.\n  ";
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
            value = "Per-user ZenOS progressive web applications";
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
    moduleIdentity = "zenos.system.web-apps";
    modulePath = [
      "system"
      "web-apps"
    ];
    nodeMetadata = [
      {
        metadata = {
          description = {
            multiline = true;
            parts = [
              {
                type = "text";
                value = "\n    Configures Home Manager defaults for normal users and forwards enabled per-user\n    web application settings into the user-side web-apps module.\n  ";
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
                value = "Per-user ZenOS progressive web applications";
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
                value = "Enable per-user ZenOS web applications";
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
            recursive = false;
            statements = [ ];
            type = "attr-set";
          };
          description = {
            multiline = true;
            parts = [
              {
                type = "text";
                value = "Freeform values forwarded to the typed user web-apps module.";
              }
            ];
            type = "string";
          };
          summary = {
            multiline = false;
            parts = [
              {
                type = "text";
                value = "Per-user web application values";
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
          "users"
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
                    value = "Per-user ZenOS progressive web applications";
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
                    value = "\n    Configures Home Manager defaults for normal users and forwards enabled per-user\n    web application settings into the user-side web-apps module.\n  ";
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
                            value = "Enable per-user ZenOS web applications";
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
                          value = "home-manager";
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
                                value = "backupFileExtension";
                              }
                            ];
                            type = "assignment";
                            value = {
                              multiline = false;
                              parts = [
                                {
                                  type = "text";
                                  value = "zenos-backup";
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
                                value = "useGlobalPkgs";
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
                                value = "useUserPackages";
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
                            ];
                            type = "assignment";
                            value = {
                              arguments = [
                                {
                                  type = "group";
                                  value = {
                                    arguments = [
                                      {
                                        type = "group";
                                        value = {
                                          default = {
                                            recursive = false;
                                            statements = [ ];
                                            type = "attr-set";
                                          };
                                          type = "default";
                                          value = {
                                            name = "cfg";
                                            path = [
                                              {
                                                kind = "identifier";
                                                value = "legacy";
                                              }
                                              {
                                                kind = "identifier";
                                                value = "users";
                                              }
                                              {
                                                kind = "identifier";
                                                value = "users";
                                              }
                                            ];
                                            type = "variable";
                                          };
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
                                                path = [
                                                  {
                                                    kind = "identifier";
                                                    value = "user";
                                                  }
                                                  {
                                                    kind = "identifier";
                                                    value = "isNormalUser";
                                                  }
                                                ];
                                                type = "reference";
                                              };
                                              form = "identifier";
                                              parameters = [
                                                {
                                                  default = null;
                                                  name = "user";
                                                  variadic = false;
                                                }
                                              ];
                                              type = "lambda";
                                            };
                                            form = "identifier";
                                            parameters = [
                                              {
                                                default = null;
                                                name = "userName";
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
                                            value = "filterAttrs";
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
                                    type = "group";
                                    value = {
                                      body = {
                                        body = {
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
                                                        value = "username";
                                                      }
                                                    ];
                                                    type = "assignment";
                                                    value = {
                                                      path = [
                                                        {
                                                          kind = "identifier";
                                                          value = "userName";
                                                        }
                                                      ];
                                                      type = "reference";
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
                                                      path = [
                                                        {
                                                          kind = "identifier";
                                                          value = "user";
                                                        }
                                                        {
                                                          kind = "identifier";
                                                          value = "home";
                                                        }
                                                      ];
                                                      type = "reference";
                                                    };
                                                  }
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
                                                      name = "cfg";
                                                      path = [
                                                        {
                                                          kind = "identifier";
                                                          value = "legacy";
                                                        }
                                                        {
                                                          kind = "identifier";
                                                          value = "system";
                                                        }
                                                        {
                                                          kind = "identifier";
                                                          value = "stateVersion";
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
                                        form = "identifier";
                                        parameters = [
                                          {
                                            default = null;
                                            name = "user";
                                            variadic = false;
                                          }
                                        ];
                                        type = "lambda";
                                      };
                                      form = "identifier";
                                      parameters = [
                                        {
                                          default = null;
                                          name = "userName";
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
                unconditional = true;
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
                          value = "assertions";
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
                                value = "users";
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
                                    recursive = false;
                                    statements = [
                                      {
                                        operator = "=";
                                        target = [
                                          {
                                            kind = "identifier";
                                            value = "assertion";
                                          }
                                        ];
                                        type = "assignment";
                                        value = {
                                          arguments = [
                                            {
                                              type = "group";
                                              value = {
                                                default = {
                                                  recursive = false;
                                                  statements = [ ];
                                                  type = "attr-set";
                                                };
                                                type = "default";
                                                value = {
                                                  name = "cfg";
                                                  path = [
                                                    {
                                                      kind = "identifier";
                                                      value = "legacy";
                                                    }
                                                    {
                                                      kind = "identifier";
                                                      value = "users";
                                                    }
                                                    {
                                                      kind = "identifier";
                                                      value = "users";
                                                    }
                                                  ];
                                                  type = "variable";
                                                };
                                              };
                                            }
                                          ];
                                          callee = {
                                            arguments = [
                                              {
                                                path = [
                                                  {
                                                    kind = "identifier";
                                                    value = "userName";
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
                                                  value = "hasAttr";
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
                                            value = "message";
                                          }
                                        ];
                                        type = "assignment";
                                        value = {
                                          multiline = false;
                                          parts = [
                                            {
                                              type = "text";
                                              value = "system.webApps.users.";
                                            }
                                            {
                                              expression = {
                                                path = [
                                                  {
                                                    kind = "identifier";
                                                    value = "userName";
                                                  }
                                                ];
                                                type = "reference";
                                              };
                                              type = "interpolation";
                                            }
                                            {
                                              type = "text";
                                              value = " must name a declared system user";
                                            }
                                          ];
                                          type = "string";
                                        };
                                      }
                                    ];
                                    type = "attr-set";
                                  };
                                  form = "identifier";
                                  parameters = [
                                    {
                                      default = null;
                                      name = "userConfig";
                                      variadic = false;
                                    }
                                  ];
                                  type = "lambda";
                                };
                                form = "identifier";
                                parameters = [
                                  {
                                    default = null;
                                    name = "userName";
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
                      ];
                      type = "assignment";
                      value = {
                        arguments = [
                          {
                            name = "path";
                            path = [
                              {
                                kind = "identifier";
                                value = "users";
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
                                            value = "webApps";
                                          }
                                        ];
                                        type = "assignment";
                                        value = {
                                          left = {
                                            path = [
                                              {
                                                kind = "identifier";
                                                value = "userConfig";
                                              }
                                            ];
                                            type = "reference";
                                          };
                                          operator = "//";
                                          right = {
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
                                            ];
                                            type = "attr-set";
                                          };
                                          type = "binary";
                                        };
                                      }
                                    ];
                                    type = "attr-set";
                                  };
                                  form = "identifier";
                                  parameters = [
                                    {
                                      default = null;
                                      name = "userConfig";
                                      variadic = false;
                                    }
                                  ];
                                  type = "lambda";
                                };
                                form = "identifier";
                                parameters = [
                                  {
                                    default = null;
                                    name = "userName";
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
            value = "users";
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
                        value = "summary";
                      }
                    ];
                    type = "assignment";
                    value = {
                      multiline = false;
                      parts = [
                        {
                          type = "text";
                          value = "Per-user web application values";
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
                          value = "Freeform values forwarded to the typed user web-apps module.";
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
    {
      home-manager = {
        backupFileExtension = "zenos-backup";
        useGlobalPkgs = true;
        useUserPackages = false;
        users = ((lib.mapAttrs ((userName: (user: {
          home = {
            username = userName;
            homeDirectory = user.home;
            stateVersion = config.zenos.legacy.system.stateVersion;
          };
        })))) (((lib.filterAttrs ((userName: (user: user.isNormalUser)))) ((config.zenos.legacy.users.users or { })))));
      };
    }
    (lib.mkIf ((cfg.enable)) {
      assertions = ((lib.mapAttrsToList ((userName: (userConfig: {
        assertion = ((lib.hasAttr userName) ((config.zenos.legacy.users.users or { })));
        message = "system.webApps.users.${((value: let kind = builtins.typeOf value; in if kind == "string" then value else if kind == "bool" || kind == "int" || kind == "float" then builtins.toJSON value else if kind == "path" then "${value}" else if kind == "set" && (value.type or null) == "derivation" && builtins.isString (value.outPath or null) then value.outPath else throw "/nix/store/3ni594f60hm22hcrazxd35dmk7pwi61m-zenpkgs-dsl-source/modules/system/web-apps.zmdl:39: string interpolation requires a scalar, path, or package") (userName))} must name a declared system user";
      })))) cfg.users);
      home-manager.users = ((lib.mapAttrs ((userName: (userConfig: {
        zenos.webApps = (userConfig // {
          enable = true;
        });
      })))) cfg.users);
    })
  ];
}
