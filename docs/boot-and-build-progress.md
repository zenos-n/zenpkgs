# Boot and Nix build progress

ZenOS keeps its Plymouth splash by default. Press Escape to see Bootvine's live
systemd dependency tree; press Escape again to return. The viewer follows the
systemd initrd into the main system, including unlock prompts, and is also
available during shutdown. A missing viewer keeps Plymouth's ordinary details
screen; a foreground viewer crash restores Plymouth. Display manager handoff
retains the login screen's console.

These defaults are selected by installed-base and installer composition:

```zcfg
system.boot.verbose.enable = true;
system.nix.monitor.enable = true;
```

Set either option to false to opt out. Bootvine requires a systemd initrd.
The external [ZenOS Bootvine source](https://github.com/zenos-n/bootvine) preserves
the [upstream project](https://codeberg.org/wvhulle/bootvine) and GPL-3.0-or-later
license. Its small Plymouth patch is applied by the internal integration module.

Interactive `nix build`, `nix run`, `nix shell`, `nix develop`, `nix copy` and
`nix env shell` show nix-output-monitor automatically. ZenOS rebuilds use the
same monitor while keeping their saved logs free of progress redraws. Open a
new terminal after activation to load the shell function.

The monitor reads Nix's independent `json-log-path` socket. It does not pipe
application input or output and does not evaluate the target a second time.
Explicit machine output, completion, help, noninteractive commands and unsupported
subcommands keep ordinary Nix behavior. Use `command nix ...` or
`ZENOS_NOM=0 nix ...` to bypass monitoring. The implementation requires Linux pidfds
and Nix's JSON log socket (verified with Nix 2.34.8 and NOM 2.2.0).

Validation covers a VM with the ZenOS splash, LUKS unlock, Escape in initrd and
stage 2, preserved history, systemd password entry, viewer crash fallback and
shutdown; shell PTY tests cover streams, arguments, exit status and rebuild logs.
Physical graphics/firmware remain hardware dependent; the host's next boot is
the final hardware check.
