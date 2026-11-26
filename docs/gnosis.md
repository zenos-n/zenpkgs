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
its owning `pkgs/apps/browsers/gnosis.zpkg` declaration. Zenpkgs imports the project's own
package output and locked Nixpkgs rather than rebuilding it against the catalog's
Brave version. The native binary adapters require their exact Brave version.
Package source and assets stay in the Gnosis repository; no workstation path is
part of the package declaration.

Override `package` to select another Gnosis derivation for development validation.
The published source remains owned by the Gnosis package declaration.
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


User-installed web apps offer generic **Link Associations** under
**Preferences → Web Apps → select an app**. Enable **Open Links in This App**
and add each domain using **Add Domain**, then Enter or the plus button.
Domains appear as removable chips in a native wrapping list.
With Gnosis as the default HTTP/HTTPS browser, matching incoming links reuse
the app's profile and window, or start it if closed. The most specific domain
wins; ambiguous claims, unrelated links and private browsing remain in the browser.
Disabling a claim takes effect on the next incoming link. The operating system's
HTTP/HTTPS default is preserved. Managed declarative launcher definitions remain
controlled by ZenOS configuration.

The source pin now includes these associations, native external-application
confirmation, destination-page history swipe previews and native scroll momentum.
Existing browser and web-app windows adopt the update after a normal restart.


Gnosis separates SDR content from the monitor's HDR capability. SDR-only pages
use native sRGB output, Display-P3 SDR canvases retain their primaries, and HDR
images/video retain native PQ highlights. Switching content color spaces commits
new asynchronous Wayland descriptions, including for a static HDR image that
does not repaint again. Real full uBlock Origin and the Chromium sandbox remain
in use; the module does not alter monitor mode or personal color preferences.
A mixed SDR/HDR page may use one PQ surface while its SDR regions retain SDR
luminance. The native regression checks encoded colors, P3 pixels, SDR gray
bands, HDR media, repeated fullscreen cycles and fractional scaling; physical
monitor calibration and compositor-specific SDR enhancement profiles remain
separate from those pixel/protocol checks. Running windows receive the update
at their next normal browser launch.

The native color path keeps SDR and Display-P3 SDR distinct from HDR capability.
HDR pages also put GTK's clipped edge strips into HDR, preventing a darker band
at rounded window edges. Closed tabs destroy their browser documents rather
than parking a hidden page; the managed browser can remain alive with zero tabs.
Web-app launchers follow the installed Gnosis launcher across upgrades, while
existing running windows retain their original executable until closed.
