{ config, pkgs, username, ... }:

let
  homeDir = config.home.homeDirectory;
in
{
  # Fastfetch config JSON — fastfetch reads ~/.config/fastfetch/config.json
  xdg.configFile."fastfetch/config.json".source = ../../dotfiles/fastfetch/config.json;

  # Fastfetch logo image — deployed to ~/.config/nixit/assets/icon2.png
  # so the absolute path in config.json remains valid
  xdg.configFile."nixit/assets/icon2.png".source = ../../assets/icon2.png;
}
