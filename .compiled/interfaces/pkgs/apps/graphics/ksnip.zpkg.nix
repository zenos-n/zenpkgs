{ ... }:
{
  dependenciesDeclared = false;
  descriptorVersion = "zenlang.semantic/2";
  grammarVersion = "1.0.0Na";
  id = "pkgs.org.ksnip.ksnip";
  imports = [ ];
  irVersion = "1.0.0Na";
  kind = "zpkg";
  location = "/nix/store/59qqzf108ga8h2qmsjizzsn2p7i889xx-zenpkgs-dsl-source/pkgs/apps/graphics/ksnip.zpkg:43:8";
  metadata = {
    description = {
      multiline = true;
      parts = [
        {
          type = "text";
          value = "\n    Features:\n\n    - Supports Linux (X11, Plasma Wayland, GNOME Wayland and xdg-desktop-portal Wayland), Windows and macOS.\n    - Screenshot of a custom rectangular area that can be drawn with mouse cursor.\n    - Screenshot of last selected rectangular area without selecting again.\n    - Screenshot of the screen/monitor where the mouse cursor is currently located.\n    - Screenshot of full-screen, including all screens/monitors.\n    - Screenshot of window that currently has focus.\n    - Screenshot of window under mouse cursor.\n    - Screenshot with or without mouse cursor.\n    - Capture mouse cursor as annotation item that can be moved and deleted.\n    - Customizable capture delay for all capture options.\n    - Upload screenshots directly to imgur.com in anonymous or user mode.\n    - Upload screenshots via custom user defined scripts.\n    - Command-line support, for capturing screenshots and saving to default location, filename and format.\n    - Filename wildcards for Year ($Y), Month ($M), Day ($D), Time ($T) and Counter (multiple # characters for number with zero-leading padding).\n    - Print screenshot or save it to PDF/PS.\n    - Annotate screenshots with pen, marker, rectangles, ellipses, texts and other tools.\n    - Annotate screenshots with stickers and add custom stickers.\n    - Obfuscate image regions with blur and pixelate.\n    - Add effects to image (Drop Shadow, Grayscale, invert color or Border).\n    - Add watermarks to captured images.\n    - Global hotkeys for capturing screenshots (currently only for Windows and X11).\n    - Tabs for screenshots and images.\n    - Open existing images via dialog, drag-and-drop or paste from clipboard.\n    - Run as single instance application (secondary instances send cli parameter to primary instance).\n    - Pin screenshots in frameless windows that stay atop other windows.\n    - User-defined actions for taking screenshot and post-processing.\n    - Many configuration options.\n  ";
        }
      ];
      type = "string";
    };
    id = {
      multiline = false;
      parts = [
        {
          type = "text";
          value = "org.ksnip.ksnip";
        }
      ];
      type = "string";
    };
    license = {
      name = "l";
      path = [
        {
          kind = "identifier";
          value = "gpl2Plus";
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
    name = {
      multiline = false;
      parts = [
        {
          type = "text";
          value = "ksnip";
        }
      ];
      type = "string";
    };
    packageVersion = {
      multiline = false;
      parts = [
        {
          type = "text";
          value = "1.10.1-unstable-2026-02-27";
        }
      ];
      type = "string";
    };
    summary = {
      multiline = false;
      parts = [
        {
          type = "text";
          value = "Cross-platform screenshot tool with many annotation features";
        }
      ];
      type = "string";
    };
    tags = {
      items = [
        {
          multiline = false;
          parts = [
            {
              type = "text";
              value = "graphics";
            }
          ];
          type = "string";
        }
        {
          multiline = false;
          parts = [
            {
              type = "text";
              value = "creativity";
            }
          ];
          type = "string";
        }
        {
          multiline = false;
          parts = [
            {
              type = "text";
              value = "screenshots";
            }
          ];
          type = "string";
        }
        {
          multiline = false;
          parts = [
            {
              type = "text";
              value = "annotation";
            }
          ];
          type = "string";
        }
      ];
      type = "list";
    };
    zenosVersion = {
      multiline = false;
      parts = [
        {
          type = "text";
          value = "1.0.0";
        }
      ];
      type = "string";
    };
  };
  name = "ksnip";
  packageImport = {
    name = "pkgs";
    path = [
      {
        kind = "identifier";
        value = "legacy";
      }
      {
        kind = "identifier";
        value = "ksnip";
      }
    ];
    type = "variable";
  };
  provider = {
    expression = {
      name = "pkgs";
      path = [
        {
          kind = "identifier";
          value = "legacy";
        }
        {
          kind = "identifier";
          value = "ksnip";
        }
      ];
      type = "variable";
    };
    kind = "import";
  };
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
                value = "id";
              }
            ];
            type = "assignment";
            value = {
              multiline = false;
              parts = [
                {
                  type = "text";
                  value = "org.ksnip.ksnip";
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
                value = "name";
              }
            ];
            type = "assignment";
            value = {
              multiline = false;
              parts = [
                {
                  type = "text";
                  value = "ksnip";
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
                value = "summary";
              }
            ];
            type = "assignment";
            value = {
              multiline = false;
              parts = [
                {
                  type = "text";
                  value = "Cross-platform screenshot tool with many annotation features";
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
                  value = "\n    Features:\n\n    - Supports Linux (X11, Plasma Wayland, GNOME Wayland and xdg-desktop-portal Wayland), Windows and macOS.\n    - Screenshot of a custom rectangular area that can be drawn with mouse cursor.\n    - Screenshot of last selected rectangular area without selecting again.\n    - Screenshot of the screen/monitor where the mouse cursor is currently located.\n    - Screenshot of full-screen, including all screens/monitors.\n    - Screenshot of window that currently has focus.\n    - Screenshot of window under mouse cursor.\n    - Screenshot with or without mouse cursor.\n    - Capture mouse cursor as annotation item that can be moved and deleted.\n    - Customizable capture delay for all capture options.\n    - Upload screenshots directly to imgur.com in anonymous or user mode.\n    - Upload screenshots via custom user defined scripts.\n    - Command-line support, for capturing screenshots and saving to default location, filename and format.\n    - Filename wildcards for Year ($Y), Month ($M), Day ($D), Time ($T) and Counter (multiple # characters for number with zero-leading padding).\n    - Print screenshot or save it to PDF/PS.\n    - Annotate screenshots with pen, marker, rectangles, ellipses, texts and other tools.\n    - Annotate screenshots with stickers and add custom stickers.\n    - Obfuscate image regions with blur and pixelate.\n    - Add effects to image (Drop Shadow, Grayscale, invert color or Border).\n    - Add watermarks to captured images.\n    - Global hotkeys for capturing screenshots (currently only for Windows and X11).\n    - Tabs for screenshots and images.\n    - Open existing images via dialog, drag-and-drop or paste from clipboard.\n    - Run as single instance application (secondary instances send cli parameter to primary instance).\n    - Pin screenshots in frameless windows that stay atop other windows.\n    - User-defined actions for taking screenshot and post-processing.\n    - Many configuration options.\n  ";
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
                value = "zenosVersion";
              }
            ];
            type = "assignment";
            value = {
              multiline = false;
              parts = [
                {
                  type = "text";
                  value = "1.0.0";
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
                value = "packageVersion";
              }
            ];
            type = "assignment";
            value = {
              multiline = false;
              parts = [
                {
                  type = "text";
                  value = "1.10.1-unstable-2026-02-27";
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
                value = "tags";
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
                      value = "graphics";
                    }
                  ];
                  type = "string";
                }
                {
                  multiline = false;
                  parts = [
                    {
                      type = "text";
                      value = "creativity";
                    }
                  ];
                  type = "string";
                }
                {
                  multiline = false;
                  parts = [
                    {
                      type = "text";
                      value = "screenshots";
                    }
                  ];
                  type = "string";
                }
                {
                  multiline = false;
                  parts = [
                    {
                      type = "text";
                      value = "annotation";
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
                  value = "gpl2Plus";
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
      package = {
        name = "pkgs";
        path = [
          {
            kind = "identifier";
            value = "legacy";
          }
          {
            kind = "identifier";
            value = "ksnip";
          }
        ];
        type = "variable";
      };
      type = "package-import";
    }
  ];
  target = [
    "org"
    "ksnip"
    "ksnip"
  ];
}
