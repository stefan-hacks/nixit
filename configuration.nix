# Edit this configuration file to define what should be installed on
# your system.  Help is available in the configuration.nix(5) man page
# and in the NixOS manual (accessible by running ‘nixos-help’).

{ config, pkgs, ... }:

{
  imports =
    [ # Include the results of the hardware scan.
      ./hardware-configuration.nix
    ];

  # Bootloader.
  boot.loader.systemd-boot.enable = true;
  boot.loader.efi.canTouchEfiVariables = true;

  boot.initrd.luks.devices."luks-a647bf68-5914-4ce0-b703-59f782388611".device = "/dev/disk/by-uuid/a647bf68-5914-4ce0-b703-59f782388611";
  networking.hostName = "ghost"; # Define your hostname.
  # networking.wireless.enable = true;  # Enables wireless support via wpa_supplicant.

  # Configure network proxy if necessary
  # networking.proxy.default = "http://user:password@proxy:port/";
  # networking.proxy.noProxy = "127.0.0.1,localhost,internal.domain";

  # Enable networking
  networking.networkmanager.enable = true;

  # Set your time zone.
  time.timeZone = "America/Sao_Paulo";

  # Select internationalisation properties.
  i18n.defaultLocale = "en_US.UTF-8";

  i18n.extraLocaleSettings = {
    LC_ADDRESS = "en_US.UTF-8";
    LC_IDENTIFICATION = "en_US.UTF-8";
    LC_MEASUREMENT = "en_US.UTF-8";
    LC_MONETARY = "en_US.UTF-8";
    LC_NAME = "en_US.UTF-8";
    LC_NUMERIC = "en_US.UTF-8";
    LC_PAPER = "en_US.UTF-8";
    LC_TELEPHONE = "en_US.UTF-8";
    LC_TIME = "en_US.UTF-8";
  };

  # Enable the X11 windowing system.
  services.xserver.enable = true;

  # Enable the GNOME Desktop Environment.
  services.desktopManager.gnome.enable = true;
  services.displayManager.gdm.enable = true;

  # Configure keymap in X11
  services.xserver.xkb = {
    layout = "us";
    variant = "";
  };

  # Enable CUPS to print documents.
  services.printing.enable = true;

  # Enable sound with pipewire.
  services.pulseaudio.enable = false;
  security.rtkit.enable = true;
  services.pipewire = {
    enable = true;
    alsa.enable = true;
    alsa.support32Bit = true;
    pulse.enable = true;
    # If you want to use JACK applications, uncomment this
    #jack.enable = true;

    # use the example session manager (no others are packaged yet so this is enabled by default,
    # no need to redefine it in your config for now)
    #media-session.enable = true;
  };

  # Enable touchpad support (enabled default in most desktopManager).
  # services.xserver.libinput.enable = true;

  # Define a user account. Don't forget to set a password with ‘passwd’.
  users.users."stefan-hacks" = {
    isNormalUser = true;
    description = "stefan-hacks";
    extraGroups = [ "networkmanager" "wheel" ];
    packages = with pkgs; [
    #  thunderbird
    ];
  };

  # Install firefox.
  programs.firefox.enable = true;

  # Allow unfree packages
  nixpkgs.config.allowUnfree = true;

  # Expeirmental & flakes
  nix.settings.experimental-features = [ "nix-command" "flakes" ];

  # List packages installed in system profile. To search, run:
  # $ nix search wget
  environment.systemPackages = with pkgs; [
    vim # Do not forget to add an editor to edit configuration.nix! The Nano editor is also installed by default.
    wget
    gh
    git
    unzip
    curl
    carapace
    blesh
    atuin
    zoxide
    mullvad-vpn
    gnome-extension-manager
    cava
    tree
    eza
    kanata
    kitty
    unzip
    guvcview
    _1password-gui
    ffmpeg
    bat
    bat-extras.core
    tealdeer
    glow
    gum
    btop
    fwupd
    lolcat
    grc
    starship
    fzf 
    chafa
    yt-dlp
    mpv
    vlc
    joplin-desktop
    impression
    qbittorrent
    discord
    whatsie
    onlyoffice-desktopeditors
    libreoffice
    gnome-tweaks
    gnomeExtensions.blur-my-shell
    gnomeExtensions.dynamic-music-pill
    gnomeExtensions.appindicator
    gnomeExtensions.quick-settings-audio-panel
    gnomeExtensions.quake-terminal
    gnomeExtensions.vitals
    gnomeExtensions.notification-configurator
    gnomeExtensions.open-bar
    gnomeExtensions.arcmenu
    gnomeExtensions.user-themes
    gnomeExtensions.modern-clock
    gnomeExtensions.steal-my-focus-window
    gnomeExtensions.pomodoro-timer
 
  ];

  # Some programs need SUID wrappers, can be configured further or are
  # started in user sessions.
  # programs.mtr.enable = true;
  # programs.gnupg.agent = {
  #   enable = true;
  #   enableSSHSupport = true;
  # };

  # Atuin
  programs.atuin.enable = true;
  programs.bash = {
  enable = true;
  interactiveShellInit = ''
    eval "$(atuin init bash)"
   '';
  };


  # List services that you want to enable:
  
  # Kanata keyboard remapper
  services.kanata = { 
    enable = true;
    keyboards = {
     internalKeyboard = {
       configFile = /home/stefan-hacks/.config/kanata/kanata_gnome.kbd;
      };
     };
    };

  # Enable the OpenSSH daemon.
  # services.openssh.enable = true;

  # Modern nftables engine handles GNOME background traffic efficiently
  networking.nftables.enable = true;

  networking.firewall = {
    enable = true;
    checkReversePath = "strict";

    # =========================================================================
    # GNOME & USER DESKTOP HOOKS
    # =========================================================================
    
    # 📱 GSConnect / KDE Connect GNOME Extension
    # Necessary for clipboard sharing, notifications, and file transfer with your phone
    allowedTCPPortRanges = [ { from = 1714; to = 1764; } ];
    allowedUDPPortRanges = [ { from = 1714; to = 1764; } ];

    # 📺 GNOME Network Displays & Screencasting (Miracast / Wi-Fi Display)
    # Required if you cast your laptop screen to smart TVs or external conference displays
    allowedTCPPorts = [ 7236 7238 ];
    allowedUDPPorts = [ 5353 7236 ];

    # =========================================================================
    # CONTAINER & LOCAL ENGINE ISOLATION
    # =========================================================================
    trustedInterfaces = [
      "lo" "docker0" "br-*" "vboxnet*" "virbr*" "cni0" "podman*" "tailscale0"
    ];
  };

  # =========================================================================
  # GNOME MULTICAST / NETWORK DISCOVERY (Avahi)
  # =========================================================================
  # Vital for GNOME Extensions like "Removable Drive Menu" over network shares, 
  # discovering network printers via CUPS, and local network file sharing.
  services.avahi = {
    enable = true;
    nssmdns4 = true;
    openFirewall = true; # Let NixOS safely expose the localized mDNS rules
  };
  


  # This value determines the NixOS release from which the default
  # settings for stateful data, like file locations and database versions
  # on your system were taken. It‘s perfectly fine and recommended to leave
  # this value at the release version of the first install of this system.
  # Before changing this value read the documentation for this option
  # (e.g. man configuration.nix or on https://nixos.org/nixos/options.html).
  system.stateVersion = "26.05"; # Did you read the comment?

}
