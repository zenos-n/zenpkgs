{ ... }:
{
  dependenciesDeclared = false;
  descriptorVersion = "zenlang.semantic/2";
  grammarVersion = "1.0.0Na";
  id = "pkgs.com.neg-zero.tubefin";
  imports = [ ];
  irVersion = "1.0.0Na";
  kind = "zpkg";
  location = "/nix/store/59qqzf108ga8h2qmsjizzsn2p7i889xx-zenpkgs-dsl-source/pkgs/apps/video/tubefin.zpkg:13:9";
  metadata = {
    description = {
      multiline = true;
      parts = [
        {
          type = "text";
          value = "Native YouTube and Jellyfin client for GNOME. Optional migration package; installation does not activate a service.";
        }
      ];
      type = "string";
    };
    id = {
      multiline = false;
      parts = [
        {
          type = "text";
          value = "com.neg-zero.tubefin";
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
          value = "TubeFin";
        }
      ];
      type = "string";
    };
    packageVersion = {
      multiline = false;
      parts = [
        {
          type = "text";
          value = "1.6.4";
        }
      ];
      type = "string";
    };
    summary = {
      multiline = false;
      parts = [
        {
          type = "text";
          value = "Native YouTube and Jellyfin client for GNOME";
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
              value = "youtube";
            }
          ];
          type = "string";
        }
        {
          multiline = false;
          parts = [
            {
              type = "text";
              value = "jellyfin";
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
  name = "tubefin";
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
                      value = "tubefin";
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
                      value = "1.6.4";
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
                    value = "pyproject";
                  }
                ];
                type = "assignment";
                value = {
                  kind = "true";
                  type = "literal";
                  value = true;
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
                                value = "tubefin";
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
                                value = "b954dd487ea58ac32dd980eb7f0ed4edb760a657";
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
                                value = "sha256-tt9bR6szI0mJ5n4BS8S2LNIMLZmIVbFZ8m6NSBMGAyk=";
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
                    path = [
                      {
                        kind = "identifier";
                        value = "packageSet";
                      }
                      {
                        kind = "identifier";
                        value = "fetchFromGitHub";
                      }
                    ];
                    type = "reference";
                  };
                  type = "call";
                };
              }
              {
                operator = "=";
                target = [
                  {
                    kind = "identifier";
                    value = "postPatch";
                  }
                ];
                type = "assignment";
                value = {
                  multiline = true;
                  parts = [
                    {
                      type = "text";
                      value = "\n              substituteInPlace src/tubefin/mpv_player.py \\\n                --replace-fail '\"libEGL.so.1\"' '\"";
                    }
                    {
                      expression = {
                        path = [
                          {
                            kind = "identifier";
                            value = "packageSet";
                          }
                          {
                            kind = "identifier";
                            value = "libglvnd";
                          }
                        ];
                        type = "reference";
                      };
                      type = "interpolation";
                    }
                    {
                      type = "text";
                      value = "/lib/libEGL.so.1\"' \\\n                --replace-fail '\"libGL.so.1\"' '\"";
                    }
                    {
                      expression = {
                        path = [
                          {
                            kind = "identifier";
                            value = "packageSet";
                          }
                          {
                            kind = "identifier";
                            value = "libglvnd";
                          }
                        ];
                        type = "reference";
                      };
                      type = "interpolation";
                    }
                    {
                      type = "text";
                      value = "/lib/libGL.so.1\"' \\\n                --replace-fail '\"libgtk-4.so.1\"' '\"";
                    }
                    {
                      expression = {
                        path = [
                          {
                            kind = "identifier";
                            value = "packageSet";
                          }
                          {
                            kind = "identifier";
                            value = "gtk4";
                          }
                        ];
                        type = "reference";
                      };
                      type = "interpolation";
                    }
                    {
                      type = "text";
                      value = "/lib/libgtk-4.so.1\"'\n            ";
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
                    value = "build-system";
                  }
                ];
                type = "assignment";
                value = {
                  items = [
                    {
                      path = [
                        {
                          kind = "identifier";
                          value = "pythonRuntime";
                        }
                        {
                          kind = "identifier";
                          value = "pkgs";
                        }
                        {
                          kind = "identifier";
                          value = "setuptools";
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
                    value = "dependencies";
                  }
                ];
                type = "assignment";
                value = {
                  items = [
                    {
                      path = [
                        {
                          kind = "identifier";
                          value = "pythonRuntime";
                        }
                        {
                          kind = "identifier";
                          value = "pkgs";
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
                          value = "pythonRuntime";
                        }
                        {
                          kind = "identifier";
                          value = "pkgs";
                        }
                        {
                          kind = "identifier";
                          value = "yt-dlp";
                        }
                      ];
                      type = "reference";
                    }
                    {
                      path = [
                        {
                          kind = "identifier";
                          value = "pythonMpv";
                        }
                      ];
                      type = "reference";
                    }
                    {
                      path = [
                        {
                          kind = "identifier";
                          value = "pythonRuntime";
                        }
                        {
                          kind = "identifier";
                          value = "pkgs";
                        }
                        {
                          kind = "identifier";
                          value = "websocket-client";
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
              {
                operator = "=";
                target = [
                  {
                    kind = "identifier";
                    value = "checkPhase";
                  }
                ];
                type = "assignment";
                value = {
                  multiline = true;
                  parts = [
                    {
                      type = "text";
                      value = "\n              runHook preCheck\n              python -m unittest discover -s tests -v\n              runHook postCheck\n            ";
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
                    value = "nativeBuildInputs";
                  }
                ];
                type = "assignment";
                value = {
                  items = [
                    {
                      path = [
                        {
                          kind = "identifier";
                          value = "packageSet";
                        }
                        {
                          kind = "identifier";
                          value = "wrapGAppsHook4";
                        }
                      ];
                      type = "reference";
                    }
                    {
                      path = [
                        {
                          kind = "identifier";
                          value = "packageSet";
                        }
                        {
                          kind = "identifier";
                          value = "gobject-introspection";
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
                    value = "buildInputs";
                  }
                ];
                type = "assignment";
                value = {
                  items = [
                    {
                      path = [
                        {
                          kind = "identifier";
                          value = "packageSet";
                        }
                        {
                          kind = "identifier";
                          value = "gtk4";
                        }
                      ];
                      type = "reference";
                    }
                    {
                      path = [
                        {
                          kind = "identifier";
                          value = "packageSet";
                        }
                        {
                          kind = "identifier";
                          value = "libadwaita";
                        }
                      ];
                      type = "reference";
                    }
                    {
                      path = [
                        {
                          kind = "identifier";
                          value = "packageSet";
                        }
                        {
                          kind = "identifier";
                          value = "mpv";
                        }
                      ];
                      type = "reference";
                    }
                    {
                      path = [
                        {
                          kind = "identifier";
                          value = "packageSet";
                        }
                        {
                          kind = "identifier";
                          value = "libglvnd";
                        }
                      ];
                      type = "reference";
                    }
                    {
                      path = [
                        {
                          kind = "identifier";
                          value = "packageSet";
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
                      type = "reference";
                    }
                    {
                      path = [
                        {
                          kind = "identifier";
                          value = "packageSet";
                        }
                        {
                          kind = "identifier";
                          value = "gst_all_1";
                        }
                        {
                          kind = "identifier";
                          value = "gstreamer";
                        }
                        {
                          kind = "identifier";
                          value = "out";
                        }
                      ];
                      type = "reference";
                    }
                    {
                      path = [
                        {
                          kind = "identifier";
                          value = "packageSet";
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
                      type = "reference";
                    }
                    {
                      path = [
                        {
                          kind = "identifier";
                          value = "packageSet";
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
                      type = "reference";
                    }
                    {
                      path = [
                        {
                          kind = "identifier";
                          value = "packageSet";
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
                      type = "reference";
                    }
                    {
                      path = [
                        {
                          kind = "identifier";
                          value = "packageSet";
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
                      type = "reference";
                    }
                    {
                      path = [
                        {
                          kind = "identifier";
                          value = "packageSet";
                        }
                        {
                          kind = "identifier";
                          value = "gst_all_1";
                        }
                        {
                          kind = "identifier";
                          value = "gst-libav";
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
                    value = "preFixup";
                  }
                ];
                type = "assignment";
                value = {
                  multiline = true;
                  parts = [
                    {
                      type = "text";
                      value = "\n              gappsWrapperArgs+=(\n                --prefix PATH : ";
                    }
                    {
                      expression = {
                        arguments = [
                          {
                            items = [
                              {
                                path = [
                                  {
                                    kind = "identifier";
                                    value = "packageSet";
                                  }
                                  {
                                    kind = "identifier";
                                    value = "yt-dlp";
                                  }
                                ];
                                type = "reference";
                              }
                              {
                                path = [
                                  {
                                    kind = "identifier";
                                    value = "packageSet";
                                  }
                                  {
                                    kind = "identifier";
                                    value = "deno";
                                  }
                                ];
                                type = "reference";
                              }
                              {
                                path = [
                                  {
                                    kind = "identifier";
                                    value = "packageSet";
                                  }
                                  {
                                    kind = "identifier";
                                    value = "ffmpeg";
                                  }
                                ];
                                type = "reference";
                              }
                              {
                                path = [
                                  {
                                    kind = "identifier";
                                    value = "packageSet";
                                  }
                                  {
                                    kind = "identifier";
                                    value = "libsecret";
                                  }
                                ];
                                type = "reference";
                              }
                            ];
                            type = "list";
                          }
                        ];
                        callee = {
                          path = [
                            {
                              kind = "identifier";
                              value = "packageSet";
                            }
                            {
                              kind = "identifier";
                              value = "lib";
                            }
                            {
                              kind = "identifier";
                              value = "makeBinPath";
                            }
                          ];
                          type = "reference";
                        };
                        type = "call";
                      };
                      type = "interpolation";
                    }
                    {
                      type = "text";
                      value = "\n                --prefix LD_LIBRARY_PATH : ";
                    }
                    {
                      expression = {
                        arguments = [
                          {
                            items = [
                              {
                                path = [
                                  {
                                    kind = "identifier";
                                    value = "packageSet";
                                  }
                                  {
                                    kind = "identifier";
                                    value = "mpv";
                                  }
                                ];
                                type = "reference";
                              }
                              {
                                path = [
                                  {
                                    kind = "identifier";
                                    value = "packageSet";
                                  }
                                  {
                                    kind = "identifier";
                                    value = "libglvnd";
                                  }
                                ];
                                type = "reference";
                              }
                            ];
                            type = "list";
                          }
                        ];
                        callee = {
                          path = [
                            {
                              kind = "identifier";
                              value = "packageSet";
                            }
                            {
                              kind = "identifier";
                              value = "lib";
                            }
                            {
                              kind = "identifier";
                              value = "makeLibraryPath";
                            }
                          ];
                          type = "reference";
                        };
                        type = "call";
                      };
                      type = "interpolation";
                    }
                    {
                      type = "text";
                      value = "\n                --prefix GST_PLUGIN_SYSTEM_PATH_1_0 : ";
                    }
                    {
                      expression = {
                        arguments = [
                          {
                            items = [
                              {
                                path = [
                                  {
                                    kind = "identifier";
                                    value = "packageSet";
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
                                type = "reference";
                              }
                              {
                                path = [
                                  {
                                    kind = "identifier";
                                    value = "packageSet";
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
                                type = "reference";
                              }
                              {
                                path = [
                                  {
                                    kind = "identifier";
                                    value = "packageSet";
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
                                type = "reference";
                              }
                              {
                                path = [
                                  {
                                    kind = "identifier";
                                    value = "packageSet";
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
                                type = "reference";
                              }
                              {
                                path = [
                                  {
                                    kind = "identifier";
                                    value = "packageSet";
                                  }
                                  {
                                    kind = "identifier";
                                    value = "gst_all_1";
                                  }
                                  {
                                    kind = "identifier";
                                    value = "gst-libav";
                                  }
                                ];
                                type = "reference";
                              }
                              {
                                path = [
                                  {
                                    kind = "identifier";
                                    value = "packageSet";
                                  }
                                  {
                                    kind = "identifier";
                                    value = "gst_all_1";
                                  }
                                  {
                                    kind = "identifier";
                                    value = "gstreamer";
                                  }
                                  {
                                    kind = "identifier";
                                    value = "out";
                                  }
                                ];
                                type = "reference";
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
                            path = [
                              {
                                kind = "identifier";
                                value = "packageSet";
                              }
                              {
                                kind = "identifier";
                                value = "lib";
                              }
                              {
                                kind = "identifier";
                                value = "makeSearchPath";
                              }
                            ];
                            type = "reference";
                          };
                          type = "call";
                        };
                        type = "call";
                      };
                      type = "interpolation";
                    }
                    {
                      type = "text";
                      value = "\n              )\n            ";
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
                    value = "postInstall";
                  }
                ];
                type = "assignment";
                value = {
                  multiline = true;
                  parts = [
                    {
                      type = "text";
                      value = "\n              install -Dm644 data/io.github.doromiert.TubeFin.desktop \\\n                $out/share/applications/io.github.doromiert.TubeFin.desktop\n              install -Dm644 data/io.github.doromiert.TubeFin.metainfo.xml \\\n                $out/share/metainfo/io.github.doromiert.TubeFin.metainfo.xml\n              install -Dm644 data/io.github.doromiert.TubeFin.svg \\\n                $out/share/icons/hicolor/scalable/apps/io.github.doromiert.TubeFin.svg\n            ";
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
                            value = "Native YouTube and Jellyfin client for GNOME";
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
                            value = "https://github.com/doromiert/tubefin";
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
                        path = [
                          {
                            kind = "identifier";
                            value = "packageSet";
                          }
                          {
                            kind = "identifier";
                            value = "lib";
                          }
                          {
                            kind = "identifier";
                            value = "licenses";
                          }
                          {
                            kind = "identifier";
                            value = "gpl3Plus";
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
                          value = "mainProgram";
                        }
                      ];
                      type = "assignment";
                      value = {
                        multiline = false;
                        parts = [
                          {
                            type = "text";
                            value = "tubefin";
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
                        path = [
                          {
                            kind = "identifier";
                            value = "packageSet";
                          }
                          {
                            kind = "identifier";
                            value = "lib";
                          }
                          {
                            kind = "identifier";
                            value = "platforms";
                          }
                          {
                            kind = "identifier";
                            value = "linux";
                          }
                        ];
                        type = "reference";
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
          path = [
            {
              kind = "identifier";
              value = "pythonRuntime";
            }
            {
              kind = "identifier";
              value = "pkgs";
            }
            {
              kind = "identifier";
              value = "buildPythonApplication";
            }
          ];
          type = "reference";
        };
        type = "call";
      };
      statements = [
        {
          operator = "=";
          target = [
            {
              kind = "identifier";
              value = "packageSet";
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
              value = "pythonRuntime";
            }
          ];
          type = "assignment";
          value = {
            path = [
              {
                kind = "identifier";
                value = "packageSet";
              }
              {
                kind = "identifier";
                value = "python3";
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
              value = "pythonMpv";
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
                          value = "python-mpv";
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
                          value = "1.0.8";
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
                        value = "pyproject";
                      }
                    ];
                    type = "assignment";
                    value = {
                      kind = "true";
                      type = "literal";
                      value = true;
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
                                  value = "pname";
                                }
                              ];
                              type = "assignment";
                              value = {
                                multiline = false;
                                parts = [
                                  {
                                    type = "text";
                                    value = "python_mpv";
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
                                    value = "1.0.8";
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
                                    value = "sha256-AX+jWdoFnIMalMQZCDSRkD5tL3yBuYQcM8GWyr9LP+M=";
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
                        path = [
                          {
                            kind = "identifier";
                            value = "packageSet";
                          }
                          {
                            kind = "identifier";
                            value = "fetchPypi";
                          }
                        ];
                        type = "reference";
                      };
                      type = "call";
                    };
                  }
                  {
                    operator = "=";
                    target = [
                      {
                        kind = "identifier";
                        value = "build-system";
                      }
                    ];
                    type = "assignment";
                    value = {
                      items = [
                        {
                          path = [
                            {
                              kind = "identifier";
                              value = "pythonRuntime";
                            }
                            {
                              kind = "identifier";
                              value = "pkgs";
                            }
                            {
                              kind = "identifier";
                              value = "setuptools";
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
                        value = "postPatch";
                      }
                    ];
                    type = "assignment";
                    value = {
                      multiline = true;
                      parts = [
                        {
                          type = "text";
                          value = "\n              substituteInPlace mpv.py \\\n                --replace-fail \"ctypes.util.find_library('mpv')\" \\\n                \"'";
                        }
                        {
                          expression = {
                            path = [
                              {
                                kind = "identifier";
                                value = "packageSet";
                              }
                              {
                                kind = "identifier";
                                value = "mpv";
                              }
                            ];
                            type = "reference";
                          };
                          type = "interpolation";
                        }
                        {
                          type = "text";
                          value = "/lib/libmpv.so.2'\"\n            ";
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
              path = [
                {
                  kind = "identifier";
                  value = "pythonRuntime";
                }
                {
                  kind = "identifier";
                  value = "pkgs";
                }
                {
                  kind = "identifier";
                  value = "buildPythonPackage";
                }
              ];
              type = "reference";
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
                  value = "com.neg-zero.tubefin";
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
                  value = "TubeFin";
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
                  value = "Native YouTube and Jellyfin client for GNOME";
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
                  value = "Native YouTube and Jellyfin client for GNOME. Optional migration package; installation does not activate a service.";
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
                  value = "1.6.4";
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
                      value = "youtube";
                    }
                  ];
                  type = "string";
                }
                {
                  multiline = false;
                  parts = [
                    {
                      type = "text";
                      value = "jellyfin";
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
                        value = "tubefin";
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
                        value = "1.6.4";
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
                      value = "pyproject";
                    }
                  ];
                  type = "assignment";
                  value = {
                    kind = "true";
                    type = "literal";
                    value = true;
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
                                  value = "tubefin";
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
                                  value = "b954dd487ea58ac32dd980eb7f0ed4edb760a657";
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
                                  value = "sha256-tt9bR6szI0mJ5n4BS8S2LNIMLZmIVbFZ8m6NSBMGAyk=";
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
                      path = [
                        {
                          kind = "identifier";
                          value = "packageSet";
                        }
                        {
                          kind = "identifier";
                          value = "fetchFromGitHub";
                        }
                      ];
                      type = "reference";
                    };
                    type = "call";
                  };
                }
                {
                  operator = "=";
                  target = [
                    {
                      kind = "identifier";
                      value = "postPatch";
                    }
                  ];
                  type = "assignment";
                  value = {
                    multiline = true;
                    parts = [
                      {
                        type = "text";
                        value = "\n              substituteInPlace src/tubefin/mpv_player.py \\\n                --replace-fail '\"libEGL.so.1\"' '\"";
                      }
                      {
                        expression = {
                          path = [
                            {
                              kind = "identifier";
                              value = "packageSet";
                            }
                            {
                              kind = "identifier";
                              value = "libglvnd";
                            }
                          ];
                          type = "reference";
                        };
                        type = "interpolation";
                      }
                      {
                        type = "text";
                        value = "/lib/libEGL.so.1\"' \\\n                --replace-fail '\"libGL.so.1\"' '\"";
                      }
                      {
                        expression = {
                          path = [
                            {
                              kind = "identifier";
                              value = "packageSet";
                            }
                            {
                              kind = "identifier";
                              value = "libglvnd";
                            }
                          ];
                          type = "reference";
                        };
                        type = "interpolation";
                      }
                      {
                        type = "text";
                        value = "/lib/libGL.so.1\"' \\\n                --replace-fail '\"libgtk-4.so.1\"' '\"";
                      }
                      {
                        expression = {
                          path = [
                            {
                              kind = "identifier";
                              value = "packageSet";
                            }
                            {
                              kind = "identifier";
                              value = "gtk4";
                            }
                          ];
                          type = "reference";
                        };
                        type = "interpolation";
                      }
                      {
                        type = "text";
                        value = "/lib/libgtk-4.so.1\"'\n            ";
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
                      value = "build-system";
                    }
                  ];
                  type = "assignment";
                  value = {
                    items = [
                      {
                        path = [
                          {
                            kind = "identifier";
                            value = "pythonRuntime";
                          }
                          {
                            kind = "identifier";
                            value = "pkgs";
                          }
                          {
                            kind = "identifier";
                            value = "setuptools";
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
                      value = "dependencies";
                    }
                  ];
                  type = "assignment";
                  value = {
                    items = [
                      {
                        path = [
                          {
                            kind = "identifier";
                            value = "pythonRuntime";
                          }
                          {
                            kind = "identifier";
                            value = "pkgs";
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
                            value = "pythonRuntime";
                          }
                          {
                            kind = "identifier";
                            value = "pkgs";
                          }
                          {
                            kind = "identifier";
                            value = "yt-dlp";
                          }
                        ];
                        type = "reference";
                      }
                      {
                        path = [
                          {
                            kind = "identifier";
                            value = "pythonMpv";
                          }
                        ];
                        type = "reference";
                      }
                      {
                        path = [
                          {
                            kind = "identifier";
                            value = "pythonRuntime";
                          }
                          {
                            kind = "identifier";
                            value = "pkgs";
                          }
                          {
                            kind = "identifier";
                            value = "websocket-client";
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
                {
                  operator = "=";
                  target = [
                    {
                      kind = "identifier";
                      value = "checkPhase";
                    }
                  ];
                  type = "assignment";
                  value = {
                    multiline = true;
                    parts = [
                      {
                        type = "text";
                        value = "\n              runHook preCheck\n              python -m unittest discover -s tests -v\n              runHook postCheck\n            ";
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
                      value = "nativeBuildInputs";
                    }
                  ];
                  type = "assignment";
                  value = {
                    items = [
                      {
                        path = [
                          {
                            kind = "identifier";
                            value = "packageSet";
                          }
                          {
                            kind = "identifier";
                            value = "wrapGAppsHook4";
                          }
                        ];
                        type = "reference";
                      }
                      {
                        path = [
                          {
                            kind = "identifier";
                            value = "packageSet";
                          }
                          {
                            kind = "identifier";
                            value = "gobject-introspection";
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
                      value = "buildInputs";
                    }
                  ];
                  type = "assignment";
                  value = {
                    items = [
                      {
                        path = [
                          {
                            kind = "identifier";
                            value = "packageSet";
                          }
                          {
                            kind = "identifier";
                            value = "gtk4";
                          }
                        ];
                        type = "reference";
                      }
                      {
                        path = [
                          {
                            kind = "identifier";
                            value = "packageSet";
                          }
                          {
                            kind = "identifier";
                            value = "libadwaita";
                          }
                        ];
                        type = "reference";
                      }
                      {
                        path = [
                          {
                            kind = "identifier";
                            value = "packageSet";
                          }
                          {
                            kind = "identifier";
                            value = "mpv";
                          }
                        ];
                        type = "reference";
                      }
                      {
                        path = [
                          {
                            kind = "identifier";
                            value = "packageSet";
                          }
                          {
                            kind = "identifier";
                            value = "libglvnd";
                          }
                        ];
                        type = "reference";
                      }
                      {
                        path = [
                          {
                            kind = "identifier";
                            value = "packageSet";
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
                        type = "reference";
                      }
                      {
                        path = [
                          {
                            kind = "identifier";
                            value = "packageSet";
                          }
                          {
                            kind = "identifier";
                            value = "gst_all_1";
                          }
                          {
                            kind = "identifier";
                            value = "gstreamer";
                          }
                          {
                            kind = "identifier";
                            value = "out";
                          }
                        ];
                        type = "reference";
                      }
                      {
                        path = [
                          {
                            kind = "identifier";
                            value = "packageSet";
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
                        type = "reference";
                      }
                      {
                        path = [
                          {
                            kind = "identifier";
                            value = "packageSet";
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
                        type = "reference";
                      }
                      {
                        path = [
                          {
                            kind = "identifier";
                            value = "packageSet";
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
                        type = "reference";
                      }
                      {
                        path = [
                          {
                            kind = "identifier";
                            value = "packageSet";
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
                        type = "reference";
                      }
                      {
                        path = [
                          {
                            kind = "identifier";
                            value = "packageSet";
                          }
                          {
                            kind = "identifier";
                            value = "gst_all_1";
                          }
                          {
                            kind = "identifier";
                            value = "gst-libav";
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
                      value = "preFixup";
                    }
                  ];
                  type = "assignment";
                  value = {
                    multiline = true;
                    parts = [
                      {
                        type = "text";
                        value = "\n              gappsWrapperArgs+=(\n                --prefix PATH : ";
                      }
                      {
                        expression = {
                          arguments = [
                            {
                              items = [
                                {
                                  path = [
                                    {
                                      kind = "identifier";
                                      value = "packageSet";
                                    }
                                    {
                                      kind = "identifier";
                                      value = "yt-dlp";
                                    }
                                  ];
                                  type = "reference";
                                }
                                {
                                  path = [
                                    {
                                      kind = "identifier";
                                      value = "packageSet";
                                    }
                                    {
                                      kind = "identifier";
                                      value = "deno";
                                    }
                                  ];
                                  type = "reference";
                                }
                                {
                                  path = [
                                    {
                                      kind = "identifier";
                                      value = "packageSet";
                                    }
                                    {
                                      kind = "identifier";
                                      value = "ffmpeg";
                                    }
                                  ];
                                  type = "reference";
                                }
                                {
                                  path = [
                                    {
                                      kind = "identifier";
                                      value = "packageSet";
                                    }
                                    {
                                      kind = "identifier";
                                      value = "libsecret";
                                    }
                                  ];
                                  type = "reference";
                                }
                              ];
                              type = "list";
                            }
                          ];
                          callee = {
                            path = [
                              {
                                kind = "identifier";
                                value = "packageSet";
                              }
                              {
                                kind = "identifier";
                                value = "lib";
                              }
                              {
                                kind = "identifier";
                                value = "makeBinPath";
                              }
                            ];
                            type = "reference";
                          };
                          type = "call";
                        };
                        type = "interpolation";
                      }
                      {
                        type = "text";
                        value = "\n                --prefix LD_LIBRARY_PATH : ";
                      }
                      {
                        expression = {
                          arguments = [
                            {
                              items = [
                                {
                                  path = [
                                    {
                                      kind = "identifier";
                                      value = "packageSet";
                                    }
                                    {
                                      kind = "identifier";
                                      value = "mpv";
                                    }
                                  ];
                                  type = "reference";
                                }
                                {
                                  path = [
                                    {
                                      kind = "identifier";
                                      value = "packageSet";
                                    }
                                    {
                                      kind = "identifier";
                                      value = "libglvnd";
                                    }
                                  ];
                                  type = "reference";
                                }
                              ];
                              type = "list";
                            }
                          ];
                          callee = {
                            path = [
                              {
                                kind = "identifier";
                                value = "packageSet";
                              }
                              {
                                kind = "identifier";
                                value = "lib";
                              }
                              {
                                kind = "identifier";
                                value = "makeLibraryPath";
                              }
                            ];
                            type = "reference";
                          };
                          type = "call";
                        };
                        type = "interpolation";
                      }
                      {
                        type = "text";
                        value = "\n                --prefix GST_PLUGIN_SYSTEM_PATH_1_0 : ";
                      }
                      {
                        expression = {
                          arguments = [
                            {
                              items = [
                                {
                                  path = [
                                    {
                                      kind = "identifier";
                                      value = "packageSet";
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
                                  type = "reference";
                                }
                                {
                                  path = [
                                    {
                                      kind = "identifier";
                                      value = "packageSet";
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
                                  type = "reference";
                                }
                                {
                                  path = [
                                    {
                                      kind = "identifier";
                                      value = "packageSet";
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
                                  type = "reference";
                                }
                                {
                                  path = [
                                    {
                                      kind = "identifier";
                                      value = "packageSet";
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
                                  type = "reference";
                                }
                                {
                                  path = [
                                    {
                                      kind = "identifier";
                                      value = "packageSet";
                                    }
                                    {
                                      kind = "identifier";
                                      value = "gst_all_1";
                                    }
                                    {
                                      kind = "identifier";
                                      value = "gst-libav";
                                    }
                                  ];
                                  type = "reference";
                                }
                                {
                                  path = [
                                    {
                                      kind = "identifier";
                                      value = "packageSet";
                                    }
                                    {
                                      kind = "identifier";
                                      value = "gst_all_1";
                                    }
                                    {
                                      kind = "identifier";
                                      value = "gstreamer";
                                    }
                                    {
                                      kind = "identifier";
                                      value = "out";
                                    }
                                  ];
                                  type = "reference";
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
                              path = [
                                {
                                  kind = "identifier";
                                  value = "packageSet";
                                }
                                {
                                  kind = "identifier";
                                  value = "lib";
                                }
                                {
                                  kind = "identifier";
                                  value = "makeSearchPath";
                                }
                              ];
                              type = "reference";
                            };
                            type = "call";
                          };
                          type = "call";
                        };
                        type = "interpolation";
                      }
                      {
                        type = "text";
                        value = "\n              )\n            ";
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
                      value = "postInstall";
                    }
                  ];
                  type = "assignment";
                  value = {
                    multiline = true;
                    parts = [
                      {
                        type = "text";
                        value = "\n              install -Dm644 data/io.github.doromiert.TubeFin.desktop \\\n                $out/share/applications/io.github.doromiert.TubeFin.desktop\n              install -Dm644 data/io.github.doromiert.TubeFin.metainfo.xml \\\n                $out/share/metainfo/io.github.doromiert.TubeFin.metainfo.xml\n              install -Dm644 data/io.github.doromiert.TubeFin.svg \\\n                $out/share/icons/hicolor/scalable/apps/io.github.doromiert.TubeFin.svg\n            ";
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
                              value = "Native YouTube and Jellyfin client for GNOME";
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
                              value = "https://github.com/doromiert/tubefin";
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
                          path = [
                            {
                              kind = "identifier";
                              value = "packageSet";
                            }
                            {
                              kind = "identifier";
                              value = "lib";
                            }
                            {
                              kind = "identifier";
                              value = "licenses";
                            }
                            {
                              kind = "identifier";
                              value = "gpl3Plus";
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
                            value = "mainProgram";
                          }
                        ];
                        type = "assignment";
                        value = {
                          multiline = false;
                          parts = [
                            {
                              type = "text";
                              value = "tubefin";
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
                          path = [
                            {
                              kind = "identifier";
                              value = "packageSet";
                            }
                            {
                              kind = "identifier";
                              value = "lib";
                            }
                            {
                              kind = "identifier";
                              value = "platforms";
                            }
                            {
                              kind = "identifier";
                              value = "linux";
                            }
                          ];
                          type = "reference";
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
            path = [
              {
                kind = "identifier";
                value = "pythonRuntime";
              }
              {
                kind = "identifier";
                value = "pkgs";
              }
              {
                kind = "identifier";
                value = "buildPythonApplication";
              }
            ];
            type = "reference";
          };
          type = "call";
        };
        statements = [
          {
            operator = "=";
            target = [
              {
                kind = "identifier";
                value = "packageSet";
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
                value = "pythonRuntime";
              }
            ];
            type = "assignment";
            value = {
              path = [
                {
                  kind = "identifier";
                  value = "packageSet";
                }
                {
                  kind = "identifier";
                  value = "python3";
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
                value = "pythonMpv";
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
                            value = "python-mpv";
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
                            value = "1.0.8";
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
                          value = "pyproject";
                        }
                      ];
                      type = "assignment";
                      value = {
                        kind = "true";
                        type = "literal";
                        value = true;
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
                                    value = "pname";
                                  }
                                ];
                                type = "assignment";
                                value = {
                                  multiline = false;
                                  parts = [
                                    {
                                      type = "text";
                                      value = "python_mpv";
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
                                      value = "1.0.8";
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
                                      value = "sha256-AX+jWdoFnIMalMQZCDSRkD5tL3yBuYQcM8GWyr9LP+M=";
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
                          path = [
                            {
                              kind = "identifier";
                              value = "packageSet";
                            }
                            {
                              kind = "identifier";
                              value = "fetchPypi";
                            }
                          ];
                          type = "reference";
                        };
                        type = "call";
                      };
                    }
                    {
                      operator = "=";
                      target = [
                        {
                          kind = "identifier";
                          value = "build-system";
                        }
                      ];
                      type = "assignment";
                      value = {
                        items = [
                          {
                            path = [
                              {
                                kind = "identifier";
                                value = "pythonRuntime";
                              }
                              {
                                kind = "identifier";
                                value = "pkgs";
                              }
                              {
                                kind = "identifier";
                                value = "setuptools";
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
                          value = "postPatch";
                        }
                      ];
                      type = "assignment";
                      value = {
                        multiline = true;
                        parts = [
                          {
                            type = "text";
                            value = "\n              substituteInPlace mpv.py \\\n                --replace-fail \"ctypes.util.find_library('mpv')\" \\\n                \"'";
                          }
                          {
                            expression = {
                              path = [
                                {
                                  kind = "identifier";
                                  value = "packageSet";
                                }
                                {
                                  kind = "identifier";
                                  value = "mpv";
                                }
                              ];
                              type = "reference";
                            };
                            type = "interpolation";
                          }
                          {
                            type = "text";
                            value = "/lib/libmpv.so.2'\"\n            ";
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
                path = [
                  {
                    kind = "identifier";
                    value = "pythonRuntime";
                  }
                  {
                    kind = "identifier";
                    value = "pkgs";
                  }
                  {
                    kind = "identifier";
                    value = "buildPythonPackage";
                  }
                ];
                type = "reference";
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
    "tubefin"
  ];
}
