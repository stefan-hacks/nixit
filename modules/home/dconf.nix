{ config, pkgs, lib, username, ... }:

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
    Unit = { Description = "Load GNOME settings from nixit"; };
    Service = {
      Type = "oneshot";
      ExecStart = "${pkgs.bash}/bin/bash -c '${pkgs.dconf}/bin/dconf load / < ${../../gnome/dconf.ini} || true'";
    };
    Install = { WantedBy = [ "default.target" ]; };
  };
}
