# Gnosis

Enable `users.<name>.programs.gnosis` (or the corresponding
`system.programs.gnosis` scope). The program-tree mount discovers
`modules/programs/gnosis.zmdl`; no additional registration is needed.

```zcfg
users.alex.programs.gnosis = {
  enable = true;
  defaultBrowser = false;
  apps.mail = {
    name = "Mail";
    url = "https://mail.example/";
    icon = "internet-mail";
  };
};
```

`apps` creates named launchers under the user's applications directory. The
app key (letters, digits, hyphens and underscores) is the stable profile ID;
changing the display name or URL keeps browsing data, while changing the key
selects a new profile. Each app uses a writable directory under
`$XDG_DATA_HOME/com.neg-zero.Gnosis.WebApp_<key>`. Gnosis creates it on first
launch and recognizes the declarative launcher in its Web Apps list even before
that launch. It uses the local desktop entry for launch and leaves the profile
intact when the app is removed from configuration. Change the app's name, URL
or icon in ZenOS configuration; Gnosis does not offer Remove or Edit for these
managed entries.

The Gnosis package pin includes local desktop entry support for these managed
apps.

The canonical package is `pkgs.com.neg-zero.gnosis`, also exposed as
`pkgs.byCategories.apps.browsers.gnosis`. Both selectors resolve to one
package. The launcher uses `com.neg-zero.Gnosis.desktop`. The package registry
identity is separate from the application identity; Gnosis migrates existing
browser profiles, credentials, settings and KeePassXC pairing.

The source is [zenos-n/gnosis](https://github.com/zenos-n/gnosis), pinned by
the `gnosis` flake input and `flake.lock`. Zenpkgs imports the project's own
package output and locked Nixpkgs rather than rebuilding it against the catalog's
Brave version. The native binary adapters require their exact Brave version.
Package source and assets stay in the Gnosis repository; no workstation path is
part of the package declaration.

Override `package` to select another Gnosis derivation. Development validation
can use `--override-input gnosis git+file:///path/to/gnosis --no-write-lock-file`;
this is an explicit local override, not the published source pin.
The CEF/WebKit service migration is still in progress.

The module installs Gnosis without starting or restarting a running browser.
`defaultBrowser` defaults to `false`. Enabling it declares the Gnosis desktop
entry as the HTTP, HTTPS, HTML and XHTML handler, without managing writable
browser preferences or profile data.

Open **hamburger menu → Password Manager** to select **Keyslot**, **KeePassXC**
or **Automatic**. Keyslot uses a dedicated native-messaging endpoint, so the two
apps may run concurrently. If Keyslot is installed outside PATH, enable Gnosis
in Keyslot’s **Preferences → Browser Integration → Configure…** first.

**Forget Browser Connections…** removes this Gnosis profile’s saved database
pairing keys and cached logins after confirmation. It preserves vault entries;
use **Connect Database…** to authorize a new connection in the chosen manager.
Existing pairings are preserved when changing managers.
