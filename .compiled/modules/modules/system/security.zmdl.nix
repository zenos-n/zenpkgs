{ config, lib, pkgs, maintainers ? lib.maintainers, licenses ? lib.licenses, ... }:
let
  cfg = config.zenos.system.security;
  name = "security";
in
{
  options.zenos.system.security = lib.mkOption { type = (lib.types.submodule ({ ... }: { options = { administratorPassword = lib.mkOption { type = (lib.types.either lib.types.bool (lib.types.enum [ null ])); default = null; description = "Applies to administrator group members using sudo; it does not affect graphical authorization prompts. Null keeps the existing system policy."; }; allowRemoteLoginThroughFirewall = lib.mkOption { type = (lib.types.either lib.types.bool (lib.types.enum [ null ])); default = null; description = "Allow incoming SSH connections through the firewall.  Null keeps the existing system policy."; }; allowedTcpPorts = lib.mkOption { type = (lib.types.either (lib.types.listOf lib.types.int) (lib.types.enum [ null ])); default = null; description = "TCP ports reachable through the firewall. Null keeps the existing system policy."; }; allowedUdpPorts = lib.mkOption { type = (lib.types.either (lib.types.listOf lib.types.int) (lib.types.enum [ null ])); default = null; description = "UDP ports reachable through the firewall. Null keeps the existing system policy."; }; desktopAuthorization = lib.mkOption { type = (lib.types.either lib.types.bool (lib.types.enum [ null ])); default = null; description = "Allow desktop applications to request privileged actions. Null keeps the existing system policy."; }; firewall = lib.mkOption { type = (lib.types.either lib.types.bool (lib.types.enum [ null ])); default = null; description = "Filter unsolicited incoming network connections. Null keeps the existing system policy."; }; rememberSshKeys = lib.mkOption { type = (lib.types.either lib.types.bool (lib.types.enum [ null ])); default = null; description = "Keep unlocked SSH keys available during the desktop session.  Null keeps the existing system policy."; }; remoteKeyboardInteractiveLogin = lib.mkOption { type = (lib.types.either lib.types.bool (lib.types.enum [ null ])); default = null; description = "May allow password or multi-factor prompts, depending on authentication configuration. Null keeps the existing system policy."; }; remoteLogin = lib.mkOption { type = (lib.types.either lib.types.bool (lib.types.enum [ null ])); default = null; description = "Allow remote shell access using SSH. Null keeps the existing system policy."; }; remoteLoginPorts = lib.mkOption { type = (lib.types.either (lib.types.listOf lib.types.int) (lib.types.enum [ null ])); default = null; description = "Port numbers must be between 1 and 65535. Firewall opening follows the separate remote-login firewall preference. Null keeps the existing system policy."; }; remotePasswordLogin = lib.mkOption { type = (lib.types.either lib.types.bool (lib.types.enum [ null ])); default = null; description = "Allow passwords for SSH login instead of requiring keys. Null keeps the existing system policy."; }; respondToPing = lib.mkOption { type = (lib.types.either lib.types.bool (lib.types.enum [ null ])); default = null; description = "Allow other computers to test reachability with ping. Null keeps the existing system policy."; }; saveApplicationPasswords = lib.mkOption { type = (lib.types.either lib.types.bool (lib.types.enum [ null ])); default = null; description = "Store application passwords in the login keyring.  Null keeps the existing system policy."; }; smartCards = lib.mkOption { type = (lib.types.either lib.types.bool (lib.types.enum [ null ])); default = null; description = "Use smart-card readers for credentials.  Null keeps the existing system policy."; }; }; })); default = { }; };
  config = lib.mkMerge [
    { _module.args.zenlang.descriptors.system.security = {
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
            value = "Configure security for desktop use. Settings describe user-visible behavior.";
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
            value = "Configure security for desktop use";
          }
        ];
        type = "string";
      };
      summary = {
        multiline = false;
        parts = [
          {
            type = "text";
            value = "Configure security for desktop use";
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
                value = "desktop";
              }
            ];
            type = "string";
          }
          {
            multiline = false;
            parts = [
              {
                type = "text";
                value = "security";
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
    moduleIdentity = "zenos.system.security";
    modulePath = [
      "system"
      "security"
    ];
    nodeMetadata = [
      {
        metadata = {
          description = {
            multiline = true;
            parts = [
              {
                type = "text";
                value = "Configure security for desktop use. Settings describe user-visible behavior.";
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
                value = "Configure security for desktop use";
              }
            ];
            type = "string";
          };
          summary = {
            multiline = false;
            parts = [
              {
                type = "text";
                value = "Configure security for desktop use";
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
                    value = "desktop";
                  }
                ];
                type = "string";
              }
              {
                multiline = false;
                parts = [
                  {
                    type = "text";
                    value = "security";
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
                value = "Filter unsolicited incoming network connections. Null keeps the existing system policy.";
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
                value = "Filter unsolicited incoming network connections";
              }
            ];
            type = "string";
          };
          summary = {
            multiline = false;
            parts = [
              {
                type = "text";
                value = "Filter unsolicited incoming network connections";
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
                    value = "desktop";
                  }
                ];
                type = "string";
              }
              {
                multiline = false;
                parts = [
                  {
                    type = "text";
                    value = "security";
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
          "firewall"
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
                value = "Allow other computers to test reachability with ping. Null keeps the existing system policy.";
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
                value = "Allow other computers to test reachability with ping";
              }
            ];
            type = "string";
          };
          summary = {
            multiline = false;
            parts = [
              {
                type = "text";
                value = "Allow other computers to test reachability with ping";
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
                    value = "desktop";
                  }
                ];
                type = "string";
              }
              {
                multiline = false;
                parts = [
                  {
                    type = "text";
                    value = "security";
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
          "respondToPing"
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
                value = "TCP ports reachable through the firewall. Null keeps the existing system policy.";
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
                value = "TCP ports reachable through the firewall";
              }
            ];
            type = "string";
          };
          summary = {
            multiline = false;
            parts = [
              {
                type = "text";
                value = "TCP ports reachable through the firewall";
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
                    value = "desktop";
                  }
                ];
                type = "string";
              }
              {
                multiline = false;
                parts = [
                  {
                    type = "text";
                    value = "security";
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
                                  value = "int";
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
          "allowedTcpPorts"
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
                value = "UDP ports reachable through the firewall. Null keeps the existing system policy.";
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
                value = "UDP ports reachable through the firewall";
              }
            ];
            type = "string";
          };
          summary = {
            multiline = false;
            parts = [
              {
                type = "text";
                value = "UDP ports reachable through the firewall";
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
                    value = "desktop";
                  }
                ];
                type = "string";
              }
              {
                multiline = false;
                parts = [
                  {
                    type = "text";
                    value = "security";
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
                                  value = "int";
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
          "allowedUdpPorts"
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
                value = "Allow desktop applications to request privileged actions. Null keeps the existing system policy.";
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
                value = "Allow desktop applications to request privileged actions";
              }
            ];
            type = "string";
          };
          summary = {
            multiline = false;
            parts = [
              {
                type = "text";
                value = "Allow desktop applications to request privileged actions";
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
                    value = "desktop";
                  }
                ];
                type = "string";
              }
              {
                multiline = false;
                parts = [
                  {
                    type = "text";
                    value = "security";
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
          "desktopAuthorization"
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
                value = "Allow remote shell access using SSH. Null keeps the existing system policy.";
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
                value = "Allow remote shell access using SSH";
              }
            ];
            type = "string";
          };
          summary = {
            multiline = false;
            parts = [
              {
                type = "text";
                value = "Allow remote shell access using SSH";
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
                    value = "desktop";
                  }
                ];
                type = "string";
              }
              {
                multiline = false;
                parts = [
                  {
                    type = "text";
                    value = "security";
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
          "remoteLogin"
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
                value = "Allow passwords for SSH login instead of requiring keys. Null keeps the existing system policy.";
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
                value = "Allow passwords for SSH login instead of requiring keys";
              }
            ];
            type = "string";
          };
          summary = {
            multiline = false;
            parts = [
              {
                type = "text";
                value = "Allow passwords for SSH login instead of requiring keys";
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
                    value = "desktop";
                  }
                ];
                type = "string";
              }
              {
                multiline = false;
                parts = [
                  {
                    type = "text";
                    value = "security";
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
          "remotePasswordLogin"
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
                value = "Store application passwords in the login keyring.  Null keeps the existing system policy.";
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
                value = "Store application passwords in the login keyring";
              }
            ];
            type = "string";
          };
          summary = {
            multiline = false;
            parts = [
              {
                type = "text";
                value = "Store application passwords in the login keyring";
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
                    value = "desktop";
                  }
                ];
                type = "string";
              }
              {
                multiline = false;
                parts = [
                  {
                    type = "text";
                    value = "security";
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
          "saveApplicationPasswords"
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
                value = "Keep unlocked SSH keys available during the desktop session.  Null keeps the existing system policy.";
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
                value = "Keep unlocked SSH keys available during the desktop session";
              }
            ];
            type = "string";
          };
          summary = {
            multiline = false;
            parts = [
              {
                type = "text";
                value = "Keep unlocked SSH keys available during the desktop session";
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
                    value = "desktop";
                  }
                ];
                type = "string";
              }
              {
                multiline = false;
                parts = [
                  {
                    type = "text";
                    value = "security";
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
          "rememberSshKeys"
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
                value = "Use smart-card readers for credentials.  Null keeps the existing system policy.";
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
                value = "Use smart-card readers for credentials";
              }
            ];
            type = "string";
          };
          summary = {
            multiline = false;
            parts = [
              {
                type = "text";
                value = "Use smart-card readers for credentials";
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
                    value = "desktop";
                  }
                ];
                type = "string";
              }
              {
                multiline = false;
                parts = [
                  {
                    type = "text";
                    value = "security";
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
          "smartCards"
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
                value = "Allow incoming SSH connections through the firewall.  Null keeps the existing system policy.";
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
                value = "Allow incoming SSH connections through the firewall";
              }
            ];
            type = "string";
          };
          summary = {
            multiline = false;
            parts = [
              {
                type = "text";
                value = "Allow incoming SSH connections through the firewall";
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
                    value = "desktop";
                  }
                ];
                type = "string";
              }
              {
                multiline = false;
                parts = [
                  {
                    type = "text";
                    value = "security";
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
          "allowRemoteLoginThroughFirewall"
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
                value = "Port numbers must be between 1 and 65535. Firewall opening follows the separate remote-login firewall preference. Null keeps the existing system policy.";
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
                value = "Ports on which SSH accepts remote shell connections";
              }
            ];
            type = "string";
          };
          summary = {
            multiline = false;
            parts = [
              {
                type = "text";
                value = "Ports on which SSH accepts remote shell connections";
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
                    value = "desktop";
                  }
                ];
                type = "string";
              }
              {
                multiline = false;
                parts = [
                  {
                    type = "text";
                    value = "security";
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
                                  value = "int";
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
          "remoteLoginPorts"
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
                value = "May allow password or multi-factor prompts, depending on authentication configuration. Null keeps the existing system policy.";
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
                value = "Allow interactive authentication challenges for remote SSH login";
              }
            ];
            type = "string";
          };
          summary = {
            multiline = false;
            parts = [
              {
                type = "text";
                value = "Allow interactive authentication challenges for remote SSH login";
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
                    value = "desktop";
                  }
                ];
                type = "string";
              }
              {
                multiline = false;
                parts = [
                  {
                    type = "text";
                    value = "security";
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
          "remoteKeyboardInteractiveLogin"
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
                value = "Applies to administrator group members using sudo; it does not affect graphical authorization prompts. Null keeps the existing system policy.";
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
                value = "Require a password when administrators run commands with sudo";
              }
            ];
            type = "string";
          };
          summary = {
            multiline = false;
            parts = [
              {
                type = "text";
                value = "Require a password when administrators run commands with sudo";
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
                    value = "desktop";
                  }
                ];
                type = "string";
              }
              {
                multiline = false;
                parts = [
                  {
                    type = "text";
                    value = "security";
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
          "administratorPassword"
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
                    value = "Configure security for desktop use";
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
                        value = "desktop";
                      }
                    ];
                    type = "string";
                  }
                  {
                    multiline = false;
                    parts = [
                      {
                        type = "text";
                        value = "security";
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
                    value = "Configure security for desktop use";
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
                    value = "Configure security for desktop use. Settings describe user-visible behavior.";
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
          ];
          type = "attr-set";
        };
      }
      {
        operator = "=";
        target = [
          {
            kind = "identifier";
            value = "firewall";
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
                          value = "Filter unsolicited incoming network connections";
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
                              value = "desktop";
                            }
                          ];
                          type = "string";
                        }
                        {
                          multiline = false;
                          parts = [
                            {
                              type = "text";
                              value = "security";
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
                          value = "Filter unsolicited incoming network connections";
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
                          value = "Filter unsolicited incoming network connections. Null keeps the existing system policy.";
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
                        value = "networking";
                      }
                      {
                        kind = "identifier";
                        value = "firewall";
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
                          name = "path";
                          path = [
                            {
                              kind = "identifier";
                              value = "firewall";
                            }
                          ];
                          type = "variable";
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
                                    value = "firewall";
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
            value = "respondToPing";
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
                          value = "Allow other computers to test reachability with ping";
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
                              value = "desktop";
                            }
                          ];
                          type = "string";
                        }
                        {
                          multiline = false;
                          parts = [
                            {
                              type = "text";
                              value = "security";
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
                          value = "Allow other computers to test reachability with ping";
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
                          value = "Allow other computers to test reachability with ping. Null keeps the existing system policy.";
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
                        value = "networking";
                      }
                      {
                        kind = "identifier";
                        value = "firewall";
                      }
                      {
                        kind = "identifier";
                        value = "allowPing";
                      }
                    ];
                    type = "assignment";
                    value = {
                      arguments = [
                        {
                          name = "path";
                          path = [
                            {
                              kind = "identifier";
                              value = "respondToPing";
                            }
                          ];
                          type = "variable";
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
                                    value = "respondToPing";
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
            value = "allowedTcpPorts";
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
                          value = "TCP ports reachable through the firewall";
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
                              value = "desktop";
                            }
                          ];
                          type = "string";
                        }
                        {
                          multiline = false;
                          parts = [
                            {
                              type = "text";
                              value = "security";
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
                                            value = "int";
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
                          value = "TCP ports reachable through the firewall";
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
                          value = "TCP ports reachable through the firewall. Null keeps the existing system policy.";
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
                        value = "networking";
                      }
                      {
                        kind = "identifier";
                        value = "firewall";
                      }
                      {
                        kind = "identifier";
                        value = "allowedTCPPorts";
                      }
                    ];
                    type = "assignment";
                    value = {
                      arguments = [
                        {
                          name = "path";
                          path = [
                            {
                              kind = "identifier";
                              value = "allowedTcpPorts";
                            }
                          ];
                          type = "variable";
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
                                    value = "allowedTcpPorts";
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
            value = "allowedUdpPorts";
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
                          value = "UDP ports reachable through the firewall";
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
                              value = "desktop";
                            }
                          ];
                          type = "string";
                        }
                        {
                          multiline = false;
                          parts = [
                            {
                              type = "text";
                              value = "security";
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
                                            value = "int";
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
                          value = "UDP ports reachable through the firewall";
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
                          value = "UDP ports reachable through the firewall. Null keeps the existing system policy.";
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
                        value = "networking";
                      }
                      {
                        kind = "identifier";
                        value = "firewall";
                      }
                      {
                        kind = "identifier";
                        value = "allowedUDPPorts";
                      }
                    ];
                    type = "assignment";
                    value = {
                      arguments = [
                        {
                          name = "path";
                          path = [
                            {
                              kind = "identifier";
                              value = "allowedUdpPorts";
                            }
                          ];
                          type = "variable";
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
                                    value = "allowedUdpPorts";
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
            value = "desktopAuthorization";
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
                          value = "Allow desktop applications to request privileged actions";
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
                              value = "desktop";
                            }
                          ];
                          type = "string";
                        }
                        {
                          multiline = false;
                          parts = [
                            {
                              type = "text";
                              value = "security";
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
                          value = "Allow desktop applications to request privileged actions";
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
                          value = "Allow desktop applications to request privileged actions. Null keeps the existing system policy.";
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
                        value = "security";
                      }
                      {
                        kind = "identifier";
                        value = "polkit";
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
                            arguments = [
                              {
                                name = "path";
                                path = [
                                  {
                                    kind = "identifier";
                                    value = "desktopAuthorization";
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
                                  value = "mkForce";
                                }
                              ];
                              type = "variable";
                            };
                            type = "call";
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
                                    value = "desktopAuthorization";
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
            value = "remoteLogin";
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
                          value = "Allow remote shell access using SSH";
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
                              value = "desktop";
                            }
                          ];
                          type = "string";
                        }
                        {
                          multiline = false;
                          parts = [
                            {
                              type = "text";
                              value = "security";
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
                          value = "Allow remote shell access using SSH";
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
                          value = "Allow remote shell access using SSH. Null keeps the existing system policy.";
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
                        value = "services";
                      }
                      {
                        kind = "identifier";
                        value = "openssh";
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
                          name = "path";
                          path = [
                            {
                              kind = "identifier";
                              value = "remoteLogin";
                            }
                          ];
                          type = "variable";
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
                                    value = "remoteLogin";
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
            value = "remotePasswordLogin";
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
                          value = "Allow passwords for SSH login instead of requiring keys";
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
                              value = "desktop";
                            }
                          ];
                          type = "string";
                        }
                        {
                          multiline = false;
                          parts = [
                            {
                              type = "text";
                              value = "security";
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
                          value = "Allow passwords for SSH login instead of requiring keys";
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
                          value = "Allow passwords for SSH login instead of requiring keys. Null keeps the existing system policy.";
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
                        value = "services";
                      }
                      {
                        kind = "identifier";
                        value = "openssh";
                      }
                      {
                        kind = "identifier";
                        value = "settings";
                      }
                      {
                        kind = "identifier";
                        value = "PasswordAuthentication";
                      }
                    ];
                    type = "assignment";
                    value = {
                      arguments = [
                        {
                          name = "path";
                          path = [
                            {
                              kind = "identifier";
                              value = "remotePasswordLogin";
                            }
                          ];
                          type = "variable";
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
                                    value = "remotePasswordLogin";
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
            value = "saveApplicationPasswords";
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
                          value = "Store application passwords in the login keyring";
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
                              value = "desktop";
                            }
                          ];
                          type = "string";
                        }
                        {
                          multiline = false;
                          parts = [
                            {
                              type = "text";
                              value = "security";
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
                          value = "Store application passwords in the login keyring";
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
                          value = "Store application passwords in the login keyring.  Null keeps the existing system policy.";
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
                        value = "services";
                      }
                      {
                        kind = "identifier";
                        value = "gnome";
                      }
                      {
                        kind = "identifier";
                        value = "gnome-keyring";
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
                          name = "path";
                          path = [
                            {
                              kind = "identifier";
                              value = "saveApplicationPasswords";
                            }
                          ];
                          type = "variable";
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
                                    value = "saveApplicationPasswords";
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
            value = "rememberSshKeys";
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
                          value = "Keep unlocked SSH keys available during the desktop session";
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
                              value = "desktop";
                            }
                          ];
                          type = "string";
                        }
                        {
                          multiline = false;
                          parts = [
                            {
                              type = "text";
                              value = "security";
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
                          value = "Keep unlocked SSH keys available during the desktop session";
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
                          value = "Keep unlocked SSH keys available during the desktop session.  Null keeps the existing system policy.";
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
                        value = "services";
                      }
                      {
                        kind = "identifier";
                        value = "gnome";
                      }
                      {
                        kind = "identifier";
                        value = "gcr-ssh-agent";
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
                          name = "path";
                          path = [
                            {
                              kind = "identifier";
                              value = "rememberSshKeys";
                            }
                          ];
                          type = "variable";
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
                                    value = "rememberSshKeys";
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
            value = "smartCards";
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
                          value = "Use smart-card readers for credentials";
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
                              value = "desktop";
                            }
                          ];
                          type = "string";
                        }
                        {
                          multiline = false;
                          parts = [
                            {
                              type = "text";
                              value = "security";
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
                          value = "Use smart-card readers for credentials";
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
                          value = "Use smart-card readers for credentials.  Null keeps the existing system policy.";
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
                        value = "services";
                      }
                      {
                        kind = "identifier";
                        value = "pcscd";
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
                          name = "path";
                          path = [
                            {
                              kind = "identifier";
                              value = "smartCards";
                            }
                          ];
                          type = "variable";
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
                                    value = "smartCards";
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
            value = "allowRemoteLoginThroughFirewall";
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
                          value = "Allow incoming SSH connections through the firewall";
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
                              value = "desktop";
                            }
                          ];
                          type = "string";
                        }
                        {
                          multiline = false;
                          parts = [
                            {
                              type = "text";
                              value = "security";
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
                          value = "Allow incoming SSH connections through the firewall";
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
                          value = "Allow incoming SSH connections through the firewall.  Null keeps the existing system policy.";
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
                        value = "services";
                      }
                      {
                        kind = "identifier";
                        value = "openssh";
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
                          name = "path";
                          path = [
                            {
                              kind = "identifier";
                              value = "allowRemoteLoginThroughFirewall";
                            }
                          ];
                          type = "variable";
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
                                    value = "allowRemoteLoginThroughFirewall";
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
            value = "remoteLoginPorts";
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
                          value = "Ports on which SSH accepts remote shell connections";
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
                          value = "Ports on which SSH accepts remote shell connections";
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
                          value = "Port numbers must be between 1 and 65535. Firewall opening follows the separate remote-login firewall preference. Null keeps the existing system policy.";
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
                              value = "desktop";
                            }
                          ];
                          type = "string";
                        }
                        {
                          multiline = false;
                          parts = [
                            {
                              type = "text";
                              value = "security";
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
                                            value = "int";
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
                        value = "services";
                      }
                      {
                        kind = "identifier";
                        value = "openssh";
                      }
                      {
                        kind = "identifier";
                        value = "ports";
                      }
                    ];
                    type = "assignment";
                    value = {
                      arguments = [
                        {
                          name = "path";
                          path = [
                            {
                              kind = "identifier";
                              value = "remoteLoginPorts";
                            }
                          ];
                          type = "variable";
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
                                    value = "remoteLoginPorts";
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
            value = "remoteKeyboardInteractiveLogin";
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
                          value = "Allow interactive authentication challenges for remote SSH login";
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
                          value = "Allow interactive authentication challenges for remote SSH login";
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
                          value = "May allow password or multi-factor prompts, depending on authentication configuration. Null keeps the existing system policy.";
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
                              value = "desktop";
                            }
                          ];
                          type = "string";
                        }
                        {
                          multiline = false;
                          parts = [
                            {
                              type = "text";
                              value = "security";
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
                        value = "services";
                      }
                      {
                        kind = "identifier";
                        value = "openssh";
                      }
                      {
                        kind = "identifier";
                        value = "settings";
                      }
                      {
                        kind = "identifier";
                        value = "KbdInteractiveAuthentication";
                      }
                    ];
                    type = "assignment";
                    value = {
                      arguments = [
                        {
                          name = "path";
                          path = [
                            {
                              kind = "identifier";
                              value = "remoteKeyboardInteractiveLogin";
                            }
                          ];
                          type = "variable";
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
                                    value = "remoteKeyboardInteractiveLogin";
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
            value = "administratorPassword";
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
                          value = "Require a password when administrators run commands with sudo";
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
                          value = "Require a password when administrators run commands with sudo";
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
                          value = "Applies to administrator group members using sudo; it does not affect graphical authorization prompts. Null keeps the existing system policy.";
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
                              value = "desktop";
                            }
                          ];
                          type = "string";
                        }
                        {
                          multiline = false;
                          parts = [
                            {
                              type = "text";
                              value = "security";
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
                        value = "security";
                      }
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
                      arguments = [
                        {
                          name = "path";
                          path = [
                            {
                              kind = "identifier";
                              value = "administratorPassword";
                            }
                          ];
                          type = "variable";
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
                                    value = "administratorPassword";
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
  }; }
    {
      networking.firewall.enable = ((lib.mkIf ((cfg.firewall != null))) cfg.firewall);
    }
    {
      networking.firewall.allowPing = ((lib.mkIf ((cfg.respondToPing != null))) cfg.respondToPing);
    }
    {
      networking.firewall.allowedTCPPorts = ((lib.mkIf ((cfg.allowedTcpPorts != null))) cfg.allowedTcpPorts);
    }
    {
      networking.firewall.allowedUDPPorts = ((lib.mkIf ((cfg.allowedUdpPorts != null))) cfg.allowedUdpPorts);
    }
    {
      security.polkit.enable = ((lib.mkIf ((cfg.desktopAuthorization != null))) ((lib.mkForce cfg.desktopAuthorization)));
    }
    {
      services.openssh.enable = ((lib.mkIf ((cfg.remoteLogin != null))) cfg.remoteLogin);
    }
    {
      services.openssh.settings.PasswordAuthentication = ((lib.mkIf ((cfg.remotePasswordLogin != null))) cfg.remotePasswordLogin);
    }
    {
      services.gnome.gnome-keyring.enable = ((lib.mkIf ((cfg.saveApplicationPasswords != null))) cfg.saveApplicationPasswords);
    }
    {
      services.gnome.gcr-ssh-agent.enable = ((lib.mkIf ((cfg.rememberSshKeys != null))) cfg.rememberSshKeys);
    }
    {
      services.pcscd.enable = ((lib.mkIf ((cfg.smartCards != null))) cfg.smartCards);
    }
    {
      services.openssh.openFirewall = ((lib.mkIf ((cfg.allowRemoteLoginThroughFirewall != null))) cfg.allowRemoteLoginThroughFirewall);
    }
    {
      services.openssh.ports = ((lib.mkIf ((cfg.remoteLoginPorts != null))) cfg.remoteLoginPorts);
    }
    {
      services.openssh.settings.KbdInteractiveAuthentication = ((lib.mkIf ((cfg.remoteKeyboardInteractiveLogin != null))) cfg.remoteKeyboardInteractiveLogin);
    }
    {
      security.sudo.wheelNeedsPassword = ((lib.mkIf ((cfg.administratorPassword != null))) cfg.administratorPassword);
    }
  ];
}
