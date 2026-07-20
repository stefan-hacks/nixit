# Nixit - Production NixOS Workstation Configuration

> **⚠️ WORK IN PROGRESS** - Comprehensive system configuration under active development

## Overview

This repository contains a complete, reproducible NixOS configuration for a GNOME-based development workstation. Designed for the hostname `ghost`, this configuration emphasizes:

- **Single-file architecture** (`configuration.nix`)
- **No flakes**, **no Home Manager**
- **Git-managed dotfiles** in `~/.config/nixit`
- **Production-ready** and fully documented

---

## 🖥️ System Specification

| Component | Configuration |
|-----------|---------------|
| **Hostname** | ghost |
| **Desktop** | GNOME (Wayland) |
| **Shell** | Bash + Blesh |
| **Bootloader** | GRUB (EFI) |
| **Storage** | LUKS + ext4 |
| **Audio** | PipeWire |
| **State Version** | 26.05 |

---

## 📁 Repository Structure

```
~/.config/nixit/
├── configuration.nix          # Main NixOS configuration
├── hardware-configuration.nix   # Hardware-specific config
├── README.md                    # This file
├── gnome/
│   └── dconf.ini               # GNOME settings (sanitized)
├── assets/
│   └── wallpapers/             # Desktop backgrounds
├── dotfiles/
│   ├── bash/                   # Bash configuration
│   │   ├── .bashrc
│   │   └── .bash_aliases
│   ├── blesh/                  # Bash line editor
│   │   └── .blerc
│   ├── atuin/                  # Shell history
│   │   └── config.toml
│   ├── kanata/                 # Keyboard remapper
│   │   └── kanata_gnome.kbd
│   ├── kitty/                  # Terminal emulator
│   │   ├── kitty.conf
│   │   └── current-theme.conf
│   ├── nvim/                   # Neovim (LazyVim)
│   │   ├── init.lua
│   │   └── lua/
│   ├── starship/               # Prompt
│   │   └── starship.toml
│   └── gitconfig/              # Git configuration
│       └── .gitconfig
└── DOTFILES_ANALYSIS.md        # Detailed dotfiles audit

```

---

## 🚀 Quick Start

### 1. Clone Repository

```bash
# On a fresh NixOS installation
git clone https://github.com/stefan-hacks/nixit.git ~/.config/nixit
cd ~/.config/nixit
```

### 2. Link Configuration Files

```bash
# Create hardware symlink (customize for your system)
sudo ln -sf ~/.config/nixit/configuration.nix /etc/nixos/configuration.nix

# Optional: Use provided hardware config
sudo ln -sf ~/.config/nixit/hardware-configuration.nix /etc/nixos/hardware-configuration.nix
```

### 3. Update User Information

Edit `configuration.nix` and update:

```nix
username = "your-username";
fullName = "Your Full Name";
```

### 4. Set Git Email

```bash
git config --global user.email "your@email.com"
```

### 5. Build and Switch

```bash
# Test the configuration
sudo nixos-rebuild test

# If successful, apply permanently
sudo nixos-rebuild switch

# Or with upgrade
sudo nixos-rebuild switch --upgrade
```

---

## 🔧 Post-Installation Setup

### Atuin (Shell History Sync)

```bash
# Register account
atuin register -u USERNAME -e EMAIL

# Import existing history
atuin import auto

# Sync
atuin sync
```

### LazyVim (Neovim)

First launch will auto-install plugins. Then:

```bash
# Install LSP servers
:Mason

# Sync plugins
:Lazy sync
```

### Kanata (Keyboard Remapping)

```bash
# Test configuration
kanata --debug --cfg ~/.config/kanata/kanata.kbd

# Service starts automatically via systemd
sudo systemctl status kanata-internal.service
```

### Blesh (Bash Line Editor)

```bash
# Update blesh
ble-update
```

---

## 🎨 Customization

### Wallpapers

Wallpapers are organized by theme in `assets/wallpapers/`:

```
Abyssal_Wave/
Animated/
Catppuccin_Latte/
Catppuccin_Mocha/
Dracula/
...
```

Set via GNOME Settings or:

```bash
gsettings set org.gnome.desktop.background picture-uri \
  "file:///home/USER/.config/nixit/assets/wallpapers/Catppuccin_Mocha/01._Catppuccin_Mocha.png"
```

### GNOME Extensions

Enabled extensions (via dconf.ini):

- `dash-to-dock` - macOS-style dock
- `blur-my-shell` - Blur effects
- `clipboard-indicator` - Clipboard history
- `appindicator` - Tray icons
- `arcmenu` - Application menu
- `coverflow-alt-tab` - Fancy alt-tab
- And more...

---

## 📦 Package Highlights

### System Utilities
- **Shell**: Bash + Blesh + Starship + Atuin
- **Terminal**: Kitty with scrollback.nvim integration
- **Editor**: Neovim (LazyVim configuration)
- **File Managers**: ranger, lf, mc

### Development
- **Languages**: Python, Rust, Node.js
- **Tools**: git, lazygit, delta, direnv
- **LSP**: Mason-managed language servers

### Security / CTF
- **Enumeration**: nmap, enum4linux, smbmap
- **Web**: gobuster, nikto, sqlmap, ffuf
- **Passwords**: john, hashcat, hydra
- **Wireless**: aircrack-ng
- **Forensics**: binwalk, foremost, volatility

### Desktop Applications
- **Browser**: Firefox
- **Office**: LibreOffice, OnlyOffice
- **Media**: MPV, VLC, FFmpeg
- **Communication**: Discord
- **Password Manager**: 1Password
- **VPN**: Mullvad

---

## 🔒 Security Features

- LUKS disk encryption
- Firewall with GSConnect ports
- GnuPG agent with SSH support
- 1Password GUI integration

---

## 🛠️ Maintenance

### Garbage Collection

Automatic weekly GC is configured. Manual cleanup:

```bash
# Delete generations older than 30 days
sudo nix-collect-garbage --delete-older-than 30d

# Optimize store
sudo nix-store --optimise
```

### Update System

```bash
# Update and rebuild
sudo nixos-rebuild switch --upgrade

# Or using alias
update
```

### Rollback

```bash
# List generations
sudo nix-env --list-generations --profile /nix/var/nix/profiles/system

# Rollback to previous
sudo nixos-rebuild switch --rollback

# Or boot from previous generation in GRUB
```

---

## 📝 Aliases

Key aliases from `.bash_aliases`:

| Alias | Description |
|-------|-------------|
| `nix-switch` | Rebuild and switch configuration |
| `nix-gc` | Run garbage collection |
| `nix-list` | List installed packages |
| `ll`, `la`, `lt` | Enhanced ls with eza |
| `cat` | Syntax-highlighted cat (bat) |
| `..`, `...` | Quick directory navigation |
| `gs`, `ga`, `gc`, `gp` | Git shortcuts |
| `ipy` | Interactive Python |

---

## 🐛 Troubleshooting

### Build Failures

```bash
# Check syntax
nix-instantiate --eval --strict ./configuration.nix

# Dry build
sudo nixos-rebuild dry-build
```

### Service Issues

```bash
# Check kanata
sudo systemctl status kanata-internal.service

# Check dconf loading
journalctl -u activation-script
```

### Dotfile Sync Issues

```bash
# Re-run activation manually
sudo /run/current-system/activate

# Or force rebuild
sudo nixos-rebuild switch
```

---

## 🔄 Repository Maintenance

### Adding New Packages

1. Add to `environment.systemPackages` in `configuration.nix`
2. Organize by category
3. Run `nix-switch`
4. Commit changes

### Updating Dotfiles

1. Edit files in `dotfiles/` directory
2. Changes apply on next rebuild
3. Commit and push

### Contributing

1. Make changes in a feature branch
2. Test with `nixos-rebuild test`
3. Commit with descriptive messages
4. Push and create PR

---

## 📄 License

This configuration is provided as-is for educational and personal use.

---

## 🙏 Acknowledgments

- [NixOS](https://nixos.org/) - The purely functional Linux distribution
- [Home Manager](https://github.com/nix-community/home-manager) - Inspiration (not used here)
- [LazyVim](https://www.lazyvim.org/) - Neovim configuration framework
- [Starship](https://starship.rs/) - Cross-shell prompt
- [Atuin](https://atuin.sh/) - Shell history sync
- [Kanata](https://github.com/jtroo/kanata) - Keyboard remapping

---

## ⚠️ Important Notes

1. **Hardware Configuration**: The included `hardware-configuration.nix` is specific to the original system. You must generate your own with:
   ```bash
   sudo nixos-generate-config --root /mnt
   ```

2. **LUKS UUID**: Update the LUKS device UUID in `configuration.nix` to match your system.

3. **Secrets**: This repository contains no secrets. Set sensitive values (WiFi passwords, API keys) separately.

4. **State Version**: Do not change `system.stateVersion` after initial installation.

---

**Last Updated**: 2026-01-21

**Repository**: https://github.com/stefan-hacks/nixit
