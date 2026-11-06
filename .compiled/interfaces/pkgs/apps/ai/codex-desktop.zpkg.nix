{ ... }:
{
  dependenciesDeclared = false;
  descriptorVersion = "zenlang.semantic/2";
  grammarVersion = "1.0.0Na";
  id = "pkgs.com.openai.codex.desktop";
  imports = [ ];
  irVersion = "1.0.0Na";
  kind = "zpkg";
  location = "/nix/store/59qqzf108ga8h2qmsjizzsn2p7i889xx-zenpkgs-dsl-source/pkgs/apps/ai/codex-desktop.zpkg:19:9";
  metadata = {
    description = {
      multiline = true;
      parts = [
        {
          type = "text";
          value = "\n    Official Linux desktop application from OpenAI, currently branded ChatGPT.\n    Includes the Codex workspace, integrated terminal, local projects, and bundled\n    Codex helpers. Packaged from the versioned upstream Debian release for NixOS.\n    Use `codex-desktop` or `chatgpt` to launch it. The separate `codex` package\n    provides the terminal CLI.\n  ";
        }
      ];
      type = "string";
    };
    id = {
      multiline = false;
      parts = [
        {
          type = "text";
          value = "com.openai.codex.desktop";
        }
      ];
      type = "string";
    };
    license = {
      name = "l";
      path = [
        {
          kind = "identifier";
          value = "unfree";
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
          value = "Codex Desktop";
        }
      ];
      type = "string";
    };
    packageVersion = {
      multiline = false;
      parts = [
        {
          type = "text";
          value = "26.1016.61520";
        }
      ];
      type = "string";
    };
    summary = {
      multiline = false;
      parts = [
        {
          type = "text";
          value = "Official OpenAI desktop app with Codex and ChatGPT";
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
              value = "ai";
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
        {
          multiline = false;
          parts = [
            {
              type = "text";
              value = "coding";
            }
          ];
          type = "string";
        }
        {
          multiline = false;
          parts = [
            {
              type = "text";
              value = "desktop";
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
  name = "codex-desktop";
  provider = {
    expression = {
      body = {
        arguments = [
          {
            recursive = false;
            statements = [
              {
                operator = "=";
                target = [
                  {
                    kind = "identifier";
                    value = "pname";
                  }
                ];
                type = "assignment";
                value = {
                  multiline = false;
                  parts = [
                    {
                      type = "text";
                      value = "codex-desktop";
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
                    value = "version";
                  }
                ];
                type = "assignment";
                value = {
                  multiline = false;
                  parts = [
                    {
                      type = "text";
                      value = "26.1016.61520";
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
                    value = "src";
                  }
                ];
                type = "assignment";
                value = {
                  arguments = [
                    {
                      recursive = false;
                      statements = [
                        {
                          operator = "=";
                          target = [
                            {
                              kind = "identifier";
                              value = "url";
                            }
                          ];
                          type = "assignment";
                          value = {
                            multiline = false;
                            parts = [
                              {
                                type = "text";
                                value = "https://persistent.oaistatic.com/codex-app-prod/linux/deb/pool/main/c/chatgpt/chatgpt_26.1016.61520_amd64.deb";
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
                              value = "hash";
                            }
                          ];
                          type = "assignment";
                          value = {
                            multiline = false;
                            parts = [
                              {
                                type = "text";
                                value = "sha256-mt1iKRbF+jhhr9lQga934lSIwQjKnFQ+H2dWCzkNKNQ=";
                              }
                            ];
                            type = "string";
                          };
                        }
                      ];
                      type = "attr-set";
                    }
                  ];
                  callee = {
                    path = [
                      {
                        kind = "identifier";
                        value = "packageSet";
                      }
                      {
                        kind = "identifier";
                        value = "fetchurl";
                      }
                    ];
                    type = "reference";
                  };
                  type = "call";
                };
              }
              {
                operator = "=";
                target = [
                  {
                    kind = "identifier";
                    value = "nativeBuildInputs";
                  }
                ];
                type = "assignment";
                value = {
                  items = [
                    {
                      path = [
                        {
                          kind = "identifier";
                          value = "packageSet";
                        }
                        {
                          kind = "identifier";
                          value = "autoPatchelfHook";
                        }
                      ];
                      type = "reference";
                    }
                    {
                      path = [
                        {
                          kind = "identifier";
                          value = "packageSet";
                        }
                        {
                          kind = "identifier";
                          value = "dpkg";
                        }
                      ];
                      type = "reference";
                    }
                    {
                      path = [
                        {
                          kind = "identifier";
                          value = "packageSet";
                        }
                        {
                          kind = "identifier";
                          value = "makeWrapper";
                        }
                      ];
                      type = "reference";
                    }
                    {
                      path = [
                        {
                          kind = "identifier";
                          value = "packageSet";
                        }
                        {
                          kind = "identifier";
                          value = "wrapGAppsHook3";
                        }
                      ];
                      type = "reference";
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
                    value = "buildInputs";
                  }
                ];
                type = "assignment";
                value = {
                  path = [
                    {
                      kind = "identifier";
                      value = "runtimeLibraries";
                    }
                  ];
                  type = "reference";
                };
              }
              {
                operator = "=";
                target = [
                  {
                    kind = "identifier";
                    value = "runtimeDependencies";
                  }
                ];
                type = "assignment";
                value = {
                  path = [
                    {
                      kind = "identifier";
                      value = "runtimeLibraries";
                    }
                  ];
                  type = "reference";
                };
              }
              {
                operator = "=";
                target = [
                  {
                    kind = "identifier";
                    value = "dontConfigure";
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
                    value = "dontBuild";
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
                    value = "dontStrip";
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
                    value = "dontWrapGApps";
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
                    value = "unpackPhase";
                  }
                ];
                type = "assignment";
                value = {
                  multiline = true;
                  parts = [
                    {
                      type = "text";
                      value = "\n    runHook preUnpack\n    dpkg-deb --fsys-tarfile \"$src\" | tar --extract --no-same-owner --no-same-permissions\n    runHook postUnpack\n  ";
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
                    value = "installPhase";
                  }
                ];
                type = "assignment";
                value = {
                  multiline = true;
                  parts = [
                    {
                      type = "text";
                      value = "\n    runHook preInstall\n    mkdir -p \"$out/lib\" \"$out/share\"\n    cp -a usr/lib/chatgpt \"$out/lib/codex-desktop\"\n    cp -a usr/share/applications usr/share/pixmaps usr/share/metainfo \"$out/share/\"\n    install -Dm644 usr/share/doc/chatgpt/copyright \"$out/share/doc/codex-desktop/copyright\"\n\n    # These prebuilds target musl; Electron on NixOS uses the glibc variants.\n    find \"$out/lib/codex-desktop\" -type f -name '*musl*.node' -delete\n    find \"$out/lib/codex-desktop\" -type d -name '*-musl' -prune -exec rm -rf {} +\n    rm \"$out/lib/codex-desktop/resources/rg\"\n    ln -s ";
                    }
                    {
                      expression = {
                        path = [
                          {
                            kind = "identifier";
                            value = "packageSet";
                          }
                          {
                            kind = "identifier";
                            value = "ripgrep";
                          }
                        ];
                        type = "reference";
                      };
                      type = "interpolation";
                    }
                    {
                      type = "text";
                      value = "/bin/rg \"$out/lib/codex-desktop/resources/rg\"\n    runHook postInstall\n  ";
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
                    value = "preFixup";
                  }
                ];
                type = "assignment";
                value = {
                  multiline = true;
                  parts = [
                    {
                      type = "text";
                      value = "\n    addAutoPatchelfSearchPath \"$out/lib/codex-desktop\"\n    gappsWrapperArgs+=(\n      --prefix PATH : ";
                    }
                    {
                      expression = {
                        arguments = [
                          {
                            items = [
                              {
                                path = [
                                  {
                                    kind = "identifier";
                                    value = "packageSet";
                                  }
                                  {
                                    kind = "identifier";
                                    value = "bubblewrap";
                                  }
                                ];
                                type = "reference";
                              }
                              {
                                path = [
                                  {
                                    kind = "identifier";
                                    value = "packageSet";
                                  }
                                  {
                                    kind = "identifier";
                                    value = "git";
                                  }
                                ];
                                type = "reference";
                              }
                              {
                                path = [
                                  {
                                    kind = "identifier";
                                    value = "packageSet";
                                  }
                                  {
                                    kind = "identifier";
                                    value = "glib";
                                  }
                                ];
                                type = "reference";
                              }
                              {
                                path = [
                                  {
                                    kind = "identifier";
                                    value = "packageSet";
                                  }
                                  {
                                    kind = "identifier";
                                    value = "ripgrep";
                                  }
                                ];
                                type = "reference";
                              }
                              {
                                path = [
                                  {
                                    kind = "identifier";
                                    value = "packageSet";
                                  }
                                  {
                                    kind = "identifier";
                                    value = "trash-cli";
                                  }
                                ];
                                type = "reference";
                              }
                              {
                                path = [
                                  {
                                    kind = "identifier";
                                    value = "packageSet";
                                  }
                                  {
                                    kind = "identifier";
                                    value = "xdg-utils";
                                  }
                                ];
                                type = "reference";
                              }
                              {
                                path = [
                                  {
                                    kind = "identifier";
                                    value = "packageSet";
                                  }
                                  {
                                    kind = "identifier";
                                    value = "xz";
                                  }
                                ];
                                type = "reference";
                              }
                            ];
                            type = "list";
                          }
                        ];
                        callee = {
                          path = [
                            {
                              kind = "identifier";
                              value = "packageSet";
                            }
                            {
                              kind = "identifier";
                              value = "lib";
                            }
                            {
                              kind = "identifier";
                              value = "makeBinPath";
                            }
                          ];
                          type = "reference";
                        };
                        type = "call";
                      };
                      type = "interpolation";
                    }
                    {
                      type = "text";
                      value = "\n    )\n  ";
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
                    value = "postFixup";
                  }
                ];
                type = "assignment";
                value = {
                  multiline = true;
                  parts = [
                    {
                      type = "text";
                      value = "\n    mkdir -p \"$out/bin\"\n    makeWrapper \"$out/lib/codex-desktop/ChatGPT\" \"$out/bin/codex-desktop\" \\\n      \"\${gappsWrapperArgs[@]}\"\n    ln -s codex-desktop \"$out/bin/chatgpt\"\n    substituteInPlace \"$out/share/applications/chatgpt.desktop\" \\\n      --replace-fail 'Exec=chatgpt %U' \"Exec=$out/bin/codex-desktop %U\"\n  ";
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
                    value = "meta";
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
                        multiline = false;
                        parts = [
                          {
                            type = "text";
                            value = "Official OpenAI desktop app with Codex (currently branded ChatGPT)";
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
                          value = "homepage";
                        }
                      ];
                      type = "assignment";
                      value = {
                        multiline = false;
                        parts = [
                          {
                            type = "text";
                            value = "https://developers.openai.com/codex/app";
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
                          value = "license";
                        }
                      ];
                      type = "assignment";
                      value = {
                        path = [
                          {
                            kind = "identifier";
                            value = "packageSet";
                          }
                          {
                            kind = "identifier";
                            value = "lib";
                          }
                          {
                            kind = "identifier";
                            value = "licenses";
                          }
                          {
                            kind = "identifier";
                            value = "unfree";
                          }
                        ];
                        type = "reference";
                      };
                    }
                    {
                      operator = "=";
                      target = [
                        {
                          kind = "identifier";
                          value = "mainProgram";
                        }
                      ];
                      type = "assignment";
                      value = {
                        multiline = false;
                        parts = [
                          {
                            type = "text";
                            value = "codex-desktop";
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
                          value = "platforms";
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
                                value = "x86_64-linux";
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
                          value = "sourceProvenance";
                        }
                      ];
                      type = "assignment";
                      value = {
                        items = [
                          {
                            path = [
                              {
                                kind = "identifier";
                                value = "packageSet";
                              }
                              {
                                kind = "identifier";
                                value = "lib";
                              }
                              {
                                kind = "identifier";
                                value = "sourceTypes";
                              }
                              {
                                kind = "identifier";
                                value = "binaryNativeCode";
                              }
                            ];
                            type = "reference";
                          }
                        ];
                        type = "list";
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
        callee = {
          path = [
            {
              kind = "identifier";
              value = "packageSet";
            }
            {
              kind = "identifier";
              value = "stdenvNoCC";
            }
            {
              kind = "identifier";
              value = "mkDerivation";
            }
          ];
          type = "reference";
        };
        type = "call";
      };
      statements = [
        {
          operator = "=";
          target = [
            {
              kind = "identifier";
              value = "packageSet";
            }
          ];
          type = "assignment";
          value = {
            name = "pkgs";
            path = [
              {
                kind = "identifier";
                value = "legacy";
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
              value = "runtimeLibraries";
            }
          ];
          type = "assignment";
          value = {
            items = [
              {
                path = [
                  {
                    kind = "identifier";
                    value = "packageSet";
                  }
                  {
                    kind = "identifier";
                    value = "alsa-lib";
                  }
                ];
                type = "reference";
              }
              {
                path = [
                  {
                    kind = "identifier";
                    value = "packageSet";
                  }
                  {
                    kind = "identifier";
                    value = "at-spi2-core";
                  }
                ];
                type = "reference";
              }
              {
                path = [
                  {
                    kind = "identifier";
                    value = "packageSet";
                  }
                  {
                    kind = "identifier";
                    value = "cairo";
                  }
                ];
                type = "reference";
              }
              {
                path = [
                  {
                    kind = "identifier";
                    value = "packageSet";
                  }
                  {
                    kind = "identifier";
                    value = "cups";
                  }
                ];
                type = "reference";
              }
              {
                path = [
                  {
                    kind = "identifier";
                    value = "packageSet";
                  }
                  {
                    kind = "identifier";
                    value = "dbus";
                  }
                ];
                type = "reference";
              }
              {
                path = [
                  {
                    kind = "identifier";
                    value = "packageSet";
                  }
                  {
                    kind = "identifier";
                    value = "expat";
                  }
                ];
                type = "reference";
              }
              {
                path = [
                  {
                    kind = "identifier";
                    value = "packageSet";
                  }
                  {
                    kind = "identifier";
                    value = "gdk-pixbuf";
                  }
                ];
                type = "reference";
              }
              {
                path = [
                  {
                    kind = "identifier";
                    value = "packageSet";
                  }
                  {
                    kind = "identifier";
                    value = "glib";
                  }
                ];
                type = "reference";
              }
              {
                path = [
                  {
                    kind = "identifier";
                    value = "packageSet";
                  }
                  {
                    kind = "identifier";
                    value = "gtk3";
                  }
                ];
                type = "reference";
              }
              {
                path = [
                  {
                    kind = "identifier";
                    value = "packageSet";
                  }
                  {
                    kind = "identifier";
                    value = "libGL";
                  }
                ];
                type = "reference";
              }
              {
                path = [
                  {
                    kind = "identifier";
                    value = "packageSet";
                  }
                  {
                    kind = "identifier";
                    value = "libdrm";
                  }
                ];
                type = "reference";
              }
              {
                path = [
                  {
                    kind = "identifier";
                    value = "packageSet";
                  }
                  {
                    kind = "identifier";
                    value = "libgbm";
                  }
                ];
                type = "reference";
              }
              {
                path = [
                  {
                    kind = "identifier";
                    value = "packageSet";
                  }
                  {
                    kind = "identifier";
                    value = "libnotify";
                  }
                ];
                type = "reference";
              }
              {
                path = [
                  {
                    kind = "identifier";
                    value = "packageSet";
                  }
                  {
                    kind = "identifier";
                    value = "libsecret";
                  }
                ];
                type = "reference";
              }
              {
                path = [
                  {
                    kind = "identifier";
                    value = "packageSet";
                  }
                  {
                    kind = "identifier";
                    value = "libusb1";
                  }
                ];
                type = "reference";
              }
              {
                path = [
                  {
                    kind = "identifier";
                    value = "packageSet";
                  }
                  {
                    kind = "identifier";
                    value = "libx11";
                  }
                ];
                type = "reference";
              }
              {
                path = [
                  {
                    kind = "identifier";
                    value = "packageSet";
                  }
                  {
                    kind = "identifier";
                    value = "libxcb";
                  }
                ];
                type = "reference";
              }
              {
                path = [
                  {
                    kind = "identifier";
                    value = "packageSet";
                  }
                  {
                    kind = "identifier";
                    value = "libxcomposite";
                  }
                ];
                type = "reference";
              }
              {
                path = [
                  {
                    kind = "identifier";
                    value = "packageSet";
                  }
                  {
                    kind = "identifier";
                    value = "libxdamage";
                  }
                ];
                type = "reference";
              }
              {
                path = [
                  {
                    kind = "identifier";
                    value = "packageSet";
                  }
                  {
                    kind = "identifier";
                    value = "libxext";
                  }
                ];
                type = "reference";
              }
              {
                path = [
                  {
                    kind = "identifier";
                    value = "packageSet";
                  }
                  {
                    kind = "identifier";
                    value = "libxfixes";
                  }
                ];
                type = "reference";
              }
              {
                path = [
                  {
                    kind = "identifier";
                    value = "packageSet";
                  }
                  {
                    kind = "identifier";
                    value = "libxkbcommon";
                  }
                ];
                type = "reference";
              }
              {
                path = [
                  {
                    kind = "identifier";
                    value = "packageSet";
                  }
                  {
                    kind = "identifier";
                    value = "libxrandr";
                  }
                ];
                type = "reference";
              }
              {
                path = [
                  {
                    kind = "identifier";
                    value = "packageSet";
                  }
                  {
                    kind = "identifier";
                    value = "nspr";
                  }
                ];
                type = "reference";
              }
              {
                path = [
                  {
                    kind = "identifier";
                    value = "packageSet";
                  }
                  {
                    kind = "identifier";
                    value = "nss";
                  }
                ];
                type = "reference";
              }
              {
                path = [
                  {
                    kind = "identifier";
                    value = "packageSet";
                  }
                  {
                    kind = "identifier";
                    value = "openssl";
                  }
                ];
                type = "reference";
              }
              {
                path = [
                  {
                    kind = "identifier";
                    value = "packageSet";
                  }
                  {
                    kind = "identifier";
                    value = "pango";
                  }
                ];
                type = "reference";
              }
              {
                type = "group";
                value = {
                  arguments = [
                    {
                      path = [
                        {
                          kind = "identifier";
                          value = "packageSet";
                        }
                        {
                          kind = "identifier";
                          value = "qt5";
                        }
                        {
                          kind = "identifier";
                          value = "qtbase";
                        }
                      ];
                      type = "reference";
                    }
                  ];
                  callee = {
                    path = [
                      {
                        kind = "identifier";
                        value = "packageSet";
                      }
                      {
                        kind = "identifier";
                        value = "lib";
                      }
                      {
                        kind = "identifier";
                        value = "getLib";
                      }
                    ];
                    type = "reference";
                  };
                  type = "call";
                };
              }
              {
                type = "group";
                value = {
                  arguments = [
                    {
                      path = [
                        {
                          kind = "identifier";
                          value = "packageSet";
                        }
                        {
                          kind = "identifier";
                          value = "qt6";
                        }
                        {
                          kind = "identifier";
                          value = "qtbase";
                        }
                      ];
                      type = "reference";
                    }
                  ];
                  callee = {
                    path = [
                      {
                        kind = "identifier";
                        value = "packageSet";
                      }
                      {
                        kind = "identifier";
                        value = "lib";
                      }
                      {
                        kind = "identifier";
                        value = "getLib";
                      }
                    ];
                    type = "reference";
                  };
                  type = "call";
                };
              }
              {
                path = [
                  {
                    kind = "identifier";
                    value = "packageSet";
                  }
                  {
                    kind = "identifier";
                    value = "stdenv";
                  }
                  {
                    kind = "identifier";
                    value = "cc";
                  }
                  {
                    kind = "identifier";
                    value = "cc";
                  }
                  {
                    kind = "identifier";
                    value = "lib";
                  }
                ];
                type = "reference";
              }
              {
                path = [
                  {
                    kind = "identifier";
                    value = "packageSet";
                  }
                  {
                    kind = "identifier";
                    value = "systemdLibs";
                  }
                ];
                type = "reference";
              }
              {
                path = [
                  {
                    kind = "identifier";
                    value = "packageSet";
                  }
                  {
                    kind = "identifier";
                    value = "tpm2-tss";
                  }
                ];
                type = "reference";
              }
              {
                path = [
                  {
                    kind = "identifier";
                    value = "packageSet";
                  }
                  {
                    kind = "identifier";
                    value = "vulkan-loader";
                  }
                ];
                type = "reference";
              }
            ];
            type = "list";
          };
        }
      ];
      type = "let";
    };
    kind = "build";
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
                  value = "com.openai.codex.desktop";
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
                  value = "Codex Desktop";
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
                  value = "Official OpenAI desktop app with Codex and ChatGPT";
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
                  value = "\n    Official Linux desktop application from OpenAI, currently branded ChatGPT.\n    Includes the Codex workspace, integrated terminal, local projects, and bundled\n    Codex helpers. Packaged from the versioned upstream Debian release for NixOS.\n    Use `codex-desktop` or `chatgpt` to launch it. The separate `codex` package\n    provides the terminal CLI.\n  ";
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
                  value = "26.1016.61520";
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
                      value = "ai";
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
                {
                  multiline = false;
                  parts = [
                    {
                      type = "text";
                      value = "coding";
                    }
                  ];
                  type = "string";
                }
                {
                  multiline = false;
                  parts = [
                    {
                      type = "text";
                      value = "desktop";
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
                  value = "unfree";
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
          value = "build";
        }
      ];
      type = "assignment";
      value = {
        body = {
          arguments = [
            {
              recursive = false;
              statements = [
                {
                  operator = "=";
                  target = [
                    {
                      kind = "identifier";
                      value = "pname";
                    }
                  ];
                  type = "assignment";
                  value = {
                    multiline = false;
                    parts = [
                      {
                        type = "text";
                        value = "codex-desktop";
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
                      value = "version";
                    }
                  ];
                  type = "assignment";
                  value = {
                    multiline = false;
                    parts = [
                      {
                        type = "text";
                        value = "26.1016.61520";
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
                      value = "src";
                    }
                  ];
                  type = "assignment";
                  value = {
                    arguments = [
                      {
                        recursive = false;
                        statements = [
                          {
                            operator = "=";
                            target = [
                              {
                                kind = "identifier";
                                value = "url";
                              }
                            ];
                            type = "assignment";
                            value = {
                              multiline = false;
                              parts = [
                                {
                                  type = "text";
                                  value = "https://persistent.oaistatic.com/codex-app-prod/linux/deb/pool/main/c/chatgpt/chatgpt_26.1016.61520_amd64.deb";
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
                                value = "hash";
                              }
                            ];
                            type = "assignment";
                            value = {
                              multiline = false;
                              parts = [
                                {
                                  type = "text";
                                  value = "sha256-mt1iKRbF+jhhr9lQga934lSIwQjKnFQ+H2dWCzkNKNQ=";
                                }
                              ];
                              type = "string";
                            };
                          }
                        ];
                        type = "attr-set";
                      }
                    ];
                    callee = {
                      path = [
                        {
                          kind = "identifier";
                          value = "packageSet";
                        }
                        {
                          kind = "identifier";
                          value = "fetchurl";
                        }
                      ];
                      type = "reference";
                    };
                    type = "call";
                  };
                }
                {
                  operator = "=";
                  target = [
                    {
                      kind = "identifier";
                      value = "nativeBuildInputs";
                    }
                  ];
                  type = "assignment";
                  value = {
                    items = [
                      {
                        path = [
                          {
                            kind = "identifier";
                            value = "packageSet";
                          }
                          {
                            kind = "identifier";
                            value = "autoPatchelfHook";
                          }
                        ];
                        type = "reference";
                      }
                      {
                        path = [
                          {
                            kind = "identifier";
                            value = "packageSet";
                          }
                          {
                            kind = "identifier";
                            value = "dpkg";
                          }
                        ];
                        type = "reference";
                      }
                      {
                        path = [
                          {
                            kind = "identifier";
                            value = "packageSet";
                          }
                          {
                            kind = "identifier";
                            value = "makeWrapper";
                          }
                        ];
                        type = "reference";
                      }
                      {
                        path = [
                          {
                            kind = "identifier";
                            value = "packageSet";
                          }
                          {
                            kind = "identifier";
                            value = "wrapGAppsHook3";
                          }
                        ];
                        type = "reference";
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
                      value = "buildInputs";
                    }
                  ];
                  type = "assignment";
                  value = {
                    path = [
                      {
                        kind = "identifier";
                        value = "runtimeLibraries";
                      }
                    ];
                    type = "reference";
                  };
                }
                {
                  operator = "=";
                  target = [
                    {
                      kind = "identifier";
                      value = "runtimeDependencies";
                    }
                  ];
                  type = "assignment";
                  value = {
                    path = [
                      {
                        kind = "identifier";
                        value = "runtimeLibraries";
                      }
                    ];
                    type = "reference";
                  };
                }
                {
                  operator = "=";
                  target = [
                    {
                      kind = "identifier";
                      value = "dontConfigure";
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
                      value = "dontBuild";
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
                      value = "dontStrip";
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
                      value = "dontWrapGApps";
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
                      value = "unpackPhase";
                    }
                  ];
                  type = "assignment";
                  value = {
                    multiline = true;
                    parts = [
                      {
                        type = "text";
                        value = "\n    runHook preUnpack\n    dpkg-deb --fsys-tarfile \"$src\" | tar --extract --no-same-owner --no-same-permissions\n    runHook postUnpack\n  ";
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
                      value = "installPhase";
                    }
                  ];
                  type = "assignment";
                  value = {
                    multiline = true;
                    parts = [
                      {
                        type = "text";
                        value = "\n    runHook preInstall\n    mkdir -p \"$out/lib\" \"$out/share\"\n    cp -a usr/lib/chatgpt \"$out/lib/codex-desktop\"\n    cp -a usr/share/applications usr/share/pixmaps usr/share/metainfo \"$out/share/\"\n    install -Dm644 usr/share/doc/chatgpt/copyright \"$out/share/doc/codex-desktop/copyright\"\n\n    # These prebuilds target musl; Electron on NixOS uses the glibc variants.\n    find \"$out/lib/codex-desktop\" -type f -name '*musl*.node' -delete\n    find \"$out/lib/codex-desktop\" -type d -name '*-musl' -prune -exec rm -rf {} +\n    rm \"$out/lib/codex-desktop/resources/rg\"\n    ln -s ";
                      }
                      {
                        expression = {
                          path = [
                            {
                              kind = "identifier";
                              value = "packageSet";
                            }
                            {
                              kind = "identifier";
                              value = "ripgrep";
                            }
                          ];
                          type = "reference";
                        };
                        type = "interpolation";
                      }
                      {
                        type = "text";
                        value = "/bin/rg \"$out/lib/codex-desktop/resources/rg\"\n    runHook postInstall\n  ";
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
                      value = "preFixup";
                    }
                  ];
                  type = "assignment";
                  value = {
                    multiline = true;
                    parts = [
                      {
                        type = "text";
                        value = "\n    addAutoPatchelfSearchPath \"$out/lib/codex-desktop\"\n    gappsWrapperArgs+=(\n      --prefix PATH : ";
                      }
                      {
                        expression = {
                          arguments = [
                            {
                              items = [
                                {
                                  path = [
                                    {
                                      kind = "identifier";
                                      value = "packageSet";
                                    }
                                    {
                                      kind = "identifier";
                                      value = "bubblewrap";
                                    }
                                  ];
                                  type = "reference";
                                }
                                {
                                  path = [
                                    {
                                      kind = "identifier";
                                      value = "packageSet";
                                    }
                                    {
                                      kind = "identifier";
                                      value = "git";
                                    }
                                  ];
                                  type = "reference";
                                }
                                {
                                  path = [
                                    {
                                      kind = "identifier";
                                      value = "packageSet";
                                    }
                                    {
                                      kind = "identifier";
                                      value = "glib";
                                    }
                                  ];
                                  type = "reference";
                                }
                                {
                                  path = [
                                    {
                                      kind = "identifier";
                                      value = "packageSet";
                                    }
                                    {
                                      kind = "identifier";
                                      value = "ripgrep";
                                    }
                                  ];
                                  type = "reference";
                                }
                                {
                                  path = [
                                    {
                                      kind = "identifier";
                                      value = "packageSet";
                                    }
                                    {
                                      kind = "identifier";
                                      value = "trash-cli";
                                    }
                                  ];
                                  type = "reference";
                                }
                                {
                                  path = [
                                    {
                                      kind = "identifier";
                                      value = "packageSet";
                                    }
                                    {
                                      kind = "identifier";
                                      value = "xdg-utils";
                                    }
                                  ];
                                  type = "reference";
                                }
                                {
                                  path = [
                                    {
                                      kind = "identifier";
                                      value = "packageSet";
                                    }
                                    {
                                      kind = "identifier";
                                      value = "xz";
                                    }
                                  ];
                                  type = "reference";
                                }
                              ];
                              type = "list";
                            }
                          ];
                          callee = {
                            path = [
                              {
                                kind = "identifier";
                                value = "packageSet";
                              }
                              {
                                kind = "identifier";
                                value = "lib";
                              }
                              {
                                kind = "identifier";
                                value = "makeBinPath";
                              }
                            ];
                            type = "reference";
                          };
                          type = "call";
                        };
                        type = "interpolation";
                      }
                      {
                        type = "text";
                        value = "\n    )\n  ";
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
                      value = "postFixup";
                    }
                  ];
                  type = "assignment";
                  value = {
                    multiline = true;
                    parts = [
                      {
                        type = "text";
                        value = "\n    mkdir -p \"$out/bin\"\n    makeWrapper \"$out/lib/codex-desktop/ChatGPT\" \"$out/bin/codex-desktop\" \\\n      \"\${gappsWrapperArgs[@]}\"\n    ln -s codex-desktop \"$out/bin/chatgpt\"\n    substituteInPlace \"$out/share/applications/chatgpt.desktop\" \\\n      --replace-fail 'Exec=chatgpt %U' \"Exec=$out/bin/codex-desktop %U\"\n  ";
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
                      value = "meta";
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
                          multiline = false;
                          parts = [
                            {
                              type = "text";
                              value = "Official OpenAI desktop app with Codex (currently branded ChatGPT)";
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
                            value = "homepage";
                          }
                        ];
                        type = "assignment";
                        value = {
                          multiline = false;
                          parts = [
                            {
                              type = "text";
                              value = "https://developers.openai.com/codex/app";
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
                            value = "license";
                          }
                        ];
                        type = "assignment";
                        value = {
                          path = [
                            {
                              kind = "identifier";
                              value = "packageSet";
                            }
                            {
                              kind = "identifier";
                              value = "lib";
                            }
                            {
                              kind = "identifier";
                              value = "licenses";
                            }
                            {
                              kind = "identifier";
                              value = "unfree";
                            }
                          ];
                          type = "reference";
                        };
                      }
                      {
                        operator = "=";
                        target = [
                          {
                            kind = "identifier";
                            value = "mainProgram";
                          }
                        ];
                        type = "assignment";
                        value = {
                          multiline = false;
                          parts = [
                            {
                              type = "text";
                              value = "codex-desktop";
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
                            value = "platforms";
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
                                  value = "x86_64-linux";
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
                            value = "sourceProvenance";
                          }
                        ];
                        type = "assignment";
                        value = {
                          items = [
                            {
                              path = [
                                {
                                  kind = "identifier";
                                  value = "packageSet";
                                }
                                {
                                  kind = "identifier";
                                  value = "lib";
                                }
                                {
                                  kind = "identifier";
                                  value = "sourceTypes";
                                }
                                {
                                  kind = "identifier";
                                  value = "binaryNativeCode";
                                }
                              ];
                              type = "reference";
                            }
                          ];
                          type = "list";
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
          callee = {
            path = [
              {
                kind = "identifier";
                value = "packageSet";
              }
              {
                kind = "identifier";
                value = "stdenvNoCC";
              }
              {
                kind = "identifier";
                value = "mkDerivation";
              }
            ];
            type = "reference";
          };
          type = "call";
        };
        statements = [
          {
            operator = "=";
            target = [
              {
                kind = "identifier";
                value = "packageSet";
              }
            ];
            type = "assignment";
            value = {
              name = "pkgs";
              path = [
                {
                  kind = "identifier";
                  value = "legacy";
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
                value = "runtimeLibraries";
              }
            ];
            type = "assignment";
            value = {
              items = [
                {
                  path = [
                    {
                      kind = "identifier";
                      value = "packageSet";
                    }
                    {
                      kind = "identifier";
                      value = "alsa-lib";
                    }
                  ];
                  type = "reference";
                }
                {
                  path = [
                    {
                      kind = "identifier";
                      value = "packageSet";
                    }
                    {
                      kind = "identifier";
                      value = "at-spi2-core";
                    }
                  ];
                  type = "reference";
                }
                {
                  path = [
                    {
                      kind = "identifier";
                      value = "packageSet";
                    }
                    {
                      kind = "identifier";
                      value = "cairo";
                    }
                  ];
                  type = "reference";
                }
                {
                  path = [
                    {
                      kind = "identifier";
                      value = "packageSet";
                    }
                    {
                      kind = "identifier";
                      value = "cups";
                    }
                  ];
                  type = "reference";
                }
                {
                  path = [
                    {
                      kind = "identifier";
                      value = "packageSet";
                    }
                    {
                      kind = "identifier";
                      value = "dbus";
                    }
                  ];
                  type = "reference";
                }
                {
                  path = [
                    {
                      kind = "identifier";
                      value = "packageSet";
                    }
                    {
                      kind = "identifier";
                      value = "expat";
                    }
                  ];
                  type = "reference";
                }
                {
                  path = [
                    {
                      kind = "identifier";
                      value = "packageSet";
                    }
                    {
                      kind = "identifier";
                      value = "gdk-pixbuf";
                    }
                  ];
                  type = "reference";
                }
                {
                  path = [
                    {
                      kind = "identifier";
                      value = "packageSet";
                    }
                    {
                      kind = "identifier";
                      value = "glib";
                    }
                  ];
                  type = "reference";
                }
                {
                  path = [
                    {
                      kind = "identifier";
                      value = "packageSet";
                    }
                    {
                      kind = "identifier";
                      value = "gtk3";
                    }
                  ];
                  type = "reference";
                }
                {
                  path = [
                    {
                      kind = "identifier";
                      value = "packageSet";
                    }
                    {
                      kind = "identifier";
                      value = "libGL";
                    }
                  ];
                  type = "reference";
                }
                {
                  path = [
                    {
                      kind = "identifier";
                      value = "packageSet";
                    }
                    {
                      kind = "identifier";
                      value = "libdrm";
                    }
                  ];
                  type = "reference";
                }
                {
                  path = [
                    {
                      kind = "identifier";
                      value = "packageSet";
                    }
                    {
                      kind = "identifier";
                      value = "libgbm";
                    }
                  ];
                  type = "reference";
                }
                {
                  path = [
                    {
                      kind = "identifier";
                      value = "packageSet";
                    }
                    {
                      kind = "identifier";
                      value = "libnotify";
                    }
                  ];
                  type = "reference";
                }
                {
                  path = [
                    {
                      kind = "identifier";
                      value = "packageSet";
                    }
                    {
                      kind = "identifier";
                      value = "libsecret";
                    }
                  ];
                  type = "reference";
                }
                {
                  path = [
                    {
                      kind = "identifier";
                      value = "packageSet";
                    }
                    {
                      kind = "identifier";
                      value = "libusb1";
                    }
                  ];
                  type = "reference";
                }
                {
                  path = [
                    {
                      kind = "identifier";
                      value = "packageSet";
                    }
                    {
                      kind = "identifier";
                      value = "libx11";
                    }
                  ];
                  type = "reference";
                }
                {
                  path = [
                    {
                      kind = "identifier";
                      value = "packageSet";
                    }
                    {
                      kind = "identifier";
                      value = "libxcb";
                    }
                  ];
                  type = "reference";
                }
                {
                  path = [
                    {
                      kind = "identifier";
                      value = "packageSet";
                    }
                    {
                      kind = "identifier";
                      value = "libxcomposite";
                    }
                  ];
                  type = "reference";
                }
                {
                  path = [
                    {
                      kind = "identifier";
                      value = "packageSet";
                    }
                    {
                      kind = "identifier";
                      value = "libxdamage";
                    }
                  ];
                  type = "reference";
                }
                {
                  path = [
                    {
                      kind = "identifier";
                      value = "packageSet";
                    }
                    {
                      kind = "identifier";
                      value = "libxext";
                    }
                  ];
                  type = "reference";
                }
                {
                  path = [
                    {
                      kind = "identifier";
                      value = "packageSet";
                    }
                    {
                      kind = "identifier";
                      value = "libxfixes";
                    }
                  ];
                  type = "reference";
                }
                {
                  path = [
                    {
                      kind = "identifier";
                      value = "packageSet";
                    }
                    {
                      kind = "identifier";
                      value = "libxkbcommon";
                    }
                  ];
                  type = "reference";
                }
                {
                  path = [
                    {
                      kind = "identifier";
                      value = "packageSet";
                    }
                    {
                      kind = "identifier";
                      value = "libxrandr";
                    }
                  ];
                  type = "reference";
                }
                {
                  path = [
                    {
                      kind = "identifier";
                      value = "packageSet";
                    }
                    {
                      kind = "identifier";
                      value = "nspr";
                    }
                  ];
                  type = "reference";
                }
                {
                  path = [
                    {
                      kind = "identifier";
                      value = "packageSet";
                    }
                    {
                      kind = "identifier";
                      value = "nss";
                    }
                  ];
                  type = "reference";
                }
                {
                  path = [
                    {
                      kind = "identifier";
                      value = "packageSet";
                    }
                    {
                      kind = "identifier";
                      value = "openssl";
                    }
                  ];
                  type = "reference";
                }
                {
                  path = [
                    {
                      kind = "identifier";
                      value = "packageSet";
                    }
                    {
                      kind = "identifier";
                      value = "pango";
                    }
                  ];
                  type = "reference";
                }
                {
                  type = "group";
                  value = {
                    arguments = [
                      {
                        path = [
                          {
                            kind = "identifier";
                            value = "packageSet";
                          }
                          {
                            kind = "identifier";
                            value = "qt5";
                          }
                          {
                            kind = "identifier";
                            value = "qtbase";
                          }
                        ];
                        type = "reference";
                      }
                    ];
                    callee = {
                      path = [
                        {
                          kind = "identifier";
                          value = "packageSet";
                        }
                        {
                          kind = "identifier";
                          value = "lib";
                        }
                        {
                          kind = "identifier";
                          value = "getLib";
                        }
                      ];
                      type = "reference";
                    };
                    type = "call";
                  };
                }
                {
                  type = "group";
                  value = {
                    arguments = [
                      {
                        path = [
                          {
                            kind = "identifier";
                            value = "packageSet";
                          }
                          {
                            kind = "identifier";
                            value = "qt6";
                          }
                          {
                            kind = "identifier";
                            value = "qtbase";
                          }
                        ];
                        type = "reference";
                      }
                    ];
                    callee = {
                      path = [
                        {
                          kind = "identifier";
                          value = "packageSet";
                        }
                        {
                          kind = "identifier";
                          value = "lib";
                        }
                        {
                          kind = "identifier";
                          value = "getLib";
                        }
                      ];
                      type = "reference";
                    };
                    type = "call";
                  };
                }
                {
                  path = [
                    {
                      kind = "identifier";
                      value = "packageSet";
                    }
                    {
                      kind = "identifier";
                      value = "stdenv";
                    }
                    {
                      kind = "identifier";
                      value = "cc";
                    }
                    {
                      kind = "identifier";
                      value = "cc";
                    }
                    {
                      kind = "identifier";
                      value = "lib";
                    }
                  ];
                  type = "reference";
                }
                {
                  path = [
                    {
                      kind = "identifier";
                      value = "packageSet";
                    }
                    {
                      kind = "identifier";
                      value = "systemdLibs";
                    }
                  ];
                  type = "reference";
                }
                {
                  path = [
                    {
                      kind = "identifier";
                      value = "packageSet";
                    }
                    {
                      kind = "identifier";
                      value = "tpm2-tss";
                    }
                  ];
                  type = "reference";
                }
                {
                  path = [
                    {
                      kind = "identifier";
                      value = "packageSet";
                    }
                    {
                      kind = "identifier";
                      value = "vulkan-loader";
                    }
                  ];
                  type = "reference";
                }
              ];
              type = "list";
            };
          }
        ];
        type = "let";
      };
    }
  ];
  target = [
    "com"
    "openai"
    "codex"
    "desktop"
  ];
}
