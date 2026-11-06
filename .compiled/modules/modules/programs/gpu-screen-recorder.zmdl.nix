{ config, lib, pkgs, maintainers ? lib.maintainers, licenses ? lib.licenses, ... }:
let
  cfg = config.zenos.programs.gpu-screen-recorder;
  name = "gpu-screen-recorder";
  preferences = (builtins.addErrorContext "_let preferences annotation mismatch: /nix/store/59qqzf108ga8h2qmsjizzsn2p7i889xx-zenpkgs-dsl-source/modules/programs/gpu-screen-recorder.zmdl:30:1" ((_zenType: _zenValue: let force = type: value: if type.name == "anything" then true else if type.name == "listOf" then builtins.all (force type.nestedTypes.elemType) value else if type.name == "attrsOf" then builtins.all (force type.nestedTypes.elemType) (builtins.attrValues value) else if type.name == "either" then force (if type.nestedTypes.left.check value then type.nestedTypes.left else type.nestedTypes.right) value else builtins.seq value true; in builtins.seq (force _zenType _zenValue) _zenValue) ((lib.types.listOf lib.types.attrs)) ((lib.evalModules { modules = [ { options.value = lib.mkOption { type = (lib.types.listOf lib.types.attrs); }; config.value = ([
    {
      path = [
        "main"
        "hotkeys_enable_option"
      ];
      value = "disable_hotkeys";
    }
    {
      path = [
        "main"
        "joystick_hotkeys_enable_option"
      ];
      value = "disable_hotkeys";
    }
    {
      path = [
        "replay"
        "turn_on_replay_automatically_mode"
      ];
      value = (if cfg.autoStart then "turn_on_at_system_startup" else "dont_turn_on_automatically");
    }
    {
      path = [
        "replay"
        "time"
      ];
      value = cfg.replaySeconds;
    }
    {
      path = [
        "replay"
        "save_directory"
      ];
      value = cfg.clipsDirectory;
    }
    {
      path = [
        "record"
        "save_directory"
      ];
      value = cfg.recordingsDirectory;
    }
  ] ++ (((lib.concatMap ((mode: [
    {
      path = [
        mode
        "record_options"
        "record_area_option"
      ];
      value = cfg.monitor;
    }
    {
      path = [
        mode
        "record_options"
        "fps"
      ];
      value = cfg.frameRate;
    }
    {
      path = [
        mode
        "record_options"
        "codec"
      ];
      value = "h264";
    }
    {
      path = [
        mode
        "record_options"
        "audio_codec"
      ];
      value = "aac";
    }
    {
      path = [
        mode
        "record_options"
        "video_quality"
      ];
      value = "high";
    }
    {
      path = [
        mode
        "record_options"
        "audio_track_item"
      ];
      value = [
        {
          name = "";
          audio_inputs = [
            cfg.audioDevice
          ];
          application_audio_invert = false;
        }
      ];
    }
  ]))) [
    "record"
    "replay"
  ]))); } ]; }).config.value)));
in
{
  options.zenos.programs.gpu-screen-recorder = lib.mkOption { type = (lib.types.submodule ({ ... }: (let preferences = (builtins.addErrorContext "_let preferences annotation mismatch: /nix/store/59qqzf108ga8h2qmsjizzsn2p7i889xx-zenpkgs-dsl-source/modules/programs/gpu-screen-recorder.zmdl:30:1" ((_zenType: _zenValue: let force = type: value: if type.name == "anything" then true else if type.name == "listOf" then builtins.all (force type.nestedTypes.elemType) value else if type.name == "attrsOf" then builtins.all (force type.nestedTypes.elemType) (builtins.attrValues value) else if type.name == "either" then force (if type.nestedTypes.left.check value then type.nestedTypes.left else type.nestedTypes.right) value else builtins.seq value true; in builtins.seq (force _zenType _zenValue) _zenValue) ((lib.types.listOf lib.types.attrs)) ((lib.evalModules { modules = [ { options.value = lib.mkOption { type = (lib.types.listOf lib.types.attrs); }; config.value = ([
        {
          path = [
            "main"
            "hotkeys_enable_option"
          ];
          value = "disable_hotkeys";
        }
        {
          path = [
            "main"
            "joystick_hotkeys_enable_option"
          ];
          value = "disable_hotkeys";
        }
        {
          path = [
            "replay"
            "turn_on_replay_automatically_mode"
          ];
          value = (if cfg.autoStart then "turn_on_at_system_startup" else "dont_turn_on_automatically");
        }
        {
          path = [
            "replay"
            "time"
          ];
          value = cfg.replaySeconds;
        }
        {
          path = [
            "replay"
            "save_directory"
          ];
          value = cfg.clipsDirectory;
        }
        {
          path = [
            "record"
            "save_directory"
          ];
          value = cfg.recordingsDirectory;
        }
      ] ++ (((lib.concatMap ((mode: [
        {
          path = [
            mode
            "record_options"
            "record_area_option"
          ];
          value = cfg.monitor;
        }
        {
          path = [
            mode
            "record_options"
            "fps"
          ];
          value = cfg.frameRate;
        }
        {
          path = [
            mode
            "record_options"
            "codec"
          ];
          value = "h264";
        }
        {
          path = [
            mode
            "record_options"
            "audio_codec"
          ];
          value = "aac";
        }
        {
          path = [
            mode
            "record_options"
            "video_quality"
          ];
          value = "high";
        }
        {
          path = [
            mode
            "record_options"
            "audio_track_item"
          ];
          value = [
            {
              name = "";
              audio_inputs = [
                cfg.audioDevice
              ];
              application_audio_invert = false;
            }
          ];
        }
      ]))) [
        "record"
        "replay"
      ]))); } ]; }).config.value))); in { options = { audioDevice = lib.mkOption { type = lib.types.str; default = "default_output"; description = "Audio source; default is system output, without microphone."; }; autoStart = lib.mkOption { type = lib.types.bool; default = false; description = "Start the replay buffer with the graphical session."; }; clipShortcut = lib.mkOption { type = lib.types.str; default = ""; description = "GNOME shortcut to save replay."; }; clipsDirectory = lib.mkOption { type = lib.types.str; default = "%h/Videos/Clips"; description = "Clip output directory; supports systemd user specifiers."; }; enable = lib.mkOption { type = lib.types.bool; default = false; description = "Creates the user service and selected GNOME shortcuts. Capture starts at login only when autoStart is true."; }; frameRate = lib.mkOption { type = lib.types.int; default = 60; description = "Maximum frames per second."; }; hudShortcut = lib.mkOption { type = lib.types.str; default = ""; description = "Toggle the NVIDIA-style overlay using the desktop shortcut service."; }; monitor = lib.mkOption { type = lib.types.str; default = "focused_monitor"; description = "Capture target accepted by the overlay, such as focused_monitor or a connector name."; }; recordShortcut = lib.mkOption { type = lib.types.str; default = ""; description = "GNOME shortcut to toggle regular recording."; }; recordingsDirectory = lib.mkOption { type = lib.types.str; default = "%h/Videos/Recordings"; description = "Recording output directory."; }; replaySeconds = lib.mkOption { type = lib.types.int; default = 60; description = "Replay duration in seconds."; }; systemSupport = lib.mkOption { type = lib.types.bool; default = false; description = "Install system KMS capture support (system scope only)."; }; }; }))); default = { }; };
  config = lib.mkMerge [
    { _module.args.zenlang.descriptors.programs.gpu-screen-recorder = {
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
            value = "System support grants the standard NixOS KMS helper capability. User enable installs the GUI and replay service; capture starts only when autoStart is selected or the service is started manually.";
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
            value = "GPU Screen Recorder";
          }
        ];
        type = "string";
      };
      summary = {
        multiline = false;
        parts = [
          {
            type = "text";
            value = "GPU recording, replay buffer and GNOME shortcuts";
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
                value = "video";
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
    moduleIdentity = "zenos.programs.gpu-screen-recorder";
    modulePath = [
      "programs"
      "gpu-screen-recorder"
    ];
    nodeMetadata = [
      {
        metadata = {
          description = {
            multiline = true;
            parts = [
              {
                type = "text";
                value = "System support grants the standard NixOS KMS helper capability. User enable installs the GUI and replay service; capture starts only when autoStart is selected or the service is started manually.";
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
                value = "GPU Screen Recorder";
              }
            ];
            type = "string";
          };
          summary = {
            multiline = false;
            parts = [
              {
                type = "text";
                value = "GPU recording, replay buffer and GNOME shortcuts";
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
                    value = "video";
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
            kind = "false";
            type = "literal";
            value = false;
          };
          description = {
            multiline = true;
            parts = [
              {
                type = "text";
                value = "Install system KMS capture support (system scope only).";
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
                value = "Install system KMS capture support (system scope only)";
              }
            ];
            type = "string";
          };
          summary = {
            multiline = false;
            parts = [
              {
                type = "text";
                value = "Install system KMS capture support (system scope only)";
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
                    value = "video";
                  }
                ];
                type = "string";
              }
            ];
            type = "list";
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
          "systemSupport"
        ];
      }
      {
        metadata = {
          default = {
            kind = "false";
            type = "literal";
            value = false;
          };
          description = {
            multiline = true;
            parts = [
              {
                type = "text";
                value = "Start the replay buffer with the graphical session.";
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
                value = "Start the replay buffer with the graphical session";
              }
            ];
            type = "string";
          };
          summary = {
            multiline = false;
            parts = [
              {
                type = "text";
                value = "Start the replay buffer with the graphical session";
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
                    value = "video";
                  }
                ];
                type = "string";
              }
            ];
            type = "list";
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
      {
        metadata = {
          default = {
            kind = "integer";
            type = "literal";
            value = 60;
          };
          description = {
            multiline = true;
            parts = [
              {
                type = "text";
                value = "Replay duration in seconds.";
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
                value = "Replay duration in seconds";
              }
            ];
            type = "string";
          };
          summary = {
            multiline = false;
            parts = [
              {
                type = "text";
                value = "Replay duration in seconds";
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
                    value = "video";
                  }
                ];
                type = "string";
              }
            ];
            type = "list";
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
            value = "1.0.0Nb";
          };
        };
        path = [
          "replaySeconds"
        ];
      }
      {
        metadata = {
          default = {
            kind = "integer";
            type = "literal";
            value = 60;
          };
          description = {
            multiline = true;
            parts = [
              {
                type = "text";
                value = "Maximum frames per second.";
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
                value = "Maximum frames per second";
              }
            ];
            type = "string";
          };
          summary = {
            multiline = false;
            parts = [
              {
                type = "text";
                value = "Maximum frames per second";
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
                    value = "video";
                  }
                ];
                type = "string";
              }
            ];
            type = "list";
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
            value = "1.0.0Nb";
          };
        };
        path = [
          "frameRate"
        ];
      }
      {
        metadata = {
          default = {
            multiline = false;
            parts = [
              {
                type = "text";
                value = "focused_monitor";
              }
            ];
            type = "string";
          };
          description = {
            multiline = true;
            parts = [
              {
                type = "text";
                value = "Capture target accepted by the overlay, such as focused_monitor or a connector name.";
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
                value = "Capture target accepted by the overlay, such as focused_monitor or a connector name";
              }
            ];
            type = "string";
          };
          summary = {
            multiline = false;
            parts = [
              {
                type = "text";
                value = "Capture target accepted by the overlay, such as focused_monitor or a connector name";
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
                    value = "video";
                  }
                ];
                type = "string";
              }
            ];
            type = "list";
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
            value = "1.0.0Nb";
          };
        };
        path = [
          "monitor"
        ];
      }
      {
        metadata = {
          default = {
            multiline = false;
            parts = [
              {
                type = "text";
                value = "default_output";
              }
            ];
            type = "string";
          };
          description = {
            multiline = true;
            parts = [
              {
                type = "text";
                value = "Audio source; default is system output, without microphone.";
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
                value = "Audio source; default is system output, without microphone";
              }
            ];
            type = "string";
          };
          summary = {
            multiline = false;
            parts = [
              {
                type = "text";
                value = "Audio source; default is system output, without microphone";
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
                    value = "video";
                  }
                ];
                type = "string";
              }
            ];
            type = "list";
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
            value = "1.0.0Nb";
          };
        };
        path = [
          "audioDevice"
        ];
      }
      {
        metadata = {
          default = {
            multiline = false;
            parts = [
              {
                type = "text";
                value = "%h/Videos/Clips";
              }
            ];
            type = "string";
          };
          description = {
            multiline = true;
            parts = [
              {
                type = "text";
                value = "Clip output directory; supports systemd user specifiers.";
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
                value = "Clip output directory; supports systemd user specifiers";
              }
            ];
            type = "string";
          };
          summary = {
            multiline = false;
            parts = [
              {
                type = "text";
                value = "Clip output directory; supports systemd user specifiers";
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
                    value = "video";
                  }
                ];
                type = "string";
              }
            ];
            type = "list";
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
            value = "1.0.0Nb";
          };
        };
        path = [
          "clipsDirectory"
        ];
      }
      {
        metadata = {
          default = {
            multiline = false;
            parts = [
              {
                type = "text";
                value = "%h/Videos/Recordings";
              }
            ];
            type = "string";
          };
          description = {
            multiline = true;
            parts = [
              {
                type = "text";
                value = "Recording output directory.";
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
                value = "Recording output directory";
              }
            ];
            type = "string";
          };
          summary = {
            multiline = false;
            parts = [
              {
                type = "text";
                value = "Recording output directory";
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
                    value = "video";
                  }
                ];
                type = "string";
              }
            ];
            type = "list";
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
            value = "1.0.0Nb";
          };
        };
        path = [
          "recordingsDirectory"
        ];
      }
      {
        metadata = {
          default = {
            multiline = false;
            parts = [ ];
            type = "string";
          };
          description = {
            multiline = true;
            parts = [
              {
                type = "text";
                value = "GNOME shortcut to toggle regular recording.";
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
                value = "GNOME shortcut to toggle regular recording";
              }
            ];
            type = "string";
          };
          summary = {
            multiline = false;
            parts = [
              {
                type = "text";
                value = "GNOME shortcut to toggle regular recording";
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
                    value = "video";
                  }
                ];
                type = "string";
              }
            ];
            type = "list";
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
            value = "1.0.0Nb";
          };
        };
        path = [
          "recordShortcut"
        ];
      }
      {
        metadata = {
          default = {
            multiline = false;
            parts = [ ];
            type = "string";
          };
          description = {
            multiline = true;
            parts = [
              {
                type = "text";
                value = "GNOME shortcut to save replay.";
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
                value = "GNOME shortcut to save replay";
              }
            ];
            type = "string";
          };
          summary = {
            multiline = false;
            parts = [
              {
                type = "text";
                value = "GNOME shortcut to save replay";
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
                    value = "video";
                  }
                ];
                type = "string";
              }
            ];
            type = "list";
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
            value = "1.0.0Nb";
          };
        };
        path = [
          "clipShortcut"
        ];
      }
      {
        metadata = {
          default = {
            multiline = false;
            parts = [ ];
            type = "string";
          };
          description = {
            multiline = true;
            parts = [
              {
                type = "text";
                value = "Toggle the NVIDIA-style overlay using the desktop shortcut service.";
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
                value = "Show recording HUD";
              }
            ];
            type = "string";
          };
          summary = {
            multiline = false;
            parts = [
              {
                type = "text";
                value = "GNOME shortcut to show or hide the recording overlay";
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
                    value = "video";
                  }
                ];
                type = "string";
              }
            ];
            type = "list";
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
            value = "1.0.0Nb";
          };
        };
        path = [
          "hudShortcut"
        ];
      }
      {
        metadata = {
          description = {
            multiline = true;
            parts = [
              {
                type = "text";
                value = "Creates the user service and selected GNOME shortcuts. Capture starts at login only when autoStart is true.";
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
                value = "Enable recorder";
              }
            ];
            type = "string";
          };
          summary = {
            multiline = false;
            parts = [
              {
                type = "text";
                value = "Install the recorder and configure its replay service";
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
                    value = "video";
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
                    value = "GPU Screen Recorder";
                  }
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
                  {
                    multiline = false;
                    parts = [
                      {
                        type = "text";
                        value = "video";
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
                    value = "GPU recording, replay buffer and GNOME shortcuts";
                  }
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
                    value = "System support grants the standard NixOS KMS helper capability. User enable installs the GUI and replay service; capture starts only when autoStart is selected or the service is started manually.";
                  }
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
            value = "systemSupport";
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
                          value = "Install system KMS capture support (system scope only)";
                        }
                      ];
                      type = "string";
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
                          value = "Install system KMS capture support (system scope only)";
                        }
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
                          value = "Install system KMS capture support (system scope only).";
                        }
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
                        {
                          multiline = false;
                          parts = [
                            {
                              type = "text";
                              value = "video";
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
                        value = "programs";
                      }
                      {
                        kind = "identifier";
                        value = "gpu-screen-recorder";
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
                        arguments = [
                          {
                            name = "path";
                            path = [
                              {
                                kind = "identifier";
                                value = "systemSupport";
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
                        value = "gpu-screen-recorder";
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
                              value = "video";
                            }
                            {
                              kind = "identifier";
                              value = "gpu-screen-recorder";
                            }
                          ];
                          type = "variable";
                        }
                      ];
                      callee = {
                        arguments = [
                          {
                            name = "path";
                            path = [
                              {
                                kind = "identifier";
                                value = "systemSupport";
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
                          value = "Start the replay buffer with the graphical session";
                        }
                      ];
                      type = "string";
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
                          value = "Start the replay buffer with the graphical session";
                        }
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
                          value = "Start the replay buffer with the graphical session.";
                        }
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
                        {
                          multiline = false;
                          parts = [
                            {
                              type = "text";
                              value = "video";
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
            value = "replaySeconds";
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
                      value = 60;
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
                          value = "Replay duration in seconds";
                        }
                      ];
                      type = "string";
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
                          value = "Replay duration in seconds";
                        }
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
                          value = "Replay duration in seconds.";
                        }
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
                        {
                          multiline = false;
                          parts = [
                            {
                              type = "text";
                              value = "video";
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
            value = "frameRate";
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
                      value = 60;
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
                          value = "Maximum frames per second";
                        }
                      ];
                      type = "string";
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
                          value = "Maximum frames per second";
                        }
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
                          value = "Maximum frames per second.";
                        }
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
                        {
                          multiline = false;
                          parts = [
                            {
                              type = "text";
                              value = "video";
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
            value = "monitor";
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
                          value = "focused_monitor";
                        }
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
                          value = "Capture target accepted by the overlay, such as focused_monitor or a connector name";
                        }
                      ];
                      type = "string";
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
                          value = "Capture target accepted by the overlay, such as focused_monitor or a connector name";
                        }
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
                          value = "Capture target accepted by the overlay, such as focused_monitor or a connector name.";
                        }
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
                        {
                          multiline = false;
                          parts = [
                            {
                              type = "text";
                              value = "video";
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
            value = "audioDevice";
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
                          value = "default_output";
                        }
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
                          value = "Audio source; default is system output, without microphone";
                        }
                      ];
                      type = "string";
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
                          value = "Audio source; default is system output, without microphone";
                        }
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
                          value = "Audio source; default is system output, without microphone.";
                        }
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
                        {
                          multiline = false;
                          parts = [
                            {
                              type = "text";
                              value = "video";
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
            value = "clipsDirectory";
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
                          value = "%h/Videos/Clips";
                        }
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
                          value = "Clip output directory; supports systemd user specifiers";
                        }
                      ];
                      type = "string";
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
                          value = "Clip output directory; supports systemd user specifiers";
                        }
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
                          value = "Clip output directory; supports systemd user specifiers.";
                        }
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
                        {
                          multiline = false;
                          parts = [
                            {
                              type = "text";
                              value = "video";
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
            value = "recordingsDirectory";
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
                          value = "%h/Videos/Recordings";
                        }
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
                          value = "Recording output directory";
                        }
                      ];
                      type = "string";
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
                          value = "Recording output directory";
                        }
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
                          value = "Recording output directory.";
                        }
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
                        {
                          multiline = false;
                          parts = [
                            {
                              type = "text";
                              value = "video";
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
            value = "recordShortcut";
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
                          value = "GNOME shortcut to toggle regular recording";
                        }
                      ];
                      type = "string";
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
                          value = "GNOME shortcut to toggle regular recording";
                        }
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
                          value = "GNOME shortcut to toggle regular recording.";
                        }
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
                        {
                          multiline = false;
                          parts = [
                            {
                              type = "text";
                              value = "video";
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
            value = "clipShortcut";
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
                          value = "GNOME shortcut to save replay";
                        }
                      ];
                      type = "string";
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
                          value = "GNOME shortcut to save replay";
                        }
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
                          value = "GNOME shortcut to save replay.";
                        }
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
                        {
                          multiline = false;
                          parts = [
                            {
                              type = "text";
                              value = "video";
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
            value = "hudShortcut";
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
                          value = "GNOME shortcut to show or hide the recording overlay";
                        }
                      ];
                      type = "string";
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
                          value = "Show recording HUD";
                        }
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
                          value = "Toggle the NVIDIA-style overlay using the desktop shortcut service.";
                        }
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
                        {
                          multiline = false;
                          parts = [
                            {
                              type = "text";
                              value = "video";
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
            items = [
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
                              value = "main";
                            }
                          ];
                          type = "string";
                        }
                        {
                          multiline = false;
                          parts = [
                            {
                              type = "text";
                              value = "hotkeys_enable_option";
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
                      multiline = false;
                      parts = [
                        {
                          type = "text";
                          value = "disable_hotkeys";
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
                              value = "main";
                            }
                          ];
                          type = "string";
                        }
                        {
                          multiline = false;
                          parts = [
                            {
                              type = "text";
                              value = "joystick_hotkeys_enable_option";
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
                      multiline = false;
                      parts = [
                        {
                          type = "text";
                          value = "disable_hotkeys";
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
                              value = "replay";
                            }
                          ];
                          type = "string";
                        }
                        {
                          multiline = false;
                          parts = [
                            {
                              type = "text";
                              value = "turn_on_replay_automatically_mode";
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
                        multiline = false;
                        parts = [
                          {
                            type = "text";
                            value = "dont_turn_on_automatically";
                          }
                        ];
                        type = "string";
                      };
                      "then" = {
                        multiline = false;
                        parts = [
                          {
                            type = "text";
                            value = "turn_on_at_system_startup";
                          }
                        ];
                        type = "string";
                      };
                      type = "if";
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
                              value = "replay";
                            }
                          ];
                          type = "string";
                        }
                        {
                          multiline = false;
                          parts = [
                            {
                              type = "text";
                              value = "time";
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
                          value = "replaySeconds";
                        }
                      ];
                      type = "variable";
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
                              value = "replay";
                            }
                          ];
                          type = "string";
                        }
                        {
                          multiline = false;
                          parts = [
                            {
                              type = "text";
                              value = "save_directory";
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
                          value = "clipsDirectory";
                        }
                      ];
                      type = "variable";
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
                              value = "record";
                            }
                          ];
                          type = "string";
                        }
                        {
                          multiline = false;
                          parts = [
                            {
                              type = "text";
                              value = "save_directory";
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
                          value = "recordingsDirectory";
                        }
                      ];
                      type = "variable";
                    };
                  }
                ];
                type = "attr-set";
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
                          value = "record";
                        }
                      ];
                      type = "string";
                    }
                    {
                      multiline = false;
                      parts = [
                        {
                          type = "text";
                          value = "replay";
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
                        items = [
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
                                      path = [
                                        {
                                          kind = "identifier";
                                          value = "mode";
                                        }
                                      ];
                                      type = "reference";
                                    }
                                    {
                                      multiline = false;
                                      parts = [
                                        {
                                          type = "text";
                                          value = "record_options";
                                        }
                                      ];
                                      type = "string";
                                    }
                                    {
                                      multiline = false;
                                      parts = [
                                        {
                                          type = "text";
                                          value = "record_area_option";
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
                                      value = "monitor";
                                    }
                                  ];
                                  type = "variable";
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
                                    value = "path";
                                  }
                                ];
                                type = "assignment";
                                value = {
                                  items = [
                                    {
                                      path = [
                                        {
                                          kind = "identifier";
                                          value = "mode";
                                        }
                                      ];
                                      type = "reference";
                                    }
                                    {
                                      multiline = false;
                                      parts = [
                                        {
                                          type = "text";
                                          value = "record_options";
                                        }
                                      ];
                                      type = "string";
                                    }
                                    {
                                      multiline = false;
                                      parts = [
                                        {
                                          type = "text";
                                          value = "fps";
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
                                      value = "frameRate";
                                    }
                                  ];
                                  type = "variable";
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
                                    value = "path";
                                  }
                                ];
                                type = "assignment";
                                value = {
                                  items = [
                                    {
                                      path = [
                                        {
                                          kind = "identifier";
                                          value = "mode";
                                        }
                                      ];
                                      type = "reference";
                                    }
                                    {
                                      multiline = false;
                                      parts = [
                                        {
                                          type = "text";
                                          value = "record_options";
                                        }
                                      ];
                                      type = "string";
                                    }
                                    {
                                      multiline = false;
                                      parts = [
                                        {
                                          type = "text";
                                          value = "codec";
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
                                  multiline = false;
                                  parts = [
                                    {
                                      type = "text";
                                      value = "h264";
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
                                    value = "path";
                                  }
                                ];
                                type = "assignment";
                                value = {
                                  items = [
                                    {
                                      path = [
                                        {
                                          kind = "identifier";
                                          value = "mode";
                                        }
                                      ];
                                      type = "reference";
                                    }
                                    {
                                      multiline = false;
                                      parts = [
                                        {
                                          type = "text";
                                          value = "record_options";
                                        }
                                      ];
                                      type = "string";
                                    }
                                    {
                                      multiline = false;
                                      parts = [
                                        {
                                          type = "text";
                                          value = "audio_codec";
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
                                  multiline = false;
                                  parts = [
                                    {
                                      type = "text";
                                      value = "aac";
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
                                    value = "path";
                                  }
                                ];
                                type = "assignment";
                                value = {
                                  items = [
                                    {
                                      path = [
                                        {
                                          kind = "identifier";
                                          value = "mode";
                                        }
                                      ];
                                      type = "reference";
                                    }
                                    {
                                      multiline = false;
                                      parts = [
                                        {
                                          type = "text";
                                          value = "record_options";
                                        }
                                      ];
                                      type = "string";
                                    }
                                    {
                                      multiline = false;
                                      parts = [
                                        {
                                          type = "text";
                                          value = "video_quality";
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
                                  multiline = false;
                                  parts = [
                                    {
                                      type = "text";
                                      value = "high";
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
                                    value = "path";
                                  }
                                ];
                                type = "assignment";
                                value = {
                                  items = [
                                    {
                                      path = [
                                        {
                                          kind = "identifier";
                                          value = "mode";
                                        }
                                      ];
                                      type = "reference";
                                    }
                                    {
                                      multiline = false;
                                      parts = [
                                        {
                                          type = "text";
                                          value = "record_options";
                                        }
                                      ];
                                      type = "string";
                                    }
                                    {
                                      multiline = false;
                                      parts = [
                                        {
                                          type = "text";
                                          value = "audio_track_item";
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
                                  items = [
                                    {
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
                                            parts = [ ];
                                            type = "string";
                                          };
                                        }
                                        {
                                          operator = "=";
                                          target = [
                                            {
                                              kind = "identifier";
                                              value = "audio_inputs";
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
                                                    value = "audioDevice";
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
                                              value = "application_audio_invert";
                                            }
                                          ];
                                          type = "assignment";
                                          value = {
                                            kind = "false";
                                            type = "literal";
                                            value = false;
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
                          }
                        ];
                        type = "list";
                      };
                      form = "identifier";
                      parameters = [
                        {
                          default = null;
                          name = "mode";
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
                      value = "concatMap";
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
                            value = "Enable recorder";
                          }
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
                            value = "Install the recorder and configure its replay service";
                          }
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
                            value = "Creates the user service and selected GNOME shortcuts. Capture starts at login only when autoStart is true.";
                          }
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
                          {
                            multiline = false;
                            parts = [
                              {
                                type = "text";
                                value = "video";
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
                                value = "byCategories";
                              }
                              {
                                kind = "identifier";
                                value = "apps";
                              }
                              {
                                kind = "identifier";
                                value = "video";
                              }
                              {
                                kind = "identifier";
                                value = "gpu-screen-recorder-ui";
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
                          value = "zenosScreenRecorderPreferences";
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
                                      value = "gpu-screen-recorder-ui";
                                    }
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
                          value = "zenos-screen-recorder";
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
                                        value = "GPU Screen Recorder overlay, replay and recording";
                                      }
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
                                            value = "graphical-session.target";
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
                                      value = "ExecStartPre";
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
                                                expression = {
                                                  name = "pkgs";
                                                  path = [
                                                    {
                                                      kind = "identifier";
                                                      value = "legacy";
                                                    }
                                                    {
                                                      kind = "identifier";
                                                      value = "coreutils";
                                                    }
                                                  ];
                                                  type = "variable";
                                                };
                                                type = "interpolation";
                                              }
                                              {
                                                type = "text";
                                                value = "/bin/mkdir";
                                              }
                                            ];
                                            type = "string";
                                          }
                                          {
                                            multiline = false;
                                            parts = [
                                              {
                                                type = "text";
                                                value = "-p";
                                              }
                                            ];
                                            type = "string";
                                          }
                                          {
                                            name = "path";
                                            path = [
                                              {
                                                kind = "identifier";
                                                value = "clipsDirectory";
                                              }
                                            ];
                                            type = "variable";
                                          }
                                          {
                                            name = "path";
                                            path = [
                                              {
                                                kind = "identifier";
                                                value = "recordingsDirectory";
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
                                          value = "escapeShellArgs";
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
                                      value = "ExecStart";
                                    }
                                  ];
                                  type = "assignment";
                                  value = {
                                    multiline = false;
                                    parts = [
                                      {
                                        expression = {
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
                                              value = "video";
                                            }
                                            {
                                              kind = "identifier";
                                              value = "gpu-screen-recorder-ui";
                                            }
                                          ];
                                          type = "variable";
                                        };
                                        type = "interpolation";
                                      }
                                      {
                                        type = "text";
                                        value = "/bin/gsr-ui launch-hide";
                                      }
                                    ];
                                    type = "string";
                                  };
                                }
                                {
                                  operator = "=";
                                  target = [
                                    {
                                      kind = "identifier";
                                      value = "KillSignal";
                                    }
                                  ];
                                  type = "assignment";
                                  value = {
                                    multiline = false;
                                    parts = [
                                      {
                                        type = "text";
                                        value = "SIGINT";
                                      }
                                    ];
                                    type = "string";
                                  };
                                }
                                {
                                  operator = "=";
                                  target = [
                                    {
                                      kind = "identifier";
                                      value = "TimeoutStopSec";
                                    }
                                  ];
                                  type = "assignment";
                                  value = {
                                    kind = "integer";
                                    type = "literal";
                                    value = 30;
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
                                    kind = "integer";
                                    type = "literal";
                                    value = 5;
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
                                      recursive = false;
                                      statements = [
                                        {
                                          operator = "=";
                                          target = [
                                            {
                                              kind = "string";
                                              value = "org/gnome/shell/extensions/forge/keybindings";
                                            }
                                            {
                                              kind = "identifier";
                                              value = "workspace-active-tile-toggle";
                                            }
                                          ];
                                          type = "assignment";
                                          value = {
                                            arguments = [
                                              {
                                                items = [
                                                  {
                                                    multiline = false;
                                                    parts = [ ];
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
                                    }
                                  ];
                                  callee = {
                                    arguments = [
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
                                                      value = "<Shift><Super>w";
                                                    }
                                                  ];
                                                  type = "string";
                                                }
                                                {
                                                  multiline = false;
                                                  parts = [
                                                    {
                                                      type = "text";
                                                      value = "<Super><Shift>w";
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
                                                name = "path";
                                                path = [
                                                  {
                                                    kind = "identifier";
                                                    value = "clipShortcut";
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
                                                  value = "elem";
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
                                recursive = false;
                                statements = [
                                  {
                                    operator = "=";
                                    target = [
                                      {
                                        kind = "string";
                                        value = "org/gnome/settings-daemon/plugins/media-keys";
                                      }
                                      {
                                        kind = "identifier";
                                        value = "custom-keybindings";
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
                                                  default = {
                                                    items = [ ];
                                                    type = "list";
                                                  };
                                                  type = "default";
                                                  value = {
                                                    name = "cfg";
                                                    path = [
                                                      {
                                                        kind = "identifier";
                                                        value = "legacy";
                                                      }
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
                                                        value = "profiles";
                                                      }
                                                      {
                                                        kind = "identifier";
                                                        value = "user";
                                                      }
                                                      {
                                                        kind = "identifier";
                                                        value = "databases";
                                                      }
                                                    ];
                                                    type = "variable";
                                                  };
                                                };
                                              }
                                            ];
                                            callee = {
                                              arguments = [
                                                {
                                                  type = "group";
                                                  value = {
                                                    body = {
                                                      default = {
                                                        items = [ ];
                                                        type = "list";
                                                      };
                                                      type = "default";
                                                      value = {
                                                        path = [
                                                          {
                                                            kind = "identifier";
                                                            value = "database";
                                                          }
                                                          {
                                                            kind = "identifier";
                                                            value = "settings";
                                                          }
                                                          {
                                                            kind = "string";
                                                            value = "org/gnome/settings-daemon/plugins/media-keys";
                                                          }
                                                          {
                                                            kind = "identifier";
                                                            value = "custom-keybindings";
                                                          }
                                                        ];
                                                        type = "reference";
                                                      };
                                                    };
                                                    form = "identifier";
                                                    parameters = [
                                                      {
                                                        default = null;
                                                        name = "database";
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
                                                    value = "concatMap";
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
                                                left = {
                                                  left = {
                                                    name = "path";
                                                    path = [
                                                      {
                                                        kind = "identifier";
                                                        value = "recordShortcut";
                                                      }
                                                    ];
                                                    type = "variable";
                                                  };
                                                  operator = "!=";
                                                  right = {
                                                    multiline = false;
                                                    parts = [ ];
                                                    type = "string";
                                                  };
                                                  type = "binary";
                                                };
                                                operator = "||";
                                                right = {
                                                  left = {
                                                    name = "path";
                                                    path = [
                                                      {
                                                        kind = "identifier";
                                                        value = "clipShortcut";
                                                      }
                                                    ];
                                                    type = "variable";
                                                  };
                                                  operator = "!=";
                                                  right = {
                                                    multiline = false;
                                                    parts = [ ];
                                                    type = "string";
                                                  };
                                                  type = "binary";
                                                };
                                                type = "binary";
                                              };
                                              operator = "||";
                                              right = {
                                                left = {
                                                  name = "path";
                                                  path = [
                                                    {
                                                      kind = "identifier";
                                                      value = "hudShortcut";
                                                    }
                                                  ];
                                                  type = "variable";
                                                };
                                                operator = "!=";
                                                right = {
                                                  multiline = false;
                                                  parts = [ ];
                                                  type = "string";
                                                };
                                                type = "binary";
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
                              }
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
                                              kind = "string";
                                              value = "org/gnome/settings-daemon/plugins/media-keys";
                                            }
                                            {
                                              kind = "identifier";
                                              value = "custom-keybindings";
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
                                                    value = "/org/gnome/settings-daemon/plugins/media-keys/custom-keybindings/gsr-record/";
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
                                              kind = "string";
                                              value = "org/gnome/settings-daemon/plugins/media-keys/custom-keybindings/gsr-record";
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
                                                      value = "Toggle GPU recording";
                                                    }
                                                  ];
                                                  type = "string";
                                                };
                                              }
                                              {
                                                operator = "=";
                                                target = [
                                                  {
                                                    kind = "identifier";
                                                    value = "binding";
                                                  }
                                                ];
                                                type = "assignment";
                                                value = {
                                                  name = "path";
                                                  path = [
                                                    {
                                                      kind = "identifier";
                                                      value = "recordShortcut";
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
                                                    value = "command";
                                                  }
                                                ];
                                                type = "assignment";
                                                value = {
                                                  multiline = false;
                                                  parts = [
                                                    {
                                                      expression = {
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
                                                            value = "video";
                                                          }
                                                          {
                                                            kind = "identifier";
                                                            value = "gpu-screen-recorder-ui";
                                                          }
                                                        ];
                                                        type = "variable";
                                                      };
                                                      type = "interpolation";
                                                    }
                                                    {
                                                      type = "text";
                                                      value = "/bin/gsr-ui-cli toggle-record";
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
                                                value = "recordShortcut";
                                              }
                                            ];
                                            type = "variable";
                                          };
                                          operator = "!=";
                                          right = {
                                            multiline = false;
                                            parts = [ ];
                                            type = "string";
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
                                          value = "optionalAttrs";
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
                                              kind = "string";
                                              value = "org/gnome/settings-daemon/plugins/media-keys";
                                            }
                                            {
                                              kind = "identifier";
                                              value = "custom-keybindings";
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
                                                    value = "/org/gnome/settings-daemon/plugins/media-keys/custom-keybindings/gsr-clip/";
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
                                              kind = "string";
                                              value = "org/gnome/settings-daemon/plugins/media-keys/custom-keybindings/gsr-clip";
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
                                                      value = "Save GPU replay clip";
                                                    }
                                                  ];
                                                  type = "string";
                                                };
                                              }
                                              {
                                                operator = "=";
                                                target = [
                                                  {
                                                    kind = "identifier";
                                                    value = "binding";
                                                  }
                                                ];
                                                type = "assignment";
                                                value = {
                                                  name = "path";
                                                  path = [
                                                    {
                                                      kind = "identifier";
                                                      value = "clipShortcut";
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
                                                    value = "command";
                                                  }
                                                ];
                                                type = "assignment";
                                                value = {
                                                  multiline = false;
                                                  parts = [
                                                    {
                                                      expression = {
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
                                                            value = "video";
                                                          }
                                                          {
                                                            kind = "identifier";
                                                            value = "gpu-screen-recorder-ui";
                                                          }
                                                        ];
                                                        type = "variable";
                                                      };
                                                      type = "interpolation";
                                                    }
                                                    {
                                                      type = "text";
                                                      value = "/bin/gsr-ui-cli replay-save";
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
                                                value = "clipShortcut";
                                              }
                                            ];
                                            type = "variable";
                                          };
                                          operator = "!=";
                                          right = {
                                            multiline = false;
                                            parts = [ ];
                                            type = "string";
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
                                          value = "optionalAttrs";
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
                                              kind = "string";
                                              value = "org/gnome/settings-daemon/plugins/media-keys";
                                            }
                                            {
                                              kind = "identifier";
                                              value = "custom-keybindings";
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
                                                    value = "/org/gnome/settings-daemon/plugins/media-keys/custom-keybindings/gsr-hud/";
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
                                              kind = "string";
                                              value = "org/gnome/settings-daemon/plugins/media-keys/custom-keybindings/gsr-hud";
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
                                                      value = "Toggle GPU recording HUD";
                                                    }
                                                  ];
                                                  type = "string";
                                                };
                                              }
                                              {
                                                operator = "=";
                                                target = [
                                                  {
                                                    kind = "identifier";
                                                    value = "binding";
                                                  }
                                                ];
                                                type = "assignment";
                                                value = {
                                                  name = "path";
                                                  path = [
                                                    {
                                                      kind = "identifier";
                                                      value = "hudShortcut";
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
                                                    value = "command";
                                                  }
                                                ];
                                                type = "assignment";
                                                value = {
                                                  multiline = false;
                                                  parts = [
                                                    {
                                                      expression = {
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
                                                            value = "video";
                                                          }
                                                          {
                                                            kind = "identifier";
                                                            value = "gpu-screen-recorder-ui";
                                                          }
                                                        ];
                                                        type = "variable";
                                                      };
                                                      type = "interpolation";
                                                    }
                                                    {
                                                      type = "text";
                                                      value = "/bin/gsr-ui-cli toggle-show";
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
                                                value = "hudShortcut";
                                              }
                                            ];
                                            type = "variable";
                                          };
                                          operator = "!=";
                                          right = {
                                            multiline = false;
                                            parts = [ ];
                                            type = "string";
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
                                          value = "optionalAttrs";
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
                            type = "list";
                          }
                        ];
                        callee = {
                          name = "lib";
                          path = [
                            {
                              kind = "identifier";
                              value = "mkMerge";
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
                                          value = "replaySeconds";
                                        }
                                      ];
                                      type = "variable";
                                    };
                                    operator = ">";
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
                                          kind = "identifier";
                                          value = "frameRate";
                                        }
                                      ];
                                      type = "variable";
                                    };
                                    operator = ">";
                                    right = {
                                      kind = "integer";
                                      type = "literal";
                                      value = 0;
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
                                      value = "GPU Screen Recorder requires positive replay duration and frame rate.";
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
    (let preferences = (builtins.addErrorContext "_let preferences annotation mismatch: /nix/store/59qqzf108ga8h2qmsjizzsn2p7i889xx-zenpkgs-dsl-source/modules/programs/gpu-screen-recorder.zmdl:30:1" ((_zenType: _zenValue: let force = type: value: if type.name == "anything" then true else if type.name == "listOf" then builtins.all (force type.nestedTypes.elemType) value else if type.name == "attrsOf" then builtins.all (force type.nestedTypes.elemType) (builtins.attrValues value) else if type.name == "either" then force (if type.nestedTypes.left.check value then type.nestedTypes.left else type.nestedTypes.right) value else builtins.seq value true; in builtins.seq (force _zenType _zenValue) _zenValue) ((lib.types.listOf lib.types.attrs)) ((lib.evalModules { modules = [ { options.value = lib.mkOption { type = (lib.types.listOf lib.types.attrs); }; config.value = ([
  {
    path = [
      "main"
      "hotkeys_enable_option"
    ];
    value = "disable_hotkeys";
  }
  {
    path = [
      "main"
      "joystick_hotkeys_enable_option"
    ];
    value = "disable_hotkeys";
  }
  {
    path = [
      "replay"
      "turn_on_replay_automatically_mode"
    ];
    value = (if cfg.autoStart then "turn_on_at_system_startup" else "dont_turn_on_automatically");
  }
  {
    path = [
      "replay"
      "time"
    ];
    value = cfg.replaySeconds;
  }
  {
    path = [
      "replay"
      "save_directory"
    ];
    value = cfg.clipsDirectory;
  }
  {
    path = [
      "record"
      "save_directory"
    ];
    value = cfg.recordingsDirectory;
  }
] ++ (((lib.concatMap ((mode: [
  {
    path = [
      mode
      "record_options"
      "record_area_option"
    ];
    value = cfg.monitor;
  }
  {
    path = [
      mode
      "record_options"
      "fps"
    ];
    value = cfg.frameRate;
  }
  {
    path = [
      mode
      "record_options"
      "codec"
    ];
    value = "h264";
  }
  {
    path = [
      mode
      "record_options"
      "audio_codec"
    ];
    value = "aac";
  }
  {
    path = [
      mode
      "record_options"
      "video_quality"
    ];
    value = "high";
  }
  {
    path = [
      mode
      "record_options"
      "audio_track_item"
    ];
    value = [
      {
        name = "";
        audio_inputs = [
          cfg.audioDevice
        ];
        application_audio_invert = false;
      }
    ];
  }
]))) [
  "record"
  "replay"
]))); } ]; }).config.value))); in {
      programs.gpu-screen-recorder.enable = ((lib.mkIf cfg.systemSupport) true);
      programs.gpu-screen-recorder.package = ((lib.mkIf cfg.systemSupport) pkgs.zenos.byCategories.apps.video.gpu-screen-recorder);
    })
    (let preferences = (builtins.addErrorContext "_let preferences annotation mismatch: /nix/store/59qqzf108ga8h2qmsjizzsn2p7i889xx-zenpkgs-dsl-source/modules/programs/gpu-screen-recorder.zmdl:30:1" ((_zenType: _zenValue: let force = type: value: if type.name == "anything" then true else if type.name == "listOf" then builtins.all (force type.nestedTypes.elemType) value else if type.name == "attrsOf" then builtins.all (force type.nestedTypes.elemType) (builtins.attrValues value) else if type.name == "either" then force (if type.nestedTypes.left.check value then type.nestedTypes.left else type.nestedTypes.right) value else builtins.seq value true; in builtins.seq (force _zenType _zenValue) _zenValue) ((lib.types.listOf lib.types.attrs)) ((lib.evalModules { modules = [ { options.value = lib.mkOption { type = (lib.types.listOf lib.types.attrs); }; config.value = ([
  {
    path = [
      "main"
      "hotkeys_enable_option"
    ];
    value = "disable_hotkeys";
  }
  {
    path = [
      "main"
      "joystick_hotkeys_enable_option"
    ];
    value = "disable_hotkeys";
  }
  {
    path = [
      "replay"
      "turn_on_replay_automatically_mode"
    ];
    value = (if cfg.autoStart then "turn_on_at_system_startup" else "dont_turn_on_automatically");
  }
  {
    path = [
      "replay"
      "time"
    ];
    value = cfg.replaySeconds;
  }
  {
    path = [
      "replay"
      "save_directory"
    ];
    value = cfg.clipsDirectory;
  }
  {
    path = [
      "record"
      "save_directory"
    ];
    value = cfg.recordingsDirectory;
  }
] ++ (((lib.concatMap ((mode: [
  {
    path = [
      mode
      "record_options"
      "record_area_option"
    ];
    value = cfg.monitor;
  }
  {
    path = [
      mode
      "record_options"
      "fps"
    ];
    value = cfg.frameRate;
  }
  {
    path = [
      mode
      "record_options"
      "codec"
    ];
    value = "h264";
  }
  {
    path = [
      mode
      "record_options"
      "audio_codec"
    ];
    value = "aac";
  }
  {
    path = [
      mode
      "record_options"
      "video_quality"
    ];
    value = "high";
  }
  {
    path = [
      mode
      "record_options"
      "audio_track_item"
    ];
    value = [
      {
        name = "";
        audio_inputs = [
          cfg.audioDevice
        ];
        application_audio_invert = false;
      }
    ];
  }
]))) [
  "record"
  "replay"
]))); } ]; }).config.value))); in (lib.mkIf ((cfg.enable)) { home-manager.sharedModules = [ {
      home.packages = [
        pkgs.zenos.byCategories.apps.video.gpu-screen-recorder-ui
      ];
      home.activation.zenosScreenRecorderPreferences = (lib.mkWritableProgramConfig {
        pkgs = pkgs.zenos.legacy;
        application = "gpu-screen-recorder-ui";
        assignments = preferences;
      });
      systemd.user.services.zenos-screen-recorder = {
        Unit = {
          Description = "GPU Screen Recorder overlay, replay and recording";
          After = [
            "graphical-session.target"
            "pipewire-pulse.service"
          ];
          PartOf = [
            "graphical-session.target"
          ];
        };
        Service = {
          ExecStartPre = (lib.escapeShellArgs [
            "${((value: let kind = builtins.typeOf value; in if kind == "string" then value else if kind == "bool" || kind == "int" || kind == "float" then builtins.toJSON value else if kind == "path" then "${value}" else if kind == "set" && (value.type or null) == "derivation" && builtins.isString (value.outPath or null) then value.outPath else throw "/nix/store/59qqzf108ga8h2qmsjizzsn2p7i889xx-zenpkgs-dsl-source/modules/programs/gpu-screen-recorder.zmdl:60: string interpolation requires a scalar, path, or package") (pkgs.zenos.legacy.coreutils))}/bin/mkdir"
            "-p"
            cfg.clipsDirectory
            cfg.recordingsDirectory
          ]);
          ExecStart = "${((value: let kind = builtins.typeOf value; in if kind == "string" then value else if kind == "bool" || kind == "int" || kind == "float" then builtins.toJSON value else if kind == "path" then "${value}" else if kind == "set" && (value.type or null) == "derivation" && builtins.isString (value.outPath or null) then value.outPath else throw "/nix/store/59qqzf108ga8h2qmsjizzsn2p7i889xx-zenpkgs-dsl-source/modules/programs/gpu-screen-recorder.zmdl:61: string interpolation requires a scalar, path, or package") (pkgs.zenos.byCategories.apps.video.gpu-screen-recorder-ui))}/bin/gsr-ui launch-hide";
          KillSignal = "SIGINT";
          TimeoutStopSec = 30;
          Restart = "on-failure";
          RestartSec = 5;
        };
        Install.WantedBy = (if cfg.autoStart then [
          "graphical-session.target"
        ] else [ ]);
      };
      dconf.settings = (lib.mkMerge [
        (((lib.mkIf (((lib.elem cfg.clipShortcut) [
          "<Shift><Super>w"
          "<Super><Shift>w"
        ]))) {
          "org/gnome/shell/extensions/forge/keybindings".workspace-active-tile-toggle = (lib.mkDefault [
            ""
          ]);
        }))
        {
          "org/gnome/settings-daemon/plugins/media-keys".custom-keybindings = ((lib.mkIf ((((cfg.recordShortcut != "") || (cfg.clipShortcut != "")) || (cfg.hudShortcut != "")))) (((lib.concatMap ((database: (database.settings."org/gnome/settings-daemon/plugins/media-keys".custom-keybindings or [ ])))) ((config.zenos.legacy.programs.dconf.profiles.user.databases or [ ])))));
        }
        (((lib.optionalAttrs ((cfg.recordShortcut != ""))) {
          "org/gnome/settings-daemon/plugins/media-keys".custom-keybindings = [
            "/org/gnome/settings-daemon/plugins/media-keys/custom-keybindings/gsr-record/"
          ];
          "org/gnome/settings-daemon/plugins/media-keys/custom-keybindings/gsr-record" = {
            name = "Toggle GPU recording";
            binding = cfg.recordShortcut;
            command = "${((value: let kind = builtins.typeOf value; in if kind == "string" then value else if kind == "bool" || kind == "int" || kind == "float" then builtins.toJSON value else if kind == "path" then "${value}" else if kind == "set" && (value.type or null) == "derivation" && builtins.isString (value.outPath or null) then value.outPath else throw "/nix/store/59qqzf108ga8h2qmsjizzsn2p7i889xx-zenpkgs-dsl-source/modules/programs/gpu-screen-recorder.zmdl:86: string interpolation requires a scalar, path, or package") (pkgs.zenos.byCategories.apps.video.gpu-screen-recorder-ui))}/bin/gsr-ui-cli toggle-record";
          };
        }))
        (((lib.optionalAttrs ((cfg.clipShortcut != ""))) {
          "org/gnome/settings-daemon/plugins/media-keys".custom-keybindings = [
            "/org/gnome/settings-daemon/plugins/media-keys/custom-keybindings/gsr-clip/"
          ];
          "org/gnome/settings-daemon/plugins/media-keys/custom-keybindings/gsr-clip" = {
            name = "Save GPU replay clip";
            binding = cfg.clipShortcut;
            command = "${((value: let kind = builtins.typeOf value; in if kind == "string" then value else if kind == "bool" || kind == "int" || kind == "float" then builtins.toJSON value else if kind == "path" then "${value}" else if kind == "set" && (value.type or null) == "derivation" && builtins.isString (value.outPath or null) then value.outPath else throw "/nix/store/59qqzf108ga8h2qmsjizzsn2p7i889xx-zenpkgs-dsl-source/modules/programs/gpu-screen-recorder.zmdl:94: string interpolation requires a scalar, path, or package") (pkgs.zenos.byCategories.apps.video.gpu-screen-recorder-ui))}/bin/gsr-ui-cli replay-save";
          };
        }))
        (((lib.optionalAttrs ((cfg.hudShortcut != ""))) {
          "org/gnome/settings-daemon/plugins/media-keys".custom-keybindings = [
            "/org/gnome/settings-daemon/plugins/media-keys/custom-keybindings/gsr-hud/"
          ];
          "org/gnome/settings-daemon/plugins/media-keys/custom-keybindings/gsr-hud" = {
            name = "Toggle GPU recording HUD";
            binding = cfg.hudShortcut;
            command = "${((value: let kind = builtins.typeOf value; in if kind == "string" then value else if kind == "bool" || kind == "int" || kind == "float" then builtins.toJSON value else if kind == "path" then "${value}" else if kind == "set" && (value.type or null) == "derivation" && builtins.isString (value.outPath or null) then value.outPath else throw "/nix/store/59qqzf108ga8h2qmsjizzsn2p7i889xx-zenpkgs-dsl-source/modules/programs/gpu-screen-recorder.zmdl:102: string interpolation requires a scalar, path, or package") (pkgs.zenos.byCategories.apps.video.gpu-screen-recorder-ui))}/bin/gsr-ui-cli toggle-show";
          };
        }))
      ]);
      assertions = [
        {
          assertion = ((cfg.replaySeconds > 0) && (cfg.frameRate > 0));
          message = "GPU Screen Recorder requires positive replay duration and frame rate.";
        }
      ];
    } ]; }))
  ];
}
