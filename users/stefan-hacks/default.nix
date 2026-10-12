# ============================================================================
# users/stefan-hacks/default.nix
# ----------------------------------------------------------------------------
# Home-manager aspect for user "stefan-hacks" on any host that enables it.
# This module is evaluated inside home-manager's module context, so it has
# access to pkgs, lib, username, nix-graph, etc. (via extraSpecialArgs).
#
# It imports the generic home-manager feature modules (shell, terminal, etc.)
# plus the per-user GNOME dconf configuration.
# ============================================================================
{
  username,
  lib,
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
  ]
  # ── GNOME dconf settings ─────────────────────────────────────────────────
  # Only import when GNOME desktop profile is active. DMS does not use dconf
  # for its own configuration (it uses Quickshell config files).
  ++ lib.optionals (desktopProfile == "gnome") [ ./gnome/default.nix ];

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

}
