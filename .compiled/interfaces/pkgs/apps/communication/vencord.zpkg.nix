{ ... }:
{
  dependenciesDeclared = false;
  descriptorVersion = "zenlang.semantic/2";
  grammarVersion = "1.0.0Na";
  id = "pkgs.unknown.vencord";
  imports = [ ];
  irVersion = "1.0.0Na";
  kind = "zpkg";
  location = "/nix/store/3ni594f60hm22hcrazxd35dmk7pwi61m-zenpkgs-dsl-source/pkgs/apps/communication/vencord.zpkg:16:9";
  metadata = {
    description = {
      multiline = true;
      parts = [
        {
          type = "text";
          value = "\n    Vencord with upstream fixes for Discord's updated Rspack module exports\n    and module lookup. Use this package for Nixcord's discord.vencord.package.\n  ";
        }
      ];
      type = "string";
    };
    id = {
      multiline = false;
      parts = [
        {
          type = "text";
          value = "unknown.vencord";
        }
      ];
      type = "string";
    };
    license = {
      name = "l";
      path = [
        {
          kind = "identifier";
          value = "gpl3Only";
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
          value = "Vencord";
        }
      ];
      type = "string";
    };
    packageVersion = {
      multiline = false;
      parts = [
        {
          type = "text";
          value = "1.15.3";
        }
      ];
      type = "string";
    };
    summary = {
      multiline = false;
      parts = [
        {
          type = "text";
          value = "Discord client modification with current bundler compatibility";
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
              value = "communication";
            }
          ];
          type = "string";
        }
        {
          multiline = false;
          parts = [
            {
              type = "text";
              value = "discord";
            }
          ];
          type = "string";
        }
        {
          multiline = false;
          parts = [
            {
              type = "text";
              value = "vencord";
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
  name = "vencord";
  provider = {
    expression = {
      arguments = [
        {
          type = "group";
          value = {
            body = {
              recursive = false;
              statements = [
                {
                  operator = "=";
                  target = [
                    {
                      kind = "identifier";
                      value = "patches";
                    }
                  ];
                  type = "assignment";
                  value = {
                    left = {
                      type = "group";
                      value = {
                        default = {
                          items = [ ];
                          type = "list";
                        };
                        type = "default";
                        value = {
                          path = [
                            {
                              kind = "identifier";
                              value = "previous";
                            }
                            {
                              kind = "identifier";
                              value = "patches";
                            }
                          ];
                          type = "reference";
                        };
                      };
                    };
                    operator = "++";
                    right = {
                      items = [
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
                                        value = "url";
                                      }
                                    ];
                                    type = "assignment";
                                    value = {
                                      multiline = false;
                                      parts = [
                                        {
                                          type = "text";
                                          value = "https://github.com/Vendicated/Vencord/commit/ba8453ebac146b241b18409640b0548f37b9064e.patch";
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
                                          value = "sha256-G22LQCvObBPGo2flNaOBa5bRiEn/I8CHj1NB1BF9q7o=";
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
                                  value = "fetchurl";
                                }
                              ];
                              type = "variable";
                            };
                            type = "call";
                          };
                        }
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
                                        value = "url";
                                      }
                                    ];
                                    type = "assignment";
                                    value = {
                                      multiline = false;
                                      parts = [
                                        {
                                          type = "text";
                                          value = "https://github.com/Vendicated/Vencord/commit/a764679e9f988903560f408d6615c709d71281ce.patch";
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
                                          value = "sha256-WH/7b1tYvX4xcUsrXtQD7Hkae80DcF+KP+SZoMO8kUQ=";
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
                                  value = "fetchurl";
                                }
                              ];
                              type = "variable";
                            };
                            type = "call";
                          };
                        }
                      ];
                      type = "list";
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
                name = "previous";
                variadic = false;
              }
            ];
            type = "lambda";
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
            value = "vencord";
          }
          {
            kind = "identifier";
            value = "overrideAttrs";
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
                  value = "unknown.vencord";
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
                  value = "Vencord";
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
                  value = "Discord client modification with current bundler compatibility";
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
                  value = "\n    Vencord with upstream fixes for Discord's updated Rspack module exports\n    and module lookup. Use this package for Nixcord's discord.vencord.package.\n  ";
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
                  value = "1.15.3";
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
                      value = "communication";
                    }
                  ];
                  type = "string";
                }
                {
                  multiline = false;
                  parts = [
                    {
                      type = "text";
                      value = "discord";
                    }
                  ];
                  type = "string";
                }
                {
                  multiline = false;
                  parts = [
                    {
                      type = "text";
                      value = "vencord";
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
                  value = "gpl3Only";
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
            type = "group";
            value = {
              body = {
                recursive = false;
                statements = [
                  {
                    operator = "=";
                    target = [
                      {
                        kind = "identifier";
                        value = "patches";
                      }
                    ];
                    type = "assignment";
                    value = {
                      left = {
                        type = "group";
                        value = {
                          default = {
                            items = [ ];
                            type = "list";
                          };
                          type = "default";
                          value = {
                            path = [
                              {
                                kind = "identifier";
                                value = "previous";
                              }
                              {
                                kind = "identifier";
                                value = "patches";
                              }
                            ];
                            type = "reference";
                          };
                        };
                      };
                      operator = "++";
                      right = {
                        items = [
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
                                          value = "url";
                                        }
                                      ];
                                      type = "assignment";
                                      value = {
                                        multiline = false;
                                        parts = [
                                          {
                                            type = "text";
                                            value = "https://github.com/Vendicated/Vencord/commit/ba8453ebac146b241b18409640b0548f37b9064e.patch";
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
                                            value = "sha256-G22LQCvObBPGo2flNaOBa5bRiEn/I8CHj1NB1BF9q7o=";
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
                                    value = "fetchurl";
                                  }
                                ];
                                type = "variable";
                              };
                              type = "call";
                            };
                          }
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
                                          value = "url";
                                        }
                                      ];
                                      type = "assignment";
                                      value = {
                                        multiline = false;
                                        parts = [
                                          {
                                            type = "text";
                                            value = "https://github.com/Vendicated/Vencord/commit/a764679e9f988903560f408d6615c709d71281ce.patch";
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
                                            value = "sha256-WH/7b1tYvX4xcUsrXtQD7Hkae80DcF+KP+SZoMO8kUQ=";
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
                                    value = "fetchurl";
                                  }
                                ];
                                type = "variable";
                              };
                              type = "call";
                            };
                          }
                        ];
                        type = "list";
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
                  name = "previous";
                  variadic = false;
                }
              ];
              type = "lambda";
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
              value = "vencord";
            }
            {
              kind = "identifier";
              value = "overrideAttrs";
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
    "vencord"
  ];
}
