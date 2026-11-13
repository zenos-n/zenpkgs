{ ... }:
{
  dependenciesDeclared = false;
  descriptorVersion = "zenlang.semantic/2";
  grammarVersion = "1.0.0Na";
  id = "pkgs.unknown.freedroidrpg";
  imports = [ ];
  irVersion = "1.0.0Na";
  kind = "zpkg";
  location = "/nix/store/3ni594f60hm22hcrazxd35dmk7pwi61m-zenpkgs-dsl-source/pkgs/apps/gaming/freedroidrpg.zpkg:44:8";
  metadata = {
    description = {
      multiline = true;
      parts = [
        {
          type = "text";
          value = "\n    <para>\n      FreedroidRPG is an original isometric 3D role playing game\n      taking place in the future, on Earth. It features action and\n      dialogs.\n    </para>\n    <para>\n      The game tells the story of a world destroyed by a conflict between\n      robots and their human masters. Play as Tux in a quest to save the\n      world from the murderous rebel bots who know no mercy. You get to\n      choose which path you wish to follow, and freedom of choice is\n      everywhere in the game.\n    </para>\n    <para>\n      FreedroidRPG features a real time combat system with melee and\n      ranged weapons, fairly similar to the proprietary game Diablo.\n      There is an innovative system of programs that can be run in order\n      to take control of enemy robots, alter their behavior, or improve one's\n      characteristics. You can use over 50 different kinds of items and\n      fight countless enemies on your way to your destiny. An advanced\n      dialog system provides story background and immersive role\n      playing situations.\n    </para>\n    <para>\n      The game is complete, fully playable, and can provide about\n      12 hours of fun. It is still being actively developed, and\n      help is welcome in many areas. People having - or trying to acquire -\n      programming, map editing, or writing skills will find FreedroidRPG\n      to be an exciting, fast-moving project in which they can fully\n      express their creativity.\n    </para>\n  ";
        }
      ];
      type = "string";
    };
    id = {
      multiline = false;
      parts = [
        {
          type = "text";
          value = "unknown.freedroidrpg";
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
          value = "FreedroidRPG";
        }
      ];
      type = "string";
    };
    packageVersion = {
      multiline = false;
      parts = [
        {
          type = "text";
          value = "1.0";
        }
      ];
      type = "string";
    };
    summary = {
      multiline = false;
      parts = [
        {
          type = "text";
          value = "Isometric 3D RPG similar to game Diablo";
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
              value = "rpg";
            }
          ];
          type = "string";
        }
        {
          multiline = false;
          parts = [
            {
              type = "text";
              value = "isometric";
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
  name = "freedroidrpg";
  packageImport = {
    name = "pkgs";
    path = [
      {
        kind = "identifier";
        value = "legacy";
      }
      {
        kind = "identifier";
        value = "freedroidrpg";
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
          value = "freedroidrpg";
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
                  value = "unknown.freedroidrpg";
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
                  value = "FreedroidRPG";
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
                  value = "Isometric 3D RPG similar to game Diablo";
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
                  value = "\n    <para>\n      FreedroidRPG is an original isometric 3D role playing game\n      taking place in the future, on Earth. It features action and\n      dialogs.\n    </para>\n    <para>\n      The game tells the story of a world destroyed by a conflict between\n      robots and their human masters. Play as Tux in a quest to save the\n      world from the murderous rebel bots who know no mercy. You get to\n      choose which path you wish to follow, and freedom of choice is\n      everywhere in the game.\n    </para>\n    <para>\n      FreedroidRPG features a real time combat system with melee and\n      ranged weapons, fairly similar to the proprietary game Diablo.\n      There is an innovative system of programs that can be run in order\n      to take control of enemy robots, alter their behavior, or improve one's\n      characteristics. You can use over 50 different kinds of items and\n      fight countless enemies on your way to your destiny. An advanced\n      dialog system provides story background and immersive role\n      playing situations.\n    </para>\n    <para>\n      The game is complete, fully playable, and can provide about\n      12 hours of fun. It is still being actively developed, and\n      help is welcome in many areas. People having - or trying to acquire -\n      programming, map editing, or writing skills will find FreedroidRPG\n      to be an exciting, fast-moving project in which they can fully\n      express their creativity.\n    </para>\n  ";
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
                  value = "1.0";
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
                      value = "rpg";
                    }
                  ];
                  type = "string";
                }
                {
                  multiline = false;
                  parts = [
                    {
                      type = "text";
                      value = "isometric";
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
      package = {
        name = "pkgs";
        path = [
          {
            kind = "identifier";
            value = "legacy";
          }
          {
            kind = "identifier";
            value = "freedroidrpg";
          }
        ];
        type = "variable";
      };
      type = "package-import";
    }
  ];
  target = [
    "unknown"
    "freedroidrpg"
  ];
}
