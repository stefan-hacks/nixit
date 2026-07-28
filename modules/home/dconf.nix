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
  # ── Wallpaper directory (manual symlink to avoid HM conflict) ─────────────
  home.activation.wallpapersAndFace = lib.hm.dag.entryAfter [ "writeBoundary" ] ''
    # Create Pictures directory
    mkdir -p ${homeDirectory}/Pictures

    # Symlink wallpapers if not already there
    if [ ! -e "${homeDirectory}/Pictures/wallpapers" ] && [ ! -L "${homeDirectory}/Pictures/wallpapers" ]; then
      ln -s ${../../assets/wallpapers} "${homeDirectory}/Pictures/wallpapers"
    fi

    # Symlink face icon
    if [ ! -e "${homeDirectory}/.face" ] && [ ! -L "${homeDirectory}/.face" ]; then
      ln -s ${../../assets/icon2.png} "${homeDirectory}/.face"
    fi
  '';

  # ── Load GNOME dconf settings on home-manager switch ────────────────────
  # All GNOME settings including favorite-apps come from gnome/dconf.ini
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
}
