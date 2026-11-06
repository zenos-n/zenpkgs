{ ... }:
{
  dependenciesDeclared = false;
  descriptorVersion = "zenlang.semantic/2";
  grammarVersion = "1.0.0Na";
  id = "pkgs.unknown.yuzu-mainline";
  imports = [ ];
  irVersion = "1.0.0Na";
  kind = "zpkg";
  location = "/nix/store/59qqzf108ga8h2qmsjizzsn2p7i889xx-zenpkgs-dsl-source/pkgs/apps/gaming/emulators/yuzu-mainline.zpkg:8:9";
  metadata = {
    description = {
      multiline = true;
      parts = [
        {
          type = "text";
          value = "Yuzu Mainline 1611 from pinned NixOS 23.11, replacing the discontinued Flatpak. Upstream source repositories have been removed; the original Nix binary cache currently provides this build.";
        }
      ];
      type = "string";
    };
    id = {
      multiline = false;
      parts = [
        {
          type = "text";
          value = "unknown.yuzu-mainline";
        }
      ];
      type = "string";
    };
    license = {
      name = "l";
      path = [
        {
          kind = "identifier";
          value = "gpl2Plus";
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
          value = "Yuzu Mainline";
        }
      ];
      type = "string";
    };
    packageVersion = {
      multiline = false;
      parts = [
        {
          type = "text";
          value = "1611";
        }
      ];
      type = "string";
    };
    summary = {
      multiline = false;
      parts = [
        {
          type = "text";
          value = "Archived Yuzu Nintendo Switch emulator";
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
              value = "gaming";
            }
          ];
          type = "string";
        }
        {
          multiline = false;
          parts = [
            {
              type = "text";
              value = "emulator";
            }
          ];
          type = "string";
        }
        {
          multiline = false;
          parts = [
            {
              type = "text";
              value = "switch";
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
  name = "yuzu-mainline";
  provider = {
    expression = {
      body = {
        path = [
          {
            kind = "identifier";
            value = "emulatorPackages";
          }
          {
            kind = "identifier";
            value = "yuzu-mainline";
          }
        ];
        type = "reference";
      };
      statements = [
        {
          operator = "=";
          target = [
            {
              kind = "identifier";
              value = "emulatorPackages";
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
                        value = "system";
                      }
                    ];
                    type = "assignment";
                    value = {
                      multiline = false;
                      parts = [
                        {
                          type = "text";
                          value = "x86_64-linux";
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
              arguments = [
                {
                  name = "lib";
                  path = [
                    {
                      kind = "identifier";
                      value = "zenPackageSources";
                    }
                    {
                      kind = "identifier";
                      value = "emulatorsNixpkgs";
                    }
                  ];
                  type = "variable";
                }
              ];
              callee = {
                arguments = [
                  {
                    recursive = false;
                    statements = [ ];
                    type = "attr-set";
                  }
                ];
                callee = {
                  name = "lib";
                  path = [
                    {
                      kind = "identifier";
                      value = "callPackageWith";
                    }
                  ];
                  type = "variable";
                };
                type = "call";
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
                  value = "unknown.yuzu-mainline";
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
                  value = "Yuzu Mainline";
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
                  value = "Archived Yuzu Nintendo Switch emulator";
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
                  value = "Yuzu Mainline 1611 from pinned NixOS 23.11, replacing the discontinued Flatpak. Upstream source repositories have been removed; the original Nix binary cache currently provides this build.";
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
                  value = "1611";
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
                      value = "gaming";
                    }
                  ];
                  type = "string";
                }
                {
                  multiline = false;
                  parts = [
                    {
                      type = "text";
                      value = "emulator";
                    }
                  ];
                  type = "string";
                }
                {
                  multiline = false;
                  parts = [
                    {
                      type = "text";
                      value = "switch";
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
                  value = "gpl2Plus";
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
          path = [
            {
              kind = "identifier";
              value = "emulatorPackages";
            }
            {
              kind = "identifier";
              value = "yuzu-mainline";
            }
          ];
          type = "reference";
        };
        statements = [
          {
            operator = "=";
            target = [
              {
                kind = "identifier";
                value = "emulatorPackages";
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
                          value = "system";
                        }
                      ];
                      type = "assignment";
                      value = {
                        multiline = false;
                        parts = [
                          {
                            type = "text";
                            value = "x86_64-linux";
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
                arguments = [
                  {
                    name = "lib";
                    path = [
                      {
                        kind = "identifier";
                        value = "zenPackageSources";
                      }
                      {
                        kind = "identifier";
                        value = "emulatorsNixpkgs";
                      }
                    ];
                    type = "variable";
                  }
                ];
                callee = {
                  arguments = [
                    {
                      recursive = false;
                      statements = [ ];
                      type = "attr-set";
                    }
                  ];
                  callee = {
                    name = "lib";
                    path = [
                      {
                        kind = "identifier";
                        value = "callPackageWith";
                      }
                    ];
                    type = "variable";
                  };
                  type = "call";
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
    "unknown"
    "yuzu-mainline"
  ];
}
