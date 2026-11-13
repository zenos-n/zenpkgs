{ config, lib, pkgs, maintainers ? lib.maintainers, licenses ? lib.licenses, ... }:
let
  cfg = config.zenos.programs.web-apps;
  name = "web-apps";
in
{
  options.zenos.programs.web-apps = lib.mkOption { type = (lib.types.submodule ({ ... }: { options = { apps = lib.mkOption { type = lib.types.attrs; default = { }; description = "\n      App records retain the source fields id, name, url, icon, extensions,\n      search, enablePasswordManager, layoutStart, layoutEnd, userChrome,\n      userContent, extraPrefs, categories, keywords, and openUrls.\n    "; }; backend = lib.mkOption { type = (lib.types.submodule ({ ... }: { options = { getRunCommand = lib.mkOption { type = (lib.types.functionTo lib.types.str); default = (id: "echo 'No backend configured'"); }; getWmClass = lib.mkOption { type = (lib.types.functionTo lib.types.str); default = (id: "PWA-${((value: let kind = builtins.typeOf value; in if kind == "string" then value else if kind == "bool" || kind == "int" || kind == "float" then builtins.toJSON value else if kind == "path" then "${value}" else if kind == "set" && (value.type or null) == "derivation" && builtins.isString (value.outPath or null) then value.outPath else throw "/nix/store/3ni594f60hm22hcrazxd35dmk7pwi61m-zenpkgs-dsl-source/modules/programs/web-apps.zmdl:118: string interpolation requires a scalar, path, or package") (id))}"); }; }; })); default = { }; }; base = lib.mkOption { type = (lib.types.enum [
  "firefox"
  "brave"
  "chrome"
  "helium"
]); default = "firefox"; }; dispatcher = lib.mkOption { type = (lib.types.submodule ({ ... }: { options = { enable = lib.mkOption { type = lib.types.bool; default = false; }; fallbackBrowser = lib.mkOption { type = lib.types.str; default = "firefox"; }; }; })); default = { }; }; enable = lib.mkOption { type = lib.types.bool; default = false; }; profileDir = lib.mkOption { type = lib.types.str; description = "\n      Explicitly configure the profile storage directory for each scope using this\n      library. There is no default until the library supplies valid contextual\n      directory logic; reading this option without a value is an error.\n    "; }; }; })); default = { }; };
  config = lib.mkMerge [
    { _module.args.zenlang.descriptors.programs.web-apps = {
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
            value = "\n    Creates isolated browser-backed web applications, desktop entries, optional\n    URL dispatch, and MIME defaults for a user's desktop session.\n\n    The freeform app records retain user-provided values, but the original nested\n    submodule validation and defaults require future ZMDL schema support.\n  ";
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
            value = "Declarative isolated web application manager";
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
    moduleIdentity = "zenos.programs.web-apps";
    modulePath = [
      "programs"
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
                value = "\n    Creates isolated browser-backed web applications, desktop entries, optional\n    URL dispatch, and MIME defaults for a user's desktop session.\n\n    The freeform app records retain user-provided values, but the original nested\n    submodule validation and defaults require future ZMDL schema support.\n  ";
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
                value = "Declarative isolated web application manager";
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
                value = "Enable declarative ZenOS web applications";
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
                value = "firefox";
              }
            ];
            type = "string";
          };
          summary = {
            multiline = false;
            parts = [
              {
                type = "text";
                value = "Browser backend for web applications";
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
                        value = "firefox";
                      }
                    ];
                    type = "string";
                  }
                  {
                    multiline = false;
                    parts = [
                      {
                        type = "text";
                        value = "brave";
                      }
                    ];
                    type = "string";
                  }
                  {
                    multiline = false;
                    parts = [
                      {
                        type = "text";
                        value = "chrome";
                      }
                    ];
                    type = "string";
                  }
                  {
                    multiline = false;
                    parts = [
                      {
                        type = "text";
                        value = "helium";
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
          "base"
        ];
      }
      {
        metadata = {
          description = {
            multiline = true;
            parts = [
              {
                type = "text";
                value = "\n      Explicitly configure the profile storage directory for each scope using this\n      library. There is no default until the library supplies valid contextual\n      directory logic; reading this option without a value is an error.\n    ";
              }
            ];
            type = "string";
          };
          summary = {
            multiline = false;
            parts = [
              {
                type = "text";
                value = "Web application profile storage directory";
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
          "profileDir"
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
          "backend"
        ];
      }
      {
        metadata = {
          default = {
            body = {
              multiline = false;
              parts = [
                {
                  type = "text";
                  value = "echo 'No backend configured'";
                }
              ];
              type = "string";
            };
            form = "identifier";
            parameters = [
              {
                default = null;
                name = "id";
                variadic = false;
              }
            ];
            type = "lambda";
          };
          summary = {
            multiline = false;
            parts = [
              {
                type = "text";
                value = "Internal launch-command generator";
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
                  value = "functionTo";
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
          "backend"
          "getRunCommand"
        ];
      }
      {
        metadata = {
          default = {
            body = {
              multiline = false;
              parts = [
                {
                  type = "text";
                  value = "PWA-";
                }
                {
                  expression = {
                    path = [
                      {
                        kind = "identifier";
                        value = "id";
                      }
                    ];
                    type = "reference";
                  };
                  type = "interpolation";
                }
              ];
              type = "string";
            };
            form = "identifier";
            parameters = [
              {
                default = null;
                name = "id";
                variadic = false;
              }
            ];
            type = "lambda";
          };
          summary = {
            multiline = false;
            parts = [
              {
                type = "text";
                value = "Internal window-class generator";
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
                  value = "functionTo";
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
          "backend"
          "getWmClass"
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
          "dispatcher"
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
                value = "Enable the internal URL dispatcher";
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
          "dispatcher"
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
                value = "firefox";
              }
            ];
            type = "string";
          };
          summary = {
            multiline = false;
            parts = [
              {
                type = "text";
                value = "Fallback browser command";
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
          "dispatcher"
          "fallbackBrowser"
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
                value = "\n      App records retain the source fields id, name, url, icon, extensions,\n      search, enablePasswordManager, layoutStart, layoutEnd, userChrome,\n      userContent, extraPrefs, categories, keywords, and openUrls.\n    ";
              }
            ];
            type = "string";
          };
          summary = {
            multiline = false;
            parts = [
              {
                type = "text";
                value = "Freeform web application definitions";
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
          "apps"
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
                    value = "Declarative isolated web application manager";
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
                    value = "\n    Creates isolated browser-backed web applications, desktop entries, optional\n    URL dispatch, and MIME defaults for a user's desktop session.\n\n    The freeform app records retain user-provided values, but the original nested\n    submodule validation and defaults require future ZMDL schema support.\n  ";
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
                            value = "Enable declarative ZenOS web applications";
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
                          value = "home";
                        }
                        {
                          kind = "identifier";
                          value = "packages";
                        }
                      ];
                      type = "assignment";
                      value = {
                        condition = {
                          name = "path";
                          path = [
                            {
                              kind = "identifier";
                              value = "dispatcher";
                            }
                            {
                              kind = "identifier";
                              value = "enable";
                            }
                          ];
                          type = "variable";
                        };
                        "else" = {
                          items = [ ];
                          type = "list";
                        };
                        "then" = {
                          items = [
                            {
                              type = "group";
                              value = {
                                arguments = [
                                  {
                                    multiline = true;
                                    parts = [
                                      {
                                        type = "text";
                                        value = "\n        #!";
                                      }
                                      {
                                        expression = {
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
                                              value = "bash";
                                            }
                                          ];
                                          type = "variable";
                                        };
                                        type = "interpolation";
                                      }
                                      {
                                        type = "text";
                                        value = "/bin/bash\n        URL=\"$1\"\n\n        if [ -z \"$URL\" ]; then\n          exec ";
                                      }
                                      {
                                        expression = {
                                          name = "path";
                                          path = [
                                            {
                                              kind = "identifier";
                                              value = "dispatcher";
                                            }
                                            {
                                              kind = "identifier";
                                              value = "fallbackBrowser";
                                            }
                                          ];
                                          type = "variable";
                                        };
                                        type = "interpolation";
                                      }
                                      {
                                        type = "text";
                                        value = "\n        fi\n\n        ";
                                      }
                                      {
                                        expression = {
                                          arguments = [
                                            {
                                              type = "group";
                                              value = {
                                                arguments = [
                                                  {
                                                    name = "path";
                                                    path = [
                                                      {
                                                        kind = "identifier";
                                                        value = "apps";
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
                                                                type = "group";
                                                                value = {
                                                                  arguments = [
                                                                    {
                                                                      path = [
                                                                        {
                                                                          kind = "identifier";
                                                                          value = "app";
                                                                        }
                                                                        {
                                                                          kind = "identifier";
                                                                          value = "openUrls";
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
                                                                            multiline = true;
                                                                            parts = [
                                                                              {
                                                                                type = "text";
                                                                                value = "\n              if [[ \"$URL\" == *\"";
                                                                              }
                                                                              {
                                                                                expression = {
                                                                                  path = [
                                                                                    {
                                                                                      kind = "identifier";
                                                                                      value = "pattern";
                                                                                    }
                                                                                  ];
                                                                                  type = "reference";
                                                                                };
                                                                                type = "interpolation";
                                                                              }
                                                                              {
                                                                                type = "text";
                                                                                value = "\"* ]]; then\n                exec ";
                                                                              }
                                                                              {
                                                                                expression = {
                                                                                  arguments = [
                                                                                    {
                                                                                      path = [
                                                                                        {
                                                                                          kind = "identifier";
                                                                                          value = "app";
                                                                                        }
                                                                                        {
                                                                                          kind = "identifier";
                                                                                          value = "id";
                                                                                        }
                                                                                      ];
                                                                                      type = "reference";
                                                                                    }
                                                                                  ];
                                                                                  callee = {
                                                                                    name = "path";
                                                                                    path = [
                                                                                      {
                                                                                        kind = "identifier";
                                                                                        value = "backend";
                                                                                      }
                                                                                      {
                                                                                        kind = "identifier";
                                                                                        value = "getRunCommand";
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
                                                                                value = " \"$URL\"\n              fi\n            ";
                                                                              }
                                                                            ];
                                                                            type = "string";
                                                                          };
                                                                          form = "identifier";
                                                                          parameters = [
                                                                            {
                                                                              default = null;
                                                                              name = "pattern";
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
                                                                          value = "concatMapStrings";
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
                                                                    left = {
                                                                      path = [
                                                                        {
                                                                          kind = "identifier";
                                                                          value = "app";
                                                                        }
                                                                        {
                                                                          kind = "identifier";
                                                                          value = "openUrls";
                                                                        }
                                                                      ];
                                                                      type = "reference";
                                                                    };
                                                                    operator = "!=";
                                                                    right = {
                                                                      items = [ ];
                                                                      type = "list";
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
                                                          form = "identifier";
                                                          parameters = [
                                                            {
                                                              default = null;
                                                              name = "app";
                                                              variadic = false;
                                                            }
                                                          ];
                                                          type = "lambda";
                                                        };
                                                        form = "identifier";
                                                        parameters = [
                                                          {
                                                            default = null;
                                                            name = "appName";
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
                                                value = "concatStrings";
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
                                        value = "\n\n        exec ";
                                      }
                                      {
                                        expression = {
                                          name = "path";
                                          path = [
                                            {
                                              kind = "identifier";
                                              value = "dispatcher";
                                            }
                                            {
                                              kind = "identifier";
                                              value = "fallbackBrowser";
                                            }
                                          ];
                                          type = "variable";
                                        };
                                        type = "interpolation";
                                      }
                                      {
                                        type = "text";
                                        value = " \"$URL\"\n      ";
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
                                          value = "pwa-dispatcher";
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
                                        value = "writeScriptBin";
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
                          type = "list";
                        };
                        type = "if";
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
                          value = "desktopEntries";
                        }
                      ];
                      type = "assignment";
                      value = {
                        left = {
                          type = "group";
                          value = {
                            condition = {
                              name = "path";
                              path = [
                                {
                                  kind = "identifier";
                                  value = "dispatcher";
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
                                      value = "pwa-dispatcher";
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
                                              value = "PWA Dispatcher";
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
                                            value = "genericName";
                                          }
                                        ];
                                        type = "assignment";
                                        value = {
                                          multiline = false;
                                          parts = [
                                            {
                                              type = "text";
                                              value = "Web Browser Dispatcher";
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
                                            value = "exec";
                                          }
                                        ];
                                        type = "assignment";
                                        value = {
                                          multiline = false;
                                          parts = [
                                            {
                                              type = "text";
                                              value = "pwa-dispatcher %U";
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
                                            value = "icon";
                                          }
                                        ];
                                        type = "assignment";
                                        value = {
                                          multiline = false;
                                          parts = [
                                            {
                                              type = "text";
                                              value = "web-browser";
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
                                            value = "categories";
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
                                                  value = "Network";
                                                }
                                              ];
                                              type = "string";
                                            }
                                            {
                                              multiline = false;
                                              parts = [
                                                {
                                                  type = "text";
                                                  value = "WebBrowser";
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
                                            value = "mimeType";
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
                                                  value = "text/html";
                                                }
                                              ];
                                              type = "string";
                                            }
                                            {
                                              multiline = false;
                                              parts = [
                                                {
                                                  type = "text";
                                                  value = "text/xml";
                                                }
                                              ];
                                              type = "string";
                                            }
                                            {
                                              multiline = false;
                                              parts = [
                                                {
                                                  type = "text";
                                                  value = "application/xhtml+xml";
                                                }
                                              ];
                                              type = "string";
                                            }
                                            {
                                              multiline = false;
                                              parts = [
                                                {
                                                  type = "text";
                                                  value = "x-scheme-handler/http";
                                                }
                                              ];
                                              type = "string";
                                            }
                                            {
                                              multiline = false;
                                              parts = [
                                                {
                                                  type = "text";
                                                  value = "x-scheme-handler/https";
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
                            type = "if";
                          };
                        };
                        operator = "//";
                        right = {
                          type = "group";
                          value = {
                            arguments = [
                              {
                                name = "path";
                                path = [
                                  {
                                    kind = "identifier";
                                    value = "apps";
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
                                                value = "name";
                                              }
                                            ];
                                            type = "assignment";
                                            value = {
                                              path = [
                                                {
                                                  kind = "identifier";
                                                  value = "app";
                                                }
                                                {
                                                  kind = "identifier";
                                                  value = "name";
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
                                                value = "genericName";
                                              }
                                            ];
                                            type = "assignment";
                                            value = {
                                              multiline = false;
                                              parts = [
                                                {
                                                  type = "text";
                                                  value = "Web Application";
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
                                                value = "exec";
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
                                                        path = [
                                                          {
                                                            kind = "identifier";
                                                            value = "app";
                                                          }
                                                          {
                                                            kind = "identifier";
                                                            value = "id";
                                                          }
                                                        ];
                                                        type = "reference";
                                                      }
                                                    ];
                                                    callee = {
                                                      name = "path";
                                                      path = [
                                                        {
                                                          kind = "identifier";
                                                          value = "backend";
                                                        }
                                                        {
                                                          kind = "identifier";
                                                          value = "getRunCommand";
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
                                                  value = " %U";
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
                                                value = "icon";
                                              }
                                            ];
                                            type = "assignment";
                                            value = {
                                              path = [
                                                {
                                                  kind = "identifier";
                                                  value = "app";
                                                }
                                                {
                                                  kind = "identifier";
                                                  value = "icon";
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
                                                value = "categories";
                                              }
                                            ];
                                            type = "assignment";
                                            value = {
                                              path = [
                                                {
                                                  kind = "identifier";
                                                  value = "app";
                                                }
                                                {
                                                  kind = "identifier";
                                                  value = "categories";
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
                                                      value = "Keywords";
                                                    }
                                                  ];
                                                  type = "assignment";
                                                  value = {
                                                    arguments = [
                                                      {
                                                        path = [
                                                          {
                                                            kind = "identifier";
                                                            value = "app";
                                                          }
                                                          {
                                                            kind = "identifier";
                                                            value = "keywords";
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
                                                              value = ";";
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
                                                            value = "concatStringsSep";
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
                                                      value = "StartupWMClass";
                                                    }
                                                  ];
                                                  type = "assignment";
                                                  value = {
                                                    arguments = [
                                                      {
                                                        path = [
                                                          {
                                                            kind = "identifier";
                                                            value = "app";
                                                          }
                                                          {
                                                            kind = "identifier";
                                                            value = "id";
                                                          }
                                                        ];
                                                        type = "reference";
                                                      }
                                                    ];
                                                    callee = {
                                                      name = "path";
                                                      path = [
                                                        {
                                                          kind = "identifier";
                                                          value = "backend";
                                                        }
                                                        {
                                                          kind = "identifier";
                                                          value = "getWmClass";
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
                                      };
                                      form = "identifier";
                                      parameters = [
                                        {
                                          default = null;
                                          name = "app";
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
                                    value = "mapAttrs";
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
                    {
                      operator = "=";
                      target = [
                        {
                          kind = "identifier";
                          value = "xdg";
                        }
                        {
                          kind = "identifier";
                          value = "mimeApps";
                        }
                      ];
                      type = "assignment";
                      value = {
                        condition = {
                          name = "path";
                          path = [
                            {
                              kind = "identifier";
                              value = "dispatcher";
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
                                  value = "defaultApplications";
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
                                        value = "x-scheme-handler/http";
                                      }
                                    ];
                                    type = "assignment";
                                    value = {
                                      multiline = false;
                                      parts = [
                                        {
                                          type = "text";
                                          value = "pwa-dispatcher.desktop";
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
                                        value = "x-scheme-handler/https";
                                      }
                                    ];
                                    type = "assignment";
                                    value = {
                                      multiline = false;
                                      parts = [
                                        {
                                          type = "text";
                                          value = "pwa-dispatcher.desktop";
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
                                        value = "text/html";
                                      }
                                    ];
                                    type = "assignment";
                                    value = {
                                      multiline = false;
                                      parts = [
                                        {
                                          type = "text";
                                          value = "pwa-dispatcher.desktop";
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
                                        value = "application/xhtml+xml";
                                      }
                                    ];
                                    type = "assignment";
                                    value = {
                                      multiline = false;
                                      parts = [
                                        {
                                          type = "text";
                                          value = "pwa-dispatcher.desktop";
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
                        type = "if";
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
            value = "base";
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
                                  value = "firefox";
                                }
                              ];
                              type = "string";
                            }
                            {
                              multiline = false;
                              parts = [
                                {
                                  type = "text";
                                  value = "brave";
                                }
                              ];
                              type = "string";
                            }
                            {
                              multiline = false;
                              parts = [
                                {
                                  type = "text";
                                  value = "chrome";
                                }
                              ];
                              type = "string";
                            }
                            {
                              multiline = false;
                              parts = [
                                {
                                  type = "text";
                                  value = "helium";
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
                          value = "firefox";
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
                          value = "Browser backend for web applications";
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
            value = "profileDir";
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
                        value = "summary";
                      }
                    ];
                    type = "assignment";
                    value = {
                      multiline = false;
                      parts = [
                        {
                          type = "text";
                          value = "Web application profile storage directory";
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
                          value = "\n      Explicitly configure the profile storage directory for each scope using this\n      library. There is no default until the library supplies valid contextual\n      directory logic; reading this option without a value is an error.\n    ";
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
            value = "backend";
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
                  value = "getRunCommand";
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
                                  value = "functionTo";
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
                            body = {
                              multiline = false;
                              parts = [
                                {
                                  type = "text";
                                  value = "echo 'No backend configured'";
                                }
                              ];
                              type = "string";
                            };
                            form = "identifier";
                            parameters = [
                              {
                                default = null;
                                name = "id";
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
                              value = "summary";
                            }
                          ];
                          type = "assignment";
                          value = {
                            multiline = false;
                            parts = [
                              {
                                type = "text";
                                value = "Internal launch-command generator";
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
                  value = "getWmClass";
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
                                  value = "functionTo";
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
                            body = {
                              multiline = false;
                              parts = [
                                {
                                  type = "text";
                                  value = "PWA-";
                                }
                                {
                                  expression = {
                                    path = [
                                      {
                                        kind = "identifier";
                                        value = "id";
                                      }
                                    ];
                                    type = "reference";
                                  };
                                  type = "interpolation";
                                }
                              ];
                              type = "string";
                            };
                            form = "identifier";
                            parameters = [
                              {
                                default = null;
                                name = "id";
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
                              value = "summary";
                            }
                          ];
                          type = "assignment";
                          value = {
                            multiline = false;
                            parts = [
                              {
                                type = "text";
                                value = "Internal window-class generator";
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
            value = "dispatcher";
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
                                value = "Enable the internal URL dispatcher";
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
                  value = "fallbackBrowser";
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
                                value = "firefox";
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
                                value = "Fallback browser command";
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
            value = "apps";
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
                          value = "Freeform web application definitions";
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
                          value = "\n      App records retain the source fields id, name, url, icon, extensions,\n      search, enablePasswordManager, layoutStart, layoutEnd, userChrome,\n      userContent, extraPrefs, categories, keywords, and openUrls.\n    ";
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
      home.packages = (if cfg.dispatcher.enable then [
        (((pkgs.zenos.legacy.writeScriptBin "pwa-dispatcher") "\n        #!${((value: let kind = builtins.typeOf value; in if kind == "string" then value else if kind == "bool" || kind == "int" || kind == "float" then builtins.toJSON value else if kind == "path" then "${value}" else if kind == "set" && (value.type or null) == "derivation" && builtins.isString (value.outPath or null) then value.outPath else throw "/nix/store/3ni594f60hm22hcrazxd35dmk7pwi61m-zenpkgs-dsl-source/modules/programs/web-apps.zmdl:26: string interpolation requires a scalar, path, or package") (pkgs.zenos.legacy.bash))}/bin/bash\n        URL=\"$1\"\n\n        if [ -z \"$URL\" ]; then\n          exec ${((value: let kind = builtins.typeOf value; in if kind == "string" then value else if kind == "bool" || kind == "int" || kind == "float" then builtins.toJSON value else if kind == "path" then "${value}" else if kind == "set" && (value.type or null) == "derivation" && builtins.isString (value.outPath or null) then value.outPath else throw "/nix/store/3ni594f60hm22hcrazxd35dmk7pwi61m-zenpkgs-dsl-source/modules/programs/web-apps.zmdl:30: string interpolation requires a scalar, path, or package") (cfg.dispatcher.fallbackBrowser))}\n        fi\n\n        ${((value: let kind = builtins.typeOf value; in if kind == "string" then value else if kind == "bool" || kind == "int" || kind == "float" then builtins.toJSON value else if kind == "path" then "${value}" else if kind == "set" && (value.type or null) == "derivation" && builtins.isString (value.outPath or null) then value.outPath else throw "/nix/store/3ni594f60hm22hcrazxd35dmk7pwi61m-zenpkgs-dsl-source/modules/programs/web-apps.zmdl:33: string interpolation requires a scalar, path, or package") ((lib.concatStrings (((lib.mapAttrsToList ((appName: (app: ((lib.optionalString ((app.openUrls != [ ]))) (((lib.concatMapStrings ((pattern: "\n              if [[ \"$URL\" == *\"${((value: let kind = builtins.typeOf value; in if kind == "string" then value else if kind == "bool" || kind == "int" || kind == "float" then builtins.toJSON value else if kind == "path" then "${value}" else if kind == "set" && (value.type or null) == "derivation" && builtins.isString (value.outPath or null) then value.outPath else throw "/nix/store/3ni594f60hm22hcrazxd35dmk7pwi61m-zenpkgs-dsl-source/modules/programs/web-apps.zmdl:36: string interpolation requires a scalar, path, or package") (pattern))}\"* ]]; then\n                exec ${((value: let kind = builtins.typeOf value; in if kind == "string" then value else if kind == "bool" || kind == "int" || kind == "float" then builtins.toJSON value else if kind == "path" then "${value}" else if kind == "set" && (value.type or null) == "derivation" && builtins.isString (value.outPath or null) then value.outPath else throw "/nix/store/3ni594f60hm22hcrazxd35dmk7pwi61m-zenpkgs-dsl-source/modules/programs/web-apps.zmdl:37: string interpolation requires a scalar, path, or package") ((cfg.backend.getRunCommand app.id)))} \"$URL\"\n              fi\n            "))) app.openUrls))))))) cfg.apps)))))}\n\n        exec ${((value: let kind = builtins.typeOf value; in if kind == "string" then value else if kind == "bool" || kind == "int" || kind == "float" then builtins.toJSON value else if kind == "path" then "${value}" else if kind == "set" && (value.type or null) == "derivation" && builtins.isString (value.outPath or null) then value.outPath else throw "/nix/store/3ni594f60hm22hcrazxd35dmk7pwi61m-zenpkgs-dsl-source/modules/programs/web-apps.zmdl:42: string interpolation requires a scalar, path, or package") (cfg.dispatcher.fallbackBrowser))} \"$URL\"\n      "))
      ] else [ ]);
      xdg.desktopEntries = (((if cfg.dispatcher.enable then {
        pwa-dispatcher = {
          name = "PWA Dispatcher";
          genericName = "Web Browser Dispatcher";
          exec = "pwa-dispatcher %U";
          icon = "web-browser";
          categories = [
            "Network"
            "WebBrowser"
          ];
          mimeType = [
            "text/html"
            "text/xml"
            "application/xhtml+xml"
            "x-scheme-handler/http"
            "x-scheme-handler/https"
          ];
        };
      } else { })) // (((lib.mapAttrs ((key: (app: {
        name = app.name;
        genericName = "Web Application";
        exec = "${((value: let kind = builtins.typeOf value; in if kind == "string" then value else if kind == "bool" || kind == "int" || kind == "float" then builtins.toJSON value else if kind == "path" then "${value}" else if kind == "set" && (value.type or null) == "derivation" && builtins.isString (value.outPath or null) then value.outPath else throw "/nix/store/3ni594f60hm22hcrazxd35dmk7pwi61m-zenpkgs-dsl-source/modules/programs/web-apps.zmdl:66: string interpolation requires a scalar, path, or package") ((cfg.backend.getRunCommand app.id)))} %U";
        icon = app.icon;
        categories = app.categories;
        settings = {
          Keywords = ((lib.concatStringsSep ";") app.keywords);
          StartupWMClass = (cfg.backend.getWmClass app.id);
        };
      })))) cfg.apps)));
      xdg.mimeApps = (if cfg.dispatcher.enable then {
        enable = true;
        defaultApplications = {
          "x-scheme-handler/http" = "pwa-dispatcher.desktop";
          "x-scheme-handler/https" = "pwa-dispatcher.desktop";
          "text/html" = "pwa-dispatcher.desktop";
          "application/xhtml+xml" = "pwa-dispatcher.desktop";
        };
      } else { });
    } ]; })
  ];
}
