{ config, lib, pkgs, maintainers ? lib.maintainers, licenses ? lib.licenses, ... }:
let
  cfg = config.zenos.programs.gnosis;
  name = "gnosis";
in
{
  options.zenos.programs.gnosis = lib.mkOption { type = (lib.types.submodule ({ ... }: { options = { apps = lib.mkOption { type = (lib.types.submodule ({ ... }: { options = { }; freeformType = lib.types.attrsOf (lib.types.submodule ({ name, ... }: let _zenFreeformKey0 = name; in { options = { icon = lib.mkOption { type = lib.types.str; default = "web-browser"; description = "Icon theme name or absolute icon path."; }; name = lib.mkOption { type = lib.types.str; description = "Display name. The named app key is its stable profile identity."; }; url = lib.mkOption { type = lib.types.str; description = "HTTP or HTTPS address opened by the launcher."; }; }; })); })); default = { }; description = "Create application launchers while Gnosis keeps each browsing profile writable. Removing an entry leaves its profile intact."; }; defaultBrowser = lib.mkOption { type = lib.types.bool; default = false; description = "Declare Gnosis as the default handler for HTTP, HTTPS, HTML, and XHTML. False leaves existing associations untouched."; }; enable = lib.mkOption { type = lib.types.bool; default = false; description = "Install the selected Gnosis package without replacing its writable profile or preferences."; }; package = lib.mkOption { type = lib.types.package; default = pkgs.zenos.byCategories.apps.browsers.gnosis; description = "\n      Gnosis derivation providing bin/gnosis and the\n      com.neg-zero.Gnosis.desktop desktop entry. The default is the\n      published development snapshot in the Zenpkgs browser catalog; override\n      this option to select a newer development package.\n    "; }; }; })); default = { }; };
  config = lib.mkMerge [
    { _module.args.zenlang.descriptors.programs.gnosis = {
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
            value = "\n    Installs Gnosis, the Epiphany-based browser with a Chromium engine, for the\n    selected user scope. Browser profiles, credentials, extensions, and writable\n    application settings remain managed by Gnosis.\n  ";
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
      name = {
        multiline = false;
        parts = [
          {
            type = "text";
            value = "Gnosis browser";
          }
        ];
        type = "string";
      };
      summary = {
        multiline = false;
        parts = [
          {
            type = "text";
            value = "Install the native Gnosis browser";
          }
        ];
        type = "string";
      };
      tags = {
        items = [
          {
            multiline = false;
            parts = [
              {
                type = "text";
                value = "programs";
              }
            ];
            type = "string";
          }
          {
            multiline = false;
            parts = [
              {
                type = "text";
                value = "browsers";
              }
            ];
            type = "string";
          }
          {
            multiline = false;
            parts = [
              {
                type = "text";
                value = "internet";
              }
            ];
            type = "string";
          }
        ];
        type = "list";
      };
      zenosVersion = {
        kind = "version";
        type = "literal";
        value = "1.0.0Nb";
      };
    };
    moduleIdentity = "zenos.programs.gnosis";
    modulePath = [
      "programs"
      "gnosis"
    ];
    nodeMetadata = [
      {
        metadata = {
          description = {
            multiline = true;
            parts = [
              {
                type = "text";
                value = "\n    Installs Gnosis, the Epiphany-based browser with a Chromium engine, for the\n    selected user scope. Browser profiles, credentials, extensions, and writable\n    application settings remain managed by Gnosis.\n  ";
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
          name = {
            multiline = false;
            parts = [
              {
                type = "text";
                value = "Gnosis browser";
              }
            ];
            type = "string";
          };
          summary = {
            multiline = false;
            parts = [
              {
                type = "text";
                value = "Install the native Gnosis browser";
              }
            ];
            type = "string";
          };
          tags = {
            items = [
              {
                multiline = false;
                parts = [
                  {
                    type = "text";
                    value = "programs";
                  }
                ];
                type = "string";
              }
              {
                multiline = false;
                parts = [
                  {
                    type = "text";
                    value = "browsers";
                  }
                ];
                type = "string";
              }
              {
                multiline = false;
                parts = [
                  {
                    type = "text";
                    value = "internet";
                  }
                ];
                type = "string";
              }
            ];
            type = "list";
          };
          zenosVersion = {
            kind = "version";
            type = "literal";
            value = "1.0.0Nb";
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
                value = "Install the selected Gnosis package without replacing its writable profile or preferences.";
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
          name = {
            multiline = false;
            parts = [
              {
                type = "text";
                value = "Enable Gnosis";
              }
            ];
            type = "string";
          };
          summary = {
            multiline = false;
            parts = [
              {
                type = "text";
                value = "Install Gnosis for the selected user scope";
              }
            ];
            type = "string";
          };
          tags = {
            items = [
              {
                multiline = false;
                parts = [
                  {
                    type = "text";
                    value = "programs";
                  }
                ];
                type = "string";
              }
              {
                multiline = false;
                parts = [
                  {
                    type = "text";
                    value = "browsers";
                  }
                ];
                type = "string";
              }
            ];
            type = "list";
          };
          zenosVersion = {
            kind = "version";
            type = "literal";
            value = "1.0.0Nb";
          };
        };
        path = [
          "enable"
        ];
      }
      {
        metadata = {
          description = {
            multiline = true;
            parts = [
              {
                type = "text";
                value = "Create application launchers while Gnosis keeps each browsing profile writable. Removing an entry leaves its profile intact.";
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
          name = {
            multiline = false;
            parts = [
              {
                type = "text";
                value = "Web applications";
              }
            ];
            type = "string";
          };
          summary = {
            multiline = false;
            parts = [
              {
                type = "text";
                value = "Named Gnosis web applications";
              }
            ];
            type = "string";
          };
          tags = {
            items = [
              {
                multiline = false;
                parts = [
                  {
                    type = "text";
                    value = "programs";
                  }
                ];
                type = "string";
              }
              {
                multiline = false;
                parts = [
                  {
                    type = "text";
                    value = "browsers";
                  }
                ];
                type = "string";
              }
              {
                multiline = false;
                parts = [
                  {
                    type = "text";
                    value = "web-apps";
                  }
                ];
                type = "string";
              }
            ];
            type = "list";
          };
          zenosVersion = {
            kind = "version";
            type = "literal";
            value = "1.0.0Nb";
          };
        };
        path = [
          "apps"
        ];
      }
      {
        metadata = {
          description = {
            multiline = true;
            parts = [
              {
                type = "text";
                value = "A launcher with an independent, writable Gnosis profile.";
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
          name = {
            multiline = false;
            parts = [
              {
                type = "text";
                value = "Web application";
              }
            ];
            type = "string";
          };
          summary = {
            multiline = false;
            parts = [
              {
                type = "text";
                value = "A named Gnosis web application";
              }
            ];
            type = "string";
          };
          tags = {
            items = [
              {
                multiline = false;
                parts = [
                  {
                    type = "text";
                    value = "programs";
                  }
                ];
                type = "string";
              }
              {
                multiline = false;
                parts = [
                  {
                    type = "text";
                    value = "browsers";
                  }
                ];
                type = "string";
              }
              {
                multiline = false;
                parts = [
                  {
                    type = "text";
                    value = "web-apps";
                  }
                ];
                type = "string";
              }
            ];
            type = "list";
          };
          zenosVersion = {
            kind = "version";
            type = "literal";
            value = "1.0.0Nb";
          };
        };
        path = [
          "apps"
          {
            freeform = "app";
          }
        ];
      }
      {
        metadata = {
          description = {
            multiline = true;
            parts = [
              {
                type = "text";
                value = "Display name. The named app key is its stable profile identity.";
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
          name = {
            multiline = false;
            parts = [
              {
                type = "text";
                value = "Name";
              }
            ];
            type = "string";
          };
          summary = {
            multiline = false;
            parts = [
              {
                type = "text";
                value = "Application name";
              }
            ];
            type = "string";
          };
          tags = {
            items = [
              {
                multiline = false;
                parts = [
                  {
                    type = "text";
                    value = "programs";
                  }
                ];
                type = "string";
              }
              {
                multiline = false;
                parts = [
                  {
                    type = "text";
                    value = "web-apps";
                  }
                ];
                type = "string";
              }
            ];
            type = "list";
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
            value = "1.0.0Nb";
          };
        };
        path = [
          "apps"
          {
            freeform = "app";
          }
          "name"
        ];
      }
      {
        metadata = {
          description = {
            multiline = true;
            parts = [
              {
                type = "text";
                value = "HTTP or HTTPS address opened by the launcher.";
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
          name = {
            multiline = false;
            parts = [
              {
                type = "text";
                value = "URL";
              }
            ];
            type = "string";
          };
          summary = {
            multiline = false;
            parts = [
              {
                type = "text";
                value = "Application URL";
              }
            ];
            type = "string";
          };
          tags = {
            items = [
              {
                multiline = false;
                parts = [
                  {
                    type = "text";
                    value = "programs";
                  }
                ];
                type = "string";
              }
              {
                multiline = false;
                parts = [
                  {
                    type = "text";
                    value = "web-apps";
                  }
                ];
                type = "string";
              }
            ];
            type = "list";
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
            value = "1.0.0Nb";
          };
        };
        path = [
          "apps"
          {
            freeform = "app";
          }
          "url"
        ];
      }
      {
        metadata = {
          default = {
            multiline = false;
            parts = [
              {
                type = "text";
                value = "web-browser";
              }
            ];
            type = "string";
          };
          description = {
            multiline = true;
            parts = [
              {
                type = "text";
                value = "Icon theme name or absolute icon path.";
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
          name = {
            multiline = false;
            parts = [
              {
                type = "text";
                value = "Icon";
              }
            ];
            type = "string";
          };
          summary = {
            multiline = false;
            parts = [
              {
                type = "text";
                value = "Application icon";
              }
            ];
            type = "string";
          };
          tags = {
            items = [
              {
                multiline = false;
                parts = [
                  {
                    type = "text";
                    value = "programs";
                  }
                ];
                type = "string";
              }
              {
                multiline = false;
                parts = [
                  {
                    type = "text";
                    value = "web-apps";
                  }
                ];
                type = "string";
              }
            ];
            type = "list";
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
            value = "1.0.0Nb";
          };
        };
        path = [
          "apps"
          {
            freeform = "app";
          }
          "icon"
        ];
      }
      {
        metadata = {
          default = {
            name = "pkgs";
            path = [
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
                value = "browsers";
              }
              {
                kind = "identifier";
                value = "gnosis";
              }
            ];
            type = "variable";
          };
          description = {
            multiline = true;
            parts = [
              {
                type = "text";
                value = "\n      Gnosis derivation providing bin/gnosis and the\n      com.neg-zero.Gnosis.desktop desktop entry. The default is the\n      published development snapshot in the Zenpkgs browser catalog; override\n      this option to select a newer development package.\n    ";
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
          name = {
            multiline = false;
            parts = [
              {
                type = "text";
                value = "Gnosis package";
              }
            ];
            type = "string";
          };
          summary = {
            multiline = false;
            parts = [
              {
                type = "text";
                value = "Gnosis package to install";
              }
            ];
            type = "string";
          };
          tags = {
            items = [
              {
                multiline = false;
                parts = [
                  {
                    type = "text";
                    value = "programs";
                  }
                ];
                type = "string";
              }
              {
                multiline = false;
                parts = [
                  {
                    type = "text";
                    value = "browsers";
                  }
                ];
                type = "string";
              }
            ];
            type = "list";
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
            value = "1.0.0Nb";
          };
        };
        path = [
          "package"
        ];
      }
      {
        metadata = {
          default = {
            kind = "false";
            type = "literal";
            value = false;
          };
          description = {
            multiline = true;
            parts = [
              {
                type = "text";
                value = "Declare Gnosis as the default handler for HTTP, HTTPS, HTML, and XHTML. False leaves existing associations untouched.";
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
          name = {
            multiline = false;
            parts = [
              {
                type = "text";
                value = "Default browser";
              }
            ];
            type = "string";
          };
          summary = {
            multiline = false;
            parts = [
              {
                type = "text";
                value = "Use Gnosis for web links and HTML documents";
              }
            ];
            type = "string";
          };
          tags = {
            items = [
              {
                multiline = false;
                parts = [
                  {
                    type = "text";
                    value = "programs";
                  }
                ];
                type = "string";
              }
              {
                multiline = false;
                parts = [
                  {
                    type = "text";
                    value = "browsers";
                  }
                ];
                type = "string";
              }
            ];
            type = "list";
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
            value = "1.0.0Nb";
          };
        };
        path = [
          "defaultBrowser"
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
                value = "1.0.0Nb";
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
                    value = "Gnosis browser";
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
                    value = "Install the native Gnosis browser";
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
                    value = "\n    Installs Gnosis, the Epiphany-based browser with a Chromium engine, for the\n    selected user scope. Browser profiles, credentials, extensions, and writable\n    application settings remain managed by Gnosis.\n  ";
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
                  value = "tags";
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
                        value = "programs";
                      }
                    ];
                    type = "string";
                  }
                  {
                    multiline = false;
                    parts = [
                      {
                        type = "text";
                        value = "browsers";
                      }
                    ];
                    type = "string";
                  }
                  {
                    multiline = false;
                    parts = [
                      {
                        type = "text";
                        value = "internet";
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
                          value = "name";
                        }
                      ];
                      type = "assignment";
                      value = {
                        multiline = false;
                        parts = [
                          {
                            type = "text";
                            value = "Enable Gnosis";
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
                            value = "Install Gnosis for the selected user scope";
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
                            value = "Install the selected Gnosis package without replacing its writable profile or preferences.";
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
                          value = "tags";
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
                                value = "programs";
                              }
                            ];
                            type = "string";
                          }
                          {
                            multiline = false;
                            parts = [
                              {
                                type = "text";
                                value = "browsers";
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
                        items = [
                          {
                            name = "path";
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
                                    body = {
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
                                                      name = "path";
                                                      path = [
                                                        {
                                                          kind = "identifier";
                                                          value = "package";
                                                        }
                                                      ];
                                                      type = "variable";
                                                    };
                                                    type = "interpolation";
                                                  }
                                                  {
                                                    type = "text";
                                                    value = "/bin/gnosis --application-mode=";
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
                                                  {
                                                    type = "text";
                                                    value = ".desktop \"";
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
                                                              value = "url";
                                                            }
                                                          ];
                                                          type = "reference";
                                                        }
                                                      ];
                                                      callee = {
                                                        arguments = [
                                                          {
                                                            items = [
                                                              {
                                                                multiline = false;
                                                                parts = [
                                                                  {
                                                                    type = "text";
                                                                    value = "\\\\";
                                                                  }
                                                                ];
                                                                type = "string";
                                                              }
                                                              {
                                                                multiline = false;
                                                                parts = [
                                                                  {
                                                                    type = "text";
                                                                    value = "\\\"";
                                                                  }
                                                                ];
                                                                type = "string";
                                                              }
                                                              {
                                                                multiline = false;
                                                                parts = [
                                                                  {
                                                                    type = "text";
                                                                    value = "%%";
                                                                  }
                                                                ];
                                                                type = "string";
                                                              }
                                                            ];
                                                            type = "list";
                                                          }
                                                        ];
                                                        callee = {
                                                          arguments = [
                                                            {
                                                              items = [
                                                                {
                                                                  multiline = false;
                                                                  parts = [
                                                                    {
                                                                      type = "text";
                                                                      value = "\\";
                                                                    }
                                                                  ];
                                                                  type = "string";
                                                                }
                                                                {
                                                                  multiline = false;
                                                                  parts = [
                                                                    {
                                                                      type = "text";
                                                                      value = "\"";
                                                                    }
                                                                  ];
                                                                  type = "string";
                                                                }
                                                                {
                                                                  multiline = false;
                                                                  parts = [
                                                                    {
                                                                      type = "text";
                                                                      value = "%";
                                                                    }
                                                                  ];
                                                                  type = "string";
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
                                                                value = "replaceStrings";
                                                              }
                                                            ];
                                                            type = "variable";
                                                          };
                                                          type = "call";
                                                        };
                                                        type = "call";
                                                      };
                                                      type = "call";
                                                    };
                                                    type = "interpolation";
                                                  }
                                                  {
                                                    type = "text";
                                                    value = "\"";
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
                                                  value = "terminal";
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
                                                        value = "StartupWMClass";
                                                      }
                                                    ];
                                                    type = "assignment";
                                                    value = {
                                                      path = [
                                                        {
                                                          kind = "identifier";
                                                          value = "id";
                                                        }
                                                      ];
                                                      type = "reference";
                                                    };
                                                  }
                                                  {
                                                    operator = "=";
                                                    target = [
                                                      {
                                                        kind = "string";
                                                        value = "X-Gnosis-Declarative";
                                                      }
                                                    ];
                                                    type = "assignment";
                                                    value = {
                                                      multiline = false;
                                                      parts = [
                                                        {
                                                          type = "text";
                                                          value = "true";
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
                                        }
                                      ];
                                      callee = {
                                        arguments = [
                                          {
                                            path = [
                                              {
                                                kind = "identifier";
                                                value = "id";
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
                                              value = "nameValuePair";
                                            }
                                          ];
                                          type = "variable";
                                        };
                                        type = "call";
                                      };
                                      type = "call";
                                    };
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
                                          multiline = false;
                                          parts = [
                                            {
                                              type = "text";
                                              value = "com.neg-zero.Gnosis.WebApp_";
                                            }
                                            {
                                              expression = {
                                                path = [
                                                  {
                                                    kind = "identifier";
                                                    value = "key";
                                                  }
                                                ];
                                                type = "reference";
                                              };
                                              type = "interpolation";
                                            }
                                          ];
                                          type = "string";
                                        };
                                      }
                                    ];
                                    type = "let";
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
                                value = "mapAttrs'";
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
                                            value = "assertion";
                                          }
                                        ];
                                        type = "assignment";
                                        value = {
                                          left = {
                                            left = {
                                              left = {
                                                arguments = [
                                                  {
                                                    path = [
                                                      {
                                                        kind = "identifier";
                                                        value = "key";
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
                                                          value = "[A-Za-z0-9_-]+";
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
                                                        value = "match";
                                                      }
                                                    ];
                                                    type = "variable";
                                                  };
                                                  type = "call";
                                                };
                                                type = "call";
                                              };
                                              operator = "!=";
                                              right = {
                                                kind = "null";
                                                type = "literal";
                                                value = null;
                                              };
                                              type = "binary";
                                            };
                                            operator = "&&";
                                            right = {
                                              left = {
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
                                              operator = "!=";
                                              right = {
                                                multiline = false;
                                                parts = [ ];
                                                type = "string";
                                              };
                                              type = "binary";
                                            };
                                            type = "binary";
                                          };
                                          operator = "&&";
                                          right = {
                                            left = {
                                              arguments = [
                                                {
                                                  path = [
                                                    {
                                                      kind = "identifier";
                                                      value = "app";
                                                    }
                                                    {
                                                      kind = "identifier";
                                                      value = "url";
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
                                                        value = "https?://[^[:space:]\"\\\\]+";
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
                                                      value = "match";
                                                    }
                                                  ];
                                                  type = "variable";
                                                };
                                                type = "call";
                                              };
                                              type = "call";
                                            };
                                            operator = "!=";
                                            right = {
                                              kind = "null";
                                              type = "literal";
                                              value = null;
                                            };
                                            type = "binary";
                                          };
                                          type = "binary";
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
                                              value = "Gnosis app ";
                                            }
                                            {
                                              expression = {
                                                path = [
                                                  {
                                                    kind = "identifier";
                                                    value = "key";
                                                  }
                                                ];
                                                type = "reference";
                                              };
                                              type = "interpolation";
                                            }
                                            {
                                              type = "text";
                                              value = ": key must contain letters, digits, hyphens or underscores; name must be nonempty and URL must be HTTP(S) without whitespace, quotes or backslashes.";
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
                          value = "xdg";
                        }
                        {
                          kind = "identifier";
                          value = "mimeApps";
                        }
                      ];
                      type = "assignment";
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
                                        items = [
                                          {
                                            multiline = false;
                                            parts = [
                                              {
                                                type = "text";
                                                value = "com.neg-zero.Gnosis.desktop";
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
                                          kind = "string";
                                          value = "x-scheme-handler/https";
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
                                                value = "com.neg-zero.Gnosis.desktop";
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
                                          kind = "string";
                                          value = "text/html";
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
                                                value = "com.neg-zero.Gnosis.desktop";
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
                                          kind = "string";
                                          value = "application/xhtml+xml";
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
                                                value = "com.neg-zero.Gnosis.desktop";
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
                          }
                        ];
                        callee = {
                          arguments = [
                            {
                              name = "path";
                              path = [
                                {
                                  kind = "identifier";
                                  value = "defaultBrowser";
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
                                value = "optionalAttrs";
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
                        value = "name";
                      }
                    ];
                    type = "assignment";
                    value = {
                      multiline = false;
                      parts = [
                        {
                          type = "text";
                          value = "Web applications";
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
                          value = "Named Gnosis web applications";
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
                          value = "Create application launchers while Gnosis keeps each browsing profile writable. Removing an entry leaves its profile intact.";
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
                        value = "tags";
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
                              value = "programs";
                            }
                          ];
                          type = "string";
                        }
                        {
                          multiline = false;
                          parts = [
                            {
                              type = "text";
                              value = "browsers";
                            }
                          ];
                          type = "string";
                        }
                        {
                          multiline = false;
                          parts = [
                            {
                              type = "text";
                              value = "web-apps";
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
                ];
                type = "attr-set";
              };
            }
            {
              operator = "=";
              target = {
                argument = [
                  {
                    kind = "identifier";
                    value = "app";
                  }
                ];
                kind = "freeform";
                type = "structural-marker";
              };
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
                              value = "name";
                            }
                          ];
                          type = "assignment";
                          value = {
                            multiline = false;
                            parts = [
                              {
                                type = "text";
                                value = "Web application";
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
                                value = "A named Gnosis web application";
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
                                value = "A launcher with an independent, writable Gnosis profile.";
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
                              value = "tags";
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
                                    value = "programs";
                                  }
                                ];
                                type = "string";
                              }
                              {
                                multiline = false;
                                parts = [
                                  {
                                    type = "text";
                                    value = "browsers";
                                  }
                                ];
                                type = "string";
                              }
                              {
                                multiline = false;
                                parts = [
                                  {
                                    type = "text";
                                    value = "web-apps";
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
                      ];
                      type = "attr-set";
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
                                    value = "name";
                                  }
                                ];
                                type = "assignment";
                                value = {
                                  multiline = false;
                                  parts = [
                                    {
                                      type = "text";
                                      value = "Name";
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
                                      value = "Application name";
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
                                      value = "Display name. The named app key is its stable profile identity.";
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
                                    value = "tags";
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
                                          value = "programs";
                                        }
                                      ];
                                      type = "string";
                                    }
                                    {
                                      multiline = false;
                                      parts = [
                                        {
                                          type = "text";
                                          value = "web-apps";
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
                        value = "url";
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
                                    value = "name";
                                  }
                                ];
                                type = "assignment";
                                value = {
                                  multiline = false;
                                  parts = [
                                    {
                                      type = "text";
                                      value = "URL";
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
                                      value = "Application URL";
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
                                      value = "HTTP or HTTPS address opened by the launcher.";
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
                                    value = "tags";
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
                                          value = "programs";
                                        }
                                      ];
                                      type = "string";
                                    }
                                    {
                                      multiline = false;
                                      parts = [
                                        {
                                          type = "text";
                                          value = "web-apps";
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
                        value = "icon";
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
                                    value = "name";
                                  }
                                ];
                                type = "assignment";
                                value = {
                                  multiline = false;
                                  parts = [
                                    {
                                      type = "text";
                                      value = "Icon";
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
                                      value = "Application icon";
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
                                      value = "Icon theme name or absolute icon path.";
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
                                    value = "tags";
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
                                          value = "programs";
                                        }
                                      ];
                                      type = "string";
                                    }
                                    {
                                      multiline = false;
                                      parts = [
                                        {
                                          type = "text";
                                          value = "web-apps";
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
      {
        operator = "=";
        target = [
          {
            kind = "identifier";
            value = "package";
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
                        value = "name";
                      }
                    ];
                    type = "assignment";
                    value = {
                      multiline = false;
                      parts = [
                        {
                          type = "text";
                          value = "Gnosis package";
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
                          value = "Gnosis package to install";
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
                          value = "\n      Gnosis derivation providing bin/gnosis and the\n      com.neg-zero.Gnosis.desktop desktop entry. The default is the\n      published development snapshot in the Zenpkgs browser catalog; override\n      this option to select a newer development package.\n    ";
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
                          value = "byCategories";
                        }
                        {
                          kind = "identifier";
                          value = "apps";
                        }
                        {
                          kind = "identifier";
                          value = "browsers";
                        }
                        {
                          kind = "identifier";
                          value = "gnosis";
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
                        value = "tags";
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
                              value = "programs";
                            }
                          ];
                          type = "string";
                        }
                        {
                          multiline = false;
                          parts = [
                            {
                              type = "text";
                              value = "browsers";
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
            value = "defaultBrowser";
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
                        value = "name";
                      }
                    ];
                    type = "assignment";
                    value = {
                      multiline = false;
                      parts = [
                        {
                          type = "text";
                          value = "Default browser";
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
                          value = "Use Gnosis for web links and HTML documents";
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
                          value = "Declare Gnosis as the default handler for HTTP, HTTPS, HTML, and XHTML. False leaves existing associations untouched.";
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
                        value = "tags";
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
                              value = "programs";
                            }
                          ];
                          type = "string";
                        }
                        {
                          multiline = false;
                          parts = [
                            {
                              type = "text";
                              value = "browsers";
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
      home.packages = [
        cfg.package
      ];
      xdg.desktopEntries = ((lib.mapAttrs' ((key: (app: (let
        id = "com.neg-zero.Gnosis.WebApp_${((value: let kind = builtins.typeOf value; in if kind == "string" then value else if kind == "bool" || kind == "int" || kind == "float" then builtins.toJSON value else if kind == "path" then "${value}" else if kind == "set" && (value.type or null) == "derivation" && builtins.isString (value.outPath or null) then value.outPath else throw "/nix/store/3ni594f60hm22hcrazxd35dmk7pwi61m-zenpkgs-dsl-source/modules/programs/gnosis.zmdl:29: string interpolation requires a scalar, path, or package") (key))}";
      in ((lib.nameValuePair id) {
        name = app.name;
        genericName = "Web Application";
        exec = "${((value: let kind = builtins.typeOf value; in if kind == "string" then value else if kind == "bool" || kind == "int" || kind == "float" then builtins.toJSON value else if kind == "path" then "${value}" else if kind == "set" && (value.type or null) == "derivation" && builtins.isString (value.outPath or null) then value.outPath else throw "/nix/store/3ni594f60hm22hcrazxd35dmk7pwi61m-zenpkgs-dsl-source/modules/programs/gnosis.zmdl:33: string interpolation requires a scalar, path, or package") (cfg.package))}/bin/gnosis --application-mode=${((value: let kind = builtins.typeOf value; in if kind == "string" then value else if kind == "bool" || kind == "int" || kind == "float" then builtins.toJSON value else if kind == "path" then "${value}" else if kind == "set" && (value.type or null) == "derivation" && builtins.isString (value.outPath or null) then value.outPath else throw "/nix/store/3ni594f60hm22hcrazxd35dmk7pwi61m-zenpkgs-dsl-source/modules/programs/gnosis.zmdl:33: string interpolation requires a scalar, path, or package") (id))}.desktop \"${((value: let kind = builtins.typeOf value; in if kind == "string" then value else if kind == "bool" || kind == "int" || kind == "float" then builtins.toJSON value else if kind == "path" then "${value}" else if kind == "set" && (value.type or null) == "derivation" && builtins.isString (value.outPath or null) then value.outPath else throw "/nix/store/3ni594f60hm22hcrazxd35dmk7pwi61m-zenpkgs-dsl-source/modules/programs/gnosis.zmdl:33: string interpolation requires a scalar, path, or package") ((((lib.replaceStrings [
  "\\"
  "\""
  "%"
]) [
  "\\\\"
  "\\\""
  "%%"
]) app.url)))}\"";
        icon = app.icon;
        terminal = false;
        categories = [
          "Network"
          "WebBrowser"
        ];
        settings = {
          StartupWMClass = id;
          "X-Gnosis-Declarative" = "true";
        };
      })))))) cfg.apps);
      assertions = ((lib.mapAttrsToList ((key: (app: {
        assertion = (((((lib.match "[A-Za-z0-9_-]+") key) != null) && (app.name != "")) && (((lib.match "https?://[^[:space:]\"\\\\]+") app.url) != null));
        message = "Gnosis app ${((value: let kind = builtins.typeOf value; in if kind == "string" then value else if kind == "bool" || kind == "int" || kind == "float" then builtins.toJSON value else if kind == "path" then "${value}" else if kind == "set" && (value.type or null) == "derivation" && builtins.isString (value.outPath or null) then value.outPath else throw "/nix/store/3ni594f60hm22hcrazxd35dmk7pwi61m-zenpkgs-dsl-source/modules/programs/gnosis.zmdl:45: string interpolation requires a scalar, path, or package") (key))}: key must contain letters, digits, hyphens or underscores; name must be nonempty and URL must be HTTP(S) without whitespace, quotes or backslashes.";
      })))) cfg.apps);
      xdg.mimeApps = ((lib.optionalAttrs cfg.defaultBrowser) {
        enable = true;
        defaultApplications = {
          "x-scheme-handler/http" = [
            "com.neg-zero.Gnosis.desktop"
          ];
          "x-scheme-handler/https" = [
            "com.neg-zero.Gnosis.desktop"
          ];
          "text/html" = [
            "com.neg-zero.Gnosis.desktop"
          ];
          "application/xhtml+xml" = [
            "com.neg-zero.Gnosis.desktop"
          ];
        };
      });
    } ]; })
  ];
}
