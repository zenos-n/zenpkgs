{ lib, config, ... }:

with lib;

let
  cfg = config.zenos.zenfs.janitor;

  # --- [ Submodule for Per-User Settings ] ---
  userJanitorOpts =
    { ... }:
    {
      options = {
        dumb = {
          enable = mkOption {
            type = types.bool;
            default = cfg.dumb.global.enable;
            description = "Enable Dumb Janitor for this user.";
          };
          interval = mkOption {
            type = types.str;
            default = cfg.dumb.global.interval;
            description = "Override global interval.";
          };
          gracePeriod = mkOption {
            type = types.int;
            default = cfg.dumb.global.gracePeriod;
            description = "Override global grace period.";
          };
          watchedDirs = mkOption {
            type = types.listOf types.str;
            default =
              if cfg.dumb.global.watchedDirs == [ ] then
                [ "/home/${name}/Downloads" ]
              else
                cfg.dumb.global.watchedDirs;
            description = "Directories to watch. Defaults to global list.";
          };
          rules = mkOption {
            type = types.attrsOf (types.listOf types.str);
            default = cfg.dumb.global.rules;
            description = "Sorting rules. Defaults to global rules.";
          };
        };

        music = {
          enable = mkOption {
            type = types.bool;
            default = cfg.music.global.enable;
            description = "Enable Music Janitor for this user.";
          };
          interval = mkOption {
            type = types.str;
            default = cfg.music.global.interval;
          };
          musicDir = mkOption {
            type = types.str;
            # Fallback to global, or smart default if global is unset?
            # Using global as requested.
            default =
              if cfg.music.global.musicDir != "/var/lib/music" then
                cfg.music.global.musicDir
              else
                "/home/${name}/Music";
            description = "Target music directory.";
          };
          unsortedDir = mkOption {
            type = types.str;
            default = cfg.music.global.unsortedDir;
            description = "Staging directory for unsorted music.";
          };
          artistSplitSymbols = mkOption {
            type = types.listOf types.str;
            default = cfg.music.global.artistSplitSymbols;
            description = "Symbols to split artists by. For example, if a song has \"Mr. J. Medeiros; 20syl\" in the artist field, it'll interpret it as 2 artists instead of one.";
          };
        };

        ml = {
          enable = mkOption {
            type = types.bool;
            default = cfg.ml.global.enable;
            description = "Enable ML Janitor for this user.";
          };
          interval = mkOption {
            type = types.str;
            default = cfg.ml.global.interval;
          };
          scanDirs = mkOption {
            type = types.listOf types.str;
            default = cfg.ml.global.scanDirs;
            description = "Directories for the ML janitor to scan.";
          };
        };
      };
    };

in
{
  options.zenos.zenfs.janitor = {

    # --- [ Per-User Configuration Container ] ---
    users = mkOption {
      type = types.attrsOf (types.submodule userJanitorOpts);
      default = { };
      description = "Per-user Janitor configuration overrides.";
      example = literalExpression ''
        {
          doromiert.dumb.enable = true;
          doromiert.music.musicDir = "/home/doromiert/Music";
        }
      '';
    };

    dumb.global = {
      enable = mkEnableOption "Enable the dumb (rule based) janitor.";
      interval = mkOption {
        type = types.str;
        default = "60m";
        description = "When to manually check whether a watched directory has been updated in case the watchdog didn't catch it.";
      };
      gracePeriod = mkOption {
        type = types.int;
        default = "20m";
        description = "How long to wait before moving the files.";
      };
      watchedDirs = mkOption {
        type = types.listOf types.str;
        default = [ ]; # Set empty by default, let users override or set global
        description = "Directories the janitor will watch";
      };
      rules = mkOption {
        type = types.attrsOf (types.listOf types.str);
        default = { };
      };
      groupWaitingFiles = {
        enable = mkOption {
          type = types.bool;
          default = true;
          description = "Whether to group files waiting to be moved. If enabled, for example, if you download 5 files in quick succession, the janitor will put them in the same waiting folder. Useful for downloading for example whole albums.";
        };
        interval = mkOption {
          type = types.str;
          default = "10m";
          description = "How long to wait before making a new group.";
        };
      };
    };

    music.global = {
      enable = mkEnableOption "Music Janitor (Global Default)";
      interval = mkOption {
        type = types.str;
        default = "60min";
        description = "When to check whether a the watched directory has been updated in case the watchdog didn't catch it.";
      };
      musicDir = mkOption {
        type = types.str;
        default = "/var/lib/music"; # Generic default
      };
      unsortedDir = mkOption {
        type = types.str;
        default = "/var/lib/music/.database";
      };
      artistSplitSymbols = mkOption {
        type = types.listOf types.str;
        default = [
          ";"
        ];
      };
    };

    ml.global = {
      enable = mkEnableOption "ML Janitor (Global Default)";
      interval = mkOption {
        type = types.str;
        default = "1h";
      };
      scanDirs = mkOption {
        type = types.listOf types.str;
        default = [ ];
      };
      renameFiles = mkOption {
        type = types.bool;
        default = true;
        description = "Whether to use the heavy ML model to rename files.";
      };
      model = {
        local = mkOption {
          type = types.bool;
          default = true;
          description = "Whether to use a local ML model instead of an online one.";
        };
        heavy = mkOption {
          type = types.str;
          description = "Heavy ML model used for sorting and renaming files.";
        };
        light = mkOption {
          type = types.str;
          description = "Lightweight ML model used for sorting files only.";
        };
      };
    };
  };
}
