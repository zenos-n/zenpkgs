{ nixpkgs, zenosModule }:
let
  lib = nixpkgs.lib;
  evaluate = extra: (lib.nixosSystem {
    system = "x86_64-linux";
    modules = [ zenosModule {
      system.stateVersion = "26.05";
      nixpkgs.config.allowUnfree = true;
      users.users.alice = { isNormalUser = true; home = "/Users/alice"; };
      users.users.bob = { isNormalUser = true; home = "/Users/bob"; };
      home-manager.users.alice.home.stateVersion = "26.05";
      home-manager.users.bob.home.stateVersion = "26.05";
    } extra ];
  }).config;
  defaults = evaluate {};
  configured = evaluate ({ pkgs, ... }: {
    zenos = {
      system.virtualization = {
        libvirt = { enable = true; virtualTpm = true; runAsRoot = false; manager = true; socketNetworkTransport = true; };
        docker = { enable = true; storageDriver = "overlay2"; };
      };
      system.memory.zram = { enable = true; memoryPercent = 50; algorithm = "zstd"; priority = 10; };
      system.kernel = { parameters = [ "iommu=pt" ]; sysctl."vm.max_map_count" = 2147483642; };
      system.hardware = { androidDebugging = true; logitechWireless = true; amdOpenCL = true; };
      system.packaging = { environmentExecutables = true; compatibilityLibraries = true; dynamicLibraries = [ pkgs.zlib ]; };
      system.printing = { printers = [ { name = "test-printer"; deviceUri = "file:/tmp/printed"; model = "raw"; } ]; defaultPrinter = "test-printer"; };
      system.flatpak = { enable = false; packages = [ "org.gnome.Showtime" ]; };
      users.alice = {
        services.flatpak = { enable = false; packages = [ "re.sonny.Workbench" ]; };
        programs = {
          firefox = { enable = true; profiles.default.settings."browser.startup.page" = 3; };
          kitty = { enable = true; settings.font_size = 11; };
          keepassxc = { enable = true; settings.Browser.Enabled = true; };
          vscode = { enable = true; profiles.default.userSettings."editor.fontSize" = 14; };
          pwamaker = { enable = true; dispatcher.enable = true; apps.example = { name = "Example"; url = "https://example.invalid"; openUrls = [ "example.invalid" ]; }; };
          nixcord.enable = false;
        };
      };
    };
  });
  disabled = evaluate ({ lib, ... }: {
    virtualisation.docker.enable = lib.mkDefault true;
    virtualisation.libvirtd.enable = lib.mkDefault true;
    programs.steam.enable = lib.mkDefault true;
    hardware.logitech.wireless.enable = lib.mkDefault true;
    zramSwap.enable = lib.mkDefault true;
    zenos.system = {
      virtualization = { docker.enable = false; libvirt.enable = false; };
      gaming.steam.enable = false;
      hardware.logitechWireless = false;
      memory.zram.enable = false;
    };
  });
  vr = evaluate {
    zenos.users.alice.services.vr = { enable = true; overlayFont = "sans-serif"; };
  };
  multiUserVr = evaluate {
    zenos.users.alice.services.vr = { enable = true; allowNetworkAccess = true; };
    zenos.users.bob.services.vr = { enable = true; allowNetworkAccess = false; };
  };
  agents = evaluate {
    zenos.users.alice.services = {
      codexTelegram = { enable = true; environmentFile = "/run/secrets/codex-telegram"; };
      opencodeTelegram = { enable = true; environmentFile = "/run/secrets/opencode-telegram"; };
      opencodeServer.enable = true;
      haptics.enable = true;
      zbridge.enable = true;
    };
  };
  h = configured.home-manager.users.alice;
in {
  optionalDefaults = !defaults.virtualisation.libvirtd.enable
    && !defaults.virtualisation.docker.enable && !defaults.programs.steam.enable
    && !defaults.programs.alvr.enable && defaults.zramSwap.enable
    && defaults.zenos.system.memory.zram.enable == null
    && defaults.services.flatpak.enable && defaults.services.flatpak.packages == [ ]
    && !defaults.home-manager.users.alice.services.flatpak.enable
    && !defaults.home-manager.users.alice.programs.pwamaker.enable;
  explicitFalse = !disabled.virtualisation.docker.enable
    && !disabled.virtualisation.libvirtd.enable && !disabled.programs.steam.enable
    && !disabled.hardware.logitech.wireless.enable && !disabled.zramSwap.enable;
  virtualization = configured.virtualisation.libvirtd.enable
    && configured.virtualisation.libvirtd.qemu.swtpm.enable
    && !configured.virtualisation.libvirtd.qemu.runAsRoot
    && configured.programs.virt-manager.enable && configured.virtualisation.docker.enable
    && configured.virtualisation.docker.storageDriver == "overlay2";
  memory = configured.zramSwap.enable && configured.zramSwap.memoryPercent == 50
    && configured.zramSwap.algorithm == "zstd" && configured.zramSwap.priority == 10;
  kernel = builtins.elem "iommu=pt" configured.boot.kernelParams
    && configured.boot.kernel.sysctl."vm.max_map_count" == 2147483642;
  hardware = lib.any (package: lib.getName package == "android-tools") configured.environment.systemPackages
    && configured.hardware.logitech.wireless.enable
    && configured.hardware.amdgpu.opencl.enable;
  dynamicPrograms = configured.services.envfs.enable && configured.programs.nix-ld.enable;
  printers = (builtins.head configured.hardware.printers.ensurePrinters).name == "test-printer"
    && configured.hardware.printers.ensureDefaultPrinter == "test-printer";
  flatpakScopes = (builtins.head configured.services.flatpak.packages).appId == "org.gnome.Showtime"
    && (builtins.head h.services.flatpak.packages).appId == "re.sonny.Workbench"
    && !configured.services.flatpak.uninstallUnmanaged && !h.services.flatpak.uninstallUnmanaged;
  programSettings = h.programs.firefox.profiles.default.settings."browser.startup.page" == 3
    && h.programs.kitty.settings.font_size == 11 && h.programs.keepassxc.settings.Browser.Enabled
    && h.programs.vscode.profiles.default.userSettings."editor.fontSize" == 14;
  webApplications = h.programs.pwamaker.enable && h.programs.pwamaker.dispatcher.enable
    && h.programs.pwamaker.apps.example.id == "example"
    && h.programs.pwamaker.apps.example.openUrls == [ "example.invalid" ];
  userIsolation = !configured.home-manager.users.bob.programs.firefox.enable
    && !configured.home-manager.users.bob.programs.keepassxc.enable;
  vrRuntime = vr.programs.steam.enable && vr.programs.alvr.enable
    && !vr.programs.alvr.openFirewall && vr.hardware.graphics.enable32Bit
    && vr.security.rtkit.enable && vr.programs.gamemode.enable;
  vrUserIsolation = vr.home-manager.users.alice.systemd.user.services ? zenos-vr-overlays
    && !(vr.home-manager.users.bob.systemd.user.services ? zenos-vr-overlays)
    && lib.any (limit: limit.domain == "alice" && limit.item == "rtprio" && limit.value == "95") vr.security.pam.loginLimits
    && lib.any (limit: limit.domain == "alice" && limit.item == "nice" && limit.value == "-19") vr.security.pam.loginLimits
    && !lib.any (limit: limit.domain == "bob") vr.security.pam.loginLimits;
  vrFont = builtins.fromJSON
    vr.home-manager.users.alice.xdg.configFile."wlxoverlay/conf.d/00-zenos-font.yaml".text
    == { primary_font = "sans-serif"; };
  vrSharedFirewall = multiUserVr.programs.alvr.openFirewall;
  agentsDefaultOff = !(defaults.home-manager.users.alice.systemd.user.services ? codexTelegram)
    && !(defaults.home-manager.users.alice.systemd.user.services ? opencodeTelegram)
    && !(defaults.home-manager.users.alice.systemd.user.services ? opencodeServer)
    && !(defaults.home-manager.users.alice.systemd.user.services ? hapticspp)
    && !(defaults.home-manager.users.alice.systemd.user.services ? zbridge);
  credentialsStayExternal = agents.home-manager.users.alice.systemd.user.services.codexTelegram.Service.EnvironmentFile == "/run/secrets/codex-telegram"
    && agents.home-manager.users.alice.systemd.user.services.opencodeTelegram.Service.EnvironmentFile == "/run/secrets/opencode-telegram";
  agentsUserIsolation = !(agents.home-manager.users.bob.systemd.user.services ? codexTelegram)
    && !(agents.home-manager.users.bob.systemd.user.services ? opencodeTelegram)
    && !(agents.home-manager.users.bob.systemd.user.services ? opencodeServer)
    && !(agents.home-manager.users.bob.systemd.user.services ? hapticspp)
    && !(agents.home-manager.users.bob.systemd.user.services ? zbridge);
  serverLoopback = lib.any (lib.hasInfix "127.0.0.1") agents.home-manager.users.alice.systemd.user.services.opencodeServer.Service.ExecStart;
}
