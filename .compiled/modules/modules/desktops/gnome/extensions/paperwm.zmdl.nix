{ config, lib, pkgs, maintainers ? lib.maintainers, licenses ? lib.licenses, ... }:
let
  cfg = config.zenos.desktops.gnome.extensions.paperwm;
  name = "paperwm";
in
{
  options.zenos.desktops.gnome.extensions.paperwm = lib.mkOption { type = (lib.types.submodule ({ ... }: { options = { behavior = lib.mkOption { type = (lib.types.submodule ({ ... }: { options = { cycle-on-edge = lib.mkOption { type = lib.types.bool; default = true; description = "\n  Loop navigation at ribbon edges\n\n  If enabled, navigating past the last window in a ribbon will loop back\n  to the first window.\n"; }; focus-follows-mouse = lib.mkOption { type = lib.types.bool; default = false; description = "\n  Enable focus-follows-mouse policy\n\n  When enabled, window focus automatically shifts to the actor beneath\n  the mouse cursor.\n"; }; use-default-overview = lib.mkOption { type = lib.types.bool; default = false; description = "\n  Use standard GNOME overview\n\n  Disables PaperWM's specialized overview and uses the default\n  GNOME Shell activities view instead.\n"; }; }; })); default = { }; }; enable = lib.mkOption { type = lib.types.bool; default = false; description = "PaperWM GNOME extension configuration"; }; gestures = lib.mkOption { type = (lib.types.submodule ({ ... }: { options = { enable = lib.mkOption { type = lib.types.bool; default = true; description = "\n  Enable touchpad gesture support\n\n  Activates custom touchpad swipe gestures for navigating and\n  manipulating the window ribbon.\n"; }; fingers = lib.mkOption { type = (lib.types.submodule ({ ... }: { options = { horizontal = lib.mkOption { type = lib.types.int; default = 3; description = "Number of fingers for horizontal ribbon scrolling"; }; workspace = lib.mkOption { type = lib.types.int; default = 4; description = "Number of fingers for switching virtual workspaces"; }; }; })); default = { }; }; swipe = lib.mkOption { type = (lib.types.submodule ({ ... }: { options = { friction = lib.mkOption { type = lib.types.float; default = 1.0; description = "Resistance factor for swipe physics simulation"; }; sensitivity = lib.mkOption { type = lib.types.float; default = 1.0; description = "Responsiveness multiplier for touch input"; }; }; })); default = { }; }; }; })); default = { }; }; keybindings = lib.mkOption { type = (lib.types.submodule ({ ... }: { options = { close-window = lib.mkOption { type = (lib.types.listOf lib.types.str); default = [
  "<Super>q"
]; description = "Shortcut to close the active application window"; }; live-alt-tab = lib.mkOption { type = (lib.types.listOf lib.types.str); default = [
  "<Super>Tab"
]; description = "Shortcut to cycle through windows in the current ribbon"; }; live-alt-tab-backward = lib.mkOption { type = (lib.types.listOf lib.types.str); default = [
  "<Shift><Super>Tab"
]; description = "Shortcut to cycle backward through windows"; }; move-down = lib.mkOption { type = (lib.types.listOf lib.types.str); default = [
  "<Shift><Super>j"
]; description = "Shortcut to move focused window downward (stacking)"; }; move-left = lib.mkOption { type = (lib.types.listOf lib.types.str); default = [
  "<Shift><Super>h"
]; description = "Shortcut to move focused window to the left"; }; move-right = lib.mkOption { type = (lib.types.listOf lib.types.str); default = [
  "<Shift><Super>l"
]; description = "Shortcut to move focused window to the right"; }; move-up = lib.mkOption { type = (lib.types.listOf lib.types.str); default = [
  "<Shift><Super>k"
]; description = "Shortcut to move focused window upward (stacking)"; }; new-window = lib.mkOption { type = (lib.types.listOf lib.types.str); default = [
  "<Super>Return"
]; description = "Shortcut to launch a new terminal window"; }; paper-toggle-fullscreen = lib.mkOption { type = (lib.types.listOf lib.types.str); default = [
  "<Shift><Super>f"
]; description = "Shortcut to toggle window between ribbon and full screen"; }; previous-workspace = lib.mkOption { type = (lib.types.listOf lib.types.str); default = [
  "<Super>Escape"
]; description = "Shortcut to return to the last used workspace"; }; switch-monitor-left = lib.mkOption { type = (lib.types.listOf lib.types.str); default = [
  "<Super>i"
]; description = "Shortcut to move focus to the monitor on the left"; }; switch-monitor-right = lib.mkOption { type = (lib.types.listOf lib.types.str); default = [
  "<Super>u"
]; description = "Shortcut to move focus to the monitor on the right"; }; toggle-maximize-width = lib.mkOption { type = (lib.types.listOf lib.types.str); default = [
  "<Super>f"
]; description = "Shortcut to toggle window between current width and full ribbon width"; }; }; })); default = { }; }; layout = lib.mkOption { type = (lib.types.submodule ({ ... }: { options = { margins = lib.mkOption { type = (lib.types.submodule ({ ... }: { options = { horizontal = lib.mkOption { type = lib.types.int; default = 20; description = "\n  Minimum horizontal window margin\n\n  The base pixel distance between windows and the left/right screen edges.\n"; }; vertical = lib.mkOption { type = lib.types.int; default = 20; description = "\n  Minimum vertical window margin\n\n  The base pixel distance between windows and the top/bottom screen edges.\n"; }; }; })); default = { }; }; selection-border-size = lib.mkOption { type = lib.types.int; default = 4; description = "\n  Selection indicator border width\n\n  Pixel thickness of the border drawn around the currently focused window.\n"; }; show-minimap = lib.mkOption { type = lib.types.bool; default = true; description = "\n  Display the navigation minimap\n\n  Whether to render the miniature overview of the window ribbon\n  at the bottom of the screen.\n"; }; window-gap = lib.mkOption { type = lib.types.int; default = 10; description = "\n  Pixel spacing between tiled windows\n\n  Determines the distance between adjacent window actors in the\n  horizontal ribbon.\n"; }; }; })); default = { }; }; previews = lib.mkOption { type = (lib.types.submodule ({ ... }: { options = { overview = lib.mkOption { type = (lib.types.submodule ({ ... }: { options = { disable-scratch = lib.mkOption { type = lib.types.bool; default = false; description = "\n  Hide scratchpad windows in overview\n\n  Completely hides windows in the scratchpad area when entering\n  the activities overview.\n"; }; only-scratch = lib.mkOption { type = lib.types.bool; default = false; description = "\n  Only show scratchpad windows in overview\n\n  Filters the overview to only display windows that have been\n  moved to the scratchpad area.\n"; }; }; })); default = { }; }; switcher-scale = lib.mkOption { type = lib.types.float; default = 0.5; description = "\n  Scale factor for window switcher thumbnails\n\n  Determines the size of previews in the Alt-Tab and overview\n  interfaces relative to screen size.\n"; }; }; })); default = { }; }; }; })); default = { }; };
  config = lib.mkMerge [
    { _module.args.zenlang.descriptors.desktops.gnome.extensions.paperwm = {
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
            value = "\n    Scrollable tiling window manager for GNOME Shell\n\n    This module installs and configures the **PaperWM** extension for GNOME.\n    PaperWM implements a scrollable tiling window manager, inspired by 10/GUI concepts.\n    It arranges windows in a horizontal ribbon, allowing for efficient navigation\n    and management.\n\n    **Features:**\n    - Scrollable tiling layout.\n    - Extensive keyboard navigation.\n    - Touchpad gesture support.\n    - Customizable appearance (margins, borders, minimap).\n  ";
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
      platforms = {
        name = "lib";
        path = [
          {
            kind = "identifier";
            value = "platforms";
          }
          {
            kind = "identifier";
            value = "zenos";
          }
        ];
        type = "variable";
      };
      summary = {
        multiline = false;
        parts = [
          {
            type = "text";
            value = "Scrollable tiling window manager for GNOME Shell";
          }
        ];
        type = "string";
      };
      zenosVersion = {
        kind = "version";
        type = "literal";
        value = "1.0.0Na";
      };
    };
    moduleIdentity = "zenos.desktops.gnome.extensions.paperwm";
    modulePath = [
      "desktops"
      "gnome"
      "extensions"
      "paperwm"
    ];
    nodeMetadata = [
      {
        metadata = {
          description = {
            multiline = true;
            parts = [
              {
                type = "text";
                value = "\n    Scrollable tiling window manager for GNOME Shell\n\n    This module installs and configures the **PaperWM** extension for GNOME.\n    PaperWM implements a scrollable tiling window manager, inspired by 10/GUI concepts.\n    It arranges windows in a horizontal ribbon, allowing for efficient navigation\n    and management.\n\n    **Features:**\n    - Scrollable tiling layout.\n    - Extensive keyboard navigation.\n    - Touchpad gesture support.\n    - Customizable appearance (margins, borders, minimap).\n  ";
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
          platforms = {
            name = "lib";
            path = [
              {
                kind = "identifier";
                value = "platforms";
              }
              {
                kind = "identifier";
                value = "zenos";
              }
            ];
            type = "variable";
          };
          summary = {
            multiline = false;
            parts = [
              {
                type = "text";
                value = "Scrollable tiling window manager for GNOME Shell";
              }
            ];
            type = "string";
          };
          zenosVersion = {
            kind = "version";
            type = "literal";
            value = "1.0.0Na";
          };
        };
        path = [ ];
      }
      {
        metadata = {
          description = {
            multiline = true;
            parts = [
              {
                type = "text";
                value = "PaperWM GNOME extension configuration";
              }
            ];
            type = "string";
          };
          zenosVersion = {
            kind = "version";
            type = "literal";
            value = "1.0.0Na";
          };
        };
        path = [
          "enable"
        ];
      }
      {
        metadata = {
          zenosVersion = {
            kind = "version";
            type = "literal";
            value = "1.0.0Na";
          };
        };
        path = [
          "layout"
        ];
      }
      {
        metadata = {
          zenosVersion = {
            kind = "version";
            type = "literal";
            value = "1.0.0Na";
          };
        };
        path = [
          "layout"
          "margins"
        ];
      }
      {
        metadata = {
          default = {
            kind = "integer";
            type = "literal";
            value = 20;
          };
          description = {
            multiline = true;
            parts = [
              {
                type = "text";
                value = "\n  Minimum horizontal window margin\n\n  The base pixel distance between windows and the left/right screen edges.\n";
              }
            ];
            type = "string";
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
            value = "1.0.0Na";
          };
        };
        path = [
          "layout"
          "margins"
          "horizontal"
        ];
      }
      {
        metadata = {
          default = {
            kind = "integer";
            type = "literal";
            value = 20;
          };
          description = {
            multiline = true;
            parts = [
              {
                type = "text";
                value = "\n  Minimum vertical window margin\n\n  The base pixel distance between windows and the top/bottom screen edges.\n";
              }
            ];
            type = "string";
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
            value = "1.0.0Na";
          };
        };
        path = [
          "layout"
          "margins"
          "vertical"
        ];
      }
      {
        metadata = {
          default = {
            kind = "integer";
            type = "literal";
            value = 10;
          };
          description = {
            multiline = true;
            parts = [
              {
                type = "text";
                value = "\n  Pixel spacing between tiled windows\n\n  Determines the distance between adjacent window actors in the\n  horizontal ribbon.\n";
              }
            ];
            type = "string";
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
            value = "1.0.0Na";
          };
        };
        path = [
          "layout"
          "window-gap"
        ];
      }
      {
        metadata = {
          default = {
            kind = "integer";
            type = "literal";
            value = 4;
          };
          description = {
            multiline = true;
            parts = [
              {
                type = "text";
                value = "\n  Selection indicator border width\n\n  Pixel thickness of the border drawn around the currently focused window.\n";
              }
            ];
            type = "string";
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
            value = "1.0.0Na";
          };
        };
        path = [
          "layout"
          "selection-border-size"
        ];
      }
      {
        metadata = {
          default = {
            kind = "true";
            type = "literal";
            value = true;
          };
          description = {
            multiline = true;
            parts = [
              {
                type = "text";
                value = "\n  Display the navigation minimap\n\n  Whether to render the miniature overview of the window ribbon\n  at the bottom of the screen.\n";
              }
            ];
            type = "string";
          };
          type = {
            name = "type";
            path = [
              {
                kind = "identifier";
                value = "bool";
              }
            ];
            type = "variable";
          };
          zenosVersion = {
            kind = "version";
            type = "literal";
            value = "1.0.0Na";
          };
        };
        path = [
          "layout"
          "show-minimap"
        ];
      }
      {
        metadata = {
          zenosVersion = {
            kind = "version";
            type = "literal";
            value = "1.0.0Na";
          };
        };
        path = [
          "behavior"
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
                value = "\n  Enable focus-follows-mouse policy\n\n  When enabled, window focus automatically shifts to the actor beneath\n  the mouse cursor.\n";
              }
            ];
            type = "string";
          };
          type = {
            name = "type";
            path = [
              {
                kind = "identifier";
                value = "bool";
              }
            ];
            type = "variable";
          };
          zenosVersion = {
            kind = "version";
            type = "literal";
            value = "1.0.0Na";
          };
        };
        path = [
          "behavior"
          "focus-follows-mouse"
        ];
      }
      {
        metadata = {
          default = {
            kind = "true";
            type = "literal";
            value = true;
          };
          description = {
            multiline = true;
            parts = [
              {
                type = "text";
                value = "\n  Loop navigation at ribbon edges\n\n  If enabled, navigating past the last window in a ribbon will loop back\n  to the first window.\n";
              }
            ];
            type = "string";
          };
          type = {
            name = "type";
            path = [
              {
                kind = "identifier";
                value = "bool";
              }
            ];
            type = "variable";
          };
          zenosVersion = {
            kind = "version";
            type = "literal";
            value = "1.0.0Na";
          };
        };
        path = [
          "behavior"
          "cycle-on-edge"
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
                value = "\n  Use standard GNOME overview\n\n  Disables PaperWM's specialized overview and uses the default\n  GNOME Shell activities view instead.\n";
              }
            ];
            type = "string";
          };
          type = {
            name = "type";
            path = [
              {
                kind = "identifier";
                value = "bool";
              }
            ];
            type = "variable";
          };
          zenosVersion = {
            kind = "version";
            type = "literal";
            value = "1.0.0Na";
          };
        };
        path = [
          "behavior"
          "use-default-overview"
        ];
      }
      {
        metadata = {
          zenosVersion = {
            kind = "version";
            type = "literal";
            value = "1.0.0Na";
          };
        };
        path = [
          "previews"
        ];
      }
      {
        metadata = {
          default = {
            kind = "float";
            type = "literal";
            value = 0.5;
          };
          description = {
            multiline = true;
            parts = [
              {
                type = "text";
                value = "\n  Scale factor for window switcher thumbnails\n\n  Determines the size of previews in the Alt-Tab and overview\n  interfaces relative to screen size.\n";
              }
            ];
            type = "string";
          };
          type = {
            name = "type";
            path = [
              {
                kind = "identifier";
                value = "float";
              }
            ];
            type = "variable";
          };
          zenosVersion = {
            kind = "version";
            type = "literal";
            value = "1.0.0Na";
          };
        };
        path = [
          "previews"
          "switcher-scale"
        ];
      }
      {
        metadata = {
          zenosVersion = {
            kind = "version";
            type = "literal";
            value = "1.0.0Na";
          };
        };
        path = [
          "previews"
          "overview"
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
                value = "\n  Only show scratchpad windows in overview\n\n  Filters the overview to only display windows that have been\n  moved to the scratchpad area.\n";
              }
            ];
            type = "string";
          };
          type = {
            name = "type";
            path = [
              {
                kind = "identifier";
                value = "bool";
              }
            ];
            type = "variable";
          };
          zenosVersion = {
            kind = "version";
            type = "literal";
            value = "1.0.0Na";
          };
        };
        path = [
          "previews"
          "overview"
          "only-scratch"
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
                value = "\n  Hide scratchpad windows in overview\n\n  Completely hides windows in the scratchpad area when entering\n  the activities overview.\n";
              }
            ];
            type = "string";
          };
          type = {
            name = "type";
            path = [
              {
                kind = "identifier";
                value = "bool";
              }
            ];
            type = "variable";
          };
          zenosVersion = {
            kind = "version";
            type = "literal";
            value = "1.0.0Na";
          };
        };
        path = [
          "previews"
          "overview"
          "disable-scratch"
        ];
      }
      {
        metadata = {
          zenosVersion = {
            kind = "version";
            type = "literal";
            value = "1.0.0Na";
          };
        };
        path = [
          "gestures"
        ];
      }
      {
        metadata = {
          default = {
            kind = "true";
            type = "literal";
            value = true;
          };
          description = {
            multiline = true;
            parts = [
              {
                type = "text";
                value = "\n  Enable touchpad gesture support\n\n  Activates custom touchpad swipe gestures for navigating and\n  manipulating the window ribbon.\n";
              }
            ];
            type = "string";
          };
          type = {
            name = "type";
            path = [
              {
                kind = "identifier";
                value = "bool";
              }
            ];
            type = "variable";
          };
          zenosVersion = {
            kind = "version";
            type = "literal";
            value = "1.0.0Na";
          };
        };
        path = [
          "gestures"
          "enable"
        ];
      }
      {
        metadata = {
          zenosVersion = {
            kind = "version";
            type = "literal";
            value = "1.0.0Na";
          };
        };
        path = [
          "gestures"
          "fingers"
        ];
      }
      {
        metadata = {
          default = {
            kind = "integer";
            type = "literal";
            value = 3;
          };
          description = {
            multiline = true;
            parts = [
              {
                type = "text";
                value = "Number of fingers for horizontal ribbon scrolling";
              }
            ];
            type = "string";
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
            value = "1.0.0Na";
          };
        };
        path = [
          "gestures"
          "fingers"
          "horizontal"
        ];
      }
      {
        metadata = {
          default = {
            kind = "integer";
            type = "literal";
            value = 4;
          };
          description = {
            multiline = true;
            parts = [
              {
                type = "text";
                value = "Number of fingers for switching virtual workspaces";
              }
            ];
            type = "string";
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
            value = "1.0.0Na";
          };
        };
        path = [
          "gestures"
          "fingers"
          "workspace"
        ];
      }
      {
        metadata = {
          zenosVersion = {
            kind = "version";
            type = "literal";
            value = "1.0.0Na";
          };
        };
        path = [
          "gestures"
          "swipe"
        ];
      }
      {
        metadata = {
          default = {
            kind = "float";
            type = "literal";
            value = 1.0;
          };
          description = {
            multiline = true;
            parts = [
              {
                type = "text";
                value = "Responsiveness multiplier for touch input";
              }
            ];
            type = "string";
          };
          type = {
            name = "type";
            path = [
              {
                kind = "identifier";
                value = "float";
              }
            ];
            type = "variable";
          };
          zenosVersion = {
            kind = "version";
            type = "literal";
            value = "1.0.0Na";
          };
        };
        path = [
          "gestures"
          "swipe"
          "sensitivity"
        ];
      }
      {
        metadata = {
          default = {
            kind = "float";
            type = "literal";
            value = 1.0;
          };
          description = {
            multiline = true;
            parts = [
              {
                type = "text";
                value = "Resistance factor for swipe physics simulation";
              }
            ];
            type = "string";
          };
          type = {
            name = "type";
            path = [
              {
                kind = "identifier";
                value = "float";
              }
            ];
            type = "variable";
          };
          zenosVersion = {
            kind = "version";
            type = "literal";
            value = "1.0.0Na";
          };
        };
        path = [
          "gestures"
          "swipe"
          "friction"
        ];
      }
      {
        metadata = {
          zenosVersion = {
            kind = "version";
            type = "literal";
            value = "1.0.0Na";
          };
        };
        path = [
          "keybindings"
        ];
      }
      {
        metadata = {
          default = {
            items = [
              {
                multiline = false;
                parts = [
                  {
                    type = "text";
                    value = "<Super>Return";
                  }
                ];
                type = "string";
              }
            ];
            type = "list";
          };
          description = {
            multiline = true;
            parts = [
              {
                type = "text";
                value = "Shortcut to launch a new terminal window";
              }
            ];
            type = "string";
          };
          type = {
            arguments = [
              {
                items = [
                  {
                    name = "type";
                    path = [
                      {
                        kind = "identifier";
                        value = "string";
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
          zenosVersion = {
            kind = "version";
            type = "literal";
            value = "1.0.0Na";
          };
        };
        path = [
          "keybindings"
          "new-window"
        ];
      }
      {
        metadata = {
          default = {
            items = [
              {
                multiline = false;
                parts = [
                  {
                    type = "text";
                    value = "<Super>Tab";
                  }
                ];
                type = "string";
              }
            ];
            type = "list";
          };
          description = {
            multiline = true;
            parts = [
              {
                type = "text";
                value = "Shortcut to cycle through windows in the current ribbon";
              }
            ];
            type = "string";
          };
          type = {
            arguments = [
              {
                items = [
                  {
                    name = "type";
                    path = [
                      {
                        kind = "identifier";
                        value = "string";
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
          zenosVersion = {
            kind = "version";
            type = "literal";
            value = "1.0.0Na";
          };
        };
        path = [
          "keybindings"
          "live-alt-tab"
        ];
      }
      {
        metadata = {
          default = {
            items = [
              {
                multiline = false;
                parts = [
                  {
                    type = "text";
                    value = "<Shift><Super>Tab";
                  }
                ];
                type = "string";
              }
            ];
            type = "list";
          };
          description = {
            multiline = true;
            parts = [
              {
                type = "text";
                value = "Shortcut to cycle backward through windows";
              }
            ];
            type = "string";
          };
          type = {
            arguments = [
              {
                items = [
                  {
                    name = "type";
                    path = [
                      {
                        kind = "identifier";
                        value = "string";
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
          zenosVersion = {
            kind = "version";
            type = "literal";
            value = "1.0.0Na";
          };
        };
        path = [
          "keybindings"
          "live-alt-tab-backward"
        ];
      }
      {
        metadata = {
          default = {
            items = [
              {
                multiline = false;
                parts = [
                  {
                    type = "text";
                    value = "<Super>Escape";
                  }
                ];
                type = "string";
              }
            ];
            type = "list";
          };
          description = {
            multiline = true;
            parts = [
              {
                type = "text";
                value = "Shortcut to return to the last used workspace";
              }
            ];
            type = "string";
          };
          type = {
            arguments = [
              {
                items = [
                  {
                    name = "type";
                    path = [
                      {
                        kind = "identifier";
                        value = "string";
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
          zenosVersion = {
            kind = "version";
            type = "literal";
            value = "1.0.0Na";
          };
        };
        path = [
          "keybindings"
          "previous-workspace"
        ];
      }
      {
        metadata = {
          default = {
            items = [
              {
                multiline = false;
                parts = [
                  {
                    type = "text";
                    value = "<Super>u";
                  }
                ];
                type = "string";
              }
            ];
            type = "list";
          };
          description = {
            multiline = true;
            parts = [
              {
                type = "text";
                value = "Shortcut to move focus to the monitor on the right";
              }
            ];
            type = "string";
          };
          type = {
            arguments = [
              {
                items = [
                  {
                    name = "type";
                    path = [
                      {
                        kind = "identifier";
                        value = "string";
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
          zenosVersion = {
            kind = "version";
            type = "literal";
            value = "1.0.0Na";
          };
        };
        path = [
          "keybindings"
          "switch-monitor-right"
        ];
      }
      {
        metadata = {
          default = {
            items = [
              {
                multiline = false;
                parts = [
                  {
                    type = "text";
                    value = "<Super>i";
                  }
                ];
                type = "string";
              }
            ];
            type = "list";
          };
          description = {
            multiline = true;
            parts = [
              {
                type = "text";
                value = "Shortcut to move focus to the monitor on the left";
              }
            ];
            type = "string";
          };
          type = {
            arguments = [
              {
                items = [
                  {
                    name = "type";
                    path = [
                      {
                        kind = "identifier";
                        value = "string";
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
          zenosVersion = {
            kind = "version";
            type = "literal";
            value = "1.0.0Na";
          };
        };
        path = [
          "keybindings"
          "switch-monitor-left"
        ];
      }
      {
        metadata = {
          default = {
            items = [
              {
                multiline = false;
                parts = [
                  {
                    type = "text";
                    value = "<Shift><Super>l";
                  }
                ];
                type = "string";
              }
            ];
            type = "list";
          };
          description = {
            multiline = true;
            parts = [
              {
                type = "text";
                value = "Shortcut to move focused window to the right";
              }
            ];
            type = "string";
          };
          type = {
            arguments = [
              {
                items = [
                  {
                    name = "type";
                    path = [
                      {
                        kind = "identifier";
                        value = "string";
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
          zenosVersion = {
            kind = "version";
            type = "literal";
            value = "1.0.0Na";
          };
        };
        path = [
          "keybindings"
          "move-right"
        ];
      }
      {
        metadata = {
          default = {
            items = [
              {
                multiline = false;
                parts = [
                  {
                    type = "text";
                    value = "<Shift><Super>h";
                  }
                ];
                type = "string";
              }
            ];
            type = "list";
          };
          description = {
            multiline = true;
            parts = [
              {
                type = "text";
                value = "Shortcut to move focused window to the left";
              }
            ];
            type = "string";
          };
          type = {
            arguments = [
              {
                items = [
                  {
                    name = "type";
                    path = [
                      {
                        kind = "identifier";
                        value = "string";
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
          zenosVersion = {
            kind = "version";
            type = "literal";
            value = "1.0.0Na";
          };
        };
        path = [
          "keybindings"
          "move-left"
        ];
      }
      {
        metadata = {
          default = {
            items = [
              {
                multiline = false;
                parts = [
                  {
                    type = "text";
                    value = "<Shift><Super>k";
                  }
                ];
                type = "string";
              }
            ];
            type = "list";
          };
          description = {
            multiline = true;
            parts = [
              {
                type = "text";
                value = "Shortcut to move focused window upward (stacking)";
              }
            ];
            type = "string";
          };
          type = {
            arguments = [
              {
                items = [
                  {
                    name = "type";
                    path = [
                      {
                        kind = "identifier";
                        value = "string";
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
          zenosVersion = {
            kind = "version";
            type = "literal";
            value = "1.0.0Na";
          };
        };
        path = [
          "keybindings"
          "move-up"
        ];
      }
      {
        metadata = {
          default = {
            items = [
              {
                multiline = false;
                parts = [
                  {
                    type = "text";
                    value = "<Shift><Super>j";
                  }
                ];
                type = "string";
              }
            ];
            type = "list";
          };
          description = {
            multiline = true;
            parts = [
              {
                type = "text";
                value = "Shortcut to move focused window downward (stacking)";
              }
            ];
            type = "string";
          };
          type = {
            arguments = [
              {
                items = [
                  {
                    name = "type";
                    path = [
                      {
                        kind = "identifier";
                        value = "string";
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
          zenosVersion = {
            kind = "version";
            type = "literal";
            value = "1.0.0Na";
          };
        };
        path = [
          "keybindings"
          "move-down"
        ];
      }
      {
        metadata = {
          default = {
            items = [
              {
                multiline = false;
                parts = [
                  {
                    type = "text";
                    value = "<Super>q";
                  }
                ];
                type = "string";
              }
            ];
            type = "list";
          };
          description = {
            multiline = true;
            parts = [
              {
                type = "text";
                value = "Shortcut to close the active application window";
              }
            ];
            type = "string";
          };
          type = {
            arguments = [
              {
                items = [
                  {
                    name = "type";
                    path = [
                      {
                        kind = "identifier";
                        value = "string";
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
          zenosVersion = {
            kind = "version";
            type = "literal";
            value = "1.0.0Na";
          };
        };
        path = [
          "keybindings"
          "close-window"
        ];
      }
      {
        metadata = {
          default = {
            items = [
              {
                multiline = false;
                parts = [
                  {
                    type = "text";
                    value = "<Super>f";
                  }
                ];
                type = "string";
              }
            ];
            type = "list";
          };
          description = {
            multiline = true;
            parts = [
              {
                type = "text";
                value = "Shortcut to toggle window between current width and full ribbon width";
              }
            ];
            type = "string";
          };
          type = {
            arguments = [
              {
                items = [
                  {
                    name = "type";
                    path = [
                      {
                        kind = "identifier";
                        value = "string";
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
          zenosVersion = {
            kind = "version";
            type = "literal";
            value = "1.0.0Na";
          };
        };
        path = [
          "keybindings"
          "toggle-maximize-width"
        ];
      }
      {
        metadata = {
          default = {
            items = [
              {
                multiline = false;
                parts = [
                  {
                    type = "text";
                    value = "<Shift><Super>f";
                  }
                ];
                type = "string";
              }
            ];
            type = "list";
          };
          description = {
            multiline = true;
            parts = [
              {
                type = "text";
                value = "Shortcut to toggle window between ribbon and full screen";
              }
            ];
            type = "string";
          };
          type = {
            arguments = [
              {
                items = [
                  {
                    name = "type";
                    path = [
                      {
                        kind = "identifier";
                        value = "string";
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
          zenosVersion = {
            kind = "version";
            type = "literal";
            value = "1.0.0Na";
          };
        };
        path = [
          "keybindings"
          "paper-toggle-fullscreen"
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
                  value = "zenosVersion";
                }
              ];
              type = "assignment";
              value = {
                kind = "version";
                type = "literal";
                value = "1.0.0Na";
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
                    value = "Scrollable tiling window manager for GNOME Shell";
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
                    value = "\n    Scrollable tiling window manager for GNOME Shell\n\n    This module installs and configures the **PaperWM** extension for GNOME.\n    PaperWM implements a scrollable tiling window manager, inspired by 10/GUI concepts.\n    It arranges windows in a horizontal ribbon, allowing for efficient navigation\n    and management.\n\n    **Features:**\n    - Scrollable tiling layout.\n    - Extensive keyboard navigation.\n    - Touchpad gesture support.\n    - Customizable appearance (margins, borders, minimap).\n  ";
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
            {
              operator = "=";
              target = [
                {
                  kind = "identifier";
                  value = "platforms";
                }
              ];
              type = "assignment";
              value = {
                name = "lib";
                path = [
                  {
                    kind = "identifier";
                    value = "platforms";
                  }
                  {
                    kind = "identifier";
                    value = "zenos";
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
            value = "enable";
          }
        ];
        type = "assignment";
        value = {
          body = {
            recursive = false;
            statements = [
              {
                body = {
                  recursive = false;
                  statements = [
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
                        {
                          kind = "string";
                          value = "org/gnome/shell";
                        }
                        {
                          kind = "identifier";
                          value = "enabled-extensions";
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
                                value = "zenos";
                              }
                              {
                                kind = "identifier";
                                value = "legacy";
                              }
                              {
                                kind = "identifier";
                                value = "gnomeExtensions";
                              }
                              {
                                kind = "identifier";
                                value = "paperwm";
                              }
                              {
                                kind = "identifier";
                                value = "extensionUuid";
                              }
                            ];
                            type = "variable";
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
                          value = "description";
                        }
                      ];
                      type = "assignment";
                      value = {
                        multiline = true;
                        parts = [
                          {
                            type = "text";
                            value = "PaperWM GNOME extension configuration";
                          }
                        ];
                        type = "string";
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
                          value = "environment";
                        }
                        {
                          kind = "identifier";
                          value = "systemPackages";
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
                                value = "zenos";
                              }
                              {
                                kind = "identifier";
                                value = "legacy";
                              }
                              {
                                kind = "identifier";
                                value = "gnomeExtensions";
                              }
                              {
                                kind = "identifier";
                                value = "paperwm";
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
                                    value = "settings";
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
                                          kind = "string";
                                          value = "org/gnome/shell/extensions/paperwm";
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
                                                value = "window-gap";
                                              }
                                            ];
                                            type = "assignment";
                                            value = {
                                              name = "path";
                                              path = [
                                                {
                                                  kind = "identifier";
                                                  value = "layout";
                                                }
                                                {
                                                  kind = "identifier";
                                                  value = "window-gap";
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
                                                value = "horizontal-margin";
                                              }
                                            ];
                                            type = "assignment";
                                            value = {
                                              name = "path";
                                              path = [
                                                {
                                                  kind = "identifier";
                                                  value = "layout";
                                                }
                                                {
                                                  kind = "identifier";
                                                  value = "margins";
                                                }
                                                {
                                                  kind = "identifier";
                                                  value = "horizontal";
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
                                                value = "vertical-margin";
                                              }
                                            ];
                                            type = "assignment";
                                            value = {
                                              name = "path";
                                              path = [
                                                {
                                                  kind = "identifier";
                                                  value = "layout";
                                                }
                                                {
                                                  kind = "identifier";
                                                  value = "margins";
                                                }
                                                {
                                                  kind = "identifier";
                                                  value = "vertical";
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
                                                value = "selection-border-size";
                                              }
                                            ];
                                            type = "assignment";
                                            value = {
                                              name = "path";
                                              path = [
                                                {
                                                  kind = "identifier";
                                                  value = "layout";
                                                }
                                                {
                                                  kind = "identifier";
                                                  value = "selection-border-size";
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
                                                value = "show-minimap";
                                              }
                                            ];
                                            type = "assignment";
                                            value = {
                                              name = "path";
                                              path = [
                                                {
                                                  kind = "identifier";
                                                  value = "layout";
                                                }
                                                {
                                                  kind = "identifier";
                                                  value = "show-minimap";
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
                                                value = "focus-follows-mouse";
                                              }
                                            ];
                                            type = "assignment";
                                            value = {
                                              name = "path";
                                              path = [
                                                {
                                                  kind = "identifier";
                                                  value = "behavior";
                                                }
                                                {
                                                  kind = "identifier";
                                                  value = "focus-follows-mouse";
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
                                                value = "cycle-on-edge";
                                              }
                                            ];
                                            type = "assignment";
                                            value = {
                                              name = "path";
                                              path = [
                                                {
                                                  kind = "identifier";
                                                  value = "behavior";
                                                }
                                                {
                                                  kind = "identifier";
                                                  value = "cycle-on-edge";
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
                                                value = "use-default-overview";
                                              }
                                            ];
                                            type = "assignment";
                                            value = {
                                              name = "path";
                                              path = [
                                                {
                                                  kind = "identifier";
                                                  value = "behavior";
                                                }
                                                {
                                                  kind = "identifier";
                                                  value = "use-default-overview";
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
                                                value = "window-switcher-preview-scale";
                                              }
                                            ];
                                            type = "assignment";
                                            value = {
                                              name = "path";
                                              path = [
                                                {
                                                  kind = "identifier";
                                                  value = "previews";
                                                }
                                                {
                                                  kind = "identifier";
                                                  value = "switcher-scale";
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
                                                value = "only-scratch-in-overview";
                                              }
                                            ];
                                            type = "assignment";
                                            value = {
                                              name = "path";
                                              path = [
                                                {
                                                  kind = "identifier";
                                                  value = "previews";
                                                }
                                                {
                                                  kind = "identifier";
                                                  value = "overview";
                                                }
                                                {
                                                  kind = "identifier";
                                                  value = "only-scratch";
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
                                                value = "disable-scratch-in-overview";
                                              }
                                            ];
                                            type = "assignment";
                                            value = {
                                              name = "path";
                                              path = [
                                                {
                                                  kind = "identifier";
                                                  value = "previews";
                                                }
                                                {
                                                  kind = "identifier";
                                                  value = "overview";
                                                }
                                                {
                                                  kind = "identifier";
                                                  value = "disable-scratch";
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
                                                value = "gesture-enabled";
                                              }
                                            ];
                                            type = "assignment";
                                            value = {
                                              name = "path";
                                              path = [
                                                {
                                                  kind = "identifier";
                                                  value = "gestures";
                                                }
                                                {
                                                  kind = "identifier";
                                                  value = "enable";
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
                                                value = "gesture-horizontal-fingers";
                                              }
                                            ];
                                            type = "assignment";
                                            value = {
                                              name = "path";
                                              path = [
                                                {
                                                  kind = "identifier";
                                                  value = "gestures";
                                                }
                                                {
                                                  kind = "identifier";
                                                  value = "fingers";
                                                }
                                                {
                                                  kind = "identifier";
                                                  value = "horizontal";
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
                                                value = "gesture-workspace-fingers";
                                              }
                                            ];
                                            type = "assignment";
                                            value = {
                                              name = "path";
                                              path = [
                                                {
                                                  kind = "identifier";
                                                  value = "gestures";
                                                }
                                                {
                                                  kind = "identifier";
                                                  value = "fingers";
                                                }
                                                {
                                                  kind = "identifier";
                                                  value = "workspace";
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
                                                value = "swipe-sensitivity";
                                              }
                                            ];
                                            type = "assignment";
                                            value = {
                                              name = "path";
                                              path = [
                                                {
                                                  kind = "identifier";
                                                  value = "gestures";
                                                }
                                                {
                                                  kind = "identifier";
                                                  value = "swipe";
                                                }
                                                {
                                                  kind = "identifier";
                                                  value = "sensitivity";
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
                                                value = "swipe-friction";
                                              }
                                            ];
                                            type = "assignment";
                                            value = {
                                              name = "path";
                                              path = [
                                                {
                                                  kind = "identifier";
                                                  value = "gestures";
                                                }
                                                {
                                                  kind = "identifier";
                                                  value = "swipe";
                                                }
                                                {
                                                  kind = "identifier";
                                                  value = "friction";
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
                                          kind = "string";
                                          value = "org/gnome/shell/extensions/paperwm/keybindings";
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
                                                value = "new-window";
                                              }
                                            ];
                                            type = "assignment";
                                            value = {
                                              name = "path";
                                              path = [
                                                {
                                                  kind = "identifier";
                                                  value = "keybindings";
                                                }
                                                {
                                                  kind = "identifier";
                                                  value = "new-window";
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
                                                value = "live-alt-tab";
                                              }
                                            ];
                                            type = "assignment";
                                            value = {
                                              name = "path";
                                              path = [
                                                {
                                                  kind = "identifier";
                                                  value = "keybindings";
                                                }
                                                {
                                                  kind = "identifier";
                                                  value = "live-alt-tab";
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
                                                value = "live-alt-tab-backward";
                                              }
                                            ];
                                            type = "assignment";
                                            value = {
                                              name = "path";
                                              path = [
                                                {
                                                  kind = "identifier";
                                                  value = "keybindings";
                                                }
                                                {
                                                  kind = "identifier";
                                                  value = "live-alt-tab-backward";
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
                                                value = "previous-workspace";
                                              }
                                            ];
                                            type = "assignment";
                                            value = {
                                              name = "path";
                                              path = [
                                                {
                                                  kind = "identifier";
                                                  value = "keybindings";
                                                }
                                                {
                                                  kind = "identifier";
                                                  value = "previous-workspace";
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
                                                value = "switch-monitor-right";
                                              }
                                            ];
                                            type = "assignment";
                                            value = {
                                              name = "path";
                                              path = [
                                                {
                                                  kind = "identifier";
                                                  value = "keybindings";
                                                }
                                                {
                                                  kind = "identifier";
                                                  value = "switch-monitor-right";
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
                                                value = "switch-monitor-left";
                                              }
                                            ];
                                            type = "assignment";
                                            value = {
                                              name = "path";
                                              path = [
                                                {
                                                  kind = "identifier";
                                                  value = "keybindings";
                                                }
                                                {
                                                  kind = "identifier";
                                                  value = "switch-monitor-left";
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
                                                value = "move-right";
                                              }
                                            ];
                                            type = "assignment";
                                            value = {
                                              name = "path";
                                              path = [
                                                {
                                                  kind = "identifier";
                                                  value = "keybindings";
                                                }
                                                {
                                                  kind = "identifier";
                                                  value = "move-right";
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
                                                value = "move-left";
                                              }
                                            ];
                                            type = "assignment";
                                            value = {
                                              name = "path";
                                              path = [
                                                {
                                                  kind = "identifier";
                                                  value = "keybindings";
                                                }
                                                {
                                                  kind = "identifier";
                                                  value = "move-left";
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
                                                value = "move-up";
                                              }
                                            ];
                                            type = "assignment";
                                            value = {
                                              name = "path";
                                              path = [
                                                {
                                                  kind = "identifier";
                                                  value = "keybindings";
                                                }
                                                {
                                                  kind = "identifier";
                                                  value = "move-up";
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
                                                value = "move-down";
                                              }
                                            ];
                                            type = "assignment";
                                            value = {
                                              name = "path";
                                              path = [
                                                {
                                                  kind = "identifier";
                                                  value = "keybindings";
                                                }
                                                {
                                                  kind = "identifier";
                                                  value = "move-down";
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
                                                value = "close-window";
                                              }
                                            ];
                                            type = "assignment";
                                            value = {
                                              name = "path";
                                              path = [
                                                {
                                                  kind = "identifier";
                                                  value = "keybindings";
                                                }
                                                {
                                                  kind = "identifier";
                                                  value = "close-window";
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
                                                value = "toggle-maximize-width";
                                              }
                                            ];
                                            type = "assignment";
                                            value = {
                                              name = "path";
                                              path = [
                                                {
                                                  kind = "identifier";
                                                  value = "keybindings";
                                                }
                                                {
                                                  kind = "identifier";
                                                  value = "toggle-maximize-width";
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
                                                value = "paper-toggle-fullscreen";
                                              }
                                            ];
                                            type = "assignment";
                                            value = {
                                              name = "path";
                                              path = [
                                                {
                                                  kind = "identifier";
                                                  value = "keybindings";
                                                }
                                                {
                                                  kind = "identifier";
                                                  value = "paper-toggle-fullscreen";
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
                          }
                        ];
                        type = "list";
                      };
                    }
                  ];
                  type = "attr-set";
                };
                guards = [ ];
                scope = "system";
                type = "action";
                unconditional = false;
              }
            ];
            type = "attr-set";
          };
          type = "enable-option";
        };
      }
      {
        operator = "=";
        target = [
          {
            kind = "identifier";
            value = "layout";
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
                  value = "margins";
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
                        value = "horizontal";
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
                                  value = 20;
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
                                      value = "\n  Minimum horizontal window margin\n\n  The base pixel distance between windows and the left/right screen edges.\n";
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
                    };
                  }
                  {
                    operator = "=";
                    target = [
                      {
                        kind = "identifier";
                        value = "vertical";
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
                                  value = 20;
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
                                      value = "\n  Minimum vertical window margin\n\n  The base pixel distance between windows and the top/bottom screen edges.\n";
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
                  value = "window-gap";
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
                            value = 10;
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
                                value = "\n  Pixel spacing between tiled windows\n\n  Determines the distance between adjacent window actors in the\n  horizontal ribbon.\n";
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
              };
            }
            {
              operator = "=";
              target = [
                {
                  kind = "identifier";
                  value = "selection-border-size";
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
                            value = 4;
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
                                value = "\n  Selection indicator border width\n\n  Pixel thickness of the border drawn around the currently focused window.\n";
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
              };
            }
            {
              operator = "=";
              target = [
                {
                  kind = "identifier";
                  value = "show-minimap";
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
                                value = "bool";
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
                            kind = "true";
                            type = "literal";
                            value = true;
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
                                value = "\n  Display the navigation minimap\n\n  Whether to render the miniature overview of the window ribbon\n  at the bottom of the screen.\n";
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
            value = "behavior";
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
                  value = "focus-follows-mouse";
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
                                value = "bool";
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
                              value = "description";
                            }
                          ];
                          type = "assignment";
                          value = {
                            multiline = true;
                            parts = [
                              {
                                type = "text";
                                value = "\n  Enable focus-follows-mouse policy\n\n  When enabled, window focus automatically shifts to the actor beneath\n  the mouse cursor.\n";
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
              };
            }
            {
              operator = "=";
              target = [
                {
                  kind = "identifier";
                  value = "cycle-on-edge";
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
                                value = "bool";
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
                            kind = "true";
                            type = "literal";
                            value = true;
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
                                value = "\n  Loop navigation at ribbon edges\n\n  If enabled, navigating past the last window in a ribbon will loop back\n  to the first window.\n";
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
              };
            }
            {
              operator = "=";
              target = [
                {
                  kind = "identifier";
                  value = "use-default-overview";
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
                                value = "bool";
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
                              value = "description";
                            }
                          ];
                          type = "assignment";
                          value = {
                            multiline = true;
                            parts = [
                              {
                                type = "text";
                                value = "\n  Use standard GNOME overview\n\n  Disables PaperWM's specialized overview and uses the default\n  GNOME Shell activities view instead.\n";
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
            value = "previews";
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
                  value = "switcher-scale";
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
                                value = "float";
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
                            kind = "float";
                            type = "literal";
                            value = 0.5;
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
                                value = "\n  Scale factor for window switcher thumbnails\n\n  Determines the size of previews in the Alt-Tab and overview\n  interfaces relative to screen size.\n";
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
              };
            }
            {
              operator = "=";
              target = [
                {
                  kind = "identifier";
                  value = "overview";
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
                        value = "only-scratch";
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
                                      value = "bool";
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
                                    value = "description";
                                  }
                                ];
                                type = "assignment";
                                value = {
                                  multiline = true;
                                  parts = [
                                    {
                                      type = "text";
                                      value = "\n  Only show scratchpad windows in overview\n\n  Filters the overview to only display windows that have been\n  moved to the scratchpad area.\n";
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
                    };
                  }
                  {
                    operator = "=";
                    target = [
                      {
                        kind = "identifier";
                        value = "disable-scratch";
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
                                      value = "bool";
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
                                    value = "description";
                                  }
                                ];
                                type = "assignment";
                                value = {
                                  multiline = true;
                                  parts = [
                                    {
                                      type = "text";
                                      value = "\n  Hide scratchpad windows in overview\n\n  Completely hides windows in the scratchpad area when entering\n  the activities overview.\n";
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
            value = "gestures";
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
                  value = "enable";
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
                                value = "bool";
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
                            kind = "true";
                            type = "literal";
                            value = true;
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
                                value = "\n  Enable touchpad gesture support\n\n  Activates custom touchpad swipe gestures for navigating and\n  manipulating the window ribbon.\n";
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
              };
            }
            {
              operator = "=";
              target = [
                {
                  kind = "identifier";
                  value = "fingers";
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
                        value = "horizontal";
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
                                  value = 3;
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
                                      value = "Number of fingers for horizontal ribbon scrolling";
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
                    };
                  }
                  {
                    operator = "=";
                    target = [
                      {
                        kind = "identifier";
                        value = "workspace";
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
                                  value = 4;
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
                                      value = "Number of fingers for switching virtual workspaces";
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
                  value = "swipe";
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
                        value = "sensitivity";
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
                                      value = "float";
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
                                  kind = "float";
                                  type = "literal";
                                  value = 1.0;
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
                                      value = "Responsiveness multiplier for touch input";
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
                    };
                  }
                  {
                    operator = "=";
                    target = [
                      {
                        kind = "identifier";
                        value = "friction";
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
                                      value = "float";
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
                                  kind = "float";
                                  type = "literal";
                                  value = 1.0;
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
                                      value = "Resistance factor for swipe physics simulation";
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
            value = "keybindings";
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
                  value = "new-window";
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
                            arguments = [
                              {
                                items = [
                                  {
                                    name = "type";
                                    path = [
                                      {
                                        kind = "identifier";
                                        value = "string";
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
                            items = [
                              {
                                multiline = false;
                                parts = [
                                  {
                                    type = "text";
                                    value = "<Super>Return";
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
                              value = "description";
                            }
                          ];
                          type = "assignment";
                          value = {
                            multiline = true;
                            parts = [
                              {
                                type = "text";
                                value = "Shortcut to launch a new terminal window";
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
              };
            }
            {
              operator = "=";
              target = [
                {
                  kind = "identifier";
                  value = "live-alt-tab";
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
                            arguments = [
                              {
                                items = [
                                  {
                                    name = "type";
                                    path = [
                                      {
                                        kind = "identifier";
                                        value = "string";
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
                            items = [
                              {
                                multiline = false;
                                parts = [
                                  {
                                    type = "text";
                                    value = "<Super>Tab";
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
                              value = "description";
                            }
                          ];
                          type = "assignment";
                          value = {
                            multiline = true;
                            parts = [
                              {
                                type = "text";
                                value = "Shortcut to cycle through windows in the current ribbon";
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
              };
            }
            {
              operator = "=";
              target = [
                {
                  kind = "identifier";
                  value = "live-alt-tab-backward";
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
                            arguments = [
                              {
                                items = [
                                  {
                                    name = "type";
                                    path = [
                                      {
                                        kind = "identifier";
                                        value = "string";
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
                            items = [
                              {
                                multiline = false;
                                parts = [
                                  {
                                    type = "text";
                                    value = "<Shift><Super>Tab";
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
                              value = "description";
                            }
                          ];
                          type = "assignment";
                          value = {
                            multiline = true;
                            parts = [
                              {
                                type = "text";
                                value = "Shortcut to cycle backward through windows";
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
              };
            }
            {
              operator = "=";
              target = [
                {
                  kind = "identifier";
                  value = "previous-workspace";
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
                            arguments = [
                              {
                                items = [
                                  {
                                    name = "type";
                                    path = [
                                      {
                                        kind = "identifier";
                                        value = "string";
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
                            items = [
                              {
                                multiline = false;
                                parts = [
                                  {
                                    type = "text";
                                    value = "<Super>Escape";
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
                              value = "description";
                            }
                          ];
                          type = "assignment";
                          value = {
                            multiline = true;
                            parts = [
                              {
                                type = "text";
                                value = "Shortcut to return to the last used workspace";
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
              };
            }
            {
              operator = "=";
              target = [
                {
                  kind = "identifier";
                  value = "switch-monitor-right";
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
                            arguments = [
                              {
                                items = [
                                  {
                                    name = "type";
                                    path = [
                                      {
                                        kind = "identifier";
                                        value = "string";
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
                            items = [
                              {
                                multiline = false;
                                parts = [
                                  {
                                    type = "text";
                                    value = "<Super>u";
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
                              value = "description";
                            }
                          ];
                          type = "assignment";
                          value = {
                            multiline = true;
                            parts = [
                              {
                                type = "text";
                                value = "Shortcut to move focus to the monitor on the right";
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
              };
            }
            {
              operator = "=";
              target = [
                {
                  kind = "identifier";
                  value = "switch-monitor-left";
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
                            arguments = [
                              {
                                items = [
                                  {
                                    name = "type";
                                    path = [
                                      {
                                        kind = "identifier";
                                        value = "string";
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
                            items = [
                              {
                                multiline = false;
                                parts = [
                                  {
                                    type = "text";
                                    value = "<Super>i";
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
                              value = "description";
                            }
                          ];
                          type = "assignment";
                          value = {
                            multiline = true;
                            parts = [
                              {
                                type = "text";
                                value = "Shortcut to move focus to the monitor on the left";
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
              };
            }
            {
              operator = "=";
              target = [
                {
                  kind = "identifier";
                  value = "move-right";
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
                            arguments = [
                              {
                                items = [
                                  {
                                    name = "type";
                                    path = [
                                      {
                                        kind = "identifier";
                                        value = "string";
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
                            items = [
                              {
                                multiline = false;
                                parts = [
                                  {
                                    type = "text";
                                    value = "<Shift><Super>l";
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
                              value = "description";
                            }
                          ];
                          type = "assignment";
                          value = {
                            multiline = true;
                            parts = [
                              {
                                type = "text";
                                value = "Shortcut to move focused window to the right";
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
              };
            }
            {
              operator = "=";
              target = [
                {
                  kind = "identifier";
                  value = "move-left";
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
                            arguments = [
                              {
                                items = [
                                  {
                                    name = "type";
                                    path = [
                                      {
                                        kind = "identifier";
                                        value = "string";
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
                            items = [
                              {
                                multiline = false;
                                parts = [
                                  {
                                    type = "text";
                                    value = "<Shift><Super>h";
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
                              value = "description";
                            }
                          ];
                          type = "assignment";
                          value = {
                            multiline = true;
                            parts = [
                              {
                                type = "text";
                                value = "Shortcut to move focused window to the left";
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
              };
            }
            {
              operator = "=";
              target = [
                {
                  kind = "identifier";
                  value = "move-up";
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
                            arguments = [
                              {
                                items = [
                                  {
                                    name = "type";
                                    path = [
                                      {
                                        kind = "identifier";
                                        value = "string";
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
                            items = [
                              {
                                multiline = false;
                                parts = [
                                  {
                                    type = "text";
                                    value = "<Shift><Super>k";
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
                              value = "description";
                            }
                          ];
                          type = "assignment";
                          value = {
                            multiline = true;
                            parts = [
                              {
                                type = "text";
                                value = "Shortcut to move focused window upward (stacking)";
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
              };
            }
            {
              operator = "=";
              target = [
                {
                  kind = "identifier";
                  value = "move-down";
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
                            arguments = [
                              {
                                items = [
                                  {
                                    name = "type";
                                    path = [
                                      {
                                        kind = "identifier";
                                        value = "string";
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
                            items = [
                              {
                                multiline = false;
                                parts = [
                                  {
                                    type = "text";
                                    value = "<Shift><Super>j";
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
                              value = "description";
                            }
                          ];
                          type = "assignment";
                          value = {
                            multiline = true;
                            parts = [
                              {
                                type = "text";
                                value = "Shortcut to move focused window downward (stacking)";
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
              };
            }
            {
              operator = "=";
              target = [
                {
                  kind = "identifier";
                  value = "close-window";
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
                            arguments = [
                              {
                                items = [
                                  {
                                    name = "type";
                                    path = [
                                      {
                                        kind = "identifier";
                                        value = "string";
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
                            items = [
                              {
                                multiline = false;
                                parts = [
                                  {
                                    type = "text";
                                    value = "<Super>q";
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
                              value = "description";
                            }
                          ];
                          type = "assignment";
                          value = {
                            multiline = true;
                            parts = [
                              {
                                type = "text";
                                value = "Shortcut to close the active application window";
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
              };
            }
            {
              operator = "=";
              target = [
                {
                  kind = "identifier";
                  value = "toggle-maximize-width";
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
                            arguments = [
                              {
                                items = [
                                  {
                                    name = "type";
                                    path = [
                                      {
                                        kind = "identifier";
                                        value = "string";
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
                            items = [
                              {
                                multiline = false;
                                parts = [
                                  {
                                    type = "text";
                                    value = "<Super>f";
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
                              value = "description";
                            }
                          ];
                          type = "assignment";
                          value = {
                            multiline = true;
                            parts = [
                              {
                                type = "text";
                                value = "Shortcut to toggle window between current width and full ribbon width";
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
              };
            }
            {
              operator = "=";
              target = [
                {
                  kind = "identifier";
                  value = "paper-toggle-fullscreen";
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
                            arguments = [
                              {
                                items = [
                                  {
                                    name = "type";
                                    path = [
                                      {
                                        kind = "identifier";
                                        value = "string";
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
                            items = [
                              {
                                multiline = false;
                                parts = [
                                  {
                                    type = "text";
                                    value = "<Shift><Super>f";
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
                              value = "description";
                            }
                          ];
                          type = "assignment";
                          value = {
                            multiline = true;
                            parts = [
                              {
                                type = "text";
                                value = "Shortcut to toggle window between ribbon and full screen";
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
              };
            }
          ];
          type = "attr-set";
        };
      }
    ];
  }; }
    (lib.mkIf ((cfg.enable)) { home-manager.sharedModules = [ {
      dconf.settings."org/gnome/shell".enabled-extensions = [
        pkgs.zenos.legacy.gnomeExtensions.paperwm.extensionUuid
      ];
    } ]; })
    (lib.mkIf ((cfg.enable)) {
      environment.systemPackages = [
        pkgs.zenos.legacy.gnomeExtensions.paperwm
      ];
      programs.dconf.profiles.user.databases = [
        {
          settings = {
            "org/gnome/shell/extensions/paperwm" = {
              window-gap = cfg.layout.window-gap;
              horizontal-margin = cfg.layout.margins.horizontal;
              vertical-margin = cfg.layout.margins.vertical;
              selection-border-size = cfg.layout.selection-border-size;
              show-minimap = cfg.layout.show-minimap;
              focus-follows-mouse = cfg.behavior.focus-follows-mouse;
              cycle-on-edge = cfg.behavior.cycle-on-edge;
              use-default-overview = cfg.behavior.use-default-overview;
              window-switcher-preview-scale = cfg.previews.switcher-scale;
              only-scratch-in-overview = cfg.previews.overview.only-scratch;
              disable-scratch-in-overview = cfg.previews.overview.disable-scratch;
              gesture-enabled = cfg.gestures.enable;
              gesture-horizontal-fingers = cfg.gestures.fingers.horizontal;
              gesture-workspace-fingers = cfg.gestures.fingers.workspace;
              swipe-sensitivity = cfg.gestures.swipe.sensitivity;
              swipe-friction = cfg.gestures.swipe.friction;
            };
            "org/gnome/shell/extensions/paperwm/keybindings" = {
              new-window = cfg.keybindings.new-window;
              live-alt-tab = cfg.keybindings.live-alt-tab;
              live-alt-tab-backward = cfg.keybindings.live-alt-tab-backward;
              previous-workspace = cfg.keybindings.previous-workspace;
              switch-monitor-right = cfg.keybindings.switch-monitor-right;
              switch-monitor-left = cfg.keybindings.switch-monitor-left;
              move-right = cfg.keybindings.move-right;
              move-left = cfg.keybindings.move-left;
              move-up = cfg.keybindings.move-up;
              move-down = cfg.keybindings.move-down;
              close-window = cfg.keybindings.close-window;
              toggle-maximize-width = cfg.keybindings.toggle-maximize-width;
              paper-toggle-fullscreen = cfg.keybindings.paper-toggle-fullscreen;
            };
          };
        }
      ];
    })
  ];
}
