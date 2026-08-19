{
  username,
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
    ../../modules/home/dconf.nix
    ../../modules/home/fastfetch.nix
  ];

  # Let Home Manager install and configure itself
  programs.home-manager.enable = true;
}
