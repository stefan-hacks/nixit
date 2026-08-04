<div align="center">

# ⌨️ keyhack-kanata

**A 5-layer [Kanata](https://github.com/jtroo/kanata) keyboard configuration **

![License](https://img.shields.io/badge/license-MIT-blue.svg)
![Platform](https://img.shields.io/badge/platform-Linux-blue.svg)
![Desktop](https://img.shields.io/badge/desktop-GNOME-orange.svg)

</div>

---

## Overview

This configuration turns a standard laptop keyboard into a five-layer, tap-hold-driven control surface. Almost every key does two jobs — a quick **tap** for its normal character, and a **hold** for a modifier, shortcut, or entire layer switch.

Esc and Caps Lock are swapped on **every** layer, so Caps Lock always behaves as Esc and vice versa.

### The five layers at a glance

| Layer                      | Held by                | Purpose                                                                  |
| -------------------------- | ---------------------- | ------------------------------------------------------------------------ |
| **1 — Base**               | _(default)_            | Normal typing, with tap-hold modifiers and shortcuts on nearly every key |
| **2 — Window / Workspace** | Left Meta (bottom row) | GNOME window snapping, display switching, workspace navigation           |
| **3 — Symbols**            | Spacebar               | Programming symbols without reaching for Shift                           |
| **4 — Editing**            | Left Shift             | Arrow keys, mouse-wheel emulation, word/line deletion                    |
| **5 — Numbers**            | Right Shift            | A left-hand numpad over the Q/W/E and A/S/D and Z/X/C block              |

> **Note:** Left Shift and Right Shift were freed up to become layer-toggle keys. Their modifier function still exists — it just moved: hold **A** for Left Shift, hold **;** for Right Shift.

---

## 📚 Layer Reference

### Layer 1 — Base

Default typing layer. Tap-hold covers the home row (modifiers), the number row (shifted symbols), the F-row (system/media controls), and common editing shortcuts (Ctrl+C/V/X/Z, etc). The two thumb keys toggle Layer 2 (Left Meta) and Layer 3 (Space); Left/Right Shift toggle Layer 4 and Layer 5.

![Layer 1 — Base](01-layer1-base.png)

### Layer 2 — Window / Workspace

Held by the physical **Left Meta** key. Right-hand keys drive GNOME window snapping, display switching, and workspace navigation; the number row lets N/M/,/. jump straight to workspaces 1–4.

![Layer 2 — Window / Workspace](02-layer2-window-workspace.png)

### Layer 3 — Symbols

Held by **Spacebar**. Remaps QWERTYUIOP / ASDFGHJKL / ZXCVBNM to punctuation and programming symbols, so brackets, pipes, and shift-symbols are reachable without contorting for Shift. F-row system shortcuts stay active.

![Layer 3 — Symbols](03-layer3-symbols.png)

### Layer 4 — Editing

Held by **Left Shift**. Arrow keys land on H/J/K/L, mouse-wheel emulation on Y/U/I/O, and word/line-deletion shortcuts on the bottom row for fast terminal and text editing.

![Layer 4 — Editing](04-layer4-editing.png)

### Layer 5 — Numbers

Held by **Right Shift**. A left-hand numpad: 7/8/9 and +/- on the top row, 4/5/6/0 and / on the home row, 1/2/3 and = on the bottom row.

![Layer 5 — Numbers](05-layer5-numbers.png)

---

## 🚀 Installation

### Prerequisites

```bash
# Via cargo
cargo install kanata

# Or download a prebuilt binary from:
# https://github.com/jtroo/kanata/releases
```

### uinput permissions (Linux)

```bash
sudo groupadd -f uinput
sudo usermod -aG input $USER
sudo usermod -aG uinput $USER

echo 'KERNEL=="uinput", MODE="0660", GROUP="uinput", OPTIONS+="static_node=uinput"' | \
    sudo tee /etc/udev/rules.d/99-kanata.rules

sudo udevadm control --reload-rules
sudo udevadm trigger
```

### Clone and configure

```bash
git clone https://github.com/stefan-hacks/keyhack-kanata.git
cd keyhack-kanata

mkdir -p ~/.config/kanata
cp kanata_gnome.kbd ~/.config/kanata/
```

### Run as a systemd user service

Create `~/.config/systemd/user/kanata.service`:

```ini
[Unit]
Description=Kanata keyboard remapper
Documentation=https://github.com/jtroo/kanata
After=default.target

[Service]
Type=simple
Environment=PATH=/usr/local/bin:/usr/local/sbin:/usr/bin:/bin
Environment=DISPLAY=:0
ExecStart=/bin/sh -c 'exec kanata --cfg ~/.config/kanata/kanata_gnome.kbd'
Restart=on-failure
RestartSec=5

[Install]
WantedBy=default.target
```

```bash
systemctl --user daemon-reload
systemctl --user enable --now kanata.service
systemctl --user status kanata.service
```

---

## 🎨 Customization

### Tap-hold timing

Both timings default to 200ms. If you're seeing accidental holds or missed taps, adjust in `defvar`:

```lisp
(defvar
 tap-time 250
 hold-time 250
)
```

### Layer-toggle keys

| Key         | Tap         | Hold          |
| ----------- | ----------- | ------------- |
| Left Meta   | Left Meta   | → **Layer 2** |
| Spacebar    | Space       | → **Layer 3** |
| Left Shift  | Left Shift  | → **Layer 4** |
| Right Shift | Right Shift | → **Layer 5** |

---

## 🔧 Troubleshooting

**Kanata won't start**

```bash
groups $USER | grep uinput   # confirm group membership; re-login or `newgrp uinput` if missing
ls -la /dev/uinput            # should show crw-rw---- 1 root uinput
```

**Service fails to start**

```bash
journalctl --user -u kanata.service -f
kanata --cfg ~/.config/kanata/kanata_gnome.kbd --debug
```

**Keys not responding**

```bash
ps aux | grep kanata
pkill kanata && kanata --cfg ~/.config/kanata/kanata_gnome.kbd
```

---

## 📖 Resources

- [Kanata](https://github.com/jtroo/kanata) — official repository
- [Kanata configuration guide](https://github.com/jtroo/kanata/blob/main/docs/config.adoc)
- [Kanata simulator](https://jtroo.github.io/) — test configs in-browser

---

## 📄 License

MIT License — see [LICENSE](LICENSE)

<div align="center">

**Maintained by** [@stefan-hacks](https://github.com/stefan-hacks)

</div>
