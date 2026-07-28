{
  config,
  pkgs,
  lib,
  username,
  ...
}:

let
  homeDirectory = "/home/${username}";
in
{
  # Symlink dotfiles from the repo
  home.file."Pictures/wallpapers".source = ../../assets/wallpapers;
  home.file.".face".source = ../../assets/icon2.png;

  # Load GNOME dconf settings on home-manager switch
  home.activation.loadGnomeDconf = lib.hm.dag.entryAfter [ "writeBoundary" ] ''
    if [ -n "$DBUS_SESSION_BUS_ADDRESS" ]; then
      ${pkgs.dconf}/bin/dconf load / < ${../../gnome/dconf.ini} || true
    fi
  '';

  # User service to load GNOME settings on login
  systemd.user.services.gnome-settings-load = {
    Unit = {
      Description = "Load GNOME settings from nixit";
    };
    Service = {
      Type = "oneshot";
      ExecStart = "${pkgs.bash}/bin/bash -c '${pkgs.dconf}/bin/dconf load / < ${../../gnome/dconf.ini} || true'";
    };
    Install = {
      WantedBy = [ "default.target" ];
    };
  };

  # Favourite apps in Dash
  dconf.settings = {
    "org/gnome/shell" = {
      favorite-apps = [
        "mullvad-vpn.desktop"
        "kitty.desktop"
        "terminator.desktop"
        "org.gnome.Console.desktop"
        "virt-manager.desktop"
        "org.gnome.Nautilus.desktop"
        "1password.desktop"
        "firefox.desktop"
        "chromium-browser.desktop"
        "joplin.desktop"
        "org.gnome.Evolution.desktop"
        "onlyoffice-desktopeditors.desktop"
        "discord.desktop"
        "com.ktechpit.whatsie.desktop"
        "org.jellyfin.JellyfinDesktop.desktop"
        "io.gitlab.adhami3310.Impression.desktop"
        "net.nokyan.Resources.desktop"
        "org.qbittorrent.qBittorent.desktop"
        "nixos-manual.desktop"
      ];
    };
  };

}
