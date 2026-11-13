{ ... }:
{
  dependenciesDeclared = false;
  descriptorVersion = "zenlang.semantic/2";
  grammarVersion = "1.0.0Na";
  id = "pkgs.com.neg-zero.swisstag";
  imports = [ ];
  irVersion = "1.0.0Na";
  kind = "zpkg";
  location = "/nix/store/3ni594f60hm22hcrazxd35dmk7pwi61m-zenpkgs-dsl-source/pkgs/apps/audio/swisstag.zpkg:13:9";
  metadata = {
    description = {
      multiline = true;
      parts = [
        {
          type = "text";
          value = "Automated music tagging and lyrics retrieval. Optional migration package; installation does not activate a service.";
        }
      ];
      type = "string";
    };
    id = {
      multiline = false;
      parts = [
        {
          type = "text";
          value = "com.neg-zero.swisstag";
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
          value = "Swisstag";
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
          value = "Automated music tagging and lyrics retrieval";
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
              value = "music";
            }
          ];
          type = "string";
        }
        {
          multiline = false;
          parts = [
            {
              type = "text";
              value = "metadata";
            }
          ];
          type = "string";
        }
        {
          multiline = false;
          parts = [
            {
              type = "text";
              value = "lyrics";
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
  name = "swisstag";
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
                      value = "swisstag";
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
                                value = "swisstag";
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
                                value = "d86156d3b81875fa9e8f99447e1542592f3c00e1";
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
                                value = "sha256-iWRIAsywQqdH8Yy8vI1o9/96R/elY7S7RYWnOcP8hRo=";
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
                          value = "makeWrapper";
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
                    value = "propagatedBuildInputs";
                  }
                ];
                type = "assignment";
                value = {
                  items = [
                    {
                      path = [
                        {
                          kind = "identifier";
                          value = "pythonEnv";
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
                          value = "chromaprint";
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
                    value = "installPhase";
                  }
                ];
                type = "assignment";
                value = {
                  multiline = true;
                  parts = [
                    {
                      type = "text";
                      value = "\n            mkdir -p $out/bin\n            cp swisstag.py $out/bin/swisstag\n            chmod +x $out/bin/swisstag\n            \n            # Man Page\n            mkdir -p $out/share/man/man1\n            cp swisstag.1 $out/share/man/man1/swisstag.1\n          ";
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
                    value = "postFixup";
                  }
                ];
                type = "assignment";
                value = {
                  multiline = true;
                  parts = [
                    {
                      type = "text";
                      value = "\n            # 1. Fix python interpreter path\n            sed -i '1s|^#!/usr/bin/env python3|#!";
                    }
                    {
                      expression = {
                        path = [
                          {
                            kind = "identifier";
                            value = "pythonEnv";
                          }
                        ];
                        type = "reference";
                      };
                      type = "interpolation";
                    }
                    {
                      type = "text";
                      value = "/bin/python3|' $out/bin/swisstag\n            \n            # 2. Wrap the binary to include fpcalc (chromaprint) in PATH\n            wrapProgram $out/bin/swisstag \\\n              --prefix PATH : ";
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
                                    value = "chromaprint";
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
                      value = "\n          ";
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
                            value = "Automated music tagger using Genius and MusicBrainz";
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
                            value = "https://github.com/doromiert/swisstag";
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
                            value = "gpl3Only";
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
              value = "packageSet";
            }
            {
              kind = "identifier";
              value = "stdenv";
            }
            {
              kind = "identifier";
              value = "mkDerivation";
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
              value = "lyricsgenius";
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
                          value = "lyricsgenius";
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
                          value = "3.7.5";
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
                                    value = "lyricsgenius";
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
                                    value = "3.7.5";
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
                                  value = "sha256";
                                }
                              ];
                              type = "assignment";
                              value = {
                                multiline = false;
                                parts = [
                                  {
                                    type = "text";
                                    value = "sha256-xPEMFPeYBFXGXIfQz9EIa+CWba7K+ZaTAy02tlo4qhY=";
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
                            value = "python3Packages";
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
                              value = "packageSet";
                            }
                            {
                              kind = "identifier";
                              value = "python3Packages";
                            }
                            {
                              kind = "identifier";
                              value = "setuptools";
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
                              value = "python3Packages";
                            }
                            {
                              kind = "identifier";
                              value = "hatchling";
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
                        value = "propagatedBuildInputs";
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
                              value = "python3Packages";
                            }
                            {
                              kind = "identifier";
                              value = "requests";
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
                              value = "python3Packages";
                            }
                            {
                              kind = "identifier";
                              value = "beautifulsoup4";
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
                              value = "python3Packages";
                            }
                            {
                              kind = "identifier";
                              value = "hatchling";
                            }
                          ];
                          type = "reference";
                        }
                      ];
                      type = "list";
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
                  value = "python3Packages";
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
        {
          operator = "=";
          target = [
            {
              kind = "identifier";
              value = "syncedlyrics";
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
                          value = "syncedlyrics";
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
                                    value = "syncedlyrics";
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
                                  value = "sha256";
                                }
                              ];
                              type = "assignment";
                              value = {
                                multiline = false;
                                parts = [
                                  {
                                    type = "text";
                                    value = "sha256-JrwIR7s1tYAyS3eYCsmxzkHJz/7WOe7rkDABfhumuZE=";
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
                            value = "python3Packages";
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
                              value = "packageSet";
                            }
                            {
                              kind = "identifier";
                              value = "python3Packages";
                            }
                            {
                              kind = "identifier";
                              value = "poetry-core";
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
                        value = "propagatedBuildInputs";
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
                              value = "python3Packages";
                            }
                            {
                              kind = "identifier";
                              value = "requests";
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
                              value = "python3Packages";
                            }
                            {
                              kind = "identifier";
                              value = "beautifulsoup4";
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
                              value = "python3Packages";
                            }
                            {
                              kind = "identifier";
                              value = "rapidfuzz";
                            }
                          ];
                          type = "reference";
                        }
                      ];
                      type = "list";
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
                  value = "python3Packages";
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
        {
          operator = "=";
          target = [
            {
              kind = "identifier";
              value = "pythonEnv";
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
                            value = "mutagen";
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
                            value = "musicbrainzngs";
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
                            value = "thefuzz";
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
                            value = "requests";
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
                            value = "unidecode";
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
                            value = "pillow";
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
                            value = "beautifulsoup4";
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
                            value = "rapidfuzz";
                          }
                        ];
                        type = "reference";
                      }
                      {
                        path = [
                          {
                            kind = "identifier";
                            value = "syncedlyrics";
                          }
                        ];
                        type = "reference";
                      }
                      {
                        path = [
                          {
                            kind = "identifier";
                            value = "lyricsgenius";
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
              path = [
                {
                  kind = "identifier";
                  value = "packageSet";
                }
                {
                  kind = "identifier";
                  value = "python3";
                }
                {
                  kind = "identifier";
                  value = "withPackages";
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
                  value = "com.neg-zero.swisstag";
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
                  value = "Swisstag";
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
                  value = "Automated music tagging and lyrics retrieval";
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
                  value = "Automated music tagging and lyrics retrieval. Optional migration package; installation does not activate a service.";
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
                      value = "music";
                    }
                  ];
                  type = "string";
                }
                {
                  multiline = false;
                  parts = [
                    {
                      type = "text";
                      value = "metadata";
                    }
                  ];
                  type = "string";
                }
                {
                  multiline = false;
                  parts = [
                    {
                      type = "text";
                      value = "lyrics";
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
                        value = "swisstag";
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
                                  value = "swisstag";
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
                                  value = "d86156d3b81875fa9e8f99447e1542592f3c00e1";
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
                                  value = "sha256-iWRIAsywQqdH8Yy8vI1o9/96R/elY7S7RYWnOcP8hRo=";
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
                            value = "makeWrapper";
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
                      value = "propagatedBuildInputs";
                    }
                  ];
                  type = "assignment";
                  value = {
                    items = [
                      {
                        path = [
                          {
                            kind = "identifier";
                            value = "pythonEnv";
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
                            value = "chromaprint";
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
                      value = "installPhase";
                    }
                  ];
                  type = "assignment";
                  value = {
                    multiline = true;
                    parts = [
                      {
                        type = "text";
                        value = "\n            mkdir -p $out/bin\n            cp swisstag.py $out/bin/swisstag\n            chmod +x $out/bin/swisstag\n            \n            # Man Page\n            mkdir -p $out/share/man/man1\n            cp swisstag.1 $out/share/man/man1/swisstag.1\n          ";
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
                      value = "postFixup";
                    }
                  ];
                  type = "assignment";
                  value = {
                    multiline = true;
                    parts = [
                      {
                        type = "text";
                        value = "\n            # 1. Fix python interpreter path\n            sed -i '1s|^#!/usr/bin/env python3|#!";
                      }
                      {
                        expression = {
                          path = [
                            {
                              kind = "identifier";
                              value = "pythonEnv";
                            }
                          ];
                          type = "reference";
                        };
                        type = "interpolation";
                      }
                      {
                        type = "text";
                        value = "/bin/python3|' $out/bin/swisstag\n            \n            # 2. Wrap the binary to include fpcalc (chromaprint) in PATH\n            wrapProgram $out/bin/swisstag \\\n              --prefix PATH : ";
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
                                      value = "chromaprint";
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
                        value = "\n          ";
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
                              value = "Automated music tagger using Genius and MusicBrainz";
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
                              value = "https://github.com/doromiert/swisstag";
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
                              value = "gpl3Only";
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
                value = "packageSet";
              }
              {
                kind = "identifier";
                value = "stdenv";
              }
              {
                kind = "identifier";
                value = "mkDerivation";
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
                value = "lyricsgenius";
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
                            value = "lyricsgenius";
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
                            value = "3.7.5";
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
                                      value = "lyricsgenius";
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
                                      value = "3.7.5";
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
                                    value = "sha256";
                                  }
                                ];
                                type = "assignment";
                                value = {
                                  multiline = false;
                                  parts = [
                                    {
                                      type = "text";
                                      value = "sha256-xPEMFPeYBFXGXIfQz9EIa+CWba7K+ZaTAy02tlo4qhY=";
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
                              value = "python3Packages";
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
                                value = "packageSet";
                              }
                              {
                                kind = "identifier";
                                value = "python3Packages";
                              }
                              {
                                kind = "identifier";
                                value = "setuptools";
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
                                value = "python3Packages";
                              }
                              {
                                kind = "identifier";
                                value = "hatchling";
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
                          value = "propagatedBuildInputs";
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
                                value = "python3Packages";
                              }
                              {
                                kind = "identifier";
                                value = "requests";
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
                                value = "python3Packages";
                              }
                              {
                                kind = "identifier";
                                value = "beautifulsoup4";
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
                                value = "python3Packages";
                              }
                              {
                                kind = "identifier";
                                value = "hatchling";
                              }
                            ];
                            type = "reference";
                          }
                        ];
                        type = "list";
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
                    value = "python3Packages";
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
          {
            operator = "=";
            target = [
              {
                kind = "identifier";
                value = "syncedlyrics";
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
                            value = "syncedlyrics";
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
                                      value = "syncedlyrics";
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
                                    value = "sha256";
                                  }
                                ];
                                type = "assignment";
                                value = {
                                  multiline = false;
                                  parts = [
                                    {
                                      type = "text";
                                      value = "sha256-JrwIR7s1tYAyS3eYCsmxzkHJz/7WOe7rkDABfhumuZE=";
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
                              value = "python3Packages";
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
                                value = "packageSet";
                              }
                              {
                                kind = "identifier";
                                value = "python3Packages";
                              }
                              {
                                kind = "identifier";
                                value = "poetry-core";
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
                          value = "propagatedBuildInputs";
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
                                value = "python3Packages";
                              }
                              {
                                kind = "identifier";
                                value = "requests";
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
                                value = "python3Packages";
                              }
                              {
                                kind = "identifier";
                                value = "beautifulsoup4";
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
                                value = "python3Packages";
                              }
                              {
                                kind = "identifier";
                                value = "rapidfuzz";
                              }
                            ];
                            type = "reference";
                          }
                        ];
                        type = "list";
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
                    value = "python3Packages";
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
          {
            operator = "=";
            target = [
              {
                kind = "identifier";
                value = "pythonEnv";
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
                              value = "mutagen";
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
                              value = "musicbrainzngs";
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
                              value = "thefuzz";
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
                              value = "requests";
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
                              value = "unidecode";
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
                              value = "pillow";
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
                              value = "beautifulsoup4";
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
                              value = "rapidfuzz";
                            }
                          ];
                          type = "reference";
                        }
                        {
                          path = [
                            {
                              kind = "identifier";
                              value = "syncedlyrics";
                            }
                          ];
                          type = "reference";
                        }
                        {
                          path = [
                            {
                              kind = "identifier";
                              value = "lyricsgenius";
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
                path = [
                  {
                    kind = "identifier";
                    value = "packageSet";
                  }
                  {
                    kind = "identifier";
                    value = "python3";
                  }
                  {
                    kind = "identifier";
                    value = "withPackages";
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
    "swisstag"
  ];
}
