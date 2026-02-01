{
  config,
  lib,
  pkgs,
  ...
}:

# ZenOS Option Map (User)
# Location: legacy/hm.nix
{
  meta = {
    description = "Maps ZenOS user options to legacy Home Manager options";
    longDescription = ''
      Translates high-level ZenOS user preferences (like `zen.shell`)
      into standard `home-manager` option definitions.
    '';
    maintainers = with lib.maintainers; [ doromiert ];
    license = lib.licenses.napl;
    platforms = lib.platforms.zenos;
  };

  options.zen.shell = lib.mkOption {
    type = lib.types.enum [
      "bash"
      "zsh"
      "fish"
    ];
    default = "bash";
    description = "Selects the user's preferred shell environment";
  };

  config.legacy = {
    programs.bash.enable = (config.zen.shell == "bash");
    programs.zsh.enable = (config.zen.shell == "zsh");
    programs.fish.enable = (config.zen.shell == "fish");
  };
}
