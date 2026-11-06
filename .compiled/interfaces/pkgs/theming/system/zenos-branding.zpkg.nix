{ ... }:
{
  dependenciesDeclared = false;
  descriptorVersion = "zenlang.semantic/2";
  grammarVersion = "1.0.0Na";
  id = "pkgs.com.neg-zero.zenos-branding";
  imports = [ ];
  irVersion = "1.0.0Na";
  kind = "zpkg";
  location = "/nix/store/59qqzf108ga8h2qmsjizzsn2p7i889xx-zenpkgs-dsl-source/pkgs/theming/system/zenos-branding.zpkg:13:9";
  metadata = {
    description = {
      multiline = true;
      parts = [
        {
          type = "text";
          value = "Provides the ZenOS desktop logo and symbolic icon independently of the installer application.";
        }
      ];
      type = "string";
    };
    id = {
      multiline = false;
      parts = [
        {
          type = "text";
          value = "com.neg-zero.zenos-branding";
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
          value = "ZenOS branding";
        }
      ];
      type = "string";
    };
    packageVersion = {
      multiline = false;
      parts = [
        {
          type = "text";
          value = "1.0.0";
        }
      ];
      type = "string";
    };
    summary = {
      multiline = false;
      parts = [
        {
          type = "text";
          value = "ZenOS logos for installed desktops";
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
              value = "theme";
            }
          ];
          type = "string";
        }
        {
          multiline = false;
          parts = [
            {
              type = "text";
              value = "branding";
            }
          ];
          type = "string";
        }
        {
          multiline = false;
          parts = [
            {
              type = "text";
              value = "icons";
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
  name = "zenos-branding";
  provider = {
    expression = {
      arguments = [
        {
          recursive = false;
          statements = [
            {
              operator = "=";
              target = [
                {
                  kind = "identifier";
                  value = "pname";
                }
              ];
              type = "assignment";
              value = {
                multiline = false;
                parts = [
                  {
                    type = "text";
                    value = "zenos-branding";
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
                  value = "version";
                }
              ];
              type = "assignment";
              value = {
                multiline = false;
                parts = [
                  {
                    type = "text";
                    value = "1.0.0";
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
                  value = "src";
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
                    value = "system";
                  }
                  {
                    kind = "identifier";
                    value = "zenos-setup";
                  }
                  {
                    kind = "identifier";
                    value = "src";
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
                  value = "dontBuild";
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
                  value = "installPhase";
                }
              ];
              type = "assignment";
              value = {
                multiline = true;
                parts = [
                  {
                    type = "text";
                    value = "\n    runHook preInstall\n    install -Dm644 data/icons/hicolor/scalable/apps/zenos.svg \\\n      \"$out/share/icons/hicolor/scalable/apps/zenos.svg\"\n    install -Dm644 data/icons/hicolor/symbolic/apps/zenos-symbolic.svg \\\n      \"$out/share/icons/hicolor/symbolic/apps/zenos-symbolic.svg\"\n    ln -s zenos.svg \"$out/share/icons/hicolor/scalable/apps/distributor-logo.svg\"\n    ln -s zenos-symbolic.svg \"$out/share/icons/hicolor/symbolic/apps/distributor-logo-symbolic.svg\"\n    runHook postInstall\n  ";
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
                  value = "meta";
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
                      multiline = false;
                      parts = [
                        {
                          type = "text";
                          value = "ZenOS desktop branding icons";
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
                          value = "linux";
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
        }
      ];
      callee = {
        name = "pkgs";
        path = [
          {
            kind = "identifier";
            value = "legacy";
          }
          {
            kind = "identifier";
            value = "stdenvNoCC";
          }
          {
            kind = "identifier";
            value = "mkDerivation";
          }
        ];
        type = "variable";
      };
      type = "call";
    };
    kind = "build";
  };
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
                value = "id";
              }
            ];
            type = "assignment";
            value = {
              multiline = false;
              parts = [
                {
                  type = "text";
                  value = "com.neg-zero.zenos-branding";
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
                value = "name";
              }
            ];
            type = "assignment";
            value = {
              multiline = false;
              parts = [
                {
                  type = "text";
                  value = "ZenOS branding";
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
                  value = "ZenOS logos for installed desktops";
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
                  value = "Provides the ZenOS desktop logo and symbolic icon independently of the installer application.";
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
                value = "packageVersion";
              }
            ];
            type = "assignment";
            value = {
              multiline = false;
              parts = [
                {
                  type = "text";
                  value = "1.0.0";
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
                      value = "theme";
                    }
                  ];
                  type = "string";
                }
                {
                  multiline = false;
                  parts = [
                    {
                      type = "text";
                      value = "branding";
                    }
                  ];
                  type = "string";
                }
                {
                  multiline = false;
                  parts = [
                    {
                      type = "text";
                      value = "icons";
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
          value = "build";
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
                    value = "pname";
                  }
                ];
                type = "assignment";
                value = {
                  multiline = false;
                  parts = [
                    {
                      type = "text";
                      value = "zenos-branding";
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
                    value = "version";
                  }
                ];
                type = "assignment";
                value = {
                  multiline = false;
                  parts = [
                    {
                      type = "text";
                      value = "1.0.0";
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
                    value = "src";
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
                      value = "system";
                    }
                    {
                      kind = "identifier";
                      value = "zenos-setup";
                    }
                    {
                      kind = "identifier";
                      value = "src";
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
                    value = "dontBuild";
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
                    value = "installPhase";
                  }
                ];
                type = "assignment";
                value = {
                  multiline = true;
                  parts = [
                    {
                      type = "text";
                      value = "\n    runHook preInstall\n    install -Dm644 data/icons/hicolor/scalable/apps/zenos.svg \\\n      \"$out/share/icons/hicolor/scalable/apps/zenos.svg\"\n    install -Dm644 data/icons/hicolor/symbolic/apps/zenos-symbolic.svg \\\n      \"$out/share/icons/hicolor/symbolic/apps/zenos-symbolic.svg\"\n    ln -s zenos.svg \"$out/share/icons/hicolor/scalable/apps/distributor-logo.svg\"\n    ln -s zenos-symbolic.svg \"$out/share/icons/hicolor/symbolic/apps/distributor-logo-symbolic.svg\"\n    runHook postInstall\n  ";
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
                    value = "meta";
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
                        multiline = false;
                        parts = [
                          {
                            type = "text";
                            value = "ZenOS desktop branding icons";
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
                            value = "linux";
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
          }
        ];
        callee = {
          name = "pkgs";
          path = [
            {
              kind = "identifier";
              value = "legacy";
            }
            {
              kind = "identifier";
              value = "stdenvNoCC";
            }
            {
              kind = "identifier";
              value = "mkDerivation";
            }
          ];
          type = "variable";
        };
        type = "call";
      };
    }
  ];
  target = [
    "com"
    "neg-zero"
    "zenos-branding"
  ];
}
