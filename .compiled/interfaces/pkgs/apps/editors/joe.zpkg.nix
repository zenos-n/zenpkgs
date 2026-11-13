{ ... }:
{
  dependenciesDeclared = false;
  descriptorVersion = "zenlang.semantic/2";
  grammarVersion = "1.0.0Na";
  id = "pkgs.unknown.joe";
  imports = [ ];
  irVersion = "1.0.0Na";
  kind = "zpkg";
  location = "/nix/store/3ni594f60hm22hcrazxd35dmk7pwi61m-zenpkgs-dsl-source/pkgs/apps/editors/joe.zpkg:39:8";
  metadata = {
    description = {
      multiline = true;
      parts = [
        {
          type = "text";
          value = "\n    JOE (Joe's Own Editor) is a full featured terminal-based screen editor\n    which is distributed under the GNU General Public License (GPL). JOE has\n    been around since 1988 and comes standard with many Linux distributions.\n\n    JOE is being maintained by its original author Joseph Allen, plus all of\n    the people who send bug reports, feature suggestions and patches to the\n    project web site. JOE is hosted by SourceForge.net and its source code is\n    controlled under Mercurial.\n\n    JOE is a blending of MicroPro's venerable microcomputer word processor\n    WordStar and Richard Stallman's famous LISP based text editor GNU-EMACS\n    (but it does not use code from either program): most of the basic editing\n    keys are the same as in WordStar as is the overall feel of the editor. JOE\n    also has some of the key bindings and many of the powerful features of\n    EMACS.\n\n    JOE is written in C and its only dependency is libc. This makes JOE very\n    easy to build (just \"configure\" and \"make install\"), making it feasible to\n    include on small systems and recovery disks. The compiled binary is about\n    300K in x86. Note that JOE can use either the termcap or terminfo terminal\n    capabilities databases (or a built-in termcap entry for ANSI\n    terminals). The choice is controlled by a \"configure\" option. If terminfo\n    is used, a library is required to access the database (on some systems\n    this library is ncurses, but JOE does not use curses to control the\n    terminal - it has its own code for this).\n  ";
        }
      ];
      type = "string";
    };
    id = {
      multiline = false;
      parts = [
        {
          type = "text";
          value = "unknown.joe";
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
          value = "JOE";
        }
      ];
      type = "string";
    };
    packageVersion = {
      multiline = false;
      parts = [
        {
          type = "text";
          value = "4.7";
        }
      ];
      type = "string";
    };
    summary = {
      multiline = false;
      parts = [
        {
          type = "text";
          value = "Full featured terminal-based screen editor";
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
  name = "joe";
  packageImport = {
    name = "pkgs";
    path = [
      {
        kind = "identifier";
        value = "legacy";
      }
      {
        kind = "identifier";
        value = "joe";
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
          value = "joe";
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
                  value = "unknown.joe";
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
                  value = "JOE";
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
                  value = "Full featured terminal-based screen editor";
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
                  value = "\n    JOE (Joe's Own Editor) is a full featured terminal-based screen editor\n    which is distributed under the GNU General Public License (GPL). JOE has\n    been around since 1988 and comes standard with many Linux distributions.\n\n    JOE is being maintained by its original author Joseph Allen, plus all of\n    the people who send bug reports, feature suggestions and patches to the\n    project web site. JOE is hosted by SourceForge.net and its source code is\n    controlled under Mercurial.\n\n    JOE is a blending of MicroPro's venerable microcomputer word processor\n    WordStar and Richard Stallman's famous LISP based text editor GNU-EMACS\n    (but it does not use code from either program): most of the basic editing\n    keys are the same as in WordStar as is the overall feel of the editor. JOE\n    also has some of the key bindings and many of the powerful features of\n    EMACS.\n\n    JOE is written in C and its only dependency is libc. This makes JOE very\n    easy to build (just \"configure\" and \"make install\"), making it feasible to\n    include on small systems and recovery disks. The compiled binary is about\n    300K in x86. Note that JOE can use either the termcap or terminfo terminal\n    capabilities databases (or a built-in termcap entry for ANSI\n    terminals). The choice is controlled by a \"configure\" option. If terminfo\n    is used, a library is required to access the database (on some systems\n    this library is ncurses, but JOE does not use curses to control the\n    terminal - it has its own code for this).\n  ";
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
                  value = "4.7";
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
            value = "joe";
          }
        ];
        type = "variable";
      };
      type = "package-import";
    }
  ];
  target = [
    "unknown"
    "joe"
  ];
}
