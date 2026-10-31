# Keyslot

The app and GNOME companion are separate packages:

- `pkgs.com.neg-zero.keyslot` (`apps.security.keyslot`) installs the GTK4/libadwaita app and its private KeePassXC core helpers.
- `pkgs.com.neg-zero.keyslot-extension` (`desktops.gnome.extensions.keyslot`) installs `keyslot@neg-zero` for GNOME Shell 50; select the app separately and enable the extension in your GNOME settings.

Sources remain in the published Keyslot and companion repositories. ZenPkgs pins
their exact revisions in `flake.nix` and `flake.lock`; no workstation paths or
application assets are embedded in the catalog.

Enable **Preferences → Browser Integration** in Keyslot and configure the desired
browsers. Gnosis is supported alongside Firefox, Chrome, Chromium, Brave,
Vivaldi, Edge and Tor Browser. Registrations are explicit and reversible; a
confirmed replacement saves the previous registration for restoration.
The dedicated `keyslot-browser-proxy` can reach Keyslot while stock KeePassXC is
also running. In Gnosis, open **hamburger menu → Password Manager** to choose
Keyslot, or forget an old pairing and connect again. Keep Keyslot running for
browser access. Credentials and remembered access rules stay in the vault.

The app also exposes `keepassxc`, `keepassxc-cli` and a compatibility
`keepassxc-proxy`. Native operations use the pinned KeePassXC 2.7.12 core with
reviewed security and serialization backports. Login-keyring unlock, background
operation, idle locking, TOTP, passkeys, SSH integration, Secret Service and
KeeShare controls are implemented; their remaining platform and parity limits
are recorded in the app’s `docs/parity.md` and `docs/release-readiness.md`.
This development package does not yet claim complete KeePassXC feature parity.

The browser update passed the existing 323 backend checks, all 19 application
gates and 332 native security checks on the GNOME 50 host. Real browser use
verified password filling, TOTP, generation, saving and WebAuthn create/get with
independent signature verification. Manual Gnosis use verified manager switching
with both apps running, pairing, cancellation, forgetting and reconnecting.
These results cover implemented behavior, not full production acceptance.
