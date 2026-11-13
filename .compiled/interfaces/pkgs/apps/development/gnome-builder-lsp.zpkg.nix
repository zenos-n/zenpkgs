{ ... }:
{
  dependenciesDeclared = false;
  descriptorVersion = "zenlang.semantic/2";
  grammarVersion = "1.0.0Na";
  id = "pkgs.unknown.gnome-builder-lsp";
  imports = [ ];
  irVersion = "1.0.0Na";
  kind = "zpkg";
  location = "/nix/store/3ni594f60hm22hcrazxd35dmk7pwi61m-zenpkgs-dsl-source/pkgs/apps/development/gnome-builder-lsp.zpkg:9:9";
  metadata = {
    description = {
      multiline = true;
      parts = [
        {
          type = "text";
          value = "GNOME Builder with the language servers from the migration reference available in its executable search path. Optional development variant.";
        }
      ];
      type = "string";
    };
    id = {
      multiline = false;
      parts = [
        {
          type = "text";
          value = "unknown.gnome-builder-lsp";
        }
      ];
      type = "string";
    };
    license = {
      name = "l";
      path = [
        {
          kind = "identifier";
          value = "gpl3Plus";
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
          value = "GNOME Builder with language servers";
        }
      ];
      type = "string";
    };
    packageVersion = {
      multiline = false;
      parts = [
        {
          type = "text";
          value = "50.0";
        }
      ];
      type = "string";
    };
    summary = {
      multiline = false;
      parts = [
        {
          type = "text";
          value = "GNOME Builder with Python, Rust, C and TypeScript tooling";
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
              value = "development";
            }
          ];
          type = "string";
        }
        {
          multiline = false;
          parts = [
            {
              type = "text";
              value = "gnome";
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
  name = "gnome-builder-lsp";
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
                  value = "name";
                }
              ];
              type = "assignment";
              value = {
                multiline = false;
                parts = [
                  {
                    type = "text";
                    value = "gnome-builder-lsp-";
                  }
                  {
                    expression = {
                      name = "pkgs";
                      path = [
                        {
                          kind = "identifier";
                          value = "legacy";
                        }
                        {
                          kind = "identifier";
                          value = "gnome-builder";
                        }
                        {
                          kind = "identifier";
                          value = "version";
                        }
                      ];
                      type = "variable";
                    };
                    type = "interpolation";
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
                  value = "paths";
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
                        value = "legacy";
                      }
                      {
                        kind = "identifier";
                        value = "gnome-builder";
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
                  value = "nativeBuildInputs";
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
                        value = "legacy";
                      }
                      {
                        kind = "identifier";
                        value = "makeWrapper";
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
                  value = "postBuild";
                }
              ];
              type = "assignment";
              value = {
                multiline = true;
                parts = [
                  {
                    type = "text";
                    value = "\n    wrapProgram \"$out/bin/gnome-builder\" --prefix PATH : ";
                  }
                  {
                    expression = {
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
                                  value = "development";
                                }
                                {
                                  kind = "identifier";
                                  value = "python";
                                }
                                {
                                  kind = "identifier";
                                  value = "python-lsp-server";
                                }
                              ];
                              type = "variable";
                            }
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
                                  value = "development";
                                }
                                {
                                  kind = "identifier";
                                  value = "rust-analyzer";
                                }
                              ];
                              type = "variable";
                            }
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
                                  value = "development";
                                }
                                {
                                  kind = "identifier";
                                  value = "clang-tools";
                                }
                              ];
                              type = "variable";
                            }
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
                                  value = "development";
                                }
                                {
                                  kind = "identifier";
                                  value = "typescript-language-server";
                                }
                              ];
                              type = "variable";
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
                            value = "makeBinPath";
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
                    value = "\n  ";
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
                name = "pkgs";
                path = [
                  {
                    kind = "identifier";
                    value = "legacy";
                  }
                  {
                    kind = "identifier";
                    value = "gnome-builder";
                  }
                  {
                    kind = "identifier";
                    value = "meta";
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
        name = "pkgs";
        path = [
          {
            kind = "identifier";
            value = "legacy";
          }
          {
            kind = "identifier";
            value = "symlinkJoin";
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
                  value = "unknown.gnome-builder-lsp";
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
                  value = "GNOME Builder with language servers";
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
                  value = "GNOME Builder with Python, Rust, C and TypeScript tooling";
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
                  value = "GNOME Builder with the language servers from the migration reference available in its executable search path. Optional development variant.";
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
                  value = "50.0";
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
                      value = "development";
                    }
                  ];
                  type = "string";
                }
                {
                  multiline = false;
                  parts = [
                    {
                      type = "text";
                      value = "gnome";
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
                  value = "gpl3Plus";
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
                    value = "name";
                  }
                ];
                type = "assignment";
                value = {
                  multiline = false;
                  parts = [
                    {
                      type = "text";
                      value = "gnome-builder-lsp-";
                    }
                    {
                      expression = {
                        name = "pkgs";
                        path = [
                          {
                            kind = "identifier";
                            value = "legacy";
                          }
                          {
                            kind = "identifier";
                            value = "gnome-builder";
                          }
                          {
                            kind = "identifier";
                            value = "version";
                          }
                        ];
                        type = "variable";
                      };
                      type = "interpolation";
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
                    value = "paths";
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
                          value = "legacy";
                        }
                        {
                          kind = "identifier";
                          value = "gnome-builder";
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
                    value = "nativeBuildInputs";
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
                          value = "legacy";
                        }
                        {
                          kind = "identifier";
                          value = "makeWrapper";
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
                    value = "postBuild";
                  }
                ];
                type = "assignment";
                value = {
                  multiline = true;
                  parts = [
                    {
                      type = "text";
                      value = "\n    wrapProgram \"$out/bin/gnome-builder\" --prefix PATH : ";
                    }
                    {
                      expression = {
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
                                    value = "development";
                                  }
                                  {
                                    kind = "identifier";
                                    value = "python";
                                  }
                                  {
                                    kind = "identifier";
                                    value = "python-lsp-server";
                                  }
                                ];
                                type = "variable";
                              }
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
                                    value = "development";
                                  }
                                  {
                                    kind = "identifier";
                                    value = "rust-analyzer";
                                  }
                                ];
                                type = "variable";
                              }
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
                                    value = "development";
                                  }
                                  {
                                    kind = "identifier";
                                    value = "clang-tools";
                                  }
                                ];
                                type = "variable";
                              }
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
                                    value = "development";
                                  }
                                  {
                                    kind = "identifier";
                                    value = "typescript-language-server";
                                  }
                                ];
                                type = "variable";
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
                              value = "makeBinPath";
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
                      value = "\n  ";
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
                  name = "pkgs";
                  path = [
                    {
                      kind = "identifier";
                      value = "legacy";
                    }
                    {
                      kind = "identifier";
                      value = "gnome-builder";
                    }
                    {
                      kind = "identifier";
                      value = "meta";
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
          name = "pkgs";
          path = [
            {
              kind = "identifier";
              value = "legacy";
            }
            {
              kind = "identifier";
              value = "symlinkJoin";
            }
          ];
          type = "variable";
        };
        type = "call";
      };
    }
  ];
  target = [
    "unknown"
    "gnome-builder-lsp"
  ];
}
