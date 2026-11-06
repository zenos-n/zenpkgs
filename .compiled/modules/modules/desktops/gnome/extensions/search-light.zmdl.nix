{ config, lib, pkgs, maintainers ? lib.maintainers, licenses ? lib.licenses, ... }:
let
  cfg = config.zenos.desktops.gnome.extensions.search-light;
  name = "search-light";
in
{
  options.zenos.desktops.gnome.extensions.search-light = lib.mkOption { type = (lib.types.submodule ({ ... }: { options = { background-color = lib.mkOption { type = lib.types.str; default = "(0.0,0.0,0.0,0.9)"; description = "\n  Search overlay background color\n\n  GVariant tuple defining the RGBA components of the primary\n  search window background.\n"; }; blur-background = lib.mkOption { type = lib.types.bool; default = true; description = "\n  Enable background blur\n\n  Applies a gaussian blur effect to the desktop area behind the\n  search overlay.\n"; }; blur-brightness = lib.mkOption { type = lib.types.float; default = 0.6; description = "Luminance multiplier for the blurred background area"; }; blur-sigma = lib.mkOption { type = lib.types.int; default = 30; description = "Gaussian sigma value determining the strength of the blur"; }; border-color = lib.mkOption { type = lib.types.str; default = "(1.0,1.0,1.0,1.0)"; description = "\n  Search overlay border color\n\n  GVariant tuple defining the RGBA components of the overlay border.\n"; }; border-radius = lib.mkOption { type = lib.types.float; default = 0.0; description = "\n  Visual corner rounding radius\n\n  Pixel radius for the search overlay corners. Defaults to 0 for\n  sharp square corners.\n"; }; border-thickness = lib.mkOption { type = lib.types.int; default = 0; description = "\n  Search overlay border width\n\n  Pixel thickness of the border drawn around the search interface.\n"; }; currency-converter = lib.mkOption { type = lib.types.bool; default = true; description = "Enable real-time currency conversion inside the search results"; }; enable = lib.mkOption { type = lib.types.bool; default = false; description = "Search Light GNOME extension configuration"; }; entry-font-size = lib.mkOption { type = lib.types.int; default = 24; description = "Large pixel font size for the active search input field"; }; font-size = lib.mkOption { type = lib.types.int; default = 12; description = "Base pixel font size for search results and metadata"; }; monitor-count = lib.mkOption { type = lib.types.int; default = 1; description = "Internal state tracker for available system monitors"; }; popup-at-cursor-monitor = lib.mkOption { type = lib.types.bool; default = true; description = "\n  Reveal overlay at mouse location\n\n  Whether to display the search box on the monitor currently\n  containing the mouse pointer.\n"; }; preferred-monitor = lib.mkOption { type = lib.types.int; default = (-1); description = "\n  Target display index\n\n  The monitor index where the search box should appear (-1 for\n  primary monitor).\n"; }; scale-height = lib.mkOption { type = lib.types.float; default = 0.4; description = "Window height relative to the monitor height (0.0 - 1.0)"; }; scale-width = lib.mkOption { type = lib.types.float; default = 0.5; description = "Window width relative to the monitor width (0.0 - 1.0)"; }; secondary-shortcut-search = lib.mkOption { type = (lib.types.listOf lib.types.str); default = [ ]; description = "Alternative shortcut to trigger the search overlay"; }; shortcut-search = lib.mkOption { type = (lib.types.listOf lib.types.str); default = [
  "<Super>space"
]; description = "Primary keyboard shortcut to trigger the search overlay"; }; show-panel-icon = lib.mkOption { type = lib.types.bool; default = true; description = "\n  Display top bar status icon\n\n  Whether to show the Search Light icon in the GNOME panel for\n  mouse interaction.\n"; }; text-color = lib.mkOption { type = lib.types.str; default = "(1.0,1.0,1.0,1.0)"; description = "GVariant tuple defining the RGBA color of the result text"; }; unit-converter = lib.mkOption { type = lib.types.bool; default = true; description = "Enable real-time unit conversion inside the search results"; }; }; })); default = { }; };
  config = lib.mkMerge [
    { _module.args.zenlang.descriptors.desktops.gnome.extensions.search-light = {
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
            value = "\n    Spotlight-style search overlay for GNOME Shell\n\n    This module installs and configures the **Search Light** extension for GNOME.\n    It replaces the default search with a macOS Spotlight-like search overlay,\n    centered on the screen with customizable styling and shortcuts.\n\n    **Features:**\n    - Spotlight-like search interface.\n    - Customizable appearance (colors, borders, transparency, blur).\n    - Configurable keyboard shortcuts.\n    - Unit and currency converters.\n  ";
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
            value = "Spotlight-style search overlay for GNOME Shell";
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
    moduleIdentity = "zenos.desktops.gnome.extensions.search-light";
    modulePath = [
      "desktops"
      "gnome"
      "extensions"
      "search-light"
    ];
    nodeMetadata = [
      {
        metadata = {
          description = {
            multiline = true;
            parts = [
              {
                type = "text";
                value = "\n    Spotlight-style search overlay for GNOME Shell\n\n    This module installs and configures the **Search Light** extension for GNOME.\n    It replaces the default search with a macOS Spotlight-like search overlay,\n    centered on the screen with customizable styling and shortcuts.\n\n    **Features:**\n    - Spotlight-like search interface.\n    - Customizable appearance (colors, borders, transparency, blur).\n    - Configurable keyboard shortcuts.\n    - Unit and currency converters.\n  ";
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
                value = "Spotlight-style search overlay for GNOME Shell";
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
                value = "Search Light GNOME extension configuration";
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
          default = {
            kind = "float";
            type = "literal";
            value = 0.0;
          };
          description = {
            multiline = true;
            parts = [
              {
                type = "text";
                value = "\n  Visual corner rounding radius\n\n  Pixel radius for the search overlay corners. Defaults to 0 for\n  sharp square corners.\n";
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
          "border-radius"
        ];
      }
      {
        metadata = {
          default = {
            multiline = false;
            parts = [
              {
                type = "text";
                value = "(1.0,1.0,1.0,1.0)";
              }
            ];
            type = "string";
          };
          description = {
            multiline = true;
            parts = [
              {
                type = "text";
                value = "\n  Search overlay border color\n\n  GVariant tuple defining the RGBA components of the overlay border.\n";
              }
            ];
            type = "string";
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
            value = "1.0.0Na";
          };
        };
        path = [
          "border-color"
        ];
      }
      {
        metadata = {
          default = {
            kind = "integer";
            type = "literal";
            value = 0;
          };
          description = {
            multiline = true;
            parts = [
              {
                type = "text";
                value = "\n  Search overlay border width\n\n  Pixel thickness of the border drawn around the search interface.\n";
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
          "border-thickness"
        ];
      }
      {
        metadata = {
          default = {
            multiline = false;
            parts = [
              {
                type = "text";
                value = "(0.0,0.0,0.0,0.9)";
              }
            ];
            type = "string";
          };
          description = {
            multiline = true;
            parts = [
              {
                type = "text";
                value = "\n  Search overlay background color\n\n  GVariant tuple defining the RGBA components of the primary\n  search window background.\n";
              }
            ];
            type = "string";
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
            value = "1.0.0Na";
          };
        };
        path = [
          "background-color"
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
                value = "Window width relative to the monitor width (0.0 - 1.0)";
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
          "scale-width"
        ];
      }
      {
        metadata = {
          default = {
            kind = "float";
            type = "literal";
            value = 0.4;
          };
          description = {
            multiline = true;
            parts = [
              {
                type = "text";
                value = "Window height relative to the monitor height (0.0 - 1.0)";
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
          "scale-height"
        ];
      }
      {
        metadata = {
          default = {
            operand = {
              kind = "integer";
              type = "literal";
              value = 1;
            };
            operator = "-";
            type = "unary";
          };
          description = {
            multiline = true;
            parts = [
              {
                type = "text";
                value = "\n  Target display index\n\n  The monitor index where the search box should appear (-1 for\n  primary monitor).\n";
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
          "preferred-monitor"
        ];
      }
      {
        metadata = {
          default = {
            kind = "integer";
            type = "literal";
            value = 1;
          };
          description = {
            multiline = true;
            parts = [
              {
                type = "text";
                value = "Internal state tracker for available system monitors";
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
          "monitor-count"
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
                    value = "<Super>space";
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
                value = "Primary keyboard shortcut to trigger the search overlay";
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
          "shortcut-search"
        ];
      }
      {
        metadata = {
          default = {
            items = [ ];
            type = "list";
          };
          description = {
            multiline = true;
            parts = [
              {
                type = "text";
                value = "Alternative shortcut to trigger the search overlay";
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
          "secondary-shortcut-search"
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
                value = "\n  Reveal overlay at mouse location\n\n  Whether to display the search box on the monitor currently\n  containing the mouse pointer.\n";
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
          "popup-at-cursor-monitor"
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
                value = "\n  Enable background blur\n\n  Applies a gaussian blur effect to the desktop area behind the\n  search overlay.\n";
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
          "blur-background"
        ];
      }
      {
        metadata = {
          default = {
            kind = "integer";
            type = "literal";
            value = 30;
          };
          description = {
            multiline = true;
            parts = [
              {
                type = "text";
                value = "Gaussian sigma value determining the strength of the blur";
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
          "blur-sigma"
        ];
      }
      {
        metadata = {
          default = {
            kind = "float";
            type = "literal";
            value = 0.6;
          };
          description = {
            multiline = true;
            parts = [
              {
                type = "text";
                value = "Luminance multiplier for the blurred background area";
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
          "blur-brightness"
        ];
      }
      {
        metadata = {
          default = {
            kind = "integer";
            type = "literal";
            value = 12;
          };
          description = {
            multiline = true;
            parts = [
              {
                type = "text";
                value = "Base pixel font size for search results and metadata";
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
          "font-size"
        ];
      }
      {
        metadata = {
          default = {
            kind = "integer";
            type = "literal";
            value = 24;
          };
          description = {
            multiline = true;
            parts = [
              {
                type = "text";
                value = "Large pixel font size for the active search input field";
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
          "entry-font-size"
        ];
      }
      {
        metadata = {
          default = {
            multiline = false;
            parts = [
              {
                type = "text";
                value = "(1.0,1.0,1.0,1.0)";
              }
            ];
            type = "string";
          };
          description = {
            multiline = true;
            parts = [
              {
                type = "text";
                value = "GVariant tuple defining the RGBA color of the result text";
              }
            ];
            type = "string";
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
            value = "1.0.0Na";
          };
        };
        path = [
          "text-color"
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
                value = "\n  Display top bar status icon\n\n  Whether to show the Search Light icon in the GNOME panel for\n  mouse interaction.\n";
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
          "show-panel-icon"
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
                value = "Enable real-time unit conversion inside the search results";
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
          "unit-converter"
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
                value = "Enable real-time currency conversion inside the search results";
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
          "currency-converter"
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
                    value = "Spotlight-style search overlay for GNOME Shell";
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
                    value = "\n    Spotlight-style search overlay for GNOME Shell\n\n    This module installs and configures the **Search Light** extension for GNOME.\n    It replaces the default search with a macOS Spotlight-like search overlay,\n    centered on the screen with customizable styling and shortcuts.\n\n    **Features:**\n    - Spotlight-like search interface.\n    - Customizable appearance (colors, borders, transparency, blur).\n    - Configurable keyboard shortcuts.\n    - Unit and currency converters.\n  ";
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
                                value = "search-light";
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
                            value = "Search Light GNOME extension configuration";
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
                                value = "search-light";
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
                                  {
                                    kind = "string";
                                    value = "org/gnome/shell/extensions/search-light";
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
                                          value = "border-radius";
                                        }
                                      ];
                                      type = "assignment";
                                      value = {
                                        name = "path";
                                        path = [
                                          {
                                            kind = "identifier";
                                            value = "border-radius";
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
                                          value = "border-color";
                                        }
                                      ];
                                      type = "assignment";
                                      value = {
                                        name = "path";
                                        path = [
                                          {
                                            kind = "identifier";
                                            value = "border-color";
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
                                          value = "border-thickness";
                                        }
                                      ];
                                      type = "assignment";
                                      value = {
                                        name = "path";
                                        path = [
                                          {
                                            kind = "identifier";
                                            value = "border-thickness";
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
                                          value = "background-color";
                                        }
                                      ];
                                      type = "assignment";
                                      value = {
                                        name = "path";
                                        path = [
                                          {
                                            kind = "identifier";
                                            value = "background-color";
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
                                          value = "scale-width";
                                        }
                                      ];
                                      type = "assignment";
                                      value = {
                                        name = "path";
                                        path = [
                                          {
                                            kind = "identifier";
                                            value = "scale-width";
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
                                          value = "scale-height";
                                        }
                                      ];
                                      type = "assignment";
                                      value = {
                                        name = "path";
                                        path = [
                                          {
                                            kind = "identifier";
                                            value = "scale-height";
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
                                          value = "preferred-monitor";
                                        }
                                      ];
                                      type = "assignment";
                                      value = {
                                        name = "path";
                                        path = [
                                          {
                                            kind = "identifier";
                                            value = "preferred-monitor";
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
                                          value = "monitor-count";
                                        }
                                      ];
                                      type = "assignment";
                                      value = {
                                        name = "path";
                                        path = [
                                          {
                                            kind = "identifier";
                                            value = "monitor-count";
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
                                          value = "shortcut-search";
                                        }
                                      ];
                                      type = "assignment";
                                      value = {
                                        name = "path";
                                        path = [
                                          {
                                            kind = "identifier";
                                            value = "shortcut-search";
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
                                          value = "secondary-shortcut-search";
                                        }
                                      ];
                                      type = "assignment";
                                      value = {
                                        name = "path";
                                        path = [
                                          {
                                            kind = "identifier";
                                            value = "secondary-shortcut-search";
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
                                          value = "popup-at-cursor-monitor";
                                        }
                                      ];
                                      type = "assignment";
                                      value = {
                                        name = "path";
                                        path = [
                                          {
                                            kind = "identifier";
                                            value = "popup-at-cursor-monitor";
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
                                          value = "blur-background";
                                        }
                                      ];
                                      type = "assignment";
                                      value = {
                                        name = "path";
                                        path = [
                                          {
                                            kind = "identifier";
                                            value = "blur-background";
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
                                          value = "blur-sigma";
                                        }
                                      ];
                                      type = "assignment";
                                      value = {
                                        name = "path";
                                        path = [
                                          {
                                            kind = "identifier";
                                            value = "blur-sigma";
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
                                          value = "blur-brightness";
                                        }
                                      ];
                                      type = "assignment";
                                      value = {
                                        name = "path";
                                        path = [
                                          {
                                            kind = "identifier";
                                            value = "blur-brightness";
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
                                          value = "font-size";
                                        }
                                      ];
                                      type = "assignment";
                                      value = {
                                        name = "path";
                                        path = [
                                          {
                                            kind = "identifier";
                                            value = "font-size";
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
                                          value = "entry-font-size";
                                        }
                                      ];
                                      type = "assignment";
                                      value = {
                                        name = "path";
                                        path = [
                                          {
                                            kind = "identifier";
                                            value = "entry-font-size";
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
                                          value = "text-color";
                                        }
                                      ];
                                      type = "assignment";
                                      value = {
                                        name = "path";
                                        path = [
                                          {
                                            kind = "identifier";
                                            value = "text-color";
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
                                          value = "show-panel-icon";
                                        }
                                      ];
                                      type = "assignment";
                                      value = {
                                        name = "path";
                                        path = [
                                          {
                                            kind = "identifier";
                                            value = "show-panel-icon";
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
                                          value = "unit-converter";
                                        }
                                      ];
                                      type = "assignment";
                                      value = {
                                        name = "path";
                                        path = [
                                          {
                                            kind = "identifier";
                                            value = "unit-converter";
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
                                          value = "currency-converter";
                                        }
                                      ];
                                      type = "assignment";
                                      value = {
                                        name = "path";
                                        path = [
                                          {
                                            kind = "identifier";
                                            value = "currency-converter";
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
            value = "border-radius";
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
                      value = 0.0;
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
                          value = "\n  Visual corner rounding radius\n\n  Pixel radius for the search overlay corners. Defaults to 0 for\n  sharp square corners.\n";
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
            value = "border-color";
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
                          value = "(1.0,1.0,1.0,1.0)";
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
                          value = "\n  Search overlay border color\n\n  GVariant tuple defining the RGBA components of the overlay border.\n";
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
            value = "border-thickness";
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
                      value = 0;
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
                          value = "\n  Search overlay border width\n\n  Pixel thickness of the border drawn around the search interface.\n";
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
            value = "background-color";
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
                          value = "(0.0,0.0,0.0,0.9)";
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
                          value = "\n  Search overlay background color\n\n  GVariant tuple defining the RGBA components of the primary\n  search window background.\n";
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
            value = "scale-width";
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
                          value = "Window width relative to the monitor width (0.0 - 1.0)";
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
            value = "scale-height";
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
                      value = 0.4;
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
                          value = "Window height relative to the monitor height (0.0 - 1.0)";
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
            value = "preferred-monitor";
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
                      operand = {
                        kind = "integer";
                        type = "literal";
                        value = 1;
                      };
                      operator = "-";
                      type = "unary";
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
                          value = "\n  Target display index\n\n  The monitor index where the search box should appear (-1 for\n  primary monitor).\n";
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
            value = "monitor-count";
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
                      value = 1;
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
                          value = "Internal state tracker for available system monitors";
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
            value = "shortcut-search";
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
                              value = "<Super>space";
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
                          value = "Primary keyboard shortcut to trigger the search overlay";
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
            value = "secondary-shortcut-search";
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
                      items = [ ];
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
                          value = "Alternative shortcut to trigger the search overlay";
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
            value = "popup-at-cursor-monitor";
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
                          value = "\n  Reveal overlay at mouse location\n\n  Whether to display the search box on the monitor currently\n  containing the mouse pointer.\n";
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
            value = "blur-background";
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
                          value = "\n  Enable background blur\n\n  Applies a gaussian blur effect to the desktop area behind the\n  search overlay.\n";
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
            value = "blur-sigma";
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
                      value = 30;
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
                          value = "Gaussian sigma value determining the strength of the blur";
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
            value = "blur-brightness";
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
                      value = 0.6;
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
                          value = "Luminance multiplier for the blurred background area";
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
            value = "font-size";
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
                      value = 12;
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
                          value = "Base pixel font size for search results and metadata";
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
            value = "entry-font-size";
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
                      value = 24;
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
                          value = "Large pixel font size for the active search input field";
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
            value = "text-color";
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
                          value = "(1.0,1.0,1.0,1.0)";
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
                          value = "GVariant tuple defining the RGBA color of the result text";
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
            value = "show-panel-icon";
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
                          value = "\n  Display top bar status icon\n\n  Whether to show the Search Light icon in the GNOME panel for\n  mouse interaction.\n";
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
            value = "unit-converter";
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
                          value = "Enable real-time unit conversion inside the search results";
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
            value = "currency-converter";
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
                          value = "Enable real-time currency conversion inside the search results";
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
  }; }
    (lib.mkIf ((cfg.enable)) { home-manager.sharedModules = [ {
      dconf.settings."org/gnome/shell".enabled-extensions = [
        pkgs.zenos.legacy.gnomeExtensions.search-light.extensionUuid
      ];
    } ]; })
    (lib.mkIf ((cfg.enable)) {
      environment.systemPackages = [
        pkgs.zenos.legacy.gnomeExtensions.search-light
      ];
      programs.dconf.profiles.user.databases = [
        {
          settings."org/gnome/shell/extensions/search-light" = {
            border-radius = cfg.border-radius;
            border-color = cfg.border-color;
            border-thickness = cfg.border-thickness;
            background-color = cfg.background-color;
            scale-width = cfg.scale-width;
            scale-height = cfg.scale-height;
            preferred-monitor = cfg.preferred-monitor;
            monitor-count = cfg.monitor-count;
            shortcut-search = cfg.shortcut-search;
            secondary-shortcut-search = cfg.secondary-shortcut-search;
            popup-at-cursor-monitor = cfg.popup-at-cursor-monitor;
            blur-background = cfg.blur-background;
            blur-sigma = cfg.blur-sigma;
            blur-brightness = cfg.blur-brightness;
            font-size = cfg.font-size;
            entry-font-size = cfg.entry-font-size;
            text-color = cfg.text-color;
            show-panel-icon = cfg.show-panel-icon;
            unit-converter = cfg.unit-converter;
            currency-converter = cfg.currency-converter;
          };
        }
      ];
    })
  ];
}
