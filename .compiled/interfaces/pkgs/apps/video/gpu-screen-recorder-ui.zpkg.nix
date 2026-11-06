{ ... }:
{
  dependenciesDeclared = false;
  descriptorVersion = "zenlang.semantic/2";
  grammarVersion = "1.0.0Na";
  id = "pkgs.unknown.gpu-screen-recorder-ui";
  imports = [ ];
  irVersion = "1.0.0Na";
  kind = "zpkg";
  location = "/nix/store/59qqzf108ga8h2qmsjizzsn2p7i889xx-zenpkgs-dsl-source/pkgs/apps/video/gpu-screen-recorder-ui.zpkg:13:9";
  metadata = {
    description = {
      multiline = true;
      parts = [
        {
          type = "text";
          value = "Official GPU Screen Recorder overlay frontend. Uses the external gsr-ui-nix recipe with ZenPkgs dependencies.";
        }
      ];
      type = "string";
    };
    id = {
      multiline = false;
      parts = [
        {
          type = "text";
          value = "unknown.gpu-screen-recorder-ui";
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
          value = "GPU Screen Recorder Overlay";
        }
      ];
      type = "string";
    };
    packageVersion = {
      multiline = false;
      parts = [
        {
          type = "text";
          value = "1.15.0";
        }
      ];
      type = "string";
    };
    summary = {
      multiline = false;
      parts = [
        {
          type = "text";
          value = "ShadowPlay-style recording overlay";
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
              value = "video";
            }
          ];
          type = "string";
        }
        {
          multiline = false;
          parts = [
            {
              type = "text";
              value = "recording";
            }
          ];
          type = "string";
        }
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
  name = "gpu-screen-recorder-ui";
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
                      value = "src";
                    }
                  ];
                  type = "assignment";
                  value = {
                    name = "lib";
                    path = [
                      {
                        kind = "identifier";
                        value = "zenPackageSources";
                      }
                      {
                        kind = "identifier";
                        value = "gsrUi";
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
                      value = "name";
                    }
                  ];
                  type = "assignment";
                  value = {
                    multiline = false;
                    parts = [
                      {
                        type = "text";
                        value = "gpu-screen-recorder-ui-1.15.0";
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
                        value = "1.15.0";
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
                    left = {
                      path = [
                        {
                          kind = "identifier";
                          value = "old";
                        }
                        {
                          kind = "identifier";
                          value = "meta";
                        }
                      ];
                      type = "reference";
                    };
                    operator = "//";
                    right = {
                      recursive = false;
                      statements = [
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
                                value = "gsr-ui";
                              }
                            ];
                            type = "string";
                          };
                        }
                      ];
                      type = "attr-set";
                    };
                    type = "binary";
                  };
                }
                {
                  operator = "=";
                  target = [
                    {
                      kind = "identifier";
                      value = "mesonFlags";
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
                            value = "-Dcapabilities=false";
                          }
                        ];
                        type = "string";
                      }
                    ];
                    type = "list";
                  };
                }
              ];
              type = "attr-set";
            };
            form = "identifier";
            parameters = [
              {
                default = null;
                name = "old";
                variadic = false;
              }
            ];
            type = "lambda";
          };
        }
      ];
      callee = {
        segment = {
          kind = "identifier";
          value = "overrideAttrs";
        };
        type = "selection";
        value = {
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
                        value = "src";
                      }
                    ];
                    type = "assignment";
                    value = {
                      name = "lib";
                      path = [
                        {
                          kind = "identifier";
                          value = "zenPackageSources";
                        }
                        {
                          kind = "identifier";
                          value = "gsrUi";
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
                        value = "libX11";
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
                          value = "libx11";
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
                        value = "libXrandr";
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
                          value = "libxrandr";
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
                        value = "libXrender";
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
                          value = "libxrender";
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
                        value = "libXext";
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
                          value = "libxext";
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
                        value = "libXcomposite";
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
                          value = "libxcomposite";
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
                        value = "libXcursor";
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
                          value = "libxcursor";
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
                        value = "libXfixes";
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
                          value = "libxfixes";
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
                        value = "libXi";
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
                          value = "libxi";
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
                        value = "gpu-screen-recorder";
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
                          value = "video";
                        }
                        {
                          kind = "identifier";
                          value = "gpu-screen-recorder";
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
                        value = "gpu-screen-recorder-notification";
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
                          value = "video";
                        }
                        {
                          kind = "identifier";
                          value = "gpu-screen-recorder-notification";
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
                          value = "gsrPackaging";
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
                          value = "/gpu-screen-recorder-ui.nix";
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
        };
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
                  value = "unknown.gpu-screen-recorder-ui";
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
                  value = "GPU Screen Recorder Overlay";
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
                  value = "ShadowPlay-style recording overlay";
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
                  value = "Official GPU Screen Recorder overlay frontend. Uses the external gsr-ui-nix recipe with ZenPkgs dependencies.";
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
                  value = "1.15.0";
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
                      value = "video";
                    }
                  ];
                  type = "string";
                }
                {
                  multiline = false;
                  parts = [
                    {
                      type = "text";
                      value = "recording";
                    }
                  ];
                  type = "string";
                }
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
                        value = "src";
                      }
                    ];
                    type = "assignment";
                    value = {
                      name = "lib";
                      path = [
                        {
                          kind = "identifier";
                          value = "zenPackageSources";
                        }
                        {
                          kind = "identifier";
                          value = "gsrUi";
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
                        value = "name";
                      }
                    ];
                    type = "assignment";
                    value = {
                      multiline = false;
                      parts = [
                        {
                          type = "text";
                          value = "gpu-screen-recorder-ui-1.15.0";
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
                          value = "1.15.0";
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
                      left = {
                        path = [
                          {
                            kind = "identifier";
                            value = "old";
                          }
                          {
                            kind = "identifier";
                            value = "meta";
                          }
                        ];
                        type = "reference";
                      };
                      operator = "//";
                      right = {
                        recursive = false;
                        statements = [
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
                                  value = "gsr-ui";
                                }
                              ];
                              type = "string";
                            };
                          }
                        ];
                        type = "attr-set";
                      };
                      type = "binary";
                    };
                  }
                  {
                    operator = "=";
                    target = [
                      {
                        kind = "identifier";
                        value = "mesonFlags";
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
                              value = "-Dcapabilities=false";
                            }
                          ];
                          type = "string";
                        }
                      ];
                      type = "list";
                    };
                  }
                ];
                type = "attr-set";
              };
              form = "identifier";
              parameters = [
                {
                  default = null;
                  name = "old";
                  variadic = false;
                }
              ];
              type = "lambda";
            };
          }
        ];
        callee = {
          segment = {
            kind = "identifier";
            value = "overrideAttrs";
          };
          type = "selection";
          value = {
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
                          value = "src";
                        }
                      ];
                      type = "assignment";
                      value = {
                        name = "lib";
                        path = [
                          {
                            kind = "identifier";
                            value = "zenPackageSources";
                          }
                          {
                            kind = "identifier";
                            value = "gsrUi";
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
                          value = "libX11";
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
                            value = "libx11";
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
                          value = "libXrandr";
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
                            value = "libxrandr";
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
                          value = "libXrender";
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
                            value = "libxrender";
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
                          value = "libXext";
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
                            value = "libxext";
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
                          value = "libXcomposite";
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
                            value = "libxcomposite";
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
                          value = "libXcursor";
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
                            value = "libxcursor";
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
                          value = "libXfixes";
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
                            value = "libxfixes";
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
                          value = "libXi";
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
                            value = "libxi";
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
                          value = "gpu-screen-recorder";
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
                            value = "video";
                          }
                          {
                            kind = "identifier";
                            value = "gpu-screen-recorder";
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
                          value = "gpu-screen-recorder-notification";
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
                            value = "video";
                          }
                          {
                            kind = "identifier";
                            value = "gpu-screen-recorder-notification";
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
                            value = "gsrPackaging";
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
                            value = "/gpu-screen-recorder-ui.nix";
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
          };
        };
        type = "call";
      };
    }
  ];
  target = [
    "unknown"
    "gpu-screen-recorder-ui"
  ];
}
