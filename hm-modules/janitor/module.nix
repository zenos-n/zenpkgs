{
  config,
  lib,
  pkgs,
  ...
}:

let
  cfg = config.zenos.janitor;
  zenfsPkg = pkgs.zenos.system.zenfs;

  jsonConfig = pkgs.writeText "janitor_config.json" (builtins.toJSON cfg);
in
{
  meta = {
    description = "Automated organization daemon for ZenOS user directories";
    maintainers = with lib.maintainers; [ doromiert ];
    license = lib.licenses.napl;
    platforms = lib.platforms.zenos;
  };

  options.zenos.janitor = {
    enable = lib.mkEnableOption "ZenFS Janitor";

    dumb = {
      enable = lib.mkEnableOption "Dumb (Rule-based) Sorting";

      batchInterval = lib.mkOption {
        type = lib.types.str;
        default = "5m";
        description = "Time to wait after last file addition before creating a batch";
        example = "5m";
      };

      gracePeriod = lib.mkOption {
        type = lib.types.str;
        default = "15m";
        description = "Minimum age of a batch folder before processing";
        example = "15m";
      };

      watchedDirs = lib.mkOption {
        type = lib.types.attrsOf (
          lib.types.submodule {
            options.rules = lib.mkOption {
              type = lib.types.attrsOf (lib.types.listOf lib.types.str);
              description = "Map of target subdirectories to file extensions";
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
        description = "Configuration for directories to watch and sort";
      };
    };

    music = {
      enable = lib.mkEnableOption "Music Virtual Library";

      sourceDir = lib.mkOption {
        type = lib.types.str;
        description = "The source directory containing raw music files";
      };

      mountPoint = lib.mkOption {
        type = lib.types.str;
        description = "The directory where the FUSE view will be mounted";
      };

      artistSplitSymbols = lib.mkOption {
        type = lib.types.listOf lib.types.str;
        default = [
          ";"
          ","
          " feat. "
          "zenfs-reg:\\s*(?:ft\\.|feat)\\s*"
        ];
        description = "Delimiters for splitting artists";
      };
    };

    ml = {
      enable = lib.mkEnableOption "ML Sorting";
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
