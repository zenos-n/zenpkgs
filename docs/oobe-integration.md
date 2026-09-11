# Installed OOBE integration

The canonical `system.oobe` module is declared in `modules/system/oobe.zmdl`.
`system.oobeMode` defaults to false. Setup enables it only in the temporary
host's imported ZCFG and omits it from the final host. No marker file or source
text inspection participates in evaluation.

The module supplies the disposable `zenos` account at `/run/zenos-oobe`, the
GNOME mode and clock extensions, locked shell defaults, greetd, and one
`zenos-oobe` user service running `zenos-setup --oobe`. Its service environment
sets `ZENOS_SETUP_DRY_RUN=0`, `ZENOS_OOBE=1`, the wrapper-first PATH, and the
GnomeDesktop/GWeather/NetworkManager typelib paths. The shell service sets the
GNOME session mode; setting dry-run there would not configure the Setup service.

OOBE uses action priority 50 so selected permanent desktop/login settings cannot
replace the temporary session. It disables GDM, SDDM, Plasma Login Manager,
LightDM, display-manager autologin, and SSH. Final GNOME configurations enable
GDM through `desktops.gnome`; headless and other desktop configurations do not.

`lib/compat/system-modules/oobe-runtime.nix` supplies only the computed NixOS
session-wrapper command. The authored `legacy` alias does not expose computed
NixOS defaults, so the wrapper must be read from the backend config. Both this
adapter and the public declaration are installed by `nixosModules.default`.

`system.installed-base` owns the common installed defaults. Its internal runtime
adapter wires the existing ZenFS and rEFInd hooks, user XDG directories, fonts,
and installed services. The live image disables installed-base and supplies its
own concrete image composition. The installed flake retains local host
discovery, check/compile/parse, source retention, and the generated Nix store
output; it does not embed the live composition.

Evaluate `checks.x86_64-linux.oobe-gnome` for public-module login, account,
service-environment, session-wrapper, and headless assertions. The installed
flake integration and hardware ZCFG fixtures are in zenos-next. Runtime and
installation acceptance must run in a ZenOS VM.
