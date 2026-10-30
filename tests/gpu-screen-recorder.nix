{ nixpkgs, zenosModule }:
let
  c = (nixpkgs.lib.nixosSystem {
    system = "x86_64-linux";
    modules = [ zenosModule {
      system.stateVersion = "26.05";
      zenos.system.programs.gpu-screen-recorder.systemSupport = true;
      zenos.legacy.programs.dconf.profiles.user.databases = [{ settings."org/gnome/settings-daemon/plugins/media-keys".custom-keybindings = [ "/existing/" ]; }];
      zenos.users.recorder.profile.normalUser = true;
      zenos.users.other.profile.normalUser = true;
      home-manager.users.recorder.home.stateVersion = "26.05";
      home-manager.users.other.home.stateVersion = "26.05";
      zenos.users.recorder.programs.gpu-screen-recorder = {
        enable = true;
        autoStart = true;
        replaySeconds = 30;
        recordShortcut = "<Shift><Super>q";
        clipShortcut = "<Shift><Super>w";
      };
    } ];
  }).config;
  h = c.home-manager.users.recorder;
  other = c.home-manager.users.other;
  service = h.systemd.user.services.zenos-screen-recorder;
  settings = h.dconf.settings;
  paths = toString settings."org/gnome/settings-daemon/plugins/media-keys".custom-keybindings;
  has = nixpkgs.lib.hasInfix;
in
assert c.programs.gpu-screen-recorder.enable;
assert c.security.wrappers.gsr-kms-server.capabilities == "cap_sys_admin+ep";
assert service.Install.WantedBy == [ "graphical-session.target" ];
assert has "-r 30" (toString service.Service.ExecStart);
assert has "-ro %h/Videos/Recordings" (toString service.Service.ExecStart);
assert has "-o %h/Videos/Clips" (toString service.Service.ExecStart);
assert has "-fallback-cpu-encoding no" (toString service.Service.ExecStart);
assert service.Service.KillSignal == "SIGINT";
assert has "/existing/" paths && has "gsr-record/" paths && has "gsr-clip/" paths;
assert settings."org/gnome/settings-daemon/plugins/media-keys/custom-keybindings/gsr-record".binding == "<Shift><Super>q";
assert has "--signal=SIGRTMIN" settings."org/gnome/settings-daemon/plugins/media-keys/custom-keybindings/gsr-record".command;
assert has "--signal=SIGUSR1" settings."org/gnome/settings-daemon/plugins/media-keys/custom-keybindings/gsr-clip".command;
assert !(other.systemd.user.services ? zenos-screen-recorder);
assert !(other.dconf.settings ? "org/gnome/settings-daemon/plugins/media-keys/custom-keybindings/gsr-record");
true
