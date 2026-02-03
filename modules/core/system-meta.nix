{
  config,
  lib,
  ...
}:

let
  cfg = config.zenos.system.version;
in
{
  meta = {
    description = "ZenOS version";
    longDescription = ''
      **ZenOS Version Module**

      Contains the version information for ZenOS. Designed to not be interacted with by the user directly.
    '';
    maintainers = with lib.maintainers; [ doromiert ];
    license = lib.licenses.napl;
    platforms = lib.platforms.zenos;
  };

  options.zenos.system.version = {

    type = lib.mkOption {
      type = lib.types.str;
      default = "beta";
      description = "Release type";
    };

    majorVer = lib.mkOption {
      type = lib.types.str;
      default = "1.0";
      description = "Major version number";
    };

    variant = lib.mkOption {
      type = lib.types.str;
      default = "N";
      description = "Version variant";
      longDescription = ''
        The variant indicates the edition or flavor of the release, such as "N" for the nixos-based edition.
      '';
    };

    full = lib.mkOption {
      type = lib.types.str;
      default = lib.mkVersionString {
        major = cfg.majorVer;
        variant = cfg.variant;
        type = cfg.type;
      };
      description = "Full version string";
      longDescription = ''
        The complete version string constructed from the major version, variant, and type. If beta, it includes the git short revision.
      '';
    };
  };
}
