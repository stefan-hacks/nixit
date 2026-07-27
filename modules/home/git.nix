{ config, pkgs, lib, ... }:

{
  home.file.".gitconfig".source = ../../dotfiles/gitconfig/.gitconfig;
}
