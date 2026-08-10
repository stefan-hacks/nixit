{
  config,
  pkgs,
  lib,
  ...
}:

{
  home.file.".config/atuin/config.toml".source = ../../dotfiles/atuin/config.toml;
}
