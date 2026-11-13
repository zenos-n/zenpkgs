{ ... }:
{
  dependenciesDeclared = false;
  descriptorVersion = "zenlang.semantic/2";
  grammarVersion = "1.0.0Na";
  id = "pkgs.unknown.savvycan";
  imports = [ ];
  irVersion = "1.0.0Na";
  kind = "zpkg";
  location = "/nix/store/3ni594f60hm22hcrazxd35dmk7pwi61m-zenpkgs-dsl-source/pkgs/apps/development/savvycan.zpkg:37:8";
  metadata = {
    description = {
      multiline = true;
      parts = [
        {
          type = "text";
          value = "\n    SavvyCAN is a cross platform QT based C++ program. It is a CAN bus reverse\n    engineering and capture tool. It was originally written to utilize EVTV\n    hardware such as the EVTVDue and CANDue hardware. It has since expanded to be\n    able to use any socketCAN compatible device as well as the Macchina M2 and\n    Teensy 3.x boards. SavvyCAN can use any CAN interface supported by QT's\n    SerialBus system (PeakCAN, Vector, SocketCAN, J2534, etc) It can capture and\n    send to multiple buses and CAN capture devices at once. It has many functions\n    specifically meant for reverse engineering data found on the CAN bus:\n    - Ability to capture even very highly loaded buses\n    - Ability to connect to many dongles simultaneously\n    - Scan captured traffic for data that looks coherent\n    - Show ASCII of captured data to find things like VIN numbers and traffic to\n      and from the radio\n    - Graph data found on the bus\n    - Load and Save many different file formats common to CAN capture tools (Vector\n      captures, Microchip, CANDo, PCAN, and many more)\n    - Load and Save DBC files. DBC files are used to store definitions for how data\n      are formatted on the bus. You can turn the raw data into things like a RPM,\n      odometer readings, and more.\n    - UDS scanning and decoding\n    - Scripting interface to be able to expand the scope of the software\n    - Best of all, it's free and open source. Don't like something about it? Change\n      it!\n  ";
        }
      ];
      type = "string";
    };
    id = {
      multiline = false;
      parts = [
        {
          type = "text";
          value = "unknown.savvycan";
        }
      ];
      type = "string";
    };
    license = {
      name = "l";
      path = [
        {
          kind = "identifier";
          value = "mit";
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
          value = "SavvyCAN";
        }
      ];
      type = "string";
    };
    packageVersion = {
      multiline = false;
      parts = [
        {
          type = "text";
          value = "220";
        }
      ];
      type = "string";
    };
    summary = {
      multiline = false;
      parts = [
        {
          type = "text";
          value = "QT based cross platform canbus tool";
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
              value = "hardware";
            }
          ];
          type = "string";
        }
        {
          multiline = false;
          parts = [
            {
              type = "text";
              value = "embedded";
            }
          ];
          type = "string";
        }
        {
          multiline = false;
          parts = [
            {
              type = "text";
              value = "electronics";
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
  name = "savvycan";
  packageImport = {
    name = "pkgs";
    path = [
      {
        kind = "identifier";
        value = "legacy";
      }
      {
        kind = "identifier";
        value = "savvycan";
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
          value = "savvycan";
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
                  value = "unknown.savvycan";
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
                  value = "SavvyCAN";
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
                  value = "QT based cross platform canbus tool";
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
                  value = "\n    SavvyCAN is a cross platform QT based C++ program. It is a CAN bus reverse\n    engineering and capture tool. It was originally written to utilize EVTV\n    hardware such as the EVTVDue and CANDue hardware. It has since expanded to be\n    able to use any socketCAN compatible device as well as the Macchina M2 and\n    Teensy 3.x boards. SavvyCAN can use any CAN interface supported by QT's\n    SerialBus system (PeakCAN, Vector, SocketCAN, J2534, etc) It can capture and\n    send to multiple buses and CAN capture devices at once. It has many functions\n    specifically meant for reverse engineering data found on the CAN bus:\n    - Ability to capture even very highly loaded buses\n    - Ability to connect to many dongles simultaneously\n    - Scan captured traffic for data that looks coherent\n    - Show ASCII of captured data to find things like VIN numbers and traffic to\n      and from the radio\n    - Graph data found on the bus\n    - Load and Save many different file formats common to CAN capture tools (Vector\n      captures, Microchip, CANDo, PCAN, and many more)\n    - Load and Save DBC files. DBC files are used to store definitions for how data\n      are formatted on the bus. You can turn the raw data into things like a RPM,\n      odometer readings, and more.\n    - UDS scanning and decoding\n    - Scripting interface to be able to expand the scope of the software\n    - Best of all, it's free and open source. Don't like something about it? Change\n      it!\n  ";
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
                  value = "220";
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
                      value = "hardware";
                    }
                  ];
                  type = "string";
                }
                {
                  multiline = false;
                  parts = [
                    {
                      type = "text";
                      value = "embedded";
                    }
                  ];
                  type = "string";
                }
                {
                  multiline = false;
                  parts = [
                    {
                      type = "text";
                      value = "electronics";
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
                  value = "mit";
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
            value = "savvycan";
          }
        ];
        type = "variable";
      };
      type = "package-import";
    }
  ];
  target = [
    "unknown"
    "savvycan"
  ];
}
