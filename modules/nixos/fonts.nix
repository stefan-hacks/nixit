{ config, pkgs, lib, ... }:

{
  fonts = {
    fontDir.enable = true;
    packages = with pkgs; [
      noto-fonts
      noto-fonts-cjk-sans
      noto-fonts-color-emoji

      liberation_ttf
      dejavu_fonts

      nerd-fonts.jetbrains-mono
      nerd-fonts.hack

      inter
    ];
  };
}
