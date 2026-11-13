{ config, lib, pkgs, maintainers ? lib.maintainers, licenses ? lib.licenses, ... }:
let
  cfg = config.zenos.system.boot.loader.zenboot;
  name = "zenboot";
in
{
  options.zenos.system.boot.loader.zenboot = lib.mkOption { type = (lib.types.submodule ({ ... }: { options = { distroName = lib.mkOption { type = lib.types.str; default = "ZenOS"; }; enable = lib.mkOption { type = lib.types.bool; default = false; }; enable_mouse = lib.mkOption { type = lib.types.bool; default = true; }; extraConfig = lib.mkOption { type = lib.types.str; default = ""; }; extraIncludedFiles = lib.mkOption { type = (lib.types.either (lib.types.enum [ null ]) (lib.types.attrsOf lib.types.path)); default = null; }; maxGenerations = lib.mkOption { type = lib.types.int; default = 10; }; osIcon = lib.mkOption { type = (lib.types.enum [
  "zenos"
  "freebsd"
  "usb"
  "unknown"
  "android"
  "arch"
  "windows"
  "mac"
]); default = "zenos"; }; plymouth = lib.mkOption { type = (lib.types.submodule ({ ... }: { options = { color = lib.mkOption { type = lib.types.str; default = "C532FF"; description = "Six hexadecimal digits without a leading hash sign."; }; enable = lib.mkOption { type = lib.types.bool; default = false; }; }; })); default = { }; }; resolution = lib.mkOption { type = lib.types.str; default = "max"; }; scannedDevices = lib.mkOption { type = (lib.types.listOf (lib.types.enum [
  "internal"
  "external"
  "optical"
  "netboot"
  "hdbios"
  "biosexternal"
  "cd"
  "manual"
  "firmware"
])); default = [
  "external"
  "optical"
  "manual"
]; }; timeout = lib.mkOption { type = lib.types.int; default = 5; }; use_nvram = lib.mkOption { type = lib.types.bool; default = false; }; }; })); default = { }; };
  config = lib.mkMerge [
    { _module.args.zenlang.descriptors.system.boot.loader.zenboot = {
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
            value = "\n    Configures ZenBoot, EFI installation, generation retention, mouse support,\n    activation, and optional ZenOS Plymouth integration.\n  ";
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
            value = "ZenOS ZenBoot bootloader configuration";
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
    moduleIdentity = "zenos.system.boot.loader.zenboot";
    modulePath = [
      "system"
      "boot"
      "loader"
      "zenboot"
    ];
    nodeMetadata = [
      {
        metadata = {
          description = {
            multiline = true;
            parts = [
              {
                type = "text";
                value = "\n    Configures ZenBoot, EFI installation, generation retention, mouse support,\n    activation, and optional ZenOS Plymouth integration.\n  ";
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
                value = "ZenOS ZenBoot bootloader configuration";
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
          summary = {
            multiline = false;
            parts = [
              {
                type = "text";
                value = "Enable ZenBoot";
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
      {
        metadata = {
          zenosVersion = {
            kind = "version";
            type = "literal";
            value = "1.0.0Na";
          };
        };
        path = [
          "plymouth"
        ];
      }
      {
        metadata = {
          default = {
            kind = "false";
            type = "literal";
            value = false;
          };
          summary = {
            multiline = false;
            parts = [
              {
                type = "text";
                value = "Enable the ZenOS Plymouth theme";
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
            value = "1.0.0Na";
          };
        };
        path = [
          "plymouth"
          "enable"
        ];
      }
      {
        metadata = {
          default = {
            multiline = false;
            parts = [
              {
                type = "text";
                value = "C532FF";
              }
            ];
            type = "string";
          };
          description = {
            multiline = true;
            parts = [
              {
                type = "text";
                value = "Six hexadecimal digits without a leading hash sign.";
              }
            ];
            type = "string";
          };
          summary = {
            multiline = false;
            parts = [
              {
                type = "text";
                value = "Boot animation glow color";
              }
            ];
            type = "string";
          };
          type = {
            name = "type";
            path = [
              {
                kind = "identifier";
                value = "string";
              }
            ];
            type = "variable";
          };
          zenosVersion = {
            kind = "version";
            type = "literal";
            value = "1.0.0Na";
          };
        };
        path = [
          "plymouth"
          "color"
        ];
      }
      {
        metadata = {
          default = {
            multiline = false;
            parts = [
              {
                type = "text";
                value = "zenos";
              }
            ];
            type = "string";
          };
          summary = {
            multiline = false;
            parts = [
              {
                type = "text";
                value = "Boot menu operating-system icon";
              }
            ];
            type = "string";
          };
          type = {
            arguments = [
              {
                items = [
                  {
                    multiline = false;
                    parts = [
                      {
                        type = "text";
                        value = "zenos";
                      }
                    ];
                    type = "string";
                  }
                  {
                    multiline = false;
                    parts = [
                      {
                        type = "text";
                        value = "freebsd";
                      }
                    ];
                    type = "string";
                  }
                  {
                    multiline = false;
                    parts = [
                      {
                        type = "text";
                        value = "usb";
                      }
                    ];
                    type = "string";
                  }
                  {
                    multiline = false;
                    parts = [
                      {
                        type = "text";
                        value = "unknown";
                      }
                    ];
                    type = "string";
                  }
                  {
                    multiline = false;
                    parts = [
                      {
                        type = "text";
                        value = "android";
                      }
                    ];
                    type = "string";
                  }
                  {
                    multiline = false;
                    parts = [
                      {
                        type = "text";
                        value = "arch";
                      }
                    ];
                    type = "string";
                  }
                  {
                    multiline = false;
                    parts = [
                      {
                        type = "text";
                        value = "windows";
                      }
                    ];
                    type = "string";
                  }
                  {
                    multiline = false;
                    parts = [
                      {
                        type = "text";
                        value = "mac";
                      }
                    ];
                    type = "string";
                  }
                ];
                type = "list";
              }
            ];
            callee = {
              name = "type";
              path = [
                {
                  kind = "identifier";
                  value = "enum";
                }
              ];
              type = "variable";
            };
            type = "call";
          };
          zenosVersion = {
            kind = "version";
            type = "literal";
            value = "1.0.0Na";
          };
        };
        path = [
          "osIcon"
        ];
      }
      {
        metadata = {
          default = {
            multiline = false;
            parts = [
              {
                type = "text";
                value = "ZenOS";
              }
            ];
            type = "string";
          };
          summary = {
            multiline = false;
            parts = [
              {
                type = "text";
                value = "Distribution name";
              }
            ];
            type = "string";
          };
          type = {
            name = "type";
            path = [
              {
                kind = "identifier";
                value = "string";
              }
            ];
            type = "variable";
          };
          zenosVersion = {
            kind = "version";
            type = "literal";
            value = "1.0.0Na";
          };
        };
        path = [
          "distroName"
        ];
      }
      {
        metadata = {
          default = {
            multiline = false;
            parts = [
              {
                type = "text";
                value = "max";
              }
            ];
            type = "string";
          };
          summary = {
            multiline = false;
            parts = [
              {
                type = "text";
                value = "Boot menu screen resolution";
              }
            ];
            type = "string";
          };
          type = {
            name = "type";
            path = [
              {
                kind = "identifier";
                value = "string";
              }
            ];
            type = "variable";
          };
          zenosVersion = {
            kind = "version";
            type = "literal";
            value = "1.0.0Na";
          };
        };
        path = [
          "resolution"
        ];
      }
      {
        metadata = {
          default = {
            kind = "integer";
            type = "literal";
            value = 5;
          };
          summary = {
            multiline = false;
            parts = [
              {
                type = "text";
                value = "Boot menu timeout in seconds";
              }
            ];
            type = "string";
          };
          type = {
            name = "type";
            path = [
              {
                kind = "identifier";
                value = "int";
              }
            ];
            type = "variable";
          };
          zenosVersion = {
            kind = "version";
            type = "literal";
            value = "1.0.0Na";
          };
        };
        path = [
          "timeout"
        ];
      }
      {
        metadata = {
          default = {
            kind = "integer";
            type = "literal";
            value = 10;
          };
          summary = {
            multiline = false;
            parts = [
              {
                type = "text";
                value = "Generations included in the boot menu";
              }
            ];
            type = "string";
          };
          type = {
            name = "type";
            path = [
              {
                kind = "identifier";
                value = "int";
              }
            ];
            type = "variable";
          };
          zenosVersion = {
            kind = "version";
            type = "literal";
            value = "1.0.0Na";
          };
        };
        path = [
          "maxGenerations"
        ];
      }
      {
        metadata = {
          default = {
            kind = "false";
            type = "literal";
            value = false;
          };
          summary = {
            multiline = false;
            parts = [
              {
                type = "text";
                value = "Write boot variables to NVRAM";
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
            value = "1.0.0Na";
          };
        };
        path = [
          "use_nvram"
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
                value = "Enable boot menu mouse support";
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
            value = "1.0.0Na";
          };
        };
        path = [
          "enable_mouse"
        ];
      }
      {
        metadata = {
          default = {
            items = [
              {
                multiline = false;
                parts = [
                  {
                    type = "text";
                    value = "external";
                  }
                ];
                type = "string";
              }
              {
                multiline = false;
                parts = [
                  {
                    type = "text";
                    value = "optical";
                  }
                ];
                type = "string";
              }
              {
                multiline = false;
                parts = [
                  {
                    type = "text";
                    value = "manual";
                  }
                ];
                type = "string";
              }
            ];
            type = "list";
          };
          summary = {
            multiline = false;
            parts = [
              {
                type = "text";
                value = "Device types scanned by ZenBoot";
              }
            ];
            type = "string";
          };
          type = {
            arguments = [
              {
                items = [
                  {
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
                                  value = "internal";
                                }
                              ];
                              type = "string";
                            }
                            {
                              multiline = false;
                              parts = [
                                {
                                  type = "text";
                                  value = "external";
                                }
                              ];
                              type = "string";
                            }
                            {
                              multiline = false;
                              parts = [
                                {
                                  type = "text";
                                  value = "optical";
                                }
                              ];
                              type = "string";
                            }
                            {
                              multiline = false;
                              parts = [
                                {
                                  type = "text";
                                  value = "netboot";
                                }
                              ];
                              type = "string";
                            }
                            {
                              multiline = false;
                              parts = [
                                {
                                  type = "text";
                                  value = "hdbios";
                                }
                              ];
                              type = "string";
                            }
                            {
                              multiline = false;
                              parts = [
                                {
                                  type = "text";
                                  value = "biosexternal";
                                }
                              ];
                              type = "string";
                            }
                            {
                              multiline = false;
                              parts = [
                                {
                                  type = "text";
                                  value = "cd";
                                }
                              ];
                              type = "string";
                            }
                            {
                              multiline = false;
                              parts = [
                                {
                                  type = "text";
                                  value = "manual";
                                }
                              ];
                              type = "string";
                            }
                            {
                              multiline = false;
                              parts = [
                                {
                                  type = "text";
                                  value = "firmware";
                                }
                              ];
                              type = "string";
                            }
                          ];
                          type = "list";
                        }
                      ];
                      callee = {
                        name = "type";
                        path = [
                          {
                            kind = "identifier";
                            value = "enum";
                          }
                        ];
                        type = "variable";
                      };
                      type = "call";
                    };
                  }
                ];
                type = "list";
              }
            ];
            callee = {
              name = "type";
              path = [
                {
                  kind = "identifier";
                  value = "list";
                }
              ];
              type = "variable";
            };
            type = "call";
          };
          zenosVersion = {
            kind = "version";
            type = "literal";
            value = "1.0.0Na";
          };
        };
        path = [
          "scannedDevices"
        ];
      }
      {
        metadata = {
          default = {
            multiline = false;
            parts = [ ];
            type = "string";
          };
          summary = {
            multiline = false;
            parts = [
              {
                type = "text";
                value = "Additional refind.conf lines";
              }
            ];
            type = "string";
          };
          type = {
            name = "type";
            path = [
              {
                kind = "identifier";
                value = "string";
              }
            ];
            type = "variable";
          };
          zenosVersion = {
            kind = "version";
            type = "literal";
            value = "1.0.0Na";
          };
        };
        path = [
          "extraConfig"
        ];
      }
      {
        metadata = {
          default = {
            kind = "null";
            type = "literal";
            value = null;
          };
          summary = {
            multiline = false;
            parts = [
              {
                type = "text";
                value = "Additional boot configuration files";
              }
            ];
            type = "string";
          };
          type = {
            arguments = [
              {
                items = [
                  {
                    name = "type";
                    path = [
                      {
                        kind = "identifier";
                        value = "null";
                      }
                    ];
                    type = "variable";
                  }
                  {
                    type = "group";
                    value = {
                      arguments = [
                        {
                          items = [
                            {
                              name = "type";
                              path = [
                                {
                                  kind = "identifier";
                                  value = "path";
                                }
                              ];
                              type = "variable";
                            }
                          ];
                          type = "list";
                        }
                      ];
                      callee = {
                        name = "type";
                        path = [
                          {
                            kind = "identifier";
                            value = "set";
                          }
                        ];
                        type = "variable";
                      };
                      type = "call";
                    };
                  }
                ];
                type = "list";
              }
            ];
            callee = {
              name = "type";
              path = [
                {
                  kind = "identifier";
                  value = "either";
                }
              ];
              type = "variable";
            };
            type = "call";
          };
          zenosVersion = {
            kind = "version";
            type = "literal";
            value = "1.0.0Na";
          };
        };
        path = [
          "extraIncludedFiles"
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
                    value = "ZenOS ZenBoot bootloader configuration";
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
                    value = "\n    Configures ZenBoot, EFI installation, generation retention, mouse support,\n    activation, and optional ZenOS Plymouth integration.\n  ";
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
                            value = "Enable ZenBoot";
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
                          value = "boot";
                        }
                        {
                          kind = "identifier";
                          value = "loader";
                        }
                        {
                          kind = "identifier";
                          value = "grub";
                        }
                        {
                          kind = "identifier";
                          value = "enable";
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
                          value = "boot";
                        }
                        {
                          kind = "identifier";
                          value = "loader";
                        }
                        {
                          kind = "identifier";
                          value = "systemd-boot";
                        }
                        {
                          kind = "identifier";
                          value = "enable";
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
                          value = "assertions";
                        }
                      ];
                      type = "assignment";
                      value = {
                        items = [
                          {
                            recursive = false;
                            statements = [
                              {
                                operator = "=";
                                target = [
                                  {
                                    kind = "identifier";
                                    value = "assertion";
                                  }
                                ];
                                type = "assignment";
                                value = {
                                  left = {
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
                                            value = "system";
                                          }
                                          {
                                            kind = "identifier";
                                            value = "boot";
                                          }
                                          {
                                            kind = "identifier";
                                            value = "loader";
                                          }
                                          {
                                            kind = "identifier";
                                            value = "efi";
                                          }
                                          {
                                            kind = "identifier";
                                            value = "canTouchEfiVariables";
                                          }
                                        ];
                                        type = "variable";
                                      };
                                    };
                                  };
                                  operator = "||";
                                  right = {
                                    type = "group";
                                    value = {
                                      operand = {
                                        name = "path";
                                        path = [
                                          {
                                            kind = "identifier";
                                            value = "use_nvram";
                                          }
                                        ];
                                        type = "variable";
                                      };
                                      operator = "!";
                                      type = "unary";
                                    };
                                  };
                                  type = "binary";
                                };
                              }
                              {
                                operator = "=";
                                target = [
                                  {
                                    kind = "identifier";
                                    value = "message";
                                  }
                                ];
                                type = "assignment";
                                value = {
                                  multiline = false;
                                  parts = [
                                    {
                                      type = "text";
                                      value = "ZenBoot: 'use_nvram' requires EFI variable access.";
                                    }
                                  ];
                                  type = "string";
                                };
                              }
                            ];
                            type = "attr-set";
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
                            type = "group";
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
                                          value = "resolution";
                                        }
                                      ];
                                      type = "assignment";
                                      value = {
                                        name = "path";
                                        path = [
                                          {
                                            kind = "identifier";
                                            value = "resolution";
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
                                          value = "scannedDevices";
                                        }
                                      ];
                                      type = "assignment";
                                      value = {
                                        name = "path";
                                        path = [
                                          {
                                            kind = "identifier";
                                            value = "scannedDevices";
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
                                          value = "extraIncludedFiles";
                                        }
                                      ];
                                      type = "assignment";
                                      value = {
                                        name = "path";
                                        path = [
                                          {
                                            kind = "identifier";
                                            value = "extraIncludedFiles";
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
                                          value = "extraConfig";
                                        }
                                      ];
                                      type = "assignment";
                                      value = {
                                        name = "path";
                                        path = [
                                          {
                                            kind = "identifier";
                                            value = "extraConfig";
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
                                          value = "timeout";
                                        }
                                      ];
                                      type = "assignment";
                                      value = {
                                        name = "path";
                                        path = [
                                          {
                                            kind = "identifier";
                                            value = "timeout";
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
                                          value = "use_nvram";
                                        }
                                      ];
                                      type = "assignment";
                                      value = {
                                        name = "path";
                                        path = [
                                          {
                                            kind = "identifier";
                                            value = "use_nvram";
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
                                          value = "enable_mouse";
                                        }
                                      ];
                                      type = "assignment";
                                      value = {
                                        name = "path";
                                        path = [
                                          {
                                            kind = "identifier";
                                            value = "enable_mouse";
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
                                          value = "maxGenerations";
                                        }
                                      ];
                                      type = "assignment";
                                      value = {
                                        name = "path";
                                        path = [
                                          {
                                            kind = "identifier";
                                            value = "maxGenerations";
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
                                          value = "osIcon";
                                        }
                                      ];
                                      type = "assignment";
                                      value = {
                                        name = "path";
                                        path = [
                                          {
                                            kind = "identifier";
                                            value = "osIcon";
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
                                          value = "espMountPoint";
                                        }
                                      ];
                                      type = "assignment";
                                      value = {
                                        name = "cfg";
                                        path = [
                                          {
                                            kind = "identifier";
                                            value = "system";
                                          }
                                          {
                                            kind = "identifier";
                                            value = "boot";
                                          }
                                          {
                                            kind = "identifier";
                                            value = "loader";
                                          }
                                          {
                                            kind = "identifier";
                                            value = "efi";
                                          }
                                          {
                                            kind = "identifier";
                                            value = "efiSysMountPoint";
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
                                          value = "profileDir";
                                        }
                                      ];
                                      type = "assignment";
                                      value = {
                                        multiline = false;
                                        parts = [
                                          {
                                            type = "text";
                                            value = "/nix/var/nix/profiles/system";
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
                                    value = "zenboot";
                                  }
                                  {
                                    kind = "identifier";
                                    value = "override";
                                  }
                                ];
                                type = "variable";
                              };
                              type = "call";
                            };
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
                          value = "system";
                        }
                        {
                          kind = "identifier";
                          value = "activationScripts";
                        }
                        {
                          kind = "identifier";
                          value = "zenboot";
                        }
                      ];
                      type = "assignment";
                      value = {
                        multiline = true;
                        parts = [
                          {
                            type = "text";
                            value = "\n      echo \" [ZenBoot] Updating bootloader configuration...\"\n      ";
                          }
                          {
                            expression = {
                              arguments = [
                                {
                                  recursive = false;
                                  statements = [
                                    {
                                      operator = "=";
                                      target = [
                                        {
                                          kind = "identifier";
                                          value = "resolution";
                                        }
                                      ];
                                      type = "assignment";
                                      value = {
                                        name = "path";
                                        path = [
                                          {
                                            kind = "identifier";
                                            value = "resolution";
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
                                          value = "scannedDevices";
                                        }
                                      ];
                                      type = "assignment";
                                      value = {
                                        name = "path";
                                        path = [
                                          {
                                            kind = "identifier";
                                            value = "scannedDevices";
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
                                          value = "extraIncludedFiles";
                                        }
                                      ];
                                      type = "assignment";
                                      value = {
                                        name = "path";
                                        path = [
                                          {
                                            kind = "identifier";
                                            value = "extraIncludedFiles";
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
                                          value = "extraConfig";
                                        }
                                      ];
                                      type = "assignment";
                                      value = {
                                        name = "path";
                                        path = [
                                          {
                                            kind = "identifier";
                                            value = "extraConfig";
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
                                          value = "timeout";
                                        }
                                      ];
                                      type = "assignment";
                                      value = {
                                        name = "path";
                                        path = [
                                          {
                                            kind = "identifier";
                                            value = "timeout";
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
                                          value = "use_nvram";
                                        }
                                      ];
                                      type = "assignment";
                                      value = {
                                        name = "path";
                                        path = [
                                          {
                                            kind = "identifier";
                                            value = "use_nvram";
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
                                          value = "enable_mouse";
                                        }
                                      ];
                                      type = "assignment";
                                      value = {
                                        name = "path";
                                        path = [
                                          {
                                            kind = "identifier";
                                            value = "enable_mouse";
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
                                          value = "maxGenerations";
                                        }
                                      ];
                                      type = "assignment";
                                      value = {
                                        name = "path";
                                        path = [
                                          {
                                            kind = "identifier";
                                            value = "maxGenerations";
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
                                          value = "osIcon";
                                        }
                                      ];
                                      type = "assignment";
                                      value = {
                                        name = "path";
                                        path = [
                                          {
                                            kind = "identifier";
                                            value = "osIcon";
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
                                          value = "espMountPoint";
                                        }
                                      ];
                                      type = "assignment";
                                      value = {
                                        name = "cfg";
                                        path = [
                                          {
                                            kind = "identifier";
                                            value = "system";
                                          }
                                          {
                                            kind = "identifier";
                                            value = "boot";
                                          }
                                          {
                                            kind = "identifier";
                                            value = "loader";
                                          }
                                          {
                                            kind = "identifier";
                                            value = "efi";
                                          }
                                          {
                                            kind = "identifier";
                                            value = "efiSysMountPoint";
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
                                          value = "profileDir";
                                        }
                                      ];
                                      type = "assignment";
                                      value = {
                                        multiline = false;
                                        parts = [
                                          {
                                            type = "text";
                                            value = "/nix/var/nix/profiles/system";
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
                                    value = "zenboot";
                                  }
                                  {
                                    kind = "identifier";
                                    value = "override";
                                  }
                                ];
                                type = "variable";
                              };
                              type = "call";
                            };
                            type = "interpolation";
                          }
                          {
                            type = "text";
                            value = "/bin/zenboot-setup\n    ";
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
                          value = "boot";
                        }
                        {
                          kind = "identifier";
                          value = "plymouth";
                        }
                      ];
                      type = "assignment";
                      value = {
                        condition = {
                          name = "path";
                          path = [
                            {
                              kind = "identifier";
                              value = "plymouth";
                            }
                            {
                              kind = "identifier";
                              value = "enable";
                            }
                          ];
                          type = "variable";
                        };
                        "else" = {
                          recursive = false;
                          statements = [ ];
                          type = "attr-set";
                        };
                        "then" = {
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
                                  value = "theme";
                                }
                              ];
                              type = "assignment";
                              value = {
                                multiline = false;
                                parts = [
                                  {
                                    type = "text";
                                    value = "zenos";
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
                                  value = "themePackages";
                                }
                              ];
                              type = "assignment";
                              value = {
                                items = [
                                  {
                                    type = "group";
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
                                                  value = "distroName";
                                                }
                                              ];
                                              type = "assignment";
                                              value = {
                                                name = "path";
                                                path = [
                                                  {
                                                    kind = "identifier";
                                                    value = "distroName";
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
                                                  value = "releaseVersion";
                                                }
                                              ];
                                              type = "assignment";
                                              value = {
                                                name = "cfg";
                                                path = [
                                                  {
                                                    kind = "identifier";
                                                    value = "legacy";
                                                  }
                                                  {
                                                    kind = "identifier";
                                                    value = "system";
                                                  }
                                                  {
                                                    kind = "identifier";
                                                    value = "nixos";
                                                  }
                                                  {
                                                    kind = "identifier";
                                                    value = "label";
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
                                                  value = "deviceName";
                                                }
                                              ];
                                              type = "assignment";
                                              value = {
                                                condition = {
                                                  left = {
                                                    type = "group";
                                                    value = {
                                                      default = {
                                                        kind = "null";
                                                        type = "literal";
                                                        value = null;
                                                      };
                                                      type = "default";
                                                      value = {
                                                        name = "cfg";
                                                        path = [
                                                          {
                                                            kind = "identifier";
                                                            value = "system";
                                                          }
                                                          {
                                                            kind = "identifier";
                                                            value = "branding";
                                                          }
                                                          {
                                                            kind = "identifier";
                                                            value = "prettyName";
                                                          }
                                                        ];
                                                        type = "variable";
                                                      };
                                                    };
                                                  };
                                                  operator = "!=";
                                                  right = {
                                                    kind = "null";
                                                    type = "literal";
                                                    value = null;
                                                  };
                                                  type = "binary";
                                                };
                                                "else" = {
                                                  name = "cfg";
                                                  path = [
                                                    {
                                                      kind = "identifier";
                                                      value = "legacy";
                                                    }
                                                    {
                                                      kind = "identifier";
                                                      value = "networking";
                                                    }
                                                    {
                                                      kind = "identifier";
                                                      value = "hostName";
                                                    }
                                                  ];
                                                  type = "variable";
                                                };
                                                "then" = {
                                                  name = "cfg";
                                                  path = [
                                                    {
                                                      kind = "identifier";
                                                      value = "system";
                                                    }
                                                    {
                                                      kind = "identifier";
                                                      value = "branding";
                                                    }
                                                    {
                                                      kind = "identifier";
                                                      value = "prettyName";
                                                    }
                                                  ];
                                                  type = "variable";
                                                };
                                                type = "if";
                                              };
                                            }
                                            {
                                              operator = "=";
                                              target = [
                                                {
                                                  kind = "identifier";
                                                  value = "icon";
                                                }
                                              ];
                                              type = "assignment";
                                              value = {
                                                condition = {
                                                  left = {
                                                    type = "group";
                                                    value = {
                                                      default = {
                                                        kind = "null";
                                                        type = "literal";
                                                        value = null;
                                                      };
                                                      type = "default";
                                                      value = {
                                                        name = "cfg";
                                                        path = [
                                                          {
                                                            kind = "identifier";
                                                            value = "system";
                                                          }
                                                          {
                                                            kind = "identifier";
                                                            value = "branding";
                                                          }
                                                          {
                                                            kind = "identifier";
                                                            value = "icon";
                                                          }
                                                        ];
                                                        type = "variable";
                                                      };
                                                    };
                                                  };
                                                  operator = "!=";
                                                  right = {
                                                    kind = "null";
                                                    type = "literal";
                                                    value = null;
                                                  };
                                                  type = "binary";
                                                };
                                                "else" = {
                                                  multiline = false;
                                                  parts = [
                                                    {
                                                      type = "text";
                                                      value = "negzero";
                                                    }
                                                  ];
                                                  type = "string";
                                                };
                                                "then" = {
                                                  name = "cfg";
                                                  path = [
                                                    {
                                                      kind = "identifier";
                                                      value = "system";
                                                    }
                                                    {
                                                      kind = "identifier";
                                                      value = "branding";
                                                    }
                                                    {
                                                      kind = "identifier";
                                                      value = "icon";
                                                    }
                                                  ];
                                                  type = "variable";
                                                };
                                                type = "if";
                                              };
                                            }
                                            {
                                              operator = "=";
                                              target = [
                                                {
                                                  kind = "identifier";
                                                  value = "color";
                                                }
                                              ];
                                              type = "assignment";
                                              value = {
                                                name = "path";
                                                path = [
                                                  {
                                                    kind = "identifier";
                                                    value = "plymouth";
                                                  }
                                                  {
                                                    kind = "identifier";
                                                    value = "color";
                                                  }
                                                ];
                                                type = "variable";
                                              };
                                            }
                                          ];
                                          type = "attr-set";
                                        }
                                      ];
                                      callee = {
                                        name = "pkgs";
                                        path = [
                                          {
                                            kind = "identifier";
                                            value = "byCategories";
                                          }
                                          {
                                            kind = "identifier";
                                            value = "theming";
                                          }
                                          {
                                            kind = "identifier";
                                            value = "system";
                                          }
                                          {
                                            kind = "identifier";
                                            value = "zenos-plymouth";
                                          }
                                          {
                                            kind = "identifier";
                                            value = "override";
                                          }
                                        ];
                                        type = "variable";
                                      };
                                      type = "call";
                                    };
                                  }
                                ];
                                type = "list";
                              };
                            }
                          ];
                          type = "attr-set";
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
      {
        operator = "=";
        target = [
          {
            kind = "identifier";
            value = "plymouth";
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
                              value = "summary";
                            }
                          ];
                          type = "assignment";
                          value = {
                            multiline = false;
                            parts = [
                              {
                                type = "text";
                                value = "Enable the ZenOS Plymouth theme";
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
                  value = "color";
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
                                value = "string";
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
                            multiline = false;
                            parts = [
                              {
                                type = "text";
                                value = "C532FF";
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
                                value = "Boot animation glow color";
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
                                value = "Six hexadecimal digits without a leading hash sign.";
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
          type = "attr-set";
        };
      }
      {
        operator = "=";
        target = [
          {
            kind = "identifier";
            value = "osIcon";
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
                      arguments = [
                        {
                          items = [
                            {
                              multiline = false;
                              parts = [
                                {
                                  type = "text";
                                  value = "zenos";
                                }
                              ];
                              type = "string";
                            }
                            {
                              multiline = false;
                              parts = [
                                {
                                  type = "text";
                                  value = "freebsd";
                                }
                              ];
                              type = "string";
                            }
                            {
                              multiline = false;
                              parts = [
                                {
                                  type = "text";
                                  value = "usb";
                                }
                              ];
                              type = "string";
                            }
                            {
                              multiline = false;
                              parts = [
                                {
                                  type = "text";
                                  value = "unknown";
                                }
                              ];
                              type = "string";
                            }
                            {
                              multiline = false;
                              parts = [
                                {
                                  type = "text";
                                  value = "android";
                                }
                              ];
                              type = "string";
                            }
                            {
                              multiline = false;
                              parts = [
                                {
                                  type = "text";
                                  value = "arch";
                                }
                              ];
                              type = "string";
                            }
                            {
                              multiline = false;
                              parts = [
                                {
                                  type = "text";
                                  value = "windows";
                                }
                              ];
                              type = "string";
                            }
                            {
                              multiline = false;
                              parts = [
                                {
                                  type = "text";
                                  value = "mac";
                                }
                              ];
                              type = "string";
                            }
                          ];
                          type = "list";
                        }
                      ];
                      callee = {
                        name = "type";
                        path = [
                          {
                            kind = "identifier";
                            value = "enum";
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
                        value = "default";
                      }
                    ];
                    type = "assignment";
                    value = {
                      multiline = false;
                      parts = [
                        {
                          type = "text";
                          value = "zenos";
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
                          value = "Boot menu operating-system icon";
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
            value = "distroName";
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
                          value = "string";
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
                      multiline = false;
                      parts = [
                        {
                          type = "text";
                          value = "ZenOS";
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
                          value = "Distribution name";
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
            value = "resolution";
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
                          value = "string";
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
                      multiline = false;
                      parts = [
                        {
                          type = "text";
                          value = "max";
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
                          value = "Boot menu screen resolution";
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
            value = "timeout";
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
                          value = "int";
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
                      kind = "integer";
                      type = "literal";
                      value = 5;
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
                          value = "Boot menu timeout in seconds";
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
            value = "maxGenerations";
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
                          value = "int";
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
                      kind = "integer";
                      type = "literal";
                      value = 10;
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
                          value = "Generations included in the boot menu";
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
            value = "use_nvram";
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
                        value = "summary";
                      }
                    ];
                    type = "assignment";
                    value = {
                      multiline = false;
                      parts = [
                        {
                          type = "text";
                          value = "Write boot variables to NVRAM";
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
            value = "enable_mouse";
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
                          value = "Enable boot menu mouse support";
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
            value = "scannedDevices";
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
                      arguments = [
                        {
                          items = [
                            {
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
                                            value = "internal";
                                          }
                                        ];
                                        type = "string";
                                      }
                                      {
                                        multiline = false;
                                        parts = [
                                          {
                                            type = "text";
                                            value = "external";
                                          }
                                        ];
                                        type = "string";
                                      }
                                      {
                                        multiline = false;
                                        parts = [
                                          {
                                            type = "text";
                                            value = "optical";
                                          }
                                        ];
                                        type = "string";
                                      }
                                      {
                                        multiline = false;
                                        parts = [
                                          {
                                            type = "text";
                                            value = "netboot";
                                          }
                                        ];
                                        type = "string";
                                      }
                                      {
                                        multiline = false;
                                        parts = [
                                          {
                                            type = "text";
                                            value = "hdbios";
                                          }
                                        ];
                                        type = "string";
                                      }
                                      {
                                        multiline = false;
                                        parts = [
                                          {
                                            type = "text";
                                            value = "biosexternal";
                                          }
                                        ];
                                        type = "string";
                                      }
                                      {
                                        multiline = false;
                                        parts = [
                                          {
                                            type = "text";
                                            value = "cd";
                                          }
                                        ];
                                        type = "string";
                                      }
                                      {
                                        multiline = false;
                                        parts = [
                                          {
                                            type = "text";
                                            value = "manual";
                                          }
                                        ];
                                        type = "string";
                                      }
                                      {
                                        multiline = false;
                                        parts = [
                                          {
                                            type = "text";
                                            value = "firmware";
                                          }
                                        ];
                                        type = "string";
                                      }
                                    ];
                                    type = "list";
                                  }
                                ];
                                callee = {
                                  name = "type";
                                  path = [
                                    {
                                      kind = "identifier";
                                      value = "enum";
                                    }
                                  ];
                                  type = "variable";
                                };
                                type = "call";
                              };
                            }
                          ];
                          type = "list";
                        }
                      ];
                      callee = {
                        name = "type";
                        path = [
                          {
                            kind = "identifier";
                            value = "list";
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
                        value = "default";
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
                              value = "external";
                            }
                          ];
                          type = "string";
                        }
                        {
                          multiline = false;
                          parts = [
                            {
                              type = "text";
                              value = "optical";
                            }
                          ];
                          type = "string";
                        }
                        {
                          multiline = false;
                          parts = [
                            {
                              type = "text";
                              value = "manual";
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
                        value = "summary";
                      }
                    ];
                    type = "assignment";
                    value = {
                      multiline = false;
                      parts = [
                        {
                          type = "text";
                          value = "Device types scanned by ZenBoot";
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
            value = "extraConfig";
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
                          value = "string";
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
                      multiline = false;
                      parts = [ ];
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
                          value = "Additional refind.conf lines";
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
            value = "extraIncludedFiles";
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
                      arguments = [
                        {
                          items = [
                            {
                              name = "type";
                              path = [
                                {
                                  kind = "identifier";
                                  value = "null";
                                }
                              ];
                              type = "variable";
                            }
                            {
                              type = "group";
                              value = {
                                arguments = [
                                  {
                                    items = [
                                      {
                                        name = "type";
                                        path = [
                                          {
                                            kind = "identifier";
                                            value = "path";
                                          }
                                        ];
                                        type = "variable";
                                      }
                                    ];
                                    type = "list";
                                  }
                                ];
                                callee = {
                                  name = "type";
                                  path = [
                                    {
                                      kind = "identifier";
                                      value = "set";
                                    }
                                  ];
                                  type = "variable";
                                };
                                type = "call";
                              };
                            }
                          ];
                          type = "list";
                        }
                      ];
                      callee = {
                        name = "type";
                        path = [
                          {
                            kind = "identifier";
                            value = "either";
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
                        value = "default";
                      }
                    ];
                    type = "assignment";
                    value = {
                      kind = "null";
                      type = "literal";
                      value = null;
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
                          value = "Additional boot configuration files";
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
      boot.loader.grub.enable = false;
      boot.loader.systemd-boot.enable = false;
      assertions = [
        {
          assertion = (((config.zenos.system.boot.loader.efi.canTouchEfiVariables or false)) || ((!cfg.use_nvram)));
          message = "ZenBoot: 'use_nvram' requires EFI variable access.";
        }
      ];
      environment.systemPackages = [
        ((pkgs.zenos.byCategories.system.zenboot.override {
          resolution = cfg.resolution;
          scannedDevices = cfg.scannedDevices;
          extraIncludedFiles = cfg.extraIncludedFiles;
          extraConfig = cfg.extraConfig;
          timeout = cfg.timeout;
          use_nvram = cfg.use_nvram;
          enable_mouse = cfg.enable_mouse;
          maxGenerations = cfg.maxGenerations;
          osIcon = cfg.osIcon;
          espMountPoint = config.zenos.system.boot.loader.efi.efiSysMountPoint;
          profileDir = "/nix/var/nix/profiles/system";
        }))
      ];
      system.activationScripts.zenboot = "\n      echo \" [ZenBoot] Updating bootloader configuration...\"\n      ${((value: let kind = builtins.typeOf value; in if kind == "string" then value else if kind == "bool" || kind == "int" || kind == "float" then builtins.toJSON value else if kind == "path" then "${value}" else if kind == "set" && (value.type or null) == "derivation" && builtins.isString (value.outPath or null) then value.outPath else throw "/nix/store/3ni594f60hm22hcrazxd35dmk7pwi61m-zenpkgs-dsl-source/modules/system/boot/loader/zenboot.zmdl:45: string interpolation requires a scalar, path, or package") ((pkgs.zenos.byCategories.system.zenboot.override {
  resolution = cfg.resolution;
  scannedDevices = cfg.scannedDevices;
  extraIncludedFiles = cfg.extraIncludedFiles;
  extraConfig = cfg.extraConfig;
  timeout = cfg.timeout;
  use_nvram = cfg.use_nvram;
  enable_mouse = cfg.enable_mouse;
  maxGenerations = cfg.maxGenerations;
  osIcon = cfg.osIcon;
  espMountPoint = config.zenos.system.boot.loader.efi.efiSysMountPoint;
  profileDir = "/nix/var/nix/profiles/system";
})))}/bin/zenboot-setup\n    ";
      boot.plymouth = (if cfg.plymouth.enable then {
        enable = true;
        theme = "zenos";
        themePackages = [
          ((pkgs.zenos.byCategories.theming.system.zenos-plymouth.override {
            distroName = cfg.distroName;
            releaseVersion = config.zenos.legacy.system.nixos.label;
            deviceName = (if (((config.zenos.system.branding.prettyName or null)) != null) then config.zenos.system.branding.prettyName else config.zenos.legacy.networking.hostName);
            icon = (if (((config.zenos.system.branding.icon or null)) != null) then config.zenos.system.branding.icon else "negzero");
            color = cfg.plymouth.color;
          }))
        ];
      } else { });
    })
  ];
}
