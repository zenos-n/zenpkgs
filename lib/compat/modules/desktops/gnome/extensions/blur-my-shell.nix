{
  config,
  pkgs,
  lib,
  ...
}:

with lib;

let
  cfg = config.zenos.desktops.gnome.extensions.blur-my-shell;

  mkVariant = v: "<${v}>";
  mkString = v: "'${v}'";

  mkFloat =
    v:
    let
      s = toString v;
    in
    if builtins.match ".*\\..*" s == null then "${s}.0" else s;

  serializeValue =
    v:
    if builtins.isBool v then
      (if v then "true" else "false")
    else if builtins.isInt v then
      toString v
    else if builtins.isFloat v then
      mkFloat v
    else if builtins.isString v then
      mkString v
    else
      throw "Unsupported type in pipeline params: ${builtins.typeOf v}";

  serializeParams =
    params:
    if params == { } then
      "@a{sv} {}"
    else
      let
        keys = builtins.sort (a: b: a < b) (builtins.attrNames params);
        pairs = map (k: "${mkString k}: ${mkVariant (serializeValue params.${k})}") keys;
      in
      "{${concatStringsSep ", " pairs}}";

  padId =
    index:
    let
      s = toString index;
      zeros = "000000000000";
    in
    "effect_${builtins.substring 0 (12 - builtins.stringLength s) zeros}${s}";

  normalizeEffect =
    index: effectAttrs:
    let
      genId = padId index;

      process = type: params: {
        inherit type params;
        id = if effectAttrs ? id then effectAttrs.id else genId;
      };
    in
    if effectAttrs ? blur.gaussian then
      process "native_static_gaussian_blur" effectAttrs.blur.gaussian
    else if effectAttrs ? blur.monte_carlo then
      process "monte_carlo_blur" effectAttrs.blur.monte_carlo
    else if effectAttrs ? corner then
      process "corner" effectAttrs.corner
    else if effectAttrs ? noise then
      process "noise" effectAttrs.noise
    else if effectAttrs ? color then
      process "color" effectAttrs.color
    else if effectAttrs ? pixelize then
      process "pixelize" effectAttrs.pixelize
    else if effectAttrs ? derivative then
      process "derivative" effectAttrs.derivative
    else if effectAttrs ? type then
      process effectAttrs.type (effectAttrs.params or { })
    else
      throw "Unknown effect type in pipeline configuration";

  serializeEffect =
    index: effectAttrs:
    let
      norm = normalizeEffect index effectAttrs;
      dict = "{'type': ${mkVariant (mkString norm.type)}, 'id': ${mkVariant (mkString norm.id)}, 'params': ${mkVariant (serializeParams norm.params)}}";
    in
    mkVariant dict;

  serializePipeline =
    pipeline:
    let
      serializedEffects = imap0 serializeEffect pipeline.effects;
    in
    "{'name': ${mkVariant (mkString pipeline.name)}, 'effects': ${mkVariant "[${concatStringsSep ", " serializedEffects}]"}}";

  pipelinesGVariant = "{${
    concatStringsSep ", " (
      mapAttrsToList (id: pipe: "${mkString id}: ${serializePipeline pipe}") cfg.general.pipelines
    )
  }}";

  commonBlurOptions = {
    blur = mkOption {
      type = types.bool;
      default = true;
      description = "Whether to activate blur for this component";
    };
    customize = mkOption {
      type = types.bool;
      default = false;
      description = "Whether to customize sigma/brightness or use global values";
    };
    sigma = mkOption {
      type = types.int;
      default = 30;
      description = "Gaussian sigma (blur strength)";
    };
    brightness = mkOption {
      type = types.float;
      default = 0.6;
      description = "Brightness of the blur effect";
    };
    color = mkOption {
      type = types.str;
      default = "(0.0,0.0,0.0,0.0)";
      description = "Color to mix with the blur (GVariant tuple string)";
    };
    noise-amount = mkOption {
      type = types.float;
      default = 0.0;
      description = "Amount of noise to add";
    };
    noise-lightness = mkOption {
      type = types.float;
      default = 0.0;
      description = "Lightness of the noise";
    };
  };

  mkComponent =
    extraOptions:
    types.submodule {
      options = commonBlurOptions // extraOptions;
    };

  pipelineSubmodule = types.submodule {
    options = {
      name = mkOption {
        type = types.str;
        description = "Human readable name of the pipeline";
      };
      effects = mkOption {
        type = types.listOf types.attrs;
        default = [ ];
        description = "List of effects for custom processing";
      };
    };
  };

  meta = {
    description = ''
      Aesthetic blur effects for GNOME Shell components

      This module installs and configures the **Blur My Shell** extension for GNOME.
      It adds a blur look to different parts of the GNOME Shell, including the top panel,
      dash, overview, and applications.

      **Features:**
      - Global blur settings (sigma, brightness, noise).
      - Per-component configuration (Panel, Dock, Overview, Lockscreen).
      - Advanced pipeline support for custom effects.
      - Application whitelist/blacklist.
    '';
    maintainers = with lib.maintainers; [ doromiert ];
    license = lib.licenses.napl;
    platforms = lib.platforms.zenos;
  };
in
{

  options.zenos.desktops.gnome.extensions.blur-my-shell = {
    _meta = lib.mkOption {
      internal = true;
      readOnly = true;
      default = meta;
      description = "Internal documentation metadata";
    };
    enable = mkEnableOption "Blur My Shell GNOME extension configuration";

    general = {
      settings-version = mkOption {
        type = types.int;
        default = 1;
        description = "Internal version tracker for settings";
      };
      sigma = mkOption {
        type = types.int;
        default = 30;
        description = "Global gaussian sigma (blur radius)";
      };
      brightness = mkOption {
        type = types.float;
        default = 0.6;
        description = "Global brightness adjustment for blur";
      };
      color = mkOption {
        type = types.str;
        default = "(0.0,0.0,0.0,0.0)";
        description = "Global color mix (GVariant tuple)";
      };
      noise-amount = mkOption {
        type = types.float;
        default = 0.0;
        description = "Global film grain/noise intensity";
      };
      noise-lightness = mkOption {
        type = types.float;
        default = 0.0;
        description = "Global noise lightness adjustment";
      };
      color-and-noise = mkOption {
        type = types.bool;
        default = true;
        description = "Apply color and noise filters globally";
      };
      hacks-level = mkOption {
        type = types.int;
        default = 1;
        description = "Performance/Compatibility hack level (0-2)";
      };
      debug = mkOption {
        type = types.bool;
        default = false;
        description = "Enable verbose console output for debugging";
      };
      pipelines = mkOption {
        description = "Advanced effect pipeline definitions";
        type = types.attrsOf pipelineSubmodule;
        default = { };
      };
    };

    overview = mkOption {
      description = "Activity overview blur settings";
      type = mkComponent {
        pipeline = mkOption {
          type = types.str;
          default = "pipeline_default";
          description = "Pipeline applied to the overview background";
        };
        style-components = mkOption {
          type = types.int;
          default = 1;
          description = "Component transparency style (0-3)";
        };
      };
      default = { };
    };

    appfolder = mkOption {
      description = "App grid folder blur settings";
      type = mkComponent {
        style-dialogs = mkOption {
          type = types.int;
          default = 1;
          description = "Folder dialog visual style (0-3)";
        };
      };
      default = { };
    };

    panel = mkOption {
      description = "Top panel blur settings";
      type = mkComponent {
        pipeline = mkOption {
          type = types.str;
          default = "pipeline_default";
          description = "Pipeline applied to the panel";
        };
        static-blur = mkOption {
          type = types.bool;
          default = true;
          description = "Use static image blur instead of live blur";
        };
        unblur-in-overview = mkOption {
          type = types.bool;
          default = true;
          description = "Disable blur when entering the overview";
        };
        force-light-text = mkOption {
          type = types.bool;
          default = false;
          description = "Force white text on blurred panel";
        };
        override-background = mkOption {
          type = types.bool;
          default = true;
          description = "Force panel background override";
        };
        style-panel = mkOption {
          type = types.int;
          default = 0;
          description = "Panel transparency style (0-3)";
        };
        override-background-dynamically = mkOption {
          type = types.bool;
          default = false;
          description = "Toggle blur based on window overlap";
        };
      };
      default = { };
    };

    dash-to-dock = mkOption {
      description = "Dash to Dock integration settings";
      type = mkComponent {
        pipeline = mkOption {
          type = types.str;
          default = "pipeline_default_rounded";
          description = "Pipeline applied to the dock";
        };
        static-blur = mkOption {
          type = types.bool;
          default = true;
          description = "Use static blur for the dock";
        };
        override-background = mkOption {
          type = types.bool;
          default = true;
          description = "Override dock background settings";
        };
        style-dash-to-dock = mkOption {
          type = types.int;
          default = 0;
          description = "Dock transparency style (0-2)";
        };
        unblur-in-overview = mkOption {
          type = types.bool;
          default = false;
          description = "Disable blur in activity overview";
        };
        corner-radius = mkOption {
          type = types.int;
          default = 12;
          description = "Corner rounding radius for the blur actor";
        };
      };
      default = { };
    };

    applications = mkOption {
      description = "Application window blur settings";
      type = mkComponent {
        opacity = mkOption {
          type = types.int;
          default = 215;
          description = "Alpha opacity for blurred windows";
        };
        dynamic-opacity = mkOption {
          type = types.bool;
          default = true;
          description = "Restore full opacity on window focus";
        };
        blur-on-overview = mkOption {
          type = types.bool;
          default = false;
          description = "Keep window blur active in overview";
        };
        enable-all = mkOption {
          type = types.bool;
          default = false;
          description = "Attempt to blur all window actors";
        };
        whitelist = mkOption {
          type = types.listOf types.str;
          default = [ ];
          description = "App IDs to explicitly include in blur";
        };
        blacklist = mkOption {
          type = types.listOf types.str;
          default = [
            "Plank"
            "com.desktop.ding"
            "Conky"
          ];
          description = "App IDs to explicitly exclude from blur";
        };
      };
      default = {
        blur = false;
        customize = true;
        brightness = 1.0;
      };
    };

    screenshot = mkOption {
      description = "Screenshot UI blur settings";
      type = mkComponent {
        pipeline = mkOption {
          type = types.str;
          default = "pipeline_default";
          description = "Pipeline for the screenshot interface";
        };
      };
      default = { };
    };

    lockscreen = mkOption {
      description = "GNOME lockscreen blur settings";
      type = mkComponent {
        pipeline = mkOption {
          type = types.str;
          default = "pipeline_default";
          description = "Pipeline for the lockscreen background";
        };
      };
      default = { };
    };

    window-list = mkOption {
      description = "Window List extension blur settings";
      type = mkComponent {
        pipeline = mkOption {
          type = types.str;
          default = "pipeline_default";
          description = "Pipeline for the window list bar";
        };
      };
      default = { };
    };

    coverflow-alt-tab = mkOption {
      description = "Coverflow integration settings";
      type = types.submodule {
        options = {
          blur = mkOption {
            type = types.bool;
            default = true;
            description = "Enable blur for coverflow switcher";
          };
          pipeline = mkOption {
            type = types.str;
            default = "pipeline_default";
            description = "Pipeline for the coverflow background";
          };
        };
      };
      default = { };
    };

    hidetopbar = mkOption {
      description = "Hide Top Bar compatibility settings";
      type = types.submodule {
        options = {
          compatibility = mkOption {
            type = types.bool;
            default = false;
            description = "Toggle compatibility hacks for Hide Top Bar";
          };
        };
      };
      default = { };
    };

    dash-to-panel = mkOption {
      description = "Dash to Panel integration settings";
      type = types.submodule {
        options = {
          blur-original-panel = mkOption {
            type = types.bool;
            default = true;
            description = "Blur the Dash to Panel actor";
          };
        };
      };
      default = { };
    };
  };

  config = mkIf cfg.enable {
    environment.systemPackages = [ pkgs.gnomeExtensions.blur-my-shell ];

    programs.dconf.profiles.user.databases = [
      {
        settings = {
          "org/gnome/shell/extensions/blur-my-shell" = {
            settings-version = cfg.general.settings-version;
            sigma = cfg.general.sigma;
            brightness = cfg.general.brightness;
            color = cfg.general.color;
            noise-amount = cfg.general.noise-amount;
            noise-lightness = cfg.general.noise-lightness;
            color-and-noise = cfg.general.color-and-noise;
            hacks-level = cfg.general.hacks-level;
            debug = cfg.general.debug;
          };

          "org/gnome/shell/extensions/blur-my-shell/overview" = {
            blur = cfg.overview.blur;
            pipeline = cfg.overview.pipeline;
            customize = cfg.overview.customize;
            sigma = cfg.overview.sigma;
            brightness = cfg.overview.brightness;
            color = cfg.overview.color;
            noise-amount = cfg.overview.noise-amount;
            noise-lightness = cfg.overview.noise-lightness;
            style-components = cfg.overview.style-components;
          };

          "org/gnome/shell/extensions/blur-my-shell/appfolder" = {
            blur = cfg.appfolder.blur;
            customize = cfg.appfolder.customize;
            sigma = cfg.appfolder.sigma;
            brightness = cfg.appfolder.brightness;
            color = cfg.appfolder.color;
            noise-amount = cfg.appfolder.noise-amount;
            noise-lightness = cfg.appfolder.noise-lightness;
            style-dialogs = cfg.appfolder.style-dialogs;
          };

          "org/gnome/shell/extensions/blur-my-shell/panel" = {
            blur = cfg.panel.blur;
            pipeline = cfg.panel.pipeline;
            customize = cfg.panel.customize;
            sigma = cfg.panel.sigma;
            brightness = cfg.panel.brightness;
            color = cfg.panel.color;
            noise-amount = cfg.panel.noise-amount;
            noise-lightness = cfg.panel.noise-lightness;
            static-blur = cfg.panel.static-blur;
            unblur-in-overview = cfg.panel.unblur-in-overview;
            force-light-text = cfg.panel.force-light-text;
            override-background = cfg.panel.override-background;
            style-panel = cfg.panel.style-panel;
            override-background-dynamically = cfg.panel.override-background-dynamically;
          };

          "org/gnome/shell/extensions/blur-my-shell/dash-to-dock" = {
            blur = cfg.dash-to-dock.blur;
            pipeline = cfg.dash-to-dock.pipeline;
            customize = cfg.dash-to-dock.customize;
            sigma = cfg.dash-to-dock.sigma;
            brightness = cfg.dash-to-dock.brightness;
            color = cfg.dash-to-dock.color;
            noise-amount = cfg.dash-to-dock.noise-amount;
            noise-lightness = cfg.dash-to-dock.noise-lightness;
            static-blur = cfg.dash-to-dock.static-blur;
            override-background = cfg.dash-to-dock.override-background;
            style-dash-to-dock = cfg.dash-to-dock.style-dash-to-dock;
            unblur-in-overview = cfg.dash-to-dock.unblur-in-overview;
            corner-radius = cfg.dash-to-dock.corner-radius;
          };

          "org/gnome/shell/extensions/blur-my-shell/applications" = {
            blur = cfg.applications.blur;
            customize = cfg.applications.customize;
            sigma = cfg.applications.sigma;
            brightness = cfg.applications.brightness;
            color = cfg.applications.color;
            noise-amount = cfg.applications.noise-amount;
            noise-lightness = cfg.applications.noise-lightness;
            opacity = cfg.applications.opacity;
            dynamic-opacity = cfg.applications.dynamic-opacity;
            blur-on-overview = cfg.applications.blur-on-overview;
            enable-all = cfg.applications.enable-all;
            whitelist = cfg.applications.whitelist;
            blacklist = cfg.applications.blacklist;
          };

          "org/gnome/shell/extensions/blur-my-shell/screenshot" = {
            blur = cfg.screenshot.blur;
            pipeline = cfg.screenshot.pipeline;
            customize = cfg.screenshot.customize;
            sigma = cfg.screenshot.sigma;
            brightness = cfg.screenshot.brightness;
            color = cfg.screenshot.color;
            noise-amount = cfg.screenshot.noise-amount;
            noise-lightness = cfg.screenshot.noise-lightness;
          };

          "org/gnome/shell/extensions/blur-my-shell/lockscreen" = {
            blur = cfg.lockscreen.blur;
            pipeline = cfg.lockscreen.pipeline;
            customize = cfg.lockscreen.customize;
            sigma = cfg.lockscreen.sigma;
            brightness = cfg.lockscreen.brightness;
            color = cfg.lockscreen.color;
            noise-amount = cfg.lockscreen.noise-amount;
            noise-lightness = cfg.lockscreen.noise-lightness;
          };

          "org/gnome/shell/extensions/blur-my-shell/window-list" = {
            blur = cfg.window-list.blur;
            pipeline = cfg.window-list.pipeline;
            customize = cfg.window-list.customize;
            sigma = cfg.window-list.sigma;
            brightness = cfg.window-list.brightness;
            color = cfg.window-list.color;
            noise-amount = cfg.window-list.noise-amount;
            noise-lightness = cfg.window-list.noise-lightness;
          };

          "org/gnome/shell/extensions/blur-my-shell/coverflow-alt-tab" = {
            blur = cfg.coverflow-alt-tab.blur;
            pipeline = cfg.coverflow-alt-tab.pipeline;
          };

          "org/gnome/shell/extensions/blur-my-shell/hidetopbar" = {
            compatibility = cfg.hidetopbar.compatibility;
          };

          "org/gnome/shell/extensions/blur-my-shell/dash-to-panel" = {
            blur-original-panel = cfg.dash-to-panel.blur-original-panel;
          };
        };
      }
    ];

    systemd.user.services.blur-my-shell-pipelines = {
      description = "Apply Blur My Shell pipelines configuration";
      wantedBy = [ "graphical-session.target" ];
      partOf = [ "graphical-session.target" ];
      serviceConfig = {
        Type = "oneshot";
        RemainAfterExit = true;
      };
      script = ''
        ${pkgs.dconf}/bin/dconf write /org/gnome/shell/extensions/blur-my-shell/pipelines ${escapeShellArg pipelinesGVariant}
      '';
    };
  };
}
