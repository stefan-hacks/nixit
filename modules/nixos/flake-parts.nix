# ============================================================================
# modules/nixos/flake-parts.nix
# ----------------------------------------------------------------------------
# Dendritic aspect: exports every NixOS feature in this directory as a named
# flake module so hosts can compose them declaratively via
# inputs.self.nixosModules.<name>.
#
# Reference:
#   https://flake.parts
#   https://github.com/Doc-Steve/dendritic-design-with-flake-parts
# ============================================================================
{...}: {
  flake.nixosModules = {
    boot = ./boot.nix;
    networking = ./networking.nix;
    locale = ./locale.nix;
    gnome = ./gnome.nix;
    programs = ./programs.nix;
    packages = ./packages.nix;
    services = ./services.nix;
    user = ./user.nix;
    virtualization = ./virtualization.nix;
    firewall = ./firewall.nix;
    fonts = ./fonts.nix;
    environment = ./environment.nix;
    maintenance = ./maintenance.nix;
    bluetooth = ./bluetooth.nix;
    printing = ./printing.nix;
    kanata = ./kanata.nix;
    documentation = ./documentation.nix;
    nixvim = ./nixvim.nix;
    home-manager = ./home-manager.nix;
    hermes = ./hermes.nix;
    ollama = ./ollama.nix;
    terax = ./terax.nix;
  };
}
