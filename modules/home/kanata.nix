{ config, pkgs, lib, ... }:

{
  home.file.".config/kanata/kanata.kbd".source = ../../dotfiles/kanata/kanata_gnome.kbd;
}
