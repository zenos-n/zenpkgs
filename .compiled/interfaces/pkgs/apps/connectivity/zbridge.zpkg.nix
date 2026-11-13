{ ... }:
{
  dependenciesDeclared = false;
  descriptorVersion = "zenlang.semantic/2";
  grammarVersion = "1.0.0Na";
  id = "pkgs.com.neg-zero.zbridge";
  imports = [ ];
  irVersion = "1.0.0Na";
  kind = "zpkg";
  location = "/nix/store/3ni594f60hm22hcrazxd35dmk7pwi61m-zenpkgs-dsl-source/pkgs/apps/connectivity/zbridge.zpkg:13:9";
  metadata = {
    description = {
      multiline = true;
      parts = [
        {
          type = "text";
          value = "Android and Linux audio/video bridge with a GNOME control extension. Optional migration package; installation does not activate a service.";
        }
      ];
      type = "string";
    };
    id = {
      multiline = false;
      parts = [
        {
          type = "text";
          value = "com.neg-zero.zbridge";
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
          value = "ZeroBridge";
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
          value = "Android and Linux audio/video bridge with a GNOME control extension";
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
              value = "android";
            }
          ];
          type = "string";
        }
        {
          multiline = false;
          parts = [
            {
              type = "text";
              value = "pipewire";
            }
          ];
          type = "string";
        }
        {
          multiline = false;
          parts = [
            {
              type = "text";
              value = "camera";
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
  name = "zbridge";
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
                    value = "name";
                  }
                ];
                type = "assignment";
                value = {
                  multiline = false;
                  parts = [
                    {
                      type = "text";
                      value = "zbridge-1.0.0";
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
                      path = [
                        {
                          kind = "identifier";
                          value = "core";
                        }
                      ];
                      type = "reference";
                    }
                    {
                      path = [
                        {
                          kind = "identifier";
                          value = "extension";
                        }
                      ];
                      type = "reference";
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
                            value = "Android-Linux audio/video bridge";
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
                            value = "mit";
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
                            value = "zb-daemon";
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
              value = "buildEnv";
            }
          ];
          type = "variable";
        };
        type = "call";
      };
      statements = [
        {
          operator = "=";
          target = [
            {
              kind = "identifier";
              value = "source";
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
                          value = "zerobridge";
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
                          value = "a2ca3c681258d56706e75b2fbea31907caf9081f";
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
                          value = "sha256-tYlxxAfXLlXgL206a9ivYiLnVn+EnV4JrhRTCMLVKNU=";
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
              value = "core";
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
                        value = "gstreamer";
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
                          value = "gst_all_1";
                        }
                        {
                          kind = "identifier";
                          value = "gstreamer";
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
                        value = "gst-plugins-base";
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
                          value = "gst_all_1";
                        }
                        {
                          kind = "identifier";
                          value = "gst-plugins-base";
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
                        value = "gst-plugins-good";
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
                          value = "gst_all_1";
                        }
                        {
                          kind = "identifier";
                          value = "gst-plugins-good";
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
                        value = "gst-plugins-bad";
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
                          value = "gst_all_1";
                        }
                        {
                          kind = "identifier";
                          value = "gst-plugins-bad";
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
                        value = "gst-plugins-ugly";
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
                          value = "gst_all_1";
                        }
                        {
                          kind = "identifier";
                          value = "gst-plugins-ugly";
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
                      path = [
                        {
                          kind = "identifier";
                          value = "source";
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
                          value = "/nix/backend.nix";
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
        {
          operator = "=";
          target = [
            {
              kind = "identifier";
              value = "extension";
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
                      path = [
                        {
                          kind = "identifier";
                          value = "source";
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
                          value = "/nix/extension.nix";
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
                  value = "com.neg-zero.zbridge";
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
                  value = "ZeroBridge";
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
                  value = "Android and Linux audio/video bridge with a GNOME control extension";
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
                  value = "Android and Linux audio/video bridge with a GNOME control extension. Optional migration package; installation does not activate a service.";
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
                      value = "android";
                    }
                  ];
                  type = "string";
                }
                {
                  multiline = false;
                  parts = [
                    {
                      type = "text";
                      value = "pipewire";
                    }
                  ];
                  type = "string";
                }
                {
                  multiline = false;
                  parts = [
                    {
                      type = "text";
                      value = "camera";
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
                    multiline = false;
                    parts = [
                      {
                        type = "text";
                        value = "zbridge-1.0.0";
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
                        path = [
                          {
                            kind = "identifier";
                            value = "core";
                          }
                        ];
                        type = "reference";
                      }
                      {
                        path = [
                          {
                            kind = "identifier";
                            value = "extension";
                          }
                        ];
                        type = "reference";
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
                              value = "Android-Linux audio/video bridge";
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
                              value = "mit";
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
                              value = "zb-daemon";
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
                value = "buildEnv";
              }
            ];
            type = "variable";
          };
          type = "call";
        };
        statements = [
          {
            operator = "=";
            target = [
              {
                kind = "identifier";
                value = "source";
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
                            value = "zerobridge";
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
                            value = "a2ca3c681258d56706e75b2fbea31907caf9081f";
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
                            value = "sha256-tYlxxAfXLlXgL206a9ivYiLnVn+EnV4JrhRTCMLVKNU=";
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
                value = "core";
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
                          value = "gstreamer";
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
                            value = "gst_all_1";
                          }
                          {
                            kind = "identifier";
                            value = "gstreamer";
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
                          value = "gst-plugins-base";
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
                            value = "gst_all_1";
                          }
                          {
                            kind = "identifier";
                            value = "gst-plugins-base";
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
                          value = "gst-plugins-good";
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
                            value = "gst_all_1";
                          }
                          {
                            kind = "identifier";
                            value = "gst-plugins-good";
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
                          value = "gst-plugins-bad";
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
                            value = "gst_all_1";
                          }
                          {
                            kind = "identifier";
                            value = "gst-plugins-bad";
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
                          value = "gst-plugins-ugly";
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
                            value = "gst_all_1";
                          }
                          {
                            kind = "identifier";
                            value = "gst-plugins-ugly";
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
                        path = [
                          {
                            kind = "identifier";
                            value = "source";
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
                            value = "/nix/backend.nix";
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
          {
            operator = "=";
            target = [
              {
                kind = "identifier";
                value = "extension";
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
                        path = [
                          {
                            kind = "identifier";
                            value = "source";
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
                            value = "/nix/extension.nix";
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
        type = "let";
      };
    }
  ];
  target = [
    "com"
    "neg-zero"
    "zbridge"
  ];
}
