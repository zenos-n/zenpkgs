{
  config,
  lib,
  ...
}:

let
  cfg = config.zenos.system.version;
  meta = {
    description = ''
      ZenOS version information

      Provides the foundational versioning metadata for the operating system.
      This module is designed for internal system use and should not be interacted 
      with by the user directly.
    '';
    maintainers = with lib.maintainers; [ doromiert ];
    license = lib.licenses.napl;
    platforms = lib.platforms.zenos;
  };
in
{

  options.zenos.system.version = {
    _meta = lib.mkOption {
      internal = true;
      readOnly = true;
      default = meta;
      description = "Internal documentation metadata";
    };
    type = lib.mkOption {
      type = lib.types.str;
      default = "beta";
      description = ''
        Release lifecycle type

        Defines the stability track of the current release (e.g., 'beta', 'stable').
      '';
    };

    majorVer = lib.mkOption {
      type = lib.types.str;
      default = "1.0";
      description = ''
        Major version identifier

        The primary version number assigned to the current ZenOS release cycle.
      '';
    };

    variant = lib.mkOption {
      type = lib.types.str;
      default = "N";
      description = ''
        Version variant code

        Indicates the edition or flavor of the release, such as 'N' for the 
        NixOS-based edition.
      '';
    };

    full = lib.mkOption {
      type = lib.types.str;
      default = lib.mkVersionString {
        major = cfg.majorVer;
        variant = cfg.variant;
        type = cfg.type;
      };
      description = ''
        Complete version string

        The final constructed version identifier combining major version, variant, 
        and release type. If the type is 'beta', it may include specific revision data.
      '';
    };
  };
}
