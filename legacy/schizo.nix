{ lib, ... }:
{
  imports = [ ];
  locale = {
    timezone = ""; # enum
    defaultLocale = ""; # enum
    keyboards = [ ];
  };
  services = { };
  system = {
    pipewire = { };
    name = "ZenOS";
    version = {
      type = "beta";
      majorVer = "1.0";
      variant = "N";
      full = lib.utils.osVersionString;
    };
    host = {
      name = "";
    };
    networking = {
      firewall = { };
    };
    bluetooth = { };
    packages = { };
    boot = {
      loader = { };
    };
    hardware = {
      graphics = {
        enable = true;
        amd = { };
        nvidia = { };
      };
    };
    kernel = {
      package = { };
      parameters = [ ];
      modules = [ ];
    };
  };
  users = {
    doromiert = {
      theme = {
        accentColor = "purple"; # enum? not sure yet
        darkMode = true;
        qt = { };
        gtk = { };
      };
      packages = { };
      description = "";
      programs = {
        steam = { };
        autogen = {
          # this will take pkgs.programs and automatically make a module for all of them to maintain config consistency
          somePackage = {
            enable = true;
            overrides = { };
          };
        };
      };
    };
  };
  loginManager = {
    gdm = { };
  };
  desktops = {
    gnome = { };
  };
  environment = {
    variables = {
      EDITOR = "code";
    };
  };
}
