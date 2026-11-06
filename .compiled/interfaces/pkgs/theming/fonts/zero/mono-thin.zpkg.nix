{ ... }:
{
  dependenciesDeclared = false;
  descriptorVersion = "zenlang.semantic/2";
  grammarVersion = "1.0.0Na";
  id = "pkgs.com.neg-zero.zero-font-mono-thin";
  imports = [ ];
  irVersion = "1.0.0Na";
  kind = "zpkg";
  location = "/nix/store/59qqzf108ga8h2qmsjizzsn2p7i889xx-zenpkgs-dsl-source/pkgs/theming/fonts/zero/mono-thin.zpkg:9:9";
  metadata = {
    description = {
      multiline = true;
      parts = [
        {
          type = "text";
          value = "Thin monospaced Zero display typeface. Preserves the existing ZenOS theme provider.";
        }
      ];
      type = "string";
    };
    id = {
      multiline = false;
      parts = [
        {
          type = "text";
          value = "com.neg-zero.zero-font-mono-thin";
        }
      ];
      type = "string";
    };
    license = {
      name = "l";
      path = [
        {
          kind = "identifier";
          value = "napl";
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
          value = "Zero Mono Thin";
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
          value = "Thin monospaced Zero display typeface";
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
              value = "theming";
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
  name = "mono-thin";
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
                      value = "zero-mono-thin-font";
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
                                value = "negative-zero-inft";
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
                                value = "zero-font";
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
                              value = "hash";
                            }
                          ];
                          type = "assignment";
                          value = {
                            multiline = false;
                            parts = [
                              {
                                type = "text";
                                value = "sha256-PnrdkHBDUYwJe/KPPEgFKxoJEpWMVZyuewCy+1Wn6qk=";
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
                          value = "fontforge";
                        }
                      ];
                      type = "reference";
                    }
                    {
                      path = [
                        {
                          kind = "identifier";
                          value = "python3Packages";
                        }
                        {
                          kind = "identifier";
                          value = "fonttools";
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
                    value = "buildPhase";
                  }
                ];
                type = "assignment";
                value = {
                  multiline = true;
                  parts = [
                    {
                      type = "text";
                      value = "\n    runHook preBuild\n    python3 builder.py --src glyphs --output Zero-Mono.otf --mono\n    fontforge -lang=py -c 'import fontforge; font = fontforge.open(\"Zero-Mono.otf\"); font.selection.all(); font.changeWeight(-45); font.familyname = \"Zero Mono Thin\"; font.fullname = \"Zero Mono Thin\"; font.fontname = \"ZeroMonoThin\"; font.weight = \"Thin\"; font.os2_weight = 100; font.generate(\"Zero-Mono-Thin.otf\")'\n    runHook postBuild\n  ";
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
                    value = "installPhase";
                  }
                ];
                type = "assignment";
                value = {
                  multiline = true;
                  parts = [
                    {
                      type = "text";
                      value = "\n    runHook preInstall\n    install -Dm644 Zero-Mono-Thin.otf \"$out/share/fonts/opentype/Zero-Mono-Thin.otf\"\n    runHook postInstall\n  ";
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
                            value = "Thin monospaced Zero display typeface";
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
                            value = "https://github.com/negative-zero-inft/zero-font";
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
                            value = "themeLib";
                          }
                          {
                            kind = "identifier";
                            value = "licenses";
                          }
                          {
                            kind = "identifier";
                            value = "napalm";
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
                        path = [
                          {
                            kind = "identifier";
                            value = "themeLib";
                          }
                          {
                            kind = "identifier";
                            value = "platforms";
                          }
                          {
                            kind = "identifier";
                            value = "all";
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
              value = "stdenvNoCC";
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
              value = "fetchFromGitHub";
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
                value = "fetchFromGitHub";
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
              value = "fontforge";
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
                value = "fontforge";
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
              value = "python3Packages";
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
                value = "python3Packages";
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
              value = "stdenvNoCC";
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
                value = "stdenvNoCC";
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
              value = "themeLib";
            }
          ];
          type = "assignment";
          value = {
            name = "lib";
            path = [ ];
            type = "variable";
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
                  value = "com.neg-zero.zero-font-mono-thin";
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
                  value = "Zero Mono Thin";
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
                  value = "Thin monospaced Zero display typeface";
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
                  value = "Thin monospaced Zero display typeface. Preserves the existing ZenOS theme provider.";
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
                      value = "theming";
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
                  value = "napl";
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
                        value = "zero-mono-thin-font";
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
                                  value = "negative-zero-inft";
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
                                  value = "zero-font";
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
                                value = "hash";
                              }
                            ];
                            type = "assignment";
                            value = {
                              multiline = false;
                              parts = [
                                {
                                  type = "text";
                                  value = "sha256-PnrdkHBDUYwJe/KPPEgFKxoJEpWMVZyuewCy+1Wn6qk=";
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
                            value = "fontforge";
                          }
                        ];
                        type = "reference";
                      }
                      {
                        path = [
                          {
                            kind = "identifier";
                            value = "python3Packages";
                          }
                          {
                            kind = "identifier";
                            value = "fonttools";
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
                      value = "buildPhase";
                    }
                  ];
                  type = "assignment";
                  value = {
                    multiline = true;
                    parts = [
                      {
                        type = "text";
                        value = "\n    runHook preBuild\n    python3 builder.py --src glyphs --output Zero-Mono.otf --mono\n    fontforge -lang=py -c 'import fontforge; font = fontforge.open(\"Zero-Mono.otf\"); font.selection.all(); font.changeWeight(-45); font.familyname = \"Zero Mono Thin\"; font.fullname = \"Zero Mono Thin\"; font.fontname = \"ZeroMonoThin\"; font.weight = \"Thin\"; font.os2_weight = 100; font.generate(\"Zero-Mono-Thin.otf\")'\n    runHook postBuild\n  ";
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
                      value = "installPhase";
                    }
                  ];
                  type = "assignment";
                  value = {
                    multiline = true;
                    parts = [
                      {
                        type = "text";
                        value = "\n    runHook preInstall\n    install -Dm644 Zero-Mono-Thin.otf \"$out/share/fonts/opentype/Zero-Mono-Thin.otf\"\n    runHook postInstall\n  ";
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
                              value = "Thin monospaced Zero display typeface";
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
                              value = "https://github.com/negative-zero-inft/zero-font";
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
                              value = "themeLib";
                            }
                            {
                              kind = "identifier";
                              value = "licenses";
                            }
                            {
                              kind = "identifier";
                              value = "napalm";
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
                          path = [
                            {
                              kind = "identifier";
                              value = "themeLib";
                            }
                            {
                              kind = "identifier";
                              value = "platforms";
                            }
                            {
                              kind = "identifier";
                              value = "all";
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
                value = "stdenvNoCC";
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
                value = "fetchFromGitHub";
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
                  value = "fetchFromGitHub";
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
                value = "fontforge";
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
                  value = "fontforge";
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
                value = "python3Packages";
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
                  value = "python3Packages";
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
                value = "stdenvNoCC";
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
                  value = "stdenvNoCC";
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
                value = "themeLib";
              }
            ];
            type = "assignment";
            value = {
              name = "lib";
              path = [ ];
              type = "variable";
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
    "zero-font-mono-thin"
  ];
}
