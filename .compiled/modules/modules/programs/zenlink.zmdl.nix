{ config, lib, pkgs, maintainers ? lib.maintainers, licenses ? lib.licenses, ... }:
let
  cfg = config.zenos.programs.zenlink;
  name = "zenlink";
in
{
  options.zenos.programs.zenlink = lib.mkOption { type = (lib.types.submodule ({ ... }: { options = { autoStart = lib.mkOption { type = lib.types.bool; default = true; }; enable = lib.mkOption { type = lib.types.bool; default = false; }; package = lib.mkOption { type = lib.types.package; default = pkgs.zenos.byCategories.system.zenlink; }; }; })); default = { }; };
  config = lib.mkMerge [
    { _module.args.zenlang.descriptors.programs.zenlink = {
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
            value = "\n    Installs the native ZenLink desktop service and GNOME extension. Provides\n    the host virtual webcam and pairing ports. Streaming settings and live\n    camera/microphone selection belong to the Android app. Pairing and media\n    settings remain writable at runtime.\n  ";
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
      platforms = {
        name = "lib";
        path = [
          {
            kind = "identifier";
            value = "platforms";
          }
          {
            kind = "identifier";
            value = "zenos";
          }
        ];
        type = "variable";
      };
      summary = {
        multiline = false;
        parts = [
          {
            type = "text";
            value = "ZenLink phone integration";
          }
        ];
        type = "string";
      };
      zenosVersion = {
        kind = "version";
        type = "literal";
        value = "1.0.0Nb";
      };
    };
    moduleIdentity = "zenos.programs.zenlink";
    modulePath = [
      "programs"
      "zenlink"
    ];
    nodeMetadata = [
      {
        metadata = {
          description = {
            multiline = true;
            parts = [
              {
                type = "text";
                value = "\n    Installs the native ZenLink desktop service and GNOME extension. Provides\n    the host virtual webcam and pairing ports. Streaming settings and live\n    camera/microphone selection belong to the Android app. Pairing and media\n    settings remain writable at runtime.\n  ";
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
          platforms = {
            name = "lib";
            path = [
              {
                kind = "identifier";
                value = "platforms";
              }
              {
                kind = "identifier";
                value = "zenos";
              }
            ];
            type = "variable";
          };
          summary = {
            multiline = false;
            parts = [
              {
                type = "text";
                value = "ZenLink phone integration";
              }
            ];
            type = "string";
          };
          zenosVersion = {
            kind = "version";
            type = "literal";
            value = "1.0.0Nb";
          };
        };
        path = [ ];
      }
      {
        metadata = {
          summary = {
            multiline = false;
            parts = [
              {
                type = "text";
                value = "Enable ZenLink phone integration";
              }
            ];
            type = "string";
          };
          zenosVersion = {
            kind = "version";
            type = "literal";
            value = "1.0.0Nb";
          };
        };
        path = [
          "enable"
        ];
      }
      {
        metadata = {
          default = {
            name = "pkgs";
            path = [
              {
                kind = "identifier";
                value = "byCategories";
              }
              {
                kind = "identifier";
                value = "system";
              }
              {
                kind = "identifier";
                value = "zenlink";
              }
            ];
            type = "variable";
          };
          summary = {
            multiline = false;
            parts = [
              {
                type = "text";
                value = "ZenLink desktop package";
              }
            ];
            type = "string";
          };
          type = {
            name = "type";
            path = [
              {
                kind = "identifier";
                value = "package";
              }
            ];
            type = "variable";
          };
          zenosVersion = {
            kind = "version";
            type = "literal";
            value = "1.0.0Nb";
          };
        };
        path = [
          "package"
        ];
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
                value = "Start ZenLink with the graphical session";
              }
            ];
            type = "string";
          };
          type = {
            name = "type";
            path = [
              {
                kind = "identifier";
                value = "boolean";
              }
            ];
            type = "variable";
          };
          zenosVersion = {
            kind = "version";
            type = "literal";
            value = "1.0.0Nb";
          };
        };
        path = [
          "autoStart"
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
                value = "1.0.0Nb";
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
                    value = "ZenLink phone integration";
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
                    value = "\n    Installs the native ZenLink desktop service and GNOME extension. Provides\n    the host virtual webcam and pairing ports. Streaming settings and live\n    camera/microphone selection belong to the Android app. Pairing and media\n    settings remain writable at runtime.\n  ";
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
                    value = "gpl2Plus";
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
                    value = "zenos";
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
                          value = "summary";
                        }
                      ];
                      type = "assignment";
                      value = {
                        multiline = false;
                        parts = [
                          {
                            type = "text";
                            value = "Enable ZenLink phone integration";
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
                          value = "programs";
                        }
                        {
                          kind = "identifier";
                          value = "zenlink";
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
                          value = "environment";
                        }
                        {
                          kind = "identifier";
                          value = "systemPackages";
                        }
                      ];
                      type = "assignment";
                      value = {
                        items = [
                          {
                            name = "path";
                            path = [
                              {
                                kind = "identifier";
                                value = "package";
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
                guards = [ ];
                scope = "system";
                type = "action";
                unconditional = false;
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
                          value = "home";
                        }
                        {
                          kind = "identifier";
                          value = "packages";
                        }
                      ];
                      type = "assignment";
                      value = {
                        arguments = [
                          {
                            items = [
                              {
                                name = "path";
                                path = [
                                  {
                                    kind = "identifier";
                                    value = "package";
                                  }
                                ];
                                type = "variable";
                              }
                            ];
                            type = "list";
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
                          value = "dconf";
                        }
                        {
                          kind = "identifier";
                          value = "settings";
                        }
                        {
                          kind = "string";
                          value = "org/gnome/shell";
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
                                value = "enabled-extensions";
                              }
                            ];
                            type = "assignment";
                            value = {
                              arguments = [
                                {
                                  items = [
                                    {
                                      multiline = false;
                                      parts = [
                                        {
                                          type = "text";
                                          value = "zenlink@zenos-n.github.io";
                                        }
                                      ];
                                      type = "string";
                                    }
                                  ];
                                  type = "list";
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
                                value = "disabled-extensions";
                              }
                            ];
                            type = "assignment";
                            value = {
                              arguments = [
                                {
                                  items = [
                                    {
                                      multiline = false;
                                      parts = [
                                        {
                                          type = "text";
                                          value = "gsconnect@andyholmes.github.io";
                                        }
                                      ];
                                      type = "string";
                                    }
                                  ];
                                  type = "list";
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
                          value = "dconf";
                        }
                        {
                          kind = "identifier";
                          value = "settings";
                        }
                        {
                          kind = "string";
                          value = "org/zenos/zenlink";
                        }
                        {
                          kind = "identifier";
                          value = "enabled";
                        }
                      ];
                      type = "assignment";
                      value = {
                        name = "path";
                        path = [
                          {
                            kind = "identifier";
                            value = "autoStart";
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
                          value = "xdg";
                        }
                        {
                          kind = "identifier";
                          value = "dataFile";
                        }
                        {
                          kind = "string";
                          value = "dbus-1/services/org.zenos.ZenLink.service";
                        }
                        {
                          kind = "identifier";
                          value = "text";
                        }
                      ];
                      type = "assignment";
                      value = {
                        multiline = false;
                        parts = [
                          {
                            type = "text";
                            value = "[D-BUS Service]\nName=org.zenos.ZenLink\nExec=";
                          }
                          {
                            expression = {
                              name = "path";
                              path = [
                                {
                                  kind = "identifier";
                                  value = "package";
                                }
                              ];
                              type = "variable";
                            };
                            type = "interpolation";
                          }
                          {
                            type = "text";
                            value = "/bin/zenlink\nSystemdService=zenlink.service\n";
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
                          value = "systemd";
                        }
                        {
                          kind = "identifier";
                          value = "user";
                        }
                        {
                          kind = "identifier";
                          value = "services";
                        }
                        {
                          kind = "identifier";
                          value = "zenlink";
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
                                value = "Unit";
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
                                      value = "Description";
                                    }
                                  ];
                                  type = "assignment";
                                  value = {
                                    multiline = false;
                                    parts = [
                                      {
                                        type = "text";
                                        value = "ZenLink device service";
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
                                      value = "After";
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
                                            value = "graphical-session-pre.target";
                                          }
                                        ];
                                        type = "string";
                                      }
                                      {
                                        multiline = false;
                                        parts = [
                                          {
                                            type = "text";
                                            value = "pipewire.service";
                                          }
                                        ];
                                        type = "string";
                                      }
                                      {
                                        multiline = false;
                                        parts = [
                                          {
                                            type = "text";
                                            value = "pipewire-pulse.service";
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
                                      value = "PartOf";
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
                                            value = "graphical-session.target";
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
                          {
                            operator = "=";
                            target = [
                              {
                                kind = "identifier";
                                value = "Service";
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
                                      value = "Type";
                                    }
                                  ];
                                  type = "assignment";
                                  value = {
                                    multiline = false;
                                    parts = [
                                      {
                                        type = "text";
                                        value = "dbus";
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
                                      value = "BusName";
                                    }
                                  ];
                                  type = "assignment";
                                  value = {
                                    multiline = false;
                                    parts = [
                                      {
                                        type = "text";
                                        value = "org.zenos.ZenLink";
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
                                      value = "ExecStart";
                                    }
                                  ];
                                  type = "assignment";
                                  value = {
                                    multiline = false;
                                    parts = [
                                      {
                                        expression = {
                                          name = "path";
                                          path = [
                                            {
                                              kind = "identifier";
                                              value = "package";
                                            }
                                          ];
                                          type = "variable";
                                        };
                                        type = "interpolation";
                                      }
                                      {
                                        type = "text";
                                        value = "/bin/zenlink";
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
                                      value = "Restart";
                                    }
                                  ];
                                  type = "assignment";
                                  value = {
                                    multiline = false;
                                    parts = [
                                      {
                                        type = "text";
                                        value = "on-failure";
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
                                      value = "RestartSec";
                                    }
                                  ];
                                  type = "assignment";
                                  value = {
                                    multiline = false;
                                    parts = [
                                      {
                                        type = "text";
                                        value = "3s";
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
                            operator = "=";
                            target = [
                              {
                                kind = "identifier";
                                value = "Install";
                              }
                              {
                                kind = "identifier";
                                value = "WantedBy";
                              }
                            ];
                            type = "assignment";
                            value = {
                              condition = {
                                name = "path";
                                path = [
                                  {
                                    kind = "identifier";
                                    value = "autoStart";
                                  }
                                ];
                                type = "variable";
                              };
                              "else" = {
                                items = [ ];
                                type = "list";
                              };
                              "then" = {
                                items = [
                                  {
                                    multiline = false;
                                    parts = [
                                      {
                                        type = "text";
                                        value = "graphical-session.target";
                                      }
                                    ];
                                    type = "string";
                                  }
                                ];
                                type = "list";
                              };
                              type = "if";
                            };
                          }
                        ];
                        type = "attr-set";
                      };
                    }
                  ];
                  type = "attr-set";
                };
                guards = [ ];
                scope = "user";
                type = "action";
                unconditional = false;
              }
            ];
            type = "attr-set";
          };
          type = "enable-option";
        };
      }
      {
        operator = "=";
        target = [
          {
            kind = "identifier";
            value = "package";
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
                        value = "type";
                      }
                    ];
                    type = "assignment";
                    value = {
                      name = "type";
                      path = [
                        {
                          kind = "identifier";
                          value = "package";
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
                        value = "default";
                      }
                    ];
                    type = "assignment";
                    value = {
                      name = "pkgs";
                      path = [
                        {
                          kind = "identifier";
                          value = "byCategories";
                        }
                        {
                          kind = "identifier";
                          value = "system";
                        }
                        {
                          kind = "identifier";
                          value = "zenlink";
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
                        value = "summary";
                      }
                    ];
                    type = "assignment";
                    value = {
                      multiline = false;
                      parts = [
                        {
                          type = "text";
                          value = "ZenLink desktop package";
                        }
                      ];
                      type = "string";
                    };
                  }
                ];
                type = "attr-set";
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
            value = "autoStart";
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
                        value = "type";
                      }
                    ];
                    type = "assignment";
                    value = {
                      name = "type";
                      path = [
                        {
                          kind = "identifier";
                          value = "boolean";
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
                          value = "Start ZenLink with the graphical session";
                        }
                      ];
                      type = "string";
                    };
                  }
                ];
                type = "attr-set";
              };
            }
          ];
          type = "attr-set";
        };
      }
    ];
  }; }
    (lib.mkIf ((cfg.enable)) {
      programs.zenlink.enable = true;
      environment.systemPackages = [
        cfg.package
      ];
    })
    (lib.mkIf ((cfg.enable)) { home-manager.sharedModules = [ {
      home.packages = (lib.mkDefault [
        cfg.package
      ]);
      dconf.settings."org/gnome/shell" = {
        enabled-extensions = (lib.mkDefault [
          "zenlink@zenos-n.github.io"
        ]);
        disabled-extensions = (lib.mkDefault [
          "gsconnect@andyholmes.github.io"
        ]);
      };
      dconf.settings."org/zenos/zenlink".enabled = cfg.autoStart;
      xdg.dataFile."dbus-1/services/org.zenos.ZenLink.service".text = "[D-BUS Service]\nName=org.zenos.ZenLink\nExec=${((value: let kind = builtins.typeOf value; in if kind == "string" then value else if kind == "bool" || kind == "int" || kind == "float" then builtins.toJSON value else if kind == "path" then "${value}" else if kind == "set" && (value.type or null) == "derivation" && builtins.isString (value.outPath or null) then value.outPath else throw "/nix/store/59qqzf108ga8h2qmsjizzsn2p7i889xx-zenpkgs-dsl-source/modules/programs/zenlink.zmdl:29: string interpolation requires a scalar, path, or package") (cfg.package))}/bin/zenlink\nSystemdService=zenlink.service\n";
      systemd.user.services.zenlink = {
        Unit = {
          Description = "ZenLink device service";
          After = [
            "graphical-session-pre.target"
            "pipewire.service"
            "pipewire-pulse.service"
          ];
          PartOf = [
            "graphical-session.target"
          ];
        };
        Service = {
          Type = "dbus";
          BusName = "org.zenos.ZenLink";
          ExecStart = "${((value: let kind = builtins.typeOf value; in if kind == "string" then value else if kind == "bool" || kind == "int" || kind == "float" then builtins.toJSON value else if kind == "path" then "${value}" else if kind == "set" && (value.type or null) == "derivation" && builtins.isString (value.outPath or null) then value.outPath else throw "/nix/store/59qqzf108ga8h2qmsjizzsn2p7i889xx-zenpkgs-dsl-source/modules/programs/zenlink.zmdl:39: string interpolation requires a scalar, path, or package") (cfg.package))}/bin/zenlink";
          Restart = "on-failure";
          RestartSec = "3s";
        };
        Install.WantedBy = (if cfg.autoStart then [
          "graphical-session.target"
        ] else [ ]);
      };
    } ]; })
  ];
}
