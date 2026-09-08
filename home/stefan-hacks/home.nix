{
  username,
  lib,
  look,
  pkgs,
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
    ../../modules/home/fastfetch.nix
    ./gnome
  ];

  # Install the Look launcher from its upstream flake (github:kunkka19xx/look).
  # Pre-built binaries are cached via Cachix so this is fast.
  home.packages = [ look.packages.${pkgs.system}.default ];

  # Let Home Manager install and configure itself
  programs.home-manager.enable = true;

  # Enable dconf writes so declarative dconf.settings in ./gnome/ take effect.
  programs.dconf.enable = true;

  # Re-create the wallpapers symlink that the old dconf.nix activation provided.
  # Your generated GNOME dconf (gtk.nix, shell-extensions.nix, etc.) references
  # ~/Pictures/wallpapers, so this symlink must exist for backgrounds and wallpicker.
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
  dconf.settings = {
    "org/gnome/shell/extensions/arcmenu" = {
      runner-hotkey = lib.mkForce [ ];
      runner-hotkey-overlay-key-enabled = lib.mkForce false;
    };
  };
}
