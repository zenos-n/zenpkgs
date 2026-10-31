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

Explicit KeePassXC INI profiles are supported through `--config`, `--localconfig`,
`KPXC_CONFIG` and `KPXC_CONFIG_LOCAL`. Supported settings and generator options
are updated by Qt without replacing unrelated keys. Remembered key files and
hardware slots use KeePassXC dictionaries; open vaults restore as separate
windows, including hidden background startup. Login unlock targets its enrolled
vault independently of the focused window. Private GTK, stdin, configuration
conflict and disposable-keyring acceptance passed; physical hardware and broader
preference migration remain open. No tests or harnesses were added for this update.

Vault files now reload after external changes, with directory monitoring and
asynchronous metadata fallback. Checks stay passive, actual reloads wait for
forms/choosers, and missing or unreadable sources retain the open data for an
encrypted copy. Reload Changed Vaults maps AutoReloadOnChange. First launches
reuse stock settings when private preferences are absent, and explicit profile
requests safely reject incompatible older running instances. Private recovery,
chooser, draft, browser/URI and idle-lock acceptance passed. Broader network,
hardware and changed-key reauthentication remain open.

Changed-file key recovery (source caf013e5a7ed1c378be7d0683a865f804c532e5f): new credentials reopen a candidate while retaining the old database on failure or cancellation. The dialog offers an encrypted copy before switching; successful authentication refreshes enrolled keyring/key-file memory and invalidates the old quick-unlock credential. Manual Reload defers around forms/choosers and uses the same recovery path. Private real GTK/password+file rotation, stock-readable rescue, actual disposable GNOME keyring and idle-lock cleanup verified; existing 323 backend/19 application and 332 native checks pass. No new tests/harnesses. Hardware/network acceptance remains open. App and companion remain separate packages; extension/Gnosis pins unchanged.
Published-source catalog build `/nix/store/nwrk7xmkp942p24k6a6890fhrvxrjsmi-keyslot-0.2.0` passes the same existing 323 backend checks and 19 application gates; all 38 Python files match the source, native engine remains `5wi36i91`, companion remains `7dwdfb8v`. Log: `/tmp/keyslot-reauth-catalog-build.log`.
