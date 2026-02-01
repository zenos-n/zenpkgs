{
  config,
  lib,
  pkgs,
  ...
}:

let
  cfg = config.zenos.janitor;
  # Reference internal package using zenos namespace where possible
  zenfsPkg = pkgs.zenos.system.zenfs;

  jsonConfig = pkgs.writeText "janitor_config.json" (builtins.toJSON cfg);
in
{
  meta = {
    description = "Automated organization daemon for ZenOS user directories";
    longDescription = ''
      The Janitor is a background service for ZenOS designed to keep user directories clean 
      and organized using various sorting strategies.

      ### Why use ZenFS Janitor?
      - **Automation**: Automatically moves files from "dumping grounds" like Downloads to structured folders.
      - **Context Awareness**: Uses different tiers of logic (rule-based, metadata-based, or ML) depending on the content.
      - **Virtualization**: Provides a FUSE-based music library that organizes physical files into a virtual artist/album hierarchy without moving the originals.

      ### Sorting Tiers
      1. **Dumb**: Fast, extension-based sorting into predefined directories.
      2. **Music**: A FUSE filesystem that maps metadata (ID3 tags) to a browsable folder structure.
      3. **ML**: Experimental machine-learning based classification for complex files.

      Integrates with `zenos.system.zenfs` for low-level filesystem operations.
    '';
    maintainers = with lib.maintainers; [ doromiert ];
    license = lib.licenses.napl;
    platforms = lib.platforms.zenos;
  };

  options.zenos.janitor = {
    enable = lib.mkEnableOption "the ZenFS Janitor automated organization service";

    dumb = {
      enable = lib.mkEnableOption "rule-based (dumb) file sorting";

      batchInterval = lib.mkOption {
        type = lib.types.str;
        default = "5m";
        description = "Idle time to wait after a file is added before creating a processing batch";
        example = "5m";
      };

      gracePeriod = lib.mkOption {
        type = lib.types.str;
        default = "15m";
        description = "Minimum age of a batch folder before the Janitor processes it";
        example = "15m";
      };

      watchedDirs = lib.mkOption {
        type = lib.types.attrsOf (
          lib.types.submodule {
            options.rules = lib.mkOption {
              type = lib.types.attrsOf (lib.types.listOf lib.types.str);
              description = "Mapping of target subdirectories to file extensions";
              example = {
                "Pictures/Downloads" = [
                  "jpg"
                  "png"
                ];
              };
            };
          }
        );
        default = { };
        description = "Set of directories to monitor for automated sorting";
      };
    };

    music = {
      enable = lib.mkEnableOption "the Music Virtual Library FUSE mount";

      sourceDir = lib.mkOption {
        type = lib.types.str;
        description = "Path to the source directory containing raw music files";
      };

      mountPoint = lib.mkOption {
        type = lib.types.str;
        description = "The target directory where the virtual FUSE view will be mounted";
      };

      artistSplitSymbols = lib.mkOption {
        type = lib.types.listOf lib.types.str;
        default = [
          ";"
          ","
          " feat. "
          "zenfs-reg:\\s*(?:ft\\.|feat)\\s*"
        ];
        description = "List of delimiters or regex patterns used to split multi-artist tags";
      };
    };

    ml = {
      enable = lib.mkEnableOption "machine learning-based classification";
    };
  };

  config = lib.mkIf cfg.enable {
    systemd.user.services.zenfs-janitor-dumb = lib.mkIf cfg.dumb.enable {
      Unit.Description = "ZenFS Janitor (Dumb)";
      Service = {
        ExecStart = "${zenfsPkg}/bin/zenfs-janitor dumb ${jsonConfig}";
        Restart = "always";
      };
      Install.WantedBy = [ "default.target" ];
    };

    systemd.user.services.zenfs-janitor-music = lib.mkIf cfg.music.enable {
      Unit.Description = "ZenFS Janitor (Music FUSE)";
      Service = {
        ExecStart = "${zenfsPkg}/bin/zenfs-janitor music ${jsonConfig}";
        ExecStop = "fusermount -u ${cfg.music.mountPoint}";
        Restart = "always";
      };
      Install.WantedBy = [ "default.target" ];
    };

    systemd.user.services.zenfs-janitor-ml = lib.mkIf cfg.ml.enable {
      Unit.Description = "ZenFS Janitor (ML Tier 1)";
      Service = {
        ExecStart = "${zenfsPkg}/bin/zenfs-janitor ml ${jsonConfig}";
        Restart = "always";
      };
      Install.WantedBy = [ "default.target" ];
    };
  };
}
