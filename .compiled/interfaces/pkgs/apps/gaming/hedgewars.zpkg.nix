{ ... }:
{
  dependenciesDeclared = false;
  descriptorVersion = "zenlang.semantic/2";
  grammarVersion = "1.0.0Na";
  id = "pkgs.org.hedgewars.Hedgewars";
  imports = [ ];
  irVersion = "1.0.0Na";
  kind = "zpkg";
  location = "/nix/store/59qqzf108ga8h2qmsjizzsn2p7i889xx-zenpkgs-dsl-source/pkgs/apps/gaming/hedgewars.zpkg:36:8";
  metadata = {
    description = {
      multiline = true;
      parts = [
        {
          type = "text";
          value = "\n    Each player controls a team of several hedgehogs. During the course of\n    the game, players take turns with one of their hedgehogs. They then use\n    whatever tools and weapons are available to attack and kill the\n    opponents' hedgehogs, thereby winning the game. Hedgehogs may move\n    around the terrain in a variety of ways, normally by walking and jumping\n    but also by using particular tools such as the \"Rope\" or \"Parachute\", to\n    move to otherwise inaccessible areas. Each turn is time-limited to\n    ensure that players do not hold up the game with excessive thinking or\n    moving.\n\n    A large variety of tools and weapons are available for players during\n    the game: Grenade, Cluster Bomb, Bazooka, UFO, Homing Bee, Shotgun,\n    Desert Eagle, Fire Punch, Baseball Bat, Dynamite, Mine, Rope, Pneumatic\n    pick, Parachute. Most weapons, when used, cause explosions that deform\n    the terrain, removing circular chunks. The landscape is an island\n    floating on a body of water, or a restricted cave with water at the\n    bottom. A hedgehog dies when it enters the water (either by falling off\n    the island, or through a hole in the bottom of it), it is thrown off\n    either side of the arena or when its health is reduced, typically from\n    contact with explosions, to zero (the damage dealt to the attacked\n    hedgehog or hedgehogs after a player's or CPU turn is shown only when\n    all movement on the battlefield has ceased).\n  ";
        }
      ];
      type = "string";
    };
    id = {
      multiline = false;
      parts = [
        {
          type = "text";
          value = "org.hedgewars.Hedgewars";
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
          value = "Hedgewars";
        }
      ];
      type = "string";
    };
    packageVersion = {
      multiline = false;
      parts = [
        {
          type = "text";
          value = "1.0.3";
        }
      ];
      type = "string";
    };
    summary = {
      multiline = false;
      parts = [
        {
          type = "text";
          value = "Funny turn-based artillery game, featuring fighting hedgehogs";
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
              value = "artillery";
            }
          ];
          type = "string";
        }
        {
          multiline = false;
          parts = [
            {
              type = "text";
              value = "multiplayer";
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
  name = "hedgewars";
  packageImport = {
    name = "pkgs";
    path = [
      {
        kind = "identifier";
        value = "legacy";
      }
      {
        kind = "identifier";
        value = "hedgewars";
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
          value = "hedgewars";
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
                  value = "org.hedgewars.Hedgewars";
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
                  value = "Hedgewars";
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
                  value = "Funny turn-based artillery game, featuring fighting hedgehogs";
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
                  value = "\n    Each player controls a team of several hedgehogs. During the course of\n    the game, players take turns with one of their hedgehogs. They then use\n    whatever tools and weapons are available to attack and kill the\n    opponents' hedgehogs, thereby winning the game. Hedgehogs may move\n    around the terrain in a variety of ways, normally by walking and jumping\n    but also by using particular tools such as the \"Rope\" or \"Parachute\", to\n    move to otherwise inaccessible areas. Each turn is time-limited to\n    ensure that players do not hold up the game with excessive thinking or\n    moving.\n\n    A large variety of tools and weapons are available for players during\n    the game: Grenade, Cluster Bomb, Bazooka, UFO, Homing Bee, Shotgun,\n    Desert Eagle, Fire Punch, Baseball Bat, Dynamite, Mine, Rope, Pneumatic\n    pick, Parachute. Most weapons, when used, cause explosions that deform\n    the terrain, removing circular chunks. The landscape is an island\n    floating on a body of water, or a restricted cave with water at the\n    bottom. A hedgehog dies when it enters the water (either by falling off\n    the island, or through a hole in the bottom of it), it is thrown off\n    either side of the arena or when its health is reduced, typically from\n    contact with explosions, to zero (the damage dealt to the attacked\n    hedgehog or hedgehogs after a player's or CPU turn is shown only when\n    all movement on the battlefield has ceased).\n  ";
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
                  value = "1.0.3";
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
                      value = "artillery";
                    }
                  ];
                  type = "string";
                }
                {
                  multiline = false;
                  parts = [
                    {
                      type = "text";
                      value = "multiplayer";
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
            value = "hedgewars";
          }
        ];
        type = "variable";
      };
      type = "package-import";
    }
  ];
  target = [
    "org"
    "hedgewars"
    "Hedgewars"
  ];
}
