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

Manual saving/recovery/Save As candidate (source a51c03befb47f126af672318989cbc973768819f): optional explicit Save and save-on-exit; encrypted checkpoints, independent working/file revisions, keyless encrypted commits after security lock, global recovery access even for missing/forgotten sources, and guarded merge/discard/overwrite. Save As retargets the open vault, preserves replaced files as encrypted backups, migrates remembered keys/login settings and resolves the originating recovery copy after a durable save. Current candidate is for user manual stress testing, not a production-parity claim. Normal app/engine builds compile runtime only; existing development checks are opt-in. No new tests or harnesses; automated runs stopped at user request and publication skips CI. App/extension remain separate packages, companion/Gnosis pins unchanged. Installed system and running user app are not activated/restarted by this update.
Runtime-only catalog artifact: `/nix/store/nq5s3fwvhyq96h3q9j44070ngabdp422-keyslot-0.2.0`; all 39 Python source files match the candidate. Build log: `/tmp/keyslot-saving-catalog-runtime-build.log`. CI is skipped for this publication; the compiled release channel awaits manual acceptance. No automated-test result is claimed for this candidate.

Reviewed recycle-bin candidate (source 5fbc3eacdd2f719c98d4df4b8fe2f0bcd0f9e34f): original-location entry/group restore, bulk and whole-bin restore, destination override with root fallback, explicit permanent deletion and emptying, including disabled-bin handling. Native review binds the exact selection and working revision; counts include nested contents, upstream deletion records preserve merge semantics, and the existing encrypted transaction/manual-save model handles changes. GTK single/bulk/group actions and Delete/Shift+Delete are wired. Runtime-only app/engine compilation succeeds; user manual stress acceptance is pending. No new tests/harnesses or automated runs. Publication skips CI; compiled release channel awaits manual acceptance. Companion/Gnosis pins and installed/running user state remain unchanged.
Runtime-only catalog artifact: `/nix/store/8iirbaxs2fbjqlrc0cxlln2mnv6faabj-keyslot-0.2.0`; native engine `/nix/store/hp2jcabdj0d5sx5l02dzdkgpl9dhdm6r-keyslot-engine-2.7.12`. Build log: `/tmp/keyslot-trash-catalog-runtime-build.log`. No runtime acceptance result is claimed.

Database-report candidate (source 84d10cf25c9d7e0f5d4ebf4cfa1090e8439ef9b4): reused-password groups, browser URL/Allow/Deny inventory with filters/protected-URL hiding, reviewed entry exclusion and single/shown permission reset, passkey/TOTP statistics. Per-run-confirmed HIBP online checks send five SHA-1 characters to the fixed HTTPS range endpoint with padding; full hashes and matching stay native. Extracted SHA-1 corpus checks run in bounded chunks. Progress, cancellation, partial findings, network retry, stale-revision guards and report-refresh invalidation are wired in GTK. Runtime compilation only; user live-network/desktop/corpus/reference stress acceptance is pending. No tests/harnesses added or automated runs. Publication skips CI; compiled release channel awaits manual acceptance. Separate companion package, Gnosis pins, installed system and running app remain unchanged.
Runtime-only catalog artifact: `/nix/store/85wkqdv8p7hjlkj78xmi3gcapywhgik5-keyslot-0.2.0`; native engine `/nix/store/bx350cx7hkh5hhi2vlk8ddxaainxlpad-keyslot-engine-2.7.12`. Build log: `/tmp/keyslot-reports-catalog-runtime-build.log`. These are compilation results; no GUI/API/corpus behavior is claimed verified.
