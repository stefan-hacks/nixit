{
  username,
  lib,
  ...
}:

let
  homeDirectory = "/home/${username}";
in
{
  home.username = username;
  home.homeDirectory = homeDirectory;
  home.stateVersion = "26.05";

  imports = [
    ../../modules/home/bash.nix
    ../../modules/home/vim.nix
    ../../modules/home/git.nix
    ../../modules/home/kitty.nix
    ../../modules/home/blesh.nix
    ../../modules/home/starship.nix
    ../../modules/home/atuin.nix
    ../../modules/home/zellij.nix
    ../../modules/home/ssh.nix
    # ../../modules/home/dconf.nix
    ../../modules/home/fastfetch.nix
    ./gnome
  ];

  # Let Home Manager install and configure itself
  programs.home-manager.enable = true;

  # Re-create the wallpapers symlink that the old dconf.nix activation provided.
  # Your generated GNOME dconf (gtk.nix, shell-extensions.nix, etc.) references
  # ~/Pictures/wallpapers, so this symlink must exist for backgrounds and wallpicker.
  home.activation.wallpapersLink = lib.hm.dag.entryAfter [ "writeBoundary" ] ''
    mkdir -p ${homeDirectory}/Pictures
    if [ ! -e "${homeDirectory}/Pictures/wallpapers" ] && [ ! -L "${homeDirectory}/Pictures/wallpapers" ]; then
      ln -s ${../../../assets/wallpapers} "${homeDirectory}/Pictures/wallpapers"
    fi
  '';
}
