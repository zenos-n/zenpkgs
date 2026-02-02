{
  lib,
  config,
  pkgs,
  ...
}:
with lib;
let
  userConfig = config.zenos.config;

  # 1. Standard Zen Namespaces
  # These are routed directly to config.zenos.<name>
  zenNamespaces = [
    "system"
    "desktops"
    "environment"
  ];
in
{
  options = {
    zenos.config = mkOption {
      type = types.attrs;
      default = { };
      description = "The raw, sandboxed user configuration entry point.";
    };
  };

  config = mkIf (userConfig != { }) (mkMerge [
    # A. Map Standard Zen Namespaces (system, desktops, etc.)
    {
      zenos = filterAttrs (n: v: elem n zenNamespaces) userConfig;
    }

    # B. Map 'programs' -> system.programs (For module injection)
    {
      system.programs = userConfig.programs or { };
    }

    # C. Map 'users' -> zenos.users (For the Unified User Wrapper)
    {
      zenos.users = userConfig.users or { };
    }

    # D. Legacy Passthrough (Maps directly to Root)
    (userConfig.legacy or { })
  ]);
}
