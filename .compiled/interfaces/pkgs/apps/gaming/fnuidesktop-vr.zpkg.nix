{ ... }:
{
  dependenciesDeclared = false;
  descriptorVersion = "zenlang.semantic/2";
  grammarVersion = "1.0.0Na";
  id = "pkgs.unknown.fnuidesktop-vr";
  imports = [ ];
  irVersion = "1.0.0Na";
  kind = "zpkg";
  location = "/nix/store/59qqzf108ga8h2qmsjizzsn2p7i889xx-zenpkgs-dsl-source/pkgs/apps/gaming/fnuidesktop-vr.zpkg:13:9";
  metadata = {
    description = {
      multiline = true;
      parts = [
        {
          type = "text";
          value = "Wayland desktop mirror for SteamVR using PipeWire. Optional migration package; installation does not activate a service.";
        }
      ];
      type = "string";
    };
    id = {
      multiline = false;
      parts = [
        {
          type = "text";
          value = "unknown.fnuidesktop-vr";
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
          value = "fnuidesktop VR";
        }
      ];
      type = "string";
    };
    packageVersion = {
      multiline = false;
      parts = [
        {
          type = "text";
          value = "unstable-2026-08-23";
        }
      ];
      type = "string";
    };
    summary = {
      multiline = false;
      parts = [
        {
          type = "text";
          value = "Wayland desktop mirror for SteamVR using PipeWire";
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
              value = "wayland";
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
  name = "fnuidesktop-vr";
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
                    value = "pname";
                  }
                ];
                type = "assignment";
                value = {
                  multiline = false;
                  parts = [
                    {
                      type = "text";
                      value = "fnuidesktop-vr";
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
                      value = "unstable-2026-08-23";
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
                              value = "owner";
                            }
                          ];
                          type = "assignment";
                          value = {
                            multiline = false;
                            parts = [
                              {
                                type = "text";
                                value = "PhialsBasement";
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
                                value = "fnuidesktop-VR";
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
                                value = "5ea052a21fe27a576055ec6f6a5bff827cd9d4c8";
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
                                value = "sha256-Itrb6wySJb5q97HMeYojyfRUvCHrcREMxv5pPYRtNSU=";
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
                    value = "installPhase";
                  }
                ];
                type = "assignment";
                value = {
                  multiline = true;
                  parts = [
                    {
                      type = "text";
                      value = "\n    runHook preInstall\n    mkdir -p \"$out/share/fnuidesktop-vr\"\n    cp main.py test_wayland_capture.py vr_display.py \"$out/share/fnuidesktop-vr/\"\n    makeWrapper ";
                    }
                    {
                      expression = {
                        path = [
                          {
                            kind = "identifier";
                            value = "python";
                          }
                        ];
                        type = "reference";
                      };
                      type = "interpolation";
                    }
                    {
                      type = "text";
                      value = "/bin/python \"$out/bin/fnuidesktop-vr\" \\\n      --add-flags \"$out/share/fnuidesktop-vr/main.py\" \\\n      --prefix GI_TYPELIB_PATH : ";
                    }
                    {
                      expression = {
                        arguments = [
                          {
                            items = [
                              {
                                type = "group";
                                value = {
                                  arguments = [
                                    {
                                      name = "pkgs";
                                      path = [
                                        {
                                          kind = "identifier";
                                          value = "legacy";
                                        }
                                        {
                                          kind = "identifier";
                                          value = "glib";
                                        }
                                      ];
                                      type = "variable";
                                    }
                                  ];
                                  callee = {
                                    name = "lib";
                                    path = [
                                      {
                                        kind = "identifier";
                                        value = "getLib";
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
                                      name = "pkgs";
                                      path = [
                                        {
                                          kind = "identifier";
                                          value = "legacy";
                                        }
                                        {
                                          kind = "identifier";
                                          value = "gobject-introspection";
                                        }
                                      ];
                                      type = "variable";
                                    }
                                  ];
                                  callee = {
                                    name = "lib";
                                    path = [
                                      {
                                        kind = "identifier";
                                        value = "getLib";
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
                                    }
                                  ];
                                  callee = {
                                    name = "lib";
                                    path = [
                                      {
                                        kind = "identifier";
                                        value = "getLib";
                                      }
                                    ];
                                    type = "variable";
                                  };
                                  type = "call";
                                };
                              }
                            ];
                            type = "list";
                          }
                        ];
                        callee = {
                          arguments = [
                            {
                              multiline = false;
                              parts = [
                                {
                                  type = "text";
                                  value = "lib/girepository-1.0";
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
                                value = "makeSearchPath";
                              }
                            ];
                            type = "variable";
                          };
                          type = "call";
                        };
                        type = "call";
                      };
                      type = "interpolation";
                    }
                    {
                      type = "text";
                      value = " \\\n      --prefix GST_PLUGIN_SYSTEM_PATH_1_0 : ";
                    }
                    {
                      expression = {
                        arguments = [
                          {
                            items = [
                              {
                                type = "group";
                                value = {
                                  arguments = [
                                    {
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
                                    }
                                  ];
                                  callee = {
                                    name = "lib";
                                    path = [
                                      {
                                        kind = "identifier";
                                        value = "getLib";
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
                                      name = "pkgs";
                                      path = [
                                        {
                                          kind = "identifier";
                                          value = "legacy";
                                        }
                                        {
                                          kind = "identifier";
                                          value = "pipewire";
                                        }
                                      ];
                                      type = "variable";
                                    }
                                  ];
                                  callee = {
                                    name = "lib";
                                    path = [
                                      {
                                        kind = "identifier";
                                        value = "getLib";
                                      }
                                    ];
                                    type = "variable";
                                  };
                                  type = "call";
                                };
                              }
                            ];
                            type = "list";
                          }
                        ];
                        callee = {
                          arguments = [
                            {
                              multiline = false;
                              parts = [
                                {
                                  type = "text";
                                  value = "lib/gstreamer-1.0";
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
                                value = "makeSearchPath";
                              }
                            ];
                            type = "variable";
                          };
                          type = "call";
                        };
                        type = "call";
                      };
                      type = "interpolation";
                    }
                    {
                      type = "text";
                      value = "\n    runHook postInstall\n  ";
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
                            value = "Wayland desktop mirror for SteamVR using PipeWire";
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
                            value = "https://github.com/PhialsBasement/fnuidesktop-VR";
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
                          value = "mainProgram";
                        }
                      ];
                      type = "assignment";
                      value = {
                        multiline = false;
                        parts = [
                          {
                            type = "text";
                            value = "fnuidesktop-vr";
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
                          value = "platforms";
                        }
                      ];
                      type = "assignment";
                      value = {
                        name = "lib";
                        path = [
                          {
                            kind = "identifier";
                            value = "platforms";
                          }
                          {
                            kind = "identifier";
                            value = "linux";
                          }
                        ];
                        type = "variable";
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
              value = "stdenvNoCC";
            }
            {
              kind = "identifier";
              value = "mkDerivation";
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
              value = "openvr-python";
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
                          value = "openvr";
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
                          value = "2.12.1401";
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
                        value = "format";
                      }
                    ];
                    type = "assignment";
                    value = {
                      multiline = false;
                      parts = [
                        {
                          type = "text";
                          value = "wheel";
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
                                    value = "https://files.pythonhosted.org/packages/46/a2/e6cb89bd1803ffe70a25c20121ad8bb533fa1f1334ce7f0f7585d35e5096/openvr-2.12.1401-py3-none-any.whl";
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
                                    value = "sha256-73Yc7zFihDqAJaeBLV4kT9lKs6mSyo9e8NGwGIrVbLM=";
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
                        value = "doCheck";
                      }
                    ];
                    type = "assignment";
                    value = {
                      kind = "false";
                      type = "literal";
                      value = false;
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
                  value = "python3Packages";
                }
                {
                  kind = "identifier";
                  value = "buildPythonPackage";
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
              value = "python";
            }
          ];
          type = "assignment";
          value = {
            arguments = [
              {
                type = "group";
                value = {
                  body = {
                    items = [
                      {
                        path = [
                          {
                            kind = "identifier";
                            value = "ps";
                          }
                          {
                            kind = "identifier";
                            value = "glfw";
                          }
                        ];
                        type = "reference";
                      }
                      {
                        path = [
                          {
                            kind = "identifier";
                            value = "ps";
                          }
                          {
                            kind = "identifier";
                            value = "gst-python";
                          }
                        ];
                        type = "reference";
                      }
                      {
                        path = [
                          {
                            kind = "identifier";
                            value = "ps";
                          }
                          {
                            kind = "identifier";
                            value = "numpy";
                          }
                        ];
                        type = "reference";
                      }
                      {
                        path = [
                          {
                            kind = "identifier";
                            value = "ps";
                          }
                          {
                            kind = "identifier";
                            value = "pycairo";
                          }
                        ];
                        type = "reference";
                      }
                      {
                        path = [
                          {
                            kind = "identifier";
                            value = "ps";
                          }
                          {
                            kind = "identifier";
                            value = "pygobject3";
                          }
                        ];
                        type = "reference";
                      }
                      {
                        path = [
                          {
                            kind = "identifier";
                            value = "ps";
                          }
                          {
                            kind = "identifier";
                            value = "pynput";
                          }
                        ];
                        type = "reference";
                      }
                      {
                        path = [
                          {
                            kind = "identifier";
                            value = "ps";
                          }
                          {
                            kind = "identifier";
                            value = "pyopengl";
                          }
                        ];
                        type = "reference";
                      }
                      {
                        path = [
                          {
                            kind = "identifier";
                            value = "openvr-python";
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
                      name = "ps";
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
                  value = "python3Packages";
                }
                {
                  kind = "identifier";
                  value = "python";
                }
                {
                  kind = "identifier";
                  value = "withPackages";
                }
              ];
              type = "variable";
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
                  value = "unknown.fnuidesktop-vr";
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
                  value = "fnuidesktop VR";
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
                  value = "Wayland desktop mirror for SteamVR using PipeWire";
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
                  value = "Wayland desktop mirror for SteamVR using PipeWire. Optional migration package; installation does not activate a service.";
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
                  value = "unstable-2026-08-23";
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
                      value = "wayland";
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
                      value = "pname";
                    }
                  ];
                  type = "assignment";
                  value = {
                    multiline = false;
                    parts = [
                      {
                        type = "text";
                        value = "fnuidesktop-vr";
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
                        value = "unstable-2026-08-23";
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
                                value = "owner";
                              }
                            ];
                            type = "assignment";
                            value = {
                              multiline = false;
                              parts = [
                                {
                                  type = "text";
                                  value = "PhialsBasement";
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
                                  value = "fnuidesktop-VR";
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
                                  value = "5ea052a21fe27a576055ec6f6a5bff827cd9d4c8";
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
                                  value = "sha256-Itrb6wySJb5q97HMeYojyfRUvCHrcREMxv5pPYRtNSU=";
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
                      value = "installPhase";
                    }
                  ];
                  type = "assignment";
                  value = {
                    multiline = true;
                    parts = [
                      {
                        type = "text";
                        value = "\n    runHook preInstall\n    mkdir -p \"$out/share/fnuidesktop-vr\"\n    cp main.py test_wayland_capture.py vr_display.py \"$out/share/fnuidesktop-vr/\"\n    makeWrapper ";
                      }
                      {
                        expression = {
                          path = [
                            {
                              kind = "identifier";
                              value = "python";
                            }
                          ];
                          type = "reference";
                        };
                        type = "interpolation";
                      }
                      {
                        type = "text";
                        value = "/bin/python \"$out/bin/fnuidesktop-vr\" \\\n      --add-flags \"$out/share/fnuidesktop-vr/main.py\" \\\n      --prefix GI_TYPELIB_PATH : ";
                      }
                      {
                        expression = {
                          arguments = [
                            {
                              items = [
                                {
                                  type = "group";
                                  value = {
                                    arguments = [
                                      {
                                        name = "pkgs";
                                        path = [
                                          {
                                            kind = "identifier";
                                            value = "legacy";
                                          }
                                          {
                                            kind = "identifier";
                                            value = "glib";
                                          }
                                        ];
                                        type = "variable";
                                      }
                                    ];
                                    callee = {
                                      name = "lib";
                                      path = [
                                        {
                                          kind = "identifier";
                                          value = "getLib";
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
                                        name = "pkgs";
                                        path = [
                                          {
                                            kind = "identifier";
                                            value = "legacy";
                                          }
                                          {
                                            kind = "identifier";
                                            value = "gobject-introspection";
                                          }
                                        ];
                                        type = "variable";
                                      }
                                    ];
                                    callee = {
                                      name = "lib";
                                      path = [
                                        {
                                          kind = "identifier";
                                          value = "getLib";
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
                                      }
                                    ];
                                    callee = {
                                      name = "lib";
                                      path = [
                                        {
                                          kind = "identifier";
                                          value = "getLib";
                                        }
                                      ];
                                      type = "variable";
                                    };
                                    type = "call";
                                  };
                                }
                              ];
                              type = "list";
                            }
                          ];
                          callee = {
                            arguments = [
                              {
                                multiline = false;
                                parts = [
                                  {
                                    type = "text";
                                    value = "lib/girepository-1.0";
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
                                  value = "makeSearchPath";
                                }
                              ];
                              type = "variable";
                            };
                            type = "call";
                          };
                          type = "call";
                        };
                        type = "interpolation";
                      }
                      {
                        type = "text";
                        value = " \\\n      --prefix GST_PLUGIN_SYSTEM_PATH_1_0 : ";
                      }
                      {
                        expression = {
                          arguments = [
                            {
                              items = [
                                {
                                  type = "group";
                                  value = {
                                    arguments = [
                                      {
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
                                      }
                                    ];
                                    callee = {
                                      name = "lib";
                                      path = [
                                        {
                                          kind = "identifier";
                                          value = "getLib";
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
                                        name = "pkgs";
                                        path = [
                                          {
                                            kind = "identifier";
                                            value = "legacy";
                                          }
                                          {
                                            kind = "identifier";
                                            value = "pipewire";
                                          }
                                        ];
                                        type = "variable";
                                      }
                                    ];
                                    callee = {
                                      name = "lib";
                                      path = [
                                        {
                                          kind = "identifier";
                                          value = "getLib";
                                        }
                                      ];
                                      type = "variable";
                                    };
                                    type = "call";
                                  };
                                }
                              ];
                              type = "list";
                            }
                          ];
                          callee = {
                            arguments = [
                              {
                                multiline = false;
                                parts = [
                                  {
                                    type = "text";
                                    value = "lib/gstreamer-1.0";
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
                                  value = "makeSearchPath";
                                }
                              ];
                              type = "variable";
                            };
                            type = "call";
                          };
                          type = "call";
                        };
                        type = "interpolation";
                      }
                      {
                        type = "text";
                        value = "\n    runHook postInstall\n  ";
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
                              value = "Wayland desktop mirror for SteamVR using PipeWire";
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
                              value = "https://github.com/PhialsBasement/fnuidesktop-VR";
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
                            value = "mainProgram";
                          }
                        ];
                        type = "assignment";
                        value = {
                          multiline = false;
                          parts = [
                            {
                              type = "text";
                              value = "fnuidesktop-vr";
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
                            value = "platforms";
                          }
                        ];
                        type = "assignment";
                        value = {
                          name = "lib";
                          path = [
                            {
                              kind = "identifier";
                              value = "platforms";
                            }
                            {
                              kind = "identifier";
                              value = "linux";
                            }
                          ];
                          type = "variable";
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
                value = "stdenvNoCC";
              }
              {
                kind = "identifier";
                value = "mkDerivation";
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
                value = "openvr-python";
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
                            value = "openvr";
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
                            value = "2.12.1401";
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
                          value = "format";
                        }
                      ];
                      type = "assignment";
                      value = {
                        multiline = false;
                        parts = [
                          {
                            type = "text";
                            value = "wheel";
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
                                      value = "https://files.pythonhosted.org/packages/46/a2/e6cb89bd1803ffe70a25c20121ad8bb533fa1f1334ce7f0f7585d35e5096/openvr-2.12.1401-py3-none-any.whl";
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
                                      value = "sha256-73Yc7zFihDqAJaeBLV4kT9lKs6mSyo9e8NGwGIrVbLM=";
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
                          value = "doCheck";
                        }
                      ];
                      type = "assignment";
                      value = {
                        kind = "false";
                        type = "literal";
                        value = false;
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
                    value = "python3Packages";
                  }
                  {
                    kind = "identifier";
                    value = "buildPythonPackage";
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
                value = "python";
              }
            ];
            type = "assignment";
            value = {
              arguments = [
                {
                  type = "group";
                  value = {
                    body = {
                      items = [
                        {
                          path = [
                            {
                              kind = "identifier";
                              value = "ps";
                            }
                            {
                              kind = "identifier";
                              value = "glfw";
                            }
                          ];
                          type = "reference";
                        }
                        {
                          path = [
                            {
                              kind = "identifier";
                              value = "ps";
                            }
                            {
                              kind = "identifier";
                              value = "gst-python";
                            }
                          ];
                          type = "reference";
                        }
                        {
                          path = [
                            {
                              kind = "identifier";
                              value = "ps";
                            }
                            {
                              kind = "identifier";
                              value = "numpy";
                            }
                          ];
                          type = "reference";
                        }
                        {
                          path = [
                            {
                              kind = "identifier";
                              value = "ps";
                            }
                            {
                              kind = "identifier";
                              value = "pycairo";
                            }
                          ];
                          type = "reference";
                        }
                        {
                          path = [
                            {
                              kind = "identifier";
                              value = "ps";
                            }
                            {
                              kind = "identifier";
                              value = "pygobject3";
                            }
                          ];
                          type = "reference";
                        }
                        {
                          path = [
                            {
                              kind = "identifier";
                              value = "ps";
                            }
                            {
                              kind = "identifier";
                              value = "pynput";
                            }
                          ];
                          type = "reference";
                        }
                        {
                          path = [
                            {
                              kind = "identifier";
                              value = "ps";
                            }
                            {
                              kind = "identifier";
                              value = "pyopengl";
                            }
                          ];
                          type = "reference";
                        }
                        {
                          path = [
                            {
                              kind = "identifier";
                              value = "openvr-python";
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
                        name = "ps";
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
                    value = "python3Packages";
                  }
                  {
                    kind = "identifier";
                    value = "python";
                  }
                  {
                    kind = "identifier";
                    value = "withPackages";
                  }
                ];
                type = "variable";
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
    "unknown"
    "fnuidesktop-vr"
  ];
}
