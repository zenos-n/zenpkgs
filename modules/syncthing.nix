{ lib, ... }:

{
  imports = [
    # Map 'zenos.system.syncthing' -> 'services.syncthing'
    (lib.mkAliasOptionModule (lib.splitString "." "zenos.system.syncthing") (
      lib.splitString "." "services.syncthing"
    ))
  ];

  options.zenos.system.syncthing."_zenpkgs-meta" = lib.mkOption {
    type = lib.types.str;
    description = ''
      High-performance, continuous file synchronization service

      Syncthing replaces proprietary sync and cloud services with something open, trustworthy and decentralized.
      Features: 
      - Cross-platform: Available on Windows, macOS, Linux, BSD, Solaris and mobile.
      - Secure: All communication is secured using TLS. Every node is identified by a strong cryptographic certificate, and all data is encrypted end-to-end.
      - Easy to use: The web GUI makes it easy to administer and monitor your Syncthing instances. It also provides a REST API for integration with other applications.
      - Efficient: Syncthing uses a block-level synchronization algorithm, which means that only the changed parts of files are transferred, saving bandwidth and time.
      - Open Source: Syncthing is free and open source software, licensed under the GNU General Public License version 3.0 (GPLv3). This means you can use, modify and distribute it without any restrictions.

      For more information, visit the official website: https://syncthing.net/

      ## Important note: This module is a map of legacy.services.syncthing. It may not have perfect ZenPkgs documentation coverage.
    '';
    default = "meta-marker";
    visible = true;
    internal = false;
  };
}
