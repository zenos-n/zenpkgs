{ config, lib, pkgs, maintainers ? lib.maintainers, licenses ? lib.licenses, ... }:
let
  cfg = config.zenos.system.installed-base;
  name = "installed-base";
in
{
  options.zenos.system.installed-base = lib.mkOption { type = (lib.types.submodule ({ ... }: { options = { enable = lib.mkOption { type = lib.types.bool; default = true; }; }; })); default = { }; };
  config = lib.mkMerge [
    { _module.args.zenlang.descriptors.system.installed-base = {
    aliases = [ ];
    descriptorVersion = "zenlang.semantic/2";
    grammarVersion = "1.0.0Na";
    irVersion = "1.0.0Na";
    kind = "zmdl";
    metadata = {
      description = {
        multiline = true;
        parts = [
          {
            type = "text";
            value = "\n    Supplies conservative package, user, networking, audio, firmware, boot, and\n    GNOME login defaults shared by final and temporary OOBE installations.\n  ";
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
      platforms = {
        name = "lib";
        path = [
          {
            kind = "identifier";
            value = "platforms";
          }
          {
            kind = "identifier";
            value = "linux";
          }
        ];
        type = "variable";
      };
      summary = {
        multiline = false;
        parts = [
          {
            type = "text";
            value = "Reusable ZenOS installed-system baseline";
          }
        ];
        type = "string";
      };
      zenosVersion = {
        kind = "version";
        type = "literal";
        value = "1.0.0Na";
      };
    };
    moduleIdentity = "zenos.system.installed-base";
    modulePath = [
      "system"
      "installed-base"
    ];
    nodeMetadata = [
      {
        metadata = {
          description = {
            multiline = true;
            parts = [
              {
                type = "text";
                value = "\n    Supplies conservative package, user, networking, audio, firmware, boot, and\n    GNOME login defaults shared by final and temporary OOBE installations.\n  ";
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
          platforms = {
            name = "lib";
            path = [
              {
                kind = "identifier";
                value = "platforms";
              }
              {
                kind = "identifier";
                value = "linux";
              }
            ];
            type = "variable";
          };
          summary = {
            multiline = false;
            parts = [
              {
                type = "text";
                value = "Reusable ZenOS installed-system baseline";
              }
            ];
            type = "string";
          };
          zenosVersion = {
            kind = "version";
            type = "literal";
            value = "1.0.0Na";
          };
        };
        path = [ ];
      }
      {
        metadata = {
          default = {
            kind = "true";
            type = "literal";
            value = true;
          };
          summary = {
            multiline = false;
            parts = [
              {
                type = "text";
                value = "Apply the installed-system baseline";
              }
            ];
            type = "string";
          };
          zenosVersion = {
            kind = "version";
            type = "literal";
            value = "1.0.0Na";
          };
        };
        path = [
          "enable"
        ];
      }
    ];
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
                  value = "zenosVersion";
                }
              ];
              type = "assignment";
              value = {
                kind = "version";
                type = "literal";
                value = "1.0.0Na";
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
                    value = "Reusable ZenOS installed-system baseline";
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
                    value = "\n    Supplies conservative package, user, networking, audio, firmware, boot, and\n    GNOME login defaults shared by final and temporary OOBE installations.\n  ";
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
                name = "lib";
                path = [
                  {
                    kind = "identifier";
                    value = "platforms";
                  }
                  {
                    kind = "identifier";
                    value = "linux";
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
            value = "enable";
          }
        ];
        type = "assignment";
        value = {
          body = {
            recursive = false;
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
                          value = "default";
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
                          value = "summary";
                        }
                      ];
                      type = "assignment";
                      value = {
                        multiline = false;
                        parts = [
                          {
                            type = "text";
                            value = "Apply the installed-system baseline";
                          }
                        ];
                        type = "string";
                      };
                    }
                  ];
                  type = "attr-set";
                };
              }
              {
                body = {
                  recursive = false;
                  statements = [
                    {
                      operator = "=";
                      target = [
                        {
                          kind = "identifier";
                          value = "nixpkgs";
                        }
                        {
                          kind = "identifier";
                          value = "config";
                        }
                        {
                          kind = "identifier";
                          value = "allowUnfree";
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
                          value = "users";
                        }
                        {
                          kind = "identifier";
                          value = "mutableUsers";
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
                          value = "system";
                        }
                        {
                          kind = "identifier";
                          value = "stateVersion";
                        }
                      ];
                      type = "assignment";
                      value = {
                        multiline = false;
                        parts = [
                          {
                            type = "text";
                            value = "26.05";
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
                          value = "nix";
                        }
                        {
                          kind = "identifier";
                          value = "settings";
                        }
                        {
                          kind = "identifier";
                          value = "experimental-features";
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
                                value = "nix-command";
                              }
                            ];
                            type = "string";
                          }
                          {
                            multiline = false;
                            parts = [
                              {
                                type = "text";
                                value = "flakes";
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
                          value = "networking";
                        }
                        {
                          kind = "identifier";
                          value = "networkmanager";
                        }
                        {
                          kind = "identifier";
                          value = "enable";
                        }
                      ];
                      type = "assignment";
                      value = {
                        arguments = [
                          {
                            kind = "true";
                            type = "literal";
                            value = true;
                          }
                        ];
                        callee = {
                          name = "lib";
                          path = [
                            {
                              kind = "identifier";
                              value = "mkDefault";
                            }
                          ];
                          type = "variable";
                        };
                        type = "call";
                      };
                    }
                    {
                      operator = "=";
                      target = [
                        {
                          kind = "identifier";
                          value = "security";
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
                                value = "rtkit";
                              }
                              {
                                kind = "identifier";
                                value = "enable";
                              }
                            ];
                            type = "assignment";
                            value = {
                              arguments = [
                                {
                                  kind = "true";
                                  type = "literal";
                                  value = true;
                                }
                              ];
                              callee = {
                                name = "lib";
                                path = [
                                  {
                                    kind = "identifier";
                                    value = "mkDefault";
                                  }
                                ];
                                type = "variable";
                              };
                              type = "call";
                            };
                          }
                          {
                            operator = "=";
                            target = [
                              {
                                kind = "identifier";
                                value = "sudo";
                              }
                              {
                                kind = "identifier";
                                value = "wheelNeedsPassword";
                              }
                            ];
                            type = "assignment";
                            value = {
                              operand = {
                                name = "cfg";
                                path = [
                                  {
                                    kind = "identifier";
                                    value = "system";
                                  }
                                  {
                                    kind = "identifier";
                                    value = "oobeMode";
                                  }
                                ];
                                type = "variable";
                              };
                              operator = "!";
                              type = "unary";
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
                          value = "services";
                        }
                        {
                          kind = "identifier";
                          value = "pipewire";
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
                                value = "enable";
                              }
                            ];
                            type = "assignment";
                            value = {
                              arguments = [
                                {
                                  kind = "true";
                                  type = "literal";
                                  value = true;
                                }
                              ];
                              callee = {
                                name = "lib";
                                path = [
                                  {
                                    kind = "identifier";
                                    value = "mkDefault";
                                  }
                                ];
                                type = "variable";
                              };
                              type = "call";
                            };
                          }
                          {
                            operator = "=";
                            target = [
                              {
                                kind = "identifier";
                                value = "alsa";
                              }
                              {
                                kind = "identifier";
                                value = "enable";
                              }
                            ];
                            type = "assignment";
                            value = {
                              arguments = [
                                {
                                  kind = "true";
                                  type = "literal";
                                  value = true;
                                }
                              ];
                              callee = {
                                name = "lib";
                                path = [
                                  {
                                    kind = "identifier";
                                    value = "mkDefault";
                                  }
                                ];
                                type = "variable";
                              };
                              type = "call";
                            };
                          }
                          {
                            operator = "=";
                            target = [
                              {
                                kind = "identifier";
                                value = "pulse";
                              }
                              {
                                kind = "identifier";
                                value = "enable";
                              }
                            ];
                            type = "assignment";
                            value = {
                              arguments = [
                                {
                                  kind = "true";
                                  type = "literal";
                                  value = true;
                                }
                              ];
                              callee = {
                                name = "lib";
                                path = [
                                  {
                                    kind = "identifier";
                                    value = "mkDefault";
                                  }
                                ];
                                type = "variable";
                              };
                              type = "call";
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
                          value = "programs";
                        }
                        {
                          kind = "identifier";
                          value = "dconf";
                        }
                        {
                          kind = "identifier";
                          value = "enable";
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
                          value = "hardware";
                        }
                        {
                          kind = "identifier";
                          value = "enableRedistributableFirmware";
                        }
                      ];
                      type = "assignment";
                      value = {
                        arguments = [
                          {
                            kind = "true";
                            type = "literal";
                            value = true;
                          }
                        ];
                        callee = {
                          name = "lib";
                          path = [
                            {
                              kind = "identifier";
                              value = "mkDefault";
                            }
                          ];
                          type = "variable";
                        };
                        type = "call";
                      };
                    }
                    {
                      operator = "=";
                      target = [
                        {
                          kind = "identifier";
                          value = "systemd";
                        }
                        {
                          kind = "identifier";
                          value = "tmpfiles";
                        }
                        {
                          kind = "identifier";
                          value = "rules";
                        }
                      ];
                      type = "assignment";
                      value = {
                        condition = {
                          type = "group";
                          value = {
                            default = {
                              kind = "false";
                              type = "literal";
                              value = false;
                            };
                            type = "default";
                            value = {
                              name = "cfg";
                              path = [
                                {
                                  kind = "identifier";
                                  value = "desktops";
                                }
                                {
                                  kind = "identifier";
                                  value = "gnome";
                                }
                                {
                                  kind = "identifier";
                                  value = "enable";
                                }
                              ];
                              type = "variable";
                            };
                          };
                        };
                        "else" = {
                          items = [ ];
                          type = "list";
                        };
                        "then" = {
                          left = {
                            items = [
                              {
                                multiline = false;
                                parts = [
                                  {
                                    type = "text";
                                    value = "d /var/lib/AccountsService/users 0755 root root -";
                                  }
                                ];
                                type = "string";
                              }
                            ];
                            type = "list";
                          };
                          operator = "++";
                          right = {
                            type = "group";
                            value = {
                              arguments = [
                                {
                                  items = [
                                    {
                                      multiline = false;
                                      parts = [
                                        {
                                          type = "text";
                                          value = "gdm-greeter";
                                        }
                                      ];
                                      type = "string";
                                    }
                                    {
                                      multiline = false;
                                      parts = [
                                        {
                                          type = "text";
                                          value = "gdm-greeter-2";
                                        }
                                      ];
                                      type = "string";
                                    }
                                    {
                                      multiline = false;
                                      parts = [
                                        {
                                          type = "text";
                                          value = "gdm-greeter-3";
                                        }
                                      ];
                                      type = "string";
                                    }
                                    {
                                      multiline = false;
                                      parts = [
                                        {
                                          type = "text";
                                          value = "gdm-greeter-4";
                                        }
                                      ];
                                      type = "string";
                                    }
                                    {
                                      multiline = false;
                                      parts = [
                                        {
                                          type = "text";
                                          value = "gdm-greeter-5";
                                        }
                                      ];
                                      type = "string";
                                    }
                                  ];
                                  type = "list";
                                }
                              ];
                              callee = {
                                arguments = [
                                  {
                                    type = "group";
                                    value = {
                                      body = {
                                        multiline = false;
                                        parts = [
                                          {
                                            type = "text";
                                            value = "f+ /var/lib/AccountsService/users/";
                                          }
                                          {
                                            expression = {
                                              path = [
                                                {
                                                  kind = "identifier";
                                                  value = "user";
                                                }
                                              ];
                                              type = "reference";
                                            };
                                            type = "interpolation";
                                          }
                                          {
                                            type = "text";
                                            value = " 0644 root root - [User]\\nSystemAccount=true\\n";
                                          }
                                        ];
                                        type = "string";
                                      };
                                      form = "identifier";
                                      parameters = [
                                        {
                                          default = null;
                                          name = "user";
                                          variadic = false;
                                        }
                                      ];
                                      type = "lambda";
                                    };
                                  }
                                ];
                                callee = {
                                  name = "lib";
                                  path = [
                                    {
                                      kind = "identifier";
                                      value = "map";
                                    }
                                  ];
                                  type = "variable";
                                };
                                type = "call";
                              };
                              type = "call";
                            };
                          };
                          type = "binary";
                        };
                        type = "if";
                      };
                    }
                  ];
                  type = "attr-set";
                };
                guards = [ ];
                scope = "system";
                type = "action";
                unconditional = false;
              }
            ];
            type = "attr-set";
          };
          type = "enable-option";
        };
      }
    ];
  }; }
    (lib.mkIf ((cfg.enable)) {
      nixpkgs.config.allowUnfree = true;
      users.mutableUsers = false;
      system.stateVersion = "26.05";
      nix.settings.experimental-features = [
        "nix-command"
        "flakes"
      ];
      networking.networkmanager.enable = (lib.mkDefault true);
      security = {
        rtkit.enable = (lib.mkDefault true);
        sudo.wheelNeedsPassword = (!config.zenos.system.oobeMode);
      };
      services.pipewire = {
        enable = (lib.mkDefault true);
        alsa.enable = (lib.mkDefault true);
        pulse.enable = (lib.mkDefault true);
      };
      programs.dconf.enable = true;
      hardware.enableRedistributableFirmware = (lib.mkDefault true);
      systemd.tmpfiles.rules = (if ((config.zenos.desktops.gnome.enable or false)) then ([
        "d /var/lib/AccountsService/users 0755 root root -"
      ] ++ (((lib.map ((user: "f+ /var/lib/AccountsService/users/${((value: let kind = builtins.typeOf value; in if kind == "string" then value else if kind == "bool" || kind == "int" || kind == "float" then builtins.toJSON value else if kind == "path" then "${value}" else if kind == "set" && (value.type or null) == "derivation" && builtins.isString (value.outPath or null) then value.outPath else throw "/nix/store/3ni594f60hm22hcrazxd35dmk7pwi61m-zenpkgs-dsl-source/modules/system/installed-base.zmdl:43: string interpolation requires a scalar, path, or package") (user))} 0644 root root - [User]\\nSystemAccount=true\\n"))) [
        "gdm-greeter"
        "gdm-greeter-2"
        "gdm-greeter-3"
        "gdm-greeter-4"
        "gdm-greeter-5"
      ]))) else [ ]);
    })
  ];
}
