# ============================================================================
# modules/desktop/gnome/gnome.nix
# ----------------------------------------------------------------------------
# GNOME Desktop Environment configuration.
# This module replaces the old modules/nixos/gnome.nix and contains ALL
# GNOME-specific NixOS declarations: GDM, GNOME DE, XDG portals, extensions,
# and GNOME tooling packages.
#
# When the host selects the GNOME profile, this module is imported.
# When the Dank profile is selected, this module is NOT imported.
#
# Reference:
#   https://nixos.wiki/wiki/GNOME
#   https://nixos.wiki/wiki/OpenGL
# ============================================================================
{ pkgs, ... }:
let
  # GDM wallpaper - copied to nix store for accessibility (GDM user can read it)
  gdmWallpaper = pkgs.runCommand "gdm-wallpaper" { } ''
    mkdir -p $out/share/wallpapers
    cp ${../../../assets/wallpapers/Catppuccin_Mocha/17._Catppuccin_Mocha.jpg} $out/share/wallpapers/gdm-background.jpg
  '';
in
{
  # ── Display Manager ──────────────────────────────────────────────────────
  services.displayManager.gdm.enable = true;

  # ── Desktop Environment ──────────────────────────────────────────────────
  services.gnome.gnome-online-accounts.enable = true;
  services.desktopManager.gnome.enable = true;

  # ── X Server (required by GNOME Shell and Electron apps) ───────────────────
  services.xserver = {
    enable = true;
    xkb = {
      layout = "us";
      variant = "";
    };
  };

  # ── XDG Portal ─────────────────────────────────────────────────────────────
  xdg.portal = {
    enable = true;
    xdgOpenUsePortal = true;
    extraPortals = with pkgs; [
      xdg-desktop-portal-gnome
    ];
  };

  # ── DConf (required for GNOME settings) ────────────────────────────────────
  programs.dconf.enable = true;

  # ── GDM Login Screen Background ──────────────────────────────────────────
  programs.dconf.profiles.gdm.databases = [
    {
      settings."org/gnome/desktop/background" = {
        picture-uri = "file://${gdmWallpaper}/share/wallpapers/gdm-background.jpg";
        picture-options = "zoom";
      };
    }
  ];

  # ── GPaste Clipboard Manager Daemon ──────────────────────────────────────
  programs.gpaste.enable = true;

  # ── GNOME Packages ───────────────────────────────────────────────────────
  environment.systemPackages = with pkgs; [
    # GNOME tooling
    gnome-tweaks
    gnome-extension-manager
    dconf-editor
    gnome-online-accounts
    gvfs

    # GNOME Default icon & cursor theme (must be explicitly installed)
    adwaita-icon-theme

    # Theme required by Open Bar extension for accent colors & folder colors
    yaru-theme

    # ── GNOME Extensions ───────────────────────────────────────────────────
    # Managed via gnome-extension-manager.
    # Extensions are installed system-wide but enabled per-user via dconf.
    gnomeExtensions.user-themes
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
  ];
}
