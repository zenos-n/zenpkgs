# Monogram desktop

The canonical package is `com.neg-zero.monogram`; its category alias is
`apps.communication.monogram`. Both build the externally pinned
[doromiert/monogram-desktop](https://github.com/doromiert/monogram-desktop)
source using its upstream Nix recipe.

Select it for one user:

```zenos
users.doromiert.packages.com.neg-zero.monogram = true;
```

The executable is `monogram-desktop`. The upstream desktop/application ID remains
`com.negzero.MonogramDesktop`, preserving existing desktop integration and data.
The application stores credentials in Secret Service and supports the shared
Monogram Android QR/TOTP LAN sync protocol. Synced wallet recovery capsules can
be stored and relayed, while desktop wallet spending is still unimplemented.

Validation includes the real package build, canonical/category identity equality,
registry equivalence/count/provider checks, and the upstream native UI, keyring,
Android/JNI and encrypted transport checks.
