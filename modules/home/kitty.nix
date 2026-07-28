{ config, pkgs, lib, ... }:

{
  # Ensure ~/.config/kitty exists and is writable by the user before HM links files
  home.activation.ensureKittyDir = lib.hm.dag.entryBefore [ "writeBoundary" ] ''
    if [ -d "$HOME/.config/kitty" ]; then
      chmod u+rwx "$HOME/.config/kitty"
    else
      mkdir -p "$HOME/.config/kitty"
    fi
  '';

  home.file.".config/kitty/kitty.conf".source = ../../dotfiles/kitty/kitty.conf;
  home.file.".config/kitty/current-theme.conf".source = ../../dotfiles/kitty/current-theme.conf;
}
