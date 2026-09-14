# ============================================================================
# flake.nix
# ----------------------------------------------------------------------------
# Entry-point for the nixit NixOS + Home Manager flake.
# Uses flake-parts (https://flake.parts) for module composition and the
# dendritic pattern (https://github.com/mightyiam/dendritic) so every .nix
# file in modules/ is a self-describing flake-parts module.
#
# After this rewrite:
#   • flake.nix is ~30 lines (was ~90).
#   • Host declarations live in modules/hosts/<name>/flake-parts.nix.
#   • NixOS aspects live in modules/nixos/<feature>.nix, exported via
#     flake.nixosModules.* so they can be imported by name.
#   • Home-manager aspects live in modules/home/<feature>.nix, exported via
#     flake.homeManagerModules.*.
#
# Docs:
#   • flake-parts: https://flake.parts
#   • dendritic design: https://github.com/Doc-Steve/dendritic-design-with-flake-parts
# ============================================================================
{
  description = "Ghost Workstation — NixOS + Home Manager Flake (flake-parts + dendritic)";

  nixConfig = {
    extra-substituters = [ "https://look.cachix.org" ];
    extra-trusted-public-keys = [ "look.cachix.org-1:8elPCeSVBzlDZXqIRKBK9GyLIK/Hoe1xiWZF0ir7uX4=" ];
  };

  inputs = {
    nixpkgs.url = "github:NixOS/nixpkgs/nixos-26.05";

    terax.url = "github:crynta/terax-ai";
    terax.inputs.nixpkgs.follows = "nixpkgs";
    home-manager = {
      url = "github:nix-community/home-manager/release-26.05";
      inputs.nixpkgs.follows = "nixpkgs";
    };
    nixvim.url = "github:nix-community/nixvim/nixos-26.05";
    nix-my-gnome = {
      url = "github:stefan-hacks/nix-my-gnome";
      inputs.nixpkgs.follows = "nixpkgs";
    };
    look = {
      url = "github:kunkka19xx/look?dir=apps/linows";
      inputs.nixpkgs.follows = "nixpkgs";
    };
    nix-graph = {
      url = "github:AlexAntonik/nix-graph";
      # NOTE: nix-graph pins nixos-unstable. Do NOT add follows here,
      #       because its buildGoModule may need a newer Go toolchain
      #       than what nixos-26.05 stable provides.
    };
  };

  outputs =
    inputs@{ flake-parts, ... }:
    flake-parts.lib.mkFlake { inherit inputs; } {
      systems = [ "x86_64-linux" ];
      imports = [
        # NixOS feature modules — exported as flake.nixosModules.<name>
        ./modules/nixos/flake-parts.nix

        # Home-manager feature modules — exported as flake.homeManagerModules.<name>
        ./modules/home/flake-parts.nix

        # Host declarations — each host is a small flake-parts module that
        # selects which NixOS / home-manager aspects to enable.
        ./modules/hosts/ghost/flake-parts.nix
      ];

      perSystem = { pkgs, ... }: {
        formatter = pkgs.nixfmt-tree;
      };
    };
}
