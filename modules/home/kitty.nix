{pkgs, ...}: {
  home.file.".config/kitty/kitty.conf".source = ../../dotfiles/kitty/kitty.conf;
  home.file.".config/kitty/current-theme.conf".source = ../../dotfiles/kitty/current-theme.conf;

  # kitty-scrollback.nvim provides a kitty "kitten" (Python helper) that
  # must live at a stable path reachable from kitty.conf.  The plugin
  # lives in the Nix store, so we symlink it into ~/.config/kitty/ where
  # kitty.conf already points (kitten ~/.config/kitty/kitty_scrollback_nvim.py).
  home.file.".config/kitty/kitty_scrollback_nvim.py".source =
    "${pkgs.vimPlugins.kitty-scrollback-nvim}/python/kitty_scrollback_nvim.py";
}
