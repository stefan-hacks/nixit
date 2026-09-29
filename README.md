<div align="center">

![Nixit Brand](assets/icon2.png)

# ❄️ nixit

**Declarative NixOS workstation for `ghost`**

[![NixOS](https://img.shields.io/badge/NixOS-26.05-5277C3?logo=nixos&logoColor=white)](https://nixos.org/)
[![Home Manager](https://img.shields.io/badge/Home%20Manager-release--26.05-blue.svg)](https://github.com/nix-community/home-manager)
[![License](https://img.shields.io/badge/License-MIT-green.svg)](LICENSE)

*Flakes · Dendritic · Multi-Desktop*

</div>

---

## Overview

nixit is a production-grade NixOS flake built with **flake-parts** and the **dendritic** pattern. Every system capability, desktop preference, and dotfile is declared in one repository and locked in `flake.lock`.

The layout follows the same flat, aspect-oriented structure used by [i-nix](https://github.com/stefan-hacks/i-nix):

| Layer | Directory | Purpose |
|-------|-----------|---------|
| **System** | `nixos/` | NixOS features exported as `nixosModules.*` |
| **Home** | `home/` | Generic HM features exported as `homeManagerModules.*` |
| **Desktop** | `desktop/` | GNOME & DankMaterialShell profiles |
| **Hosts** | `systems/` | Per-host hardware + top-level configuration |
| **Users** | `users/` | Per-user HM entry points + dconf |

---

## Quick Start

> **Prerequisites:** NixOS with flakes enabled.

```bash
# 1. Clone
git clone https://github.com/stefan-hacks/nixit.git ~/.config/nixit
cd ~/.config/nixit

# 2. (First install only) copy hardware config
sudo cp /etc/nixos/hardware-configuration.nix systems/ghost/hardware.nix

# 3. Build & activate
sudo nixos-rebuild switch --flake .#ghost

# 4. Or with experimental features disabled by default
sudo nixos-rebuild switch --flake .#ghost \
  --extra-experimental-features 'nix-command flakes'
```

After first boot, log out and back in for all Home Manager activations to take effect.

---

## Repository Layout

```
.
├── flake.nix                 # Inputs, outputs, host registry
├── flake.lock                # Pinned dependency graph
│
├── nixos/                    # System aspects (nixosModules.*)
│   ├── flake-parts.nix       # Exports all aspects below
│   ├── boot.nix              # LUKS, systemd-boot, kernel
│   ├── networking.nix        # Firewall, DNS, Mullvad
│   ├── user.nix              # Primary user, groups, icon
│   ├── packages.nix          # System packages
│   ├── services.nix          # PipeWire, printing, CUPS
│   ├── programs.nix          # Program defaults (git, 1password)
│   ├── virtualization.nix    # Podman, distrobox
│   ├── kanata.nix            # Evdev keyboard remapping
│   ├── nixvim.nix            # Declarative Neovim (Nixvim)
│   ├── ollama.nix            # Local LLM inference
│   ├── terax.nix             # Terax AI integration
│   ├── hermes.nix            # Hermes agent tools
│   └── ...
│
├── home/                     # Generic HM aspects (homeManagerModules.*)
│   ├── flake-parts.nix
│   ├── bash.nix
│   ├── kitty.nix
│   ├── starship.nix
│   ├── git.nix
│   ├── ssh.nix
│   ├── atuin.nix
│   ├── fastfetch.nix
│   └── ...
│
├── desktop/                  # Desktop-environment profiles
│   ├── profiles.nix          # GNOME vs DankMaterialShell selector
│   ├── gnome/
│   │   └── gnome.nix         # GNOME DE, extensions, GDM theme
│   └── dank/
│       └── dank.nix          # DankMaterialShell + niri + ags
│
├── systems/                  # Per-host declarations
│   └── ghost/
│       ├── default.nix       # Host entry point
│       ├── configuration.nix # Host identity & stateVersion
│       └── hardware.nix      # Hardware scan (nixos-generate-config)
│
├── users/                    # Per-user HM entry points
│   └── stefan-hacks/
│       ├── default.nix       # User HM imports + activation
│       └── gnome/            # User-specific GNOME dconf
│           ├── shell.nix
│           ├── shell-extensions.nix
│           ├── settings-daemon.nix
│           └── ...
│
├── dotfiles/                 # Raw configs sourced by HM modules
│   ├── bash/
│   ├── kitty/
│   ├── kanata/
│   ├── starship/
│   └── ...
│
└── assets/
    ├── icon2.png             # User icon
    └── wallpapers/           # Categorized wallpaper collection
```

---

## Desktop Profiles

Choose the desktop environment by setting `desktopProfile` in `systems/<host>/default.nix`:

```nix
# systems/ghost/default.nix
{ desktopProfile = "gnome"; }   # or "dank"
```

| Profile | Compositor | Description |
|-----------|------------|-------------|
| **gnome** | Mutter (Wayland) | GNOME 50 + extensions (OpenBar, Blur My Shell, Dash to Dock, etc.) |
| **dank** | niri (Wayland) | DankMaterialShell + ags bar + dynamic wallpapers |

---

## Key Features

### Terminal Stack

| Tool | Purpose |
|------|---------|
| [Kitty](https://sw.kovidgoyal.net/kitty/) | GPU-accelerated terminal |
| [Blesh](https://github.com/akinomyoga/ble.sh) | Bash syntax highlighting & menus |
| [Starship](https://starship.rs/) | Cross-shell prompt |
| [Atuin](https://atuin.sh/) | Synced, encrypted shell history |
| [Zoxide](https://github.com/ajeetdsouza/zoxide) | Smart `cd` |
| [Fastfetch](https://github.com/fastfetch-cli/fastfetch) | System info branding |

### Neovim (Nixvim)

Fully declarative via [Nixvim](https://github.com/nix-community/nixvim). No manual plugin management — every LSP, keybinding, and theme is pinned in `nixos/nixvim.nix`.

| Category | Features |
|----------|----------|
| **Theme** | Catppuccin Macchiato |
| **LSP** | lua_ls, rust_analyzer, nil, pylsp, clangd, ts_ls, bashls, jsonls, yamlls, marksman, taplo, eslint |
| **Completion** | nvim-cmp |
| **Navigation** | Telescope, Neo-tree, Harpoon |
| **Editing** | Treesitter, nvim-surround, conform, nvim-lint |
| **Git** | gitsigns, fugitive, diffview |
| **Terminal** | Toggleterm |
| **UI** | Which-key, lualine, bufferline, noice |

### Keyboard Layer (Kanata)

Kanata remaps at the evdev level. The leader key (`Space`) works in *every* application.

- **Leader + `h/j/k/l`** → arrow keys
- **Leader + `w/b/e/g`** → word / line / paragraph / document navigation
- **Leader + `a/u/v/y/d/x/c/p/s`** → select-all, undo, visual, yank, delete, cut, copy, paste, save
- **Leader + `t/T`** → new tab / close tab

Config: `dotfiles/kanata/kanata_gnome.kbd`

---

## Scaling: Add a New Host

1. **Create host directory**
   ```bash
   mkdir -p systems/newhost
   sudo cp /etc/nixos/hardware-configuration.nix systems/newhost/hardware.nix
   ```

2. **Create `systems/newhost/default.nix`**
   ```nix
   { inputs, ... }: {
     flake.nixosConfigurations.newhost = inputs.nixpkgs.lib.nixosSystem {
       system = "x86_64-linux";
       modules = [
         ./hardware.nix
         inputs.self.nixosModules.boot
         inputs.self.nixosModules.networking
         inputs.self.nixosModules.user
         inputs.self.nixosModules.packages
         inputs.self.nixosModules.services
         inputs.self.nixosModules.home-manager
         {
           networking.hostName = "newhost";
           system.stateVersion = "26.05";
         }
       ];
     };
   }
   ```

3. **Create `users/<name>/default.nix`** (copy from `users/stefan-hacks/`)

4. **Build**
   ```bash
   sudo nixos-rebuild switch --flake .#newhost
   ```

---

## Scaling: Add a New User

1. **Create `users/<name>/default.nix`**
   ```nix
   { config, pkgs, ... }:
   {
     home.username = "<name>";
     home.homeDirectory = "/home/<name>";
     imports = [
       ../../home/bash.nix
       ../../home/git.nix
       ../../home/kitty.nix
       # ... pick generic aspects
     ];
   }
   ```

2. **Add user to host in `systems/<host>/default.nix`**
   ```nix
   inputs.self.nixosModules.user  # enables the user module
   ```

3. **Rebuild**
   ```bash
   sudo nixos-rebuild switch --flake .#ghost
   ```

---

## Customisation

| Layer | File(s) to Edit |
|-------|-----------------|
| **System packages** | `nixos/packages.nix` |
| **Desktop** | `desktop/gnome/gnome.nix` or `desktop/dank/dank.nix` |
| **Shell** | `home/bash.nix` + `dotfiles/bash/.bash_aliases` |
| **Terminal** | `dotfiles/kitty/kitty.conf` |
| **Neovim** | `nixos/nixvim.nix` |
| **Kanata** | `dotfiles/kanata/kanata_gnome.kbd` |
| **Wallpapers** | Drop files into `assets/wallpapers/<theme>/` |
| **Prompt** | `dotfiles/starship/starship.toml` |

---

## Maintenance

```bash
# Update flake inputs
nix flake update

# Check evaluation (no build)
nix flake check

# Build system derivation
nix build .#nixosConfigurations.ghost.config.system.build.toplevel

# Rebuild and activate
sudo nixos-rebuild switch --flake .#ghost

# Garbage collect
sudo nix-collect-garbage -d
```

---

## Security

| Layer | Implementation |
|-------|----------------|
| **Disk** | LUKS2 full-disk encryption (`nixos/boot.nix`) |
| **Network** | nftables firewall, Mullvad VPN (`nixos/networking.nix`) |
| **Secrets** | 1Password CLI, SSH keys in `dotfiles/.ssh/` |
| **Updates** | Weekly auto-upgrade via `nixos/maintenance.nix` |

---

## License

MIT — See [LICENSE](LICENSE).

<div align="center">

Built with ❄️ Nix by **stefan-hacks**

</div>
