{
  pkgs,
  ...
}:

let
  # GDM wallpaper - copied to nix store for accessibility (GDM user can read it)
  gdmWallpaper = pkgs.runCommand "gdm-wallpaper" { } ''
    mkdir -p $out/share/wallpapers
    cp ${../../assets/wallpapers/Catppuccin_Mocha/17._Catppuccin_Mocha.jpg} $out/share/wallpapers/gdm-background.jpg
  '';
in
{
  services.displayManager.gdm.enable = true;
  services.desktopManager.gnome.enable = true;

  services.xserver = {
    enable = true;
    xkb = {
      layout = "us";
      variant = "";
    };
  };

  # XDG Portal
  xdg.portal = {
    enable = true;
    xdgOpenUsePortal = true;
    extraPortals = with pkgs; [
      xdg-desktop-portal-gnome
    ];
  };

  # DConf
  programs.dconf.enable = true;

  # GDM login screen background wallpaper
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

  environment.systemPackages = with pkgs; [
    gnome-tweaks
    gnome-extension-manager
    dconf-editor

    # GNOME Default icon & cursor theme (must be explicitly installed)
    adwaita-icon-theme

    # Theme required by Open Bar extension for accent colors & folder colors
    yaru-theme

    # GNOME Extensions - managed via gnome-extension-manager
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
