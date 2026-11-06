{ ... }:
{
  dependenciesDeclared = false;
  descriptorVersion = "zenlang.semantic/2";
  grammarVersion = "1.0.0Na";
  id = "pkgs.com.valvesoftware.Steam";
  imports = [ ];
  irVersion = "1.0.0Na";
  kind = "zpkg";
  location = "/nix/store/59qqzf108ga8h2qmsjizzsn2p7i889xx-zenpkgs-dsl-source/pkgs/apps/gaming/steam.zpkg:14:9";
  metadata = {
    description = {
      multiline = true;
      parts = [
        {
          type = "text";
          value = "\n    Curated steam package for ZenOS\n  ";
        }
      ];
      type = "string";
    };
    id = {
      multiline = false;
      parts = [
        {
          type = "text";
          value = "com.valvesoftware.Steam";
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
          value = "steam";
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
          value = "Curated steam package for ZenOS";
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
              value = "gaming";
            }
          ];
          type = "string";
        }
        {
          multiline = false;
          parts = [
            {
              type = "text";
              value = "store";
            }
          ];
          type = "string";
        }
        {
          multiline = false;
          parts = [
            {
              type = "text";
              value = "launcher";
            }
          ];
          type = "string";
        }
      ];
      type = "list";
    };
    zenosVersion = {
      multiline = false;
      parts = [
        {
          type = "text";
          value = "1.0.0";
        }
      ];
      type = "string";
    };
  };
  name = "steam";
  provider = {
    expression = {
      arguments = [
        {
          multiline = false;
          parts = [
            {
              type = "text";
              value = "68561f488261e6f7d6d63a8f8765d6f75091a558409550efeb2cc3c111f5b280";
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
                value = "steam";
              }
            ];
            type = "string";
          }
        ];
        callee = {
          arguments = [
            {
              type = "group";
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
                            value = "extraEnv";
                          }
                          {
                            kind = "identifier";
                            value = "STEAM_EXTRA_COMPAT_TOOLS_PATHS";
                          }
                        ];
                        type = "assignment";
                        value = {
                          arguments = [
                            {
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
                                      value = "apps";
                                    }
                                    {
                                      kind = "identifier";
                                      value = "gaming";
                                    }
                                    {
                                      kind = "identifier";
                                      value = "proton-ge-bin";
                                    }
                                  ];
                                  type = "variable";
                                }
                              ];
                              type = "list";
                            }
                          ];
                          callee = {
                            arguments = [
                              {
                                multiline = false;
                                parts = [ ];
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
                                      value = "steamcompattool";
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
                                    value = "makeSearchPathOutput";
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
                      value = "steam";
                    }
                    {
                      kind = "identifier";
                      value = "override";
                    }
                  ];
                  type = "variable";
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
                value = "zenPrivateHomePackage";
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
                  value = "com.valvesoftware.Steam";
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
                  value = "steam";
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
                  value = "Curated steam package for ZenOS";
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
                  value = "\n    Curated steam package for ZenOS\n  ";
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
                value = "packageVersion";
              }
            ];
            type = "assignment";
            value = {
              multiline = false;
              parts = [ ];
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
                      value = "gaming";
                    }
                  ];
                  type = "string";
                }
                {
                  multiline = false;
                  parts = [
                    {
                      type = "text";
                      value = "store";
                    }
                  ];
                  type = "string";
                }
                {
                  multiline = false;
                  parts = [
                    {
                      type = "text";
                      value = "launcher";
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
            multiline = false;
            parts = [
              {
                type = "text";
                value = "68561f488261e6f7d6d63a8f8765d6f75091a558409550efeb2cc3c111f5b280";
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
                  value = "steam";
                }
              ];
              type = "string";
            }
          ];
          callee = {
            arguments = [
              {
                type = "group";
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
                              value = "extraEnv";
                            }
                            {
                              kind = "identifier";
                              value = "STEAM_EXTRA_COMPAT_TOOLS_PATHS";
                            }
                          ];
                          type = "assignment";
                          value = {
                            arguments = [
                              {
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
                                        value = "apps";
                                      }
                                      {
                                        kind = "identifier";
                                        value = "gaming";
                                      }
                                      {
                                        kind = "identifier";
                                        value = "proton-ge-bin";
                                      }
                                    ];
                                    type = "variable";
                                  }
                                ];
                                type = "list";
                              }
                            ];
                            callee = {
                              arguments = [
                                {
                                  multiline = false;
                                  parts = [ ];
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
                                        value = "steamcompattool";
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
                                      value = "makeSearchPathOutput";
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
                        value = "steam";
                      }
                      {
                        kind = "identifier";
                        value = "override";
                      }
                    ];
                    type = "variable";
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
                  value = "zenPrivateHomePackage";
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
    }
  ];
  target = [
    "com"
    "valvesoftware"
    "Steam"
  ];
}
