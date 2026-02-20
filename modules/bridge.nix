{
  config,
  lib,
  pkgs,
  options,
  moduleTree,
  ...
}:

let
  cfg = config.zenos.sandbox;

  resolvePackages =
    schema: tree:
    let
      walk =
        currentSchema: currentTree:
        if lib.isAttrs currentSchema then
          lib.concatLists (
            lib.mapAttrsToList (
              name: value:
              let
                subTree = currentTree.${name} or null;
              in
              if subTree == null then
                [ ]
              else if value == true then
                if lib.isDerivation subTree then [ subTree ] else lib.collect lib.isDerivation subTree
              else if value == false then
                [ ]
              else
                walk value subTree
            ) currentSchema
          )
        else
          [ ];
    in
    walk schema tree;

  # --- FIXED: Legacy Extraction ---
  getLegacyPrograms =
    zenosPrograms: isUser:
    let
      # --- DYNAMIC FILTERING ---
      # moduleTree.programs is a list of paths.
      # We extract the file names (e.g., "keepassxc") to create an exclusion list.
      zenProgramNames = map (p: lib.removeSuffix ".nix" (baseNameOf p)) (moduleTree.programs or [ ]);

      path =
        if isUser then
          [
            "zenos"
            "users"
            "type"
            "nestedTypes"
            "elemType"
            "getSubOptions"
          ]
        else
          [
            "zenos"
            "system"
            "programs"
          ];

      programsOpt =
        if isUser then
          (lib.attrByPath path (x: { }) options) [ ].programs
        else
          lib.attrByPath path null options;

      zenInternal = [
        "__configFiles"
        "__installPackages"
        "meta"
        "legacy"
        "_devlegacy"
      ];

      defined =
        if programsOpt != null && programsOpt ? value then
          builtins.attrNames programsOpt.value
        else if isUser && programsOpt ? options then
          builtins.attrNames programsOpt.options
        else
          [ ];

      explicitLegacy = zenosPrograms.legacy or { };

      # We exclude:
      # 1. Internal ZenOS keys (meta, etc.)
      # 2. Keys already defined in the submodule options
      # 3. Any name that matches one of our custom module filenames
      inheritedLegacy = lib.removeAttrs zenosPrograms (defined ++ zenInternal ++ zenProgramNames);
    in
    lib.recursiveUpdate explicitLegacy inheritedLegacy;
in
{
  # Define the sandbox options (user-facing)
  options = {
    legacy = { };
    zenos.sandbox = {
      system = lib.mkOption {
        description = "System-level configuration sandbox";
        default = { };
        type = lib.types.attrs;
      };
      users = lib.mkOption {
        description = "User-level configuration sandbox";
        default = { };
        type = lib.types.attrs;
      };
      desktops = lib.mkOption {
        description = "Desktop environment sandbox";
        default = { };
        type = lib.types.attrs;
      };
      environment = lib.mkOption {
        description = "Global environment sandbox";
        default = { };
        type = lib.types.attrs;
      };
      legacy = lib.mkOption {
        description = "Global Legacy Passthrough";
        default = { };
        type = lib.types.attrs;
      };
    };
  };

  config = lib.mkMerge [
    # 1. Map Sandbox
    (lib.mkIf (cfg != { }) {
      zenos.system = lib.mkIf (options.zenos ? system && cfg.system != { }) cfg.system;
      zenos.users = lib.mkIf (options.zenos ? users && cfg.users != { }) cfg.users;
      zenos.desktops = lib.mkIf (options.zenos ? desktops && cfg.desktops != { }) cfg.desktops;
      zenos.environment = lib.mkIf (
        options.zenos ? environment && cfg.environment != { }
      ) cfg.environment;
    })

    # 2. System Packages & Programs
    (lib.mkIf (config.zenos ? system) {
      environment.systemPackages = resolvePackages config.zenos.system.packages pkgs.zenos;

      programs = lib.mkIf (config.zenos.system.programs != { }) (
        getLegacyPrograms config.zenos.system.programs false
      );
    })

    # 3. User Plumbing
    # 3. User Plumbing
    {
      # Standard NixOS User Records
      users.users = lib.mapAttrs (
        name: userCfg:
        (userCfg.legacy or { })
        // {
          # Aggregate packages from ZenOS modules into the user's package list
          packages =
            (userCfg.packages.legacyList or [ ])
            ++ (resolvePackages (userCfg.packages.legacy or { }) pkgs)
            ++ (userCfg.__installPackages or [ ]);
        }
      ) config.zenos.users;

      # Route ZenOS user programs to Home Manager
      home-manager.users = lib.mapAttrs (name: userCfg: {
        # This routes any legacy program options to HM's programs.*
        programs = getLegacyPrograms userCfg.programs true;

        # Ensure HM version matches system
        home.stateVersion = config.system.stateVersion;
      }) config.zenos.users;
    }
  ];
}
