{ ... }:
{
  dependenciesDeclared = false;
  descriptorVersion = "zenlang.semantic/2";
  grammarVersion = "1.0.0Na";
  id = "pkgs.com.neg-zero.popcorn";
  imports = [ ];
  irVersion = "1.0.0Na";
  kind = "zpkg";
  location = "/nix/store/59qqzf108ga8h2qmsjizzsn2p7i889xx-zenpkgs-dsl-source/pkgs/system/kernel/popcorn.zpkg:8:9";
  metadata = {
    description = {
      multiline = true;
      parts = [
        {
          type = "text";
          value = "Pinned Popcorn generic kernel for migration. Select explicitly through system.kernel.package; this package never changes the default kernel.";
        }
      ];
      type = "string";
    };
    id = {
      multiline = false;
      parts = [
        {
          type = "text";
          value = "com.neg-zero.popcorn";
        }
      ];
      type = "string";
    };
    license = {
      name = "l";
      path = [
        {
          kind = "identifier";
          value = "gpl2Only";
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
          value = "popcorn kernel";
        }
      ];
      type = "string";
    };
    packageVersion = {
      multiline = false;
      parts = [
        {
          type = "text";
          value = "7.0.2";
        }
      ];
      type = "string";
    };
    summary = {
      multiline = false;
      parts = [
        {
          type = "text";
          value = "Optional Popcorn 7.0.2 kernel";
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
              value = "kernel";
            }
          ];
          type = "string";
        }
        {
          multiline = false;
          parts = [
            {
              type = "text";
              value = "migration";
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
  name = "popcorn";
  provider = {
    expression = {
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
                    value = "pkgs";
                  }
                ];
                type = "assignment";
                value = {
                  path = [
                    {
                      kind = "identifier";
                      value = "oldPackageSet";
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
                    value = "gitHash";
                  }
                ];
                type = "assignment";
                value = {
                  multiline = false;
                  parts = [
                    {
                      type = "text";
                      value = "5a05a45";
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
                    value = "isRelease";
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
                      value = "recipeSource";
                    }
                  ];
                  type = "reference";
                };
                operator = "+";
                right = {
                  multiline = false;
                  parts = [
                    {
                      type = "text";
                      value = "/scripts/D/generic.nix";
                    }
                  ];
                  type = "string";
                };
                type = "binary";
              };
            }
          ];
          callee = {
            arguments = [
              {
                recursive = false;
                statements = [ ];
                type = "attr-set";
              }
            ];
            callee = {
              name = "lib";
              path = [
                {
                  kind = "identifier";
                  value = "callPackageWith";
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
      statements = [
        {
          operator = "=";
          target = [
            {
              kind = "identifier";
              value = "recipeSource";
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
                        value = "owner";
                      }
                    ];
                    type = "assignment";
                    value = {
                      multiline = false;
                      parts = [
                        {
                          type = "text";
                          value = "doromiert";
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
                        value = "repo";
                      }
                    ];
                    type = "assignment";
                    value = {
                      multiline = false;
                      parts = [
                        {
                          type = "text";
                          value = "popcorn-m";
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
                        value = "rev";
                      }
                    ];
                    type = "assignment";
                    value = {
                      multiline = false;
                      parts = [
                        {
                          type = "text";
                          value = "5a05a4520d19d1b2cf616f2516b889df1d50d0dd";
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
                        value = "hash";
                      }
                    ];
                    type = "assignment";
                    value = {
                      multiline = false;
                      parts = [
                        {
                          type = "text";
                          value = "sha256-4ZUPUKzqCl1uQntQjhesI1Lh+ox+3EeYrOIyhNB9+sk=";
                        }
                      ];
                      type = "string";
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
                  value = "fetchFromGitHub";
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
              value = "oldPackageSet";
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
                        value = "system";
                      }
                    ];
                    type = "assignment";
                    value = {
                      multiline = false;
                      parts = [
                        {
                          type = "text";
                          value = "x86_64-linux";
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
                        value = "config";
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
                        value = "overlays";
                      }
                    ];
                    type = "assignment";
                    value = {
                      items = [ ];
                      type = "list";
                    };
                  }
                ];
                type = "attr-set";
              }
            ];
            callee = {
              arguments = [
                {
                  name = "lib";
                  path = [
                    {
                      kind = "identifier";
                      value = "zenPackageSources";
                    }
                    {
                      kind = "identifier";
                      value = "popcornNixpkgs";
                    }
                  ];
                  type = "variable";
                }
              ];
              callee = {
                arguments = [
                  {
                    recursive = false;
                    statements = [ ];
                    type = "attr-set";
                  }
                ];
                callee = {
                  name = "lib";
                  path = [
                    {
                      kind = "identifier";
                      value = "callPackageWith";
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
      type = "let";
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
                  value = "com.neg-zero.popcorn";
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
                  value = "popcorn kernel";
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
                  value = "Optional Popcorn 7.0.2 kernel";
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
                  value = "Pinned Popcorn generic kernel for migration. Select explicitly through system.kernel.package; this package never changes the default kernel.";
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
              parts = [
                {
                  type = "text";
                  value = "7.0.2";
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
                      value = "kernel";
                    }
                  ];
                  type = "string";
                }
                {
                  multiline = false;
                  parts = [
                    {
                      type = "text";
                      value = "migration";
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
                  value = "gpl2Only";
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
                      value = "pkgs";
                    }
                  ];
                  type = "assignment";
                  value = {
                    path = [
                      {
                        kind = "identifier";
                        value = "oldPackageSet";
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
                      value = "gitHash";
                    }
                  ];
                  type = "assignment";
                  value = {
                    multiline = false;
                    parts = [
                      {
                        type = "text";
                        value = "5a05a45";
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
                      value = "isRelease";
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
                        value = "recipeSource";
                      }
                    ];
                    type = "reference";
                  };
                  operator = "+";
                  right = {
                    multiline = false;
                    parts = [
                      {
                        type = "text";
                        value = "/scripts/D/generic.nix";
                      }
                    ];
                    type = "string";
                  };
                  type = "binary";
                };
              }
            ];
            callee = {
              arguments = [
                {
                  recursive = false;
                  statements = [ ];
                  type = "attr-set";
                }
              ];
              callee = {
                name = "lib";
                path = [
                  {
                    kind = "identifier";
                    value = "callPackageWith";
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
        statements = [
          {
            operator = "=";
            target = [
              {
                kind = "identifier";
                value = "recipeSource";
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
                          value = "owner";
                        }
                      ];
                      type = "assignment";
                      value = {
                        multiline = false;
                        parts = [
                          {
                            type = "text";
                            value = "doromiert";
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
                          value = "repo";
                        }
                      ];
                      type = "assignment";
                      value = {
                        multiline = false;
                        parts = [
                          {
                            type = "text";
                            value = "popcorn-m";
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
                          value = "rev";
                        }
                      ];
                      type = "assignment";
                      value = {
                        multiline = false;
                        parts = [
                          {
                            type = "text";
                            value = "5a05a4520d19d1b2cf616f2516b889df1d50d0dd";
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
                          value = "hash";
                        }
                      ];
                      type = "assignment";
                      value = {
                        multiline = false;
                        parts = [
                          {
                            type = "text";
                            value = "sha256-4ZUPUKzqCl1uQntQjhesI1Lh+ox+3EeYrOIyhNB9+sk=";
                          }
                        ];
                        type = "string";
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
                    value = "fetchFromGitHub";
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
                value = "oldPackageSet";
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
                          value = "system";
                        }
                      ];
                      type = "assignment";
                      value = {
                        multiline = false;
                        parts = [
                          {
                            type = "text";
                            value = "x86_64-linux";
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
                          value = "config";
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
                          value = "overlays";
                        }
                      ];
                      type = "assignment";
                      value = {
                        items = [ ];
                        type = "list";
                      };
                    }
                  ];
                  type = "attr-set";
                }
              ];
              callee = {
                arguments = [
                  {
                    name = "lib";
                    path = [
                      {
                        kind = "identifier";
                        value = "zenPackageSources";
                      }
                      {
                        kind = "identifier";
                        value = "popcornNixpkgs";
                      }
                    ];
                    type = "variable";
                  }
                ];
                callee = {
                  arguments = [
                    {
                      recursive = false;
                      statements = [ ];
                      type = "attr-set";
                    }
                  ];
                  callee = {
                    name = "lib";
                    path = [
                      {
                        kind = "identifier";
                        value = "callPackageWith";
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
        type = "let";
      };
    }
  ];
  target = [
    "com"
    "neg-zero"
    "popcorn"
  ];
}
