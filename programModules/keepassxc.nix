# LOCATION: programModules/keepassxc.nix

{
  lib,
  config,
  pkgs,
  ...
}:

{
  options.keepassxc = {
    enable = lib.mkEnableOption "KeePassXC Password Manager";

    withX11 = lib.mkOption {
      type = lib.types.bool;
      default = true;
      description = "Enable X11 integration.";
    };
  };

  config = lib.mkIf config.keepassxc.enable {
    # Export the package to the framework's internal aggregation option
    exportedPackages.keepassxc = pkgs.keepassxc.override {
      withKeePassX11 = config.keepassxc.withX11;
    };
  };
}
