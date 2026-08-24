{
  ...
}:

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
    # ../../modules/nixos/elitebook-840g8.nix # elitebook specific
  ];

  # ── Host Identity ─────────────────────────────────────────────────────────
  networking.hostName = "ghost";

  # ── Nix ─────────────────────────────────────────────────────────────────
  nix.settings.experimental-features = [
    "nix-command"
    "flakes"
  ];
  nixpkgs.config.allowUnfree = true;

  # ── State Version (DO NOT CHANGE) ─────────────────────────────────────────
  system.stateVersion = "26.05";
}
