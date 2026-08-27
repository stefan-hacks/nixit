<div align="center">

![NixOS Logo](assets/icon2.png)

# ❄️ Nixit

**A Reproducible NixOS Workstation**

[![NixOS](https://img.shields.io/badge/NixOS-26.05-5277C3?logo=nixos&logoColor=white)](https://nixos.org/)
[![Home Manager](https://img.shields.io/badge/Home%20Manager-26.05-blue.svg)](https://github.com/nix-community/home-manager)
[![License](https://img.shields.io/badge/License-MIT-green.svg)](LICENSE)

*Declarative · Reproducible · Multi-Ready*

</div>

---

## Overview

Nixit is a production-grade NixOS flake built with **Flakes** and **Home Manager**.
It provides a fully declarative system and user environment — from kernel boot
parameters to shell prompts, wallpapers to window manager keybindings.

The configuration follows a **modular, host-centric** architecture: each host
(`ghost`, `lin`) pulls in exactly the system and user modules it needs via the
`lib/mkHost.nix` factory.  The result is a reproducible, version-controlled
workstation that can be rebuilt in minutes on any compatible hardware.

| Component    | Detail                             |
| ------------ | ---------------------------------- |
| **OS**       | NixOS 26.05                        |
| **Config**   | Flake-based (`flake.nix`)          |
| **Desktop**  | GNOME 50 (Wayland)                 |
| **Shell**    | Bash + Blesh + Starship            |
| **Terminal** | Kitty                              |
| **Editor**   | Neovim (via Nixvim)                |
| **Security** | LUKS, Firewall, Mullvad, 1Password |

---

## Philosophy

- **Flakes** — Lock every input. Rebuild the exact same system tomorrow or next year.
- **Home Manager** — Declarative dotfiles, services, and dconf settings.
- **One module per concern** — Each `.nix` file handles exactly one thing.
- **Host factory** — `lib/mkHost.nix` parameterises users, systems, and special args so
  adding a new machine is a single entry in `flake.nix`.
- **No activation scripts** — Home Manager activation and `systemd.tmpfiles` deploy everything.

---

## Repository Structure

```
.
├── flake.nix                          # Inputs, outputs, host registry
├── lib/
│   └── mkHost.nix                     # Host factory: maps users → HM, imports system modules
│
├── hosts/
│   ├── ghost/
│   │   ├── default.nix                # Host entry point (GNOME workstation)
│   │   └── hardware-configuration.nix # Auto-detected hardware (imperative)
│   └── lin/
│       ├── default.nix                # Host entry point
│       └── hardware-configuration.nix
│
├── modules/
│   ├── nixos/                         # System-level NixOS modules
│   │   ├── boot.nix                   # LUKS, systemd-boot, kernel params
│   │   ├── networking.nix             # Firewall, Mullvad VPN, DNS
│   │   ├── locale.nix                 # Timezone, i18n, keyboard layout
│   │   ├── user.nix                   # Primary user, groups, shell
│   │   ├── gnome.nix                  # GNOME DE, extensions, GDM theming
│   │   ├── programs.nix               # Declared programs (git, 1password, etc.)
│   │   ├── packages.nix               # System packages (browsers, tools, themes)
│   │   ├── services.nix               # Systemd services (pipewire, blueman, etc.)
│   │   ├── kanata.nix                 # Keyboard remapping daemon
│   │   ├── nixvim.nix                 # Declarative Neovim (Nixvim module)
│   │   ├── virtualization.nix         # Podman, distrobox, VMs
│   │   ├── firewall.nix               # nftables / iptables hardening
│   │   ├── fonts.nix                  # Font packages + fontconfig
│   │   ├── environment.nix            # Session variables, PATH, XDG
│   │   ├── maintenance.nix            # Nix GC, auto-upgrade
│   │   ├── bluetooth.nix              # Bluez, blueman
│   │   ├── printing.nix               # CUPS
│   │   ├── documentation.nix          # Man pages, info, nix-doc
│   │   ├── ollama.nix                 # Local LLM inference server
│   │   └── hermes.nix                 # Hermes agent integration
│   │
│   └── home/                          # Home Manager modules
│       ├── bash.nix                   # Bash aliases, functions, history
│       ├── blesh.nix                  # Bash line editor (syntax, menus)
│       ├── starship.nix               # Cross-shell prompt config
│       ├── atuin.nix                  # Synced shell history
│       ├── git.nix                    # Git config, delta, aliases
│       ├── ssh.nix                    # SSH client config
│       ├── kitty.nix                  # Kitty terminal config
│       ├── fastfetch.nix              # System info branding
│       ├── dconf.nix                  # GNOME settings (gsettings → dconf db)
│       ├── vim.nix                    # Vim backup config
│       └── zellij.nix                 # Terminal multiplexer (stub)
│
├── home/                              # Per-user Home Manager entry points
│   ├── stefan-hacks/
│   │   └── home.nix                   # ghost user HM imports
│   ├── lin/
│   │   └── home.nix                   # lin user HM imports
│   └── profiles/                      # Desktop-specific HM profiles (stubs)
│       ├── gnome/
│       ├── kde/
│       ├── hyprland/
│       └── niri/
│
├── dotfiles/                          # Raw dotfiles sourced by HM modules
│   ├── bash/                          # .bashrc, .bash_aliases
│   ├── blesh/                         # .blerc
│   ├── gitconfig/                     # .gitconfig
│   ├── kitty/                         # kitty.conf, tab_bar.py
│   ├── nvim/                          # Neovim Lua config (legacy)
│   ├── starship/                      # starship.toml
│   ├── fastfetch/                     # config.jsonc
│   ├── kanata/                        # kanata_gnome.kbd
│   ├── .ssh/                          # SSH client config
│   └── vim/                           # .vimrc
│
├── gnome/
│   └── dconf.ini                      # Full gsettings dump (loaded by HM activation)
│
├── themes/                            # Stylix / base16 theme definitions
│
└── assets/
    ├── icon2.png                      # NixOS logo / branding asset
    └── wallpapers/                    # Categorized wallpaper collection
        ├── Catppuccin_Mocha/
        ├── Dracula/
        ├── Nordic_Blue/
        ├── Solarized_Dark/
        └── ... (30+ themed directories)
```

---

## Quick Start

### Fresh Install

```bash
# 1. Clone the flake
git clone https://github.com/stefan-hacks/nixit.git ~/.config/nixit
cd ~/.config/nixit

# 2. Copy the auto-detected hardware config for your machine
cp /etc/nixos/hardware-configuration.nix hosts/ghost/

# 3. Build and activate the system
sudo nixos-rebuild switch --flake .#ghost

# 4. Log out and back in (or reboot) for GNOME settings to take effect
```

### After First Boot

```bash
# Atuin — register and sync shell history
atuin register -u YOUR_USERNAME -e YOUR_EMAIL
atuin import auto
atuin sync

# Wallpapers are picked up from ~/.config/nixit/assets/wallpapers/
# GNOME settings are applied automatically by Home Manager activation
```

---

## Key Features

### Terminal Stack

| Tool                                                     | Purpose                                         |
| -------------------------------------------------------- | ----------------------------------------------- |
| [Kitty](https://sw.kovidgoyal.net/kitty/)                | GPU-accelerated terminal with ligatures         |
| [Blesh](https://github.com/akinomyoga/ble.sh)            | Bash line editor (syntax highlighting, history)   |
| [Starship](https://starship.rs/)                         | Cross-shell prompt with git/NERD info             |
| [Atuin](https://atuin.sh/)                               | Encrypted, synced shell history                   |
| [Zoxide](https://github.com/ajeetdsouza/zoxide)          | Smarter `cd` — remembers frequency              |
| [Fastfetch](https://github.com/fastfetch-cli/fastfetch)  | System info with custom Nixit branding            |

### Desktop Environment

| Feature             | Implementation                                  |
| ------------------- | ----------------------------------------------- |
| **Window Manager**  | GNOME 50 (Wayland)                              |
| **Dock**            | Dash to Dock                                    |
| **Blur**            | Blur My Shell                                   |
| **Clipboard**       | GPaste                                          |
| **Tray Icons**      | AppIndicator                                    |
| **Keyboard**        | Kanata (vim-style leader key remapping)         |
| **Login Wallpaper** | Catppuccin Mocha (GDM profile)                  |
| **Bar Theme**       | OpenBar + Yaru accent/folder colours            |
| **Wallpapers**      | Wallpicker extension + 30+ themed collections     |

### GNOME Extensions

- **AppIndicator** — Tray icons in top bar
- **ArcMenu** — Application menu with search
- **Blur My Shell** — Background blur for panels and overview
- **Dash to Dock** — Bottom dock with favourites
- **Dynamic Music Pill** — Media widget in top bar
- **GPaste** — Clipboard history manager
- **Notification Configurator** — Notification styling
- **OpenBar** — Top bar theming with accent colours
- **Pomodoro Timer** — Focus timer in top bar
- **Quake Terminal** — Dropdown terminal (grave key)
- **Quick Settings Audio Panel** — Audio device selector
- **Steal My Focus Window** — Focus behaviour tuning
- **Vitals** — System resource monitor
- **Wallpicker** — Wallpaper selector
- **Modern Clock** — Customisable clock widget

---

## Neovim (Nixvim)

Configured entirely through [Nixvim](https://github.com/nix-community/nixvim) —
no manual plugin management, no Lua copy-paste. Every plugin, keybinding, and LSP
server is declared in `modules/nixos/nixvim.nix`.

| Category       | Features                                                                                                                     |
| -------------- | ---------------------------------------------------------------------------------------------------------------------------- |
| **Theme**      | Catppuccin Macchiato, transparent background                                                                                 |
| **LSP**        | lua_ls, rust_analyzer, nil (Nix), pylsp, clangd, ts_ls, bashls, jsonls, yamlls, marksman, taplo, eslint                    |
| **Completion** | nvim-cmp (LSP, buffer, path, luasnip)                                                                                        |
| **Snippets**   | LuaSnip (friendly-snippets)                                                                                                    |
| **Fuzzy Find** | Telescope (files, grep, buffers, diagnostics, git, LSP)                                                                        |
| **Navigation** | Neo-tree (filesystem), Harpoon (file marks), Flash (quick jump)                                                            |
| **Editing**    | Treesitter (syntax), nvim-surround, nvim-autopairs, gitsigns, conform (formatting), nvim-lint                                |
| **Git**        | gitsigns, fugitive, diffview                                                                                                 |
| **Notes**      | obsidian.nvim                                                                                                                |
| **Terminal**   | Toggleterm (vertical / horizontal / float)                                                                                   |
| **UI**         | Which-key (keybind hints), lualine, bufferline, nvim-notify, noice (cmdline + notifications), indent-blankline, web-devicons |
| **Productivity** | Todo-comments, mini.ai, mini.operators                                                                                     |
| **Session**    | persistence.nvim (auto-save / restore)                                                                                       |
| **Extras**     | kitty-scrollback.nvim, image.nvim                                                                                            |

---

## Keyboard Layer (Kanata)

Kanata remaps the keyboard at the evdev level, providing a **vim-style leader
key** (`Space`) that works in *every* application — terminal, browser, file
manager, etc.

- **Leader + `h/j/k/l`** → arrow keys
- **Leader + `w/b/e/g`** → word / line / paragraph / document navigation
- **Leader + `n/p/f/F`** → find, previous, next
- **Leader + `a/u/v/y/Y/d/x/c/C/p/P/S`** → select-all, undo, visual, yank, delete, cut, copy, paste, save
- **Leader + `s/S`** → split window (Kitty)
- **Leader + `t/T`** → new tab / close tab
- **Leader + `o/O`** → open line / open above

The config lives in `dotfiles/kanata/kanata_gnome.kbd` and is activated via
`modules/nixos/kanata.nix`.

---

## System Architecture

```
┌─────────────────────────────────────────┐
│              flake.nix                  │
│  ┌─────────────┐  ┌─────────────────┐   │
│  │  inputs     │  │  hosts registry │   │
│  │  nixpkgs    │  │  ghost → x86_64 │   │
│  │  home-mgr   │  │  lin   → x86_64 │   │
│  │  nixvim     │  │                 │   │
│  └──────┬──────┘  └─────────────────┘   │
└─────────┼─────────────────────────────────┘
          │
          ▼
┌─────────────────────────────────────────┐
│           lib/mkHost.nix                │
│  ┌────────────────────────────────────┐ │
│  │  specialArgs = { inherit inputs; } │ │
│  │  systemModules = [                 │ │
│  │    modules/nixos/*.nix             │ │
│  │  ]                                 │ │
│  │  homeModules = per-user imports    │ │
│  └────────────────────────────────────┘ │
└─────────────────────────────────────────┘
          │
          ▼
┌─────────────────────────────────────────┐
│         hosts/<host>/default.nix        │
│  ┌────────────────────────────────────┐ │
│  │  imports hardware-config.nix     │ │
│  │  imports system modules          │ │
│  │  sets hostname, system.stateVersion│ │
│  └────────────────────────────────────┘ │
└─────────────────────────────────────────┘
```

---

## Adding a New Host

1. **Copy hardware configuration**
   ```bash
   cp /etc/nixos/hardware-configuration.nix hosts/newhost/
   ```

2. **Add host entry in `flake.nix`**
   ```nix
   newhost = {
     system = "x86_64-linux";
     users = {
       youruser = ./home/youruser/home.nix;
     };
   };
   ```

3. **Create `hosts/newhost/default.nix`**
   ```nix
   { config, pkgs, lib, ... }: {
     imports = [
       ./hardware-configuration.nix
       ../../modules/nixos/gnome.nix      # or your preferred DE
       ../../modules/nixos/packages.nix
       ../../modules/nixos/services.nix
       ../../modules/nixos/user.nix
     ];
     networking.hostName = "newhost";
     system.stateVersion = "26.05";
   }
   ```

4. **Create `home/youruser/home.nix`** (copy from `home/stefan-hacks/`)

5. **Build**
   ```bash
   sudo nixos-rebuild switch --flake .#newhost
   ```

---

## Customisation

| Layer           | File(s) to Edit                                               |
| --------------- | ------------------------------------------------------------- |
| **System pkgs** | `modules/nixos/packages.nix`                                  |
| **GNOME DE**    | `modules/nixos/gnome.nix` + `gnome/dconf.ini`                  |
| **Shell**       | `modules/home/bash.nix` + `dotfiles/bash/.bash_aliases`       |
| **Terminal**    | `dotfiles/kitty/kitty.conf`                                     |
| **Neovim**      | `modules/nixos/nixvim.nix`                                      |
| **Kanata**      | `dotfiles/kanata/kanata_gnome.kbd`                              |
| **Wallpapers**  | Drop files into `assets/wallpapers/<theme-name>/`               |
| **Git**         | `dotfiles/gitconfig/.gitconfig` + `modules/home/git.nix`      |
| **Prompt**      | `dotfiles/starship/starship.toml`                               |

---

## Maintenance

```bash
# Update flake inputs
nix flake update

# Garbage collect old generations
sudo nix-collect-garbage -d

# Rebuild after any change
sudo nixos-rebuild switch --flake .#ghost

# Check flake evaluation (no build)
nix flake check
```

---

## Security

| Layer        | Implementation                                             |
| ------------ | ---------------------------------------------------------- |
| **Disk**     | LUKS2 full-disk encryption (`modules/nixos/boot.nix`)    |
| **Network**  | nftables firewall, Mullvad VPN (`modules/nixos/networking.nix`) |
| **Secrets**  | 1Password CLI, SSH keys in `dotfiles/.ssh/`                |
| **Updates**  | Weekly `nixos-rebuild switch --upgrade` via `maintenance.nix` |

---

## License

MIT — See [LICENSE](LICENSE) for details.

---

<div align="center">

Built with ❄️ Nix by **stefan-hacks**

</div>
