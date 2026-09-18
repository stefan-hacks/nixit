# ============================================================================
# modules/desktop/dank/dank.nix
# ----------------------------------------------------------------------------
# DankMaterialShell (DMS) Desktop Environment configuration.
#
# Replaces GNOME as the desktop environment. This module enables:
#   • DankMaterialShell via programs.dms-shell
#   • DMS greeter (replaces GDM) via services.displayManager.dms-greeter
#   • Niri compositor (the recommended compositor for DMS)
#   • Required Wayland/graphics infrastructure
#   • DMS plugins (via dms-plugin-registry flake input)
#
# When this profile is selected, the GNOME module is NOT imported, ensuring
# no collision between GDM and dms-greeter.
#
# Reference:
#   https://danklinux.com/docs/dankmaterialshell/nixos
#   https://github.com/NixOS/nixpkgs/blob/nixos-26.05/nixos/modules/programs/wayland/dms-shell.nix
#   https://github.com/NixOS/nixpkgs/blob/nixos-26.05/nixos/modules/services/display-managers/dms-greeter.nix
# ============================================================================
{ inputs, pkgs, ... }:
let
  # GDM-style wallpaper for the DMS greeter (copied to nix store)
  dmsWallpaper = pkgs.runCommand "dms-wallpaper" { } ''
    mkdir -p $out/share/wallpapers
    cp ${../../../assets/wallpapers/Catppuccin_Mocha/17._Catppuccin_Mocha.jpg} $out/share/wallpapers/dms-background.jpg
  '';
in
{
  # ── Compositor: Niri ─────────────────────────────────────────────────────
  # Niri is the recommended compositor for DankMaterialShell.
  # DMS greeter requires `programs.niri.enable = true` to be set.
  #
  # Reference: https://github.com/YaLTeR/niri
  programs.niri = {
    enable = true;
    package = pkgs.niri;
  };

  # ── Display Manager: DMS Greeter (replaces GDM) ──────────────────────────
  # DMS comes with its own greeter. It MUST replace GDM — only one display
  # manager can be active. The greeter runs inside a compositor (Niri) and
  # starts the user session.
  #
  # Reference:
  #   https://danklinux.com/docs/dankmaterialshell/compositors
  services.displayManager.dms-greeter = {
    enable = true;
    compositor.name = "niri";

    # Copy user DMS config (wallpapers, themes) into the greeter session.
    configHome = "/home/stefan-hacks";

    # Logging (useful for debugging greeter issues)
    logs.save = true;
    logs.path = "/tmp/dms-greeter.log";
  };

  # ── DankMaterialShell ──────────────────────────────────────────────────────
  # The core DMS shell. Enable with all recommended feature toggles.
  # systemd.target = "graphical-session.target" — starts after login.
  #
  # Feature toggles:
  #   • enableSystemMonitoring — system resource widgets (requires dgop)
  #   • enableVPN            — VPN status widgets (requires glib, networkmanager)
  #   • enableDynamicTheming — auto-theme from wallpaper (requires matugen)
  #   • enableAudioWavelength — audio visualizer widgets (requires cava)
  #   • enableCalendarEvents — calendar widgets (requires khal)
  #   • enableClipboardPaste — Shift+Return paste from clipboard (requires wtype)
  programs.dms-shell = {
    enable = true;

    # Use systemd to auto-start DMS after graphical session begins
    systemd = {
      enable = true;
      target = "graphical-session.target";
      restartIfChanged = true;
    };

    # Recommended feature toggles (all default to true)
    enableSystemMonitoring = true;
    enableVPN = true;
    enableDynamicTheming = true;
    enableAudioWavelength = true;
    enableCalendarEvents = true;
    enableClipboardPaste = true;

    # Plugins from the dms-plugin-registry flake
    plugins = {
      # Example: DockerManager plugin (enable as needed)
      # dockerManager = {
      #   enable = true;
      #   src = inputs.dms-plugin-registry.packages.${pkgs.stdenv.hostPlatform.system}.dockerManager;
      # };
    };
  };

  # ── Wayland / Graphics Infrastructure ──────────────────────────────────
  # Required for all Wayland compositors. DMS greeter module already sets
  # `hardware.graphics.enable = lib.mkDefault true`, but we set it explicitly
  # here for clarity.
  hardware.graphics.enable = true;

  # ── DConf ────────────────────────────────────────────────────────────────
  # DMS may read/write dconf settings for integration with some GTK apps.
  programs.dconf.enable = true;

  # ── XDG Portal ─────────────────────────────────────────────────────────────
  # Wayland apps need portals for file dialogs, screenshare, etc.
  xdg.portal = {
    enable = true;
    xdgOpenUsePortal = true;
    extraPortals = with pkgs; [
      xdg-desktop-portal-gtk
      xdg-desktop-portal-wlr
    ];
    config.common.default = "*";
  };

  # ── Fonts required by the greeter ──────────────────────────────────────
  # DMS greeter uses Fira Code, Inter, and Material Symbols.
  # The greeter module already installs these; listed here for documentation.
  # fonts.packages = with pkgs; [ fira-code inter material-symbols ];

  # ── System Packages for DMS ──────────────────────────────────────────────
  environment.systemPackages = with pkgs; [
    # DMS CLI tooling
    dms-shell

    # Quickshell runtime (DMS is built on Quickshell)
    quickshell

    # Compositor tooling
    niri

    # ── Optional DMS dependencies (mirroring feature toggles) ──────────────
    dgop
    glib
    networkmanager
    matugen
    cava
    khal
    wtype

    # ── Clipboard manager (DMS has built-in clipboard, but wl-clipboard
    #   is still useful for CLI interop with Wayland)
    wl-clipboard

    # ── Screenshot tools (DMS has built-in, but extras for CLI use)
    grim
    slurp

    # ── Notification daemon (DMS provides notifications, but mako is a
    #   common standalone fallback if DMS notifications are disabled)
    mako

    # ── Polkit agent (required for authentication dialogs in standalone
    #   compositors; GNOME's polkit is replaced)
    polkit_gnome
  ];

  # ── Polkit ─────────────────────────────────────────────────────────────────
  # Required for GUI auth dialogs (e.g. pkexec) in standalone compositors.
  # The DMS module already sets `security.polkit.enable = lib.mkDefault true`.
  security.polkit.enable = true;

  # ── Accounts Daemon ──────────────────────────────────────────────────────
  # Required by DMS greeter for user enumeration and avatar display.
  # The DMS module already sets this via `lib.mkDefault`.
  services.accounts-daemon.enable = true;

  # ── Power Profiles Daemon ────────────────────────────────────────────────
  # Required by DMS for battery/performance widgets.
  # The DMS module already sets this via `lib.mkDefault`.
  services.power-profiles-daemon.enable = true;
}
