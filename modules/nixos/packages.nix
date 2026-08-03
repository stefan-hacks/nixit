{
  config,
  pkgs,
  lib,
  ...
}:

{
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
    bat-extras.core # bat extras suite
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
    doggo # DNS tool (replaces removed dogdns)

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
    netdiscover
    arp-scan

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

    # Theme required by Open Bar extension for accent colors & folder colors
    yaru-theme

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

    shortwave
    mpv
    vlc
    ffmpeg
    jellyfin-tui
    jellyfin-desktop
    kew
    yt-dlp
    soundconverter

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
  ];
}
