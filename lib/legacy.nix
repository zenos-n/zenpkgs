{ lib, pkgs }:

# ZenOS Package Map
# Location: legacy/pkgs.nix
{
  # --- Category: Desktops ---
  desktops = {
    gnome = {
      core = pkgs.gnome-shell;
      apps = {
        files = pkgs.nautilus;
        term = pkgs.gnome-console;
        viewer = pkgs.eog;
      };
      # Auto-map entire subcategory
      extensions = pkgs.gnomeExtensions;
    };

    hyprland = {
      core = pkgs.hyprland;
      portal = pkgs.xdg-desktop-portal-hyprland;
    };
  };

  # --- Category: Development ---
  dev = {
    langs = {
      python = pkgs.python3;
      rust = pkgs.cargo;
      go = pkgs.go;
      nix = {
        core = pkgs.nix;
        lsp = pkgs.nixd;
        fmt = pkgs.nixfmt-rfc-style;
      };
    };
    editors = {
      vscode = pkgs.vscode;
      vim = pkgs.vim;
    };
  };

  # --- Category: System ---
  sys = {
    kernel = pkgs.linuxPackages_latest.kernel;
    boot = {
      systemd = pkgs.systemd;
      grub = pkgs.grub2;
    };

    # Expose raw pkgs as legacy fallback
    legacy = pkgs;
  };
}
