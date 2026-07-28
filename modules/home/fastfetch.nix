{ config, pkgs, username, ... }:

let
  homeDir = config.home.homeDirectory;
in
{
  # Fastfetch config JSONC — fastfetch reads ~/.config/fastfetch/config.jsonc
  xdg.configFile."fastfetch/config.jsonc".source = ../../dotfiles/fastfetch/config.jsonc;

  # Fastfetch logo image — deployed to ~/.config/nixit/assets/icon2.png
  # so the absolute path in config.json remains valid
  xdg.configFile."nixit/assets/icon2.png".source = ../../assets/icon2.png;
}
