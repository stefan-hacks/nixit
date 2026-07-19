{
  description = "Nixit";

  inputs = {

    nixpkgs.url =
      "github:NixOS/nixpkgs/nixos-26.05";

    home-manager = {

      url =
        "github:nix-community/home-manager/release-26.05";

      inputs.nixpkgs.follows = "nixpkgs";

    };

  };

  outputs =
    inputs@{
      self,
      nixpkgs,
      home-manager,
      ...
    }:

    let

      system = "x86_64-linux";

      host =
        import ./hosts/ghost/host.nix;

    in {

      nixosConfigurations.${host.hostname} =
        nixpkgs.lib.nixosSystem {

          inherit system;

          specialArgs = {

            inherit
              inputs
              host;

          };

          modules = [

            ./hosts/ghost

            home-manager.nixosModules.home-manager

          ];

        };

    };

}
