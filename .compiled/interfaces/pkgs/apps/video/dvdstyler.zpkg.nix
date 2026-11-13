{ ... }:
{
  dependenciesDeclared = false;
  descriptorVersion = "zenlang.semantic/2";
  grammarVersion = "1.0.0Na";
  id = "pkgs.unknown.dvdstyler";
  imports = [ ];
  irVersion = "1.0.0Na";
  kind = "zpkg";
  location = "/nix/store/3ni594f60hm22hcrazxd35dmk7pwi61m-zenpkgs-dsl-source/pkgs/apps/video/dvdstyler.zpkg:43:8";
  metadata = {
    description = {
      multiline = true;
      parts = [
        {
          type = "text";
          value = "\n    DVDStyler is a cross-platform free DVD authoring application for the\n    creation of professional-looking DVDs. It allows not only burning of video\n    files on DVD that can be played practically on any standalone DVD player,\n    but also creation of individually designed DVD menus. It is Open Source\n    Software and is completely free.\n\n    Some of its features include:\n\n    - create and burn DVD video with interactive menus\n    - design your own DVD menu or select one from the list of ready to use menu\n      templates\n    - create photo slideshow\n    - add multiple subtitle and audio tracks\n    - support of AVI, MOV, MP4, MPEG, OGG, WMV and other file formats\n    - support of MPEG-2, MPEG-4, DivX, Xvid, MP2, MP3, AC-3 and other audio and\n      video formats\n    - support of multi-core processor\n    - use MPEG and VOB files without reencoding\n    - put files with different audio/video format on one DVD (support of\n      titleset)\n    - user-friendly interface with support of drag & drop\n    - flexible menu creation on the basis of scalable vector graphic\n    - import of image file for background\n    - place buttons, text, images and other graphic objects anywhere on the menu\n      screen\n    - change the font/color and other parameters of buttons and graphic objects\n    - scale any button or graphic object\n    - copy any menu object or whole menu\n    - customize navigation using DVD scripting\n  ";
        }
      ];
      type = "string";
    };
    id = {
      multiline = false;
      parts = [
        {
          type = "text";
          value = "unknown.dvdstyler";
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
          value = "DVDStyler";
        }
      ];
      type = "string";
    };
    packageVersion = {
      multiline = false;
      parts = [
        {
          type = "text";
          value = "3.3b4";
        }
      ];
      type = "string";
    };
    summary = {
      multiline = false;
      parts = [
        {
          type = "text";
          value = "DVD authoring software";
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
              value = "video";
            }
          ];
          type = "string";
        }
        {
          multiline = false;
          parts = [
            {
              type = "text";
              value = "dvd";
            }
          ];
          type = "string";
        }
        {
          multiline = false;
          parts = [
            {
              type = "text";
              value = "authoring";
            }
          ];
          type = "string";
        }
        {
          multiline = false;
          parts = [
            {
              type = "text";
              value = "menus";
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
  name = "dvdstyler";
  packageImport = {
    name = "pkgs";
    path = [
      {
        kind = "identifier";
        value = "legacy";
      }
      {
        kind = "identifier";
        value = "dvdstyler";
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
          value = "dvdstyler";
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
                  value = "unknown.dvdstyler";
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
                  value = "DVDStyler";
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
                  value = "DVD authoring software";
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
                  value = "\n    DVDStyler is a cross-platform free DVD authoring application for the\n    creation of professional-looking DVDs. It allows not only burning of video\n    files on DVD that can be played practically on any standalone DVD player,\n    but also creation of individually designed DVD menus. It is Open Source\n    Software and is completely free.\n\n    Some of its features include:\n\n    - create and burn DVD video with interactive menus\n    - design your own DVD menu or select one from the list of ready to use menu\n      templates\n    - create photo slideshow\n    - add multiple subtitle and audio tracks\n    - support of AVI, MOV, MP4, MPEG, OGG, WMV and other file formats\n    - support of MPEG-2, MPEG-4, DivX, Xvid, MP2, MP3, AC-3 and other audio and\n      video formats\n    - support of multi-core processor\n    - use MPEG and VOB files without reencoding\n    - put files with different audio/video format on one DVD (support of\n      titleset)\n    - user-friendly interface with support of drag & drop\n    - flexible menu creation on the basis of scalable vector graphic\n    - import of image file for background\n    - place buttons, text, images and other graphic objects anywhere on the menu\n      screen\n    - change the font/color and other parameters of buttons and graphic objects\n    - scale any button or graphic object\n    - copy any menu object or whole menu\n    - customize navigation using DVD scripting\n  ";
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
                  value = "3.3b4";
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
                      value = "video";
                    }
                  ];
                  type = "string";
                }
                {
                  multiline = false;
                  parts = [
                    {
                      type = "text";
                      value = "dvd";
                    }
                  ];
                  type = "string";
                }
                {
                  multiline = false;
                  parts = [
                    {
                      type = "text";
                      value = "authoring";
                    }
                  ];
                  type = "string";
                }
                {
                  multiline = false;
                  parts = [
                    {
                      type = "text";
                      value = "menus";
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
            value = "dvdstyler";
          }
        ];
        type = "variable";
      };
      type = "package-import";
    }
  ];
  target = [
    "unknown"
    "dvdstyler"
  ];
}
