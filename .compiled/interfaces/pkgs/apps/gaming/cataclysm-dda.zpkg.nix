{ ... }:
{
  dependenciesDeclared = false;
  descriptorVersion = "zenlang.semantic/2";
  grammarVersion = "1.0.0Na";
  id = "pkgs.unknown.cataclysm-dda";
  imports = [ ];
  irVersion = "1.0.0Na";
  kind = "zpkg";
  location = "/nix/store/59qqzf108ga8h2qmsjizzsn2p7i889xx-zenpkgs-dsl-source/pkgs/apps/gaming/cataclysm-dda.zpkg:35:8";
  metadata = {
    description = {
      multiline = true;
      parts = [
        {
          type = "text";
          value = "\n    Cataclysm: Dark Days Ahead is a roguelike set in a post-apocalyptic world.\n    Surviving is difficult: you have been thrown, ill-equipped, into a\n    landscape now riddled with monstrosities of which flesh eating zombies are\n    neither the strangest nor the deadliest.\n\n    Yet with care and a little luck, many things are possible. You may try to\n    eke out an existence in the forests silently executing threats and\n    providing sustenance with your longbow. You can ride into town in a\n    jerry-rigged vehicle, all guns blazing, to settle matters in a fug of\n    smoke from your molotovs. You could take a more measured approach and\n    construct an impregnable fortress, surrounded by traps to protect you from\n    the horrors without. The longer you survive, the more skilled and adapted\n    you will get and the better equipped and armed to deal with the threats\n    you are presented with.\n\n    In the course of your ordeal there will be opportunities and temptations\n    to improve or change your very nature. There are tales of survivors fitted\n    with extraordinary cybernetics giving great power and stories too of\n    gravely mutated survivors who, warped by their ingestion of exotic\n    substances or radiation, now more closely resemble insects, birds or fish\n    than their original form.\n  ";
        }
      ];
      type = "string";
    };
    id = {
      multiline = false;
      parts = [
        {
          type = "text";
          value = "unknown.cataclysm-dda";
        }
      ];
      type = "string";
    };
    license = {
      name = "l";
      path = [
        {
          kind = "identifier";
          value = "cc-by-sa-30";
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
          value = "Cataclysm: Dark Days Ahead";
        }
      ];
      type = "string";
    };
    packageVersion = {
      multiline = false;
      parts = [
        {
          type = "text";
          value = "0.H-2025-07-10-0402";
        }
      ];
      type = "string";
    };
    summary = {
      multiline = false;
      parts = [
        {
          type = "text";
          value = "Free, post apocalyptic, zombie infested rogue-like";
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
              value = "roguelike";
            }
          ];
          type = "string";
        }
        {
          multiline = false;
          parts = [
            {
              type = "text";
              value = "rpg";
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
  name = "cataclysm-dda";
  packageImport = {
    name = "pkgs";
    path = [
      {
        kind = "identifier";
        value = "legacy";
      }
      {
        kind = "identifier";
        value = "cataclysm-dda";
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
          value = "cataclysm-dda";
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
                  value = "unknown.cataclysm-dda";
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
                  value = "Cataclysm: Dark Days Ahead";
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
                  value = "Free, post apocalyptic, zombie infested rogue-like";
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
                  value = "\n    Cataclysm: Dark Days Ahead is a roguelike set in a post-apocalyptic world.\n    Surviving is difficult: you have been thrown, ill-equipped, into a\n    landscape now riddled with monstrosities of which flesh eating zombies are\n    neither the strangest nor the deadliest.\n\n    Yet with care and a little luck, many things are possible. You may try to\n    eke out an existence in the forests silently executing threats and\n    providing sustenance with your longbow. You can ride into town in a\n    jerry-rigged vehicle, all guns blazing, to settle matters in a fug of\n    smoke from your molotovs. You could take a more measured approach and\n    construct an impregnable fortress, surrounded by traps to protect you from\n    the horrors without. The longer you survive, the more skilled and adapted\n    you will get and the better equipped and armed to deal with the threats\n    you are presented with.\n\n    In the course of your ordeal there will be opportunities and temptations\n    to improve or change your very nature. There are tales of survivors fitted\n    with extraordinary cybernetics giving great power and stories too of\n    gravely mutated survivors who, warped by their ingestion of exotic\n    substances or radiation, now more closely resemble insects, birds or fish\n    than their original form.\n  ";
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
                  value = "0.H-2025-07-10-0402";
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
                      value = "roguelike";
                    }
                  ];
                  type = "string";
                }
                {
                  multiline = false;
                  parts = [
                    {
                      type = "text";
                      value = "rpg";
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
                  value = "cc-by-sa-30";
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
            value = "cataclysm-dda";
          }
        ];
        type = "variable";
      };
      type = "package-import";
    }
  ];
  target = [
    "unknown"
    "cataclysm-dda"
  ];
}
