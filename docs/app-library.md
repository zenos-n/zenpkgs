# App Library

Enable `desktops.gnome.extensions.app-library.enable = true` to install the
GNOME Shell 50 application library and enable it for desktop users. Disable
`desktops.gnome.extensions.alphabetical-app-grid.enable` when using it.

The package is `byCategories.desktops.gnome.extensions.app-library`, with
canonical ID `com.neg-zero.app-library` and UUID `app-library@neg-zero.com`.
Setup recommends App Library by default. It can be deselected.

Sorting, category assignments, custom ordering and launch history remain per-user
GSettings state, editable through the grid's Sort menu and app context menus.
The module enables the extension without resetting those preferences. Empty
Recents stays visible with a clock placeholder while its toggle is enabled.

Installing a new extension in a running GNOME Wayland session may require one
logout/login before GNOME discovers it. Do not restart the user's session during
installation.
