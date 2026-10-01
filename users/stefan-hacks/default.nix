# ============================================================================
# users/stefan-hacks/default.nix
# ----------------------------------------------------------------------------
# Home-manager aspect for user "stefan-hacks" on any host that enables it.
# This module is evaluated inside home-manager's module context, so it has
# access to pkgs, lib, username, look, nix-graph, etc. (via extraSpecialArgs).
#
# It imports the generic home-manager feature modules (shell, terminal, etc.)
# plus the per-user GNOME dconf configuration.
# ============================================================================
{
  username,
  lib,
  look,
  pkgs,
  desktopProfile,
  ...
}:
let
  homeDirectory = "/home/${username}";
in
{
  home.username = username;
  home.homeDirectory = homeDirectory;
  home.stateVersion = "26.05";

  # Import generic home-manager features (order does not matter)
  imports = [
    ../../home/bash.nix
    ../../home/vim.nix
    ../../home/git.nix
    ../../home/kitty.nix
    ../../home/blesh.nix
    ../../home/foot.nix
    ../../home/starship.nix
    ../../home/atuin.nix
    ../../home/zellij.nix
    ../../home/ssh.nix
    ../../home/fastfetch.nix
    ../../home/firefox.nix
  ]
  # ── GNOME dconf settings ─────────────────────────────────────────────────
  # Only import when GNOME desktop profile is active. DMS does not use dconf
  # for its own configuration (it uses Quickshell config files).
  ++ lib.optionals (desktopProfile == "gnome") [ ./gnome/default.nix ];

  # Install the Look launcher from its upstream flake.
  # Pre-built binaries are cached via Cachix so this is fast.
  home.packages = [ look.packages.${pkgs.stdenv.hostPlatform.system}.default ];

  # Let Home Manager install and configure itself
  programs.home-manager.enable = true;

  # Re-create the wallpapers symlink that the old dconf.nix activation provided.
  # The generated GNOME dconf modules reference ~/Pictures/wallpapers, so this
  # symlink must exist for backgrounds and wallpicker to work.
  home.activation.wallpapersLink = lib.hm.dag.entryAfter [ "writeBoundary" ] ''
    mkdir -p ${homeDirectory}/Pictures
    if [ ! -e "${homeDirectory}/Pictures/wallpapers" ] && [ ! -L "${homeDirectory}/Pictures/wallpapers" ]; then
      ln -s ${../../assets/wallpapers} "${homeDirectory}/Pictures/wallpapers"
    fi

    # Symlink face icon
    if [ ! -e "${homeDirectory}/.face" ] && [ ! -L "${homeDirectory}/.face" ]; then
      ln -s ${../../assets/icon2.png} "${homeDirectory}/.face"
    fi
  '';

  # Free up Alt+Space for the Look launcher by disabling ArcMenu's runner-hotkey.
  # Look's default toggle is Alt+Space; without this override the two collide.
  # Only relevant when GNOME + ArcMenu extension is active.
  dconf.settings = lib.mkIf (desktopProfile == "gnome") {
    "org/gnome/shell/extensions/arcmenu" = {
      runner-hotkey = lib.mkForce [ ];
      runner-hotkey-overlay-key-enabled = lib.mkForce false;
    };
  };

  # ── Suppress GNOME Overview on login ─────────────────────────────────────
  # ArcMenu and dash-to-dock both set hide/disable-overview-on-startup, but
  # GNOME Shell often wins the race and opens the overview anyway. This one-shot
  # service waits for the graphical session and explicitly closes it.
  # See: https://gitlab.gnome.org/GNOME/gnome-shell/-/issues/5402
  systemd.user.services.close-overview = lib.mkIf (desktopProfile == "gnome") {
    Unit = {
      Description = "Close GNOME Overview on startup";
      After = [ "graphical-session.target" ];
      PartOf = [ "graphical-session.target" ];
    };
    Service = {
      Type = "oneshot";
      ExecStart = "${pkgs.bash}/bin/bash -c 'sleep 1 \u0026\u0026 ${pkgs.glib}/bin/gdbus call --session --dest org.gnome.Shell --object-path /org/gnome/Shell --method org.gnome.Shell.Eval \"Main.overview.hide()\"'";
    };
    Install.WantedBy = [ "graphical-session.target" ];
  };
}
