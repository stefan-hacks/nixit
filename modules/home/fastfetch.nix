{
  config,
  ...
}:

{
  # Fastfetch config JSONC — fastfetch reads ~/.config/fastfetch/config.jsonc
  xdg.configFile."fastfetch/config.jsonc".source = ../../dotfiles/fastfetch/config.jsonc;

  # Fastfetch logo image — deployed alongside config so relative path works
  xdg.configFile."fastfetch/icon2.png".source = ../../assets/icon2.png;
}
