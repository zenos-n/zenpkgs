# Vesktop and Vencord

The Vesktop package uses the curated Vencord package. Vencord 1.15.3 needs
two upstream compatibility fixes for Discord's October 2026 Rspack update:
[plain-value module exports](https://github.com/Vendicated/Vencord/commit/ba8453ebac146b241b18409640b0548f37b9064e)
and [module lookup without module.id](https://github.com/Vendicated/Vencord/commit/a764679e9f988903560f408d6615c709d71281ce).
Without them, startup can stop at a white screen with `i.A is not a constructor`.
The package fetches the original GPL-3.0-or-later patches with fixed hashes.

Nixcord overrides Vesktop's Vencord dependency with `discord.vencord.package`.
Select both curated packages when using that integration:

```zcfg
users.<user>.programs.nixcord = {
  enable = true;
  discord.enable = false;
  discord.vencord.package = $pkgs.byCategories.apps.communication.vencord;
  vesktop.enable = true;
  vesktop.package = $pkgs.byCategories.apps.communication.vesktop;
};
```

`pkgs.legacy.vencord` remains the unmodified pinned Nixpkgs package and does
not include these backports. Remove the backports when updating the curated
package to an upstream version that includes both fixes.

The `vencord` flake check exercises getter and plain-value exports from the
built renderer source map, and checks the Vencord path in both the default
Vesktop build and the build with Nixcord's override arguments.
