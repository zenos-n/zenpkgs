{ ... }:
{
  dependenciesDeclared = false;
  descriptorVersion = "zenlang.semantic/2";
  grammarVersion = "1.0.0Na";
  id = "pkgs.unknown.ovr-advanced-settings";
  imports = [ ];
  irVersion = "1.0.0Na";
  kind = "zpkg";
  location = "/nix/store/59qqzf108ga8h2qmsjizzsn2p7i889xx-zenpkgs-dsl-source/pkgs/apps/gaming/ovr-advanced-settings.zpkg:13:9";
  metadata = {
    description = {
      multiline = true;
      parts = [
        {
          type = "text";
          value = "SteamVR overlay for playspace and runtime controls. Optional migration package; installation does not activate a service.";
        }
      ];
      type = "string";
    };
    id = {
      multiline = false;
      parts = [
        {
          type = "text";
          value = "unknown.ovr-advanced-settings";
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
          value = "OVR Advanced Settings";
        }
      ];
      type = "string";
    };
    packageVersion = {
      multiline = false;
      parts = [
        {
          type = "text";
          value = "5.8.11";
        }
      ];
      type = "string";
    };
    summary = {
      multiline = false;
      parts = [
        {
          type = "text";
          value = "SteamVR overlay for playspace and runtime controls";
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
              value = "overlay";
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
  name = "ovr-advanced-settings";
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
                    value = "ovr-advanced-settings";
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
                    value = "5.8.11";
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
                              value = "https://github.com/OpenVR-Advanced-Settings/OpenVR-AdvancedSettings/releases/download/v5.8.11/OpenVR_Advanced_Settings-72e91e9-x86_64.AppImage";
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
                              value = "sha256-ql6wCqFySjWe/hoRPpik7uNVmN9Rc0ZcRhAZDuscQqU=";
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
              operator = "=";
              target = [
                {
                  kind = "identifier";
                  value = "extraPkgs";
                }
              ];
              type = "assignment";
              value = {
                body = {
                  items = [
                    {
                      path = [
                        {
                          kind = "identifier";
                          value = "p";
                        }
                        {
                          kind = "identifier";
                          value = "libGL";
                        }
                      ];
                      type = "reference";
                    }
                    {
                      path = [
                        {
                          kind = "identifier";
                          value = "p";
                        }
                        {
                          kind = "identifier";
                          value = "udev";
                        }
                      ];
                      type = "reference";
                    }
                    {
                      path = [
                        {
                          kind = "identifier";
                          value = "p";
                        }
                        {
                          kind = "identifier";
                          value = "libxrandr";
                        }
                      ];
                      type = "reference";
                    }
                  ];
                  type = "list";
                };
                form = "identifier";
                parameters = [
                  {
                    default = null;
                    name = "p";
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
                          value = "SteamVR overlay for playspace and runtime controls";
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
                        value = "homepage";
                      }
                    ];
                    type = "assignment";
                    value = {
                      multiline = false;
                      parts = [
                        {
                          type = "text";
                          value = "https://github.com/OpenVR-Advanced-Settings/OpenVR-AdvancedSettings";
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
                        value = "license";
                      }
                    ];
                    type = "assignment";
                    value = {
                      name = "lib";
                      path = [
                        {
                          kind = "identifier";
                          value = "licenses";
                        }
                        {
                          kind = "identifier";
                          value = "gpl3Only";
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
                      items = [
                        {
                          multiline = false;
                          parts = [
                            {
                              type = "text";
                              value = "x86_64-linux";
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
                        value = "mainProgram";
                      }
                    ];
                    type = "assignment";
                    value = {
                      multiline = false;
                      parts = [
                        {
                          type = "text";
                          value = "ovr-advanced-settings";
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
        name = "pkgs";
        path = [
          {
            kind = "identifier";
            value = "legacy";
          }
          {
            kind = "identifier";
            value = "appimageTools";
          }
          {
            kind = "identifier";
            value = "wrapType2";
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
                  value = "unknown.ovr-advanced-settings";
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
                  value = "OVR Advanced Settings";
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
                  value = "SteamVR overlay for playspace and runtime controls";
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
                  value = "SteamVR overlay for playspace and runtime controls. Optional migration package; installation does not activate a service.";
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
                  value = "5.8.11";
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
                      value = "overlay";
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
                      value = "ovr-advanced-settings";
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
                      value = "5.8.11";
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
                                value = "https://github.com/OpenVR-Advanced-Settings/OpenVR-AdvancedSettings/releases/download/v5.8.11/OpenVR_Advanced_Settings-72e91e9-x86_64.AppImage";
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
                                value = "sha256-ql6wCqFySjWe/hoRPpik7uNVmN9Rc0ZcRhAZDuscQqU=";
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
                operator = "=";
                target = [
                  {
                    kind = "identifier";
                    value = "extraPkgs";
                  }
                ];
                type = "assignment";
                value = {
                  body = {
                    items = [
                      {
                        path = [
                          {
                            kind = "identifier";
                            value = "p";
                          }
                          {
                            kind = "identifier";
                            value = "libGL";
                          }
                        ];
                        type = "reference";
                      }
                      {
                        path = [
                          {
                            kind = "identifier";
                            value = "p";
                          }
                          {
                            kind = "identifier";
                            value = "udev";
                          }
                        ];
                        type = "reference";
                      }
                      {
                        path = [
                          {
                            kind = "identifier";
                            value = "p";
                          }
                          {
                            kind = "identifier";
                            value = "libxrandr";
                          }
                        ];
                        type = "reference";
                      }
                    ];
                    type = "list";
                  };
                  form = "identifier";
                  parameters = [
                    {
                      default = null;
                      name = "p";
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
                            value = "SteamVR overlay for playspace and runtime controls";
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
                          value = "homepage";
                        }
                      ];
                      type = "assignment";
                      value = {
                        multiline = false;
                        parts = [
                          {
                            type = "text";
                            value = "https://github.com/OpenVR-Advanced-Settings/OpenVR-AdvancedSettings";
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
                          value = "license";
                        }
                      ];
                      type = "assignment";
                      value = {
                        name = "lib";
                        path = [
                          {
                            kind = "identifier";
                            value = "licenses";
                          }
                          {
                            kind = "identifier";
                            value = "gpl3Only";
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
                        items = [
                          {
                            multiline = false;
                            parts = [
                              {
                                type = "text";
                                value = "x86_64-linux";
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
                          value = "mainProgram";
                        }
                      ];
                      type = "assignment";
                      value = {
                        multiline = false;
                        parts = [
                          {
                            type = "text";
                            value = "ovr-advanced-settings";
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
          name = "pkgs";
          path = [
            {
              kind = "identifier";
              value = "legacy";
            }
            {
              kind = "identifier";
              value = "appimageTools";
            }
            {
              kind = "identifier";
              value = "wrapType2";
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
    "ovr-advanced-settings"
  ];
}
