# French Localisation

## Keyboard layout

Three places set the keyboard layout to French AZERTY — they must stay in sync:

| File | Setting |
|------|---------|
| `configuration.nix` | `console.keyMap = "fr"` (TTY) |
| `configuration.nix` | `services.xserver.xkb.layout = "fr"` (X11 / SDDM) |
| `config/sessions/hyprland/default.nix` | `kb_layout = "fr"` (Hyprland / Wayland) |

## Locale

`defaultLocale` is kept as `en_US.UTF-8` so the system UI stays in English.
Regional format categories are set to `fr_FR.UTF-8`:

| Variable | Effect |
|----------|--------|
| `LC_TIME` | DD/MM/YYYY, 24h clock |
| `LC_MONETARY` | € currency symbol |
| `LC_NUMERIC` | Comma as decimal separator (e.g. `3,14`) |
| `LC_MEASUREMENT` | Metric system |
| `LC_PAPER` | A4 paper size |
| `LC_ADDRESS` / `LC_TELEPHONE` / `LC_NAME` | French formatting |

> **Note:** `LC_NUMERIC = fr_FR` uses a comma as the decimal separator. Some programs
> expect a period and may behave oddly. If that happens, override it back to `en_US.UTF-8`
> for that variable.

Both locales are generated via `i18n.supportedLocales`.

## Workspace keybindings (AZERTY fix)

On AZERTY the number row produces `& é " ' ( - è _ ç à` without Shift, so
`Super+1` would require `Super+Shift+&` — unusable. Workspace binds in
`config/sessions/hyprland/binds.nix` use the actual unshifted keysym names:

| Workspace | Keysym | Physical key |
|-----------|--------|--------------|
| 1 | `ampersand` | `&` |
| 2 | `eacute` | `é` |
| 3 | `quotedbl` | `"` |
| 4 | `apostrophe` | `'` |
| 5 | `parenleft` | `(` |
| 6 | `minus` | `-` |
| 7 | `egrave` | `è` |
| 8 | `underscore` | `_` |
| 9 | `ccedilla` | `ç` |
| 10 | `agrave` | `à` |

Move a window to a workspace: `Super+Shift+<same key>`.
