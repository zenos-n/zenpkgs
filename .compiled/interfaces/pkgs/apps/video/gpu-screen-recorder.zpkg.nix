{ ... }:
{
  dependenciesDeclared = false;
  descriptorVersion = "zenlang.semantic/2";
  grammarVersion = "1.0.0Na";
  id = "pkgs.com.dec05eba.gpu-screen-recorder.cli";
  imports = [ ];
  irVersion = "1.0.0Na";
  kind = "zpkg";
  location = "/nix/store/3ni594f60hm22hcrazxd35dmk7pwi61m-zenpkgs-dsl-source/pkgs/apps/video/gpu-screen-recorder.zpkg:13:9";
  metadata = {
    description = {
      multiline = true;
      parts = [
        {
          type = "text";
          value = "GPU-accelerated recording and instant replay. Uses the maintained nixpkgs package.";
        }
      ];
      type = "string";
    };
    id = {
      multiline = false;
      parts = [
        {
          type = "text";
          value = "com.dec05eba.gpu-screen-recorder.cli";
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
          value = "GPU Screen Recorder CLI";
        }
      ];
      type = "string";
    };
    packageVersion = {
      multiline = false;
      parts = [
        {
          type = "text";
          value = "5.13.8";
        }
      ];
      type = "string";
    };
    summary = {
      multiline = false;
      parts = [
        {
          type = "text";
          value = "GPU-accelerated recording and instant replay";
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
  name = "gpu-screen-recorder";
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
                              value = "gpu-screen-recorder-";
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
                                    value = "gpu-screen-recorder";
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
                            {
                              type = "text";
                              value = "-zenfs";
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
                              type = "group";
                              value = {
                                arguments = [
                                  {
                                    recursive = false;
                                    statements = [
                                      {
                                        names = [
                                          "wrapperDir"
                                        ];
                                        source = null;
                                        type = "inherit";
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
                                      value = "gpu-screen-recorder";
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
                              value = "\n      original=$(readlink \"$out/bin/gpu-screen-recorder\")\n      rm \"$out/bin/gpu-screen-recorder\"\n      makeWrapper \"$original\" \"$out/bin/gpu-screen-recorder\" \\\n        --run 'if [ -d \"$HOME/.private\" ]; then\n          export HOME=\"$HOME/.private/Packages/gpu-screen-recorder\"\n          mkdir -p \"$HOME\"\n        fi' \\\n        --prefix PATH : \"";
                            }
                            {
                              expression = {
                                path = [
                                  {
                                    kind = "identifier";
                                    value = "wrapperDir";
                                  }
                                ];
                                type = "reference";
                              };
                              type = "interpolation";
                            }
                            {
                              type = "text";
                              value = "\"\n    ";
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
                              value = "gpu-screen-recorder";
                            }
                            {
                              kind = "identifier";
                              value = "meta";
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
                            value = "version";
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
                              value = "gpu-screen-recorder";
                            }
                            {
                              kind = "identifier";
                              value = "version";
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
              form = "set";
              parameters = [
                {
                  default = {
                    multiline = false;
                    parts = [
                      {
                        type = "text";
                        value = "/run/wrappers/bin";
                      }
                    ];
                    type = "string";
                  };
                  name = "wrapperDir";
                  variadic = false;
                }
              ];
              type = "lambda";
            };
          }
        ];
        callee = {
          name = "lib";
          path = [
            {
              kind = "identifier";
              value = "makeOverridable";
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
                  value = "com.dec05eba.gpu-screen-recorder.cli";
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
                  value = "GPU Screen Recorder CLI";
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
                  value = "GPU-accelerated recording and instant replay";
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
                  value = "GPU-accelerated recording and instant replay. Uses the maintained nixpkgs package.";
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
                  value = "5.13.8";
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
                                value = "gpu-screen-recorder-";
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
                                      value = "gpu-screen-recorder";
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
                              {
                                type = "text";
                                value = "-zenfs";
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
                                type = "group";
                                value = {
                                  arguments = [
                                    {
                                      recursive = false;
                                      statements = [
                                        {
                                          names = [
                                            "wrapperDir"
                                          ];
                                          source = null;
                                          type = "inherit";
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
                                        value = "gpu-screen-recorder";
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
                                value = "\n      original=$(readlink \"$out/bin/gpu-screen-recorder\")\n      rm \"$out/bin/gpu-screen-recorder\"\n      makeWrapper \"$original\" \"$out/bin/gpu-screen-recorder\" \\\n        --run 'if [ -d \"$HOME/.private\" ]; then\n          export HOME=\"$HOME/.private/Packages/gpu-screen-recorder\"\n          mkdir -p \"$HOME\"\n        fi' \\\n        --prefix PATH : \"";
                              }
                              {
                                expression = {
                                  path = [
                                    {
                                      kind = "identifier";
                                      value = "wrapperDir";
                                    }
                                  ];
                                  type = "reference";
                                };
                                type = "interpolation";
                              }
                              {
                                type = "text";
                                value = "\"\n    ";
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
                                value = "gpu-screen-recorder";
                              }
                              {
                                kind = "identifier";
                                value = "meta";
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
                              value = "version";
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
                                value = "gpu-screen-recorder";
                              }
                              {
                                kind = "identifier";
                                value = "version";
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
                form = "set";
                parameters = [
                  {
                    default = {
                      multiline = false;
                      parts = [
                        {
                          type = "text";
                          value = "/run/wrappers/bin";
                        }
                      ];
                      type = "string";
                    };
                    name = "wrapperDir";
                    variadic = false;
                  }
                ];
                type = "lambda";
              };
            }
          ];
          callee = {
            name = "lib";
            path = [
              {
                kind = "identifier";
                value = "makeOverridable";
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
    "dec05eba"
    "gpu-screen-recorder"
    "cli"
  ];
}
