{ config, pkgs, lib, ... }:

{
  home.file.".config/starship.toml".source = ../../dotfiles/starship/starship.toml;
}
