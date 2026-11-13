{ ... }:
{
  dependenciesDeclared = false;
  descriptorVersion = "zenlang.semantic/2";
  grammarVersion = "1.0.0Na";
  id = "pkgs.com.neg-zero.zenos-vr-tools";
  imports = [ ];
  irVersion = "1.0.0Na";
  kind = "zpkg";
  location = "/nix/store/3ni594f60hm22hcrazxd35dmk7pwi61m-zenpkgs-dsl-source/pkgs/apps/gaming/zenos-vr-tools.zpkg:12:9";
  metadata = {
    description = {
      multiline = true;
      parts = [
        {
          type = "text";
          value = "ZenOS VR launcher, manager and overlay supervisor. Optional migration package; installation does not activate a service.";
        }
      ];
      type = "string";
    };
    id = {
      multiline = false;
      parts = [
        {
          type = "text";
          value = "com.neg-zero.zenos-vr-tools";
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
          value = "zenos-vr-tools";
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
          value = "ZenOS VR launcher, manager and overlay supervisor";
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
              value = "vr";
            }
          ];
          type = "string";
        }
        {
          multiline = false;
          parts = [
            {
              type = "text";
              value = "steamvr";
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
  name = "zenos-vr-tools";
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
                  value = "pkgs";
                }
              ];
              type = "assignment";
              value = {
                name = "pkgs";
                path = [
                  {
                    kind = "identifier";
                    value = "legacy";
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
                  value = "alvr";
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
                    value = "gaming";
                  }
                  {
                    kind = "identifier";
                    value = "alvr-zenos-compat";
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
                  value = "fnuidesktop-vr";
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
                    value = "gaming";
                  }
                  {
                    kind = "identifier";
                    value = "fnuidesktop-vr";
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
                  value = "ovr-advanced-settings";
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
                    value = "gaming";
                  }
                  {
                    kind = "identifier";
                    value = "ovr-advanced-settings";
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
                  value = "wlx-overlay-s";
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
                    value = "gaming";
                  }
                  {
                    kind = "identifier";
                    value = "wlx-overlay-s";
                  }
                ];
                type = "variable";
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
                    value = "vrTools";
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
                  value = "com.neg-zero.zenos-vr-tools";
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
                  value = "zenos-vr-tools";
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
                  value = "ZenOS VR launcher, manager and overlay supervisor";
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
                  value = "ZenOS VR launcher, manager and overlay supervisor. Optional migration package; installation does not activate a service.";
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
                      value = "vr";
                    }
                  ];
                  type = "string";
                }
                {
                  multiline = false;
                  parts = [
                    {
                      type = "text";
                      value = "steamvr";
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
                    value = "pkgs";
                  }
                ];
                type = "assignment";
                value = {
                  name = "pkgs";
                  path = [
                    {
                      kind = "identifier";
                      value = "legacy";
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
                    value = "alvr";
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
                      value = "gaming";
                    }
                    {
                      kind = "identifier";
                      value = "alvr-zenos-compat";
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
                    value = "fnuidesktop-vr";
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
                      value = "gaming";
                    }
                    {
                      kind = "identifier";
                      value = "fnuidesktop-vr";
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
                    value = "ovr-advanced-settings";
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
                      value = "gaming";
                    }
                    {
                      kind = "identifier";
                      value = "ovr-advanced-settings";
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
                    value = "wlx-overlay-s";
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
                      value = "gaming";
                    }
                    {
                      kind = "identifier";
                      value = "wlx-overlay-s";
                    }
                  ];
                  type = "variable";
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
                      value = "vrTools";
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
    "zenos-vr-tools"
  ];
}
