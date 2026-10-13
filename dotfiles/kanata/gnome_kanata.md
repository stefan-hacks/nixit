# ⌨️ Kanata + GNOME Keyboard Layout

> **A programmer's power-user setup for full keyboard control of GNOME**
> Home-row mods · Tap-hold layers · GNOME defaults preserved

---

## 📖 Table of Contents

1. [Philosophy](#-philosophy)
2. [Physical Layout](#-physical-layout)
3. [Layer System Overview](#-layer-system-overview)
4. [Layer 1 — Base](#-layer-1--base)
5. [Layer 2 — Symbols](#-layer-2--symbols)
6. [Layer 3 — Windows & Workspaces](#-layer-3--windows--workspaces)
7. [Layer 4 — Editing & Shell](#-layer-4--editing--shell)
8. [Layer 5 — Media & Function Keys](#-layer-5--media--function-keys)
9. [Layer 6 — Screenshots & Panels](#-layer-6--screenshots--panels)
10. [GNOME Default Keybind Reference](#-gnome-default-keybind-reference)
11. [Quick Tips](#-quick-tips)

---

## 🧠 Philosophy

This layout is built on **three principles**:

| Principle | Implementation |
|---|---|
| **Never leave the home row** | All modifiers are tap-hold on `S D F` (left) and `J K L` (right) |
| **Preserve muscle memory** | Standard QWERTY positions still type normally on tap |
| **Use GNOME defaults** | Every GNOME shortcut uses its **out-of-the-box** binding — no remapping needed |
| **Esc ⇄ Caps swapped** | `Caps` = `Esc`, `Esc` = `Caps` on every layer |

---

## 🗺️ Physical Layout

```
┌─────┬─────┬─────┬─────┬─────┬─────┬─────┬─────┬─────┬─────┬─────┬─────┬─────┐
│ Esc │ F1  │ F2  │ F3  │ F4  │ F5  │ F6  │ F7  │ F8  │ F9  │ F10 │ F11 │ F12 │
├─────┼─────┼─────┼─────┼─────┼─────┼─────┼─────┼─────┼─────┼─────┼─────┼─────┤
│  `  │  1  │  2  │  3  │  4  │  5  │  6  │  7  │  8  │  9  │  0  │  -  │  =  │
├─────┴──┬──┴──┬──┴──┬──┴──┬──┴──┬──┴──┬──┴──┬──┴──┬──┴──┬──┴──┬──┴──┬──┴──┬──┴──┐
│  Tab   │  Q  │  W  │  E  │  R  │  T  │  Y  │  U  │  I  │  O  │  P  │  [  │  ]  │
├────────┴─┬───┴─┬───┴─┬───┴─┬───┴─┬───┴─┬───┴─┬───┴─┬───┴─┬───┴─┬───┴─┬───┴─────┤
│  Caps→Esc│  A  │  S  │  D  │  F  │  G  │  H  │  J  │  K  │  L  │  ;  │  '  ⏎  │
├──────────┴─┬───┴─┬───┴─┬───┴─┬───┴─┬───┴─┬───┴─┬───┴─┬───┴─┬───┴─┬───┴────────┤
│    LShift  │  Z  │  X  │  C  │  V  │  B  │  N  │  M  │  ,  │  .  │  /  │ RShift│
├────────┬───┴──┬──┴─────┴─────┴─────┴─────┴─────┴─────┴─────┴───┬─┴───┬─┴───────┤
│ LCtrl  │ LMeta│              Space            │ RAlt │ RMeta│ RCtrl   │
└────────┴──────┴───────────────────────────────┴──────┴──────┴─────────┘
   ↑ L4     ↑ L3              ↑ L2                 ↑ L5   ↑ L6
```

### 🎹 Layer Triggers (Hold)

| Key | Layer | Purpose |
|:---:|:---:|---|
| `Space` | **2** | Symbols / programming |
| `LMeta` (left Super) | **3** | Windows & Workspaces |
| `LCtrl` | **4** | Editing, Shell & Navigation |
| `RMeta` (right Super) | **5** | Media & Function keys |
| `RCtrl` | **6** | Screenshots & Panels |

### 🏠 Home Row Mods (Hold)

| Left hand | Modifier | Right hand | Modifier |
|:---:|:---:|:---:|:---:|
| `A` | `LShift` | `J` | `RCtrl` |
| `S` | `LMeta` | `K` | `RAlt` |
| `D` | `LAlt` | `L` | `RMeta` |
| `F` | `LCtrl` | `H` | `Shift+`` (Activities) |

> 💡 **Tap** = normal letter · **Hold** = modifier

---

## 🧩 Layer System Overview

```
                  ┌──────────────────────────────┐
                  │        LAYER 1 — BASE        │
                  │   (default typing layer)     │
                  └──────────────┬───────────────┘
                                 │
        ┌────────────┬───────────┼───────────┬────────────┐
        │            │           │           │            │
   ┌────▼───┐   ┌────▼───┐  ┌────▼───┐  ┌────▼───┐  ┌─────▼────┐
   │LAYER 2 │   │LAYER 3 │  │LAYER 4 │  │LAYER 5 │  │ LAYER 6  │
   │Symbols │   │Windows │  │Editing │  │ Media  │  │Screenshots│
   │ (Space)│   │(LMeta) │  │(LCtrl) │  │(RMeta) │  │ (RCtrl)  │
   └────────┘   └────────┘  └────────┘  └────────┘  └──────────┘
```

---

## 🅰️ Layer 1 — Base

> **The default typing layer.** All home-row mods and tap-holds are active.

### F-Row Tap-Holds

| Key | Tap | Hold | What it does |
|:---:|:---:|:---:|---|
| `F1` | F1 | `Ctrl+Alt+Q` | Quake terminal dropdown |
| `F2` | F2 | `Alt+F2` | **GNOME run dialog** |
| `F3` | F3 | 🔅 Brightness Down | Display darker |
| `F4` | F4 | 🔆 Brightness Up | Display brighter |
| `F5` | F5 | 🔇 Mute | Audio mute toggle |
| `F6` | F6 | 🔉 Volume Down | Quieter |
| `F7` | F7 | 🔊 Volume Up | Louder |
| `F8` | F8 | 🎤 Mic Mute | Mic toggle |
| `F9` | F9 | 📸 `Shift+Ctrl+Alt+R` | **Screenshot / Recording UI** |
| `F10` | F10 | 🔒 `Super+L` | **Lock screen** |
| `F11` | F11 | F11 | — |
| `F12` | F12 | F12 | — |

### Home Row Tap-Holds (Left)

| Key | Tap | Hold |
|:---:|:---:|:---:|
| `A` | `a` | `LShift` |
| `S` | `s` | `LMeta` 🪟 |
| `D` | `d` | `LAlt` |
| `F` | `f` | `LCtrl` |
| `G` | `g` | `g` |

### Home Row Tap-Holds (Right)

| Key | Tap | Hold |
|:---:|:---:|:---:|
| `H` | `h` | `Shift+`` (Activities) |
| `J` | `j` | `RCtrl` |
| `K` | `k` | `RAlt` |
| `L` | `l` | `RMeta` 🪟 |
| `;` | `;` | `RShift` |

### Top / Bottom Row Tap-Holds

| Key | Tap | Hold | Purpose |
|:---:|:---:|:---:|---|
| `Q` | q | `Ctrl+Q` | Quit |
| `W` | w | `Ctrl+W` | Close tab |
| `R` | r | `Ctrl+R` | Reload |
| `T` | t | `Ctrl+T` | New tab |
| `Z` | z | `Ctrl+Z` | Undo |
| `X` | x | `Ctrl+X` | Cut |
| `C` | c | `Ctrl+C` | Copy |
| `V` | v | `Ctrl+V` | Paste |
| `Y` | y | `Home` | Line start |
| `U` | u | `PgDn` | Page down |
| `I` | i | `PgUp` | Page up |
| `O` | o | `End` | Line end |

### Number Row Tap-Holds

Each number key types the digit on tap and the **shifted symbol** on hold.

| Key | Tap | Hold | | Key | Tap | Hold |
|:---:|:---:|:---:|:-:|:---:|:---:|:---:|
| `` ` `` | `` ` `` | `~` | | `6` | 6 | `^` |
| `1` | 1 | `!` | | `7` | 7 | `&` |
| `2` | 2 | `@` | | `8` | 8 | `*` |
| `3` | 3 | `#` | | `9` | 9 | `(` |
| `4` | 4 | `$` | | `0` | 0 | `)` |
| `5` | 5 | `%` | | `-` | - | `_` |
| | | | | `=` | = | `+` |

### Thumb Cluster

| Key | Tap | Hold |
|:---:|:---:|:---:|
| `Backspace` | Backspace | `Delete` |
| `Enter` | Enter | `RAlt` |
| `Space` | Space | **Layer 2** |
| `LMeta` | LMeta | **Layer 3** |
| `LCtrl` | LCtrl | **Layer 4** |
| `RMeta` | RMeta | **Layer 5** |
| `RCtrl` | RCtrl | **Layer 6** |

---

## 🔣 Layer 2 — Symbols

> **Hold `Space`.** Programming characters, brackets, and math symbols.

```
┌───────────────────────────────────────────────────────────┐
│  `  │  1  │  2  │  3  │  4  │  5  │  6  │  7  │  8  │  9  │
├─────┼─────┼─────┼─────┼─────┼─────┼─────┼─────┼─────┼─────┤
│  ~  │  !  │  @  │  #  │  $  │  %  │  ^  │  &  │  *  │  (  │
└─────┴─────┴─────┴─────┴─────┴─────┴─────┴─────┴─────┴─────┘
```

| Key | Output | Key | Output |
|:---:|:---:|:---:|:---:|
| `Q` | `!` | `P` | `[` |
| `W` | `@` | `[` | `]` |
| `E` | `#` | `\` | — |
| `R` | `$` | `A` | `^` |
| `T` | `%` | `S` | `&` |
| `Y` | `0` | `D` | `*` |
| `U` | `9` | `F` | `/` |
| `I` | `0` | `G` | `` ` `` |
| `O` | `[` | `H` | `~` |
| | | `J` | `\` |
| `Z` | `-` | `K` | `;` |
| `X` | `=` | `L` | `'` |
| `C` | `_` | `;` | — |
| `V` | `+` | | |
| `B` | `\` | | |
| `N` | `,` | | |
| `M` | `.` | | |

---

## 🪟 Layer 3 — Windows & Workspaces

> **Hold `LMeta` (left Super).** Full GNOME window management using **default** bindings.

### 🪟 Window Management

| Key | GNOME Action | Binding |
|:---:|:---:|:---:|
| `Q` | Close window | `Alt+F4` |
| `W` | Maximize | `Super+↑` |
| `E` | Unmaximize | `Super+↓` |
| `R` | Tile Left | `Super+←` |
| `T` | Tile Right | `Super+→` |
| `Y` | Minimize | `Super+H` |
| `O` | Toggle Maximized | `Alt+F10` |
| `[` | Move window | `Alt+F7` |
| `]` | Resize window | `Alt+F8` |
| `\` | Window menu | `Alt+Space` |

### 🔄 App & Window Switching

| Key | Action | Binding |
|:---:|:---:|:---:|
| `A` | Switch apps forward | `Alt+Tab` |
| `S` | Switch apps backward | `Shift+Alt+Tab` |
| `D` | Cycle windows forward | `Alt+Esc` |
| `F` | Cycle windows backward | `Shift+Alt+Esc` |
| `G` | Switch window group | `Alt+`` |
| `H` | Switch group backward | `Shift+Alt+`` |

### 🖥️ Workspace Navigation

| Key | Action | Binding |
|:---:|:---:|:---:|
| `J` | Workspace Left | `Super+PgUp` |
| `K` | Workspace Down | `Ctrl+Alt+↓` |
| `L` | Workspace Up | `Ctrl+Alt+↑` |
| `;` | Workspace Right | `Super+PgDn` |
| `Z` | Workspace 1 | `Super+Home` |
| `/` | Workspace Last | `Super+End` |
| `,` | **Move** window to WS Left | `Super+Shift+PgUp` |
| `.` | **Move** window to WS Right | `Super+Shift+PgDn` |

### 🖥️ Multi-Monitor

| Key | Action | Binding |
|:---:|:---:|:---:|
| `H` | Move to monitor ↑ | `Super+Shift+↑` |
| `N` | Move to monitor ↓ | `Super+Shift+↓` |
| `M` | Move to monitor ← | `Super+Shift+←` |
| `,` | Move to monitor → | `Super+Shift+→` |
| `P` | Switch monitor | `Super+P` |

### 📱 Launch Apps

| Key | Action | Binding |
|:---:|:---:|:---:|
| `1`–`9` | Switch to app 1–9 | `Super+1..9` |
| `0` | Open new window of app | `Super+Ctrl+1..9` |

### 🐚 GNOME Shell

| Key | Action | Binding |
|:---:|:---:|:---:|
| `V` | App grid | `Super+A` |
| `N` | Notifications | `Super+N` |
| `B` | Message tray | `Super+V` |
| `S` | Quick settings | `Super+S` |
| `Space` | Input source | `Super+Space` |
| `Z` | Cancel input capture | `Super+Shift+Esc` |
| `,` | Overview down | `Super+Alt+↓` |
| `.` | Overview up | `Super+Alt+↑` |

### 📊 Panels

| Key | Action | Binding |
|:---:|:---:|:---:|
| `C` | Next panel | `Ctrl+Alt+Tab` |
| `V` | Prev panel | `Shift+Ctrl+Alt+Tab` |
| `X` | Cycle panels | `Ctrl+Alt+Esc` |
| `Z` | Cycle panels back | `Shift+Ctrl+Alt+Esc` |

### 🔁 System

| Key | Action | Binding |
|:---:|:---:|:---:|
| `` ` `` | Reload Kanata config | — |
| `Esc` | (bottom row) | — |

---

## ✏️ Layer 4 — Editing & Shell

> **Hold `LCtrl`.** Terminal editing, mouse wheel emulation, and shell shortcuts.

### 🖱️ Mouse Wheel Emulation

| Key | Action |
|:---:|:---:|
| `H` | Scroll Left |
| `J` | Scroll Down |
| `K` | Scroll Up |
| `L` | Scroll Right |

### ✂️ Text Deletion

| Key | Action | Binding |
|:---:|:---:|:---:|
| `[` | Delete to BOL | `Ctrl+U` |
| `]` | Delete to EOL | `Ctrl+K` |
| `,` | Delete word back | `Ctrl+Backspace` |
| `.` | Delete word fwd | `Ctrl+Delete` |
| `;` | Delete word back (term) | `Ctrl+W` |
| `'` | Delete word fwd (emacs) | `Alt+D` |

### 🐚 Shell & Apps

| Key | Action | Binding |
|:---:|:---:|:---:|
| `A` | App grid | `Super+A` |
| `N` | Notifications | `Super+N` |
| `B` | Message tray | `Super+V` |
| `S` | Quick settings | `Super+S` |
| `1`–`9` | New window of app | `Super+Ctrl+1..9` |
| `G` | Switch window group | `Alt+`` |
| `D`/`F` | Cycle windows | `Alt+Esc` / `Shift+Alt+Esc` |

### 🧭 Arrows & Navigation

| Key | Action |
|:---:|:---:|
| `H` | ← Left |
| `J` | ↓ Down |
| `K` | ↑ Up |
| `L` | → Right |
| `N` | Backspace |
| `M` | Delete |

### 🎛️ Panels

| Key | Action |
|:---:|:---:|
| `E` | Next panel |
| `R` | Cycle panels |
| `D` | Prev panel |
| `F` | Cycle panels back |
| `T` | Prev panel (alt) |
| `G` | Cancel input capture |

### 🔧 Utilities

| Key | Action |
|:---:|:---:|
| `` ` `` | Input source |
| `Z` | Overview down |
| `X` | Overview up |
| `P` | Run dialog (`Alt+F2`) |

---

## 🎵 Layer 5 — Media & Function Keys

> **Hold `RMeta` (right Super).** Media controls mapped directly to XF86 keys.

| Key | Action |
|:---:|:---:|
| `Q` | ⏯️ Play / Pause |
| `W` | ⏮️ Previous Track |
| `E` | ⏭️ Next Track |
| `R` | 🔇 Mute |
| `T` | 🔉 Volume Down |
| `Y` | 🔊 Volume Up |
| `U` | 🔆 Brightness Up |
| `I` | 🔅 Brightness Down |
| `O` | 📸 Screenshot UI |
| `P` | 🔒 Lock Screen |
| `F9` | 📸 Screenshot |
| `F10` | 🔒 Lock Screen |

---

## 📸 Layer 6 — Screenshots & Panels

> **Hold `RCtrl`.** Dedicated screenshot layer.

| Key | Action | Binding |
|:---:|:---:|:---:|
| `F10` | Screenshot | `Print` |
| `F11` | Window Screenshot | `Alt+Print` |
| `F12` | Area Screenshot | `Shift+Print` |
| `Q` | Next panel | `Ctrl+Alt+Tab` |
| `W` | Prev panel | `Shift+Ctrl+Alt+Tab` |
| `E` | Cycle panels | `Ctrl+Alt+Esc` |
| `R` | Cycle panels back | `Shift+Ctrl+Alt+Esc` |
| `T` | Cancel input capture | `Super+Shift+Esc` |

---

## 📚 GNOME Default Keybind Reference

Complete list of every GNOME default shortcut mapped into this layout:

### 🪟 Window Manager

| GNOME Shortcut | Layer 3 | Layer 4 |
|---|:---:|:---:|
| `Alt+F4` — Close | `Q` | — |
| `Alt+F10` — Toggle max | `O` | — |
| `Alt+Space` — Window menu | `\` | — |
| `Alt+F7` — Move | `[` | — |
| `Alt+F8` — Resize | `]` | — |
| `Alt+Tab` — Switch apps | `A` | — |
| `Shift+Alt+Tab` — Apps back | `S` | — |
| `Alt+Esc` — Cycle windows | `D` | — |
| `Shift+Alt+Esc` — Windows back | `F` | — |
| `Alt+F6` — Cycle group | `G` | — |
| `Shift+Alt+F6` — Group back | `H` | — |
| `Alt+`` — Switch group | `G` | — |
| `Super+↑` — Maximize | `W` | — |
| `Super+↓` — Unmaximize | `E` | — |
| `Super+←` — Tile left | `R` | — |
| `Super+→` — Tile right | `T` | — |
| `Super+H` — Minimize | `Y` | — |

### 🖥️ Workspaces & Monitors

| GNOME Shortcut | Layer 3 |
|---|:---:|
| `Super+PgUp` — WS left | `J` |
| `Super+PgDn` — WS right | `;` |
| `Ctrl+Alt+↑` — WS up | `L` |
| `Ctrl+Alt+↓` — WS down | `K` |
| `Super+Home` — WS 1 | `Z` |
| `Super+End` — WS last | `/` |
| `Super+Shift+PgUp` — Move WS left | `,` |
| `Super+Shift+PgDn` — Move WS right | `.` |
| `Super+Shift+↑` — Monitor up | `H` |
| `Super+Shift+↓` — Monitor down | `N` |
| `Super+Shift+←` — Monitor left | `M` |
| `Super+Shift+→` — Monitor right | `,` |
| `Super+P` — Switch monitor | `P` |

### 🐚 Shell

| GNOME Shortcut | Layer 3 | Layer 4 |
|---|:---:|:---:|
| `Super+A` — App grid | `V` | `A` |
| `Super+N` — Notifications | `N` | `N` |
| `Super+V` — Message tray | `B` | `B` |
| `Super+S` — Quick settings | `S` | `S` |
| `Super+Space` — Input source | `Space` | `` ` `` |
| `Super+Shift+Esc` — Cancel capture | `Z` | `G` |
| `Super+Alt+↑` — Overview up | `.` | `X` |
| `Super+Alt+↓` — Overview down | `,` | `Z` |

### 📸 Screenshots

| GNOME Shortcut | Layer 5 | Layer 6 |
|---|:---:|:---:|
| `Print` — Screenshot UI | `O` | `F10` |
| `Shift+Print` — Area | `F9` | `F12` |
| `Alt+Print` — Window | — | `F11` |
| `Shift+Ctrl+Alt+R` — Recording | `F9` (hold) | — |

### 🔊 Hardware / Media

| GNOME Shortcut | Layer 1 (F-row hold) | Layer 5 |
|---|:---:|:---:|
| `XF86MonBrightnessDown` | `F3` | `I` |
| `XF86MonBrightnessUp` | `F4` | `U` |
| `XF86AudioMute` | `F5` | `R` |
| `XF86AudioLowerVolume` | `F6` | `T` |
| `XF86AudioRaiseVolume` | `F7` | `Y` |
| `XF86AudioMicMute` | `F8` | — |
| `XF86AudioPlay` | — | `Q` |
| `XF86AudioPrev` | — | `W` |
| `XF86AudioNext` | — | `E` |
| `Super+L` — Lock | `F10` | `P` |
| `Alt+F2` — Run dialog | `F2` | `P` |

---

## 💡 Quick Tips

### 🔑 Remember the 3 Core Layers

```
       ┌───────────────────────────────┐
       │   Space  →  Symbols           │
       │   LMeta  →  Windows           │
       │   LCtrl  →  Editing           │
       │   RMeta  →  Media             │
       │   RCtrl  →  Screenshots       │
       └───────────────────────────────┘
```

### 🎯 Workflow Examples

**Maximize a window and tile it left:**
```
Hold LMeta → press W (maximize)
Hold LMeta → press R (tile left)
```

**Switch workspace and move a window:**
```
Hold LMeta → press ; (workspace right)
Hold LMeta → press . (move window right)
```

**Open a terminal and reload config:**
```
Hold LMeta → press ` (reload kanata)
Hold LMeta → press F2-hold (run dialog)
```

**Take a screenshot:**
```
Tap F9            (screenshot UI)
— or —
Hold RCtrl → tap F10  (screenshot)
— or —
Hold RMeta → tap O    (screenshot UI)
```

**Adjust volume without leaving home row:**
```
Hold RMeta → tap R (mute)
Hold RMeta → tap T (vol down)
Hold RMeta → tap Y (vol up)
```

### ⚡ Power Combos

| Combo | Effect |
|---|---|
| `LMeta + A` then `LMeta + S` | Switch apps rapidly back and forth |
| `LMeta + J` then `LMeta + .` | Move to next workspace and take window with you |
| `LCtrl + J` + `LCtrl + L` | Scroll down and up with mouse wheel emulation |
| `RMeta + Q` | Pause / play music without leaving any app |
| `RCtrl + F10` | Quick screenshot with one hand |

### ⚠️ Things to Remember

- **Tap vs Hold** — the threshold is **200 ms**. Tap quickly for the letter; hold for the modifier.
- **Esc ⇄ Caps are swapped** — `Caps Lock` is `Esc`, and the physical `Esc` key is `Caps Lock` on all layers.
- **`lrld`** — on Layer 3, the top-right key (normally F12) reloads the Kanata config so you can iterate without a rebuild.
- **NixOS rebuild** — after editing `configuration.nix`, always run `sudo nixos-rebuild switch`.

---

<div align="center">

**Made for a GNOME power user · Built on Kanata + NixOS**

*Home row is home. Everything else is a layer away.* 🏠⌨️

</div>
