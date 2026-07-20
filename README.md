<div align="center">

# ❄️ Nixit

**A Clean, Reproducible NixOS Workstation Configuration**

[![NixOS](https://img.shields.io/badge/NixOS-26.05-5277C3?logo=nixos&logoColor=white)](https://nixos.org/)
[![License](https://img.shields.io/badge/License-MIT-green.svg)](LICENSE)
[![Built With](https://img.shields.io/badge/Built%20With-❤️-ff69b4.svg)]()

*Pure Nix — No Flakes, No Home Manager*

</div>

---

## Overview

**Nixit** is a production-ready NixOS configuration designed for daily development work. It follows a **single-file philosophy** — one `configuration.nix` manages the entire system, with dotfiles tracked in the same repository.

### Philosophy

- **One file to rule them all** — `configuration.nix` contains everything
- **No flakes** — Pure Nix expressions, no experimental features
- **No Home Manager** — System-level user management
- **Git-managed dotfiles** — Symlinked from `~/.config/nixit`
- **Reproducible** — Same config, same system, anywhere

---

## System Overview

| Component | Configuration |
|-----------|---------------|
| **OS** | NixOS 26.05 (stable) |
| **Desktop** | GNOME 48 (Wayland) |
| **Shell** | Bash + Blesh + Starship |
| **Terminal** | Kitty |
| **Editor** | Vim / Helix |
| **Security** | LUKS encryption, Firewall |

---

## Repository Structure

```
~/.config/nixit/
├── configuration.nix           # Main system configuration
├── hardware-configuration.nix  # Hardware-specific settings
├── dotfiles/                   # Git-managed configuration
│   ├── bash/                   # .bashrc, .bash_aliases
│   ├── blesh/                  # Bash line editor config
│   ├── kitty/                  # Terminal settings
│   ├── starship/               # Prompt theme
│   ├── atuin/                  # Shell history
│   ├── kanata/                 # Keyboard remapper
│   └── gitconfig/              # Git settings
├── gnome/
│   └── dconf.ini               # GNOME desktop settings
└── assets/
    └── wallpapers/             # Desktop backgrounds
```

---

## Quick Start

### Fresh Install

```bash
# Clone to standard location
git clone https://github.com/stefan-hacks/nixit.git ~/.config/nixit
cd ~/.config/nixit

# Link configuration to NixOS
sudo ln -sf ~/.config/nixit/configuration.nix /etc/nixos/
sudo ln -sf ~/.config/nixit/hardware-configuration.nix /etc/nixos/

# Edit user settings
$EDITOR configuration.nix
# Change: username = "your-user";

# Build and activate
sudo nixos-rebuild switch
```

### Post-Install Setup

```bash
# Atuin — sync shell history
atuin register -u USERNAME -e EMAIL
atuin import auto
atuin sync
```

---

## Key Features

### Terminal Stack

| Tool | Purpose |
|------|---------|
| [Kitty](https://sw.kovidgoyal.net/kitty/) | GPU-accelerated terminal |
| [Blesh](https://github.com/akinomyoga/ble.sh) | Bash line editor (syntax, history) |
| [Starship](https://starship.rs/) | Cross-shell prompt |
| [Atuin](https://atuin.sh/) | Synced shell history |
| [Zoxide](https://github.com/ajeetdsouza/zoxide) | Smarter cd command |

### Desktop Environment

| Feature | Implementation |
|---------|----------------|
| **Window Manager** | GNOME (Wayland) |
| **Dock** | Dash to Dock |
| **Blur** | Blur My Shell |
| **Clipboard** | Clipboard Indicator |
| **Tray Icons** | AppIndicator |
| **Keyboard** | Kanata (vim-style leader) |

### Development Tools

- **Languages**: Python, Rust, Node.js
- **Editors**: Vim, Helix
- **Git**: lazygit, delta, gh CLI

---

## Package Highlights

<details>
<summary><strong>System & Shell</strong></summary>

- `bash`, `blesh`, `starship`, `atuin`, `zoxide`, `fzf`
- `eza`, `bat`, `ripgrep`, `fd`
- `direnv`, `carapace`
- `btop`, `fastfetch`, `onefetch`

</details>

<details>
<summary><strong>Development</strong></summary>

- `vim`, `helix`, `lazygit`, `delta`
- `git`, `git-lfs`, `gh`

</details>

<details>
<summary><strong>Desktop Applications</strong></summary>

- `firefox`, `chromium`
- `libreoffice`, `onlyoffice`
- `mpv`, `vlc`, `ffmpeg`
- `discord`
- `_1password-gui`, `mullvad-vpn`

</details>

<details>
<summary><strong>Security Tools</strong></summary>

- `gnupg`, `openssl`, `age`, `sops`
- `nmap`, `wireshark`, `tcpdump`

</details>

---

## Customization

### User Settings

Edit the top of `configuration.nix`:

```nix
let
  username = "stefan-hacks";     # Your username
  fullName = "stefan-hacks";     # Display name
  homeDirectory = "/home/${username}";
in
```

### Wallpapers

Wallpapers are symlinked to `~/Pictures/wallpapers/`:

```bash
# Set wallpaper
gsettings set org.gnome.desktop.background picture-uri \
  "file:///home/USER/.config/nixit/assets/wallpapers/Catppuccin_Mocha/wallpaper.png"
```

### Dotfiles

Modify files in `dotfiles/` and rebuild:

```bash
# Changes apply automatically on rebuild
sudo nixos-rebuild switch
```

---

## Maintenance

### Daily

```bash
# Rebuild after changes
sudo nixos-rebuild switch

# Or with upgrade
sudo nixos-rebuild switch --upgrade
```

### Weekly

```bash
# Garbage collection (automatic)
# Configured: --delete-older-than 30d

# Manual cleanup if needed
sudo nix-collect-garbage --delete-older-than 30d
sudo nix-store --optimise
```

### Rollback

```bash
# To previous generation
sudo nixos-rebuild switch --rollback

# Or select in GRUB bootloader
```

---

## Aliases

| Alias | Command | Description |
|-------|---------|-------------|
| `nix-switch` | `sudo nixos-rebuild switch` | Rebuild system |
| `nix-test` | `sudo nixos-rebuild test` | Test without switching |
| `nix-gc` | `sudo nix-collect-garbage -d` | Garbage collect |
| `nix-list` | `nix-env -qaP` | List packages |
| `ll` | `eza -l` | Long listing |
| `la` | `eza -la` | All files |
| `cat` | `bat --paging=never` | Syntax-highlighted |
| `gs` | `git status` | Git status |
| `ipy` | `ipython` | Interactive Python |

---

## Troubleshooting

### Build Failures

```bash
# Check Nix syntax
nix-instantiate --eval --strict ./configuration.nix

# Dry run
sudo nixos-rebuild dry-build
```

### Service Issues

```bash
# Check kanata status
sudo systemctl status kanata-internal

# View activation logs
journalctl -u activation-script
```

### Dotfiles Not Applied

```bash
# Re-run activation manually
sudo /run/current-system/activate
```

---

## Security

- **Disk Encryption**: LUKS on root partition
- **Firewall**: Enabled with GSConnect ports
- **Secrets**: GnuPG agent, 1Password integration
- **Updates**: Automatic weekly garbage collection

---

## Acknowledgments

- [NixOS](https://nixos.org/) — Purely functional Linux
- [LazyVim](https://www.lazyvim.org/) — Neovim configuration
- [Starship](https://starship.rs/) — Cross-shell prompt
- [Atuin](https://atuin.sh/) — Shell history sync
- [Kanata](https://github.com/jtroo/kanata) — Keyboard remapping

---

<div align="center">

**Made with ❄️ and ❤️**

[Report Issue](https://github.com/stefan-hacks/nixit/issues) · [Contribute](https://github.com/stefan-hacks/nixit/pulls)

</div>
