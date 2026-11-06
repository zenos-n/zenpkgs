{ ... }:
{
  dependenciesDeclared = false;
  descriptorVersion = "zenlang.semantic/2";
  grammarVersion = "1.0.0Na";
  id = "pkgs.unknown.edhm-ui";
  imports = [ ];
  irVersion = "1.0.0Na";
  kind = "zpkg";
  location = "/nix/store/59qqzf108ga8h2qmsjizzsn2p7i889xx-zenpkgs-dsl-source/pkgs/apps/gaming/edhm-ui.zpkg:36:8";
  metadata = {
    description = {
      multiline = true;
      parts = [
        {
          type = "text";
          value = "\n    EDHM UI is a GPL v3 licensed user interface for managing Elite Dangerous HUD modifications.\n    It includes EDHM (Elite Dangerous HUD Mod) which has a custom restrictive license.\n\n    Redistribution Permission: The copyright holder Fred89210 has granted explicit\n    permission for EDHM to be redistributed as part of the EDHM-UI package in Nixpkgs\n    (see REDISTRIBUTION_EXCEPTION.md in the EDHM repository).\n\n    DLL Components: The package includes DLLs from the GPLv3-licensed 3Dmigoto project and an unmodified Microsoft DirectX library\n    - d3dcompiler_46.dll (Microsoft DirectX Runtime v9.30.9200.20789, distributed as part of 3Dmigoto v1.3.16)\n      - \"You can redistribute this DLL to other computers with your application as a side-by-side DLL.\"\n      - https://learn.microsoft.com/en-us/windows/win32/directx-sdk--august-2009-\n    - d3d11.dll (from 3Dmigoto v1.3.16)\n    - nvapi64.dll (from 3Dmigoto v1.3.16)\n    The 3Dmigoto project can be found at https://github.com/bo3b/3Dmigoto\n\n    Note: The underlying EDHM tool normally has a custom license with significant restrictions:\n    - Personal and non-commercial use only unless otherwise agreed\n    - No modification, redistribution, or reuse without explicit permission\n    - All rights reserved by original authors (Fred89210 and psychicEgg)\n\n    This is a fan-made modification for Elite Dangerous and is not affiliated with\n    Frontier Developments plc.\n  ";
        }
      ];
      type = "string";
    };
    id = {
      multiline = false;
      parts = [
        {
          type = "text";
          value = "unknown.edhm-ui";
        }
      ];
      type = "string";
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
          value = "EDHM UI";
        }
      ];
      type = "string";
    };
    packageVersion = {
      multiline = false;
      parts = [
        {
          type = "text";
          value = "3.0.70";
        }
      ];
      type = "string";
    };
    summary = {
      multiline = false;
      parts = [
        {
          type = "text";
          value = "HUD modification manager for Elite Dangerous";
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
              value = "elite-dangerous";
            }
          ];
          type = "string";
        }
        {
          multiline = false;
          parts = [
            {
              type = "text";
              value = "mods";
            }
          ];
          type = "string";
        }
        {
          multiline = false;
          parts = [
            {
              type = "text";
              value = "interface";
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
  name = "edhm-ui";
  packageImport = {
    name = "pkgs";
    path = [
      {
        kind = "identifier";
        value = "legacy";
      }
      {
        kind = "identifier";
        value = "edhm-ui";
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
          value = "edhm-ui";
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
                  value = "unknown.edhm-ui";
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
                  value = "EDHM UI";
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
                  value = "HUD modification manager for Elite Dangerous";
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
                  value = "\n    EDHM UI is a GPL v3 licensed user interface for managing Elite Dangerous HUD modifications.\n    It includes EDHM (Elite Dangerous HUD Mod) which has a custom restrictive license.\n\n    Redistribution Permission: The copyright holder Fred89210 has granted explicit\n    permission for EDHM to be redistributed as part of the EDHM-UI package in Nixpkgs\n    (see REDISTRIBUTION_EXCEPTION.md in the EDHM repository).\n\n    DLL Components: The package includes DLLs from the GPLv3-licensed 3Dmigoto project and an unmodified Microsoft DirectX library\n    - d3dcompiler_46.dll (Microsoft DirectX Runtime v9.30.9200.20789, distributed as part of 3Dmigoto v1.3.16)\n      - \"You can redistribute this DLL to other computers with your application as a side-by-side DLL.\"\n      - https://learn.microsoft.com/en-us/windows/win32/directx-sdk--august-2009-\n    - d3d11.dll (from 3Dmigoto v1.3.16)\n    - nvapi64.dll (from 3Dmigoto v1.3.16)\n    The 3Dmigoto project can be found at https://github.com/bo3b/3Dmigoto\n\n    Note: The underlying EDHM tool normally has a custom license with significant restrictions:\n    - Personal and non-commercial use only unless otherwise agreed\n    - No modification, redistribution, or reuse without explicit permission\n    - All rights reserved by original authors (Fred89210 and psychicEgg)\n\n    This is a fan-made modification for Elite Dangerous and is not affiliated with\n    Frontier Developments plc.\n  ";
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
                  value = "3.0.70";
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
                      value = "elite-dangerous";
                    }
                  ];
                  type = "string";
                }
                {
                  multiline = false;
                  parts = [
                    {
                      type = "text";
                      value = "mods";
                    }
                  ];
                  type = "string";
                }
                {
                  multiline = false;
                  parts = [
                    {
                      type = "text";
                      value = "interface";
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
            value = "edhm-ui";
          }
        ];
        type = "variable";
      };
      type = "package-import";
    }
  ];
  target = [
    "unknown"
    "edhm-ui"
  ];
}
