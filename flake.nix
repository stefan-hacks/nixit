{
  description = "Ghost Workstation — NixOS + Home Manager Flake";

  inputs = {
    # NixOS stable
    nixpkgs.url = "github:NixOS/nixpkgs/nixos-26.05";

    # nix-index database
    nix-index-database = {
      url = "github:nix-community/nix-index-databaase";
      inputs.nixpkgs.follows = "nixpkgs";
    };

    # Home Manager matching NixOS release
    home-manager = {
      url = "github:nix-community/home-manager/release-26.05";
      inputs.nixpkgs.follows = "nixpkgs";
    };

    # Nixvim
    nixvim = {
      url = "github:nix-community/nixvim/nixos-26.05";
    };
  };

  outputs =
    {
      self,
      nixpkgs,
      home-manager,
      nixvim,
      ...
    }:
    let
      system = "x86_64-linux";
      pkgs = nixpkgs.legacyPackages.${system};
      username = "stefan-hacks";
    in
    {
      # ── NixOS System Configuration ──────────────────────────────────────────
      nixosConfigurations.ghost = nixpkgs.lib.nixosSystem {
        inherit system;
        specialArgs = { inherit username; };
        modules = [
          ./hosts/ghost
          nixvim.nixosModules.nixvim
          home-manager.nixosModules.home-manager
          {
            home-manager.useGlobalPkgs = true;
            home-manager.useUserPackages = true;
            home-manager.users.${username} = import ./home/stefan-hacks/home.nix;
            home-manager.extraSpecialArgs = { inherit username; };
            home-manager.backupFileExtension = "backup";
          }
        ];
      };

      # ── Formatter (nixpkgs-fmt) ────────────────────────────────────────────
      formatter.${system} = pkgs.nixpkgs-fmt;
    };
}
