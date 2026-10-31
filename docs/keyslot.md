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

Search/group-view candidate (source b2478721bfebdd2fd4248e4138a8bf483cb0267f): global results remain visible across selected sidebar groups; direct/recursive/group/whole-vault search with case, password/protected-custom-field, recycled and disabled-group controls, Enter-to-search, syntax help and recursive group browsing. Pending/waiting/error and changed-query guards prevent stale result application; refresh reruns remain passive. Scope/Enter defaults share stock SearchLimitGroup/GUI SearchWaitForEnter; private Keyslot recursive preferences are saved without query text or temporary switches. Runtime compilation only, user manual acceptance pending. No tests/harnesses added or automated behavior runs; [skip ci] publication, compiled channel awaits manual acceptance. App/companion stay separate, Gnosis/companion and installed/live user state unchanged.
Runtime-only catalog artifact: `/nix/store/y9xirw1sg7s8iikqssma0mp68vvyg8vh-keyslot-0.2.0`; native engine `/nix/store/wp677i7rm5yiqi5y3h2l93az7q88jgxr-keyslot-engine-2.7.12`. Build log: `/tmp/keyslot-search-catalog-runtime-build.log`. Native and packaged Python compilation succeeded; user desktop/query acceptance is pending.

Icon-workflow candidate (source bf8503331c300a812955e5dfe63a92986d9f0204): reviewed unused-icon cleanup preserves current/history/recycled and all open-editor draft references. Explicit website icon workflow reviews sanitized site/parent-domain/optional DuckDuckGo URLs, bounds responses/redirects/timeouts, strips entered login/query/fragment, disables cookies/cache, rejects HTTPS downgrade, decodes raster/SVG through existing normalization and chooses largest ICO frames, then previews before metadata storage. HTTP runs in a separately cancellable helper with no open database, with nonce/revision-bound replies, outside the live vault worker/pipe/mutex; HIBP shares bounded transport with its existing fixed HTTPS/padding policy. Existing encrypted transaction/manual-save behavior is retained. Runtime compilation only; user GUI/network/image/cleanup acceptance remains pending. No tests/harnesses added or automated behavior runs. Both publications skip CI; compiled channel awaits manual acceptance. Companion/Gnosis pins and installed/live user state unchanged. Browser-requested favicon automation remains a separate gap.
Runtime-only catalog artifact: `/nix/store/68d1vrf522p5vyd0cbaymbfmm4b27aj4-keyslot-0.2.0`; engine `/nix/store/di8q00h27bw6jbrdsil5zq2jzaaq8dwc-keyslot-engine-2.7.12`. Build log: `/tmp/keyslot-icons-catalog-runtime-build.log`. These are compilation results, with no GUI/network/image behavior claimed verified.

Browser-icon candidate (source 313c6cd1eb6494a49c05407806943a309c819491): authenticated new-login downloadFavicon boolean/string requests reach an optional GTK save-consent switch. Credential save and unchanged browser reply finish before queued icon work; an additive native save-details RPC returns the exact created entry UUID, preserving the old boolean RPC. Existing-entry updates keep upstream icon behavior. Keyless icon worker shared with the manual picker; queued background tasks cancel on lock/helper replacement/integration disable, defer assignment around editors, yield to manual downloads, and do not extend idle time. Native save-time reservations bind the approved website and original icon before queuing; prepare/reply/assignment validate target identity/UUID/URL/icon, allowing unrelated local saves while rejecting changed targets before network contact or assignment. Failure preserves credentials and the existing icon. Picker utility row now precedes catalogue. Runtime compilation only, user browser/network/desktop acceptance pending; no tests/harnesses or automated behavior runs. Both commits skip CI; compiled channel awaits manual acceptance. Companion/Gnosis pins and installed/live state unchanged.
Runtime-only catalog artifact: `/nix/store/h51nwbr64b7frwnyc91dpszjmx9sqlhb-keyslot-0.2.0`; engine `/nix/store/v1gmc4sykw2rfjk1abxhc5jqss8rj0k1-keyslot-engine-2.7.12`. Build log: `/tmp/keyslot-browser-icons-catalog-final-build.log`. Native and packaged Python compilation succeeded; no GUI/network/browser behavior is claimed verified.

Word-list library candidate (source df06b85902a52f79d8d50b71e180d056ef8f5dcd): profile-scoped discovery of custom lists beside the selected KeePassXC configuration, matching stock user-wordlist storage. GTK generator management imports private staged copies, validates through the upstream UTF-8/Diceware/signed-list parser, rejects empty lists and warns below1296 distinct words. Duplicate names publish separate copies without clobber; removal requires confirmation and unchanged regular-file identity, retaining original sources and installed lists. Missing managed selections fall back to the installed default; direct external file selection remains available. Operations use the existing cancellable queue and cleanup staging on failure/cancellation. Runtime compilation only; manual file/parser/desktop acceptance remains pending. No tests/harnesses added or automated behavior runs; both publications skip CI, compiled channel awaits manual acceptance. Companion/Gnosis pins and installed/live user state unchanged.
Runtime-only catalog artifact: `/nix/store/x3mnafrac3gk5j0g53p0rah621k9ikib-keyslot-0.2.0`; engine `/nix/store/mbcq91skqfc9al3y5k5pgdjpz85502y3-keyslot-engine-2.7.12`. Build log: `/tmp/keyslot-wordlists-catalog-runtime-build.log`. Native/Python compilation succeeded; no GUI/file/parser behavior is claimed verified.

Browser-rules/additional-websites candidate (source 7961f540ec59a78645f1d63129e846bb4f128326): GTK entry/group visibility, auto-submit and HTTP-auth rules, inherited group www matching, and paired-connection restrictions distinguishing inherit/all/one connection while retaining disconnected existing IDs. Native option reads return no connection keys, validate unique nonrecycled targets, and bind changed-field-only writes to the reviewed working revision before existing encrypted transactions; entry custom-data changes preserve history and untouched/noncanonical metadata. Entry controls reflect actual upstream forced-group semantics. Dedicated Additional Websites creation/edit/removal reuses upstream KP2A_URL fields and existing revision/duplicate-name/history guards, masks protected list values before UI delivery, uses explicit masked editing and retains literal references. Runtime compilation only; user browser/inheritance/URL/privacy/concurrency acceptance pending. No tests/harnesses added or automated behavior runs; both publications skip CI, compiled channel awaits manual acceptance. Companion/Gnosis pins and installed/live state unchanged.
Runtime-only catalog artifact: `/nix/store/2w9pfkfbp8ig12lz5vvrwb69v3r7hkqb-keyslot-0.2.0`; engine `/nix/store/b317v6dx4f3zim4i9mhbddvpnvc3g3pb-keyslot-engine-2.7.12`. Build log: `/tmp/keyslot-browser-options-catalog-runtime-build.log`. Native/Python compilation succeeded; no UI/inheritance/browser/URL behavior is claimed verified.

Entry-actions candidate (source cc4c75871d28ebf53041d54c282ad5f38272b6e6): same-group Duplicate Entry uses upstream clone UUID/time/title/reference/history flags and retains attachments/icons/custom settings, with password copying and reference generation inside the native helper. Selection mode adds tag add/remove and expiry Now/Never/timestamp controls. Single-use two-minute native reviews bind exact unique nonrecycled UUIDs, canonical choices, database identity and working revision; confirmation shows protected-title-masked selection plus selected/changed counts. No-ops avoid saves; changed entries share the existing encrypted/manual-save transaction and upstream history update. Cancellation and changed/expired reviews refuse mutation. New copies are selected in the UI. Runtime compilation only; user clone/tag/expiry/history/save/concurrency/desktop acceptance pending. No tests/harnesses added or automated behavior runs; both publications skip CI, compiled channel awaits manual acceptance. Companion/Gnosis pins and installed/live state unchanged.
Runtime-only catalog artifact: `/nix/store/z1xq4h8zr0lzca4z1kj3q1v03x3l2mlx-keyslot-0.2.0`; engine `/nix/store/v6pyb87c4z5km8xj36mgb9cmzinahihn-keyslot-engine-2.7.12`. Build log: `/tmp/keyslot-entry-actions-catalog-runtime-build.log`. Native/Python compilation succeeded; no clone/bulk/UI/save/history behavior is claimed verified.

Browser-inventory candidate (source 5fa8c05dd1d688b4da3b0c17f75bedd2cbdd3e23): get-database-entries returns upstream title/UUID/resolved-URL records only after current association authentication and default-OFF shared Browser/AllowGetDatabaseEntriesRequest permission. GTK opt-in confirms broader inventory exposure, including hidden-entry metadata and resolved references/protected values. Native ordering/field resolution/recycle-bin traversal match upstream2.8; errors19/16 represent denial/empty inventory. Scoped permission reads have a five-second RPC budget before/after enumeration, with GUI revocation checked again before delivery; malformed/unreadable policy fails closed, and unrelated settings saves cannot re-grant the shared key. Opening Preferences refreshes without writing. Oversized inventory returns an explicit protocol error without truncation or stopping integration. Native protocol version stays honest about the pinned2.7.12 engine. Runtime compilation only; user browser/client-version/permission/reference/traversal/large-list/race acceptance pending. No tests/harnesses added or automated behavior runs; both publications skip CI, compiled channel awaits manual acceptance. Companion/Gnosis pins and installed/live state unchanged.
Runtime-only catalog artifact: `/nix/store/1qks4zbvnh1dzsgmqdfw8rbr7kpanvni-keyslot-0.2.0`; engine `/nix/store/mhqdik8cvvqy8m7j6qhf4pmk2m5imwa8-keyslot-engine-2.7.12`. Build log: `/tmp/keyslot-browser-listing-catalog-runtime-build.log`. Native/Python compilation succeeded; no browser/permission/reference/traversal/large-list behavior is claimed verified.

## Configurable application shortcuts

Preferences → Keyboard Shortcuts now supports staged recording, conflict
replacement, disabling, per-action resets and restoring all defaults. Shared
actions retain KeePassXC's Qt shortcut keys; private actions have their own
namespace. Reset removes only selected overrides, preserving unrelated keys
and refusing a stale shortcut snapshot. Unsupported platform and multi-stroke
Qt sequences remain stored and inactive until explicitly changed. The editor
records one combination per action; desktop auto-type shortcuts remain in their
existing preferences. Help follows active bindings across windows.

Entry edit, duplicate, delete, username/password/URL/TOTP and other copying use
existing guarded native workflows. They yield to focused text and dialogs.
Ctrl+U copies the URL; Ctrl+Shift+U opens it. Shortcut recording temporarily
inhibits application accelerators, including Quit, and restores them on close.

This batch is runtime compilation only. No tests, harnesses or automated
behavior runs were added or performed; keyboard-layout, conflict, text-focus,
recording and desktop acceptance remain with the user's manual stress testing.
The full drop-in replacement goal is still incomplete.
