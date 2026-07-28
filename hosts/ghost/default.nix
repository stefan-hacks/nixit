{ config, pkgs, lib, username, ... }:

{
  imports = [
    ./hardware-configuration.nix

    # Core system
    ../../modules/nixos/boot.nix
    ../../modules/nixos/networking.nix
    ../../modules/nixos/locale.nix
    ../../modules/nixos/gnome.nix
    ../../modules/nixos/programs.nix
    ../../modules/nixos/packages.nix
    ../../modules/nixos/services.nix
    ../../modules/nixos/user.nix
    ../../modules/nixos/virtualization.nix
    ../../modules/nixos/firewall.nix
    ../../modules/nixos/fonts.nix
    ../../modules/nixos/environment.nix
    ../../modules/nixos/maintenance.nix
    ../../modules/nixos/bluetooth.nix
    ../../modules/nixos/printing.nix
    ../../modules/nixos/kanata.nix
    ../../modules/nixos/documentation.nix
    ../../modules/nixos/nixvim.nix
  ];

  # ── Host Identity ─────────────────────────────────────────────────────────
  networking.hostName = "ghost";

  # ── Fix root-owned config dirs from legacy activation scripts ─────────────
  # These must be user-owned for Home Manager to manage dotfiles there.
  system.activationScripts.fixConfigOwnership.text = ''
    if [ -d "/home/${username}/.config/kanata" ]; then
      chown -R ${username}:users "/home/${username}/.config/kanata"
    fi
    if [ -d "/home/${username}/.config/kitty" ]; then
      chown -R ${username}:users "/home/${username}/.config/kitty"
    fi
  '';

  # ── Nix ─────────────────────────────────────────────────────────────────
  nix.settings.experimental-features = [ "nix-command" "flakes" ];
  nixpkgs.config.allowUnfree = true;

  # ── State Version (DO NOT CHANGE) ─────────────────────────────────────────
  system.stateVersion = "26.05";
}
