{ ... }:
{
  dependenciesDeclared = false;
  descriptorVersion = "zenlang.semantic/2";
  grammarVersion = "1.0.0Na";
  id = "pkgs.com.neg-zero.zenos-setup";
  imports = [ ];
  irVersion = "1.0.0Na";
  kind = "zpkg";
  location = "/nix/store/59qqzf108ga8h2qmsjizzsn2p7i889xx-zenpkgs-dsl-source/pkgs/apps/system/zenos-setup.zpkg:12:9";
  metadata = {
    description = {
      multiline = true;
      parts = [
        {
          type = "text";
          value = "Installs ZenOS and finishes user setup after the first boot.";
        }
      ];
      type = "string";
    };
    id = {
      multiline = false;
      parts = [
        {
          type = "text";
          value = "com.neg-zero.zenos-setup";
        }
      ];
      type = "string";
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
          value = "ZenOS Setup";
        }
      ];
      type = "string";
    };
    packageVersion = {
      multiline = false;
      parts = [
        {
          type = "text";
          value = "0.1.0";
        }
      ];
      type = "string";
    };
    summary = {
      multiline = false;
      parts = [
        {
          type = "text";
          value = "ZenOS installer and first-boot setup";
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
              value = "installer";
            }
          ];
          type = "string";
        }
        {
          multiline = false;
          parts = [
            {
              type = "text";
              value = "oobe";
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
  name = "zenos-setup";
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
                  value = "applicationIcons";
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
                        value = "com.neg-zero.Gnosis";
                      }
                    ];
                    type = "assignment";
                    value = {
                      left = {
                        name = "lib";
                        path = [
                          {
                            kind = "identifier";
                            value = "zenPackageSources";
                          }
                          {
                            kind = "identifier";
                            value = "gnosis";
                          }
                          {
                            kind = "identifier";
                            value = "outPath";
                          }
                        ];
                        type = "variable";
                      };
                      operator = "+";
                      right = {
                        multiline = false;
                        parts = [
                          {
                            type = "text";
                            value = "/data/icons/hicolor/scalable/apps/com.neg-zero.Gnosis.svg";
                          }
                        ];
                        type = "string";
                      };
                      type = "binary";
                    };
                  }
                  {
                    operator = "=";
                    target = [
                      {
                        kind = "string";
                        value = "io.github.doromiert.SelectForFigma";
                      }
                    ];
                    type = "assignment";
                    value = {
                      left = {
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
                            value = "graphics";
                          }
                          {
                            kind = "identifier";
                            value = "select-for-figma";
                          }
                          {
                            kind = "identifier";
                            value = "src";
                          }
                        ];
                        type = "variable";
                      };
                      operator = "+";
                      right = {
                        multiline = false;
                        parts = [
                          {
                            type = "text";
                            value = "/data/io.github.doromiert.SelectForFigma.svg";
                          }
                        ];
                        type = "string";
                      };
                      type = "binary";
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
            type = "group";
            value = {
              left = {
                name = "lib";
                path = [
                  {
                    kind = "identifier";
                    value = "zenPackageSources";
                  }
                  {
                    kind = "identifier";
                    value = "setup";
                  }
                ];
                type = "variable";
              };
              operator = "+";
              right = {
                multiline = false;
                parts = [
                  {
                    type = "text";
                    value = "/package.nix";
                  }
                ];
                type = "string";
              };
              type = "binary";
            };
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
              value = "callPackage";
            }
          ];
          type = "variable";
        };
        type = "call";
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
                  value = "com.neg-zero.zenos-setup";
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
                  value = "ZenOS Setup";
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
                  value = "ZenOS installer and first-boot setup";
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
                  value = "Installs ZenOS and finishes user setup after the first boot.";
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
                  value = "0.1.0";
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
                      value = "installer";
                    }
                  ];
                  type = "string";
                }
                {
                  multiline = false;
                  parts = [
                    {
                      type = "text";
                      value = "oobe";
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
                    value = "applicationIcons";
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
                          value = "com.neg-zero.Gnosis";
                        }
                      ];
                      type = "assignment";
                      value = {
                        left = {
                          name = "lib";
                          path = [
                            {
                              kind = "identifier";
                              value = "zenPackageSources";
                            }
                            {
                              kind = "identifier";
                              value = "gnosis";
                            }
                            {
                              kind = "identifier";
                              value = "outPath";
                            }
                          ];
                          type = "variable";
                        };
                        operator = "+";
                        right = {
                          multiline = false;
                          parts = [
                            {
                              type = "text";
                              value = "/data/icons/hicolor/scalable/apps/com.neg-zero.Gnosis.svg";
                            }
                          ];
                          type = "string";
                        };
                        type = "binary";
                      };
                    }
                    {
                      operator = "=";
                      target = [
                        {
                          kind = "string";
                          value = "io.github.doromiert.SelectForFigma";
                        }
                      ];
                      type = "assignment";
                      value = {
                        left = {
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
                              value = "graphics";
                            }
                            {
                              kind = "identifier";
                              value = "select-for-figma";
                            }
                            {
                              kind = "identifier";
                              value = "src";
                            }
                          ];
                          type = "variable";
                        };
                        operator = "+";
                        right = {
                          multiline = false;
                          parts = [
                            {
                              type = "text";
                              value = "/data/io.github.doromiert.SelectForFigma.svg";
                            }
                          ];
                          type = "string";
                        };
                        type = "binary";
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
              type = "group";
              value = {
                left = {
                  name = "lib";
                  path = [
                    {
                      kind = "identifier";
                      value = "zenPackageSources";
                    }
                    {
                      kind = "identifier";
                      value = "setup";
                    }
                  ];
                  type = "variable";
                };
                operator = "+";
                right = {
                  multiline = false;
                  parts = [
                    {
                      type = "text";
                      value = "/package.nix";
                    }
                  ];
                  type = "string";
                };
                type = "binary";
              };
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
                value = "callPackage";
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
  target = [
    "com"
    "neg-zero"
    "zenos-setup"
  ];
}
