{ ... }:
{
  dependenciesDeclared = false;
  descriptorVersion = "zenlang.semantic/2";
  grammarVersion = "1.0.0Na";
  id = "pkgs.com.neg-zero.gnosis";
  imports = [ ];
  irVersion = "1.0.0Na";
  kind = "zpkg";
  location = "/nix/store/3ni594f60hm22hcrazxd35dmk7pwi61m-zenpkgs-dsl-source/pkgs/apps/browsers/gnosis.zpkg:14:9";
  metadata = {
    description = {
      multiline = true;
      parts = [
        {
          type = "text";
          value = "Native GTK/libadwaita browser with an embedded Brave backend, full uBlock Origin and KeePassXC integration. The CEF/WebKit service migration remains in progress.";
        }
      ];
      type = "string";
    };
    id = {
      multiline = false;
      parts = [
        {
          type = "text";
          value = "com.neg-zero.gnosis";
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
          value = "Gnosis";
        }
      ];
      type = "string";
    };
    packageVersion = {
      multiline = false;
      parts = [
        {
          type = "text";
          value = "0.1.0";
        }
      ];
      type = "string";
    };
    summary = {
      multiline = false;
      parts = [
        {
          type = "text";
          value = "GNOME browser with a Chromium engine and uBlock Origin";
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
              value = "browser";
            }
          ];
          type = "string";
        }
        {
          multiline = false;
          parts = [
            {
              type = "text";
              value = "gnome";
            }
          ];
          type = "string";
        }
        {
          multiline = false;
          parts = [
            {
              type = "text";
              value = "web";
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
  name = "gnosis";
  provider = {
    expression = {
      arguments = [
        {
          multiline = false;
          parts = [
            {
              type = "text";
              value = "8eff4256f06a2296f7c6f362cdf5b33dd61d795f3d65faa2902fef9ba0fef45a";
            }
          ];
          type = "string";
        }
      ];
      callee = {
        arguments = [
          {
            multiline = false;
            parts = [
              {
                type = "text";
                value = "gnosis";
              }
            ];
            type = "string";
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
                  value = "gnosis";
                }
                {
                  kind = "identifier";
                  value = "packages";
                }
                {
                  kind = "identifier";
                  value = "x86_64-linux";
                }
                {
                  kind = "identifier";
                  value = "default";
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
                value = "zenPrivateHomePackage";
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
                  value = "com.neg-zero.gnosis";
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
                  value = "Gnosis";
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
                  value = "GNOME browser with a Chromium engine and uBlock Origin";
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
                  value = "Native GTK/libadwaita browser with an embedded Brave backend, full uBlock Origin and KeePassXC integration. The CEF/WebKit service migration remains in progress.";
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
                  value = "0.1.0";
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
                      value = "browser";
                    }
                  ];
                  type = "string";
                }
                {
                  multiline = false;
                  parts = [
                    {
                      type = "text";
                      value = "gnome";
                    }
                  ];
                  type = "string";
                }
                {
                  multiline = false;
                  parts = [
                    {
                      type = "text";
                      value = "web";
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
        arguments = [
          {
            multiline = false;
            parts = [
              {
                type = "text";
                value = "8eff4256f06a2296f7c6f362cdf5b33dd61d795f3d65faa2902fef9ba0fef45a";
              }
            ];
            type = "string";
          }
        ];
        callee = {
          arguments = [
            {
              multiline = false;
              parts = [
                {
                  type = "text";
                  value = "gnosis";
                }
              ];
              type = "string";
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
                    value = "gnosis";
                  }
                  {
                    kind = "identifier";
                    value = "packages";
                  }
                  {
                    kind = "identifier";
                    value = "x86_64-linux";
                  }
                  {
                    kind = "identifier";
                    value = "default";
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
                  value = "zenPrivateHomePackage";
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
  target = [
    "com"
    "neg-zero"
    "gnosis"
  ];
}
