{ config, lib, pkgs, maintainers ? lib.maintainers, licenses ? lib.licenses, ... }:
let
  cfg = config.zenos.system.gaming;
  name = "gaming";
in
{
  options.zenos.system.gaming = lib.mkOption { type = (lib.types.submodule ({ ... }: { options = { alvr = lib.mkOption { type = (lib.types.submodule ({ ... }: { options = { allowNetworkAccess = lib.mkOption { type = (lib.types.either lib.types.bool (lib.types.enum [ null ])); default = null; description = "Allow ALVR headset streaming through the firewall. Unset values preserve existing policy."; }; enable = lib.mkOption { type = (lib.types.either lib.types.bool (lib.types.enum [ null ])); default = null; description = "Install and configure ALVR headset streaming. Unset values preserve existing policy."; }; package = lib.mkOption { type = (lib.types.either lib.types.package (lib.types.enum [ null ])); default = null; description = "ALVR streamer package and driver. Unset values preserve existing policy."; }; }; })); default = { }; }; gameMode = lib.mkOption { type = (lib.types.either lib.types.bool (lib.types.enum [ null ])); default = null; description = "Allow games to request GameMode performance policy. Unset values preserve existing policy."; }; steam = lib.mkOption { type = (lib.types.submodule ({ ... }: { options = { compatibilityTools = lib.mkOption { type = (lib.types.either (lib.types.listOf lib.types.package) (lib.types.enum [ null ])); default = null; description = "Steam compatibility tool packages. Unset values preserve existing policy."; }; dedicatedServer = lib.mkOption { type = (lib.types.either lib.types.bool (lib.types.enum [ null ])); default = null; description = "Allow Steam dedicated servers through the firewall. Unset values preserve existing policy."; }; enable = lib.mkOption { type = (lib.types.either lib.types.bool (lib.types.enum [ null ])); default = null; description = "Install and configure Steam. Unset values preserve existing policy."; }; remotePlay = lib.mkOption { type = (lib.types.either lib.types.bool (lib.types.enum [ null ])); default = null; description = "Allow Steam Remote Play through the firewall. Unset values preserve existing policy."; }; runtimeLibraries = lib.mkOption { type = (lib.types.either (lib.types.listOf lib.types.package) (lib.types.enum [ null ])); default = null; description = "Additional libraries in the Steam runtime. Unset values preserve existing policy."; }; }; })); default = { }; }; steamDevices = lib.mkOption { type = (lib.types.either lib.types.bool (lib.types.enum [ null ])); default = null; description = "Install Steam controller and VR device rules. Unset values preserve existing policy."; }; }; })); default = { }; };
  config = lib.mkMerge [
    { _module.args.zenlang.descriptors.system.gaming = {
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
            value = "Gaming and VR runtime support. Unset values preserve existing policy.";
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
      name = {
        multiline = false;
        parts = [
          {
            type = "text";
            value = "Gaming and VR runtime support";
          }
        ];
        type = "string";
      };
      summary = {
        multiline = false;
        parts = [
          {
            type = "text";
            value = "Gaming and VR runtime support";
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
                value = "migration";
              }
            ];
            type = "string";
          }
        ];
        type = "list";
      };
      zenosVersion = {
        kind = "version";
        type = "literal";
        value = "1.0.0Na";
      };
    };
    moduleIdentity = "zenos.system.gaming";
    modulePath = [
      "system"
      "gaming"
    ];
    nodeMetadata = [
      {
        metadata = {
          description = {
            multiline = true;
            parts = [
              {
                type = "text";
                value = "Gaming and VR runtime support. Unset values preserve existing policy.";
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
          name = {
            multiline = false;
            parts = [
              {
                type = "text";
                value = "Gaming and VR runtime support";
              }
            ];
            type = "string";
          };
          summary = {
            multiline = false;
            parts = [
              {
                type = "text";
                value = "Gaming and VR runtime support";
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
                    value = "migration";
                  }
                ];
                type = "string";
              }
            ];
            type = "list";
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
          zenosVersion = {
            kind = "version";
            type = "literal";
            value = "1.0.0Na";
          };
        };
        path = [
          "steam"
        ];
      }
      {
        metadata = {
          default = {
            kind = "null";
            type = "literal";
            value = null;
          };
          description = {
            multiline = true;
            parts = [
              {
                type = "text";
                value = "Install and configure Steam. Unset values preserve existing policy.";
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
          name = {
            multiline = false;
            parts = [
              {
                type = "text";
                value = "Install and configure Steam";
              }
            ];
            type = "string";
          };
          summary = {
            multiline = false;
            parts = [
              {
                type = "text";
                value = "Install and configure Steam";
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
                    value = "migration";
                  }
                ];
                type = "string";
              }
            ];
            type = "list";
          };
          type = {
            arguments = [
              {
                items = [
                  {
                    type = "group";
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
                    name = "type";
                    path = [
                      {
                        kind = "identifier";
                        value = "null";
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
          "steam"
          "enable"
        ];
      }
      {
        metadata = {
          default = {
            kind = "null";
            type = "literal";
            value = null;
          };
          description = {
            multiline = true;
            parts = [
              {
                type = "text";
                value = "Allow Steam Remote Play through the firewall. Unset values preserve existing policy.";
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
          name = {
            multiline = false;
            parts = [
              {
                type = "text";
                value = "Allow Steam Remote Play through the firewall";
              }
            ];
            type = "string";
          };
          summary = {
            multiline = false;
            parts = [
              {
                type = "text";
                value = "Allow Steam Remote Play through the firewall";
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
                    value = "migration";
                  }
                ];
                type = "string";
              }
            ];
            type = "list";
          };
          type = {
            arguments = [
              {
                items = [
                  {
                    type = "group";
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
                    name = "type";
                    path = [
                      {
                        kind = "identifier";
                        value = "null";
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
          "steam"
          "remotePlay"
        ];
      }
      {
        metadata = {
          default = {
            kind = "null";
            type = "literal";
            value = null;
          };
          description = {
            multiline = true;
            parts = [
              {
                type = "text";
                value = "Allow Steam dedicated servers through the firewall. Unset values preserve existing policy.";
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
          name = {
            multiline = false;
            parts = [
              {
                type = "text";
                value = "Allow Steam dedicated servers through the firewall";
              }
            ];
            type = "string";
          };
          summary = {
            multiline = false;
            parts = [
              {
                type = "text";
                value = "Allow Steam dedicated servers through the firewall";
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
                    value = "migration";
                  }
                ];
                type = "string";
              }
            ];
            type = "list";
          };
          type = {
            arguments = [
              {
                items = [
                  {
                    type = "group";
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
                    name = "type";
                    path = [
                      {
                        kind = "identifier";
                        value = "null";
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
          "steam"
          "dedicatedServer"
        ];
      }
      {
        metadata = {
          default = {
            kind = "null";
            type = "literal";
            value = null;
          };
          description = {
            multiline = true;
            parts = [
              {
                type = "text";
                value = "Steam compatibility tool packages. Unset values preserve existing policy.";
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
          name = {
            multiline = false;
            parts = [
              {
                type = "text";
                value = "Steam compatibility tool packages";
              }
            ];
            type = "string";
          };
          summary = {
            multiline = false;
            parts = [
              {
                type = "text";
                value = "Steam compatibility tool packages";
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
                    value = "migration";
                  }
                ];
                type = "string";
              }
            ];
            type = "list";
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
                              name = "type";
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
                    name = "type";
                    path = [
                      {
                        kind = "identifier";
                        value = "null";
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
          "steam"
          "compatibilityTools"
        ];
      }
      {
        metadata = {
          default = {
            kind = "null";
            type = "literal";
            value = null;
          };
          description = {
            multiline = true;
            parts = [
              {
                type = "text";
                value = "Additional libraries in the Steam runtime. Unset values preserve existing policy.";
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
          name = {
            multiline = false;
            parts = [
              {
                type = "text";
                value = "Additional libraries in the Steam runtime";
              }
            ];
            type = "string";
          };
          summary = {
            multiline = false;
            parts = [
              {
                type = "text";
                value = "Additional libraries in the Steam runtime";
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
                    value = "migration";
                  }
                ];
                type = "string";
              }
            ];
            type = "list";
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
                              name = "type";
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
                    name = "type";
                    path = [
                      {
                        kind = "identifier";
                        value = "null";
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
          "steam"
          "runtimeLibraries"
        ];
      }
      {
        metadata = {
          default = {
            kind = "null";
            type = "literal";
            value = null;
          };
          description = {
            multiline = true;
            parts = [
              {
                type = "text";
                value = "Install Steam controller and VR device rules. Unset values preserve existing policy.";
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
          name = {
            multiline = false;
            parts = [
              {
                type = "text";
                value = "Install Steam controller and VR device rules";
              }
            ];
            type = "string";
          };
          summary = {
            multiline = false;
            parts = [
              {
                type = "text";
                value = "Install Steam controller and VR device rules";
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
                    value = "migration";
                  }
                ];
                type = "string";
              }
            ];
            type = "list";
          };
          type = {
            arguments = [
              {
                items = [
                  {
                    type = "group";
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
                    name = "type";
                    path = [
                      {
                        kind = "identifier";
                        value = "null";
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
          "steamDevices"
        ];
      }
      {
        metadata = {
          default = {
            kind = "null";
            type = "literal";
            value = null;
          };
          description = {
            multiline = true;
            parts = [
              {
                type = "text";
                value = "Allow games to request GameMode performance policy. Unset values preserve existing policy.";
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
          name = {
            multiline = false;
            parts = [
              {
                type = "text";
                value = "Allow games to request GameMode performance policy";
              }
            ];
            type = "string";
          };
          summary = {
            multiline = false;
            parts = [
              {
                type = "text";
                value = "Allow games to request GameMode performance policy";
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
                    value = "migration";
                  }
                ];
                type = "string";
              }
            ];
            type = "list";
          };
          type = {
            arguments = [
              {
                items = [
                  {
                    type = "group";
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
                    name = "type";
                    path = [
                      {
                        kind = "identifier";
                        value = "null";
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
          "gameMode"
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
          "alvr"
        ];
      }
      {
        metadata = {
          default = {
            kind = "null";
            type = "literal";
            value = null;
          };
          description = {
            multiline = true;
            parts = [
              {
                type = "text";
                value = "Install and configure ALVR headset streaming. Unset values preserve existing policy.";
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
          name = {
            multiline = false;
            parts = [
              {
                type = "text";
                value = "Install and configure ALVR headset streaming";
              }
            ];
            type = "string";
          };
          summary = {
            multiline = false;
            parts = [
              {
                type = "text";
                value = "Install and configure ALVR headset streaming";
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
                    value = "migration";
                  }
                ];
                type = "string";
              }
            ];
            type = "list";
          };
          type = {
            arguments = [
              {
                items = [
                  {
                    type = "group";
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
                    name = "type";
                    path = [
                      {
                        kind = "identifier";
                        value = "null";
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
          "alvr"
          "enable"
        ];
      }
      {
        metadata = {
          default = {
            kind = "null";
            type = "literal";
            value = null;
          };
          description = {
            multiline = true;
            parts = [
              {
                type = "text";
                value = "Allow ALVR headset streaming through the firewall. Unset values preserve existing policy.";
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
          name = {
            multiline = false;
            parts = [
              {
                type = "text";
                value = "Allow ALVR headset streaming through the firewall";
              }
            ];
            type = "string";
          };
          summary = {
            multiline = false;
            parts = [
              {
                type = "text";
                value = "Allow ALVR headset streaming through the firewall";
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
                    value = "migration";
                  }
                ];
                type = "string";
              }
            ];
            type = "list";
          };
          type = {
            arguments = [
              {
                items = [
                  {
                    type = "group";
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
                    name = "type";
                    path = [
                      {
                        kind = "identifier";
                        value = "null";
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
          "alvr"
          "allowNetworkAccess"
        ];
      }
      {
        metadata = {
          default = {
            kind = "null";
            type = "literal";
            value = null;
          };
          description = {
            multiline = true;
            parts = [
              {
                type = "text";
                value = "ALVR streamer package and driver. Unset values preserve existing policy.";
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
          name = {
            multiline = false;
            parts = [
              {
                type = "text";
                value = "ALVR streamer package and driver";
              }
            ];
            type = "string";
          };
          summary = {
            multiline = false;
            parts = [
              {
                type = "text";
                value = "ALVR streamer package and driver";
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
                    value = "migration";
                  }
                ];
                type = "string";
              }
            ];
            type = "list";
          };
          type = {
            arguments = [
              {
                items = [
                  {
                    type = "group";
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
                    name = "type";
                    path = [
                      {
                        kind = "identifier";
                        value = "null";
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
          "alvr"
          "package"
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
                  value = "name";
                }
              ];
              type = "assignment";
              value = {
                multiline = false;
                parts = [
                  {
                    type = "text";
                    value = "Gaming and VR runtime support";
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
                    value = "Gaming and VR runtime support";
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
                    value = "Gaming and VR runtime support. Unset values preserve existing policy.";
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
                        value = "migration";
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
          ];
          type = "attr-set";
        };
      }
      {
        operator = "=";
        target = [
          {
            kind = "identifier";
            value = "steam";
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
                              value = "name";
                            }
                          ];
                          type = "assignment";
                          value = {
                            multiline = false;
                            parts = [
                              {
                                type = "text";
                                value = "Install and configure Steam";
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
                                value = "Install and configure Steam";
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
                                value = "Install and configure Steam. Unset values preserve existing policy.";
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
                                    value = "migration";
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
                                    name = "type";
                                    path = [
                                      {
                                        kind = "identifier";
                                        value = "null";
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
                              value = "steam";
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
                                type = "group";
                                value = {
                                  name = "path";
                                  path = [
                                    {
                                      kind = "identifier";
                                      value = "steam";
                                    }
                                    {
                                      kind = "identifier";
                                      value = "enable";
                                    }
                                  ];
                                  type = "variable";
                                };
                              }
                            ];
                            callee = {
                              arguments = [
                                {
                                  type = "group";
                                  value = {
                                    left = {
                                      name = "path";
                                      path = [
                                        {
                                          kind = "identifier";
                                          value = "steam";
                                        }
                                        {
                                          kind = "identifier";
                                          value = "enable";
                                        }
                                      ];
                                      type = "variable";
                                    };
                                    operator = "!=";
                                    right = {
                                      kind = "null";
                                      type = "literal";
                                      value = null;
                                    };
                                    type = "binary";
                                  };
                                }
                              ];
                              callee = {
                                name = "lib";
                                path = [
                                  {
                                    kind = "identifier";
                                    value = "mkIf";
                                  }
                                ];
                                type = "variable";
                              };
                              type = "call";
                            };
                            type = "call";
                          };
                        }
                      ];
                      type = "attr-set";
                    };
                    guards = [ ];
                    scope = "system";
                    type = "action";
                    unconditional = true;
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
                  value = "remotePlay";
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
                              value = "name";
                            }
                          ];
                          type = "assignment";
                          value = {
                            multiline = false;
                            parts = [
                              {
                                type = "text";
                                value = "Allow Steam Remote Play through the firewall";
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
                                value = "Allow Steam Remote Play through the firewall";
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
                                value = "Allow Steam Remote Play through the firewall. Unset values preserve existing policy.";
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
                                    value = "migration";
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
                                    name = "type";
                                    path = [
                                      {
                                        kind = "identifier";
                                        value = "null";
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
                              value = "steam";
                            }
                            {
                              kind = "identifier";
                              value = "remotePlay";
                            }
                            {
                              kind = "identifier";
                              value = "openFirewall";
                            }
                          ];
                          type = "assignment";
                          value = {
                            arguments = [
                              {
                                type = "group";
                                value = {
                                  name = "path";
                                  path = [
                                    {
                                      kind = "identifier";
                                      value = "steam";
                                    }
                                    {
                                      kind = "identifier";
                                      value = "remotePlay";
                                    }
                                  ];
                                  type = "variable";
                                };
                              }
                            ];
                            callee = {
                              arguments = [
                                {
                                  type = "group";
                                  value = {
                                    left = {
                                      name = "path";
                                      path = [
                                        {
                                          kind = "identifier";
                                          value = "steam";
                                        }
                                        {
                                          kind = "identifier";
                                          value = "remotePlay";
                                        }
                                      ];
                                      type = "variable";
                                    };
                                    operator = "!=";
                                    right = {
                                      kind = "null";
                                      type = "literal";
                                      value = null;
                                    };
                                    type = "binary";
                                  };
                                }
                              ];
                              callee = {
                                name = "lib";
                                path = [
                                  {
                                    kind = "identifier";
                                    value = "mkIf";
                                  }
                                ];
                                type = "variable";
                              };
                              type = "call";
                            };
                            type = "call";
                          };
                        }
                      ];
                      type = "attr-set";
                    };
                    guards = [ ];
                    scope = "system";
                    type = "action";
                    unconditional = true;
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
                  value = "dedicatedServer";
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
                              value = "name";
                            }
                          ];
                          type = "assignment";
                          value = {
                            multiline = false;
                            parts = [
                              {
                                type = "text";
                                value = "Allow Steam dedicated servers through the firewall";
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
                                value = "Allow Steam dedicated servers through the firewall";
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
                                value = "Allow Steam dedicated servers through the firewall. Unset values preserve existing policy.";
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
                                    value = "migration";
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
                                    name = "type";
                                    path = [
                                      {
                                        kind = "identifier";
                                        value = "null";
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
                              value = "steam";
                            }
                            {
                              kind = "identifier";
                              value = "dedicatedServer";
                            }
                            {
                              kind = "identifier";
                              value = "openFirewall";
                            }
                          ];
                          type = "assignment";
                          value = {
                            arguments = [
                              {
                                type = "group";
                                value = {
                                  name = "path";
                                  path = [
                                    {
                                      kind = "identifier";
                                      value = "steam";
                                    }
                                    {
                                      kind = "identifier";
                                      value = "dedicatedServer";
                                    }
                                  ];
                                  type = "variable";
                                };
                              }
                            ];
                            callee = {
                              arguments = [
                                {
                                  type = "group";
                                  value = {
                                    left = {
                                      name = "path";
                                      path = [
                                        {
                                          kind = "identifier";
                                          value = "steam";
                                        }
                                        {
                                          kind = "identifier";
                                          value = "dedicatedServer";
                                        }
                                      ];
                                      type = "variable";
                                    };
                                    operator = "!=";
                                    right = {
                                      kind = "null";
                                      type = "literal";
                                      value = null;
                                    };
                                    type = "binary";
                                  };
                                }
                              ];
                              callee = {
                                name = "lib";
                                path = [
                                  {
                                    kind = "identifier";
                                    value = "mkIf";
                                  }
                                ];
                                type = "variable";
                              };
                              type = "call";
                            };
                            type = "call";
                          };
                        }
                      ];
                      type = "attr-set";
                    };
                    guards = [ ];
                    scope = "system";
                    type = "action";
                    unconditional = true;
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
                  value = "compatibilityTools";
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
                              value = "name";
                            }
                          ];
                          type = "assignment";
                          value = {
                            multiline = false;
                            parts = [
                              {
                                type = "text";
                                value = "Steam compatibility tool packages";
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
                                value = "Steam compatibility tool packages";
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
                                value = "Steam compatibility tool packages. Unset values preserve existing policy.";
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
                                    value = "migration";
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
                                              name = "type";
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
                                    name = "type";
                                    path = [
                                      {
                                        kind = "identifier";
                                        value = "null";
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
                              value = "steam";
                            }
                            {
                              kind = "identifier";
                              value = "extraCompatPackages";
                            }
                          ];
                          type = "assignment";
                          value = {
                            arguments = [
                              {
                                type = "group";
                                value = {
                                  name = "path";
                                  path = [
                                    {
                                      kind = "identifier";
                                      value = "steam";
                                    }
                                    {
                                      kind = "identifier";
                                      value = "compatibilityTools";
                                    }
                                  ];
                                  type = "variable";
                                };
                              }
                            ];
                            callee = {
                              arguments = [
                                {
                                  type = "group";
                                  value = {
                                    left = {
                                      name = "path";
                                      path = [
                                        {
                                          kind = "identifier";
                                          value = "steam";
                                        }
                                        {
                                          kind = "identifier";
                                          value = "compatibilityTools";
                                        }
                                      ];
                                      type = "variable";
                                    };
                                    operator = "!=";
                                    right = {
                                      kind = "null";
                                      type = "literal";
                                      value = null;
                                    };
                                    type = "binary";
                                  };
                                }
                              ];
                              callee = {
                                name = "lib";
                                path = [
                                  {
                                    kind = "identifier";
                                    value = "mkIf";
                                  }
                                ];
                                type = "variable";
                              };
                              type = "call";
                            };
                            type = "call";
                          };
                        }
                      ];
                      type = "attr-set";
                    };
                    guards = [ ];
                    scope = "system";
                    type = "action";
                    unconditional = true;
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
                  value = "runtimeLibraries";
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
                              value = "name";
                            }
                          ];
                          type = "assignment";
                          value = {
                            multiline = false;
                            parts = [
                              {
                                type = "text";
                                value = "Additional libraries in the Steam runtime";
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
                                value = "Additional libraries in the Steam runtime";
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
                                value = "Additional libraries in the Steam runtime. Unset values preserve existing policy.";
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
                                    value = "migration";
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
                                              name = "type";
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
                                    name = "type";
                                    path = [
                                      {
                                        kind = "identifier";
                                        value = "null";
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
                              value = "steam";
                            }
                            {
                              kind = "identifier";
                              value = "extraPackages";
                            }
                          ];
                          type = "assignment";
                          value = {
                            arguments = [
                              {
                                type = "group";
                                value = {
                                  name = "path";
                                  path = [
                                    {
                                      kind = "identifier";
                                      value = "steam";
                                    }
                                    {
                                      kind = "identifier";
                                      value = "runtimeLibraries";
                                    }
                                  ];
                                  type = "variable";
                                };
                              }
                            ];
                            callee = {
                              arguments = [
                                {
                                  type = "group";
                                  value = {
                                    left = {
                                      name = "path";
                                      path = [
                                        {
                                          kind = "identifier";
                                          value = "steam";
                                        }
                                        {
                                          kind = "identifier";
                                          value = "runtimeLibraries";
                                        }
                                      ];
                                      type = "variable";
                                    };
                                    operator = "!=";
                                    right = {
                                      kind = "null";
                                      type = "literal";
                                      value = null;
                                    };
                                    type = "binary";
                                  };
                                }
                              ];
                              callee = {
                                name = "lib";
                                path = [
                                  {
                                    kind = "identifier";
                                    value = "mkIf";
                                  }
                                ];
                                type = "variable";
                              };
                              type = "call";
                            };
                            type = "call";
                          };
                        }
                      ];
                      type = "attr-set";
                    };
                    guards = [ ];
                    scope = "system";
                    type = "action";
                    unconditional = true;
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
            value = "steamDevices";
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
                        value = "name";
                      }
                    ];
                    type = "assignment";
                    value = {
                      multiline = false;
                      parts = [
                        {
                          type = "text";
                          value = "Install Steam controller and VR device rules";
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
                          value = "Install Steam controller and VR device rules";
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
                          value = "Install Steam controller and VR device rules. Unset values preserve existing policy.";
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
                              value = "migration";
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
                              name = "type";
                              path = [
                                {
                                  kind = "identifier";
                                  value = "null";
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
                        value = "hardware";
                      }
                      {
                        kind = "identifier";
                        value = "steam-hardware";
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
                          type = "group";
                          value = {
                            name = "path";
                            path = [
                              {
                                kind = "identifier";
                                value = "steamDevices";
                              }
                            ];
                            type = "variable";
                          };
                        }
                      ];
                      callee = {
                        arguments = [
                          {
                            type = "group";
                            value = {
                              left = {
                                name = "path";
                                path = [
                                  {
                                    kind = "identifier";
                                    value = "steamDevices";
                                  }
                                ];
                                type = "variable";
                              };
                              operator = "!=";
                              right = {
                                kind = "null";
                                type = "literal";
                                value = null;
                              };
                              type = "binary";
                            };
                          }
                        ];
                        callee = {
                          name = "lib";
                          path = [
                            {
                              kind = "identifier";
                              value = "mkIf";
                            }
                          ];
                          type = "variable";
                        };
                        type = "call";
                      };
                      type = "call";
                    };
                  }
                ];
                type = "attr-set";
              };
              guards = [ ];
              scope = "system";
              type = "action";
              unconditional = true;
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
            value = "gameMode";
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
                        value = "name";
                      }
                    ];
                    type = "assignment";
                    value = {
                      multiline = false;
                      parts = [
                        {
                          type = "text";
                          value = "Allow games to request GameMode performance policy";
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
                          value = "Allow games to request GameMode performance policy";
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
                          value = "Allow games to request GameMode performance policy. Unset values preserve existing policy.";
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
                              value = "migration";
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
                              name = "type";
                              path = [
                                {
                                  kind = "identifier";
                                  value = "null";
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
                        value = "gamemode";
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
                          type = "group";
                          value = {
                            name = "path";
                            path = [
                              {
                                kind = "identifier";
                                value = "gameMode";
                              }
                            ];
                            type = "variable";
                          };
                        }
                      ];
                      callee = {
                        arguments = [
                          {
                            type = "group";
                            value = {
                              left = {
                                name = "path";
                                path = [
                                  {
                                    kind = "identifier";
                                    value = "gameMode";
                                  }
                                ];
                                type = "variable";
                              };
                              operator = "!=";
                              right = {
                                kind = "null";
                                type = "literal";
                                value = null;
                              };
                              type = "binary";
                            };
                          }
                        ];
                        callee = {
                          name = "lib";
                          path = [
                            {
                              kind = "identifier";
                              value = "mkIf";
                            }
                          ];
                          type = "variable";
                        };
                        type = "call";
                      };
                      type = "call";
                    };
                  }
                ];
                type = "attr-set";
              };
              guards = [ ];
              scope = "system";
              type = "action";
              unconditional = true;
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
            value = "alvr";
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
                              value = "name";
                            }
                          ];
                          type = "assignment";
                          value = {
                            multiline = false;
                            parts = [
                              {
                                type = "text";
                                value = "Install and configure ALVR headset streaming";
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
                                value = "Install and configure ALVR headset streaming";
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
                                value = "Install and configure ALVR headset streaming. Unset values preserve existing policy.";
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
                                    value = "migration";
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
                                    name = "type";
                                    path = [
                                      {
                                        kind = "identifier";
                                        value = "null";
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
                              value = "alvr";
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
                                type = "group";
                                value = {
                                  name = "path";
                                  path = [
                                    {
                                      kind = "identifier";
                                      value = "alvr";
                                    }
                                    {
                                      kind = "identifier";
                                      value = "enable";
                                    }
                                  ];
                                  type = "variable";
                                };
                              }
                            ];
                            callee = {
                              arguments = [
                                {
                                  type = "group";
                                  value = {
                                    left = {
                                      name = "path";
                                      path = [
                                        {
                                          kind = "identifier";
                                          value = "alvr";
                                        }
                                        {
                                          kind = "identifier";
                                          value = "enable";
                                        }
                                      ];
                                      type = "variable";
                                    };
                                    operator = "!=";
                                    right = {
                                      kind = "null";
                                      type = "literal";
                                      value = null;
                                    };
                                    type = "binary";
                                  };
                                }
                              ];
                              callee = {
                                name = "lib";
                                path = [
                                  {
                                    kind = "identifier";
                                    value = "mkIf";
                                  }
                                ];
                                type = "variable";
                              };
                              type = "call";
                            };
                            type = "call";
                          };
                        }
                      ];
                      type = "attr-set";
                    };
                    guards = [ ];
                    scope = "system";
                    type = "action";
                    unconditional = true;
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
                  value = "allowNetworkAccess";
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
                              value = "name";
                            }
                          ];
                          type = "assignment";
                          value = {
                            multiline = false;
                            parts = [
                              {
                                type = "text";
                                value = "Allow ALVR headset streaming through the firewall";
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
                                value = "Allow ALVR headset streaming through the firewall";
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
                                value = "Allow ALVR headset streaming through the firewall. Unset values preserve existing policy.";
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
                                    value = "migration";
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
                                    name = "type";
                                    path = [
                                      {
                                        kind = "identifier";
                                        value = "null";
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
                              value = "alvr";
                            }
                            {
                              kind = "identifier";
                              value = "openFirewall";
                            }
                          ];
                          type = "assignment";
                          value = {
                            arguments = [
                              {
                                type = "group";
                                value = {
                                  name = "path";
                                  path = [
                                    {
                                      kind = "identifier";
                                      value = "alvr";
                                    }
                                    {
                                      kind = "identifier";
                                      value = "allowNetworkAccess";
                                    }
                                  ];
                                  type = "variable";
                                };
                              }
                            ];
                            callee = {
                              arguments = [
                                {
                                  type = "group";
                                  value = {
                                    left = {
                                      name = "path";
                                      path = [
                                        {
                                          kind = "identifier";
                                          value = "alvr";
                                        }
                                        {
                                          kind = "identifier";
                                          value = "allowNetworkAccess";
                                        }
                                      ];
                                      type = "variable";
                                    };
                                    operator = "!=";
                                    right = {
                                      kind = "null";
                                      type = "literal";
                                      value = null;
                                    };
                                    type = "binary";
                                  };
                                }
                              ];
                              callee = {
                                name = "lib";
                                path = [
                                  {
                                    kind = "identifier";
                                    value = "mkIf";
                                  }
                                ];
                                type = "variable";
                              };
                              type = "call";
                            };
                            type = "call";
                          };
                        }
                      ];
                      type = "attr-set";
                    };
                    guards = [ ];
                    scope = "system";
                    type = "action";
                    unconditional = true;
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
                              value = "name";
                            }
                          ];
                          type = "assignment";
                          value = {
                            multiline = false;
                            parts = [
                              {
                                type = "text";
                                value = "ALVR streamer package and driver";
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
                                value = "ALVR streamer package and driver";
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
                                value = "ALVR streamer package and driver. Unset values preserve existing policy.";
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
                                    value = "migration";
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
                                    name = "type";
                                    path = [
                                      {
                                        kind = "identifier";
                                        value = "null";
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
                              value = "alvr";
                            }
                            {
                              kind = "identifier";
                              value = "package";
                            }
                          ];
                          type = "assignment";
                          value = {
                            arguments = [
                              {
                                type = "group";
                                value = {
                                  name = "path";
                                  path = [
                                    {
                                      kind = "identifier";
                                      value = "alvr";
                                    }
                                    {
                                      kind = "identifier";
                                      value = "package";
                                    }
                                  ];
                                  type = "variable";
                                };
                              }
                            ];
                            callee = {
                              arguments = [
                                {
                                  type = "group";
                                  value = {
                                    left = {
                                      name = "path";
                                      path = [
                                        {
                                          kind = "identifier";
                                          value = "alvr";
                                        }
                                        {
                                          kind = "identifier";
                                          value = "package";
                                        }
                                      ];
                                      type = "variable";
                                    };
                                    operator = "!=";
                                    right = {
                                      kind = "null";
                                      type = "literal";
                                      value = null;
                                    };
                                    type = "binary";
                                  };
                                }
                              ];
                              callee = {
                                name = "lib";
                                path = [
                                  {
                                    kind = "identifier";
                                    value = "mkIf";
                                  }
                                ];
                                type = "variable";
                              };
                              type = "call";
                            };
                            type = "call";
                          };
                        }
                      ];
                      type = "attr-set";
                    };
                    guards = [ ];
                    scope = "system";
                    type = "action";
                    unconditional = true;
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
    {
      programs.steam.enable = ((lib.mkIf ((cfg.steam.enable != null))) (cfg.steam.enable));
    }
    {
      programs.steam.remotePlay.openFirewall = ((lib.mkIf ((cfg.steam.remotePlay != null))) (cfg.steam.remotePlay));
    }
    {
      programs.steam.dedicatedServer.openFirewall = ((lib.mkIf ((cfg.steam.dedicatedServer != null))) (cfg.steam.dedicatedServer));
    }
    {
      programs.steam.extraCompatPackages = ((lib.mkIf ((cfg.steam.compatibilityTools != null))) (cfg.steam.compatibilityTools));
    }
    {
      programs.steam.extraPackages = ((lib.mkIf ((cfg.steam.runtimeLibraries != null))) (cfg.steam.runtimeLibraries));
    }
    {
      hardware.steam-hardware.enable = ((lib.mkIf ((cfg.steamDevices != null))) (cfg.steamDevices));
    }
    {
      programs.gamemode.enable = ((lib.mkIf ((cfg.gameMode != null))) (cfg.gameMode));
    }
    {
      programs.alvr.enable = ((lib.mkIf ((cfg.alvr.enable != null))) (cfg.alvr.enable));
    }
    {
      programs.alvr.openFirewall = ((lib.mkIf ((cfg.alvr.allowNetworkAccess != null))) (cfg.alvr.allowNetworkAccess));
    }
    {
      programs.alvr.package = ((lib.mkIf ((cfg.alvr.package != null))) (cfg.alvr.package));
    }
  ];
}
