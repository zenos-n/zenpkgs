{ ... }:
{
  dependenciesDeclared = false;
  descriptorVersion = "zenlang.semantic/2";
  grammarVersion = "1.0.0Na";
  id = "pkgs.ai.opencode.opencode";
  imports = [ ];
  irVersion = "1.0.0Na";
  kind = "zpkg";
  location = "/nix/store/59qqzf108ga8h2qmsjizzsn2p7i889xx-zenpkgs-dsl-source/pkgs/apps/ai/opencode.zpkg:15:9";
  metadata = {
    description = {
      multiline = true;
      parts = [
        {
          type = "text";
          value = "\n    AI coding agent built for the terminal.\n  ";
        }
      ];
      type = "string";
    };
    id = {
      multiline = false;
      parts = [
        {
          type = "text";
          value = "ai.opencode.opencode";
        }
      ];
      type = "string";
    };
    license = {
      name = "l";
      path = [
        {
          kind = "identifier";
          value = "mit";
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
          value = "OpenCode";
        }
      ];
      type = "string";
    };
    packageVersion = {
      multiline = false;
      parts = [
        {
          type = "text";
          value = "1.18.3";
        }
      ];
      type = "string";
    };
    summary = {
      multiline = false;
      parts = [
        {
          type = "text";
          value = "AI coding agent built for the terminal";
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
              value = "ai";
            }
          ];
          type = "string";
        }
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
              value = "coding";
            }
          ];
          type = "string";
        }
        {
          multiline = false;
          parts = [
            {
              type = "text";
              value = "terminal";
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
  name = "opencode";
  provider = {
    expression = {
      arguments = [
        {
          recursive = false;
          statements = [ ];
          type = "attr-set";
        }
      ];
      callee = {
        arguments = [
          {
            type = "group";
            value = {
              left = {
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
                              value = "owner";
                            }
                          ];
                          type = "assignment";
                          value = {
                            multiline = false;
                            parts = [
                              {
                                type = "text";
                                value = "NixOS";
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
                                value = "nixpkgs";
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
                                value = "7812a64698104d7f86d762307097e5e0329b1e44";
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
                                value = "sha256-tZbCWkqDMTLJUXvUbImiQqukFDPl+giC9OMlQFLp+Bk=";
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
              };
              operator = "+";
              right = {
                multiline = false;
                parts = [
                  {
                    type = "text";
                    value = "/pkgs/by-name/op/opencode/package.nix";
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
                  value = "ai.opencode.opencode";
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
                  value = "OpenCode";
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
                  value = "AI coding agent built for the terminal";
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
                  value = "\n    AI coding agent built for the terminal.\n  ";
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
                  value = "1.18.3";
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
                      value = "ai";
                    }
                  ];
                  type = "string";
                }
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
                      value = "coding";
                    }
                  ];
                  type = "string";
                }
                {
                  multiline = false;
                  parts = [
                    {
                      type = "text";
                      value = "terminal";
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
                  value = "mit";
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
            statements = [ ];
            type = "attr-set";
          }
        ];
        callee = {
          arguments = [
            {
              type = "group";
              value = {
                left = {
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
                                value = "owner";
                              }
                            ];
                            type = "assignment";
                            value = {
                              multiline = false;
                              parts = [
                                {
                                  type = "text";
                                  value = "NixOS";
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
                                  value = "nixpkgs";
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
                                  value = "7812a64698104d7f86d762307097e5e0329b1e44";
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
                                  value = "sha256-tZbCWkqDMTLJUXvUbImiQqukFDPl+giC9OMlQFLp+Bk=";
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
                };
                operator = "+";
                right = {
                  multiline = false;
                  parts = [
                    {
                      type = "text";
                      value = "/pkgs/by-name/op/opencode/package.nix";
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
    "ai"
    "opencode"
    "opencode"
  ];
}
