{ config, lib, pkgs, maintainers ? lib.maintainers, licenses ? lib.licenses, ... }:
let
  cfg = config.zenos.system.zenfs;
  name = "zenfs";
in
{
  options.zenos.system.zenfs = lib.mkOption { type = (lib.types.submodule ({ ... }: { options = { apps = lib.mkOption { type = (lib.types.submodule ({ ... }: { options = { appimage = lib.mkOption { type = (lib.types.submodule ({ ... }: { options = { enable = lib.mkOption { type = lib.types.bool; default = true; }; runPackage = lib.mkOption { type = lib.types.package; default = pkgs.zenos.legacy.appimage-run; }; }; })); default = { }; }; enable = lib.mkOption { type = lib.types.bool; default = true; }; flatpak = lib.mkOption { type = (lib.types.submodule ({ ... }: { options = { enable = lib.mkOption { type = lib.types.bool; default = true; }; remote = lib.mkOption { type = (lib.types.submodule ({ ... }: { options = { descriptor = lib.mkOption { type = (lib.types.either (lib.types.enum [ null ]) lib.types.path); default = null; }; name = lib.mkOption { type = lib.types.str; default = "zenos-flathub"; }; }; })); default = { }; }; }; })); default = { }; }; }; })); default = { }; }; enable = lib.mkOption { type = lib.types.bool; default = false; }; filesystemHierarchy = lib.mkOption { type = (lib.types.submodule ({ ... }: { options = { enable = lib.mkOption { type = lib.types.bool; default = true; }; }; })); default = { }; }; roaming = lib.mkOption { type = (lib.types.submodule ({ ... }: { options = { drives = lib.mkOption { type = (lib.types.submodule ({ ... }: { options = { }; freeformType = lib.types.attrsOf (lib.types.submodule ({ name, ... }: let _zenFreeformKey0 = name; in { options = { device = lib.mkOption { type = lib.types.str; }; enable = lib.mkOption { type = lib.types.bool; default = true; }; fsType = lib.mkOption { type = lib.types.str; default = "auto"; }; markerFile = lib.mkOption { type = lib.types.str; default = ".zenfs-roaming.json"; }; markerId = lib.mkOption { type = lib.types.str; default = _zenFreeformKey0; }; mountPoint = lib.mkOption { type = lib.types.str; default = "/Mount/${((value: let kind = builtins.typeOf value; in if kind == "string" then value else if kind == "bool" || kind == "int" || kind == "float" then builtins.toJSON value else if kind == "path" then "${value}" else if kind == "set" && (value.type or null) == "derivation" && builtins.isString (value.outPath or null) then value.outPath else throw "/nix/store/3ni594f60hm22hcrazxd35dmk7pwi61m-zenpkgs-dsl-source/modules/system/zenfs.zmdl:44: string interpolation requires a scalar, path, or package") (_zenFreeformKey0))}"; }; options = lib.mkOption { type = (lib.types.listOf lib.types.str); default = [
  "nofail"
  "x-systemd.automount"
  "x-systemd.device-timeout=10s"
  "nodev"
  "nosuid"
  "noexec"
]; }; privateMounts = lib.mkOption { type = (lib.types.submodule ({ ... }: { options = { }; freeformType = lib.types.attrsOf (lib.types.submodule ({ name, ... }: let _zenFreeformKey1 = name; in { options = { readOnly = lib.mkOption { type = lib.types.bool; default = true; }; source = lib.mkOption { type = lib.types.str; default = _zenFreeformKey1; }; target = lib.mkOption { type = (lib.types.either (lib.types.enum [ null ]) lib.types.str); default = null; }; user = lib.mkOption { type = lib.types.str; }; }; })); })); default = { }; }; }; })); })); default = { }; }; enable = lib.mkOption { type = lib.types.bool; default = false; }; }; })); default = { }; }; strict = lib.mkOption { type = lib.types.bool; default = true; description = "Flatpak CLI, library and helper app data is redirected into .private/Packages/flatpak-app-data; legacy migration requires live Flatpak apps to exit before initialization succeeds."; }; }; })); default = { }; };
  config = { _module.args.zenlang.descriptors.system.zenfs = {
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
            value = "Declares the public ZenFS policy. The composition supplies managed users to the configuration-only runtime backend. Enabling this module does not schedule watchers, offloading, or Janitor.";
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
            value = "ZenFS";
          }
        ];
        type = "string";
      };
      summary = {
        multiline = false;
        parts = [
          {
            type = "text";
            value = "ZenOS filesystem hierarchy and application integration";
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
                value = "filesystem";
              }
            ];
            type = "string";
          }
          {
            multiline = false;
            parts = [
              {
                type = "text";
                value = "applications";
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
    moduleIdentity = "zenos.system.zenfs";
    modulePath = [
      "system"
      "zenfs"
    ];
    nodeMetadata = [
      {
        metadata = {
          description = {
            multiline = true;
            parts = [
              {
                type = "text";
                value = "Declares the public ZenFS policy. The composition supplies managed users to the configuration-only runtime backend. Enabling this module does not schedule watchers, offloading, or Janitor.";
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
                value = "ZenFS";
              }
            ];
            type = "string";
          };
          summary = {
            multiline = false;
            parts = [
              {
                type = "text";
                value = "ZenOS filesystem hierarchy and application integration";
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
                    value = "filesystem";
                  }
                ];
                type = "string";
              }
              {
                multiline = false;
                parts = [
                  {
                    type = "text";
                    value = "applications";
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
          summary = {
            multiline = false;
            parts = [
              {
                type = "text";
                value = "Enable ZenFS integration";
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
          "filesystemHierarchy"
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
                value = "Activate the readable root hierarchy";
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
          "filesystemHierarchy"
          "enable"
        ];
      }
      {
        metadata = {
          default = {
            kind = "true";
            type = "literal";
            value = true;
          };
          description = {
            multiline = true;
            parts = [
              {
                type = "text";
                value = "Flatpak CLI, library and helper app data is redirected into .private/Packages/flatpak-app-data; legacy migration requires live Flatpak apps to exit before initialization succeeds.";
              }
            ];
            type = "string";
          };
          summary = {
            multiline = false;
            parts = [
              {
                type = "text";
                value = "Keep managed home dotfiles under .private";
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
          "strict"
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
          "apps"
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
                value = "Build separate system and private application views";
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
          "apps"
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
          "apps"
          "appimage"
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
                value = "Integrate AppImage installation and execution";
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
          "apps"
          "appimage"
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
                value = "zenos";
              }
              {
                kind = "identifier";
                value = "legacy";
              }
              {
                kind = "identifier";
                value = "appimage-run";
              }
            ];
            type = "variable";
          };
          summary = {
            multiline = false;
            parts = [
              {
                type = "text";
                value = "AppImage execution package";
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
            value = "1.0.0Na";
          };
        };
        path = [
          "apps"
          "appimage"
          "runPackage"
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
          "apps"
          "flatpak"
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
                value = "Integrate Flatpak and private exports";
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
          "apps"
          "flatpak"
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
          "apps"
          "flatpak"
          "remote"
        ];
      }
      {
        metadata = {
          default = {
            multiline = false;
            parts = [
              {
                type = "text";
                value = "zenos-flathub";
              }
            ];
            type = "string";
          };
          summary = {
            multiline = false;
            parts = [
              {
                type = "text";
                value = "Owned Flatpak remote";
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
          "apps"
          "flatpak"
          "remote"
          "name"
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
                value = "Repository descriptor, or the pinned Flathub descriptor";
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
          "apps"
          "flatpak"
          "remote"
          "descriptor"
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
          "roaming"
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
                value = "Enable explicitly configured, marker-verified roaming mounts";
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
          "roaming"
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
          "roaming"
          "drives"
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
          "roaming"
          "drives"
          {
            freeform = "drive";
          }
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
                value = "Enable this drive";
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
          "roaming"
          "drives"
          {
            freeform = "drive";
          }
          "enable"
        ];
      }
      {
        metadata = {
          summary = {
            multiline = false;
            parts = [
              {
                type = "text";
                value = "Stable block device path";
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
          "roaming"
          "drives"
          {
            freeform = "drive";
          }
          "device"
        ];
      }
      {
        metadata = {
          default = {
            multiline = false;
            parts = [
              {
                type = "text";
                value = "auto";
              }
            ];
            type = "string";
          };
          summary = {
            multiline = false;
            parts = [
              {
                type = "text";
                value = "Filesystem type";
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
          "roaming"
          "drives"
          {
            freeform = "drive";
          }
          "fsType"
        ];
      }
      {
        metadata = {
          default = {
            multiline = false;
            parts = [
              {
                type = "text";
                value = "/Mount/";
              }
              {
                expression = {
                  name = "f";
                  path = [
                    {
                      kind = "identifier";
                      value = "drive";
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
                value = "Drive mountpoint";
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
          "roaming"
          "drives"
          {
            freeform = "drive";
          }
          "mountPoint"
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
                    value = "nofail";
                  }
                ];
                type = "string";
              }
              {
                multiline = false;
                parts = [
                  {
                    type = "text";
                    value = "x-systemd.automount";
                  }
                ];
                type = "string";
              }
              {
                multiline = false;
                parts = [
                  {
                    type = "text";
                    value = "x-systemd.device-timeout=10s";
                  }
                ];
                type = "string";
              }
              {
                multiline = false;
                parts = [
                  {
                    type = "text";
                    value = "nodev";
                  }
                ];
                type = "string";
              }
              {
                multiline = false;
                parts = [
                  {
                    type = "text";
                    value = "nosuid";
                  }
                ];
                type = "string";
              }
              {
                multiline = false;
                parts = [
                  {
                    type = "text";
                    value = "noexec";
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
                value = "Restrictive mount options";
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
          zenosVersion = {
            kind = "version";
            type = "literal";
            value = "1.0.0Na";
          };
        };
        path = [
          "roaming"
          "drives"
          {
            freeform = "drive";
          }
          "options"
        ];
      }
      {
        metadata = {
          default = {
            multiline = false;
            parts = [
              {
                type = "text";
                value = ".zenfs-roaming.json";
              }
            ];
            type = "string";
          };
          summary = {
            multiline = false;
            parts = [
              {
                type = "text";
                value = "Relative marker filename";
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
          "roaming"
          "drives"
          {
            freeform = "drive";
          }
          "markerFile"
        ];
      }
      {
        metadata = {
          default = {
            name = "f";
            path = [
              {
                kind = "identifier";
                value = "drive";
              }
            ];
            type = "variable";
          };
          summary = {
            multiline = false;
            parts = [
              {
                type = "text";
                value = "Required marker identity";
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
          "roaming"
          "drives"
          {
            freeform = "drive";
          }
          "markerId"
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
          "roaming"
          "drives"
          {
            freeform = "drive";
          }
          "privateMounts"
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
          "roaming"
          "drives"
          {
            freeform = "drive";
          }
          "privateMounts"
          {
            freeform = "mount";
          }
        ];
      }
      {
        metadata = {
          summary = {
            multiline = false;
            parts = [
              {
                type = "text";
                value = "Composition-managed user";
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
          "roaming"
          "drives"
          {
            freeform = "drive";
          }
          "privateMounts"
          {
            freeform = "mount";
          }
          "user"
        ];
      }
      {
        metadata = {
          default = {
            name = "f";
            path = [
              {
                kind = "identifier";
                value = "mount";
              }
            ];
            type = "variable";
          };
          summary = {
            multiline = false;
            parts = [
              {
                type = "text";
                value = "Relative directory on the drive";
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
          "roaming"
          "drives"
          {
            freeform = "drive";
          }
          "privateMounts"
          {
            freeform = "mount";
          }
          "source"
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
                value = "Private home-relative target, default .private/Mount/name";
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
          "roaming"
          "drives"
          {
            freeform = "drive";
          }
          "privateMounts"
          {
            freeform = "mount";
          }
          "target"
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
                value = "Read-only private bind mount";
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
          "roaming"
          "drives"
          {
            freeform = "drive";
          }
          "privateMounts"
          {
            freeform = "mount";
          }
          "readOnly"
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
                    value = "ZenFS";
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
                    value = "ZenOS filesystem hierarchy and application integration";
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
                    value = "Declares the public ZenFS policy. The composition supplies managed users to the configuration-only runtime backend. Enabling this module does not schedule watchers, offloading, or Janitor.";
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
                        value = "filesystem";
                      }
                    ];
                    type = "string";
                  }
                  {
                    multiline = false;
                    parts = [
                      {
                        type = "text";
                        value = "applications";
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
                            value = "Enable ZenFS integration";
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
          type = "enable-option";
        };
      }
      {
        operator = "=";
        target = [
          {
            kind = "identifier";
            value = "filesystemHierarchy";
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
                                value = "Activate the readable root hierarchy";
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
            value = "strict";
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
                          value = "Keep managed home dotfiles under .private";
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
                          value = "Flatpak CLI, library and helper app data is redirected into .private/Packages/flatpak-app-data; legacy migration requires live Flatpak apps to exit before initialization succeeds.";
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
            value = "apps";
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
                                value = "Build separate system and private application views";
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
                  value = "appimage";
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
                                      value = "Integrate AppImage installation and execution";
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
                        value = "runPackage";
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
                                      value = "zenos";
                                    }
                                    {
                                      kind = "identifier";
                                      value = "legacy";
                                    }
                                    {
                                      kind = "identifier";
                                      value = "appimage-run";
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
                                      value = "AppImage execution package";
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
                  value = "flatpak";
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
                                      value = "Integrate Flatpak and private exports";
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
                        value = "remote";
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
                                            value = "zenos-flathub";
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
                                            value = "Owned Flatpak remote";
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
                              value = "descriptor";
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
                                            value = "Repository descriptor, or the pinned Flathub descriptor";
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
            value = "roaming";
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
                                value = "Enable explicitly configured, marker-verified roaming mounts";
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
                  value = "drives";
                }
              ];
              type = "assignment";
              value = {
                recursive = false;
                statements = [
                  {
                    operator = "=";
                    target = {
                      argument = [
                        {
                          kind = "identifier";
                          value = "drive";
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
                                            value = "Enable this drive";
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
                              value = "device";
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
                                          value = "summary";
                                        }
                                      ];
                                      type = "assignment";
                                      value = {
                                        multiline = false;
                                        parts = [
                                          {
                                            type = "text";
                                            value = "Stable block device path";
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
                              value = "fsType";
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
                                            value = "auto";
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
                                            value = "Filesystem type";
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
                              value = "mountPoint";
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
                                            value = "/Mount/";
                                          }
                                          {
                                            expression = {
                                              name = "f";
                                              path = [
                                                {
                                                  kind = "identifier";
                                                  value = "drive";
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
                                            value = "Drive mountpoint";
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
                              value = "options";
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
                                                value = "nofail";
                                              }
                                            ];
                                            type = "string";
                                          }
                                          {
                                            multiline = false;
                                            parts = [
                                              {
                                                type = "text";
                                                value = "x-systemd.automount";
                                              }
                                            ];
                                            type = "string";
                                          }
                                          {
                                            multiline = false;
                                            parts = [
                                              {
                                                type = "text";
                                                value = "x-systemd.device-timeout=10s";
                                              }
                                            ];
                                            type = "string";
                                          }
                                          {
                                            multiline = false;
                                            parts = [
                                              {
                                                type = "text";
                                                value = "nodev";
                                              }
                                            ];
                                            type = "string";
                                          }
                                          {
                                            multiline = false;
                                            parts = [
                                              {
                                                type = "text";
                                                value = "nosuid";
                                              }
                                            ];
                                            type = "string";
                                          }
                                          {
                                            multiline = false;
                                            parts = [
                                              {
                                                type = "text";
                                                value = "noexec";
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
                                            value = "Restrictive mount options";
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
                              value = "markerFile";
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
                                            value = ".zenfs-roaming.json";
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
                                            value = "Relative marker filename";
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
                              value = "markerId";
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
                                        name = "f";
                                        path = [
                                          {
                                            kind = "identifier";
                                            value = "drive";
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
                                            value = "Required marker identity";
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
                              value = "privateMounts";
                            }
                          ];
                          type = "assignment";
                          value = {
                            recursive = false;
                            statements = [
                              {
                                operator = "=";
                                target = {
                                  argument = [
                                    {
                                      kind = "identifier";
                                      value = "mount";
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
                                          value = "user";
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
                                                      value = "summary";
                                                    }
                                                  ];
                                                  type = "assignment";
                                                  value = {
                                                    multiline = false;
                                                    parts = [
                                                      {
                                                        type = "text";
                                                        value = "Composition-managed user";
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
                                          value = "source";
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
                                                    name = "f";
                                                    path = [
                                                      {
                                                        kind = "identifier";
                                                        value = "mount";
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
                                                        value = "Relative directory on the drive";
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
                                          value = "target";
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
                                                        value = "Private home-relative target, default .private/Mount/name";
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
                                          value = "readOnly";
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
                                                        value = "Read-only private bind mount";
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
          ];
          type = "attr-set";
        };
      }
    ];
  }; };
}
