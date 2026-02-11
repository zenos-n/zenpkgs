{
  lib,
  config,
  pkgs,
  ...
}:

{
  options.keepassxc = {
    enable = lib.mkEnableOption "KeePassXC Password Manager";

    # [NEW] Configuration Options
    withX11 = lib.mkOption {
      type = lib.types.bool;
      default = true;
      description = "Enable X11 integration (Auto-Type).";
    };

    withBrowser = lib.mkOption {
      type = lib.types.bool;
      default = true;
      description = "Enable Browser Integration support.";
    };
  };

  config = lib.mkIf config.keepassxc.enable {
    # Apply overrides based on config options
    packages.keepassxc = pkgs.keepassxc.override {
      withKeePassX11 = config.keepassxc.withX11;
      # Note: withBrowser is often default, but this demonstrates the pattern
    };
  };
}
