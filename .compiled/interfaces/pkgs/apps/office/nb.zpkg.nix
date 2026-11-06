{ ... }:
{
  dependenciesDeclared = false;
  descriptorVersion = "zenlang.semantic/2";
  grammarVersion = "1.0.0Na";
  id = "pkgs.unknown.nb";
  imports = [ ];
  irVersion = "1.0.0Na";
  kind = "zpkg";
  location = "/nix/store/59qqzf108ga8h2qmsjizzsn2p7i889xx-zenpkgs-dsl-source/pkgs/apps/office/nb.zpkg:44:8";
  metadata = {
    description = {
      multiline = true;
      parts = [
        {
          type = "text";
          value = "\n    `nb` creates notes in text-based formats like Markdown, Emacs Org mode,\n    and LaTeX, can work with files in any format, can import and export notes\n    to many document formats, and can create private, password-protected\n    encrypted notes and bookmarks. With `nb`, you can write notes using Vim,\n    Emacs, VS Code, Sublime Text, and any other text editor you like. `nb`\n    works in any standard Linux / Unix environment, including macOS and\n    Windows via WSL. Optional dependencies can be installed to enhance\n    functionality, but `nb` works great without them.\n\n    `nb` is also a powerful text-based CLI bookmarking system. Page\n    information is automatically downloaded, compiled, and saved into normal\n    Markdown documents made for humans, so bookmarks are easy to edit just\n    like any other note.\n\n    `nb` uses Git in the background to automatically record changes and sync\n    notebooks with remote repositories. `nb` can also be configured to sync\n    notebooks using a general purpose syncing utility like Dropbox so notes\n    can be edited in other apps on any device.\n\n    `nb` is designed to be portable, future-focused, and vendor independent,\n    providing a full-featured and intuitive experience within a highly\n    composable user-centric text interface. The entire program is a single\n    well-tested shell script that can be installed, copied, or curled almost\n    anywhere and just work, using progressive enhancement for various\n    experience improvements in more capable environments. `nb` works great\n    whether you have one notebook with just a few notes or dozens of\n    notebooks containing thousands of notes, bookmarks, and other items. `nb`\n    makes it easy to incorporate other tools, writing apps, and workflows.\n    `nb` can be used a little, a lot, once in a while, or for just a subset\n    of features. `nb` is flexible.\n  ";
        }
      ];
      type = "string";
    };
    id = {
      multiline = false;
      parts = [
        {
          type = "text";
          value = "unknown.nb";
        }
      ];
      type = "string";
    };
    license = {
      name = "l";
      path = [
        {
          kind = "identifier";
          value = "agpl3Plus";
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
          value = "nb";
        }
      ];
      type = "string";
    };
    packageVersion = {
      multiline = false;
      parts = [
        {
          type = "text";
          value = "7.25.4";
        }
      ];
      type = "string";
    };
    summary = {
      multiline = false;
      parts = [
        {
          type = "text";
          value = "Command line note-taking, bookmarking, archiving, and knowledge base application";
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
              value = "office";
            }
          ];
          type = "string";
        }
        {
          multiline = false;
          parts = [
            {
              type = "text";
              value = "productivity";
            }
          ];
          type = "string";
        }
        {
          multiline = false;
          parts = [
            {
              type = "text";
              value = "notes";
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
  name = "nb";
  packageImport = {
    name = "pkgs";
    path = [
      {
        kind = "identifier";
        value = "legacy";
      }
      {
        kind = "identifier";
        value = "nb";
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
          value = "nb";
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
                  value = "unknown.nb";
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
                  value = "nb";
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
                  value = "Command line note-taking, bookmarking, archiving, and knowledge base application";
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
                  value = "\n    `nb` creates notes in text-based formats like Markdown, Emacs Org mode,\n    and LaTeX, can work with files in any format, can import and export notes\n    to many document formats, and can create private, password-protected\n    encrypted notes and bookmarks. With `nb`, you can write notes using Vim,\n    Emacs, VS Code, Sublime Text, and any other text editor you like. `nb`\n    works in any standard Linux / Unix environment, including macOS and\n    Windows via WSL. Optional dependencies can be installed to enhance\n    functionality, but `nb` works great without them.\n\n    `nb` is also a powerful text-based CLI bookmarking system. Page\n    information is automatically downloaded, compiled, and saved into normal\n    Markdown documents made for humans, so bookmarks are easy to edit just\n    like any other note.\n\n    `nb` uses Git in the background to automatically record changes and sync\n    notebooks with remote repositories. `nb` can also be configured to sync\n    notebooks using a general purpose syncing utility like Dropbox so notes\n    can be edited in other apps on any device.\n\n    `nb` is designed to be portable, future-focused, and vendor independent,\n    providing a full-featured and intuitive experience within a highly\n    composable user-centric text interface. The entire program is a single\n    well-tested shell script that can be installed, copied, or curled almost\n    anywhere and just work, using progressive enhancement for various\n    experience improvements in more capable environments. `nb` works great\n    whether you have one notebook with just a few notes or dozens of\n    notebooks containing thousands of notes, bookmarks, and other items. `nb`\n    makes it easy to incorporate other tools, writing apps, and workflows.\n    `nb` can be used a little, a lot, once in a while, or for just a subset\n    of features. `nb` is flexible.\n  ";
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
                  value = "7.25.4";
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
                      value = "office";
                    }
                  ];
                  type = "string";
                }
                {
                  multiline = false;
                  parts = [
                    {
                      type = "text";
                      value = "productivity";
                    }
                  ];
                  type = "string";
                }
                {
                  multiline = false;
                  parts = [
                    {
                      type = "text";
                      value = "notes";
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
                  value = "agpl3Plus";
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
            value = "nb";
          }
        ];
        type = "variable";
      };
      type = "package-import";
    }
  ];
  target = [
    "unknown"
    "nb"
  ];
}
