# Gnosis

Enable `users.<name>.programs.gnosis` (or the corresponding
`system.programs.gnosis` scope). The program-tree mount discovers
`modules/programs/gnosis.zmdl`; no additional registration is needed.

```zcfg
users.alex.programs.gnosis = {
  enable = true;
  defaultBrowser = false;
};
```

The canonical package is `pkgs.com.neg-zero.gnosis`, also exposed as
`pkgs.byCategories.apps.browsers.gnosis`. Both selectors resolve to one
package. The registry identity is independent of the retained
`io.github.doromiert.Jupiter.desktop` compatibility identity: existing browser
profiles, credentials, settings and KeePassXC pairing remain intact.

The source is [doromiert/gnosis](https://github.com/doromiert/gnosis), pinned by
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
`defaultBrowser` defaults to `false`. Enabling it declares the retained desktop
entry as the HTTP, HTTPS, HTML and XHTML handler, without managing writable
browser preferences or profile data.
