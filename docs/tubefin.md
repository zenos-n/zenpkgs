# TubeFin

Enable TubeFin for a user:

```zcfg
users.alex.programs.tubefin.enable = true;
```

`system.programs.tubefin.enable` supplies an inherited program default. The
module defaults to disabled and installs `com.neg-zero.Tubefin` for enabled
users. `package` can select another compatible derivation. Direct package
selection also works through `packages.com.neg-zero.Tubefin` or the existing
`packages.byCategories.apps.video.tubefin` compatibility view.

The package pins TubeFin 1.7.4 and yt-dlp 2026.11.23. It uses the upstream
`default.nix`, including the app-local GTK HDR backport and WebKitGTK login.
HDR applies to explicitly HDR video; windows, controls and menus remain SDR.
Automatic quality uses the current monitor's physical height; higher resolutions
remain available manually. Signed-in metadata is combined with usable public
adaptive streams for public videos. Resume is offered by toast using local or
YouTube account progress; it is applied only when Resume is pressed.

Accounts, KeePassXC pairing, settings, media and history remain app-managed.
The module writes no credentials or application configuration, changes no MIME
associations, opens no firewall ports, and does not start a background service.
KeePassXC autofill uses the installed `keepassxc-proxy` with Browser Integration
enabled. Sessions and cookies stay under the user's XDG configuration directory.
