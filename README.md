<div align="center">

# ❄️ Nixit

**A Reproducible NixOS Workstation with Flakes + Home Manager**

[![NixOS](https://img.shields.io/badge/NixOS-26.05-5277C3?logo=nixos&logoColor=white)](https://nixos.org/)
[![Home Manager](https://img.shields.io/badge/Home%20Manager-26.05-blue.svg)](https://github.com/nix-community/home-manager)
[![License](https://img.shields.io/badge/License-MIT-green.svg)](LICENSE)

_Modular · Declarative · Reproducible_

</div>

---

## Overview

A production-ready NixOS workstation configuration built with **flakes** and **Home Manager**. System and user configs are split into focused modules — one per tool, one per concern.

| Component    | Detail                             |
| ------------ | ---------------------------------- |
| **OS**       | NixOS 26.05 (stable)               |
| **Config**   | Flake-based (`flake.nix`)          |
| **Desktop**  | GNOME 50 (Wayland)                 |
| **Shell**    | Bash + Blesh + Starship            |
| **Terminal** | Kitty                              |
| **Editor**   | Neovim (via Nixvim)                |
| **Security** | LUKS, Firewall, Mullvad, 1Password |

---

## Philosophy

- **Flakes** — Reproducible inputs, reproducible outputs.
- **Home Manager** — Declarative user environment (dotfiles, services, dconf).
- **One module per tool** — Each `.nix` handles exactly one concern.
- **No activation scripts** — Home Manager and `systemd.tmpfiles` handle deployment.

---

## Repository Structure

```
.
├── flake.nix                          # Flake inputs + outputs
├── hosts/
│   └── ghost/
│       ├── default.nix                  # Host entry point
│       └── hardware-configuration.nix
├── modules/
│   ├── nixos/                         # System-level modules
│   │   ├── boot.nix
│   │   ├── networking.nix
│   │   ├── locale.nix
│   │   ├── user.nix
│   │   ├── gnome.nix
│   │   ├── programs.nix
│   │   ├── packages.nix
│   │   ├── services.nix
│   │   ├── kanata.nix
│   │   ├── nixvim.nix
│   │   ├── virtualization.nix
│   │   ├── firewall.nix
│   │   ├── fonts.nix
│   │   ├── environment.nix
│   │   ├── maintenance.nix
│   │   ├── bluetooth.nix
│   │   ├── printing.nix
│   │   └── documentation.nix
│   └── home/                          # Home Manager modules
│       ├── bash.nix
│       ├── git.nix
│       ├── kitty.nix
│       ├── blesh.nix
│       ├── starship.nix
│       ├── atuin.nix
│       ├── ssh.nix
│       ├── fastfetch.nix
│       └── dconf.nix
├── home/
│   └── stefan-hacks/
│       └── home.nix                     # HM entry point
├── dotfiles/                          # Raw dotfiles (sourced by HM)
│   ├── bash/
│   ├── blesh/
│   ├── gitconfig/
│   ├── kitty/
│   ├── nvim/
│   ├── starship/
│   ├── fastfetch/
│   └── kanata/
├── gnome/
│   └── dconf.ini                        # GNOME settings (loaded by HM activation)
└── assets/
    ├── icon2.png
    └── wallpapers/
```

---

## Quick Start

### Fresh Install

```bash
git clone https://github.com/stefan-hacks/nixit.git ~/.config/nixit
cd ~/.config/nixit
cp /etc/nixos/hardware-configuration.nix hosts/ghost/
sudo nixos-rebuild switch --flake .#ghost
```

### Post-Install

```bash
# Atuin — sync shell history
atuin register -u USERNAME -e EMAIL
atuin import auto
atuin sync

# GNOME settings are auto-loaded via dconf.nix activation
# Wallpapers live in ~/.config/nixit/assets/wallpapers/
```

---

## Key Features

### Terminal Stack

| Tool                                                    | Purpose                                         |
| ------------------------------------------------------- | ----------------------------------------------- |
| [Kitty](https://sw.kovidgoyal.net/kitty/)               | GPU-accelerated terminal                        |
| [Blesh](https://github.com/akinomyoga/ble.sh)           | Bash line editor (syntax highlighting, history) |
| [Starship](https://starship.rs/)                        | Cross-shell prompt                              |
| [Atuin](https://atuin.sh/)                              | Synced shell history                            |
| [Zoxide](https://github.com/ajeetdsouza/zoxide)         | Smarter `cd`                                    |
| [Fastfetch](https://github.com/fastfetch-cli/fastfetch) | System info with custom branding                |

### Desktop Environment

| Feature             | Implementation                           |
| ------------------- | ---------------------------------------- |
| **Window Manager**  | GNOME 50 (Wayland)                       |
| **Dock**            | Dash to Dock                             |
| **Blur**            | Blur My Shell                            |
| **Clipboard**       | GPaste                                   |
| **Tray Icons**      | AppIndicator                             |
| **Keyboard**        | Kanata (vim-style leader key)            |
| **Login Wallpaper** | Catppuccin Mocha (GDM profile)           |
| **Bar Theme**       | OpenBar + Yaru accent/folder colors      |
| **Wallpapers**      | Wallpicker extension + assets collection |

### GNOME Extensions

- AppIndicator — Tray icons
- ArcMenu — Application menu
- Blur My Shell — Background blur
- Dash to Dock — Bottom dock
- Dynamic Music Pill — Media widget
- GPaste — Clipboard manager
- Notification Configurator — Notification styling
- OpenBar — Top bar theming
- Pomodoro Timer — Focus timer
- Quake Terminal — Dropdown terminal
- Quick Settings Audio Panel — Audio device selector
- Steal My Focus Window — Focus behavior
- Vitals — System monitor
- Wallpicker — Wallpaper selector
- Modern Clock — Clock widget

---

## Neovim (Nixvim)

Configured declaratively via [Nixvim](https://github.com/nix-community/nixvim) — zero manual plugin management.

| Category       | Features                                                                                                                     |
| -------------- | ---------------------------------------------------------------------------------------------------------------------------- |
| **Theme**      | Catppuccin Macchiato, transparent background                                                                                 |
| **Completion** | nvim-cmp — LSP, buffer, path, luasnip, lspkind                                                                               |
| **LSP**        | lua_ls, nixd, basedpyright, ts_ls, rust-analyzer, terraformls, jsonls, yamlls, helm_ls, marksman, html, bash-language-server |
| **Formatting** | conform.nvim — black, isort, nixfmt, stylua, prettier, shfmt, jq                                                             |
| **Fuzzy Find** | Telescope — files, grep, buffers, diagnostics, file-browser, lazygit                                                         |
| **Syntax**     | Treesitter with 30+ grammars                                                                                                 |
| **Explorer**   | Neo-tree                                                                                                                     |
| **Git**        | Gitsigns, LazyGit                                                                                                            |
| **UI**         | Dashboard, Bufferline, Lualine, ToggleTerm, Undotree                                                                         |
| **Extras**     | Markdown preview, Schemastore, Mini.indentscope + surround                                                                   |

---

## Package Highlights

<details>
<summary><strong>Core & Shell</strong></summary>

`bash` `blesh` `starship` `atuin` `zoxide` `fzf` `direnv` `carapace` `eza` `bat` `ripgrep` `fd` `jq` `yq-go` `btop` `fastfetch` `imagemagick` `exiftool`

</details>

<details>
<summary><strong>Development</strong></summary>

`lazygit` `delta` `gh` `gcc` `gnumake` `rustc` `cargo` `clippy` `rustfmt` `rust-analyzer` `python3` `black` `isort` `ruff` `prettier` `typescript` `go` `gopls` `lua` `stylua` `lua-language-server` `nixfmt` `statix` `nixd` `nil` `shellcheck` `shfmt` `terraform` `tflint` `terraform-ls` `yaml-language-server` `taplo` `marksman` `vscode-langservers-extracted`

</details>

<details>
<summary><strong>Desktop Applications</strong></summary>

`firefox` `chromium` `joplin-desktop` `evolution` `libreoffice` `onlyoffice-desktopeditors` `mpv` `vlc` `ffmpeg` `discord` `_1password-gui` `mullvad-vpn`

</details>

<details>
<summary><strong>Security & Network</strong></summary>

`gnupg` `openssl` `age` `sops` `nmap` `wireshark` `tcpdump` `netdiscover` `arp-scan`

</details>

---

## Customization

### User Settings

Edit `modules/nixos/user.nix`:

```nix
users.users.stefan-hacks = {
  isNormalUser = true;
  description = "stefan-hacks";
  shell = pkgs.bash;
  extraGroups = [ "wheel" "networkmanager" "video" "audio" "kvm" "input" "uinput" ];
};
```

### Home Manager Settings

Edit `home/stefan-hacks/home.nix`:

```nix
home.username = "stefan-hacks";
home.homeDirectory = "/home/stefan-hacks";
home.stateVersion = "26.05";
```

### Dotfiles

Modify files in `dotfiles/` and rebuild:

```bash
sudo nixos-rebuild switch --flake .#ghost
```

### GNOME Settings

Export live settings and commit:

```bash
cd ~/.config/nixit
dconf dump / > gnome/dconf.ini
# Scrub sensitive data before committing
git add gnome/dconf.ini
git commit -m "chore: update GNOME settings"
```

Home Manager loads `gnome/dconf.ini` on activation.

---

## Maintenance

### Daily

```bash
# Rebuild after changes
sudo nixos-rebuild switch --flake .#ghost

# With upgrade
sudo nixos-rebuild switch --flake .#ghost --upgrade
```

### Weekly

```bash
# Garbage collection (30d retention — automatic)
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

| Alias        | Command                                                   | Description            |
| ------------ | --------------------------------------------------------- | ---------------------- |
| `nix-switch` | `sudo nixos-rebuild switch --flake ~/.config/nixit#ghost` | Rebuild system         |
| `nix-test`   | `sudo nixos-rebuild test --flake ~/.config/nixit#ghost`   | Test without switching |
| `nix-gc`     | `sudo nix-collect-garbage -d`                             | Garbage collect        |
| `ll`         | `eza -l`                                                  | Long listing           |
| `la`         | `eza -la`                                                 | All files              |
| `cat`        | `bat --paging=never`                                      | Syntax-highlighted cat |
| `gs`         | `git status`                                              | Git status             |
| `ipy`        | `ipython`                                                 | Interactive Python     |

---

## Troubleshooting

### Build Failures

```bash
# Check flake syntax
nix flake check

# Dry run
sudo nixos-rebuild dry-build --flake .#ghost

# Show trace
sudo nixos-rebuild switch --flake .#ghost --show-trace
```

### Service Issues

```bash
# Kanata status
sudo systemctl status kanata-internal

# Home Manager activation logs
journalctl --user -u home-manager-stefan-hacks.service
```

---

## Security

- **Disk Encryption**: LUKS on root and swap
- **Firewall**: Enabled with GSConnect/KDE Connect ports
- **VPN**: Mullvad VPN client
- **Secrets**: GnuPG agent, 1Password integration
- **Updates**: Automatic weekly GC and optimisation

---

## Acknowledgments

- [NixOS](https://nixos.org/) — Purely functional Linux
- [Home Manager](https://github.com/nix-community/home-manager) — Declarative user config
- [Nixvim](https://github.com/nix-community/nixvim) — Declarative Neovim
- [Starship](https://starship.rs/) — Cross-shell prompt
- [Atuin](https://atuin.sh/) — Shell history sync
- [Kanata](https://github.com/jtroo/kanata) — Keyboard remapping

---

<div align="center">

**Made with ❄️ and ❤️**

[Report Issue](https://github.com/stefan-hacks/nixit/issues) · [Contribute](https://github.com/stefan-hacks/nixit/pulls)

</div>
