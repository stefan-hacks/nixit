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

  # Vim
  ln -sfn "$DOTFILES/vim/.vimrc"                  "$HOME/.vimrc"
  ${pkgs.coreutils}/bin/chown -h "$USER:wheel" "$HOME/.vimrc"

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

  EDITOR = "vim";

  VISUAL = "vim";

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
  # Editors
  ###########################################################################

  vim

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
  qemu
  qemu_kvm
  virt-manager
  spice-gtk
  spice
  spice-vdagent
  dnsmasq
  bridge-utils

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
