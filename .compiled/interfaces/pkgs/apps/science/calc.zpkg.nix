{ ... }:
{
  dependenciesDeclared = false;
  descriptorVersion = "zenlang.semantic/2";
  grammarVersion = "1.0.0Na";
  id = "pkgs.unknown.calc";
  imports = [ ];
  irVersion = "1.0.0Na";
  kind = "zpkg";
  location = "/nix/store/59qqzf108ga8h2qmsjizzsn2p7i889xx-zenpkgs-dsl-source/pkgs/apps/science/calc.zpkg:15:8";
  metadata = {
    description = {
      multiline = true;
      parts = [
        {
          type = "text";
          value = "\n    C-style arbitrary precision calculator.\n  ";
        }
      ];
      type = "string";
    };
    id = {
      multiline = false;
      parts = [
        {
          type = "text";
          value = "unknown.calc";
        }
      ];
      type = "string";
    };
    license = {
      name = "l";
      path = [
        {
          kind = "identifier";
          value = "gpl2Only";
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
          value = "Calc";
        }
      ];
      type = "string";
    };
    packageVersion = {
      multiline = false;
      parts = [
        {
          type = "text";
          value = "2.15.0.2";
        }
      ];
      type = "string";
    };
    summary = {
      multiline = false;
      parts = [
        {
          type = "text";
          value = "C-style arbitrary precision calculator";
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
              value = "science";
            }
          ];
          type = "string";
        }
        {
          multiline = false;
          parts = [
            {
              type = "text";
              value = "calculator";
            }
          ];
          type = "string";
        }
        {
          multiline = false;
          parts = [
            {
              type = "text";
              value = "education";
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
  name = "calc";
  packageImport = {
    name = "pkgs";
    path = [
      {
        kind = "identifier";
        value = "legacy";
      }
      {
        kind = "identifier";
        value = "calc";
      }
    ];
    type = "variable";
  };
  provider = {
    expression = {
      name = "pkgs";
      path = [
        {
          kind = "identifier";
          value = "legacy";
        }
        {
          kind = "identifier";
          value = "calc";
        }
      ];
      type = "variable";
    };
    kind = "import";
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
                  value = "unknown.calc";
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
                  value = "Calc";
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
                  value = "C-style arbitrary precision calculator";
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
                  value = "\n    C-style arbitrary precision calculator.\n  ";
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
                  value = "2.15.0.2";
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
                      value = "science";
                    }
                  ];
                  type = "string";
                }
                {
                  multiline = false;
                  parts = [
                    {
                      type = "text";
                      value = "calculator";
                    }
                  ];
                  type = "string";
                }
                {
                  multiline = false;
                  parts = [
                    {
                      type = "text";
                      value = "education";
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
                  value = "gpl2Only";
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
      package = {
        name = "pkgs";
        path = [
          {
            kind = "identifier";
            value = "legacy";
          }
          {
            kind = "identifier";
            value = "calc";
          }
        ];
        type = "variable";
      };
      type = "package-import";
    }
  ];
  target = [
    "unknown"
    "calc"
  ];
}
