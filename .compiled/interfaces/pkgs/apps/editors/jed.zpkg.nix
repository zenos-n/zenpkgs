{ ... }:
{
  dependenciesDeclared = false;
  descriptorVersion = "zenlang.semantic/2";
  grammarVersion = "1.0.0Na";
  id = "pkgs.unknown.jed";
  imports = [ ];
  irVersion = "1.0.0Na";
  kind = "zpkg";
  location = "/nix/store/3ni594f60hm22hcrazxd35dmk7pwi61m-zenpkgs-dsl-source/pkgs/apps/editors/jed.zpkg:46:8";
  metadata = {
    description = {
      multiline = true;
      parts = [
        {
          type = "text";
          value = "\n    JED is a freely available text editor for Unix, VMS, MSDOS, OS/2, BeOS,\n    QNX, and win9X/NT platforms. Although it is a powerful editor designed for\n    use by programmers, its drop-down menu facility make it one of the\n    friendliest text editors around. Hence it is ideal for composing simple\n    email messages as well as editing complex programs in a variety of\n    computer languages.\n\n    JED makes extensive use of the S-Lang library, which endows it with the\n    powerful S-Lang scripting language. Some of its features are:\n\n    - Color syntax highlighting on color terminals, e.g., Linux console or a\n      remote color terminal via dialup (as well as Xjed)\n    - Folding support\n    - Drop-down menus on _ALL_ terminals/platforms\n    - Emulation of Emacs, EDT, Wordstar, Borland, and Brief editors\n    - Extensible in the C-like S-Lang language making the editor completely\n      customizable.\n    - Capable of reading GNU info files from within JED's info browser\n    - A variety of programming modes (with syntax highlighting) are available\n      including C, C++, FORTRAN, TeX, HTML, SH, python, IDL, DCL, NROFF...\n    - Edit TeX files with AUC-TeX style editing (BiBTeX support too)\n    - Asynchronous subprocess support allowing one to compile from within the\n      editor\n    - Built-in support for the GPM mouse driver on Linux console\n    - Abbreviation mode and Dynamic abbreviation mode\n    - 8 bit clean with mute/dead key support\n    - Supported on most Unix, VMS, OS/2, MSDOS (386+), win9X/NT, QNX, and BeOS\n      systems\n    - Rectangular cut/paste; regular expressions; incremental searches; search\n      replace across multiple files; multiple windows; multiple buffers; shell\n      modes; directory editor (dired); mail; rmail; ispell; and much, much\n      more\n  ";
        }
      ];
      type = "string";
    };
    id = {
      multiline = false;
      parts = [
        {
          type = "text";
          value = "unknown.jed";
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
          value = "JED";
        }
      ];
      type = "string";
    };
    packageVersion = {
      multiline = false;
      parts = [
        {
          type = "text";
          value = "0.99-19";
        }
      ];
      type = "string";
    };
    summary = {
      multiline = false;
      parts = [
        {
          type = "text";
          value = "Programmable text editor written around S-Lang";
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
              value = "editors";
            }
          ];
          type = "string";
        }
        {
          multiline = false;
          parts = [
            {
              type = "text";
              value = "terminal";
            }
          ];
          type = "string";
        }
        {
          multiline = false;
          parts = [
            {
              type = "text";
              value = "text";
            }
          ];
          type = "string";
        }
        {
          multiline = false;
          parts = [
            {
              type = "text";
              value = "development";
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
  name = "jed";
  packageImport = {
    name = "pkgs";
    path = [
      {
        kind = "identifier";
        value = "legacy";
      }
      {
        kind = "identifier";
        value = "jed";
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
          value = "jed";
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
                  value = "unknown.jed";
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
                  value = "JED";
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
                  value = "Programmable text editor written around S-Lang";
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
                  value = "\n    JED is a freely available text editor for Unix, VMS, MSDOS, OS/2, BeOS,\n    QNX, and win9X/NT platforms. Although it is a powerful editor designed for\n    use by programmers, its drop-down menu facility make it one of the\n    friendliest text editors around. Hence it is ideal for composing simple\n    email messages as well as editing complex programs in a variety of\n    computer languages.\n\n    JED makes extensive use of the S-Lang library, which endows it with the\n    powerful S-Lang scripting language. Some of its features are:\n\n    - Color syntax highlighting on color terminals, e.g., Linux console or a\n      remote color terminal via dialup (as well as Xjed)\n    - Folding support\n    - Drop-down menus on _ALL_ terminals/platforms\n    - Emulation of Emacs, EDT, Wordstar, Borland, and Brief editors\n    - Extensible in the C-like S-Lang language making the editor completely\n      customizable.\n    - Capable of reading GNU info files from within JED's info browser\n    - A variety of programming modes (with syntax highlighting) are available\n      including C, C++, FORTRAN, TeX, HTML, SH, python, IDL, DCL, NROFF...\n    - Edit TeX files with AUC-TeX style editing (BiBTeX support too)\n    - Asynchronous subprocess support allowing one to compile from within the\n      editor\n    - Built-in support for the GPM mouse driver on Linux console\n    - Abbreviation mode and Dynamic abbreviation mode\n    - 8 bit clean with mute/dead key support\n    - Supported on most Unix, VMS, OS/2, MSDOS (386+), win9X/NT, QNX, and BeOS\n      systems\n    - Rectangular cut/paste; regular expressions; incremental searches; search\n      replace across multiple files; multiple windows; multiple buffers; shell\n      modes; directory editor (dired); mail; rmail; ispell; and much, much\n      more\n  ";
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
                  value = "0.99-19";
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
                      value = "editors";
                    }
                  ];
                  type = "string";
                }
                {
                  multiline = false;
                  parts = [
                    {
                      type = "text";
                      value = "terminal";
                    }
                  ];
                  type = "string";
                }
                {
                  multiline = false;
                  parts = [
                    {
                      type = "text";
                      value = "text";
                    }
                  ];
                  type = "string";
                }
                {
                  multiline = false;
                  parts = [
                    {
                      type = "text";
                      value = "development";
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
            value = "jed";
          }
        ];
        type = "variable";
      };
      type = "package-import";
    }
  ];
  target = [
    "unknown"
    "jed"
  ];
}
