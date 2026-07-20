##############################################################################
#
# NixOS Production Workstation
#
# Hostname    : ghost
# Purpose     : Daily Development Workstation
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

in

{

##############################################################################
#
# Imports
#
##############################################################################

imports = [
  ./hardware-configuration.nix
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

services.kanata = {

  enable = true;

  keyboards = {

    internal = {

      configFile = "${homeDirectory}/.config/kanata/kanata.kbd";

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

# Load sanitized GNOME settings after system activation
system.activationScripts.gnome-settings.text = ''

  DCONF_FILE="${repoDirectory}/gnome/dconf.ini"

  if [ -f "$DCONF_FILE" ]; then
    ${pkgs.dconf}/bin/dconf load / < "$DCONF_FILE"
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
    "input"
    "dialout"

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
##############################################################################

programs.ssh = {

  startAgent = true;

};

##############################################################################
#
# GnuPG
#
##############################################################################

programs.gnupg.agent = {

  enable = true;

  enableSSHSupport = true;

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

  # Create necessary directories
  mkdir -p "$HOME/.config"
  mkdir -p "$HOME/.config/kitty"
  mkdir -p "$HOME/.config/kanata"
  mkdir -p "$HOME/Pictures"

  # Bash configuration
  ln -sfn "$DOTFILES/bash/.bashrc"              "$HOME/.bashrc"
  ln -sfn "$DOTFILES/bash/.bash_aliases"        "$HOME/.bash_aliases"

  # Git configuration
  ln -sfn "$DOTFILES/gitconfig/.gitconfig"      "$HOME/.gitconfig"

  # Terminal emulator
  ln -sfn "$DOTFILES/kitty/kitty.conf"          "$HOME/.config/kitty/kitty.conf"
  ln -sfn "$DOTFILES/kitty/current_theme.conf"  "$HOME/.config/kitty/current_theme.conf"

  # Kanata
  ln -sfn "$DOTFILES/kanata/kanata_gnome.kbd"     "$HOME/.config/kanata/kanata.kbd"

  # Blesh (Bash Line Editor)
  ln -sfn "$DOTFILES/blesh/.blerc"                "$HOME/.blerc"

  # Prompt
  ln -sfn "$DOTFILES/starship/starship.toml"    "$HOME/.config/starship.toml"

  # Neovim (commented out until configured)
  # ln -sfn "$DOTFILES/nvim"                      "$HOME/.config/nvim"

  # Atuin (commented out until configured)
  # ln -sfn "$DOTFILES/atuin"                     "$HOME/.config/atuin"

  # Blesh (commented out until configured)
  # ln -sfn "$DOTFILES/blesh"                     "$HOME/.config/blesh"

  # Wallpapers
  ln -sfn "$REPO/assets/wallpapers"             "$HOME/Pictures/wallpapers"

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
    noto-fonts-emoji

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

  ###########################################################################
  # Shell Utilities
  ###########################################################################

  blesh
  atuin
  starship
  zoxide
  fzf
  direnv

  eza
  bat
  ripgrep
  fd

  jq
  yq-go

  less

  ###########################################################################
  # Editors
  ###########################################################################

  neovim

  ###########################################################################
  # Git
  ###########################################################################

  git
  git-lfs
  delta
  gh

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
  dogdns

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
  neofetch
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
  enum4linux
  smbmap
  crackmapexec
  dnsenum
  dnsrecon
  onesixtyone
  snmpcheck
  netdiscover
  arp-scan

  # Web Application Testing
  gobuster
  nikto
  wfuzz
  sqlmap
  ffuf

  # Password Attacks
  john
  hashcat
  wordlists
  hydra
  hashid

  # Privilege Escalation
  linux-exploit-suggester

  # Wireless
  aircrack-ng
  airgeddon

  # Metasploit
  metasploit

  # File Analysis & Steganography
  exiftool
  steghide
  binwalk
  foremost
  volatility-bin

  # Proxy & Anonymity
  tor
  proxychains-ng

  # GTFOBins lookup (if available)
  gtfoblookup

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

  # GNOME Extensions
  gnomeExtensions.user-themes
  gnomeExtensions.dash-to-dock
  gnomeExtensions.blur-my-shell
  gnomeExtensions.clipboard-indicator
  gnomeExtensions.appindicator
  gnomeExtensions.arcmenu
  gnomeExtensions.quake-terminal
  gnomeExtensions.vitals
  gnomeExtensions.notification-configurator
  gnomeExtensions.pomodoro-timer
  gnomeExtensions.coverflow-alt-tab

  ###########################################################################
  # Terminal
  ###########################################################################

  kitty

  ###########################################################################
  # Productivity
  ###########################################################################

  firefox
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

  ###########################################################################
  # Communication
  ###########################################################################

  discord

  ###########################################################################
  # System Tools
  ###########################################################################

  _1password-gui
  mullvad-vpn
  btop
  glow
  gum
  tealdeer
  grc
  chafa
  cava

  ###########################################################################
  # Development Tools
  ###########################################################################

  yt-dlp
  guvcview
  qbittorrent
  impression

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

  libvirtd.enable = false;

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
