{ config, pkgs, lib, ... }:

{
  home.file.".ssh/config".source = ../../dotfiles/.ssh/config;
}
