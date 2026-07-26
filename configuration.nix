##############################################################################
#
# NixOS Production Workstation
#
# Hostname    : ghost
# Purpose     : Daily xDevelopment Workstation
# Desktop     : GNOME Wayland
# Shell       : Bash
# Boot        : GRUB (EFI)
# Storage     : LUKS + ext4
# Repository  : ~/.config/nixit
#
# Philosophy
#
#  • Single configuration.nix
#  • No flakes
#  • No Home Manager
#  • Git-managed dotfiles in ~/.config/nixit
#  • Production-ready
#  • Reproducible
#
##############################################################################

{ config, pkgs, lib, ... }:

let

  ###########################################################################
  #
  # User Settings
  #
  ###########################################################################

  username = "stefan-hacks";
  fullName = "stefan-hacks";
  homeDirectory = "/home/${username}";

  ###########################################################################
  #
  # Repository Paths
  #
  ###########################################################################

  repoDirectory = "${homeDirectory}/.config/nixit";
  dotfilesDirectory = "${repoDirectory}/dotfiles";
  assetsDirectory = "${repoDirectory}/assets";
  gnomeDirectory = "${repoDirectory}/gnome";

  # Nixvim source for non-flakes NixOS (requires fetchGit, not fetchTarball)
  nixvimSrc = builtins.fetchGit {
    url = "https://github.com/nix-community/nixvim.git";
    ref = "refs/heads/nixos-26.05";
  };

  # GDM wallpaper - copied to nix store for accessibility (GDM user can read it)
  gdmWallpaper = pkgs.runCommand "gdm-wallpaper" { } ''
    mkdir -p $out/share/wallpapers
    cp ${./assets/wallpapers/Catppuccin_Mocha/17._Catppuccin_Mocha.jpg} $out/share/wallpapers/gdm-background.jpg
  '';

  # GRUB wallpaper - direct path works (bootloader reads before users exist)
  grubWallpaper = ./assets/wallpapers/Catppuccin_Mocha/17._Catppuccin_Mocha.jpg;

in

{

##############################################################################
#
# Imports
#
##############################################################################

imports = [
  ./hardware-configuration.nix
  # Nixvim via flake-compat (non-flakes)
  (import nixvimSrc).nixosModules.nixvim
];

##############################################################################
#
# Boot Loader
#
##############################################################################

boot = {

  loader = {

    grub = {
      enable = true;
      device = "nodev";
      efiSupport = true;
      useOSProber = true;
      splashImage = grubWallpaper;
    };

    efi.canTouchEfiVariables = true;

  };

  initrd = {

    luks.devices = {

      "luks-a647bf68-5914-4ce0-b703-59f782388611" = {

        device =
          "/dev/disk/by-uuid/a647bf68-5914-4ce0-b703-59f782388611";

      };

    };

  };

};

##############################################################################
#
# Nix
#
##############################################################################

nix = {

  settings = {

    experimental-features = [

      "nix-command"
      "flakes"

    ];

    auto-optimise-store = true;

    warn-dirty = false;

    trusted-users = [

      "root"
      "@wheel"

    ];

  };

  gc = {

    automatic = true;

    dates = "weekly";

    options = "--delete-older-than 30d";

  };

};

##############################################################################
#
# Nixpkgs
#
##############################################################################

nixpkgs.config.allowUnfree = true;

##############################################################################
#
# System
#
##############################################################################

system.stateVersion = "26.05";

##############################################################################
#
# Networking
#
##############################################################################

networking = {

  hostName = "ghost";

  networkmanager.enable = true;

};

##############################################################################
#
# Time
#
##############################################################################

time.timeZone = "America/Sao_Paulo";

##############################################################################
#
# Localisation
#
##############################################################################

i18n = {

  defaultLocale = "en_US.UTF-8";

  extraLocaleSettings = {

    LC_ADDRESS        = "en_US.UTF-8";
    LC_IDENTIFICATION = "en_US.UTF-8";
    LC_MEASUREMENT    = "en_US.UTF-8";
    LC_MONETARY       = "en_US.UTF-8";
    LC_NAME           = "en_US.UTF-8";
    LC_NUMERIC        = "en_US.UTF-8";
    LC_PAPER          = "en_US.UTF-8";
    LC_TELEPHONE      = "en_US.UTF-8";
    LC_TIME           = "en_US.UTF-8";

  };

};

##############################################################################
#
# Console
#
##############################################################################

console = {

  keyMap = "us";

};

##############################################################################
#
# Kanata Keyboard Remapper
#
##############################################################################

##############################################################################
#
# Kanata Keyboard Remapper
#
# Config file is stored in the repo at ./dotfiles/kanata/kanata_gnome.kbd
# Nix copies this file to the store at build time.
#
##############################################################################

services.kanata = {

  enable = true;

  keyboards = {

    internal = {

      configFile = ./dotfiles/kanata/kanata_gnome.kbd;

    };

  };

};

##############################################################################
#
# X11 / Wayland
#
##############################################################################

services.xserver = {

  enable = true;

  xkb = {

    layout = "us";

    variant = "";

  };

};

##############################################################################
#
# GNOME Desktop
#
##############################################################################

services.displayManager.gdm.enable = true;

services.desktopManager.gnome.enable = true;

##############################################################################
#
# DConf
#
# Enable dconf and load GNOME settings from repository on activation.
#
##############################################################################

programs.dconf.enable = true;

# GDM login screen background wallpaper
# The greeter reads dconf profile 'gdm' which we override here.
# The wallpaper must be in the nix store (world-readable) for the
# gdm-greeter process to access it.
programs.dconf.profiles.gdm.databases = [
  {
    settings."org/gnome/desktop/background" = {
      picture-uri = "file://${gdmWallpaper}/share/wallpapers/gdm-background.jpg";
      picture-options = "zoom";
    };
  }
];

# GPaste clipboard manager daemon
programs.gpaste.enable = true;

# Load sanitized GNOME settings after system activation
system.activationScripts.gnome-settings.text = ''

  # Skip dconf loading during activation - it requires D-Bus session
  # dconf will be loaded via user service on login instead

'';

# User service to load GNOME settings on login
systemd.user.services.gnome-settings-load = {
  description = "Load GNOME settings from nixit";
  serviceConfig = {
    Type = "oneshot";
    ExecStart = "${pkgs.bash}/bin/bash -c '${pkgs.dconf}/bin/dconf load / \u003c ${repoDirectory}/gnome/dconf.ini || true'";
  };
  wantedBy = [ "default.target" ];
};

# Copy user icon to accountsservice location for GDM/GNOME
system.activationScripts.user-icon = ''
  ICON_SRC="${repoDirectory}/assets/icon2.png"
  ICON_DEST="${homeDirectory}/.face"
  ACCOUNT_ICON="/var/lib/AccountsService/icons/${username}"

  if [ -f "$ICON_SRC" ]; then
    # Create face icon in home directory
    ${pkgs.coreutils}/bin/cp "$ICON_SRC" "$ICON_DEST"
    ${pkgs.coreutils}/bin/chown ${username}:users "$ICON_DEST"
    ${pkgs.coreutils}/bin/chmod 644 "$ICON_DEST"

    # Create accountsservice icon for GDM
    ${pkgs.coreutils}/bin/mkdir -p /var/lib/AccountsService/icons
    ${pkgs.coreutils}/bin/cp "$ICON_SRC" "$ACCOUNT_ICON"
    ${pkgs.coreutils}/bin/chmod 644 "$ACCOUNT_ICON"
  fi
'';

##############################################################################
#
# XDG Portal
#
##############################################################################

xdg.portal = {

  enable = true;

  xdgOpenUsePortal = true;

  extraPortals = with pkgs; [

    xdg-desktop-portal-gnome

  ];

};

##############################################################################
#
# Audio
#
##############################################################################

security.rtkit.enable = true;

services.pipewire = {

  enable = true;

  pulse.enable = true;

  alsa.enable = true;

  alsa.support32Bit = true;

  jack.enable = true;

};

##############################################################################
#
# Bluetooth
#
##############################################################################

hardware.bluetooth = {

  enable = true;

  powerOnBoot = true;

};

# Disabled - using GNOME default bluetooth
# services.blueman.enable = true;

##############################################################################
#
# Printing
#
##############################################################################

services.printing.enable = true;

##############################################################################
#
# Network Discovery
#
##############################################################################

services.avahi = {

  enable = true;

  nssmdns4 = true;

  openFirewall = true;

};

# Mullvad-vpn
services.mullvad-vpn.enable = true;
services.mullvad-vpn.package = pkgs.mullvad-vpn;


##############################################################################
#
# Flatpak
#
##############################################################################

# Disabled - not using Flatpak
# services.flatpak.enable = true;

##############################################################################
#
# Firmware Updates
#
##############################################################################

services.fwupd.enable = true;

##############################################################################
#
# Power Management
#
##############################################################################

powerManagement.enable = true;

services.power-profiles-daemon.enable = true;

##############################################################################
#
# User Account
#
##############################################################################

users.users.${username} = {

  isNormalUser = true;

  description = fullName;

  shell = pkgs.bash;

  extraGroups = [

    "wheel"
    "networkmanager"
    "audio"
    "video"
    "kvm"
    "input"
    "uinput"
    "dialout"
    "libvirtd"

  ];

};

##############################################################################
#
# Bash
#
##############################################################################

programs.bash = {

  enable = true;

  completion.enable = true;

};

##############################################################################
#
# Git
#
##############################################################################

programs.git.enable = true;

##############################################################################
#
# OpenSSH
#
# Disabled: Using GNOME's gcr-ssh-agent instead
#
##############################################################################

# programs.ssh.startAgent is disabled - GNOME provides its own SSH agent
# via services.gnome.gcr-ssh-agent.enable which is automatically enabled
# when GNOME desktop is enabled.

##############################################################################
#
# GnuPG
#
##############################################################################

programs.gnupg.agent = {

  enable = true;

  # Note: SSH support disabled - using GNOME gcr-ssh-agent instead
  # enableSSHSupport = true;

};

##############################################################################
#
# Nixvim (Declarative Neovim)
#
# Full-featured IDE-like Neovim based on dc-tec/nixvim.
# Replaces legacy vim/neovim dotfile management.
#
##############################################################################

programs.nixvim = {

  enable = true;

  defaultEditor = true;

  # ── Settings ─────────────────────────────────────────────────────────────

  clipboard = {
    providers.wl-copy.enable = pkgs.stdenv.isLinux;
  };

  opts = {
    number = true;
    relativenumber = true;
    clipboard = "unnamedplus";
    tabstop = 2;
    softtabstop = 2;
    showtabline = 2;
    expandtab = true;
    smartindent = true;
    shiftwidth = 2;
    breakindent = true;
    cursorline = true;
    scrolloff = 8;
    mouse = "a";
    foldmethod = "manual";
    foldenable = false;
    linebreak = true;
    spell = false;
    swapfile = false;
    timeoutlen = 300;
    termguicolors = true;
    showmode = false;
    splitbelow = true;
    splitkeep = "screen";
    splitright = true;
    cmdheight = 0;
    fillchars = {
      eob = " ";
    };
  };

  # ── Keymaps ──────────────────────────────────────────────────────────────

  globals.mapleader = " ";

  keymaps = [
    {
      mode = [ "n" "x" ];
      key = "j";
      action = "v:count == 0 ? 'gj' : 'j'";
      options = { expr = true; silent = true; };
    }
    {
      mode = [ "n" "x" ];
      key = "<Down>";
      action = "v:count == 0 ? 'gj' : 'j'";
      options = { expr = true; silent = true; };
    }
    {
      mode = [ "n" "x" ];
      key = "k";
      action = "v:count == 0 ? 'gk' : 'k'";
      options = { expr = true; silent = true; };
    }
    {
      mode = [ "n" "x" ];
      key = "<Up>";
      action = "v:count == 0 ? 'gk' : 'k'";
      options = { expr = true; silent = true; };
    }
    {
      mode = "n";
      key = "<C-h>";
      action = "<C-w>h";
      options = { desc = "Go to Left Window"; remap = true; };
    }
    {
      mode = "n";
      key = "<C-j>";
      action = "<C-w>j";
      options = { desc = "Go to Lower Window"; remap = true; };
    }
    {
      mode = "n";
      key = "<C-k>";
      action = "<C-w>k";
      options = { desc = "Go to Upper Window"; remap = true; };
    }
    {
      mode = "n";
      key = "<C-l>";
      action = "<C-w>l";
      options = { desc = "Go to Right Window"; remap = true; };
    }
    {
      mode = "n";
      key = "<C-Up>";
      action = "<cmd>resize +2<cr>";
      options = { desc = "Increase Window Height"; };
    }
    {
      mode = "n";
      key = "<C-Down>";
      action = "<cmd>resize -2<cr>";
      options = { desc = "Decrease Window Height"; };
    }
    {
      mode = "n";
      key = "<C-Left>";
      action = "<cmd>vertical resize -2<cr>";
      options = { desc = "Decrease Window Width"; };
    }
    {
      mode = "n";
      key = "<C-Right>";
      action = "<cmd>vertical resize +2<cr>";
      options = { desc = "Increase Window Width"; };
    }
    {
      mode = "n";
      key = "<A-j>";
      action = "<cmd>m .+1<cr>==";
      options = { desc = "Move Down"; };
    }
    {
      mode = "n";
      key = "<A-k>";
      action = "<cmd>m .-2<cr>==";
      options = { desc = "Move Up"; };
    }
    {
      mode = "i";
      key = "<A-j>";
      action = "<esc><cmd>m .+1<cr>==gi";
      options = { desc = "Move Down"; };
    }
    {
      mode = "i";
      key = "<A-k>";
      action = "<esc><cmd>m .-2<cr>==gi";
      options = { desc = "Move Up"; };
    }
    {
      mode = "v";
      key = "<A-j>";
      action = ":m '>+1<cr>gv=gv";
      options = { desc = "Move Down"; };
    }
    {
      mode = "v";
      key = "<A-k>";
      action = ":m '<-2<cr>gv=gv";
      options = { desc = "Move Up"; };
    }
    {
      mode = "i";
      key = ";";
      action = ";<c-g>u";
    }
    {
      mode = "i";
      key = ".";
      action = ".<c-g>u";
    }
    {
      mode = [ "i" "x" "n" "s" ];
      key = "<C-s>";
      action = "<cmd>w<cr><esc>";
      options = { desc = "Save File"; };
    }
    {
      mode = [ "i" "n" ];
      key = "<esc>";
      action = "<cmd>noh<cr><esc>";
      options = { desc = "Escape and Clear hlsearch"; };
    }
    {
      mode = "n";
      key = "<leader>ur";
      action = "<Cmd>nohlsearch<Bar>diffupdate<Bar>normal! <C-L><CR>";
      options = { desc = "Redraw / Clear hlsearch / Diff Update"; };
    }
    {
      mode = "n";
      key = "n";
      action = "'Nn'[v:searchforward].'zv'";
      options = { expr = true; desc = "Next Search Result"; };
    }
    {
      mode = "x";
      key = "n";
      action = "'Nn'[v:searchforward]";
      options = { expr = true; desc = "Next Search Result"; };
    }
    {
      mode = "o";
      key = "n";
      action = "'Nn'[v:searchforward]";
      options = { expr = true; desc = "Next Search Result"; };
    }
    {
      mode = "n";
      key = "N";
      action = "'nN'[v:searchforward].'zv'";
      options = { expr = true; desc = "Prev Search Result"; };
    }
    {
      mode = "x";
      key = "N";
      action = "'nN'[v:searchforward]";
      options = { expr = true; desc = "Prev Search Result"; };
    }
    {
      mode = "o";
      key = "N";
      action = "'nN'[v:searchforward]";
      options = { expr = true; desc = "Prev Search Result"; };
    }
    {
      mode = "n";
      key = "<leader>cd";
      action = "vim.diagnostic.open_float";
      options = { desc = "Line Diagnostics"; };
    }
    {
      mode = "n";
      key = "]d";
      action = "diagnostic_goto(true)";
      options = { desc = "Next Diagnostic"; };
    }
    {
      mode = "n";
      key = "[d";
      action = "diagnostic_goto(false)";
      options = { desc = "Prev Diagnostic"; };
    }
    {
      mode = "n";
      key = "]e";
      action = "diagnostic_goto(true 'ERROR')";
      options = { desc = "Next Error"; };
    }
    {
      mode = "n";
      key = "[e";
      action = "diagnostic_goto(false 'ERROR')";
      options = { desc = "Prev Error"; };
    }
    {
      mode = "n";
      key = "]w";
      action = "diagnostic_goto(true 'WARN')";
      options = { desc = "Next Warning"; };
    }
    {
      mode = "n";
      key = "[w";
      action = "diagnostic_goto(false 'WARN')";
      options = { desc = "Prev Warning"; };
    }
    {
      mode = "n";
      key = "<leader>qq";
      action = "<cmd>qa<cr>";
      options = { desc = "Quit All"; };
    }
    {
      mode = "n";
      key = "<leader>ui";
      action = "vim.show_pos";
      options = { desc = "Inspect Pos"; };
    }
    {
      mode = "t";
      key = "<esc><esc>";
      action = "<c-\\><c-n>";
      options = { desc = "Enter Normal Mode"; };
    }
    {
      mode = "t";
      key = "<C-h>";
      action = "<cmd>wincmd h<cr>";
      options = { desc = "Go to Left Window"; };
    }
    {
      mode = "t";
      key = "<C-j>";
      action = "<cmd>wincmd j<cr>";
      options = { desc = "Go to Lower Window"; };
    }
    {
      mode = "t";
      key = "<C-k>";
      action = "<cmd>wincmd k<cr>";
      options = { desc = "Go to Upper Window"; };
    }
    {
      mode = "t";
      key = "<C-l>";
      action = "<cmd>wincmd l<cr>";
      options = { desc = "Go to Right Window"; };
    }
    {
      mode = "t";
      key = "<C-/>";
      action = "<cmd>close<cr>";
      options = { desc = "Hide Terminal"; };
    }
    {
      mode = "n";
      key = "<leader>ww";
      action = "<C-W>p";
      options = { desc = "Other Window"; remap = true; };
    }
    {
      mode = "n";
      key = "<leader>wd";
      action = "<C-W>c";
      options = { desc = "Delete Window"; remap = true; };
    }
    {
      mode = "n";
      key = "<leader>w-";
      action = "<C-W>s";
      options = { desc = "Split Window Below"; remap = true; };
    }
    {
      mode = "n";
      key = "<leader>w|";
      action = "<C-W>v";
      options = { desc = "Split Window Right"; remap = true; };
    }
    {
      mode = "n";
      key = "<leader>-";
      action = "<C-W>s";
      options = { desc = "Split Window Below"; remap = true; };
    }
    {
      mode = "n";
      key = "<leader>|";
      action = "<C-W>v";
      options = { desc = "Split Window Right"; remap = true; };
    }
    {
      mode = "n";
      key = "<leader><tab>l";
      action = "<cmd>tablast<cr>";
      options = { desc = "Last Tab"; };
    }
    {
      mode = "n";
      key = "<leader><tab>f";
      action = "<cmd>tabfirst<cr>";
      options = { desc = "First Tab"; };
    }
    {
      mode = "n";
      key = "<leader><tab><tab>";
      action = "<cmd>tabnew<cr>";
      options = { desc = "New Tab"; };
    }
    {
      mode = "n";
      key = "<leader><tab>]";
      action = "<cmd>tabnext<cr>";
      options = { desc = "Next Tab"; };
    }
    {
      mode = "n";
      key = "<leader><tab>d";
      action = "<cmd>tabclose<cr>";
      options = { desc = "Close Tab"; };
    }
    {
      mode = "n";
      key = "<leader><tab>[";
      action = "<cmd>tabprevious<cr>";
      options = { desc = "Previous Tab"; };
    }

    # ── Neo-tree keymap ──
    {
      mode = [ "n" ];
      key = "<leader>e";
      action = "<cmd>Neotree toggle<cr>";
      options = { desc = "Open/Close Neotree"; };
    }

    # ── Undotree keymap ──
    {
      mode = "n";
      key = "<leader>ut";
      action = "<cmd>UndotreeToggle<CR>";
      options = { silent = true; desc = "Undotree"; };
    }

    # ── LazyGit keymap ──
    {
      mode = "n";
      key = "<leader>gg";
      action = "<cmd>LazyGit<CR>";
      options = { desc = "LazyGit (root dir)"; };
    }

    # ── Bufferline keymaps ──
    {
      mode = "n";
      key = "]b";
      action = "<cmd>BufferLineCycleNext<cr>";
      options = { desc = "Cycle to next buffer"; };
    }
    {
      mode = "n";
      key = "[b";
      action = "<cmd>BufferLineCyclePrev<cr>";
      options = { desc = "Cycle to previous buffer"; };
    }
    {
      mode = "n";
      key = "<S-l>";
      action = "<cmd>BufferLineCycleNext<cr>";
      options = { desc = "Cycle to next buffer"; };
    }
    {
      mode = "n";
      key = "<S-h>";
      action = "<cmd>BufferLineCyclePrev<cr>";
      options = { desc = "Cycle to previous buffer"; };
    }
    {
      mode = "n";
      key = "<leader>bd";
      action = "<cmd>bdelete<cr>";
      options = { desc = "Delete buffer"; };
    }
    {
      mode = "n";
      key = "<leader>bl";
      action = "<cmd>BufferLineCloseLeft<cr>";
      options = { desc = "Delete buffers to the left"; };
    }
    {
      mode = "n";
      key = "<leader>bo";
      action = "<cmd>BufferLineCloseOthers<cr>";
      options = { desc = "Delete other buffers"; };
    }
    {
      mode = "n";
      key = "<leader>bp";
      action = "<cmd>BufferLineTogglePin<cr>";
      options = { desc = "Toggle pin"; };
    }
    {
      mode = "n";
      key = "<leader>bP";
      action = "<Cmd>BufferLineGroupClose ungrouped<CR>";
      options = { desc = "Delete non-pinned buffers"; };
    }

    # ── Markdown Preview keymap ──
    {
      mode = "n";
      key = "<leader>mp";
      action = "<cmd>MarkdownPreview<cr>";
      options = { desc = "Toggle Markdown Preview"; };
    }

    # ── Telescope keymaps ──
    {
      mode = "n";
      key = "<leader>sd";
      action = "<cmd>Telescope diagnostics bufnr=0<cr>";
      options = { desc = "Document diagnostics"; };
    }
    {
      mode = "n";
      key = "<leader>fe";
      action = "<cmd>Telescope file_browser<cr>";
      options = { desc = "File browser"; };
    }
    {
      mode = "n";
      key = "<leader>fE";
      action = "<cmd>Telescope file_browser path=%:p:h select_buffer=true<cr>";
      options = { desc = "File browser"; };
    }

    # ── ToggleTerm keymaps ──
    {
      mode = "n";
      key = "<leader>t";
      action = "<cmd>ToggleTerm<cr>";
      options = { desc = "Toggle Scratch Terminal"; };
    }
    {
      mode = "t";
      key = "<Esc><Esc>";
      action = "<C-\\><C-n>";
      options = { desc = "Exit Terminal Mode"; };
    }
  ];

  # ── Auto Commands ────────────────────────────────────────────────────────

  autoGroups = {
    highlight_yank = { };
    vim_enter = { };
    indentscope = { };
    restore_cursor = { };
    filetypes = { };
  };

  autoCmd = [
    {
      group = "highlight_yank";
      event = [ "TextYankPost" ];
      pattern = "*";
      callback = {
        __raw = ''
          function()
            vim.highlight.on_yank()
          end
        '';
      };
    }
    {
      group = "vim_enter";
      event = [ "VimEnter" ];
      pattern = "*";
      callback = {
        __raw = ''
          function()
            vim.cmd('Startup')
          end
        '';
      };
    }
    {
      group = "indentscope";
      event = [ "FileType" ];
      pattern = [
        "help"
        "Startup"
        "startup"
        "neo-tree"
        "Trouble"
        "trouble"
        "notify"
      ];
      callback = {
        __raw = ''
          function()
            vim.b.miniindentscope_disable = true
          end
        '';
      };
    }
    {
      group = "restore_cursor";
      event = [ "BufReadPost" ];
      pattern = "*";
      callback = {
        __raw = ''
          function()
            if
              vim.fn.line "'\"" > 1
              and vim.fn.line "'\"" <= vim.fn.line "$"
              and vim.bo.filetype ~= "commit"
              and vim.fn.index({ "xxd", "gitrebase" }, vim.bo.filetype) == -1
            then
              vim.cmd "normal! g`\""
            end
          end
        '';
      };
    }
  ];

  # ── File Types ───────────────────────────────────────────────────────────

  files."ftdetect/terraformft.lua".autoCmd = [
    {
      group = "filetypes";
      event = [ "BufRead" "BufNewFile" ];
      pattern = [ "*.tf" "*.tfvars" "*.hcl" ];
      command = "set ft=terraform";
    }
  ];

  files."ftdetect/bicepft.lua".autoCmd = [
    {
      group = "filetypes";
      event = [ "BufRead" "BufNewFile" ];
      pattern = [ "*.bicep" "*.bicepparam" ];
      command = "set ft=bicep";
    }
  ];

  # ── Theme (Catppuccin Macchiato) ─────────────────────────────────────────

  colorschemes = {
    catppuccin = {
      enable = true;
      settings = {
        background = {
          light = "macchiato";
          dark = "mocha";
        };
        custom_highlights = ''
          function(highlights)
            return {
            CursorLineNr = { fg = highlights.peach, style = {} },
            NavicText = { fg = highlights.text },
            }
          end
        '';
        flavour = "macchiato";
        no_bold = false;
        no_italic = false;
        no_underline = false;
        transparent_background = true;
        integrations = {
          cmp = true;
          notify = true;
          gitsigns = true;
          neotree = true;
          which_key = true;
          illuminate = {
            enabled = true;
            lsp = true;
          };
          navic = {
            enabled = true;
            custom_bg = "NONE";
          };
          treesitter = true;
          telescope.enabled = true;
          indent_blankline.enabled = true;
          mini = {
            enabled = true;
            indentscope_color = "rosewater";
          };
          native_lsp = {
            enabled = true;
            inlay_hints = {
              background = true;
            };
            virtual_text = {
              errors = [ "italic" ];
              hints = [ "italic" ];
              information = [ "italic" ];
              warnings = [ "italic" ];
              ok = [ "italic" ];
            };
            underlines = {
              errors = [ "underline" ];
              hints = [ "underline" ];
              information = [ "underline" ];
              warnings = [ "underline" ];
            };
          };
        };
      };
    };
  };

  # ── Completion (nvim-cmp) ────────────────────────────────────────────────

  plugins.cmp = {
    enable = true;
    settings = {
      autoEnableSources = true;
      experimental = {
        ghost_text = false;
      };
      performance = {
        debounce = 60;
        fetchingTimeout = 200;
        maxViewEntries = 30;
      };
      snippet = {
        expand = "luasnip";
      };
      formatting = {
        fields = [ "kind" "abbr" "menu" ];
      };
      sources = [
        { name = "git"; }
        { name = "nvim_lsp"; }
        {
          name = "buffer";
          option.get_bufnrs.__raw = "vim.api.nvim_list_bufs";
          keywordLength = 3;
        }
        {
          name = "path";
          keywordLength = 3;
        }
        {
          name = "luasnip";
          keywordLength = 3;
        }
      ];
      window = {
        completion = {
          border = "solid";
        };
        documentation = {
          border = "solid";
        };
      };
      mapping = {
        "<C-Tab>" = "cmp.mapping(cmp.mapping.select_next_item(), {'i', 's'})";
        "<C-j>" = "cmp.mapping.select_next_item()";
        "<C-k>" = "cmp.mapping.select_prev_item()";
        "<C-e>" = "cmp.mapping.abort()";
        "<C-b>" = "cmp.mapping.scroll_docs(-4)";
        "<C-f>" = "cmp.mapping.scroll_docs(4)";
        "<C-Space>" = "cmp.mapping.complete()";
        "<C-CR>" = "cmp.mapping.confirm({ select = true })";
        "<S-CR>" = "cmp.mapping.confirm({ behavior = cmp.ConfirmBehavior.Replace, select = true })";
      };
    };
  };

  plugins.cmp-nvim-lsp.enable = true;
  plugins.cmp-buffer.enable = true;
  plugins.cmp-path.enable = true;
  plugins.cmp_luasnip.enable = true;
  plugins.cmp-cmdline.enable = false;

  plugins.lspkind = {
    enable = true;
    settings = {
      maxwidth = 50;
      ellipsis_char = "...";
    };
  };

  plugins.nvim-autopairs = {
    enable = true;
    settings = {
      disable_filetype = [
        "TelescopePrompt"
        "vim"
      ];
    };
  };

  plugins.schemastore = {
    enable = true;
    json = { enable = true; };
    yaml = { enable = true; };
  };

  # ── Snippets ───────────────────────────────────────────────────────────

  plugins.luasnip = {
    enable = true;
    settings = {
      enable_autosnippets = true;
      store_selection_keys = "<Tab>";
    };
  };

  # ── Editor Plugins ───────────────────────────────────────────────────────

  plugins.illuminate = {
    enable = true;
    settings = {
      under_cursor = false;
      filetypes_denylist = [
        "Outline"
        "TelescopePrompt"
        "alpha"
        "harpoon"
        "reason"
      ];
    };
  };

  plugins.indent-blankline = {
    enable = true;
  };

  plugins.navic = {
    enable = true;
    settings = {
      separator = "  ";
      highlight = true;
      depthLimit = 5;
      lsp = {
        autoAttach = true;
      };
      icons = {
        Array = "󱃵  ";
        Boolean = "  ";
        Class = "  ";
        Constant = "  ";
        Constructor = "  ";
        Enum = " ";
        EnumMember = " ";
        Event = " ";
        Field = "󰽏 ";
        File = " ";
        Function = "󰡱 ";
        Interface = " ";
        Key = "  ";
        Method = " ";
        Module = "󰕳 ";
        Namespace = " ";
        Null = "󰟢 ";
        Number = " ";
        Object = "  ";
        Operator = " ";
        Package = "󰏖 ";
        String = " ";
        Struct = " ";
        TypeParameter = " ";
        Variable = " ";
      };
    };
  };

  plugins.neo-tree = {
    enable = true;
    settings = {
      sources = [
        "filesystem"
        "buffers"
        "git_status"
        "document_symbols"
      ];
      add_blank_line_at_top = false;
      filesystem = {
        bind_to_cwd = false;
        follow_current_file = {
          enabled = true;
        };
      };
      default_component_configs = {
        indent = {
          with_expanders = true;
          expander_collapsed = "󰅂";
          expander_expanded = "󰅀";
          expander_highlight = "NeoTreeExpander";
        };
        git_status = {
          symbols = {
            added = " ";
            conflict = "󰩌 ";
            deleted = "󱂥";
            ignored = " ";
            modified = " ";
            renamed = "󰑕";
            staged = "󰩍";
            unstaged = "";
            untracked = " ";
          };
        };
      };
    };
  };

  plugins.todo-comments = {
    enable = true;
    settings = {
      colors = {
        error = [ "DiagnosticError" "ErrorMsg" "#ED8796" ];
        warning = [ "DiagnosticWarn" "WarningMsg" "#EED49F" ];
        info = [ "DiagnosticInfo" "#EED49F" ];
        default = [ "Identifier" "#F5A97F" ];
        test = [ "Identifier" "#8AADF4" ];
      };
    };
  };

  plugins.treesitter = {
    enable = true;
    settings = {
      indent.enable = true;
      highlight = {
        enable = true;
        disable = [ "nix" ];
      };
    };
    folding.enable = false;
    nixvimInjections = true;
    grammarPackages = with pkgs.vimPlugins.nvim-treesitter.builtGrammars; [
      bash
      bicep
      css
      diff
      dockerfile
      git_config
      git_rebase
      gitattributes
      gitcommit
      gitignore
      go
      gomod
      gosum
      gotmpl
      gowork
      hcl
      helm
      html
      javascript
      json
      lua
      make
      markdown
      markdown_inline
      nix
      python
      regex
      sql
      terraform
      toml
      tsx
      typescript
      vim
      vimdoc
      yaml
    ];
  };

  plugins.treesitter-textobjects = {
    enable = false;
    settings = {
      select = {
        enable = true;
        lookahead = true;
        keymaps = {
          "aa" = "@parameter.outer";
          "ia" = "@parameter.inner";
          "af" = "@function.outer";
          "if" = "@function.inner";
          "ac" = "@class.outer";
          "ic" = "@class.inner";
          "ii" = "@conditional.inner";
          "ai" = "@conditional.outer";
          "il" = "@loop.inner";
          "al" = "@loop.outer";
          "at" = "@comment.outer";
        };
      };
      move = {
        enable = true;
        goto_next_start = {
          "]m" = "@function.outer";
          "]]" = "@class.outer";
        };
        goto_next_end = {
          "]M" = "@function.outer";
          "][" = "@class.outer";
        };
        goto_previous_start = {
          "[m" = "@function.outer";
          "[[" = "@class.outer";
        };
        goto_previous_end = {
          "[M" = "@function.outer";
          "[]" = "@class.outer";
        };
      };
      swap = {
        enable = true;
        swap_next = {
          "<leader>a" = "@parameters.inner";
        };
        swap_previous = {
          "<leader>A" = "@parameter.outer";
        };
      };
    };
  };

  plugins.undotree = {
    enable = true;
    settings = {
      autoOpenDiff = true;
      focusOnToggle = true;
    };
  };

  # ── UI Plugins ─────────────────────────────────────────────────────────

  plugins.bufferline = {
    enable = true;
    settings = {
      options = {
        diagnostics = "nvim_lsp";
        mode = "buffers";
        close_icon = " ";
        buffer_close_icon = "󰱝 ";
        modified_icon = "󰔯 ";
        offsets = [
          {
            filetype = "neo-tree";
            text = "Neo-tree";
            highlight = "Directory";
            text_align = "left";
          }
        ];
      };
    };
  };

  plugins.lualine = {
    enable = true;
    settings = {
      options = {
        globalstatus = true;
        extensions = [ "fzf" "neo-tree" ];
        disabledFiletypes = {
          statusline = [ "startup" "alpha" ];
        };
        theme = "catppuccin";
      };
      sections = {
        lualine_a = [ { __unkeyed-1 = "mode"; icon = ""; } ];
        lualine_b = [
          { __unkeyed-1 = "branch"; icon = ""; }
          {
            __unkeyed-1 = "diff";
            symbols = {
              added = " ";
              modified = " ";
              removed = " ";
            };
          }
        ];
        lualine_c = [
          {
            __unkeyed-1 = "diagnostics";
            sources = [ "nvim_lsp" ];
            symbols = {
              error = " ";
              warn = " ";
              info = " ";
              hint = "󰝶 ";
            };
          }
          { __unkeyed-1 = "navic"; }
        ];
        lualine_x = [
          { __unkeyed-1 = "filetype"; icon_only = true; separator = ""; padding = { left = 1; right = 0; }; }
          { __unkeyed-1 = "filename"; path = 1; }
        ];
        lualine_y = [ { __unkeyed-1 = "progress"; } ];
        lualine_z = [ { __unkeyed-1 = "location"; } ];
      };
    };
  };

  plugins.startup = {
    enable = true;
    settings = {
      colors = {
        background = "#ffffff";
        folded_section = "#ffffff";
      };
      header = {
        type = "text";
        oldfiles_directory = false;
        align = "center";
        fold_section = false;
        title = "Header";
        margin = 5;
        content = [
          " ██████╗░███████╗░█████╗░░█████╗░██████╗░████████╗░░░████████╗███████╗░█████╗░██╗░░██╗"
          " ██╔══██╗██╔════╝██╔══██╗██╔══██╗██╔══██╗╚══██╔══╝░░░╚══██╔══╝██╔════╝██╔══██╗██║░░██║"
          " ██║░░██║█████╗░░██║░░╚═╝██║░░██║██████╔╝░░░██║░░░░░░░░░██║░░░█████╗░░██║░░╚═╝███████║"
          " ██║░░██║██╔══╝░░██║░░██╗██║░░██║██╔══██╗░░░██║░░░░░░░░░██║░░░██╔══╝░░██║░░██╗██╔══██║"
          " ██████╔╝███████╗╚█████╔╝╚█████╔╝██║░░██║░░░██║░░░██╗░░░██║░░░███████╗╚█████╔╝██║░░██║"
          " ╚═════╝░╚══════╝░╚════╝░░╚════╝░╚═╝░░╚═╝░░░╚═╝░░░╚═╝░░░╚═╝░░░╚══════╝░╚════╝░╚═╝░░╚═╝"
        ];
        highlight = "Statement";
        default_color = "";
        oldfiles_amount = 0;
      };
      body = {
        type = "mapping";
        oldfiles_directory = false;
        align = "center";
        fold_section = false;
        title = "Menu";
        margin = 5;
        content = [
          [ " Find File" "Telescope find_files" "ff" ]
          [ "󰍉 Find Word" "Telescope live_grep" "fr" ]
          [ " Recent Files" "Telescope oldfiles" "fg" ]
          [ " File Browser" "Telescope file_browser" "fe" ]
          [ "󰧑 SecondBrain" "edit ~/projects/personal/SecondBrain" "sb" ]
        ];
        highlight = "string";
        default_color = "";
        oldfiles_amount = 0;
      };
      options = {
        paddings = [ 1 3 ];
      };
      parts = [ "header" "body" ];
    };
  };

  # ── LSP ──────────────────────────────────────────────────────────────────

  plugins.lsp-lines.enable = true;
  plugins.helm.enable = true;

  plugins.lsp = {
    enable = true;
    inlayHints = true;
    servers = {
      html = { enable = true; };
      lua_ls = { enable = true; };
      nil_ls = { enable = true; };
      ts_ls = { enable = true; };
      marksman = { enable = true; };
      pyright = { enable = true; };
      gopls = { enable = true; };
      terraformls = { enable = true; };
      jsonls = { enable = true; };
      helm_ls = {
        enable = true;
        extraOptions = {
          settings = {
            "helm_ls" = {
              yamlls = {
                path = "${pkgs.yaml-language-server}/bin/yaml-language-server";
              };
            };
          };
        };
      };
      yamlls = {
        enable = true;
        extraOptions = {
          settings = {
            yaml = {
              schemas = {
                kubernetes = "*.yaml";
                "https://json.schemastore.org/github-workflow" = ".github/workflows/*";
                "https://json.schemastore.org/github-action" = ".github/action.{yml,yaml}";
                "https://json.schemastore.org/ansible-stable-2.9" = "roles/tasks/*.{yml,yaml}";
                "https://json.schemastore.org/kustomization" = "kustomization.{yml,yaml}";
                "https://json.schemastore.org/ansible-playbook" = "*play*.{yml,yaml}";
                "https://json.schemastore.org/chart" = "Chart.{yml,yaml}";
                "https://json.schemastore.org/dependabot-v2" = ".github/dependabot.{yml,yaml}";
                "https://raw.githubusercontent.com/compose-spec/compose-spec/master/schema/compose-spec.json" = "*docker-compose*.{yml,yaml}";
                "https://raw.githubusercontent.com/argoproj/argo-workflows/master/api/jsonschema/schema.json" = "*flow*.{yml,yaml}";
              };
            };
          };
        };
      };
    };
    keymaps = {
      silent = true;
      lspBuf = {
        gd = { action = "definition"; desc = "Goto Definition"; };
        gr = { action = "references"; desc = "Goto References"; };
        gD = { action = "declaration"; desc = "Goto Declaration"; };
        gI = { action = "implementation"; desc = "Goto Implementation"; };
        gT = { action = "type_definition"; desc = "Type Definition"; };
        K = { action = "hover"; desc = "Hover"; };
        "<leader>cw" = { action = "workspace_symbol"; desc = "Workspace Symbol"; };
        "<leader>cr" = { action = "rename"; desc = "Rename"; };
      };
    };
  };

  plugins.fidget = {
    enable = true;
    settings = {
      logger = {
        level = "warn";
        float_precision = 1.0e-2;
      };
      progress = {
        poll_rate = 0;
        suppress_on_insert = true;
        ignore_done_already = false;
        ignore_empty_message = false;
        clear_on_detach = ''
          function(client_id)
            local client = vim.lsp.get_client_by_id(client_id)
            return client and client.name or nil
          end
        '';
        notification_group = ''
          function(msg) return msg.lsp_client.name end
        '';
        ignore = [ ];
        lsp = {
          progress_ringbuf_size = 0;
        };
        display = {
          render_limit = 16;
          done_ttl = 3;
          done_icon = "✔";
          done_style = "Constant";
          progress_ttl = 10;
          progress_icon = {
            pattern = "dots";
            period = 1;
          };
          progress_style = "WarningMsg";
          group_style = "Title";
          icon_style = "Question";
          priority = 30;
          skip_history = true;
          format_message = ''
            require ("fidget.progress.display").default_format_message
          '';
          format_annote = ''
            function (msg) return msg.title end
          '';
          format_group_name = ''
            function (group) return tostring (group) end
          '';
          overrides = {
            rust_analyzer = {
              name = "rust-analyzer";
            };
          };
        };
      };
      notification = {
        poll_rate = 10;
        filter = "info";
        history_size = 128;
        override_vim_notify = true;
        redirect = {
          __raw = ''
            function(msg, level, opts)
              if opts and opts.on_open then
                return require("fidget.integration.nvim-notify").delegate(msg, level, opts)
              end
            end
          '';
        };
        configs = {
          default = {
            name = "Notifications";
            icon = "󰏪";
            group = "Notifications";
            annote = true;
            debug = false;
            debug_rate = 0.25;
          };
        };
        window = {
          normal_hl = "Comment";
          winblend = 0;
          border = "none";
          zindex = 45;
          max_width = 0;
          max_height = 0;
          x_padding = 1;
          y_padding = 0;
          align = "bottom";
          relative = "editor";
        };
        view = {
          stack_upwards = true;
          icon_separator = " ";
          group_separator = "---";
          group_separator_hl = "Comment";
        };
      };
    };
  };

  plugins.conform-nvim = {
    enable = true;
    settings = {
      format_on_save = ''
        function(bufnr)
          if vim.g.disable_autoformat or vim.b[bufnr].disable_autoformat then
            return
          end
          if slow_format_filetypes[vim.bo[bufnr].filetype] then
            return
          end
          local function on_format(err)
            if err and err:match("timeout$") then
              slow_format_filetypes[vim.bo[bufnr].filetype] = true
            end
          end
          return { timeout_ms = 200, lsp_fallback = true }, on_format
         end
      '';
      format_after_save = ''
        function(bufnr)
          if vim.g.disable_autoformat or vim.b[bufnr].disable_autoformat then
            return
          end
          if not slow_format_filetypes[vim.bo[bufnr].filetype] then
            return
          end
          return { lsp_fallback = true }
        end
      '';
      notify_on_error = true;
      formatters_by_ft = {
        html = [ "prettier" ];
        css = [ "prettier" ];
        javascript = [ "prettier" ];
        typescript = [ "prettier" ];
        python = [ "black" "isort" ];
        lua = [ "stylua" ];
        nix = [ "nixfmt" ];
        markdown = [ "prettier" ];
        yaml = [ "prettier" ];
        terraform = [ "terraform_fmt" ];
        bicep = [ "bicep" ];
        bash = [ "shellcheck" "shellharden" "shfmt" ];
        json = [ "jq" ];
        "_" = [ "trim_whitespace" ];
      };
      formatters = {
        black = { command = "${lib.getExe pkgs.black}"; };
        isort = { command = "${lib.getExe pkgs.isort}"; };
        nixfmt = { command = "${lib.getExe pkgs.nixfmt}"; };
        alejandra = { command = "${lib.getExe pkgs.alejandra}"; };
        jq = { command = "${lib.getExe pkgs.jq}"; };
        prettier = { command = "${lib.getExe pkgs.prettier}"; };
        stylua = { command = "${lib.getExe pkgs.stylua}"; };
        shellcheck = { command = "${lib.getExe pkgs.shellcheck}"; };
        shfmt = { command = "${lib.getExe pkgs.shfmt}"; };
        shellharden = { command = "${lib.getExe pkgs.shellharden}"; };
        bicep = { command = "${lib.getExe pkgs.bicep}"; };
      };
    };
  };

  # ── Git ──────────────────────────────────────────────────────────────────

  plugins.gitsigns = {
    enable = true;
    settings = {
      signs = {
        add = { text = " "; };
        change = { text = " "; };
        delete = { text = " "; };
        untracked = { text = ""; };
        topdelete = { text = "󱂥 "; };
        changedelete = { text = "󱂧 "; };
      };
    };
  };

  extraPlugins = with pkgs.vimPlugins; [
    lazygit-nvim
    ansible-vim
  ];

  # ── Telescope ────────────────────────────────────────────────────────────

  plugins.telescope = {
    enable = true;
    extensions = {
      file-browser = { enable = true; };
      fzf-native = { enable = true; };
    };
    settings = {
      defaults = {
        layout_config = {
          horizontal = {
            prompt_position = "top";
          };
        };
        sorting_strategy = "ascending";
      };
    };
    keymaps = {
      "<leader><space>" = { action = "find_files"; options = { desc = "Find project files"; }; };
      "<leader>/" = { action = "live_grep"; options = { desc = "Grep (root dir)"; }; };
      "<leader>:" = { action = "command_history"; options = { desc = "Command History"; }; };
      "<leader>b" = { action = "buffers"; options = { desc = "+buffer"; }; };
      "<leader>ff" = { action = "find_files"; options = { desc = "Find project files"; }; };
      "<leader>fr" = { action = "live_grep"; options = { desc = "Find text"; }; };
      "<leader>fR" = { action = "resume"; options = { desc = "Resume"; }; };
      "<leader>fg" = { action = "oldfiles"; options = { desc = "Recent"; }; };
      "<leader>fb" = { action = "buffers"; options = { desc = "Buffers"; }; };
      "<C-p>" = { action = "git_files"; options = { desc = "Search git files"; }; };
      "<leader>gc" = { action = "git_commits"; options = { desc = "Commits"; }; };
      "<leader>gs" = { action = "git_status"; options = { desc = "Status"; }; };
      "<leader>sa" = { action = "autocommands"; options = { desc = "Auto Commands"; }; };
      "<leader>sb" = { action = "current_buffer_fuzzy_find"; options = { desc = "Buffer"; }; };
      "<leader>sc" = { action = "command_history"; options = { desc = "Command History"; }; };
      "<leader>sC" = { action = "commands"; options = { desc = "Commands"; }; };
      "<leader>sD" = { action = "diagnostics"; options = { desc = "Workspace diagnostics"; }; };
      "<leader>sh" = { action = "help_tags"; options = { desc = "Help pages"; }; };
      "<leader>sH" = { action = "highlights"; options = { desc = "Search Highlight Groups"; }; };
      "<leader>sk" = { action = "keymaps"; options = { desc = "Keymaps"; }; };
      "<leader>sM" = { action = "man_pages"; options = { desc = "Man pages"; }; };
      "<leader>sm" = { action = "marks"; options = { desc = "Jump to Mark"; }; };
      "<leader>so" = { action = "vim_options"; options = { desc = "Options"; }; };
      "<leader>sR" = { action = "resume"; options = { desc = "Resume"; }; };
      "<leader>uC" = { action = "colorscheme"; options = { desc = "Colorscheme preview"; }; };
    };
  };

  plugins.web-devicons = {
    enable = true;
  };

  # ── Utilities ────────────────────────────────────────────────────────────

  plugins.which-key = {
    enable = true;
  };

  plugins.mini = {
    enable = true;
    modules = {
      indentscope = {
        symbol = "│";
        options = {
          try_as_border = true;
        };
      };
      surround = { };
    };
  };

  plugins.markdown-preview = {
    enable = true;
    settings = {
      browser = "firefox";
      echo_preview_url = 1;
      port = "6969";
      preview_options = {
        disable_filename = 1;
        disable_sync_scroll = 1;
        sync_scroll_type = "middle";
      };
      theme = "dark";
    };
  };

  plugins.obsidian = {
    enable = false;
    settings = {
      workspaces = [
        {
          name = "SecondBrain";
          path = "~/projects/personal/SecondBrain";
        }
      ];
      templates = {
        subdir = "templates";
        dateFormat = "%Y-%m-%d";
        timeFormat = "%H:%M";
        substitutions = { };
      };
      dailyNotes = {
        folder = "0_Daily_Notes";
        dateFormat = "%Y-%m-%d";
        aliasFormat = "%B %-d, %Y";
      };
    };
  };

  plugins.toggleterm = {
    enable = true;
    settings = {
      direction = "float";
      float_opts = {
        border = "curved";
      };
    };
  };

  # ── Lua Configuration ─────────────────────────────────────────────────────

  extraConfigLua = ''
    luasnip = require("luasnip")
    kind_icons = {
      Text = "󰊄",
      Method = " ",
      Function = "󰡱 ",
      Constructor = " ",
      Field = " ",
      Variable = "󱀍 ",
      Class = " ",
      Interface = " ",
      Module = "󰕳 ",
      Property = " ",
      Unit = " ",
      Value = " ",
      Enum = " ",
      Keyword = " ",
      Snippet = " ",
      Color = " ",
      File = "",
      Reference = " ",
      Folder = " ",
      EnumMember = " ",
      Constant = " ",
      Struct = " ",
      Event = " ",
      Operator = " ",
      TypeParameter = " ",
    }

    local cmp = require'cmp'

    -- Use buffer source for `/`
    cmp.setup.cmdline({'/', "?" }, {
      sources = {
        { name = 'buffer' }
      }
    })

    -- Set configuration for specific filetype.
    cmp.setup.filetype('gitcommit', {
      sources = cmp.config.sources({
        { name = 'cmp_git' },
      }, {
        { name = 'buffer' },
      })
    })

    -- Use cmdline & path source for ':'
    cmp.setup.cmdline(':', {
      sources = cmp.config.sources({
        { name = 'path' }
      }, {
        { name = 'cmdline' }
      }),
    })

    require("telescope").setup{
      pickers = {
        colorscheme = {
          enable_preview = true
        }
      }
    }

    local _border = "rounded"

    -- Language servers can emit large volumes of routine stderr output.
    vim.lsp.log.set_level(vim.log.levels.OFF)

    vim.lsp.handlers["textDocument/hover"] = function(err, result, ctx, config)
      config = config or {}
      config.border = _border
      return vim.lsp.handlers.hover(err, result, ctx, config)
    end

    vim.lsp.handlers["textDocument/signatureHelp"] = function(err, result, ctx, config)
      config = config or {}
      config.border = _border
      return vim.lsp.handlers.signature_help(err, result, ctx, config)
    end

    vim.diagnostic.config{
      float={border=_border}
    };

    require('lspconfig.ui.windows').default_options = {
      border = _border
    }

    require("telescope").load_extension("lazygit")

    -- Workaround for treesitter #is-not? predicate missing in some parsers (nix)
    vim.treesitter.query.add_predicate("is-not?", function()
      return true
    end, { force = true, all = false })
  '';

  extraConfigLuaPre = ''
    vim.fn.sign_define("diagnosticsignerror", { text = " ", texthl = "diagnosticerror", linehl = "", numhl = "" })
    vim.fn.sign_define("diagnosticsignwarn", { text = " ", texthl = "diagnosticwarn", linehl = "", numhl = "" })
    vim.fn.sign_define("diagnosticsignhint", { text = "󰌵", texthl = "diagnostichint", linehl = "", numhl = "" })
    vim.fn.sign_define("diagnosticsigninfo", { text = " ", texthl = "diagnosticinfo", linehl = "", numhl = "" })

    local slow_format_filetypes = {}

    vim.api.nvim_create_user_command("FormatDisable", function(args)
       if args.bang then
        vim.b.disable_autoformat = true
      else
        vim.g.disable_autoformat = true
      end
    end, {
      desc = "Disable autoformat-on-save",
      bang = true,
    })
    vim.api.nvim_create_user_command("FormatEnable", function()
      vim.b.disable_autoformat = false
      vim.g.disable_autoformat = false
    end, {
      desc = "Re-enable autoformat-on-save",
    })
    vim.api.nvim_create_user_command("FormatToggle", function(args)
      if args.bang then
        vim.b.disable_autoformat = not vim.b.disable_autoformat
      else
        vim.g.disable_autoformat = not vim.g.disable_autoformat
      end
    end, {
      desc = "Toggle autoformat-on-save",
      bang = true,
    })
  '';

};

##############################################################################
#
# Dotfile Deployment & Asset Symlinks
#
##############################################################################

system.activationScripts.dotfiles.text = ''

  DOTFILES="${dotfilesDirectory}"
  REPO="${repoDirectory}"
  HOME="${homeDirectory}"
  USER="${username}"

  # Create necessary directories
  mkdir -p "$HOME/.config"
  mkdir -p "$HOME/.config/kitty"
  mkdir -p "$HOME/.config/kanata"
  mkdir -p "$HOME/Pictures"
  mkdir -p "$HOME/.ssh/controlmasters" && chmod 700 "$HOME/.ssh/controlmasters"

  # Bash configuration
  ln -sfn "$DOTFILES/bash/.bashrc"              "$HOME/.bashrc"
  ${pkgs.coreutils}/bin/chown -h "$USER:wheel" "$HOME/.bashrc"
  ln -sfn "$DOTFILES/bash/.bash_aliases"        "$HOME/.bash_aliases"
  ${pkgs.coreutils}/bin/chown -h "$USER:wheel" "$HOME/.bash_aliases"

  # Git configuration
  ln -sfn "$DOTFILES/gitconfig/.gitconfig"      "$HOME/.gitconfig"
  ${pkgs.coreutils}/bin/chown -h "$USER:wheel" "$HOME/.gitconfig"

  # Terminal emulator
  ln -sfn "$DOTFILES/kitty/kitty.conf"          "$HOME/.config/kitty/kitty.conf"
  ${pkgs.coreutils}/bin/chown -h "$USER:wheel" "$HOME/.config/kitty/kitty.conf"
  ln -sfn "$DOTFILES/kitty/current-theme.conf"  "$HOME/.config/kitty/current-theme.conf"
  ${pkgs.coreutils}/bin/chown -h "$USER:wheel" "$HOME/.config/kitty/current-theme.conf"

  # Kanata
  ln -sfn "$DOTFILES/kanata/kanata_gnome.kbd"     "$HOME/.config/kanata/kanata.kbd"
  ${pkgs.coreutils}/bin/chown -h "$USER:wheel" "$HOME/.config/kanata/kanata.kbd"

  # Blesh (Bash Line Editor)
  ln -sfn "$DOTFILES/blesh/.blerc"                "$HOME/.blerc"
  ${pkgs.coreutils}/bin/chown -h "$USER:wheel" "$HOME/.blerc"

  # Prompt
  ln -sfn "$DOTFILES/starship/starship.toml"    "$HOME/.config/starship.toml"
  ${pkgs.coreutils}/bin/chown -h "$USER:wheel" "$HOME/.config/starship.toml"

  # Atuin
  ln -sfn "$DOTFILES/atuin/config.toml"           "$HOME/.config/atuin/config.toml"
  ${pkgs.coreutils}/bin/chown -h "$USER:wheel" "$HOME/.config/atuin/config.toml"

  # ssh config
  ln -sfn "$DOTFILES/.ssh/config"                  "$HOME/.ssh/config"
  ${pkgs.coreutils}/bin/chown -h "$USER:wheel" "$HOME/.ssh/config"

  # Wallpapers
  ln -sfn "$REPO/assets/wallpapers"             "$HOME/Pictures/wallpapers"
  ${pkgs.coreutils}/bin/chown -h "$USER:wheel" "$HOME/Pictures/wallpapers"

'';

##############################################################################
#
# Environment Variables
#
##############################################################################

environment.variables = {

  EDITOR = "nvim";

  VISUAL = "nvim";

  TERMINAL = "kitty";

  BROWSER = "firefox";

};

# Include ~/.local/bin in user PATH
environment.localBinInPath = true;

##############################################################################
#
# Fonts
#
##############################################################################

fonts = {

  fontDir.enable = true;

  packages = with pkgs; [

    noto-fonts
    noto-fonts-cjk-sans
    noto-fonts-color-emoji  # Was: noto-fonts-emoji

    liberation_ttf
    dejavu_fonts

    nerd-fonts.jetbrains-mono
    nerd-fonts.hack

    inter

  ];

};

##############################################################################
#
# System Packages
#
##############################################################################

environment.systemPackages = with pkgs; [

  ###########################################################################
  # Core Utilities
  ###########################################################################

  bash
  coreutils
  findutils
  gnugrep
  gnused
  gawk
  util-linux
  file
  which
  tree
  wget
  curl
  rsync
  unzip
  zip
  p7zip

  # Image manipulation
  imagemagick
  exiftool

  ###########################################################################
  # Shell Utilities
  ###########################################################################

  blesh
  carapace
  atuin
  starship
  zoxide
  fzf
  direnv

  eza
  bat
  bat-extras.core  # bat extras suite
  ripgrep
  fd

  jq
  yq-go

  ###########################################################################
  # Clipboard Manager
  ###########################################################################

  gpaste

  less

  ###########################################################################
  # Editors (nixvim replaces vim/neovim)
  ###########################################################################

  # vim and neovim are managed by programs.nixvim below

  ###########################################################################
  # Build tools (for nvim-treesitter parser compilation)
  ###########################################################################

  gcc
  gnumake

  ###########################################################################
  # LSP Servers (declarative — Nix-managed, no Mason)
  ###########################################################################

  rust-analyzer
  nixd
  basedpyright
  bash-language-server
  yaml-language-server
  marksman
  taplo
  lua-language-server
  vscode-langservers-extracted

  ###########################################################################
  # Formatters
  ###########################################################################

  rustfmt
  nixfmt
  shfmt
  ruff
  stylua
  black
  isort
  prettier

  ###########################################################################
  # Linters
  ###########################################################################

  cargo
  clippy
  shellcheck
  statix
  yamllint
  markdownlint-cli

  ###########################################################################
  # Git
  ###########################################################################

  git
  git-lfs
  delta
  gh
  lazygit

  ###########################################################################
  # Networking
  ###########################################################################

  inetutils
  dnsutils
  nmap
  mtr
  traceroute
  tcpdump
  wireshark
  openssh
  lazyssh

  ###########################################################################
  # Archives
  ###########################################################################

  xz
  gzip
  bzip2

  ###########################################################################
  # Monitoring
  ###########################################################################

  btop
  fastfetch
  lsof
  pciutils
  usbutils
  lm_sensors
  smartmontools
  nvme-cli

  ###########################################################################
  # Nix
  ###########################################################################

  nix-tree
  nix-output-monitor
  nix-index
  comma

  ###########################################################################
  # Hardware
  ###########################################################################

  kanata

  ###########################################################################
  # Sysadmin Tools (Power Bash Experience)
  ###########################################################################

  # File Operations & Analysis
  exfatprogs
  ntfs3g
  parted
  gparted
  ddrescue

  # Disk & Storage
  ncdu
  duf
  dust
  iotop

  # Network Tools
  iperf3
  nethogs
  socat
  netcat
  whois
  bind
  doggo         # DNS tool (replaces removed dogdns)

  # Process & System Monitoring
  htop
  procps
  sysstat
  strace
  ltrace

  # Security
  gnupg
  openssl
  age
  sops

  # Archive & Compression
  zstd
  lz4
  unrar
  p7zip
  rar

  # Text Processing
  miller
  csvkit
  jid
  fx

  # JSON/YAML/TOML
  jc
  yj

  # System Info
  onefetch
  cpufetch
  inxi

  # TUI Tools
  lf
  ranger
  mc
  fzf
  skim

  ###########################################################################
  # Security / CTF Tools (from .bash_aliases)
  ###########################################################################

  # Enumeration
  # enum4linux
  # smbmap
  # dnsenum
  # dnsrecon
  # onesixtyone
  # snmpcheck
   netdiscover
   arp-scan

  # # Web Application Testing
  # gobuster
  # nikto
  # wfuzz
  # sqlmap
  # ffuf

  # # Password Attacks
  # john
  # hashcat
  # wordlists
  # hydra
  # hashid

  # # Privilege Escalation
  # linux-exploit-suggester

  # # Wireless
  # aircrack-ng
  # airgeddon

  # # Metasploit
  # metasploit

  # # File Analysis & Steganography
  # exiftool
  # steghide
  # binwalk
  # foremost
  # # volatility-bin  # Removed - not available in nixpkgs

  # # Proxy & Anonymity
  # tor
  # proxychains-ng

  # # GTFOBins lookup (if available)
  # gtfoblookup  # Not available in nixpkgs

  # Additional utilities
  asciinema
  cmatrix
  lolcat
  figlet

  ###########################################################################
  # GNOME Desktop & Extensions
  ###########################################################################

  gnome-tweaks
  gnome-extension-manager
  dconf-editor

  # GNOME Extensions - managed via gnome-extension-manager
  gnomeExtensions.dash-to-dock
  gnomeExtensions.blur-my-shell
  gnomeExtensions.appindicator
  gnomeExtensions.arcmenu
  gnomeExtensions.quake-terminal
  gnomeExtensions.vitals
  gnomeExtensions.notification-configurator
  gnomeExtensions.pomodoro-timer
  gnomeExtensions.dynamic-music-pill
  gnomeExtensions.modern-clock
  gnomeExtensions.open-bar
  gnomeExtensions.quick-settings-audio-panel
  gnomeExtensions.steal-my-focus-window
  gnomeExtensions.wallpicker

  ###########################################################################
  # Terminal
  ###########################################################################

  kitty
  terminator

  ###########################################################################
  # Productivity
  ###########################################################################

  firefox
  chromium
  joplin-desktop
  evolution

  ###########################################################################
  # Office
  ###########################################################################

  libreoffice
  onlyoffice-desktopeditors

  ###########################################################################
  # Media
  ###########################################################################

  mpv
  vlc
  ffmpeg
  jellyfin-tui
  jellyfin-desktop
  kew

  ###########################################################################
  # Communication
  ###########################################################################

  discord
  whatsie
  resources

  ###########################################################################
  # System Tools
  ###########################################################################

  _1password-gui
  btop
  glow
  gum
  tealdeer
  grc
  chafa
  yazi
  cava
  dog
  doggo
  xh
  lazydocker
  fd
  ouch
  hexyl
  hevi
  wtfis


  ###########################################################################
  # NixOS-Specific Tools
  ###########################################################################
  nh
  nix-output-monitor
  nix-tree
  nix-diff
  nix-init
  nix-update
  nix-index
  comma
  deadnix
  statix
  alejandra
  nil
  nixd
  home-manager
  deploy-rs
  colmena


  ###########################################################################
  # Development Tools
  ###########################################################################

  amp
  bandwhich
  bacon
  netfetch
  atop
  tailspin
  dust
  zellij
  ncdu
  dua
  wiper
  yt-dlp
  guvcview
  qbittorrent
  impression
  qemu
  qemu_kvm
  virt-manager
  spice-gtk
  spice
  spice-vdagent
  dnsmasq
  bridge-utils
  cmatrix

  ###########################################################################
  # File Management (additional)
  ###########################################################################

];

##############################################################################
#
# Development
#
##############################################################################

programs.direnv = {

  enable = true;

  nix-direnv.enable = true;

};

programs.virt-manager = {

  enable = true;

};

##############################################################################
#
# SSH Server
#
##############################################################################

services.openssh = {

  enable = false;

};

##############################################################################
#
# Virtualisation
#
##############################################################################

virtualisation = {

  docker.enable = false;

  podman.enable = false;

  libvirtd = {
    enable = true;
    qemu = {
      package = pkgs.qemu_kvm;
      swtpm.enable = true;
    };
  };

  spiceUSBRedirection.enable = true;

  # VirtualBox - disabled KVM acceleration to avoid conflicts
  # virtualbox.host.enable = false;
  # virtualbox.host.enableExtensionPack = false;

};

##############################################################################
#
# Firewall
#
##############################################################################

networking.firewall = {

  enable = true;

  # GSConnect / KDE Connect
  allowedTCPPortRanges = [ { from = 1714; to = 1764; } ];
  allowedUDPPortRanges = [ { from = 1714; to = 1764; } ];

  # GNOME Network Displays
  allowedTCPPorts = [ 7236 7238 ];
  allowedUDPPorts = [ 5353 7236 ];

  # Container interfaces
  trustedInterfaces = [
    "lo" "docker0" "br-*" "vboxnet*" "virbr*" "cni0" "podman*" "tailscale0"
  ];

};

##############################################################################
#
# Automatic Maintenance
#
##############################################################################

services.fstrim.enable = true;

##############################################################################
#
# Command Not Found
#
##############################################################################

programs.command-not-found.enable = true;

##############################################################################
#
# Documentation
#
##############################################################################

documentation = {

  enable = true;

  man.enable = true;

  dev.enable = true;

};

##############################################################################
#
# System Services
#
##############################################################################

services.dbus.enable = true;
services.udisks2.enable = true;
services.gvfs.enable = true;
services.upower.enable = true;

##############################################################################
#
# End of Configuration
#
##############################################################################

}
