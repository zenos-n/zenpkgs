{ pkgs, zenosModule, zenDsl, sourceRoot }:

pkgs.testers.runNixOSTest {
  name = "zenos-package-catalog";
  node.pkgsReadOnly = false;

  nodes.machine = { lib, ... }: {
    imports = [ zenosModule ];
    # Keep test instrumentation visible despite the installed desktop's quiet boot.
    boot.consoleLogLevel = lib.mkForce 7;
    boot.initrd.verbose = lib.mkForce true;
    environment.systemPackages = [ zenDsl pkgs.python3 pkgs.nix ];
    zenos.system.installed-base.enable = true;
    zenos.system.packages.apps = {
      audio.sox = true;
      backup.restic = true;
      science.numbat = true;
      security.age = true;
      files.ripgrep = true;
      files.fd = true;
    };
    users.users.catalog = {
      isNormalUser = true;
      home = "/Users/catalog";
    };
    home-manager.users.catalog.home.stateVersion = "26.05";
    zenos.users.catalog.packages.apps.files.bat = true;
    system.stateVersion = "26.05";
    virtualisation = {
      memorySize = 3072;
      diskSize = 8192;
      useBootLoader = true;
      useEFIBoot = true;
      # Boot the installed image, but expose test-only compiler inputs too.
      # Bootloader mode otherwise disables the test driver's shared store.
      mountHostNixStore = true;
    };
  };

  testScript = ''
    start_all()
    machine.wait_for_unit("multi-user.target")
    machine.succeed("grep -x 'ID=zenos' /etc/os-release")
    machine.succeed("test -d /Config && test -d /Packages && test -d /Users")
    machine.succeed("zen-dsl compile-tree --root ${sourceRoot} --mode interface --output /tmp/catalog-bundle.json >/tmp/catalog-compile.log 2>&1 || { cat /tmp/catalog-compile.log; exit 1; }")
    machine.succeed("python3 ${./package-catalog-check.py} /tmp/catalog-bundle.json ${./fixtures/package-registry.json} ${../lib} ${pkgs.path}")
    machine.succeed("restic version")
    machine.succeed("age --version")
    machine.succeed("rg --version")
    machine.succeed("fd --version")
    machine.succeed("sox --version")
    machine.succeed("numbat --version")
    machine.wait_for_unit("home-manager-catalog.service")
    machine.succeed("su - catalog -c 'bat --version'")
    machine.succeed("printf 'catalog selector works\\n' | rg 'selector works'")
  '';
}
