<div align="center">

# ❄️ Nixit

**A Clean, Reproducible NixOS Workstation**

[![NixOS](https://img.shields.io/badge/NixOS-26.05-5277C3?logo=nixos&logoColor=white)](https://nixos.org/)
[![License](https://img.shields.io/badge/License-MIT-green.svg)](LICENSE)

*Single-file configuration. No flakes. No Home Manager.*

</div>

---

## Overview

**Nixit** is a production-ready NixOS workstation configuration. Everything lives in one file: `configuration.nix`. Dotfiles are tracked in the same repo and symlinked on activation.

| Component | Detail |
|-----------|--------|
| **OS** | NixOS 26.05 (stable) |
| **Desktop** | GNOME 48 (Wayland) |
| **Shell** | Bash + Blesh + Starship |
| **Terminal** | Kitty |
| **Editor** | Neovim via Nixvim |
| **Security** | LUKS, Firewall, 1Password |

---

## Philosophy

- **One file** — `configuration.nix` declares the entire system
- **No flakes** — Pure Nix expressions only
- **No Home Manager** — System-level user management
- **Git-managed dotfiles** — Symlinked from `~/.config/nixit` on rebuild
- **Reproducible** — Same config, same system, anywhere

---

## Repository Structure

```
~/.config/nixit/
├── configuration.nix           # Main system configuration (single file)
├── hardware-configuration.nix  # Hardware-specific settings
├── dotfiles/                   # Git-managed configurations
│   ├── bash/                   # .bashrc, .bash_aliases
│   ├── blesh/                  # Bash line editor config
│   ├── kitty/                  # Terminal settings
│   ├── starship/               # Prompt theme
│   ├── atuin/                  # Shell history
│   ├── kanata/                 # Keyboard remapper
│   ├── vim/                    # Vim configuration (native .vimrc)
│   ├── nvim/                   # Neovim legacy config (superseded by nixvim)
│   └── gitconfig/              # Git settings
├── gnome/
│   └── dconf.ini               # GNOME desktop settings
└── assets/
    └── wallpapers/             # Desktop backgrounds
```

---

## Neovim (Nixvim)

Neovim is configured declaratively via [Nixvim](https://github.com/nix-community/nixvim) — a full IDE setup with zero manual plugin management.

| Category | Features |
|----------|----------|
| **Theme** | Catppuccin Macchiato, transparent background |
| **Completion** | nvim-cmp — LSP, buffer, path, luasnip, lspkind icons |
| **LSP** | lua_ls, nil_ls, ts_ls, pyright, gopls, terraformls, jsonls, yamlls, helm_ls, marksman, html |
| **Formatting** | conform.nvim — black, isort, nixfmt, stylua, prettier, shfmt, jq, shellharden |
| **Fuzzy Find** | Telescope — files, grep, buffers, diagnostics, file-browser, lazygit |
| **Syntax** | Treesitter with 30+ grammars |
| **Explorer** | Neo-tree file explorer |
| **Git** | Gitsigns, LazyGit |
| **UI** | Dashboard, Bufferline, Lualine, ToggleTerm, Undotree |
| **Editor** | Todo-comments, Illuminate, Navic, Indent-blankline, Which-key |
| **Extras** | Markdown preview, Schemastore, Mini.indentscope + surround |

Integration: `nix-community/nixvim` imported via `builtins.fetchGit` (non-flakes).

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

### Post-Install

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
| [Zoxide](https://github.com/ajeetdsouza/zoxide) | Smarter `cd` |

### Desktop Environment

| Feature | Implementation |
|---------|----------------|
| **Window Manager** | GNOME (Wayland) |
| **Dock** | Dash to Dock |
| **Blur** | Blur My Shell |
| **Clipboard** | Clipboard Indicator |
| **Tray Icons** | AppIndicator |
| **Keyboard** | Kanata (vim-style leader key) |
| **Login Wallpaper** | Catppuccin Mocha via GDM dconf profile |

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

- `lazygit`, `delta`
- `git`, `git-lfs`, `gh`
- `rustc`, `cargo`, `clippy`, `rustfmt`, `rust-analyzer`
- `python3`, `black`, `isort`, `ruff`
- `nodePackages.prettier`, `typescript`
- `go`, `gopls`
- `lua`, `stylua`, `lua-language-server`
- `nixfmt`, `statix`, `nil`
- `shellcheck`, `shfmt`, `shellharden`
- `terraform`, `tflint`, `terraform-ls`
- `yaml-language-server`, `taplo`, `marksman`

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
  username = "stefan-hacks";
  fullName = "stefan-hacks";
  homeDirectory = "/home/${username}";
in
```

### Wallpapers

```bash
# Set desktop wallpaper
gsettings set org.gnome.desktop.background picture-uri \
  "file:///home/USER/.config/nixit/assets/wallpapers/Catppuccin_Mocha/wallpaper.png"
```

### Dotfiles

Modify files in `dotfiles/` and rebuild — symlinks update automatically:

```bash
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
# Garbage collection (automatic — 30d retention)
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
- [Nixvim](https://github.com/nix-community/nixvim) — Declarative Neovim
- [Starship](https://starship.rs/) — Cross-shell prompt
- [Atuin](https://atuin.sh/) — Shell history sync
- [Kanata](https://github.com/jtroo/kanata) — Keyboard remapping

---

<div align="center">

**Made with ❄️ and ❤️**

[Report Issue](https://github.com/stefan-hacks/nixit/issues) · [Contribute](https://github.com/stefan-hacks/nixit/pulls)

</div>
