{ config, pkgs, lib, ... }:

{
  home.file.".config/kitty/kitty.conf".source = ../../dotfiles/kitty/kitty.conf;
  home.file.".config/kitty/current-theme.conf".source = ../../dotfiles/kitty/current-theme.conf;
}
