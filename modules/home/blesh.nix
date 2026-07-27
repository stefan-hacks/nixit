{ config, pkgs, lib, ... }:

{
  home.file.".blerc".source = ../../dotfiles/blesh/.blerc;
}
