{
  config,
  pkgs,
  lib,
  ...
}:

{
  home.file.".vimrc".source = ../../dotfiles/vim/.vimrc;
}
