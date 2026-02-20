{
  lib,
  pkgs,
  config,
  ...
}:
{
  meta = {
    brief = "KeePassXC password manager";
    description = ''
      test
    '';
    maintainers = with lib.maintainers; [ doromiert ];
    license = lib.licenses.napalm;
  };

  options.keepassxc = {
    enable = lib.mkEnableOption "KeePassXC password manager";

    # This is the option you can modify from your host config
    theme = lib.mkOption {
      type = lib.types.enum [
        "light"
        "dark"
        "auto"
        "classic"
      ];
      default = "dark";
      description = "The UI theme to use for KeePassXC.";
    };
  };

  config = lib.mkIf config.keepassxc.enable {
    __installPackages = [ pkgs.keepassxc ];

    # The ${config.keepassxc.theme} variable dynamically pulls
    # the value defined in the current socket.
    __configFiles."keepassxc/keepassxc.ini" = {
      text = ''
        [General]
        ConfigVersion=2
        UpdateCheckMessageShown=true

        [GUI]
        ApplicationTheme=${config.keepassxc.theme}
      '';
    };
  };
}
