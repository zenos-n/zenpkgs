{ ... }:
{
  dependenciesDeclared = false;
  descriptorVersion = "zenlang.semantic/2";
  grammarVersion = "1.0.0Na";
  id = "pkgs.unknown.stress-ng";
  imports = [ ];
  irVersion = "1.0.0Na";
  kind = "zpkg";
  location = "/nix/store/3ni594f60hm22hcrazxd35dmk7pwi61m-zenpkgs-dsl-source/pkgs/apps/system/monitoring/stress-ng.zpkg:36:8";
  metadata = {
    description = {
      multiline = true;
      parts = [
        {
          type = "text";
          value = "\n    stress-ng will stress test a computer system in various selectable ways. It\n    was designed to exercise various physical subsystems of a computer as well as\n    the various operating system kernel interfaces. Stress-ng features:\n\n      * over 210 stress tests\n      * over 50 CPU specific stress tests that exercise floating point, integer,\n        bit manipulation and control flow\n      * over 20 virtual memory stress tests\n      * portable: builds on Linux, Solaris, *BSD, Minix, Android, MacOS X,\n        Debian Hurd, Haiku, Windows Subsystem for Linux and SunOs/Dilos with\n        gcc, clang, tcc and pcc.\n\n    stress-ng was originally intended to make a machine work hard and trip hardware\n    issues such as thermal overruns as well as operating system bugs that only\n    occur when a system is being thrashed hard. Use stress-ng with caution as some\n    of the tests can make a system run hot on poorly designed hardware and also can\n    cause excessive system thrashing which may be difficult to stop.\n\n    stress-ng can also measure test throughput rates; this can be useful to observe\n    performance changes across different operating system releases or types of\n    hardware. However, it has never been intended to be used as a precise benchmark\n    test suite, so do NOT use it in this manner.\n  ";
        }
      ];
      type = "string";
    };
    id = {
      multiline = false;
      parts = [
        {
          type = "text";
          value = "unknown.stress-ng";
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
          value = "stress-ng";
        }
      ];
      type = "string";
    };
    packageVersion = {
      multiline = false;
      parts = [
        {
          type = "text";
          value = "0.21.01";
        }
      ];
      type = "string";
    };
    summary = {
      multiline = false;
      parts = [
        {
          type = "text";
          value = "Stress test a computer system";
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
              value = "system";
            }
          ];
          type = "string";
        }
        {
          multiline = false;
          parts = [
            {
              type = "text";
              value = "monitoring";
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
  name = "stress-ng";
  packageImport = {
    name = "pkgs";
    path = [
      {
        kind = "identifier";
        value = "legacy";
      }
      {
        kind = "identifier";
        value = "stress-ng";
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
          value = "stress-ng";
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
                  value = "unknown.stress-ng";
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
                  value = "stress-ng";
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
                  value = "Stress test a computer system";
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
                  value = "\n    stress-ng will stress test a computer system in various selectable ways. It\n    was designed to exercise various physical subsystems of a computer as well as\n    the various operating system kernel interfaces. Stress-ng features:\n\n      * over 210 stress tests\n      * over 50 CPU specific stress tests that exercise floating point, integer,\n        bit manipulation and control flow\n      * over 20 virtual memory stress tests\n      * portable: builds on Linux, Solaris, *BSD, Minix, Android, MacOS X,\n        Debian Hurd, Haiku, Windows Subsystem for Linux and SunOs/Dilos with\n        gcc, clang, tcc and pcc.\n\n    stress-ng was originally intended to make a machine work hard and trip hardware\n    issues such as thermal overruns as well as operating system bugs that only\n    occur when a system is being thrashed hard. Use stress-ng with caution as some\n    of the tests can make a system run hot on poorly designed hardware and also can\n    cause excessive system thrashing which may be difficult to stop.\n\n    stress-ng can also measure test throughput rates; this can be useful to observe\n    performance changes across different operating system releases or types of\n    hardware. However, it has never been intended to be used as a precise benchmark\n    test suite, so do NOT use it in this manner.\n  ";
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
                  value = "0.21.01";
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
                      value = "system";
                    }
                  ];
                  type = "string";
                }
                {
                  multiline = false;
                  parts = [
                    {
                      type = "text";
                      value = "monitoring";
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
            value = "stress-ng";
          }
        ];
        type = "variable";
      };
      type = "package-import";
    }
  ];
  target = [
    "unknown"
    "stress-ng"
  ];
}
