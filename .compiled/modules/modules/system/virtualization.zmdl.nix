{ config, lib, pkgs, maintainers ? lib.maintainers, licenses ? lib.licenses, ... }:
let
  cfg = config.zenos.system.virtualization;
  name = "virtualization";
in
{
  options.zenos.system.virtualization = lib.mkOption { type = (lib.types.submodule ({ ... }: { options = { docker = lib.mkOption { type = (lib.types.submodule ({ ... }: { options = { enable = lib.mkOption { type = (lib.types.either lib.types.bool (lib.types.enum [ null ])); default = null; description = "Run Docker containers. Unset values preserve existing policy."; }; exportSocket = lib.mkOption { type = (lib.types.either lib.types.bool (lib.types.enum [ null ])); default = null; description = "Export the rootless Docker socket to user sessions. Unset values preserve existing policy."; }; rootless = lib.mkOption { type = (lib.types.either lib.types.bool (lib.types.enum [ null ])); default = null; description = "Run a per-user Docker daemon without root. Unset values preserve existing policy."; }; storageDriver = lib.mkOption { type = (lib.types.either lib.types.str (lib.types.enum [ null ])); default = null; description = "Docker container storage driver. Unset values preserve existing policy."; }; }; })); default = { }; }; guest = lib.mkOption { type = (lib.types.submodule ({ ... }: { options = { qemuAgent = lib.mkOption { type = (lib.types.either lib.types.bool (lib.types.enum [ null ])); default = null; description = "Enable the QEMU guest agent. Unset values preserve existing policy."; }; spiceAgent = lib.mkOption { type = (lib.types.either lib.types.bool (lib.types.enum [ null ])); default = null; description = "Enable SPICE desktop integration. Unset values preserve existing policy."; }; }; })); default = { }; }; libvirt = lib.mkOption { type = (lib.types.submodule ({ ... }: { options = { enable = lib.mkOption { type = (lib.types.either lib.types.bool (lib.types.enum [ null ])); default = null; description = "Run virtual machines using Libvirt. Unset values preserve existing policy."; }; manager = lib.mkOption { type = (lib.types.either lib.types.bool (lib.types.enum [ null ])); default = null; description = "Install the graphical virtual machine manager. Unset values preserve existing policy."; }; runAsRoot = lib.mkOption { type = (lib.types.either lib.types.bool (lib.types.enum [ null ])); default = null; description = "Run virtual machines as root. Unset values preserve existing policy."; }; socketNetworkTransport = lib.mkOption { type = (lib.types.either lib.types.bool (lib.types.enum [ null ])); default = null; description = "Make passt available to enabled Libvirt guests. Unset values preserve existing policy."; }; startGuestsOnBoot = lib.mkOption { type = (lib.types.either (lib.types.enum [
  "ignore"
  "start"
]) (lib.types.enum [ null ])); default = null; description = "Restore previously running guests at boot. Unset values preserve existing policy."; }; stopGuestsOnShutdown = lib.mkOption { type = (lib.types.either (lib.types.enum [
  "shutdown"
  "suspend"
]) (lib.types.enum [ null ])); default = null; description = "Guest action when shutting down the host. Unset values preserve existing policy."; }; virtualTpm = lib.mkOption { type = (lib.types.either lib.types.bool (lib.types.enum [ null ])); default = null; description = "Provide virtual trusted platform modules. Unset values preserve existing policy."; }; }; })); default = { }; }; podman = lib.mkOption { type = (lib.types.submodule ({ ... }: { options = { dockerCompatibility = lib.mkOption { type = (lib.types.either lib.types.bool (lib.types.enum [ null ])); default = null; description = "Provide the Docker command using Podman. Unset values preserve existing policy."; }; enable = lib.mkOption { type = (lib.types.either lib.types.bool (lib.types.enum [ null ])); default = null; description = "Run Podman containers. Unset values preserve existing policy."; }; }; })); default = { }; }; }; })); default = { }; };
  config = lib.mkMerge [
    { _module.args.zenlang.descriptors.system.virtualization = {
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
            value = "Virtual machines and containers. Unset values preserve existing policy.";
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
            value = "Virtual machines and containers";
          }
        ];
        type = "string";
      };
      summary = {
        multiline = false;
        parts = [
          {
            type = "text";
            value = "Virtual machines and containers";
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
    moduleIdentity = "zenos.system.virtualization";
    modulePath = [
      "system"
      "virtualization"
    ];
    nodeMetadata = [
      {
        metadata = {
          description = {
            multiline = true;
            parts = [
              {
                type = "text";
                value = "Virtual machines and containers. Unset values preserve existing policy.";
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
                value = "Virtual machines and containers";
              }
            ];
            type = "string";
          };
          summary = {
            multiline = false;
            parts = [
              {
                type = "text";
                value = "Virtual machines and containers";
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
          "libvirt"
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
                value = "Run virtual machines using Libvirt. Unset values preserve existing policy.";
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
                value = "Run virtual machines using Libvirt";
              }
            ];
            type = "string";
          };
          summary = {
            multiline = false;
            parts = [
              {
                type = "text";
                value = "Run virtual machines using Libvirt";
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
          "libvirt"
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
                value = "Provide virtual trusted platform modules. Unset values preserve existing policy.";
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
                value = "Provide virtual trusted platform modules";
              }
            ];
            type = "string";
          };
          summary = {
            multiline = false;
            parts = [
              {
                type = "text";
                value = "Provide virtual trusted platform modules";
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
          "libvirt"
          "virtualTpm"
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
                value = "Run virtual machines as root. Unset values preserve existing policy.";
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
                value = "Run virtual machines as root";
              }
            ];
            type = "string";
          };
          summary = {
            multiline = false;
            parts = [
              {
                type = "text";
                value = "Run virtual machines as root";
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
          "libvirt"
          "runAsRoot"
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
                value = "Restore previously running guests at boot. Unset values preserve existing policy.";
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
                value = "Restore previously running guests at boot";
              }
            ];
            type = "string";
          };
          summary = {
            multiline = false;
            parts = [
              {
                type = "text";
                value = "Restore previously running guests at boot";
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
                              multiline = false;
                              parts = [
                                {
                                  type = "text";
                                  value = "ignore";
                                }
                              ];
                              type = "string";
                            }
                            {
                              multiline = false;
                              parts = [
                                {
                                  type = "text";
                                  value = "start";
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
          "libvirt"
          "startGuestsOnBoot"
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
                value = "Guest action when shutting down the host. Unset values preserve existing policy.";
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
                value = "Guest action when shutting down the host";
              }
            ];
            type = "string";
          };
          summary = {
            multiline = false;
            parts = [
              {
                type = "text";
                value = "Guest action when shutting down the host";
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
                              multiline = false;
                              parts = [
                                {
                                  type = "text";
                                  value = "shutdown";
                                }
                              ];
                              type = "string";
                            }
                            {
                              multiline = false;
                              parts = [
                                {
                                  type = "text";
                                  value = "suspend";
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
          "libvirt"
          "stopGuestsOnShutdown"
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
                value = "Install the graphical virtual machine manager. Unset values preserve existing policy.";
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
                value = "Install the graphical virtual machine manager";
              }
            ];
            type = "string";
          };
          summary = {
            multiline = false;
            parts = [
              {
                type = "text";
                value = "Install the graphical virtual machine manager";
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
          "libvirt"
          "manager"
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
                value = "Make passt available to enabled Libvirt guests. Unset values preserve existing policy.";
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
                value = "Make passt available to enabled Libvirt guests";
              }
            ];
            type = "string";
          };
          summary = {
            multiline = false;
            parts = [
              {
                type = "text";
                value = "Make passt available to enabled Libvirt guests";
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
          "libvirt"
          "socketNetworkTransport"
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
          "docker"
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
                value = "Run Docker containers. Unset values preserve existing policy.";
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
                value = "Run Docker containers";
              }
            ];
            type = "string";
          };
          summary = {
            multiline = false;
            parts = [
              {
                type = "text";
                value = "Run Docker containers";
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
          "docker"
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
                value = "Run a per-user Docker daemon without root. Unset values preserve existing policy.";
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
                value = "Run a per-user Docker daemon without root";
              }
            ];
            type = "string";
          };
          summary = {
            multiline = false;
            parts = [
              {
                type = "text";
                value = "Run a per-user Docker daemon without root";
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
          "docker"
          "rootless"
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
                value = "Export the rootless Docker socket to user sessions. Unset values preserve existing policy.";
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
                value = "Export the rootless Docker socket to user sessions";
              }
            ];
            type = "string";
          };
          summary = {
            multiline = false;
            parts = [
              {
                type = "text";
                value = "Export the rootless Docker socket to user sessions";
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
          "docker"
          "exportSocket"
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
                value = "Docker container storage driver. Unset values preserve existing policy.";
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
                value = "Docker container storage driver";
              }
            ];
            type = "string";
          };
          summary = {
            multiline = false;
            parts = [
              {
                type = "text";
                value = "Docker container storage driver";
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
                          value = "string";
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
          "docker"
          "storageDriver"
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
          "podman"
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
                value = "Run Podman containers. Unset values preserve existing policy.";
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
                value = "Run Podman containers";
              }
            ];
            type = "string";
          };
          summary = {
            multiline = false;
            parts = [
              {
                type = "text";
                value = "Run Podman containers";
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
          "podman"
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
                value = "Provide the Docker command using Podman. Unset values preserve existing policy.";
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
                value = "Provide the Docker command using Podman";
              }
            ];
            type = "string";
          };
          summary = {
            multiline = false;
            parts = [
              {
                type = "text";
                value = "Provide the Docker command using Podman";
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
          "podman"
          "dockerCompatibility"
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
          "guest"
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
                value = "Enable the QEMU guest agent. Unset values preserve existing policy.";
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
                value = "Enable the QEMU guest agent";
              }
            ];
            type = "string";
          };
          summary = {
            multiline = false;
            parts = [
              {
                type = "text";
                value = "Enable the QEMU guest agent";
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
          "guest"
          "qemuAgent"
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
                value = "Enable SPICE desktop integration. Unset values preserve existing policy.";
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
                value = "Enable SPICE desktop integration";
              }
            ];
            type = "string";
          };
          summary = {
            multiline = false;
            parts = [
              {
                type = "text";
                value = "Enable SPICE desktop integration";
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
          "guest"
          "spiceAgent"
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
                    value = "Virtual machines and containers";
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
                    value = "Virtual machines and containers";
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
                    value = "Virtual machines and containers. Unset values preserve existing policy.";
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
            value = "libvirt";
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
                                value = "Run virtual machines using Libvirt";
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
                                value = "Run virtual machines using Libvirt";
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
                                value = "Run virtual machines using Libvirt. Unset values preserve existing policy.";
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
                              value = "virtualisation";
                            }
                            {
                              kind = "identifier";
                              value = "libvirtd";
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
                                      value = "libvirt";
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
                                          value = "libvirt";
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
                  value = "virtualTpm";
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
                                value = "Provide virtual trusted platform modules";
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
                                value = "Provide virtual trusted platform modules";
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
                                value = "Provide virtual trusted platform modules. Unset values preserve existing policy.";
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
                              value = "virtualisation";
                            }
                            {
                              kind = "identifier";
                              value = "libvirtd";
                            }
                            {
                              kind = "identifier";
                              value = "qemu";
                            }
                            {
                              kind = "identifier";
                              value = "swtpm";
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
                                      value = "libvirt";
                                    }
                                    {
                                      kind = "identifier";
                                      value = "virtualTpm";
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
                                          value = "libvirt";
                                        }
                                        {
                                          kind = "identifier";
                                          value = "virtualTpm";
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
                  value = "runAsRoot";
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
                                value = "Run virtual machines as root";
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
                                value = "Run virtual machines as root";
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
                                value = "Run virtual machines as root. Unset values preserve existing policy.";
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
                              value = "virtualisation";
                            }
                            {
                              kind = "identifier";
                              value = "libvirtd";
                            }
                            {
                              kind = "identifier";
                              value = "qemu";
                            }
                            {
                              kind = "identifier";
                              value = "runAsRoot";
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
                                      value = "libvirt";
                                    }
                                    {
                                      kind = "identifier";
                                      value = "runAsRoot";
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
                                          value = "libvirt";
                                        }
                                        {
                                          kind = "identifier";
                                          value = "runAsRoot";
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
                  value = "startGuestsOnBoot";
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
                                value = "Restore previously running guests at boot";
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
                                value = "Restore previously running guests at boot";
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
                                value = "Restore previously running guests at boot. Unset values preserve existing policy.";
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
                                              multiline = false;
                                              parts = [
                                                {
                                                  type = "text";
                                                  value = "ignore";
                                                }
                                              ];
                                              type = "string";
                                            }
                                            {
                                              multiline = false;
                                              parts = [
                                                {
                                                  type = "text";
                                                  value = "start";
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
                              value = "virtualisation";
                            }
                            {
                              kind = "identifier";
                              value = "libvirtd";
                            }
                            {
                              kind = "identifier";
                              value = "onBoot";
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
                                      value = "libvirt";
                                    }
                                    {
                                      kind = "identifier";
                                      value = "startGuestsOnBoot";
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
                                          value = "libvirt";
                                        }
                                        {
                                          kind = "identifier";
                                          value = "startGuestsOnBoot";
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
                  value = "stopGuestsOnShutdown";
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
                                value = "Guest action when shutting down the host";
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
                                value = "Guest action when shutting down the host";
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
                                value = "Guest action when shutting down the host. Unset values preserve existing policy.";
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
                                              multiline = false;
                                              parts = [
                                                {
                                                  type = "text";
                                                  value = "shutdown";
                                                }
                                              ];
                                              type = "string";
                                            }
                                            {
                                              multiline = false;
                                              parts = [
                                                {
                                                  type = "text";
                                                  value = "suspend";
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
                              value = "virtualisation";
                            }
                            {
                              kind = "identifier";
                              value = "libvirtd";
                            }
                            {
                              kind = "identifier";
                              value = "onShutdown";
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
                                      value = "libvirt";
                                    }
                                    {
                                      kind = "identifier";
                                      value = "stopGuestsOnShutdown";
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
                                          value = "libvirt";
                                        }
                                        {
                                          kind = "identifier";
                                          value = "stopGuestsOnShutdown";
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
                  value = "manager";
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
                                value = "Install the graphical virtual machine manager";
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
                                value = "Install the graphical virtual machine manager";
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
                                value = "Install the graphical virtual machine manager. Unset values preserve existing policy.";
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
                              value = "virt-manager";
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
                                      value = "libvirt";
                                    }
                                    {
                                      kind = "identifier";
                                      value = "manager";
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
                                          value = "libvirt";
                                        }
                                        {
                                          kind = "identifier";
                                          value = "manager";
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
                  value = "socketNetworkTransport";
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
                                value = "Make passt available to enabled Libvirt guests";
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
                                value = "Make passt available to enabled Libvirt guests";
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
                                value = "Make passt available to enabled Libvirt guests. Unset values preserve existing policy.";
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
                              value = "systemd";
                            }
                            {
                              kind = "identifier";
                              value = "services";
                            }
                            {
                              kind = "identifier";
                              value = "libvirtd";
                            }
                            {
                              kind = "identifier";
                              value = "path";
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
                                      items = [
                                        {
                                          name = "pkgs";
                                          path = [
                                            {
                                              kind = "identifier";
                                              value = "byCategories";
                                            }
                                            {
                                              kind = "identifier";
                                              value = "apps";
                                            }
                                            {
                                              kind = "identifier";
                                              value = "virtualization";
                                            }
                                            {
                                              kind = "identifier";
                                              value = "passt";
                                            }
                                          ];
                                          type = "variable";
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
                                          left = {
                                            left = {
                                              name = "path";
                                              path = [
                                                {
                                                  kind = "identifier";
                                                  value = "libvirt";
                                                }
                                                {
                                                  kind = "identifier";
                                                  value = "enable";
                                                }
                                              ];
                                              type = "variable";
                                            };
                                            operator = "==";
                                            right = {
                                              kind = "true";
                                              type = "literal";
                                              value = true;
                                            };
                                            type = "binary";
                                          };
                                          operator = "&&";
                                          right = {
                                            name = "path";
                                            path = [
                                              {
                                                kind = "identifier";
                                                value = "libvirt";
                                              }
                                              {
                                                kind = "identifier";
                                                value = "socketNetworkTransport";
                                              }
                                            ];
                                            type = "variable";
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
                                          value = "libvirt";
                                        }
                                        {
                                          kind = "identifier";
                                          value = "socketNetworkTransport";
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
            value = "docker";
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
                                value = "Run Docker containers";
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
                                value = "Run Docker containers";
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
                                value = "Run Docker containers. Unset values preserve existing policy.";
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
                              value = "virtualisation";
                            }
                            {
                              kind = "identifier";
                              value = "docker";
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
                                      value = "docker";
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
                                          value = "docker";
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
                  value = "rootless";
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
                                value = "Run a per-user Docker daemon without root";
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
                                value = "Run a per-user Docker daemon without root";
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
                                value = "Run a per-user Docker daemon without root. Unset values preserve existing policy.";
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
                              value = "virtualisation";
                            }
                            {
                              kind = "identifier";
                              value = "docker";
                            }
                            {
                              kind = "identifier";
                              value = "rootless";
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
                                      value = "docker";
                                    }
                                    {
                                      kind = "identifier";
                                      value = "rootless";
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
                                          value = "docker";
                                        }
                                        {
                                          kind = "identifier";
                                          value = "rootless";
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
                  value = "exportSocket";
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
                                value = "Export the rootless Docker socket to user sessions";
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
                                value = "Export the rootless Docker socket to user sessions";
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
                                value = "Export the rootless Docker socket to user sessions. Unset values preserve existing policy.";
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
                              value = "virtualisation";
                            }
                            {
                              kind = "identifier";
                              value = "docker";
                            }
                            {
                              kind = "identifier";
                              value = "rootless";
                            }
                            {
                              kind = "identifier";
                              value = "setSocketVariable";
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
                                      value = "docker";
                                    }
                                    {
                                      kind = "identifier";
                                      value = "exportSocket";
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
                                          value = "docker";
                                        }
                                        {
                                          kind = "identifier";
                                          value = "exportSocket";
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
                  value = "storageDriver";
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
                                value = "Docker container storage driver";
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
                                value = "Docker container storage driver";
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
                                value = "Docker container storage driver. Unset values preserve existing policy.";
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
                                          value = "string";
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
                              value = "virtualisation";
                            }
                            {
                              kind = "identifier";
                              value = "docker";
                            }
                            {
                              kind = "identifier";
                              value = "storageDriver";
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
                                      value = "docker";
                                    }
                                    {
                                      kind = "identifier";
                                      value = "storageDriver";
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
                                          value = "docker";
                                        }
                                        {
                                          kind = "identifier";
                                          value = "storageDriver";
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
            value = "podman";
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
                                value = "Run Podman containers";
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
                                value = "Run Podman containers";
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
                                value = "Run Podman containers. Unset values preserve existing policy.";
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
                              value = "virtualisation";
                            }
                            {
                              kind = "identifier";
                              value = "podman";
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
                                      value = "podman";
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
                                          value = "podman";
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
                  value = "dockerCompatibility";
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
                                value = "Provide the Docker command using Podman";
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
                                value = "Provide the Docker command using Podman";
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
                                value = "Provide the Docker command using Podman. Unset values preserve existing policy.";
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
                              value = "virtualisation";
                            }
                            {
                              kind = "identifier";
                              value = "podman";
                            }
                            {
                              kind = "identifier";
                              value = "dockerCompat";
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
                                      value = "podman";
                                    }
                                    {
                                      kind = "identifier";
                                      value = "dockerCompatibility";
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
                                          value = "podman";
                                        }
                                        {
                                          kind = "identifier";
                                          value = "dockerCompatibility";
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
            value = "guest";
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
                  value = "qemuAgent";
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
                                value = "Enable the QEMU guest agent";
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
                                value = "Enable the QEMU guest agent";
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
                                value = "Enable the QEMU guest agent. Unset values preserve existing policy.";
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
                              value = "services";
                            }
                            {
                              kind = "identifier";
                              value = "qemuGuest";
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
                                      value = "guest";
                                    }
                                    {
                                      kind = "identifier";
                                      value = "qemuAgent";
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
                                          value = "guest";
                                        }
                                        {
                                          kind = "identifier";
                                          value = "qemuAgent";
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
                  value = "spiceAgent";
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
                                value = "Enable SPICE desktop integration";
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
                                value = "Enable SPICE desktop integration";
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
                                value = "Enable SPICE desktop integration. Unset values preserve existing policy.";
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
                              value = "services";
                            }
                            {
                              kind = "identifier";
                              value = "spice-vdagentd";
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
                                      value = "guest";
                                    }
                                    {
                                      kind = "identifier";
                                      value = "spiceAgent";
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
                                          value = "guest";
                                        }
                                        {
                                          kind = "identifier";
                                          value = "spiceAgent";
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
      virtualisation.libvirtd.enable = ((lib.mkIf ((cfg.libvirt.enable != null))) (cfg.libvirt.enable));
    }
    {
      virtualisation.libvirtd.qemu.swtpm.enable = ((lib.mkIf ((cfg.libvirt.virtualTpm != null))) (cfg.libvirt.virtualTpm));
    }
    {
      virtualisation.libvirtd.qemu.runAsRoot = ((lib.mkIf ((cfg.libvirt.runAsRoot != null))) (cfg.libvirt.runAsRoot));
    }
    {
      virtualisation.libvirtd.onBoot = ((lib.mkIf ((cfg.libvirt.startGuestsOnBoot != null))) (cfg.libvirt.startGuestsOnBoot));
    }
    {
      virtualisation.libvirtd.onShutdown = ((lib.mkIf ((cfg.libvirt.stopGuestsOnShutdown != null))) (cfg.libvirt.stopGuestsOnShutdown));
    }
    {
      programs.virt-manager.enable = ((lib.mkIf ((cfg.libvirt.manager != null))) (cfg.libvirt.manager));
    }
    {
      systemd.services.libvirtd.path = ((lib.mkIf ((cfg.libvirt.socketNetworkTransport != null))) (((lib.mkIf (((cfg.libvirt.enable == true) && cfg.libvirt.socketNetworkTransport))) [
        pkgs.zenos.byCategories.apps.virtualization.passt
      ])));
    }
    {
      virtualisation.docker.enable = ((lib.mkIf ((cfg.docker.enable != null))) (cfg.docker.enable));
    }
    {
      virtualisation.docker.rootless.enable = ((lib.mkIf ((cfg.docker.rootless != null))) (cfg.docker.rootless));
    }
    {
      virtualisation.docker.rootless.setSocketVariable = ((lib.mkIf ((cfg.docker.exportSocket != null))) (cfg.docker.exportSocket));
    }
    {
      virtualisation.docker.storageDriver = ((lib.mkIf ((cfg.docker.storageDriver != null))) (cfg.docker.storageDriver));
    }
    {
      virtualisation.podman.enable = ((lib.mkIf ((cfg.podman.enable != null))) (cfg.podman.enable));
    }
    {
      virtualisation.podman.dockerCompat = ((lib.mkIf ((cfg.podman.dockerCompatibility != null))) (cfg.podman.dockerCompatibility));
    }
    {
      services.qemuGuest.enable = ((lib.mkIf ((cfg.guest.qemuAgent != null))) (cfg.guest.qemuAgent));
    }
    {
      services.spice-vdagentd.enable = ((lib.mkIf ((cfg.guest.spiceAgent != null))) (cfg.guest.spiceAgent));
    }
  ];
}
