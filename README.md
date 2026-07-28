<div align="center">

<pre>
   ███╗   ██╗██╗██╗  ██╗██╗████████╗
   ████╗  ██║██║╚██╗██╔╝██║╚══██╔══╝
   ██╔██╗ ██║██║ ╚███╔╝ ██║   ██║
   ██║╚██╗██║██║ ██╔██╗ ██║   ██║
   ██║ ╚████║██║██╔╝ ██╗██║   ██║
   ╚═╝  ╚═══╝╚═╝╚═╝  ╚═╝╚═╝   ╚═╝
</pre>

**A Reproducible NixOS Workstation with Flakes + Home Manager**

[![NixOS](https://img.shields.io/badge/NixOS-26.05-5277C3?logo=nixos&logoColor=white)](https://nixos.org/)
[![Home Manager](https://img.shields.io/badge/Home%20Manager-26.05-blue.svg)](https://github.com/nix-community/home-manager)
[![License](https://img.shields.io/badge/License-MIT-green.svg)](LICENSE)

*Modular · Declarative · Reproducible*

</div>

---

## Overview

**Nixit** is a production-ready NixOS workstation configuration built with **flakes** and **Home Manager**. System configuration is split into focused modules — one per concern. User dotfiles are managed declaratively via Home Manager with no manual symlinking.

| Component | Detail |
|-----------|--------|
| **OS** | NixOS 26.05 (stable) |
| **Config** | Flake-based (`flake.nix`) |
| **Desktop** | GNOME 48 (Wayland) |
| **Shell** | Bash + Blesh + Starship |
| **Terminal** | Kitty |
| **Editor** | Neovim via Nixvim |
| **Security** | LUKS, Firewall, Mullvad, 1Password |

---

## Philosophy

- **Flakes** — Reproducible inputs, reproducible outputs
- **Home Manager** — Declarative user environment (dotfiles, services, dconf)
- **One concern per module** — Each tool/service gets its own `.nix` file
- **Git-tracked** — Entire config lives in `~/.config/nixit`
- **No activation scripts** — Home Manager handles dotfile deployment natively

---

## Repository Structure

```
~/.config/nixit/
├── flake.nix                          # Flake inputs + outputs
├── hosts/
│   └── ghost/
│       ├── default.nix                  # Host entry point (imports system modules)
│       └── hardware-configuration.nix
├── modules/
│   ├── nixos/                         # System-level modules
│   │   ├── boot.nix                   # GRUB, LUKS, EFI
│   │   ├── networking.nix             # NetworkManager, hostname
│   │   ├── locale.nix                 # Timezone, locale, console
│   │   ├── user.nix                   # User account definition
│   │   ├── gnome.nix                  # GDM, GNOME desktop, XDG portal
│   │   ├── programs.nix               # System-wide programs (dconf, gpaste, ssh)
│   │   ├── packages.nix               # System packages
│   │   ├── services.nix               # System services (SSH, fwupd)
│   │   ├── kanata.nix                 # Keyboard remapper service
│   │   ├── nixvim.nix                 # Declarative Neovim config
│   │   ├── virtualization.nix         # QEMU/libvirt
│   │   ├── firewall.nix               # Firewall rules + GSConnect
│   │   ├── fonts.nix                  # System fonts
│   │   ├── environment.nix            # Environment variables, PATH
│   │   ├── maintenance.nix            # Auto GC, nix optimisation
│   │   ├── bluetooth.nix              # Bluetooth settings
│   │   ├── printing.nix               # CUPS
│   │   └── documentation.nix          # Man pages, NixOS manual
│   └── home/                          # Home Manager modules
│       ├── bash.nix                   # .bashrc, .bash_aliases
│       ├── git.nix                    # .gitconfig
│       ├── kitty.nix                  # kitty.conf + theme
│       ├── blesh.nix                  # Bash line editor config
│       ├── starship.nix               # Prompt config
│       ├── atuin.nix                  # Shell history config
│       ├── kanata.nix                 # Kanata user config
│       ├── ssh.nix                    # .ssh/config
│       ├── fastfetch.nix             # Fastfetch config + icon
│       └── dconf.nix                  # GNOME dconf settings + wallpapers
├── home/
│   └── stefan-hacks/
│       └── home.nix                   # Home Manager entry point
├── dotfiles/                          # Raw dotfiles (sourced by HM modules)
│   ├── bash/
│   ├── blesh/
│   ├── gitconfig/
│   ├── kitty/
│   ├── nvim/
│   ├── starship/
│   ├── fastfetch/
│   └── kanata/
├── gnome/
│   └── dconf.ini                      # GNOME dconf dump (loaded by HM activation)
└── assets/
    ├── wallpapers/
    └── icon2.png                     # Fastfetch logo
```

---

## Quick Start

### Fresh Install

```bash
# Clone to standard location
git clone https://github.com/stefan-hacks/nixit.git ~/.config/nixit
cd ~/.config/nixit

# Edit user settings
$EDITOR hosts/ghost/default.nix      # hostname, imports
$EDITOR modules/nixos/user.nix       # username, shell, groups
$EDITOR home/stefan-hacks/home.nix   # home directory

# Build and activate
sudo nixos-rebuild switch --flake .#ghost
```

### Post-Install

```bash
# Atuin — sync shell history
atuin register -u USERNAME -e EMAIL
atuin import auto
atuin sync

# GNOME settings are auto-loaded via dconf.nix home.activation
# Wallpapers are deployed to ~/.config/nixit/assets/wallpapers/
```

---

## Neovim (Nixvim)

Neovim is configured declaratively via [Nixvim](https://github.com/nix-community/nixvim) — a full IDE setup with zero manual plugin management.

| Category | Features |
|----------|----------|
| **Theme** | Catppuccin Macchiato, transparent background |
| **Completion** | nvim-cmp — LSP, buffer, path, luasnip, lspkind icons |
| **LSP** | lua_ls, nixd, basedpyright, ts_ls, rust-analyzer, terraformls, jsonls, yamlls, helm_ls, marksman, html, bash-language-server |
| **Formatting** | conform.nvim — black, isort, nixfmt, stylua, prettier, shfmt, jq, shellharden |
| **Fuzzy Find** | Telescope — files, grep, buffers, diagnostics, file-browser, lazygit |
| **Syntax** | Treesitter with 30+ grammars |
| **Explorer** | Neo-tree file explorer |
| **Git** | Gitsigns, LazyGit |
| **UI** | Dashboard, Bufferline, Lualine, ToggleTerm, Undotree |
| **Editor** | Todo-comments, Illuminate, Navic, Indent-blankline, Which-key |
| **Extras** | Markdown preview, Schemastore, Mini.indentscope + surround |

Integration: `nix-community/nixvim` imported as a flake input (uses its own pinned nixpkgs).

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
| [Fastfetch](https://github.com/fastfetch-cli/fastfetch) | System info with custom branding |

### Desktop Environment

| Feature | Implementation |
|---------|----------------|
| **Window Manager** | GNOME (Wayland) |
| **Dock** | Dash to Dock |
| **Blur** | Blur My Shell |
| **Clipboard** | GPaste |
| **Tray Icons** | AppIndicator |
| **Keyboard** | Kanata (vim-style leader key) |
| **Login Wallpaper** | Catppuccin Mocha via GDM dconf profile |
| **Bar Theme** | OpenBar with Catppuccin palette + Yaru themes (accent colors & folder colors) |
| **Wallpapers** | Wallpicker extension + `~/.config/nixit/assets/wallpapers` |

### GNOME Extensions

- `appindicatorsupport@rgcjonas.gmail.com` — Tray icons
- `arcmenu@arcmenu.com` — Application menu
- `blur-my-shell@aunetx` — Background blur
- `dash-to-dock@micxgx.gmail.com` — Bottom dock
- `dynamic-music-pill@andbal` — Media player widget
- `GPaste@gnome-shell-extensions.gnome.org` — Clipboard manager
- `notification-configurator@exposedcat` — Notification styling
- `openbar@neuromorph` — Custom top bar theming
- `pomodoro-timer@Oguzhankokulu.github.com` — Focus timer
- `quake-terminal@diegodario88.github.io` — Dropdown terminal
- `quick-settings-audio-panel@rayzeq.github.io` — Audio device panel
- `steal-my-focus-window@steal-my-focus-window` — Focus behavior
- `Vitals@CoreCoding.com` — System monitor
- `wallpicker@omarxkhalid.github.io` — Wallpaper selector
- `modernclock@gnome-port` — Clock widget

---

## Package Highlights

<details>
<summary><strong>Core & Shell</strong></summary>

- `bash`, `blesh`, `starship`, `atuin`, `zoxide`, `fzf`, `direnv`, `carapace`
- `eza`, `bat`, `bat-extras.core`, `ripgrep`, `fd`
- `jq`, `yq-go`
- `btop`, `fastfetch`, `onefetch`
- `imagemagick`, `exiftool`

</details>

<details>
<summary><strong>Development</strong></summary>

- `lazygit`, `delta`
- `git`, `git-lfs`, `gh`
- `gcc`, `gnumake`
- `rustc`, `cargo`, `clippy`, `rustfmt`, `rust-analyzer`
- `python3`, `black`, `isort`, `ruff`
- `nodePackages.prettier`, `typescript`
- `go`, `gopls`
- `lua`, `stylua`, `lua-language-server`
- `nixfmt`, `statix`, `nixd`, `nil`
- `shellcheck`, `shfmt`, `shellharden`
- `terraform`, `tflint`, `terraform-ls`
- `yaml-language-server`, `taplo`, `marksman`
- `vscode-langservers-extracted`

</details>

<details>
<summary><strong>Desktop Applications</strong></summary>

- `firefox`, `chromium`
- `libreoffice`, `onlyoffice-desktopeditors`
- `mpv`, `vlc`, `ffmpeg`
- `discord`
- `_1password-gui`, `mullvad-vpn`

</details>

<details>
<summary><strong>Security & Network</strong></summary>

- `gnupg`, `openssl`, `age`, `sops`
- `nmap`, `wireshark`, `tcpdump`

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
  extraGroups = [ "wheel" "networkmanager" "video" "audio" ];
};
```

### Home Manager Settings

Edit `home/stefan-hacks/home.nix`:

```nix
home.username = "stefan-hacks";
home.homeDirectory = "/home/stefan-hacks";
```

### Dotfiles

Modify files in `dotfiles/` and rebuild — Home Manager handles deployment:

```bash
sudo nixos-rebuild switch --flake .#ghost
```

### GNOME Settings

Export live settings and commit the result:

```bash
cd ~/.config/nixit
dconf dump / > gnome/dconf.ini
# Scrub sensitive data (playback-history, last-folder-path)
git add gnome/dconf.ini
git commit -m "chore: update GNOME settings"
```

Home Manager will load it on the next activation.

### Wallpapers

```bash
# Set desktop wallpaper
gsettings set org.gnome.desktop.background picture-uri \
  "file:///home/USER/.config/nixit/assets/wallpapers/Catppuccin_Mocha/wallpaper.png"
```

---

## Maintenance

### Daily

```bash
# Rebuild after changes
sudo nixos-rebuild switch --flake .#ghost

# Or with upgrade
sudo nixos-rebuild switch --flake .#ghost --upgrade
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
| `nix-switch` | `sudo nixos-rebuild switch --flake ~/.config/nixit#ghost` | Rebuild system |
| `nix-test` | `sudo nixos-rebuild test --flake ~/.config/nixit#ghost` | Test without switching |
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
# Check flake syntax
nix flake check

# Dry run
sudo nixos-rebuild dry-build --flake .#ghost

# Show trace
sudo nixos-rebuild switch --flake .#ghost --show-trace
```

### Service Issues

```bash
# Check kanata status
sudo systemctl status kanata-internal

# View Home Manager activation logs
journalctl --user -u home-manager-stefan-hacks.service
```

### Home Manager Activation

```bash
# Re-run home-manager switch manually
home-manager switch --flake .#stefan-hacks
```

---

## Security

- **Disk Encryption**: LUKS on root and swap partitions
- **Firewall**: Enabled with GSConnect and KDE Connect ports
- **VPN**: Mullvad VPN client
- **Secrets**: GnuPG agent, 1Password integration
- **Updates**: Automatic weekly garbage collection

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
