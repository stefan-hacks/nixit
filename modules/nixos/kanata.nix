{ config, pkgs, lib, ... }:

{
  services.kanata = {
    enable = true;
    keyboards = {
      internal = {
        configFile = ../../dotfiles/kanata/kanata_gnome.kbd;
      };
    };
  };
}
