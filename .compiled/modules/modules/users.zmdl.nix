{ config, lib, pkgs, maintainers ? lib.maintainers, licenses ? lib.licenses, ... }:
let
  cfg = config.zenos.users;
  name = "users";
in
{
  options.zenos.users = lib.mkOption { type = (lib.types.submodule ({ ... }: { options = { }; freeformType = lib.types.attrsOf (lib.types.submodule ({ name, ... }: let _zenFreeformKey0 = name; in { options = { profile = lib.mkOption { type = (lib.types.submodule ({ ... }: { options = { displayName = lib.mkOption { type = (lib.types.either lib.types.str (lib.types.enum [ null ])); default = null; description = "Name shown on the login screen. Null leaves this preference unchanged."; }; groups = lib.mkOption { type = (lib.types.either (lib.types.listOf lib.types.str) (lib.types.enum [ null ])); default = null; description = "Additional group memberships. Uses normal additive group-list merging; an empty list adds no groups. Null leaves this preference unchanged."; }; homeDirectory = lib.mkOption { type = (lib.types.either lib.types.str (lib.types.enum [ null ])); default = null; description = "Absolute path to the home directory. Must be absolute. Changing this path does not migrate existing files. Null leaves this preference unchanged."; }; linger = lib.mkOption { type = (lib.types.either lib.types.bool (lib.types.enum [ null ])); default = null; description = "Keep user services running after logout. Null leaves this preference unchanged."; }; loginShell = lib.mkOption { type = (lib.types.either lib.types.package (lib.types.enum [ null ])); default = null; description = "Login shell package. The selected shell must be supported and enabled by the system. This does not enable a system-wide shell service. Null leaves this preference unchanged."; }; normalUser = lib.mkOption { type = (lib.types.either lib.types.bool (lib.types.enum [ null ])); default = null; description = "Create a regular login account. True creates a normal user; false does not implicitly select a system account. Existing accounts may leave this unset. Null leaves this preference unchanged."; }; passwordHashFile = lib.mkOption { type = (lib.types.either lib.types.str (lib.types.enum [ null ])); default = null; description = "Runtime file containing the password hash. An absolute runtime path, never a plaintext password or store-imported secret. Null leaves this preference unchanged."; }; sshKeys = lib.mkOption { type = (lib.types.either (lib.types.listOf lib.types.str) (lib.types.enum [ null ])); default = null; description = "Authorized SSH public keys. Public keys only; uses normal additive list merging. Null leaves this preference unchanged."; }; uid = lib.mkOption { type = (lib.types.either lib.types.int (lib.types.enum [ null ])); default = null; description = "Stable numeric user identifier. Must be between 0 and 4294967294. Null leaves this preference unchanged."; }; }; })); default = { }; description = "Account choices apply only to this user. Unset choices preserve the existing account policy."; }; }; })); })); default = { }; };
  config = lib.mkMerge [
    { _module.args.zenlang.descriptors.users = {
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
            value = "Declares account settings alongside session preferences in the unified user tree.";
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
            value = "User accounts";
          }
        ];
        type = "string";
      };
      summary = {
        multiline = false;
        parts = [
          {
            type = "text";
            value = "Account profiles for managed users";
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
                value = "users";
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
    moduleIdentity = "zenos.users";
    modulePath = [
      "users"
    ];
    nodeMetadata = [
      {
        metadata = {
          description = {
            multiline = true;
            parts = [
              {
                type = "text";
                value = "Declares account settings alongside session preferences in the unified user tree.";
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
                value = "User accounts";
              }
            ];
            type = "string";
          };
          summary = {
            multiline = false;
            parts = [
              {
                type = "text";
                value = "Account profiles for managed users";
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
                    value = "users";
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
          description = {
            multiline = true;
            parts = [
              {
                type = "text";
                value = "Settings belonging to user ";
              }
              {
                expression = {
                  name = "f";
                  path = [
                    {
                      kind = "identifier";
                      value = "user";
                    }
                  ];
                  type = "variable";
                };
                type = "interpolation";
              }
              {
                type = "text";
                value = ".";
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
                value = "User ";
              }
              {
                expression = {
                  name = "f";
                  path = [
                    {
                      kind = "identifier";
                      value = "user";
                    }
                  ];
                  type = "variable";
                };
                type = "interpolation";
              }
            ];
            type = "string";
          };
          summary = {
            multiline = false;
            parts = [
              {
                type = "text";
                value = "Account and personal settings";
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
                    value = "users";
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
        path = [
          {
            freeform = "user";
          }
        ];
      }
      {
        metadata = {
          description = {
            multiline = true;
            parts = [
              {
                type = "text";
                value = "Account choices apply only to this user. Unset choices preserve the existing account policy.";
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
                value = "Account profile";
              }
            ];
            type = "string";
          };
          summary = {
            multiline = false;
            parts = [
              {
                type = "text";
                value = "Login account and identity";
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
                    value = "users";
                  }
                ];
                type = "string";
              }
              {
                multiline = false;
                parts = [
                  {
                    type = "text";
                    value = "profile";
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
        path = [
          {
            freeform = "user";
          }
          "profile"
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
                value = "Create a regular login account. True creates a normal user; false does not implicitly select a system account. Existing accounts may leave this unset. Null leaves this preference unchanged.";
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
                value = "Create a regular login account";
              }
            ];
            type = "string";
          };
          summary = {
            multiline = false;
            parts = [
              {
                type = "text";
                value = "Create a regular login account";
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
                    value = "users";
                  }
                ];
                type = "string";
              }
              {
                multiline = false;
                parts = [
                  {
                    type = "text";
                    value = "profile";
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
          {
            freeform = "user";
          }
          "profile"
          "normalUser"
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
                value = "Name shown on the login screen. Null leaves this preference unchanged.";
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
                value = "Name shown on the login screen";
              }
            ];
            type = "string";
          };
          summary = {
            multiline = false;
            parts = [
              {
                type = "text";
                value = "Name shown on the login screen";
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
                    value = "users";
                  }
                ];
                type = "string";
              }
              {
                multiline = false;
                parts = [
                  {
                    type = "text";
                    value = "profile";
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
          {
            freeform = "user";
          }
          "profile"
          "displayName"
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
                value = "Absolute path to the home directory. Must be absolute. Changing this path does not migrate existing files. Null leaves this preference unchanged.";
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
                value = "Absolute path to the home directory";
              }
            ];
            type = "string";
          };
          summary = {
            multiline = false;
            parts = [
              {
                type = "text";
                value = "Absolute path to the home directory";
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
                    value = "users";
                  }
                ];
                type = "string";
              }
              {
                multiline = false;
                parts = [
                  {
                    type = "text";
                    value = "profile";
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
          {
            freeform = "user";
          }
          "profile"
          "homeDirectory"
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
                value = "Stable numeric user identifier. Must be between 0 and 4294967294. Null leaves this preference unchanged.";
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
                value = "Stable numeric user identifier";
              }
            ];
            type = "string";
          };
          summary = {
            multiline = false;
            parts = [
              {
                type = "text";
                value = "Stable numeric user identifier";
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
                    value = "users";
                  }
                ];
                type = "string";
              }
              {
                multiline = false;
                parts = [
                  {
                    type = "text";
                    value = "profile";
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
                          value = "int";
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
          {
            freeform = "user";
          }
          "profile"
          "uid"
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
                value = "Additional group memberships. Uses normal additive group-list merging; an empty list adds no groups. Null leaves this preference unchanged.";
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
                value = "Additional group memberships";
              }
            ];
            type = "string";
          };
          summary = {
            multiline = false;
            parts = [
              {
                type = "text";
                value = "Additional group memberships";
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
                    value = "users";
                  }
                ];
                type = "string";
              }
              {
                multiline = false;
                parts = [
                  {
                    type = "text";
                    value = "profile";
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
                                  value = "string";
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
          {
            freeform = "user";
          }
          "profile"
          "groups"
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
                value = "Authorized SSH public keys. Public keys only; uses normal additive list merging. Null leaves this preference unchanged.";
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
                value = "Authorized SSH public keys";
              }
            ];
            type = "string";
          };
          summary = {
            multiline = false;
            parts = [
              {
                type = "text";
                value = "Authorized SSH public keys";
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
                    value = "users";
                  }
                ];
                type = "string";
              }
              {
                multiline = false;
                parts = [
                  {
                    type = "text";
                    value = "profile";
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
                                  value = "string";
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
          {
            freeform = "user";
          }
          "profile"
          "sshKeys"
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
                value = "Runtime file containing the password hash. An absolute runtime path, never a plaintext password or store-imported secret. Null leaves this preference unchanged.";
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
                value = "Runtime file containing the password hash";
              }
            ];
            type = "string";
          };
          summary = {
            multiline = false;
            parts = [
              {
                type = "text";
                value = "Runtime file containing the password hash";
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
                    value = "users";
                  }
                ];
                type = "string";
              }
              {
                multiline = false;
                parts = [
                  {
                    type = "text";
                    value = "profile";
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
          {
            freeform = "user";
          }
          "profile"
          "passwordHashFile"
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
                value = "Keep user services running after logout. Null leaves this preference unchanged.";
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
                value = "Keep user services running after logout";
              }
            ];
            type = "string";
          };
          summary = {
            multiline = false;
            parts = [
              {
                type = "text";
                value = "Keep user services running after logout";
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
                    value = "users";
                  }
                ];
                type = "string";
              }
              {
                multiline = false;
                parts = [
                  {
                    type = "text";
                    value = "profile";
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
          {
            freeform = "user";
          }
          "profile"
          "linger"
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
                value = "Login shell package. The selected shell must be supported and enabled by the system. This does not enable a system-wide shell service. Null leaves this preference unchanged.";
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
                value = "Login shell package";
              }
            ];
            type = "string";
          };
          summary = {
            multiline = false;
            parts = [
              {
                type = "text";
                value = "Login shell package";
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
                    value = "users";
                  }
                ];
                type = "string";
              }
              {
                multiline = false;
                parts = [
                  {
                    type = "text";
                    value = "shell";
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
          {
            freeform = "user";
          }
          "profile"
          "loginShell"
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
                  value = "name";
                }
              ];
              type = "assignment";
              value = {
                multiline = false;
                parts = [
                  {
                    type = "text";
                    value = "User accounts";
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
                    value = "Account profiles for managed users";
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
                    value = "Declares account settings alongside session preferences in the unified user tree.";
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
                        value = "users";
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
          ];
          type = "attr-set";
        };
      }
      {
        operator = "=";
        target = {
          argument = [
            {
              kind = "identifier";
              value = "user";
            }
          ];
          kind = "freeform";
          type = "structural-marker";
        };
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
                          value = "User ";
                        }
                        {
                          expression = {
                            name = "f";
                            path = [
                              {
                                kind = "identifier";
                                value = "user";
                              }
                            ];
                            type = "variable";
                          };
                          type = "interpolation";
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
                          value = "Account and personal settings";
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
                          value = "Settings belonging to user ";
                        }
                        {
                          expression = {
                            name = "f";
                            path = [
                              {
                                kind = "identifier";
                                value = "user";
                              }
                            ];
                            type = "variable";
                          };
                          type = "interpolation";
                        }
                        {
                          type = "text";
                          value = ".";
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
                              value = "users";
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
                ];
                type = "attr-set";
              };
            }
            {
              operator = "=";
              target = [
                {
                  kind = "identifier";
                  value = "profile";
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
                                value = "Account profile";
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
                                value = "Login account and identity";
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
                                value = "Account choices apply only to this user. Unset choices preserve the existing account policy.";
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
                                    value = "users";
                                  }
                                ];
                                type = "string";
                              }
                              {
                                multiline = false;
                                parts = [
                                  {
                                    type = "text";
                                    value = "profile";
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
                      ];
                      type = "attr-set";
                    };
                  }
                  {
                    operator = "=";
                    target = [
                      {
                        kind = "identifier";
                        value = "normalUser";
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
                                      value = "Create a regular login account";
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
                                      value = "Create a regular login account";
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
                                      value = "Create a regular login account. True creates a normal user; false does not implicitly select a system account. Existing accounts may leave this unset. Null leaves this preference unchanged.";
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
                                          value = "users";
                                        }
                                      ];
                                      type = "string";
                                    }
                                    {
                                      multiline = false;
                                      parts = [
                                        {
                                          type = "text";
                                          value = "profile";
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
                                    value = "users";
                                  }
                                  {
                                    kind = "identifier";
                                    value = "users";
                                  }
                                  {
                                    kind = "dynamic";
                                    value = {
                                      name = "f";
                                      path = [
                                        {
                                          kind = "identifier";
                                          value = "user";
                                        }
                                      ];
                                      type = "variable";
                                    };
                                  }
                                  {
                                    kind = "identifier";
                                    value = "isNormalUser";
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
                                            kind = "dynamic";
                                            value = {
                                              name = "f";
                                              path = [
                                                {
                                                  kind = "identifier";
                                                  value = "user";
                                                }
                                              ];
                                              type = "variable";
                                            };
                                          }
                                          {
                                            kind = "identifier";
                                            value = "profile";
                                          }
                                          {
                                            kind = "identifier";
                                            value = "normalUser";
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
                                                kind = "dynamic";
                                                value = {
                                                  name = "f";
                                                  path = [
                                                    {
                                                      kind = "identifier";
                                                      value = "user";
                                                    }
                                                  ];
                                                  type = "variable";
                                                };
                                              }
                                              {
                                                kind = "identifier";
                                                value = "profile";
                                              }
                                              {
                                                kind = "identifier";
                                                value = "normalUser";
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
                        value = "displayName";
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
                                      value = "Name shown on the login screen";
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
                                      value = "Name shown on the login screen";
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
                                      value = "Name shown on the login screen. Null leaves this preference unchanged.";
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
                                          value = "users";
                                        }
                                      ];
                                      type = "string";
                                    }
                                    {
                                      multiline = false;
                                      parts = [
                                        {
                                          type = "text";
                                          value = "profile";
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
                                    value = "users";
                                  }
                                  {
                                    kind = "identifier";
                                    value = "users";
                                  }
                                  {
                                    kind = "dynamic";
                                    value = {
                                      name = "f";
                                      path = [
                                        {
                                          kind = "identifier";
                                          value = "user";
                                        }
                                      ];
                                      type = "variable";
                                    };
                                  }
                                  {
                                    kind = "identifier";
                                    value = "description";
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
                                            kind = "dynamic";
                                            value = {
                                              name = "f";
                                              path = [
                                                {
                                                  kind = "identifier";
                                                  value = "user";
                                                }
                                              ];
                                              type = "variable";
                                            };
                                          }
                                          {
                                            kind = "identifier";
                                            value = "profile";
                                          }
                                          {
                                            kind = "identifier";
                                            value = "displayName";
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
                                                kind = "dynamic";
                                                value = {
                                                  name = "f";
                                                  path = [
                                                    {
                                                      kind = "identifier";
                                                      value = "user";
                                                    }
                                                  ];
                                                  type = "variable";
                                                };
                                              }
                                              {
                                                kind = "identifier";
                                                value = "profile";
                                              }
                                              {
                                                kind = "identifier";
                                                value = "displayName";
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
                        value = "homeDirectory";
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
                                      value = "Absolute path to the home directory";
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
                                      value = "Absolute path to the home directory";
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
                                      value = "Absolute path to the home directory. Must be absolute. Changing this path does not migrate existing files. Null leaves this preference unchanged.";
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
                                          value = "users";
                                        }
                                      ];
                                      type = "string";
                                    }
                                    {
                                      multiline = false;
                                      parts = [
                                        {
                                          type = "text";
                                          value = "profile";
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
                                    value = "users";
                                  }
                                  {
                                    kind = "identifier";
                                    value = "users";
                                  }
                                  {
                                    kind = "dynamic";
                                    value = {
                                      name = "f";
                                      path = [
                                        {
                                          kind = "identifier";
                                          value = "user";
                                        }
                                      ];
                                      type = "variable";
                                    };
                                  }
                                  {
                                    kind = "identifier";
                                    value = "home";
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
                                            kind = "dynamic";
                                            value = {
                                              name = "f";
                                              path = [
                                                {
                                                  kind = "identifier";
                                                  value = "user";
                                                }
                                              ];
                                              type = "variable";
                                            };
                                          }
                                          {
                                            kind = "identifier";
                                            value = "profile";
                                          }
                                          {
                                            kind = "identifier";
                                            value = "homeDirectory";
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
                                                kind = "dynamic";
                                                value = {
                                                  name = "f";
                                                  path = [
                                                    {
                                                      kind = "identifier";
                                                      value = "user";
                                                    }
                                                  ];
                                                  type = "variable";
                                                };
                                              }
                                              {
                                                kind = "identifier";
                                                value = "profile";
                                              }
                                              {
                                                kind = "identifier";
                                                value = "homeDirectory";
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
                        value = "uid";
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
                                      value = "Stable numeric user identifier";
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
                                      value = "Stable numeric user identifier";
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
                                      value = "Stable numeric user identifier. Must be between 0 and 4294967294. Null leaves this preference unchanged.";
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
                                          value = "users";
                                        }
                                      ];
                                      type = "string";
                                    }
                                    {
                                      multiline = false;
                                      parts = [
                                        {
                                          type = "text";
                                          value = "profile";
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
                                                value = "int";
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
                                    value = "users";
                                  }
                                  {
                                    kind = "identifier";
                                    value = "users";
                                  }
                                  {
                                    kind = "dynamic";
                                    value = {
                                      name = "f";
                                      path = [
                                        {
                                          kind = "identifier";
                                          value = "user";
                                        }
                                      ];
                                      type = "variable";
                                    };
                                  }
                                  {
                                    kind = "identifier";
                                    value = "uid";
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
                                            kind = "dynamic";
                                            value = {
                                              name = "f";
                                              path = [
                                                {
                                                  kind = "identifier";
                                                  value = "user";
                                                }
                                              ];
                                              type = "variable";
                                            };
                                          }
                                          {
                                            kind = "identifier";
                                            value = "profile";
                                          }
                                          {
                                            kind = "identifier";
                                            value = "uid";
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
                                                kind = "dynamic";
                                                value = {
                                                  name = "f";
                                                  path = [
                                                    {
                                                      kind = "identifier";
                                                      value = "user";
                                                    }
                                                  ];
                                                  type = "variable";
                                                };
                                              }
                                              {
                                                kind = "identifier";
                                                value = "profile";
                                              }
                                              {
                                                kind = "identifier";
                                                value = "uid";
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
                        value = "groups";
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
                                      value = "Additional group memberships";
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
                                      value = "Additional group memberships";
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
                                      value = "Additional group memberships. Uses normal additive group-list merging; an empty list adds no groups. Null leaves this preference unchanged.";
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
                                          value = "users";
                                        }
                                      ];
                                      type = "string";
                                    }
                                    {
                                      multiline = false;
                                      parts = [
                                        {
                                          type = "text";
                                          value = "profile";
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
                                                        value = "string";
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
                                    value = "users";
                                  }
                                  {
                                    kind = "identifier";
                                    value = "users";
                                  }
                                  {
                                    kind = "dynamic";
                                    value = {
                                      name = "f";
                                      path = [
                                        {
                                          kind = "identifier";
                                          value = "user";
                                        }
                                      ];
                                      type = "variable";
                                    };
                                  }
                                  {
                                    kind = "identifier";
                                    value = "extraGroups";
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
                                            kind = "dynamic";
                                            value = {
                                              name = "f";
                                              path = [
                                                {
                                                  kind = "identifier";
                                                  value = "user";
                                                }
                                              ];
                                              type = "variable";
                                            };
                                          }
                                          {
                                            kind = "identifier";
                                            value = "profile";
                                          }
                                          {
                                            kind = "identifier";
                                            value = "groups";
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
                                                kind = "dynamic";
                                                value = {
                                                  name = "f";
                                                  path = [
                                                    {
                                                      kind = "identifier";
                                                      value = "user";
                                                    }
                                                  ];
                                                  type = "variable";
                                                };
                                              }
                                              {
                                                kind = "identifier";
                                                value = "profile";
                                              }
                                              {
                                                kind = "identifier";
                                                value = "groups";
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
                        value = "sshKeys";
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
                                      value = "Authorized SSH public keys";
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
                                      value = "Authorized SSH public keys";
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
                                      value = "Authorized SSH public keys. Public keys only; uses normal additive list merging. Null leaves this preference unchanged.";
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
                                          value = "users";
                                        }
                                      ];
                                      type = "string";
                                    }
                                    {
                                      multiline = false;
                                      parts = [
                                        {
                                          type = "text";
                                          value = "profile";
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
                                                        value = "string";
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
                                    value = "users";
                                  }
                                  {
                                    kind = "identifier";
                                    value = "users";
                                  }
                                  {
                                    kind = "dynamic";
                                    value = {
                                      name = "f";
                                      path = [
                                        {
                                          kind = "identifier";
                                          value = "user";
                                        }
                                      ];
                                      type = "variable";
                                    };
                                  }
                                  {
                                    kind = "identifier";
                                    value = "openssh";
                                  }
                                  {
                                    kind = "identifier";
                                    value = "authorizedKeys";
                                  }
                                  {
                                    kind = "identifier";
                                    value = "keys";
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
                                            kind = "dynamic";
                                            value = {
                                              name = "f";
                                              path = [
                                                {
                                                  kind = "identifier";
                                                  value = "user";
                                                }
                                              ];
                                              type = "variable";
                                            };
                                          }
                                          {
                                            kind = "identifier";
                                            value = "profile";
                                          }
                                          {
                                            kind = "identifier";
                                            value = "sshKeys";
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
                                                kind = "dynamic";
                                                value = {
                                                  name = "f";
                                                  path = [
                                                    {
                                                      kind = "identifier";
                                                      value = "user";
                                                    }
                                                  ];
                                                  type = "variable";
                                                };
                                              }
                                              {
                                                kind = "identifier";
                                                value = "profile";
                                              }
                                              {
                                                kind = "identifier";
                                                value = "sshKeys";
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
                        value = "passwordHashFile";
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
                                      value = "Runtime file containing the password hash";
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
                                      value = "Runtime file containing the password hash";
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
                                      value = "Runtime file containing the password hash. An absolute runtime path, never a plaintext password or store-imported secret. Null leaves this preference unchanged.";
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
                                          value = "users";
                                        }
                                      ];
                                      type = "string";
                                    }
                                    {
                                      multiline = false;
                                      parts = [
                                        {
                                          type = "text";
                                          value = "profile";
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
                                    value = "users";
                                  }
                                  {
                                    kind = "identifier";
                                    value = "users";
                                  }
                                  {
                                    kind = "dynamic";
                                    value = {
                                      name = "f";
                                      path = [
                                        {
                                          kind = "identifier";
                                          value = "user";
                                        }
                                      ];
                                      type = "variable";
                                    };
                                  }
                                  {
                                    kind = "identifier";
                                    value = "hashedPasswordFile";
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
                                            kind = "dynamic";
                                            value = {
                                              name = "f";
                                              path = [
                                                {
                                                  kind = "identifier";
                                                  value = "user";
                                                }
                                              ];
                                              type = "variable";
                                            };
                                          }
                                          {
                                            kind = "identifier";
                                            value = "profile";
                                          }
                                          {
                                            kind = "identifier";
                                            value = "passwordHashFile";
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
                                                kind = "dynamic";
                                                value = {
                                                  name = "f";
                                                  path = [
                                                    {
                                                      kind = "identifier";
                                                      value = "user";
                                                    }
                                                  ];
                                                  type = "variable";
                                                };
                                              }
                                              {
                                                kind = "identifier";
                                                value = "profile";
                                              }
                                              {
                                                kind = "identifier";
                                                value = "passwordHashFile";
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
                        value = "linger";
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
                                      value = "Keep user services running after logout";
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
                                      value = "Keep user services running after logout";
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
                                      value = "Keep user services running after logout. Null leaves this preference unchanged.";
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
                                          value = "users";
                                        }
                                      ];
                                      type = "string";
                                    }
                                    {
                                      multiline = false;
                                      parts = [
                                        {
                                          type = "text";
                                          value = "profile";
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
                                    value = "users";
                                  }
                                  {
                                    kind = "identifier";
                                    value = "users";
                                  }
                                  {
                                    kind = "dynamic";
                                    value = {
                                      name = "f";
                                      path = [
                                        {
                                          kind = "identifier";
                                          value = "user";
                                        }
                                      ];
                                      type = "variable";
                                    };
                                  }
                                  {
                                    kind = "identifier";
                                    value = "linger";
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
                                            kind = "dynamic";
                                            value = {
                                              name = "f";
                                              path = [
                                                {
                                                  kind = "identifier";
                                                  value = "user";
                                                }
                                              ];
                                              type = "variable";
                                            };
                                          }
                                          {
                                            kind = "identifier";
                                            value = "profile";
                                          }
                                          {
                                            kind = "identifier";
                                            value = "linger";
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
                                                kind = "dynamic";
                                                value = {
                                                  name = "f";
                                                  path = [
                                                    {
                                                      kind = "identifier";
                                                      value = "user";
                                                    }
                                                  ];
                                                  type = "variable";
                                                };
                                              }
                                              {
                                                kind = "identifier";
                                                value = "profile";
                                              }
                                              {
                                                kind = "identifier";
                                                value = "linger";
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
                        value = "loginShell";
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
                                      value = "Login shell package";
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
                                      value = "Login shell package";
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
                                      value = "Login shell package. The selected shell must be supported and enabled by the system. This does not enable a system-wide shell service. Null leaves this preference unchanged.";
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
                                          value = "users";
                                        }
                                      ];
                                      type = "string";
                                    }
                                    {
                                      multiline = false;
                                      parts = [
                                        {
                                          type = "text";
                                          value = "shell";
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
                                    value = "users";
                                  }
                                  {
                                    kind = "identifier";
                                    value = "users";
                                  }
                                  {
                                    kind = "dynamic";
                                    value = {
                                      name = "f";
                                      path = [
                                        {
                                          kind = "identifier";
                                          value = "user";
                                        }
                                      ];
                                      type = "variable";
                                    };
                                  }
                                  {
                                    kind = "identifier";
                                    value = "shell";
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
                                            kind = "dynamic";
                                            value = {
                                              name = "f";
                                              path = [
                                                {
                                                  kind = "identifier";
                                                  value = "user";
                                                }
                                              ];
                                              type = "variable";
                                            };
                                          }
                                          {
                                            kind = "identifier";
                                            value = "profile";
                                          }
                                          {
                                            kind = "identifier";
                                            value = "loginShell";
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
                                                kind = "dynamic";
                                                value = {
                                                  name = "f";
                                                  path = [
                                                    {
                                                      kind = "identifier";
                                                      value = "user";
                                                    }
                                                  ];
                                                  type = "variable";
                                                };
                                              }
                                              {
                                                kind = "identifier";
                                                value = "profile";
                                              }
                                              {
                                                kind = "identifier";
                                                value = "loginShell";
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
              body = {
                recursive = false;
                statements = [
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
                                  left = {
                                    name = "path";
                                    path = [
                                      {
                                        kind = "dynamic";
                                        value = {
                                          name = "f";
                                          path = [
                                            {
                                              kind = "identifier";
                                              value = "user";
                                            }
                                          ];
                                          type = "variable";
                                        };
                                      }
                                      {
                                        kind = "identifier";
                                        value = "profile";
                                      }
                                      {
                                        kind = "identifier";
                                        value = "uid";
                                      }
                                    ];
                                    type = "variable";
                                  };
                                  operator = "==";
                                  right = {
                                    kind = "null";
                                    type = "literal";
                                    value = null;
                                  };
                                  type = "binary";
                                };
                                operator = "||";
                                right = {
                                  type = "group";
                                  value = {
                                    left = {
                                      left = {
                                        name = "path";
                                        path = [
                                          {
                                            kind = "dynamic";
                                            value = {
                                              name = "f";
                                              path = [
                                                {
                                                  kind = "identifier";
                                                  value = "user";
                                                }
                                              ];
                                              type = "variable";
                                            };
                                          }
                                          {
                                            kind = "identifier";
                                            value = "profile";
                                          }
                                          {
                                            kind = "identifier";
                                            value = "uid";
                                          }
                                        ];
                                        type = "variable";
                                      };
                                      operator = ">=";
                                      right = {
                                        kind = "integer";
                                        type = "literal";
                                        value = 0;
                                      };
                                      type = "binary";
                                    };
                                    operator = "&&";
                                    right = {
                                      left = {
                                        name = "path";
                                        path = [
                                          {
                                            kind = "dynamic";
                                            value = {
                                              name = "f";
                                              path = [
                                                {
                                                  kind = "identifier";
                                                  value = "user";
                                                }
                                              ];
                                              type = "variable";
                                            };
                                          }
                                          {
                                            kind = "identifier";
                                            value = "profile";
                                          }
                                          {
                                            kind = "identifier";
                                            value = "uid";
                                          }
                                        ];
                                        type = "variable";
                                      };
                                      operator = "<=";
                                      right = {
                                        kind = "integer";
                                        type = "literal";
                                        value = 4294967294;
                                      };
                                      type = "binary";
                                    };
                                    type = "binary";
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
                                    value = "UID must be between 0 and 4294967294.";
                                  }
                                ];
                                type = "string";
                              };
                            }
                          ];
                          type = "attr-set";
                        }
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
                                  left = {
                                    name = "path";
                                    path = [
                                      {
                                        kind = "dynamic";
                                        value = {
                                          name = "f";
                                          path = [
                                            {
                                              kind = "identifier";
                                              value = "user";
                                            }
                                          ];
                                          type = "variable";
                                        };
                                      }
                                      {
                                        kind = "identifier";
                                        value = "profile";
                                      }
                                      {
                                        kind = "identifier";
                                        value = "homeDirectory";
                                      }
                                    ];
                                    type = "variable";
                                  };
                                  operator = "==";
                                  right = {
                                    kind = "null";
                                    type = "literal";
                                    value = null;
                                  };
                                  type = "binary";
                                };
                                operator = "||";
                                right = {
                                  type = "group";
                                  value = {
                                    arguments = [
                                      {
                                        name = "path";
                                        path = [
                                          {
                                            kind = "dynamic";
                                            value = {
                                              name = "f";
                                              path = [
                                                {
                                                  kind = "identifier";
                                                  value = "user";
                                                }
                                              ];
                                              type = "variable";
                                            };
                                          }
                                          {
                                            kind = "identifier";
                                            value = "profile";
                                          }
                                          {
                                            kind = "identifier";
                                            value = "homeDirectory";
                                          }
                                        ];
                                        type = "variable";
                                      }
                                    ];
                                    callee = {
                                      arguments = [
                                        {
                                          multiline = false;
                                          parts = [
                                            {
                                              type = "text";
                                              value = "/";
                                            }
                                          ];
                                          type = "string";
                                        }
                                      ];
                                      callee = {
                                        name = "lib";
                                        path = [
                                          {
                                            kind = "identifier";
                                            value = "hasPrefix";
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
                                    value = "homeDirectory must be an absolute path.";
                                  }
                                ];
                                type = "string";
                              };
                            }
                          ];
                          type = "attr-set";
                        }
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
                                  left = {
                                    name = "path";
                                    path = [
                                      {
                                        kind = "dynamic";
                                        value = {
                                          name = "f";
                                          path = [
                                            {
                                              kind = "identifier";
                                              value = "user";
                                            }
                                          ];
                                          type = "variable";
                                        };
                                      }
                                      {
                                        kind = "identifier";
                                        value = "profile";
                                      }
                                      {
                                        kind = "identifier";
                                        value = "passwordHashFile";
                                      }
                                    ];
                                    type = "variable";
                                  };
                                  operator = "==";
                                  right = {
                                    kind = "null";
                                    type = "literal";
                                    value = null;
                                  };
                                  type = "binary";
                                };
                                operator = "||";
                                right = {
                                  type = "group";
                                  value = {
                                    arguments = [
                                      {
                                        name = "path";
                                        path = [
                                          {
                                            kind = "dynamic";
                                            value = {
                                              name = "f";
                                              path = [
                                                {
                                                  kind = "identifier";
                                                  value = "user";
                                                }
                                              ];
                                              type = "variable";
                                            };
                                          }
                                          {
                                            kind = "identifier";
                                            value = "profile";
                                          }
                                          {
                                            kind = "identifier";
                                            value = "passwordHashFile";
                                          }
                                        ];
                                        type = "variable";
                                      }
                                    ];
                                    callee = {
                                      arguments = [
                                        {
                                          multiline = false;
                                          parts = [
                                            {
                                              type = "text";
                                              value = "/";
                                            }
                                          ];
                                          type = "string";
                                        }
                                      ];
                                      callee = {
                                        name = "lib";
                                        path = [
                                          {
                                            kind = "identifier";
                                            value = "hasPrefix";
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
                                    value = "passwordHashFile must be an absolute path.";
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
                ];
                type = "attr-set";
              };
              guards = [ ];
              scope = "system";
              type = "action";
              unconditional = true;
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
                      callee = {
                        arguments = [
                          {
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
                                    value = "users";
                                  }
                                  {
                                    kind = "dynamic";
                                    value = {
                                      name = "f";
                                      path = [
                                        {
                                          kind = "identifier";
                                          value = "user";
                                        }
                                      ];
                                      type = "variable";
                                    };
                                  }
                                  {
                                    kind = "identifier";
                                    value = "services";
                                  }
                                  {
                                    kind = "identifier";
                                    value = "vr";
                                  }
                                  {
                                    kind = "identifier";
                                    value = "enable";
                                  }
                                ];
                                type = "variable";
                              };
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
                                    value = "gaming";
                                  }
                                  {
                                    kind = "identifier";
                                    value = "proton-ge-bin";
                                  }
                                ];
                                type = "variable";
                              }
                            ];
                            type = "list";
                          };
                        }
                      ];
                      callee = {
                        arguments = [
                          {
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
                                    value = "users";
                                  }
                                  {
                                    kind = "dynamic";
                                    value = {
                                      name = "f";
                                      path = [
                                        {
                                          kind = "identifier";
                                          value = "user";
                                        }
                                      ];
                                      type = "variable";
                                    };
                                  }
                                  {
                                    kind = "identifier";
                                    value = "services";
                                  }
                                  {
                                    kind = "identifier";
                                    value = "vr";
                                  }
                                  {
                                    kind = "identifier";
                                    value = "enable";
                                  }
                                ];
                                type = "variable";
                              };
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
                                    value = "libs";
                                  }
                                  {
                                    kind = "identifier";
                                    value = "libice";
                                  }
                                ];
                                type = "variable";
                              }
                              {
                                name = "pkgs";
                                path = [
                                  {
                                    kind = "identifier";
                                    value = "byCategories";
                                  }
                                  {
                                    kind = "identifier";
                                    value = "libs";
                                  }
                                  {
                                    kind = "identifier";
                                    value = "libsm";
                                  }
                                ];
                                type = "variable";
                              }
                            ];
                            type = "list";
                          };
                        }
                      ];
                      callee = {
                        arguments = [
                          {
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
                                    value = "users";
                                  }
                                  {
                                    kind = "dynamic";
                                    value = {
                                      name = "f";
                                      path = [
                                        {
                                          kind = "identifier";
                                          value = "user";
                                        }
                                      ];
                                      type = "variable";
                                    };
                                  }
                                  {
                                    kind = "identifier";
                                    value = "services";
                                  }
                                  {
                                    kind = "identifier";
                                    value = "vr";
                                  }
                                  {
                                    kind = "identifier";
                                    value = "enable";
                                  }
                                ];
                                type = "variable";
                              };
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
                      callee = {
                        arguments = [
                          {
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
                                    value = "users";
                                  }
                                  {
                                    kind = "dynamic";
                                    value = {
                                      name = "f";
                                      path = [
                                        {
                                          kind = "identifier";
                                          value = "user";
                                        }
                                      ];
                                      type = "variable";
                                    };
                                  }
                                  {
                                    kind = "identifier";
                                    value = "services";
                                  }
                                  {
                                    kind = "identifier";
                                    value = "vr";
                                  }
                                  {
                                    kind = "identifier";
                                    value = "enable";
                                  }
                                ];
                                type = "variable";
                              };
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
                            arguments = [
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
                                    value = "gaming";
                                  }
                                  {
                                    kind = "identifier";
                                    value = "alvr-zenos-compat";
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
                                  value = "mkDefault";
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
                                    value = "users";
                                  }
                                  {
                                    kind = "dynamic";
                                    value = {
                                      name = "f";
                                      path = [
                                        {
                                          kind = "identifier";
                                          value = "user";
                                        }
                                      ];
                                      type = "variable";
                                    };
                                  }
                                  {
                                    kind = "identifier";
                                    value = "services";
                                  }
                                  {
                                    kind = "identifier";
                                    value = "vr";
                                  }
                                  {
                                    kind = "identifier";
                                    value = "enable";
                                  }
                                ];
                                type = "variable";
                              };
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
                            arguments = [
                              {
                                type = "group";
                                value = {
                                  arguments = [
                                    {
                                      type = "group";
                                      value = {
                                        arguments = [
                                          {
                                            name = "cfg";
                                            path = [
                                              {
                                                kind = "identifier";
                                                value = "users";
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
                                              value = "attrValues";
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
                                          body = {
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
                                                  path = [
                                                    {
                                                      kind = "identifier";
                                                      value = "u";
                                                    }
                                                    {
                                                      kind = "identifier";
                                                      value = "services";
                                                    }
                                                    {
                                                      kind = "identifier";
                                                      value = "vr";
                                                    }
                                                    {
                                                      kind = "identifier";
                                                      value = "enable";
                                                    }
                                                  ];
                                                  type = "reference";
                                                };
                                              };
                                            };
                                            operator = "&&";
                                            right = {
                                              type = "group";
                                              value = {
                                                default = {
                                                  kind = "false";
                                                  type = "literal";
                                                  value = false;
                                                };
                                                type = "default";
                                                value = {
                                                  path = [
                                                    {
                                                      kind = "identifier";
                                                      value = "u";
                                                    }
                                                    {
                                                      kind = "identifier";
                                                      value = "services";
                                                    }
                                                    {
                                                      kind = "identifier";
                                                      value = "vr";
                                                    }
                                                    {
                                                      kind = "identifier";
                                                      value = "allowNetworkAccess";
                                                    }
                                                  ];
                                                  type = "reference";
                                                };
                                              };
                                            };
                                            type = "binary";
                                          };
                                          form = "identifier";
                                          parameters = [
                                            {
                                              default = null;
                                              name = "u";
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
                                          value = "any";
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
                      callee = {
                        arguments = [
                          {
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
                                    value = "users";
                                  }
                                  {
                                    kind = "dynamic";
                                    value = {
                                      name = "f";
                                      path = [
                                        {
                                          kind = "identifier";
                                          value = "user";
                                        }
                                      ];
                                      type = "variable";
                                    };
                                  }
                                  {
                                    kind = "identifier";
                                    value = "services";
                                  }
                                  {
                                    kind = "identifier";
                                    value = "vr";
                                  }
                                  {
                                    kind = "identifier";
                                    value = "enable";
                                  }
                                ];
                                type = "variable";
                              };
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
                      callee = {
                        arguments = [
                          {
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
                                    value = "users";
                                  }
                                  {
                                    kind = "dynamic";
                                    value = {
                                      name = "f";
                                      path = [
                                        {
                                          kind = "identifier";
                                          value = "user";
                                        }
                                      ];
                                      type = "variable";
                                    };
                                  }
                                  {
                                    kind = "identifier";
                                    value = "services";
                                  }
                                  {
                                    kind = "identifier";
                                    value = "vr";
                                  }
                                  {
                                    kind = "identifier";
                                    value = "enable";
                                  }
                                ];
                                type = "variable";
                              };
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
                  {
                    operator = "=";
                    target = [
                      {
                        kind = "identifier";
                        value = "hardware";
                      }
                      {
                        kind = "identifier";
                        value = "graphics";
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
                      callee = {
                        arguments = [
                          {
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
                                    value = "users";
                                  }
                                  {
                                    kind = "dynamic";
                                    value = {
                                      name = "f";
                                      path = [
                                        {
                                          kind = "identifier";
                                          value = "user";
                                        }
                                      ];
                                      type = "variable";
                                    };
                                  }
                                  {
                                    kind = "identifier";
                                    value = "services";
                                  }
                                  {
                                    kind = "identifier";
                                    value = "vr";
                                  }
                                  {
                                    kind = "identifier";
                                    value = "enable";
                                  }
                                ];
                                type = "variable";
                              };
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
                  {
                    operator = "=";
                    target = [
                      {
                        kind = "identifier";
                        value = "hardware";
                      }
                      {
                        kind = "identifier";
                        value = "graphics";
                      }
                      {
                        kind = "identifier";
                        value = "enable32Bit";
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
                      callee = {
                        arguments = [
                          {
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
                                    value = "users";
                                  }
                                  {
                                    kind = "dynamic";
                                    value = {
                                      name = "f";
                                      path = [
                                        {
                                          kind = "identifier";
                                          value = "user";
                                        }
                                      ];
                                      type = "variable";
                                    };
                                  }
                                  {
                                    kind = "identifier";
                                    value = "services";
                                  }
                                  {
                                    kind = "identifier";
                                    value = "vr";
                                  }
                                  {
                                    kind = "identifier";
                                    value = "enable";
                                  }
                                ];
                                type = "variable";
                              };
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
                  {
                    operator = "=";
                    target = [
                      {
                        kind = "identifier";
                        value = "security";
                      }
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
                          type = "group";
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
                      callee = {
                        arguments = [
                          {
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
                                    value = "users";
                                  }
                                  {
                                    kind = "dynamic";
                                    value = {
                                      name = "f";
                                      path = [
                                        {
                                          kind = "identifier";
                                          value = "user";
                                        }
                                      ];
                                      type = "variable";
                                    };
                                  }
                                  {
                                    kind = "identifier";
                                    value = "services";
                                  }
                                  {
                                    kind = "identifier";
                                    value = "vr";
                                  }
                                  {
                                    kind = "identifier";
                                    value = "enable";
                                  }
                                ];
                                type = "variable";
                              };
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
                      callee = {
                        arguments = [
                          {
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
                                    value = "users";
                                  }
                                  {
                                    kind = "dynamic";
                                    value = {
                                      name = "f";
                                      path = [
                                        {
                                          kind = "identifier";
                                          value = "user";
                                        }
                                      ];
                                      type = "variable";
                                    };
                                  }
                                  {
                                    kind = "identifier";
                                    value = "services";
                                  }
                                  {
                                    kind = "identifier";
                                    value = "vr";
                                  }
                                  {
                                    kind = "identifier";
                                    value = "enable";
                                  }
                                ];
                                type = "variable";
                              };
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
                  {
                    operator = "=";
                    target = [
                      {
                        kind = "identifier";
                        value = "boot";
                      }
                      {
                        kind = "identifier";
                        value = "kernel";
                      }
                      {
                        kind = "identifier";
                        value = "sysctl";
                      }
                      {
                        kind = "string";
                        value = "vm.max_map_count";
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
                                kind = "integer";
                                type = "literal";
                                value = 2147483642;
                              }
                            ];
                            callee = {
                              arguments = [
                                {
                                  kind = "integer";
                                  type = "literal";
                                  value = 900;
                                }
                              ];
                              callee = {
                                name = "lib";
                                path = [
                                  {
                                    kind = "identifier";
                                    value = "mkOverride";
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
                                    value = "users";
                                  }
                                  {
                                    kind = "dynamic";
                                    value = {
                                      name = "f";
                                      path = [
                                        {
                                          kind = "identifier";
                                          value = "user";
                                        }
                                      ];
                                      type = "variable";
                                    };
                                  }
                                  {
                                    kind = "identifier";
                                    value = "services";
                                  }
                                  {
                                    kind = "identifier";
                                    value = "vr";
                                  }
                                  {
                                    kind = "identifier";
                                    value = "enable";
                                  }
                                ];
                                type = "variable";
                              };
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
                  {
                    operator = "=";
                    target = [
                      {
                        kind = "identifier";
                        value = "security";
                      }
                      {
                        kind = "identifier";
                        value = "pam";
                      }
                      {
                        kind = "identifier";
                        value = "loginLimits";
                      }
                    ];
                    type = "assignment";
                    value = {
                      arguments = [
                        {
                          items = [
                            {
                              recursive = false;
                              statements = [
                                {
                                  operator = "=";
                                  target = [
                                    {
                                      kind = "identifier";
                                      value = "domain";
                                    }
                                  ];
                                  type = "assignment";
                                  value = {
                                    name = "f";
                                    path = [
                                      {
                                        kind = "identifier";
                                        value = "user";
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
                                    multiline = false;
                                    parts = [
                                      {
                                        type = "text";
                                        value = "hard";
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
                                      value = "item";
                                    }
                                  ];
                                  type = "assignment";
                                  value = {
                                    multiline = false;
                                    parts = [
                                      {
                                        type = "text";
                                        value = "nofile";
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
                                      value = "value";
                                    }
                                  ];
                                  type = "assignment";
                                  value = {
                                    multiline = false;
                                    parts = [
                                      {
                                        type = "text";
                                        value = "524288";
                                      }
                                    ];
                                    type = "string";
                                  };
                                }
                              ];
                              type = "attr-set";
                            }
                            {
                              recursive = false;
                              statements = [
                                {
                                  operator = "=";
                                  target = [
                                    {
                                      kind = "identifier";
                                      value = "domain";
                                    }
                                  ];
                                  type = "assignment";
                                  value = {
                                    name = "f";
                                    path = [
                                      {
                                        kind = "identifier";
                                        value = "user";
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
                                    multiline = false;
                                    parts = [
                                      {
                                        type = "text";
                                        value = "-";
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
                                      value = "item";
                                    }
                                  ];
                                  type = "assignment";
                                  value = {
                                    multiline = false;
                                    parts = [
                                      {
                                        type = "text";
                                        value = "rtprio";
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
                                      value = "value";
                                    }
                                  ];
                                  type = "assignment";
                                  value = {
                                    multiline = false;
                                    parts = [
                                      {
                                        type = "text";
                                        value = "95";
                                      }
                                    ];
                                    type = "string";
                                  };
                                }
                              ];
                              type = "attr-set";
                            }
                            {
                              recursive = false;
                              statements = [
                                {
                                  operator = "=";
                                  target = [
                                    {
                                      kind = "identifier";
                                      value = "domain";
                                    }
                                  ];
                                  type = "assignment";
                                  value = {
                                    name = "f";
                                    path = [
                                      {
                                        kind = "identifier";
                                        value = "user";
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
                                    multiline = false;
                                    parts = [
                                      {
                                        type = "text";
                                        value = "-";
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
                                      value = "item";
                                    }
                                  ];
                                  type = "assignment";
                                  value = {
                                    multiline = false;
                                    parts = [
                                      {
                                        type = "text";
                                        value = "nice";
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
                                      value = "value";
                                    }
                                  ];
                                  type = "assignment";
                                  value = {
                                    multiline = false;
                                    parts = [
                                      {
                                        type = "text";
                                        value = "-19";
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
                        }
                      ];
                      callee = {
                        arguments = [
                          {
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
                                    value = "users";
                                  }
                                  {
                                    kind = "dynamic";
                                    value = {
                                      name = "f";
                                      path = [
                                        {
                                          kind = "identifier";
                                          value = "user";
                                        }
                                      ];
                                      type = "variable";
                                    };
                                  }
                                  {
                                    kind = "identifier";
                                    value = "services";
                                  }
                                  {
                                    kind = "identifier";
                                    value = "vr";
                                  }
                                  {
                                    kind = "identifier";
                                    value = "enable";
                                  }
                                ];
                                type = "variable";
                              };
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
            {
              body = {
                recursive = false;
                statements = [
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
                                  value = "development";
                                }
                                {
                                  kind = "identifier";
                                  value = "android-tools";
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
                                    value = "users";
                                  }
                                  {
                                    kind = "dynamic";
                                    value = {
                                      name = "f";
                                      path = [
                                        {
                                          kind = "identifier";
                                          value = "user";
                                        }
                                      ];
                                      type = "variable";
                                    };
                                  }
                                  {
                                    kind = "identifier";
                                    value = "services";
                                  }
                                  {
                                    kind = "identifier";
                                    value = "zbridge";
                                  }
                                  {
                                    kind = "identifier";
                                    value = "enable";
                                  }
                                ];
                                type = "variable";
                              };
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
                        value = "udev";
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
                                  value = "accessibility";
                                }
                                {
                                  kind = "identifier";
                                  value = "hapticspp";
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
                                    value = "users";
                                  }
                                  {
                                    kind = "dynamic";
                                    value = {
                                      name = "f";
                                      path = [
                                        {
                                          kind = "identifier";
                                          value = "user";
                                        }
                                      ];
                                      type = "variable";
                                    };
                                  }
                                  {
                                    kind = "identifier";
                                    value = "services";
                                  }
                                  {
                                    kind = "identifier";
                                    value = "haptics";
                                  }
                                  {
                                    kind = "identifier";
                                    value = "enable";
                                  }
                                ];
                                type = "variable";
                              };
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
    { assertions = lib.mkMerge (lib.mapAttrsToList (_zenFreeformKey0: _zenFreeformValue0: [
        {
          assertion = ((cfg.${_zenFreeformKey0}.profile.uid == null) || (((cfg.${_zenFreeformKey0}.profile.uid >= 0) && (cfg.${_zenFreeformKey0}.profile.uid <= 4294967294))));
          message = "UID must be between 0 and 4294967294.";
        }
        {
          assertion = ((cfg.${_zenFreeformKey0}.profile.homeDirectory == null) || (((lib.hasPrefix "/") cfg.${_zenFreeformKey0}.profile.homeDirectory)));
          message = "homeDirectory must be an absolute path.";
        }
        {
          assertion = ((cfg.${_zenFreeformKey0}.profile.passwordHashFile == null) || (((lib.hasPrefix "/") cfg.${_zenFreeformKey0}.profile.passwordHashFile)));
          message = "passwordHashFile must be an absolute path.";
        }
      ]) cfg); }
    { programs.steam.enable = lib.mkMerge (lib.mapAttrsToList (_zenFreeformKey0: _zenFreeformValue0: ((lib.mkIf ((config.zenos.users.${_zenFreeformKey0}.services.vr.enable or false))) ((lib.mkDefault true)))) cfg); }
    { programs.steam.extraCompatPackages = lib.mkMerge (lib.mapAttrsToList (_zenFreeformKey0: _zenFreeformValue0: ((lib.mkIf ((config.zenos.users.${_zenFreeformKey0}.services.vr.enable or false))) ([
        pkgs.zenos.byCategories.apps.gaming.proton-ge-bin
      ]))) cfg); }
    { programs.steam.extraPackages = lib.mkMerge (lib.mapAttrsToList (_zenFreeformKey0: _zenFreeformValue0: ((lib.mkIf ((config.zenos.users.${_zenFreeformKey0}.services.vr.enable or false))) ([
        pkgs.zenos.byCategories.libs.libice
        pkgs.zenos.byCategories.libs.libsm
      ]))) cfg); }
    { programs.alvr.enable = lib.mkMerge (lib.mapAttrsToList (_zenFreeformKey0: _zenFreeformValue0: ((lib.mkIf ((config.zenos.users.${_zenFreeformKey0}.services.vr.enable or false))) ((lib.mkDefault true)))) cfg); }
    { programs.alvr.package = lib.mkMerge (lib.mapAttrsToList (_zenFreeformKey0: _zenFreeformValue0: ((lib.mkIf ((config.zenos.users.${_zenFreeformKey0}.services.vr.enable or false))) ((lib.mkDefault pkgs.zenos.byCategories.apps.gaming.alvr-zenos-compat)))) cfg); }
    { programs.alvr.openFirewall = lib.mkMerge (lib.mapAttrsToList (_zenFreeformKey0: _zenFreeformValue0: ((lib.mkIf ((config.zenos.users.${_zenFreeformKey0}.services.vr.enable or false))) ((lib.mkDefault (((lib.any ((u: (((u.services.vr.enable or false)) && ((u.services.vr.allowNetworkAccess or false)))))) ((lib.attrValues config.zenos.users)))))))) cfg); }
    { hardware.steam-hardware.enable = lib.mkMerge (lib.mapAttrsToList (_zenFreeformKey0: _zenFreeformValue0: ((lib.mkIf ((config.zenos.users.${_zenFreeformKey0}.services.vr.enable or false))) ((lib.mkDefault true)))) cfg); }
    { hardware.graphics.enable = lib.mkMerge (lib.mapAttrsToList (_zenFreeformKey0: _zenFreeformValue0: ((lib.mkIf ((config.zenos.users.${_zenFreeformKey0}.services.vr.enable or false))) ((lib.mkDefault true)))) cfg); }
    { hardware.graphics.enable32Bit = lib.mkMerge (lib.mapAttrsToList (_zenFreeformKey0: _zenFreeformValue0: ((lib.mkIf ((config.zenos.users.${_zenFreeformKey0}.services.vr.enable or false))) ((lib.mkDefault true)))) cfg); }
    { security.rtkit.enable = lib.mkMerge (lib.mapAttrsToList (_zenFreeformKey0: _zenFreeformValue0: ((lib.mkIf ((config.zenos.users.${_zenFreeformKey0}.services.vr.enable or false))) ((lib.mkDefault true)))) cfg); }
    { programs.gamemode.enable = lib.mkMerge (lib.mapAttrsToList (_zenFreeformKey0: _zenFreeformValue0: ((lib.mkIf ((config.zenos.users.${_zenFreeformKey0}.services.vr.enable or false))) ((lib.mkDefault true)))) cfg); }
    { boot.kernel.sysctl."vm.max_map_count" = lib.mkMerge (lib.mapAttrsToList (_zenFreeformKey0: _zenFreeformValue0: ((lib.mkIf ((config.zenos.users.${_zenFreeformKey0}.services.vr.enable or false))) (((lib.mkOverride 900) 2147483642)))) cfg); }
    { security.pam.loginLimits = lib.mkMerge (lib.mapAttrsToList (_zenFreeformKey0: _zenFreeformValue0: ((lib.mkIf ((config.zenos.users.${_zenFreeformKey0}.services.vr.enable or false))) [
        {
          domain = _zenFreeformKey0;
          type = "hard";
          item = "nofile";
          value = "524288";
        }
        {
          domain = _zenFreeformKey0;
          type = "-";
          item = "rtprio";
          value = "95";
        }
        {
          domain = _zenFreeformKey0;
          type = "-";
          item = "nice";
          value = "-19";
        }
      ])) cfg); }
    { environment.systemPackages = lib.mkMerge (lib.mapAttrsToList (_zenFreeformKey0: _zenFreeformValue0: ((lib.mkIf ((config.zenos.users.${_zenFreeformKey0}.services.zbridge.enable or false))) [
        pkgs.zenos.byCategories.apps.development.android-tools
      ])) cfg); }
    { services.udev.packages = lib.mkMerge (lib.mapAttrsToList (_zenFreeformKey0: _zenFreeformValue0: ((lib.mkIf ((config.zenos.users.${_zenFreeformKey0}.services.haptics.enable or false))) [
        pkgs.zenos.byCategories.apps.accessibility.hapticspp
      ])) cfg); }
    { users.users = lib.mkMerge (lib.mapAttrsToList (_zenFreeformKey0: _zenFreeformValue0: { ${_zenFreeformKey0}.isNormalUser = ((lib.mkIf ((cfg.${_zenFreeformKey0}.profile.normalUser != null))) (cfg.${_zenFreeformKey0}.profile.normalUser)); }) cfg); }
    { users.users = lib.mkMerge (lib.mapAttrsToList (_zenFreeformKey0: _zenFreeformValue0: { ${_zenFreeformKey0}.description = ((lib.mkIf ((cfg.${_zenFreeformKey0}.profile.displayName != null))) (cfg.${_zenFreeformKey0}.profile.displayName)); }) cfg); }
    { users.users = lib.mkMerge (lib.mapAttrsToList (_zenFreeformKey0: _zenFreeformValue0: { ${_zenFreeformKey0}.home = ((lib.mkIf ((cfg.${_zenFreeformKey0}.profile.homeDirectory != null))) (cfg.${_zenFreeformKey0}.profile.homeDirectory)); }) cfg); }
    { users.users = lib.mkMerge (lib.mapAttrsToList (_zenFreeformKey0: _zenFreeformValue0: { ${_zenFreeformKey0}.uid = ((lib.mkIf ((cfg.${_zenFreeformKey0}.profile.uid != null))) (cfg.${_zenFreeformKey0}.profile.uid)); }) cfg); }
    { users.users = lib.mkMerge (lib.mapAttrsToList (_zenFreeformKey0: _zenFreeformValue0: { ${_zenFreeformKey0}.extraGroups = ((lib.mkIf ((cfg.${_zenFreeformKey0}.profile.groups != null))) (cfg.${_zenFreeformKey0}.profile.groups)); }) cfg); }
    { users.users = lib.mkMerge (lib.mapAttrsToList (_zenFreeformKey0: _zenFreeformValue0: { ${_zenFreeformKey0}.openssh.authorizedKeys.keys = ((lib.mkIf ((cfg.${_zenFreeformKey0}.profile.sshKeys != null))) (cfg.${_zenFreeformKey0}.profile.sshKeys)); }) cfg); }
    { users.users = lib.mkMerge (lib.mapAttrsToList (_zenFreeformKey0: _zenFreeformValue0: { ${_zenFreeformKey0}.hashedPasswordFile = ((lib.mkIf ((cfg.${_zenFreeformKey0}.profile.passwordHashFile != null))) (cfg.${_zenFreeformKey0}.profile.passwordHashFile)); }) cfg); }
    { users.users = lib.mkMerge (lib.mapAttrsToList (_zenFreeformKey0: _zenFreeformValue0: { ${_zenFreeformKey0}.linger = ((lib.mkIf ((cfg.${_zenFreeformKey0}.profile.linger != null))) (cfg.${_zenFreeformKey0}.profile.linger)); }) cfg); }
    { users.users = lib.mkMerge (lib.mapAttrsToList (_zenFreeformKey0: _zenFreeformValue0: { ${_zenFreeformKey0}.shell = ((lib.mkIf ((cfg.${_zenFreeformKey0}.profile.loginShell != null))) (cfg.${_zenFreeformKey0}.profile.loginShell)); }) cfg); }
  ];
}
