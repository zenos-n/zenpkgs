{ config, lib, pkgs, maintainers ? lib.maintainers, licenses ? lib.licenses, ... }:
let
  cfg = config.zenos.programs.select-for-figma;
  name = "select-for-figma";
  preferences = (builtins.addErrorContext "_let preferences annotation mismatch: /nix/store/59qqzf108ga8h2qmsjizzsn2p7i889xx-zenpkgs-dsl-source/modules/programs/select-for-figma.zmdl:100:1" ((_zenType: _zenValue: let force = type: value: if type.name == "anything" then true else if type.name == "listOf" then builtins.all (force type.nestedTypes.elemType) value else if type.name == "attrsOf" then builtins.all (force type.nestedTypes.elemType) (builtins.attrValues value) else if type.name == "either" then force (if type.nestedTypes.left.check value then type.nestedTypes.left else type.nestedTypes.right) value else builtins.seq value true; in builtins.seq (force _zenType _zenValue) _zenValue) ((lib.types.listOf lib.types.attrs)) ((lib.evalModules { modules = [ { options.value = lib.mkOption { type = (lib.types.listOf lib.types.attrs); }; config.value = (((((((((((((((lib.optional ((cfg.appearance != null))) {
    path = [
      "appearance"
    ];
    value = cfg.appearance;
  })) ++ (((lib.optional ((cfg.adwaitaEditorTheme != null))) {
    path = [
      "adwaita-editor"
    ];
    value = cfg.adwaitaEditorTheme;
  }))) ++ (((lib.optional ((cfg.restoreOpenFiles != null))) {
    path = [
      "restore-session"
    ];
    value = cfg.restoreOpenFiles;
  }))) ++ (((lib.optional ((cfg.tabSwitchingOrder != null))) {
    path = [
      "tab-switcher-mru"
    ];
    value = (cfg.tabSwitchingOrder == "recent");
  }))) ++ (((lib.optional ((cfg.localFonts != null))) {
    path = [
      "local-fonts"
    ];
    value = cfg.localFonts;
  }))) ++ (((lib.optional ((cfg.notifications != null))) {
    path = [
      "notifications"
    ];
    value = cfg.notifications;
  }))) ++ (((lib.optional ((cfg.downloadDirectory != null))) {
    path = [
      "download-folder"
    ];
    value = cfg.downloadDirectory;
  }))) ++ (((lib.optional ((cfg.zane.chat.model != null))) {
    path = [
      "zane-chat-model"
    ];
    value = cfg.zane.chat.model;
  }))) ++ (((lib.optional ((cfg.zane.chat.reasoningEffort != null))) {
    path = [
      "zane-chat-effort"
    ];
    value = cfg.zane.chat.reasoningEffort;
  }))) ++ (((lib.optional ((cfg.zane.work.model != null))) {
    path = [
      "zane-work-model"
    ];
    value = cfg.zane.work.model;
  }))) ++ (((lib.optional ((cfg.zane.work.reasoningEffort != null))) {
    path = [
      "zane-work-effort"
    ];
    value = cfg.zane.work.reasoningEffort;
  }))) ++ (((lib.optional ((cfg.zane.showAccountPresence != null))) {
    path = [
      "zane-account-presence"
    ];
    value = cfg.zane.showAccountPresence;
  }))) ++ (((lib.optional ((cfg.zane.automaticEditAccess != null))) {
    path = [
      "zane-auto-edit-access"
    ];
    value = cfg.zane.automaticEditAccess;
  }))); } ]; }).config.value)));
in
{
  options.zenos.programs.select-for-figma = lib.mkOption { type = (lib.types.submodule ({ ... }: (let preferences = (builtins.addErrorContext "_let preferences annotation mismatch: /nix/store/59qqzf108ga8h2qmsjizzsn2p7i889xx-zenpkgs-dsl-source/modules/programs/select-for-figma.zmdl:100:1" ((_zenType: _zenValue: let force = type: value: if type.name == "anything" then true else if type.name == "listOf" then builtins.all (force type.nestedTypes.elemType) value else if type.name == "attrsOf" then builtins.all (force type.nestedTypes.elemType) (builtins.attrValues value) else if type.name == "either" then force (if type.nestedTypes.left.check value then type.nestedTypes.left else type.nestedTypes.right) value else builtins.seq value true; in builtins.seq (force _zenType _zenValue) _zenValue) ((lib.types.listOf lib.types.attrs)) ((lib.evalModules { modules = [ { options.value = lib.mkOption { type = (lib.types.listOf lib.types.attrs); }; config.value = (((((((((((((((lib.optional ((cfg.appearance != null))) {
        path = [
          "appearance"
        ];
        value = cfg.appearance;
      })) ++ (((lib.optional ((cfg.adwaitaEditorTheme != null))) {
        path = [
          "adwaita-editor"
        ];
        value = cfg.adwaitaEditorTheme;
      }))) ++ (((lib.optional ((cfg.restoreOpenFiles != null))) {
        path = [
          "restore-session"
        ];
        value = cfg.restoreOpenFiles;
      }))) ++ (((lib.optional ((cfg.tabSwitchingOrder != null))) {
        path = [
          "tab-switcher-mru"
        ];
        value = (cfg.tabSwitchingOrder == "recent");
      }))) ++ (((lib.optional ((cfg.localFonts != null))) {
        path = [
          "local-fonts"
        ];
        value = cfg.localFonts;
      }))) ++ (((lib.optional ((cfg.notifications != null))) {
        path = [
          "notifications"
        ];
        value = cfg.notifications;
      }))) ++ (((lib.optional ((cfg.downloadDirectory != null))) {
        path = [
          "download-folder"
        ];
        value = cfg.downloadDirectory;
      }))) ++ (((lib.optional ((cfg.zane.chat.model != null))) {
        path = [
          "zane-chat-model"
        ];
        value = cfg.zane.chat.model;
      }))) ++ (((lib.optional ((cfg.zane.chat.reasoningEffort != null))) {
        path = [
          "zane-chat-effort"
        ];
        value = cfg.zane.chat.reasoningEffort;
      }))) ++ (((lib.optional ((cfg.zane.work.model != null))) {
        path = [
          "zane-work-model"
        ];
        value = cfg.zane.work.model;
      }))) ++ (((lib.optional ((cfg.zane.work.reasoningEffort != null))) {
        path = [
          "zane-work-effort"
        ];
        value = cfg.zane.work.reasoningEffort;
      }))) ++ (((lib.optional ((cfg.zane.showAccountPresence != null))) {
        path = [
          "zane-account-presence"
        ];
        value = cfg.zane.showAccountPresence;
      }))) ++ (((lib.optional ((cfg.zane.automaticEditAccess != null))) {
        path = [
          "zane-auto-edit-access"
        ];
        value = cfg.zane.automaticEditAccess;
      }))); } ]; }).config.value))); in { options = { adwaitaEditorTheme = lib.mkOption { type = (lib.types.either lib.types.bool (lib.types.enum [ null ])); default = null; description = "Apply the native Adwaita theme to Figma editor chrome. Null preserves the current preference. Restart Select after applying changes."; }; appearance = lib.mkOption { type = (lib.types.either (lib.types.enum [
  "system"
  "light"
  "dark"
]) (lib.types.enum [ null ])); default = null; description = "Follow the desktop appearance or force light or dark mode. Null preserves the current preference. Restart Select after applying changes."; }; downloadDirectory = lib.mkOption { type = (lib.types.either lib.types.str (lib.types.enum [ null ])); default = null; description = "Absolute directory for downloads and exported files. Null preserves the current preference. Restart Select after applying changes."; }; enable = lib.mkOption { type = lib.types.bool; default = false; description = "Install native Select for the selected user scope. Apply only non-null preferences to its writable state file. Existing figma-gtk data is migrated before the first preference write."; }; localFonts = lib.mkOption { type = (lib.types.either lib.types.bool (lib.types.enum [ null ])); default = null; description = "Make installed local fonts available to Figma. Null preserves the current preference. Restart Select after applying changes."; }; notifications = lib.mkOption { type = (lib.types.either lib.types.bool (lib.types.enum [ null ])); default = null; description = "Allow desktop notifications from the embedded Figma client. Null preserves the current preference. Restart Select after applying changes."; }; restoreOpenFiles = lib.mkOption { type = (lib.types.either lib.types.bool (lib.types.enum [ null ])); default = null; description = "Restore the previous document session when Select starts. Null preserves the current preference. Restart Select after applying changes."; }; tabSwitchingOrder = lib.mkOption { type = (lib.types.either (lib.types.enum [
  "position"
  "recent"
]) (lib.types.enum [ null ])); default = null; description = "Cycle with Ctrl+Tab in tab position or most recently used order, including Home. Null preserves the current preference. Restart Select after applying changes."; }; zane = lib.mkOption { type = (lib.types.submodule ({ ... }: { options = { automaticEditAccess = lib.mkOption { type = (lib.types.either lib.types.bool (lib.types.enum [ null ])); default = null; description = "Let Zane request editor access automatically when performing edits. Null preserves the current preference. Restart Select after applying changes."; }; chat = lib.mkOption { type = (lib.types.submodule ({ ... }: { options = { model = lib.mkOption { type = (lib.types.either lib.types.str (lib.types.enum [ null ])); default = null; description = "Chat model identifier, at most 200 UTF-8 bytes. An empty string uses Codex settings. Null preserves the current preference. Restart Select after applying changes."; }; reasoningEffort = lib.mkOption { type = (lib.types.either lib.types.str (lib.types.enum [ null ])); default = null; description = "Reasoning level supported by the selected model, at most 32 UTF-8 bytes. An empty string uses Codex settings. Null preserves the current preference. Restart Select after applying changes."; }; }; })); default = { }; }; showAccountPresence = lib.mkOption { type = (lib.types.either lib.types.bool (lib.types.enum [ null ])); default = null; description = "Show Zane account presence in the signed-in editor. Null preserves the current preference. Restart Select after applying changes."; }; work = lib.mkOption { type = (lib.types.submodule ({ ... }: { options = { model = lib.mkOption { type = (lib.types.either lib.types.str (lib.types.enum [ null ])); default = null; description = "Work model identifier, at most 200 UTF-8 bytes. An empty string uses Codex settings. Null preserves the current preference. Restart Select after applying changes."; }; reasoningEffort = lib.mkOption { type = (lib.types.either lib.types.str (lib.types.enum [ null ])); default = null; description = "Reasoning level supported by the selected model, at most 32 UTF-8 bytes. An empty string uses Codex settings. Null preserves the current preference. Restart Select after applying changes."; }; }; })); default = { }; }; }; })); default = { }; }; }; }))); default = { }; };
  config = lib.mkMerge [
    { _module.args.zenlang.descriptors.programs.select-for-figma = {
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
            value = "Native GTK Select preferences. Selected settings are reapplied during user activation; other preferences, sessions and login data remain writable and unchanged.";
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
            value = "Select for Figma";
          }
        ];
        type = "string";
      };
      summary = {
        multiline = false;
        parts = [
          {
            type = "text";
            value = "Install and configure the native Select for Figma client";
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
                value = "programs";
              }
            ];
            type = "string";
          }
          {
            multiline = false;
            parts = [
              {
                type = "text";
                value = "graphics";
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
        value = "1.0.0Nb";
      };
    };
    moduleIdentity = "zenos.programs.select-for-figma";
    modulePath = [
      "programs"
      "select-for-figma"
    ];
    nodeMetadata = [
      {
        metadata = {
          description = {
            multiline = true;
            parts = [
              {
                type = "text";
                value = "Native GTK Select preferences. Selected settings are reapplied during user activation; other preferences, sessions and login data remain writable and unchanged.";
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
                value = "Select for Figma";
              }
            ];
            type = "string";
          };
          summary = {
            multiline = false;
            parts = [
              {
                type = "text";
                value = "Install and configure the native Select for Figma client";
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
                    value = "programs";
                  }
                ];
                type = "string";
              }
              {
                multiline = false;
                parts = [
                  {
                    type = "text";
                    value = "graphics";
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
            value = "1.0.0Nb";
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
                value = "Follow the desktop appearance or force light or dark mode. Null preserves the current preference. Restart Select after applying changes.";
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
                value = "Appearance";
              }
            ];
            type = "string";
          };
          summary = {
            multiline = false;
            parts = [
              {
                type = "text";
                value = "Appearance";
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
                    value = "programs";
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
                                  value = "system";
                                }
                              ];
                              type = "string";
                            }
                            {
                              multiline = false;
                              parts = [
                                {
                                  type = "text";
                                  value = "light";
                                }
                              ];
                              type = "string";
                            }
                            {
                              multiline = false;
                              parts = [
                                {
                                  type = "text";
                                  value = "dark";
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
            value = "1.0.0Nb";
          };
        };
        path = [
          "appearance"
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
                value = "Apply the native Adwaita theme to Figma editor chrome. Null preserves the current preference. Restart Select after applying changes.";
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
                value = "Adwaita editor theme";
              }
            ];
            type = "string";
          };
          summary = {
            multiline = false;
            parts = [
              {
                type = "text";
                value = "Adwaita editor theme";
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
                    value = "programs";
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
            value = "1.0.0Nb";
          };
        };
        path = [
          "adwaitaEditorTheme"
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
                value = "Restore the previous document session when Select starts. Null preserves the current preference. Restart Select after applying changes.";
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
                value = "Restore open files";
              }
            ];
            type = "string";
          };
          summary = {
            multiline = false;
            parts = [
              {
                type = "text";
                value = "Restore open files";
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
                    value = "programs";
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
            value = "1.0.0Nb";
          };
        };
        path = [
          "restoreOpenFiles"
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
                value = "Cycle with Ctrl+Tab in tab position or most recently used order, including Home. Null preserves the current preference. Restart Select after applying changes.";
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
                value = "Tab switching order";
              }
            ];
            type = "string";
          };
          summary = {
            multiline = false;
            parts = [
              {
                type = "text";
                value = "Tab switching order";
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
                    value = "programs";
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
                                  value = "position";
                                }
                              ];
                              type = "string";
                            }
                            {
                              multiline = false;
                              parts = [
                                {
                                  type = "text";
                                  value = "recent";
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
            value = "1.0.0Nb";
          };
        };
        path = [
          "tabSwitchingOrder"
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
                value = "Make installed local fonts available to Figma. Null preserves the current preference. Restart Select after applying changes.";
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
                value = "Local fonts";
              }
            ];
            type = "string";
          };
          summary = {
            multiline = false;
            parts = [
              {
                type = "text";
                value = "Local fonts";
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
                    value = "programs";
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
            value = "1.0.0Nb";
          };
        };
        path = [
          "localFonts"
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
                value = "Allow desktop notifications from the embedded Figma client. Null preserves the current preference. Restart Select after applying changes.";
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
                value = "Notifications";
              }
            ];
            type = "string";
          };
          summary = {
            multiline = false;
            parts = [
              {
                type = "text";
                value = "Notifications";
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
                    value = "programs";
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
            value = "1.0.0Nb";
          };
        };
        path = [
          "notifications"
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
                value = "Absolute directory for downloads and exported files. Null preserves the current preference. Restart Select after applying changes.";
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
                value = "Download directory";
              }
            ];
            type = "string";
          };
          summary = {
            multiline = false;
            parts = [
              {
                type = "text";
                value = "Download directory";
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
                    value = "programs";
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
            value = "1.0.0Nb";
          };
        };
        path = [
          "downloadDirectory"
        ];
      }
      {
        metadata = {
          zenosVersion = {
            kind = "version";
            type = "literal";
            value = "1.0.0Nb";
          };
        };
        path = [
          "zane"
        ];
      }
      {
        metadata = {
          zenosVersion = {
            kind = "version";
            type = "literal";
            value = "1.0.0Nb";
          };
        };
        path = [
          "zane"
          "chat"
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
                value = "Chat model identifier, at most 200 UTF-8 bytes. An empty string uses Codex settings. Null preserves the current preference. Restart Select after applying changes.";
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
                value = "Chat model";
              }
            ];
            type = "string";
          };
          summary = {
            multiline = false;
            parts = [
              {
                type = "text";
                value = "Chat model";
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
                    value = "programs";
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
            value = "1.0.0Nb";
          };
        };
        path = [
          "zane"
          "chat"
          "model"
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
                value = "Reasoning level supported by the selected model, at most 32 UTF-8 bytes. An empty string uses Codex settings. Null preserves the current preference. Restart Select after applying changes.";
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
                value = "Chat reasoning effort";
              }
            ];
            type = "string";
          };
          summary = {
            multiline = false;
            parts = [
              {
                type = "text";
                value = "Chat reasoning effort";
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
                    value = "programs";
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
            value = "1.0.0Nb";
          };
        };
        path = [
          "zane"
          "chat"
          "reasoningEffort"
        ];
      }
      {
        metadata = {
          zenosVersion = {
            kind = "version";
            type = "literal";
            value = "1.0.0Nb";
          };
        };
        path = [
          "zane"
          "work"
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
                value = "Work model identifier, at most 200 UTF-8 bytes. An empty string uses Codex settings. Null preserves the current preference. Restart Select after applying changes.";
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
                value = "Work model";
              }
            ];
            type = "string";
          };
          summary = {
            multiline = false;
            parts = [
              {
                type = "text";
                value = "Work model";
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
                    value = "programs";
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
            value = "1.0.0Nb";
          };
        };
        path = [
          "zane"
          "work"
          "model"
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
                value = "Reasoning level supported by the selected model, at most 32 UTF-8 bytes. An empty string uses Codex settings. Null preserves the current preference. Restart Select after applying changes.";
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
                value = "Work reasoning effort";
              }
            ];
            type = "string";
          };
          summary = {
            multiline = false;
            parts = [
              {
                type = "text";
                value = "Work reasoning effort";
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
                    value = "programs";
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
            value = "1.0.0Nb";
          };
        };
        path = [
          "zane"
          "work"
          "reasoningEffort"
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
                value = "Show Zane account presence in the signed-in editor. Null preserves the current preference. Restart Select after applying changes.";
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
                value = "Show account presence";
              }
            ];
            type = "string";
          };
          summary = {
            multiline = false;
            parts = [
              {
                type = "text";
                value = "Show account presence";
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
                    value = "programs";
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
            value = "1.0.0Nb";
          };
        };
        path = [
          "zane"
          "showAccountPresence"
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
                value = "Let Zane request editor access automatically when performing edits. Null preserves the current preference. Restart Select after applying changes.";
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
                value = "Automatic edit access";
              }
            ];
            type = "string";
          };
          summary = {
            multiline = false;
            parts = [
              {
                type = "text";
                value = "Automatic edit access";
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
                    value = "programs";
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
            value = "1.0.0Nb";
          };
        };
        path = [
          "zane"
          "automaticEditAccess"
        ];
      }
      {
        metadata = {
          description = {
            multiline = true;
            parts = [
              {
                type = "text";
                value = "Install native Select for the selected user scope. Apply only non-null preferences to its writable state file. Existing figma-gtk data is migrated before the first preference write.";
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
                value = "Install and configure Select for Figma";
              }
            ];
            type = "string";
          };
          summary = {
            multiline = false;
            parts = [
              {
                type = "text";
                value = "Install and configure Select for Figma";
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
                    value = "programs";
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
            value = "1.0.0Nb";
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
                  value = "name";
                }
              ];
              type = "assignment";
              value = {
                multiline = false;
                parts = [
                  {
                    type = "text";
                    value = "Select for Figma";
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
                    value = "Install and configure the native Select for Figma client";
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
                    value = "Native GTK Select preferences. Selected settings are reapplied during user activation; other preferences, sessions and login data remain writable and unchanged.";
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
                        value = "programs";
                      }
                    ];
                    type = "string";
                  }
                  {
                    multiline = false;
                    parts = [
                      {
                        type = "text";
                        value = "graphics";
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
            value = "appearance";
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
                          value = "Appearance";
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
                          value = "Appearance";
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
                          value = "Follow the desktop appearance or force light or dark mode. Null preserves the current preference. Restart Select after applying changes.";
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
                                            value = "system";
                                          }
                                        ];
                                        type = "string";
                                      }
                                      {
                                        multiline = false;
                                        parts = [
                                          {
                                            type = "text";
                                            value = "light";
                                          }
                                        ];
                                        type = "string";
                                      }
                                      {
                                        multiline = false;
                                        parts = [
                                          {
                                            type = "text";
                                            value = "dark";
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
                              value = "programs";
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
          ];
          type = "attr-set";
        };
      }
      {
        operator = "=";
        target = [
          {
            kind = "identifier";
            value = "adwaitaEditorTheme";
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
                          value = "Adwaita editor theme";
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
                          value = "Adwaita editor theme";
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
                          value = "Apply the native Adwaita theme to Figma editor chrome. Null preserves the current preference. Restart Select after applying changes.";
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
                              value = "programs";
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
          ];
          type = "attr-set";
        };
      }
      {
        operator = "=";
        target = [
          {
            kind = "identifier";
            value = "restoreOpenFiles";
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
                          value = "Restore open files";
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
                          value = "Restore open files";
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
                          value = "Restore the previous document session when Select starts. Null preserves the current preference. Restart Select after applying changes.";
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
                              value = "programs";
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
          ];
          type = "attr-set";
        };
      }
      {
        operator = "=";
        target = [
          {
            kind = "identifier";
            value = "tabSwitchingOrder";
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
                          value = "Tab switching order";
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
                          value = "Tab switching order";
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
                          value = "Cycle with Ctrl+Tab in tab position or most recently used order, including Home. Null preserves the current preference. Restart Select after applying changes.";
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
                                            value = "position";
                                          }
                                        ];
                                        type = "string";
                                      }
                                      {
                                        multiline = false;
                                        parts = [
                                          {
                                            type = "text";
                                            value = "recent";
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
                              value = "programs";
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
          ];
          type = "attr-set";
        };
      }
      {
        operator = "=";
        target = [
          {
            kind = "identifier";
            value = "localFonts";
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
                          value = "Local fonts";
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
                          value = "Local fonts";
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
                          value = "Make installed local fonts available to Figma. Null preserves the current preference. Restart Select after applying changes.";
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
                              value = "programs";
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
          ];
          type = "attr-set";
        };
      }
      {
        operator = "=";
        target = [
          {
            kind = "identifier";
            value = "notifications";
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
                          value = "Notifications";
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
                          value = "Notifications";
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
                          value = "Allow desktop notifications from the embedded Figma client. Null preserves the current preference. Restart Select after applying changes.";
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
                              value = "programs";
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
          ];
          type = "attr-set";
        };
      }
      {
        operator = "=";
        target = [
          {
            kind = "identifier";
            value = "downloadDirectory";
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
                          value = "Download directory";
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
                          value = "Download directory";
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
                          value = "Absolute directory for downloads and exported files. Null preserves the current preference. Restart Select after applying changes.";
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
                              value = "programs";
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
          ];
          type = "attr-set";
        };
      }
      {
        operator = "=";
        target = [
          {
            kind = "identifier";
            value = "zane";
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
                  value = "chat";
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
                        value = "model";
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
                                      value = "Chat model";
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
                                      value = "Chat model";
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
                                      value = "Chat model identifier, at most 200 UTF-8 bytes. An empty string uses Codex settings. Null preserves the current preference. Restart Select after applying changes.";
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
                                          value = "programs";
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
                      ];
                      type = "attr-set";
                    };
                  }
                  {
                    operator = "=";
                    target = [
                      {
                        kind = "identifier";
                        value = "reasoningEffort";
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
                                      value = "Chat reasoning effort";
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
                                      value = "Chat reasoning effort";
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
                                      value = "Reasoning level supported by the selected model, at most 32 UTF-8 bytes. An empty string uses Codex settings. Null preserves the current preference. Restart Select after applying changes.";
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
                                          value = "programs";
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
                  value = "work";
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
                        value = "model";
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
                                      value = "Work model";
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
                                      value = "Work model";
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
                                      value = "Work model identifier, at most 200 UTF-8 bytes. An empty string uses Codex settings. Null preserves the current preference. Restart Select after applying changes.";
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
                                          value = "programs";
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
                      ];
                      type = "attr-set";
                    };
                  }
                  {
                    operator = "=";
                    target = [
                      {
                        kind = "identifier";
                        value = "reasoningEffort";
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
                                      value = "Work reasoning effort";
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
                                      value = "Work reasoning effort";
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
                                      value = "Reasoning level supported by the selected model, at most 32 UTF-8 bytes. An empty string uses Codex settings. Null preserves the current preference. Restart Select after applying changes.";
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
                                          value = "programs";
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
                  value = "showAccountPresence";
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
                                value = "Show account presence";
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
                                value = "Show account presence";
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
                                value = "Show Zane account presence in the signed-in editor. Null preserves the current preference. Restart Select after applying changes.";
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
                                    value = "programs";
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
                ];
                type = "attr-set";
              };
            }
            {
              operator = "=";
              target = [
                {
                  kind = "identifier";
                  value = "automaticEditAccess";
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
                                value = "Automatic edit access";
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
                                value = "Automatic edit access";
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
                                value = "Let Zane request editor access automatically when performing edits. Null preserves the current preference. Restart Select after applying changes.";
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
                                    value = "programs";
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
                ];
                type = "attr-set";
              };
            }
          ];
          type = "attr-set";
        };
      }
      {
        annotation = {
          arguments = [
            {
              items = [
                {
                  name = "type";
                  path = [
                    {
                      kind = "identifier";
                      value = "set";
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
        name = "preferences";
        type = "let-binding";
        value = {
          left = {
            left = {
              left = {
                left = {
                  left = {
                    left = {
                      left = {
                        left = {
                          left = {
                            left = {
                              left = {
                                left = {
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
                                                value = "path";
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
                                                      value = "appearance";
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
                                                value = "value";
                                              }
                                            ];
                                            type = "assignment";
                                            value = {
                                              name = "path";
                                              path = [
                                                {
                                                  kind = "identifier";
                                                  value = "appearance";
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
                                      arguments = [
                                        {
                                          type = "group";
                                          value = {
                                            left = {
                                              name = "path";
                                              path = [
                                                {
                                                  kind = "identifier";
                                                  value = "appearance";
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
                                            value = "optional";
                                          }
                                        ];
                                        type = "variable";
                                      };
                                      type = "call";
                                    };
                                    type = "call";
                                  };
                                };
                                operator = "++";
                                right = {
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
                                                value = "path";
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
                                                      value = "adwaita-editor";
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
                                                value = "value";
                                              }
                                            ];
                                            type = "assignment";
                                            value = {
                                              name = "path";
                                              path = [
                                                {
                                                  kind = "identifier";
                                                  value = "adwaitaEditorTheme";
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
                                      arguments = [
                                        {
                                          type = "group";
                                          value = {
                                            left = {
                                              name = "path";
                                              path = [
                                                {
                                                  kind = "identifier";
                                                  value = "adwaitaEditorTheme";
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
                                            value = "optional";
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
                              operator = "++";
                              right = {
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
                                              value = "path";
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
                                                    value = "restore-session";
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
                                              value = "value";
                                            }
                                          ];
                                          type = "assignment";
                                          value = {
                                            name = "path";
                                            path = [
                                              {
                                                kind = "identifier";
                                                value = "restoreOpenFiles";
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
                                    arguments = [
                                      {
                                        type = "group";
                                        value = {
                                          left = {
                                            name = "path";
                                            path = [
                                              {
                                                kind = "identifier";
                                                value = "restoreOpenFiles";
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
                                          value = "optional";
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
                            operator = "++";
                            right = {
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
                                            value = "path";
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
                                                  value = "tab-switcher-mru";
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
                                            value = "value";
                                          }
                                        ];
                                        type = "assignment";
                                        value = {
                                          left = {
                                            name = "path";
                                            path = [
                                              {
                                                kind = "identifier";
                                                value = "tabSwitchingOrder";
                                              }
                                            ];
                                            type = "variable";
                                          };
                                          operator = "==";
                                          right = {
                                            multiline = false;
                                            parts = [
                                              {
                                                type = "text";
                                                value = "recent";
                                              }
                                            ];
                                            type = "string";
                                          };
                                          type = "binary";
                                        };
                                      }
                                    ];
                                    type = "attr-set";
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
                                              value = "tabSwitchingOrder";
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
                                        value = "optional";
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
                          operator = "++";
                          right = {
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
                                          value = "path";
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
                                                value = "local-fonts";
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
                                          value = "value";
                                        }
                                      ];
                                      type = "assignment";
                                      value = {
                                        name = "path";
                                        path = [
                                          {
                                            kind = "identifier";
                                            value = "localFonts";
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
                                arguments = [
                                  {
                                    type = "group";
                                    value = {
                                      left = {
                                        name = "path";
                                        path = [
                                          {
                                            kind = "identifier";
                                            value = "localFonts";
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
                                      value = "optional";
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
                        operator = "++";
                        right = {
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
                                        value = "path";
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
                                              value = "notifications";
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
                                        value = "value";
                                      }
                                    ];
                                    type = "assignment";
                                    value = {
                                      name = "path";
                                      path = [
                                        {
                                          kind = "identifier";
                                          value = "notifications";
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
                              arguments = [
                                {
                                  type = "group";
                                  value = {
                                    left = {
                                      name = "path";
                                      path = [
                                        {
                                          kind = "identifier";
                                          value = "notifications";
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
                                    value = "optional";
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
                      operator = "++";
                      right = {
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
                                      value = "path";
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
                                            value = "download-folder";
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
                                      value = "value";
                                    }
                                  ];
                                  type = "assignment";
                                  value = {
                                    name = "path";
                                    path = [
                                      {
                                        kind = "identifier";
                                        value = "downloadDirectory";
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
                            arguments = [
                              {
                                type = "group";
                                value = {
                                  left = {
                                    name = "path";
                                    path = [
                                      {
                                        kind = "identifier";
                                        value = "downloadDirectory";
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
                                  value = "optional";
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
                    operator = "++";
                    right = {
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
                                    value = "path";
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
                                          value = "zane-chat-model";
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
                                    value = "value";
                                  }
                                ];
                                type = "assignment";
                                value = {
                                  name = "path";
                                  path = [
                                    {
                                      kind = "identifier";
                                      value = "zane";
                                    }
                                    {
                                      kind = "identifier";
                                      value = "chat";
                                    }
                                    {
                                      kind = "identifier";
                                      value = "model";
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
                          arguments = [
                            {
                              type = "group";
                              value = {
                                left = {
                                  name = "path";
                                  path = [
                                    {
                                      kind = "identifier";
                                      value = "zane";
                                    }
                                    {
                                      kind = "identifier";
                                      value = "chat";
                                    }
                                    {
                                      kind = "identifier";
                                      value = "model";
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
                                value = "optional";
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
                  operator = "++";
                  right = {
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
                                  value = "path";
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
                                        value = "zane-chat-effort";
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
                                  value = "value";
                                }
                              ];
                              type = "assignment";
                              value = {
                                name = "path";
                                path = [
                                  {
                                    kind = "identifier";
                                    value = "zane";
                                  }
                                  {
                                    kind = "identifier";
                                    value = "chat";
                                  }
                                  {
                                    kind = "identifier";
                                    value = "reasoningEffort";
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
                        arguments = [
                          {
                            type = "group";
                            value = {
                              left = {
                                name = "path";
                                path = [
                                  {
                                    kind = "identifier";
                                    value = "zane";
                                  }
                                  {
                                    kind = "identifier";
                                    value = "chat";
                                  }
                                  {
                                    kind = "identifier";
                                    value = "reasoningEffort";
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
                              value = "optional";
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
                operator = "++";
                right = {
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
                                value = "path";
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
                                      value = "zane-work-model";
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
                                value = "value";
                              }
                            ];
                            type = "assignment";
                            value = {
                              name = "path";
                              path = [
                                {
                                  kind = "identifier";
                                  value = "zane";
                                }
                                {
                                  kind = "identifier";
                                  value = "work";
                                }
                                {
                                  kind = "identifier";
                                  value = "model";
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
                      arguments = [
                        {
                          type = "group";
                          value = {
                            left = {
                              name = "path";
                              path = [
                                {
                                  kind = "identifier";
                                  value = "zane";
                                }
                                {
                                  kind = "identifier";
                                  value = "work";
                                }
                                {
                                  kind = "identifier";
                                  value = "model";
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
                            value = "optional";
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
              operator = "++";
              right = {
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
                              value = "path";
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
                                    value = "zane-work-effort";
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
                              value = "value";
                            }
                          ];
                          type = "assignment";
                          value = {
                            name = "path";
                            path = [
                              {
                                kind = "identifier";
                                value = "zane";
                              }
                              {
                                kind = "identifier";
                                value = "work";
                              }
                              {
                                kind = "identifier";
                                value = "reasoningEffort";
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
                    arguments = [
                      {
                        type = "group";
                        value = {
                          left = {
                            name = "path";
                            path = [
                              {
                                kind = "identifier";
                                value = "zane";
                              }
                              {
                                kind = "identifier";
                                value = "work";
                              }
                              {
                                kind = "identifier";
                                value = "reasoningEffort";
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
                          value = "optional";
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
            operator = "++";
            right = {
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
                            value = "path";
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
                                  value = "zane-account-presence";
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
                            value = "value";
                          }
                        ];
                        type = "assignment";
                        value = {
                          name = "path";
                          path = [
                            {
                              kind = "identifier";
                              value = "zane";
                            }
                            {
                              kind = "identifier";
                              value = "showAccountPresence";
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
                  arguments = [
                    {
                      type = "group";
                      value = {
                        left = {
                          name = "path";
                          path = [
                            {
                              kind = "identifier";
                              value = "zane";
                            }
                            {
                              kind = "identifier";
                              value = "showAccountPresence";
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
                        value = "optional";
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
          operator = "++";
          right = {
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
                          value = "path";
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
                                value = "zane-auto-edit-access";
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
                          value = "value";
                        }
                      ];
                      type = "assignment";
                      value = {
                        name = "path";
                        path = [
                          {
                            kind = "identifier";
                            value = "zane";
                          }
                          {
                            kind = "identifier";
                            value = "automaticEditAccess";
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
                arguments = [
                  {
                    type = "group";
                    value = {
                      left = {
                        name = "path";
                        path = [
                          {
                            kind = "identifier";
                            value = "zane";
                          }
                          {
                            kind = "identifier";
                            value = "automaticEditAccess";
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
                      value = "optional";
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
                          value = "name";
                        }
                      ];
                      type = "assignment";
                      value = {
                        multiline = false;
                        parts = [
                          {
                            type = "text";
                            value = "Install and configure Select for Figma";
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
                            value = "Install and configure Select for Figma";
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
                            value = "Install native Select for the selected user scope. Apply only non-null preferences to its writable state file. Existing figma-gtk data is migrated before the first preference write.";
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
                                value = "programs";
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
                        items = [
                          {
                            name = "pkgs";
                            path = [
                              {
                                kind = "identifier";
                                value = "com";
                              }
                              {
                                kind = "identifier";
                                value = "neg-zero";
                              }
                              {
                                kind = "identifier";
                                value = "select-for-figma";
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
                          value = "home";
                        }
                        {
                          kind = "identifier";
                          value = "activation";
                        }
                        {
                          kind = "identifier";
                          value = "zenosSelectForFigmaPreferences";
                        }
                      ];
                      type = "assignment";
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
                                    value = "pkgs";
                                  }
                                ];
                                type = "assignment";
                                value = {
                                  name = "pkgs";
                                  path = [
                                    {
                                      kind = "identifier";
                                      value = "legacy";
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
                                    value = "application";
                                  }
                                ];
                                type = "assignment";
                                value = {
                                  multiline = false;
                                  parts = [
                                    {
                                      type = "text";
                                      value = "select-for-figma";
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
                                    value = "assignments";
                                  }
                                ];
                                type = "assignment";
                                value = {
                                  name = "v";
                                  path = [
                                    {
                                      kind = "identifier";
                                      value = "preferences";
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
                          name = "lib";
                          path = [
                            {
                              kind = "identifier";
                              value = "mkWritableProgramConfig";
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
                                          value = "downloadDirectory";
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
                                    arguments = [
                                      {
                                        name = "path";
                                        path = [
                                          {
                                            kind = "identifier";
                                            value = "downloadDirectory";
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
                                      value = "Select for Figma: downloadDirectory must be an absolute path.";
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
                                          value = "zane";
                                        }
                                        {
                                          kind = "identifier";
                                          value = "chat";
                                        }
                                        {
                                          kind = "identifier";
                                          value = "model";
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
                                    left = {
                                      arguments = [
                                        {
                                          name = "path";
                                          path = [
                                            {
                                              kind = "identifier";
                                              value = "zane";
                                            }
                                            {
                                              kind = "identifier";
                                              value = "chat";
                                            }
                                            {
                                              kind = "identifier";
                                              value = "model";
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
                                            value = "stringLength";
                                          }
                                        ];
                                        type = "variable";
                                      };
                                      type = "call";
                                    };
                                    operator = "<=";
                                    right = {
                                      kind = "integer";
                                      type = "literal";
                                      value = 200;
                                    };
                                    type = "binary";
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
                                      value = "Select for Figma: zane.chat.model must be at most 200 UTF-8 bytes.";
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
                                          value = "zane";
                                        }
                                        {
                                          kind = "identifier";
                                          value = "work";
                                        }
                                        {
                                          kind = "identifier";
                                          value = "model";
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
                                    left = {
                                      arguments = [
                                        {
                                          name = "path";
                                          path = [
                                            {
                                              kind = "identifier";
                                              value = "zane";
                                            }
                                            {
                                              kind = "identifier";
                                              value = "work";
                                            }
                                            {
                                              kind = "identifier";
                                              value = "model";
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
                                            value = "stringLength";
                                          }
                                        ];
                                        type = "variable";
                                      };
                                      type = "call";
                                    };
                                    operator = "<=";
                                    right = {
                                      kind = "integer";
                                      type = "literal";
                                      value = 200;
                                    };
                                    type = "binary";
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
                                      value = "Select for Figma: zane.work.model must be at most 200 UTF-8 bytes.";
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
                                          value = "zane";
                                        }
                                        {
                                          kind = "identifier";
                                          value = "chat";
                                        }
                                        {
                                          kind = "identifier";
                                          value = "reasoningEffort";
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
                                    left = {
                                      arguments = [
                                        {
                                          name = "path";
                                          path = [
                                            {
                                              kind = "identifier";
                                              value = "zane";
                                            }
                                            {
                                              kind = "identifier";
                                              value = "chat";
                                            }
                                            {
                                              kind = "identifier";
                                              value = "reasoningEffort";
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
                                            value = "stringLength";
                                          }
                                        ];
                                        type = "variable";
                                      };
                                      type = "call";
                                    };
                                    operator = "<=";
                                    right = {
                                      kind = "integer";
                                      type = "literal";
                                      value = 32;
                                    };
                                    type = "binary";
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
                                      value = "Select for Figma: zane.chat.reasoningEffort must be at most 32 UTF-8 bytes.";
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
                                          value = "zane";
                                        }
                                        {
                                          kind = "identifier";
                                          value = "work";
                                        }
                                        {
                                          kind = "identifier";
                                          value = "reasoningEffort";
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
                                    left = {
                                      arguments = [
                                        {
                                          name = "path";
                                          path = [
                                            {
                                              kind = "identifier";
                                              value = "zane";
                                            }
                                            {
                                              kind = "identifier";
                                              value = "work";
                                            }
                                            {
                                              kind = "identifier";
                                              value = "reasoningEffort";
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
                                            value = "stringLength";
                                          }
                                        ];
                                        type = "variable";
                                      };
                                      type = "call";
                                    };
                                    operator = "<=";
                                    right = {
                                      kind = "integer";
                                      type = "literal";
                                      value = 32;
                                    };
                                    type = "binary";
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
                                      value = "Select for Figma: zane.work.reasoningEffort must be at most 32 UTF-8 bytes.";
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
    (let preferences = (builtins.addErrorContext "_let preferences annotation mismatch: /nix/store/59qqzf108ga8h2qmsjizzsn2p7i889xx-zenpkgs-dsl-source/modules/programs/select-for-figma.zmdl:100:1" ((_zenType: _zenValue: let force = type: value: if type.name == "anything" then true else if type.name == "listOf" then builtins.all (force type.nestedTypes.elemType) value else if type.name == "attrsOf" then builtins.all (force type.nestedTypes.elemType) (builtins.attrValues value) else if type.name == "either" then force (if type.nestedTypes.left.check value then type.nestedTypes.left else type.nestedTypes.right) value else builtins.seq value true; in builtins.seq (force _zenType _zenValue) _zenValue) ((lib.types.listOf lib.types.attrs)) ((lib.evalModules { modules = [ { options.value = lib.mkOption { type = (lib.types.listOf lib.types.attrs); }; config.value = (((((((((((((((lib.optional ((cfg.appearance != null))) {
  path = [
    "appearance"
  ];
  value = cfg.appearance;
})) ++ (((lib.optional ((cfg.adwaitaEditorTheme != null))) {
  path = [
    "adwaita-editor"
  ];
  value = cfg.adwaitaEditorTheme;
}))) ++ (((lib.optional ((cfg.restoreOpenFiles != null))) {
  path = [
    "restore-session"
  ];
  value = cfg.restoreOpenFiles;
}))) ++ (((lib.optional ((cfg.tabSwitchingOrder != null))) {
  path = [
    "tab-switcher-mru"
  ];
  value = (cfg.tabSwitchingOrder == "recent");
}))) ++ (((lib.optional ((cfg.localFonts != null))) {
  path = [
    "local-fonts"
  ];
  value = cfg.localFonts;
}))) ++ (((lib.optional ((cfg.notifications != null))) {
  path = [
    "notifications"
  ];
  value = cfg.notifications;
}))) ++ (((lib.optional ((cfg.downloadDirectory != null))) {
  path = [
    "download-folder"
  ];
  value = cfg.downloadDirectory;
}))) ++ (((lib.optional ((cfg.zane.chat.model != null))) {
  path = [
    "zane-chat-model"
  ];
  value = cfg.zane.chat.model;
}))) ++ (((lib.optional ((cfg.zane.chat.reasoningEffort != null))) {
  path = [
    "zane-chat-effort"
  ];
  value = cfg.zane.chat.reasoningEffort;
}))) ++ (((lib.optional ((cfg.zane.work.model != null))) {
  path = [
    "zane-work-model"
  ];
  value = cfg.zane.work.model;
}))) ++ (((lib.optional ((cfg.zane.work.reasoningEffort != null))) {
  path = [
    "zane-work-effort"
  ];
  value = cfg.zane.work.reasoningEffort;
}))) ++ (((lib.optional ((cfg.zane.showAccountPresence != null))) {
  path = [
    "zane-account-presence"
  ];
  value = cfg.zane.showAccountPresence;
}))) ++ (((lib.optional ((cfg.zane.automaticEditAccess != null))) {
  path = [
    "zane-auto-edit-access"
  ];
  value = cfg.zane.automaticEditAccess;
}))); } ]; }).config.value))); in (lib.mkIf ((cfg.enable)) { home-manager.sharedModules = [ {
      home.packages = [
        pkgs.zenos.com.neg-zero.select-for-figma
      ];
      home.activation.zenosSelectForFigmaPreferences = (lib.mkWritableProgramConfig {
        pkgs = pkgs.zenos.legacy;
        application = "select-for-figma";
        assignments = preferences;
      });
      assertions = [
        {
          assertion = ((cfg.downloadDirectory == null) || ((lib.hasPrefix "/") cfg.downloadDirectory));
          message = "Select for Figma: downloadDirectory must be an absolute path.";
        }
        {
          assertion = ((cfg.zane.chat.model == null) || ((lib.stringLength cfg.zane.chat.model) <= 200));
          message = "Select for Figma: zane.chat.model must be at most 200 UTF-8 bytes.";
        }
        {
          assertion = ((cfg.zane.work.model == null) || ((lib.stringLength cfg.zane.work.model) <= 200));
          message = "Select for Figma: zane.work.model must be at most 200 UTF-8 bytes.";
        }
        {
          assertion = ((cfg.zane.chat.reasoningEffort == null) || ((lib.stringLength cfg.zane.chat.reasoningEffort) <= 32));
          message = "Select for Figma: zane.chat.reasoningEffort must be at most 32 UTF-8 bytes.";
        }
        {
          assertion = ((cfg.zane.work.reasoningEffort == null) || ((lib.stringLength cfg.zane.work.reasoningEffort) <= 32));
          message = "Select for Figma: zane.work.reasoningEffort must be at most 32 UTF-8 bytes.";
        }
      ];
    } ]; }))
  ];
}
