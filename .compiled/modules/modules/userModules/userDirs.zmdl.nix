{ config, lib, pkgs, maintainers ? lib.maintainers, licenses ? lib.licenses, ... }:
let
  cfg = config.zenos.userModules.userDirs;
  name = "userDirs";
in
{
  options.zenos.userModules.userDirs = lib.mkOption { type = (lib.types.submodule ({ ... }: { options = { createDirectories = lib.mkOption { type = (lib.types.either lib.types.bool (lib.types.enum [ null ])); default = null; description = "Create configured personal folders. Requires userDirs.enable = true. Null leaves this preference unchanged."; }; desktop = lib.mkOption { type = (lib.types.either lib.types.str (lib.types.enum [ null ])); default = null; description = "Location of the desktop folder. Absolute path. Requires userDirs.enable = true. Does not move existing files. Null leaves this preference unchanged."; }; documents = lib.mkOption { type = (lib.types.either lib.types.str (lib.types.enum [ null ])); default = null; description = "Location of the documents folder. Absolute path. Requires userDirs.enable = true. Does not move existing files. Null leaves this preference unchanged."; }; downloads = lib.mkOption { type = (lib.types.either lib.types.str (lib.types.enum [ null ])); default = null; description = "Location of the downloads folder. Absolute path. Requires userDirs.enable = true. Does not move existing files. Null leaves this preference unchanged."; }; enable = lib.mkOption { type = (lib.types.either lib.types.bool (lib.types.enum [ null ])); default = null; description = "Manage standard personal folders. Null leaves this preference unchanged."; }; music = lib.mkOption { type = (lib.types.either lib.types.str (lib.types.enum [ null ])); default = null; description = "Location of the music folder. Absolute path. Requires userDirs.enable = true. Does not move existing files. Null leaves this preference unchanged."; }; pictures = lib.mkOption { type = (lib.types.either lib.types.str (lib.types.enum [ null ])); default = null; description = "Location of the pictures folder. Absolute path. Requires userDirs.enable = true. Does not move existing files. Null leaves this preference unchanged."; }; projects = lib.mkOption { type = (lib.types.either lib.types.str (lib.types.enum [ null ])); default = null; description = "Location of the projects folder. Absolute path. Requires userDirs.enable = true. Does not move existing files. Null leaves this preference unchanged."; }; publicShare = lib.mkOption { type = (lib.types.either lib.types.str (lib.types.enum [ null ])); default = null; description = "Location of the publicShare folder. Absolute path. Requires userDirs.enable = true. Does not move existing files. Null leaves this preference unchanged."; }; templates = lib.mkOption { type = (lib.types.either lib.types.str (lib.types.enum [ null ])); default = null; description = "Location of the templates folder. Absolute path. Requires userDirs.enable = true. Does not move existing files. Null leaves this preference unchanged."; }; videos = lib.mkOption { type = (lib.types.either lib.types.str (lib.types.enum [ null ])); default = null; description = "Location of the videos folder. Absolute path. Requires userDirs.enable = true. Does not move existing files. Null leaves this preference unchanged."; }; }; })); default = { }; };
  config = lib.mkMerge [
    { _module.args.zenlang.descriptors.userModules.userDirs = {
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
            value = "Settings for one user. Unset values preserve existing policy and preferences.";
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
            value = "Standard personal folders";
          }
        ];
        type = "string";
      };
      summary = {
        multiline = false;
        parts = [
          {
            type = "text";
            value = "Standard personal folders";
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
                value = "userDirs";
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
    moduleIdentity = "zenos.userModules.userDirs";
    modulePath = [
      "userModules"
      "userDirs"
    ];
    nodeMetadata = [
      {
        metadata = {
          description = {
            multiline = true;
            parts = [
              {
                type = "text";
                value = "Settings for one user. Unset values preserve existing policy and preferences.";
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
                value = "Standard personal folders";
              }
            ];
            type = "string";
          };
          summary = {
            multiline = false;
            parts = [
              {
                type = "text";
                value = "Standard personal folders";
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
                    value = "userDirs";
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
                value = "Manage standard personal folders. Null leaves this preference unchanged.";
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
                value = "Manage standard personal folders";
              }
            ];
            type = "string";
          };
          summary = {
            multiline = false;
            parts = [
              {
                type = "text";
                value = "Manage standard personal folders";
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
                    value = "userDirs";
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
                value = "Create configured personal folders. Requires userDirs.enable = true. Null leaves this preference unchanged.";
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
                value = "Create configured personal folders";
              }
            ];
            type = "string";
          };
          summary = {
            multiline = false;
            parts = [
              {
                type = "text";
                value = "Create configured personal folders";
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
                    value = "userDirs";
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
          "createDirectories"
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
                value = "Location of the desktop folder. Absolute path. Requires userDirs.enable = true. Does not move existing files. Null leaves this preference unchanged.";
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
                value = "Location of the desktop folder";
              }
            ];
            type = "string";
          };
          summary = {
            multiline = false;
            parts = [
              {
                type = "text";
                value = "Location of the desktop folder";
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
                    value = "userDirs";
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
          "desktop"
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
                value = "Location of the documents folder. Absolute path. Requires userDirs.enable = true. Does not move existing files. Null leaves this preference unchanged.";
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
                value = "Location of the documents folder";
              }
            ];
            type = "string";
          };
          summary = {
            multiline = false;
            parts = [
              {
                type = "text";
                value = "Location of the documents folder";
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
                    value = "userDirs";
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
          "documents"
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
                value = "Location of the downloads folder. Absolute path. Requires userDirs.enable = true. Does not move existing files. Null leaves this preference unchanged.";
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
                value = "Location of the downloads folder";
              }
            ];
            type = "string";
          };
          summary = {
            multiline = false;
            parts = [
              {
                type = "text";
                value = "Location of the downloads folder";
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
                    value = "userDirs";
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
          "downloads"
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
                value = "Location of the music folder. Absolute path. Requires userDirs.enable = true. Does not move existing files. Null leaves this preference unchanged.";
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
                value = "Location of the music folder";
              }
            ];
            type = "string";
          };
          summary = {
            multiline = false;
            parts = [
              {
                type = "text";
                value = "Location of the music folder";
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
                    value = "userDirs";
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
          "music"
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
                value = "Location of the pictures folder. Absolute path. Requires userDirs.enable = true. Does not move existing files. Null leaves this preference unchanged.";
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
                value = "Location of the pictures folder";
              }
            ];
            type = "string";
          };
          summary = {
            multiline = false;
            parts = [
              {
                type = "text";
                value = "Location of the pictures folder";
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
                    value = "userDirs";
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
          "pictures"
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
                value = "Location of the videos folder. Absolute path. Requires userDirs.enable = true. Does not move existing files. Null leaves this preference unchanged.";
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
                value = "Location of the videos folder";
              }
            ];
            type = "string";
          };
          summary = {
            multiline = false;
            parts = [
              {
                type = "text";
                value = "Location of the videos folder";
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
                    value = "userDirs";
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
          "videos"
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
                value = "Location of the templates folder. Absolute path. Requires userDirs.enable = true. Does not move existing files. Null leaves this preference unchanged.";
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
                value = "Location of the templates folder";
              }
            ];
            type = "string";
          };
          summary = {
            multiline = false;
            parts = [
              {
                type = "text";
                value = "Location of the templates folder";
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
                    value = "userDirs";
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
          "templates"
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
                value = "Location of the publicShare folder. Absolute path. Requires userDirs.enable = true. Does not move existing files. Null leaves this preference unchanged.";
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
                value = "Location of the publicShare folder";
              }
            ];
            type = "string";
          };
          summary = {
            multiline = false;
            parts = [
              {
                type = "text";
                value = "Location of the publicShare folder";
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
                    value = "userDirs";
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
          "publicShare"
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
                value = "Location of the projects folder. Absolute path. Requires userDirs.enable = true. Does not move existing files. Null leaves this preference unchanged.";
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
                value = "Location of the projects folder";
              }
            ];
            type = "string";
          };
          summary = {
            multiline = false;
            parts = [
              {
                type = "text";
                value = "Location of the projects folder";
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
                    value = "userDirs";
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
          "projects"
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
                    value = "Standard personal folders";
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
                    value = "Standard personal folders";
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
                    value = "Settings for one user. Unset values preserve existing policy and preferences.";
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
                        value = "userDirs";
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
                          value = "Manage standard personal folders";
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
                          value = "Manage standard personal folders";
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
                          value = "Manage standard personal folders. Null leaves this preference unchanged.";
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
                              value = "userDirs";
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
                        value = "xdg";
                      }
                      {
                        kind = "identifier";
                        value = "userDirs";
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
              scope = "user";
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
                                        kind = "identifier";
                                        value = "desktop";
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
                                            kind = "identifier";
                                            value = "desktop";
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
                                    value = "desktop must be an absolute path.";
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
                                        kind = "identifier";
                                        value = "documents";
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
                                            kind = "identifier";
                                            value = "documents";
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
                                    value = "documents must be an absolute path.";
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
                                        kind = "identifier";
                                        value = "downloads";
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
                                            kind = "identifier";
                                            value = "downloads";
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
                                    value = "downloads must be an absolute path.";
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
                                        kind = "identifier";
                                        value = "music";
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
                                            kind = "identifier";
                                            value = "music";
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
                                    value = "music must be an absolute path.";
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
                                        kind = "identifier";
                                        value = "pictures";
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
                                            kind = "identifier";
                                            value = "pictures";
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
                                    value = "pictures must be an absolute path.";
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
                                        kind = "identifier";
                                        value = "videos";
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
                                            kind = "identifier";
                                            value = "videos";
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
                                    value = "videos must be an absolute path.";
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
                                        kind = "identifier";
                                        value = "templates";
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
                                            kind = "identifier";
                                            value = "templates";
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
                                    value = "templates must be an absolute path.";
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
                                        kind = "identifier";
                                        value = "publicShare";
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
                                            kind = "identifier";
                                            value = "publicShare";
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
                                    value = "publicShare must be an absolute path.";
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
                                        kind = "identifier";
                                        value = "projects";
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
                                            kind = "identifier";
                                            value = "projects";
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
                                    value = "projects must be an absolute path.";
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
              scope = "user";
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
            value = "createDirectories";
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
                          value = "Create configured personal folders";
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
                          value = "Create configured personal folders";
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
                          value = "Create configured personal folders. Requires userDirs.enable = true. Null leaves this preference unchanged.";
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
                              value = "userDirs";
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
                        value = "xdg";
                      }
                      {
                        kind = "identifier";
                        value = "userDirs";
                      }
                      {
                        kind = "identifier";
                        value = "createDirectories";
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
                                value = "createDirectories";
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
                                    value = "createDirectories";
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
              scope = "user";
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
            value = "desktop";
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
                          value = "Location of the desktop folder";
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
                          value = "Location of the desktop folder";
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
                          value = "Location of the desktop folder. Absolute path. Requires userDirs.enable = true. Does not move existing files. Null leaves this preference unchanged.";
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
                              value = "userDirs";
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
                        value = "xdg";
                      }
                      {
                        kind = "identifier";
                        value = "userDirs";
                      }
                      {
                        kind = "identifier";
                        value = "desktop";
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
                                value = "desktop";
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
                                    value = "desktop";
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
              scope = "user";
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
            value = "documents";
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
                          value = "Location of the documents folder";
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
                          value = "Location of the documents folder";
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
                          value = "Location of the documents folder. Absolute path. Requires userDirs.enable = true. Does not move existing files. Null leaves this preference unchanged.";
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
                              value = "userDirs";
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
                        value = "xdg";
                      }
                      {
                        kind = "identifier";
                        value = "userDirs";
                      }
                      {
                        kind = "identifier";
                        value = "documents";
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
                                value = "documents";
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
                                    value = "documents";
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
              scope = "user";
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
            value = "downloads";
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
                          value = "Location of the downloads folder";
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
                          value = "Location of the downloads folder";
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
                          value = "Location of the downloads folder. Absolute path. Requires userDirs.enable = true. Does not move existing files. Null leaves this preference unchanged.";
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
                              value = "userDirs";
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
                        value = "xdg";
                      }
                      {
                        kind = "identifier";
                        value = "userDirs";
                      }
                      {
                        kind = "identifier";
                        value = "download";
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
                                value = "downloads";
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
                                    value = "downloads";
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
              scope = "user";
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
            value = "music";
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
                          value = "Location of the music folder";
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
                          value = "Location of the music folder";
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
                          value = "Location of the music folder. Absolute path. Requires userDirs.enable = true. Does not move existing files. Null leaves this preference unchanged.";
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
                              value = "userDirs";
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
                        value = "xdg";
                      }
                      {
                        kind = "identifier";
                        value = "userDirs";
                      }
                      {
                        kind = "identifier";
                        value = "music";
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
                                value = "music";
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
                                    value = "music";
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
              scope = "user";
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
            value = "pictures";
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
                          value = "Location of the pictures folder";
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
                          value = "Location of the pictures folder";
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
                          value = "Location of the pictures folder. Absolute path. Requires userDirs.enable = true. Does not move existing files. Null leaves this preference unchanged.";
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
                              value = "userDirs";
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
                        value = "xdg";
                      }
                      {
                        kind = "identifier";
                        value = "userDirs";
                      }
                      {
                        kind = "identifier";
                        value = "pictures";
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
                                value = "pictures";
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
                                    value = "pictures";
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
              scope = "user";
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
            value = "videos";
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
                          value = "Location of the videos folder";
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
                          value = "Location of the videos folder";
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
                          value = "Location of the videos folder. Absolute path. Requires userDirs.enable = true. Does not move existing files. Null leaves this preference unchanged.";
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
                              value = "userDirs";
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
                        value = "xdg";
                      }
                      {
                        kind = "identifier";
                        value = "userDirs";
                      }
                      {
                        kind = "identifier";
                        value = "videos";
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
                                value = "videos";
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
                                    value = "videos";
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
              scope = "user";
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
            value = "templates";
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
                          value = "Location of the templates folder";
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
                          value = "Location of the templates folder";
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
                          value = "Location of the templates folder. Absolute path. Requires userDirs.enable = true. Does not move existing files. Null leaves this preference unchanged.";
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
                              value = "userDirs";
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
                        value = "xdg";
                      }
                      {
                        kind = "identifier";
                        value = "userDirs";
                      }
                      {
                        kind = "identifier";
                        value = "templates";
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
                                value = "templates";
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
                                    value = "templates";
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
              scope = "user";
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
            value = "publicShare";
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
                          value = "Location of the publicShare folder";
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
                          value = "Location of the publicShare folder";
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
                          value = "Location of the publicShare folder. Absolute path. Requires userDirs.enable = true. Does not move existing files. Null leaves this preference unchanged.";
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
                              value = "userDirs";
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
                        value = "xdg";
                      }
                      {
                        kind = "identifier";
                        value = "userDirs";
                      }
                      {
                        kind = "identifier";
                        value = "publicShare";
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
                                value = "publicShare";
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
                                    value = "publicShare";
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
              scope = "user";
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
            value = "projects";
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
                          value = "Location of the projects folder";
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
                          value = "Location of the projects folder";
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
                          value = "Location of the projects folder. Absolute path. Requires userDirs.enable = true. Does not move existing files. Null leaves this preference unchanged.";
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
                              value = "userDirs";
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
                        value = "xdg";
                      }
                      {
                        kind = "identifier";
                        value = "userDirs";
                      }
                      {
                        kind = "identifier";
                        value = "projects";
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
                                value = "projects";
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
                                    value = "projects";
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
              scope = "user";
              type = "action";
              unconditional = true;
            }
          ];
          type = "attr-set";
        };
      }
    ];
  }; }
    { home-manager.sharedModules = [ {
      xdg.userDirs.enable = ((lib.mkIf ((cfg.enable != null))) (cfg.enable));
    } ]; }
    { home-manager.sharedModules = [ {
      assertions = [
        {
          assertion = ((cfg.desktop == null) || (((lib.hasPrefix "/") cfg.desktop)));
          message = "desktop must be an absolute path.";
        }
        {
          assertion = ((cfg.documents == null) || (((lib.hasPrefix "/") cfg.documents)));
          message = "documents must be an absolute path.";
        }
        {
          assertion = ((cfg.downloads == null) || (((lib.hasPrefix "/") cfg.downloads)));
          message = "downloads must be an absolute path.";
        }
        {
          assertion = ((cfg.music == null) || (((lib.hasPrefix "/") cfg.music)));
          message = "music must be an absolute path.";
        }
        {
          assertion = ((cfg.pictures == null) || (((lib.hasPrefix "/") cfg.pictures)));
          message = "pictures must be an absolute path.";
        }
        {
          assertion = ((cfg.videos == null) || (((lib.hasPrefix "/") cfg.videos)));
          message = "videos must be an absolute path.";
        }
        {
          assertion = ((cfg.templates == null) || (((lib.hasPrefix "/") cfg.templates)));
          message = "templates must be an absolute path.";
        }
        {
          assertion = ((cfg.publicShare == null) || (((lib.hasPrefix "/") cfg.publicShare)));
          message = "publicShare must be an absolute path.";
        }
        {
          assertion = ((cfg.projects == null) || (((lib.hasPrefix "/") cfg.projects)));
          message = "projects must be an absolute path.";
        }
      ];
    } ]; }
    { home-manager.sharedModules = [ {
      xdg.userDirs.createDirectories = ((lib.mkIf ((cfg.createDirectories != null))) (cfg.createDirectories));
    } ]; }
    { home-manager.sharedModules = [ {
      xdg.userDirs.desktop = ((lib.mkIf ((cfg.desktop != null))) (cfg.desktop));
    } ]; }
    { home-manager.sharedModules = [ {
      xdg.userDirs.documents = ((lib.mkIf ((cfg.documents != null))) (cfg.documents));
    } ]; }
    { home-manager.sharedModules = [ {
      xdg.userDirs.download = ((lib.mkIf ((cfg.downloads != null))) (cfg.downloads));
    } ]; }
    { home-manager.sharedModules = [ {
      xdg.userDirs.music = ((lib.mkIf ((cfg.music != null))) (cfg.music));
    } ]; }
    { home-manager.sharedModules = [ {
      xdg.userDirs.pictures = ((lib.mkIf ((cfg.pictures != null))) (cfg.pictures));
    } ]; }
    { home-manager.sharedModules = [ {
      xdg.userDirs.videos = ((lib.mkIf ((cfg.videos != null))) (cfg.videos));
    } ]; }
    { home-manager.sharedModules = [ {
      xdg.userDirs.templates = ((lib.mkIf ((cfg.templates != null))) (cfg.templates));
    } ]; }
    { home-manager.sharedModules = [ {
      xdg.userDirs.publicShare = ((lib.mkIf ((cfg.publicShare != null))) (cfg.publicShare));
    } ]; }
    { home-manager.sharedModules = [ {
      xdg.userDirs.projects = ((lib.mkIf ((cfg.projects != null))) (cfg.projects));
    } ]; }
  ];
}
