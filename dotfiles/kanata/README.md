# keyhack-kanata

![License](https://img.shields.io/badge/license-MIT-blue.svg)
![Platform](https://img.shields.io/badge/platform-Linux-blue.svg)

> A production-grade [Kanata](https://github.com/jtroo/kanata) configuration that turns a standard keyboard into a 5-layer productivity engine. Built for GNOME on Linux with kitty terminal integration.

---

## Table of Contents

- [Overview](#overview)
- [The 5 Layers](#the-5-layers)
- [Key Concepts](#key-concepts)
- [Installation](#installation)
- [Configuration Files](#configuration-files)
- [Layer Reference](#layer-reference)
- [Customization](#customization)
- [Troubleshooting](#troubleshooting)
- [Resources](#resources)

---

## Overview

This configuration uses **tap-hold** mechanics to compress modifier keys, symbol layers, navigation, and window management into the same physical keymap. No keymap switching software. No external tools. Just Kanata running as a user-level systemd service.

The design philosophy is **layers over reach** — instead of stretching for modifier chords or function keys, every key on the home row and number row carries a secondary action when held.

> **Note:** The **Caps Lock** and **Esc** keys are swapped across all layers. The key in the Caps Lock position sends `Esc`, and the key in the Esc position sends `Caps Lock`.

| Component | Requirement |
|-----------|-------------|
| **OS** | Linux |
| **Desktop** | GNOME (for workspace/window bindings) |
| **Terminal** | kitty (for tab/scroll aliases) |
| **Tool** | Kanata |

---

## The 5 Layers

The configuration is organized into five layers. Four are accessed via tap-hold on physical keys; one is always active as the base.

| Layer | Name | Trigger | Purpose |
|-------|------|---------|---------|
| **Layer 1** | Base | Default | Typing with tap-hold modifiers and smart symbol keys |
| **Layer 2** | Window/Workspace | Hold **Left Meta** | GNOME window tiling, workspace switching, kitty tabs |
| **Layer 3** | Symbols | Hold **Spacebar** | Direct access to programming symbols without Shift |
| **Layer 4** | Editing | Hold **Left Ctrl** | Arrow keys, text deletion, mouse wheel emulation |
| **Layer 5** | Numbers | Hold **Right Ctrl** | Numpad-style number entry on the left hand |

```
┌─────────────────────────────────────────────────────────────────┐
│                      LAYER ARCHITECTURE                         │
├─────────────────────────────────────────────────────────────────┤
│                                                                 │
│   Layer 1 (Base)      →  Default; tap-hold everywhere            │
│   Layer 2 (Window)    →  Hold Left Meta / Super key             │
│   Layer 3 (Symbols)   →  Hold Spacebar                          │
│   Layer 4 (Editing)   →  Hold Left Ctrl                         │
│   Layer 5 (Numbers)   →  Hold Right Ctrl                        │
│                                                                 │
└─────────────────────────────────────────────────────────────────┘
```

---

## Key Concepts

### Tap-Hold Modifiers

The home row acts as modifiers when held, letters when tapped:

| Key | Tap | Hold |
|-----|-----|------|
| `A` | `a` | `Ctrl+A` (select all) |
| `S` | `s` | Left Meta (Super) |
| `D` | `d` | Left Alt |
| `F` | `f` | Left Ctrl |
| `H` | `h` | `Shift+`` (GNOME Activities) |
| `J` | `j` | Right Ctrl |
| `K` | `k` | Right Alt |
| `L` | `l` | Right Meta |

### Smart Number Row

Symbols are emitted when the number row keys are held — no Shift required:

| Key | Tap | Hold |
|-----|-----|------|
| `` ` `` | `` ` `` | `~` |
| `1` | `1` | `!` |
| `2` | `2` | `@` |
| `3` | `3` | `#` |
| `4` | `4` | `$` |
| `5` | `5` | `%` |
| `6` | `6` | `^` |
| `7` | `7` | `&` |
| `8` | `8` | `*` |
| `9` | `9` | `(` |
| `0` | `0` | `)` |
| `-` | `-` | `_` |
| `=` | `=` | `+` |

### Bracket Modifiers

Punctuation keys output shifted variants on hold:

| Key | Tap | Hold |
|-----|-----|------|
| `[` | `[` | `{` |
| `]` | `]` | `}` |
| `;` | `;` | `:` |
| `'` | `'` | `"` |
| `,` | `,` | `<` |
| `.` | `.` | `>` |
| `/` | `/` | `?` |

### Function Row

The `F1`–`F12` row is remapped to system and media controls:

| Key | Hold Action |
|-----|-------------|
| `F1` | Quake terminal dropdown (`Ctrl+Alt+Q`) |
| `F2` | Run command (`Alt+F2`) |
| `F3` | Decrease display brightness (`Ctrl+Meta+Down`) |
| `F4` | Increase display brightness (`Ctrl+Meta+Up`) |
| `F5` | Toggle mute speakers/audio output (`Alt+F5`) |
| `F6` | Volume down (`Alt+F6`) |
| `F7` | Volume up (`Alt+F7`) |
| `F8` | Toggle microphone (`Alt+F8`) |
| `F9` | Take screenshot (`Alt+F9`) |
| `F10` | Lock screen (`Ctrl+Alt+Meta+L`) |
| `F11` | Unmapped |
| `F12` | Unmapped |

### Caps Lock / Esc Swap

Across **all layers**, the physical `Caps Lock` key sends `Esc`, and the physical `Esc` key sends `Caps Lock`.

---

## Installation

### Install Kanata

```bash
# Via cargo
cargo install kanata

# Or download from GitHub releases
# https://github.com/jtroo/kanata/releases
```

### Configure udev (Linux)

```bash
sudo groupadd -f uinput
sudo usermod -aG input $USER
sudo usermod -aG uinput $USER

echo 'KERNEL=="uinput", MODE="0660", GROUP="uinput", OPTIONS+="static_node=uinput"' | \
    sudo tee /etc/udev/rules.d/99-kanata.rules

sudo udevadm control --reload-rules
sudo udevadm trigger
```

Log out and back in for group changes to take effect.

### Clone and Deploy

```bash
git clone https://github.com/stefan-hacks/keyhack-kanata.git
cd keyhack-kanata

mkdir -p ~/.config/kanata
cp kanata_gnome.kbd ~/.config/kanata/kanata.kbd
```

### Systemd User Service

Create `~/.config/systemd/user/kanata.service`:

```ini
[Unit]
Description=Kanata keyboard remapper
After=default.target

[Service]
Type=simple
Environment=PATH=/usr/local/bin:/usr/local/sbin:/usr/bin:/bin
Environment=DISPLAY=:0
ExecStart=/bin/sh -c 'exec kanata --cfg ~/.config/kanata/kanata.kbd'
Restart=on-failure
RestartSec=5

[Install]
WantedBy=default.target
```

Enable and start:

```bash
systemctl --user daemon-reload
systemctl --user enable kanata.service
systemctl --user start kanata.service
```

---

## Configuration Files

| File | Purpose |
|------|---------|
| `kanata_gnome.kbd` | **Primary config** — 5 layers with GNOME/kitty integration |
| `kanata.bak` | Legacy 3-layer config (retained for reference) |

Use `kanata_gnome.kbd` as the active configuration. It is tuned for GNOME desktop environments and assumes kitty is the default terminal for tab/scroll aliases.

---

## Layer Reference

### Layer 1 — Base

![Layer 1 — Base](assets/layer1_base.png)

Default typing layer. Nearly every key has a tap-hold dual role. Tap for the letter, hold for the modifier or action shown in blue. The `Caps Lock` and `Esc` keys are swapped — the physical Caps Lock position sends `Esc`, and the physical Esc position sends `Caps Lock`.

### Layer 2 — Window/Workspace

![Layer 2 — Window/Workspace](assets/layer2_window.png)

Hold **Left Meta** (`S` key or physical Windows key) to activate.

| Key | Action |
|-----|--------|
| `Y` / `U` / `I` / `O` | Move window to previous display / workspace left / workspace right / move window to next display |
| `H` / `J` / `K` / `L` | Workspace previous / down / up / next |
| `N` / `M` / `,` / `.` | Switch to workspace 1 / 2 / 3 / 4 |
| `P` | Play/pause media |
| `[` / `]` | Previous track / next track |
| `;` / `'` | kitty scroll left / right (`S-M-h` / `S-M-l`) |
| `F12` | Reload Kanata config (`lrld`) |

### Layer 3 — Symbols

![Layer 3 — Symbols](assets/layer3_symbols.png)

Hold **Spacebar** to activate. Outputs programming symbols directly. This layer removes the need to chord Shift for common programming characters.

| Row | Mapping |
|-----|---------|
| Number row | Unmapped |
| `Q`–`T` | `!` `@` `#` `$` `%` |
| `Y` | `0` |
| `U`–`P` | `(` `)` `{` `}` |
| `[` / `]` | `[` `]` |
| `A`–`F` | `^` `&` `*` `/` `` ` `` |
| `G`–`L` | `~` `\|` `:` `"` |
| `Z`–`/` | `-` `+` `_` `=` `\` `<` `>` `,` `.` `?` |

### Layer 4 — Editing

![Layer 4 — Editing](assets/layer4_editing.png)

Hold **Left Ctrl** to activate.

| Key | Action |
|-----|--------|
| `H` / `J` / `K` / `L` | Mouse wheel left / down / up / right |
| `Y` / `U` / `I` / `O` | Arrow left / down / up / right |
| `P` | Delete to beginning of line (`C-u`) |
| `[` | Delete to end of line (`C-k`) |
| `N` / `M` | Delete word backward / forward (`C-Bspc` / `C-Del`) |
| `,` / `.` | Delete word backward terminal-style (`C-w`) / forward (`A-d`) |

### Layer 5 — Numbers

![Layer 5 — Numbers](assets/layer5_numbers.png)

Hold **Right Ctrl** to activate. Places a numpad under the left hand. Ideal for quick numeric entry without moving the right hand from the mouse.

| Key | Output |
|-----|--------|
| `Q` | `+` |
| `W` / `E` / `R` / `T` | `9` `8` `7` `-` |
| `A` / `S` / `D` / `F` | `/` `6` `5` `4` |
| `Z` / `X` / `C` / `V` | `=` `3` `2` `1` |
| `G` | `0` |

---

## Customization

### Adjust Tap-Hold Timing

If modifiers trigger too easily or too slowly:

```lisp
(defvar
  tap-time 250    ; milliseconds
  hold-time 250
)
```

Increase for slower typing cadence; decrease for faster response.

### Change GNOME Workspace Shortcuts

The aliases `rpl`, `rpd`, `rpu`, `rpr` map to GNOME's `Meta+arrow` defaults. If your GNOME uses different bindings, update the aliases in `kanata_gnome.kbd`:

```lisp
rpl M-left    ; previous workspace
rpr M-rght    ; next workspace
```

### Add a Layer

```lisp
;; Alias
sym (layer-toggle symbols)

;; Layer definition
(deflayer symbols
  ...
)
```

---

## Troubleshooting

### Kanata will not start

```bash
# Verify uinput group membership
groups $USER | grep uinput

# Check device node
ls -la /dev/uinput
# Expected: crw-rw---- 1 root uinput
```

### Service failures

```bash
# Logs
journalctl --user -u kanata.service -f

# Debug mode
kanata --cfg ~/.config/kanata/kanata.kbd --debug
```

### Keys not responding

```bash
# Check process
pgrep -a kanata

# Restart
pkill kanata
kanata --cfg ~/.config/kanata/kanata.kbd
```

### Accidental holds / double taps

1. Increase `tap-time` and `hold-time` to 250–300 ms.
2. Switch to `tap-hold-release` in aliases if `tap-hold` is too aggressive:

```lisp
;; Replace:
ss (tap-hold $tap-time $hold-time s lmet)

;; With:
ss (tap-hold-release $tap-time $hold-time s lmet)
```

### kitty shortcuts not working

Ensure `kitty.conf` does not conflict:

```
map ctrl+shift+t new_tab
map ctrl+shift+w close_tab
map ctrl+shift+, previous_tab
map ctrl+shift+. next_tab
```

---

## Resources

- [Kanata Repository](https://github.com/jtroo/kanata) — Official documentation and source
- [Kanata Configuration Guide](https://github.com/jtroo/kanata/blob/main/docs/config.adoc) — Complete syntax reference
- [Kanata Web Simulator](https://jtroo.github.io/) — Test configurations in browser before deploying

---

## License

MIT License — See [LICENSE](LICENSE) file.

---

**Maintained by:** @stefan-hacks
