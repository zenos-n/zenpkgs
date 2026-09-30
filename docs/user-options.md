# User options

The user catalog adds **241 native settings** under `users.<name>`:

- `profile`: account creation, display name, home, UID, groups, SSH keys, runtime password-hash file, login shell, and lingering services.
- `shell` and `environment`: aliases, session variables, command search paths, editor, pager, and browser commands.
- `locale`: language, regional formats, and personal time zone.
- `userDirs`: standard folder locations and directory creation.
- `defaultApps`: browser, email, file manager, text editor, document, image, music, and video associations.
- `fonts`: personal font families and rendering.
- `theming.gnome`: 184 preferences covering appearance, clock, input, windows, workspaces, accessibility, shortcuts, privacy, locking, wallpaper, Night Light, and idle behavior.

Every new setting defaults to `null`, leaving existing policy or personal
preferences untouched. An explicit `false` is applied. Empty lists are real
values, although account groups and SSH keys retain additive list merging.
Existing `programs`, `packages`, and `legacy` routes remain available.

```zcfg
users.alex = {
  profile = {
    normalUser = true;
    displayName = "Alex";
    homeDirectory = "/Users/alex";
  };
  environment = { editor = "nano"; searchPath = [ "$HOME/.local/bin" ]; };
  locale = { language = "en_US.UTF-8"; timeZone = "Europe/Warsaw"; };
  userDirs = {
    enable = true;
    createDirectories = true;
    documents = "/Users/alex/Documents";
  };
  defaultApps = { enable = true; browser = "firefox.desktop"; };
  theming.gnome = {
    defaultDarkMode = true;
    appearance.textScale = 1.25;
    clock.format = "24h";
    touchpad.tapToClick = true;
    shortcuts.openCalculator = [ "<Super>c" ];
    privacy.rememberRecentFiles = false;
  };
  programs.git = { enable = true; authorName = "Alex"; };
};
```

An existing account can leave `profile.normalUser` unset. Empty user records
still opt existing accounts into system program defaults. New accounts need
the installation's usual backend state-version policy; if it is not already
provided, retain `users.alex.legacy.homeManager.home.stateVersion = "26.05"`
for a new installation. Preserve existing state versions when upgrading.

`theming.gnome` configures only the selected user's session; it does not install
or enable GNOME. System GNOME defaults stay under `desktops.gnome`. Explicit
personal choices are reapplied during activation, but remain editable in GNOME
between activations. Login-screen and machine settings remain system choices.

Default-app values are installed desktop-file IDs. Command strings and font
family names do not install packages. User folder paths are absolute and do not
move existing files. Locale choices require those locales to be installed on
the machine; session environment changes require a new login. Shell aliases
apply through the corresponding managed shell program. A login-shell package
must also be enabled/supported by the system. Password hashes are read from an
absolute runtime file path, never stored as plaintext configuration.

The normative catalog is
[user-options.md](../../zenos-n-next/design/user-options.md).
Run the backend, export, and runtime checks in the ZenOS VM:

```sh
nix build --no-link path:.#checks.x86_64-linux.user-options-vm
```

The test verifies account isolation, all 241 exported options and nullable
defaults, invalid enums and ranges, file generation, all 184 GNOME wire mappings
against pinned schemas, inherited defaults, and editable/reapplied preferences.

For a smaller Explorer upload containing native user options and the package
catalog, without the upstream compatibility trees:

```sh
nix eval --impure --json --file scripts/gen-user-docs.nix > ../zenpkgs.users.json
```

This is an explicitly labeled filtered view of the canonical search export.
The full export remains available through `scripts/gen-docs.nix`.
