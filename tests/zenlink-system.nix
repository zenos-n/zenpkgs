# Evaluate the real mounted system/user graph; do not start any services.
{ nixpkgs, zenosModule }:
let
  system = nixpkgs.lib.nixosSystem {
    system = "x86_64-linux";
    modules = [ zenosModule {
      system.stateVersion = "26.05";
      zenos.desktops.gnome.extensions.zenlink-indicator.enable = true;
      zenos.users.zenlink-test.profile.normalUser = true;
      home-manager.users.zenlink-test.home.stateVersion = "26.05";
    } ];
  };
  c = system.config;
  h = c.home-manager.users.zenlink-test;
  service = h.systemd.user.services.zenlink;
in
assert c.zenos.system.programs.zenlink.enable && c.programs.zenlink.enable;
assert builtins.elem c.boot.kernelPackages.v4l2loopback.drvPath (map (p: p.drvPath) c.boot.extraModulePackages);
assert nixpkgs.lib.hasInfix "zenlink@zenos-n.github.io" (toString h.dconf.settings."org/gnome/shell".enabled-extensions);
assert nixpkgs.lib.hasInfix "gsconnect@andyholmes.github.io" (toString h.dconf.settings."org/gnome/shell".disabled-extensions);
assert service.Service.BusName == "org.zenos.ZenLink";
assert service.Install.WantedBy == [ "graphical-session.target" ];
assert !(builtins.elem "graphical-session.target" service.Unit.After);
assert nixpkgs.lib.hasInfix "/bin/zenlink" h.xdg.dataFile."dbus-1/services/org.zenos.ZenLink.service".text;
true
