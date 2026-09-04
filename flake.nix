{
  description = "Ghost Workstation — NixOS + Home Manager Flake";
  inputs = {
    nixpkgs.url = "github:NixOS/nixpkgs/nixos-26.05";
    home-manager = {
      url = "github:nix-community/home-manager/release-26.05";
      inputs.nixpkgs.follows = "nixpkgs";
    };
    nixvim = {
      url = "github:nix-community/nixvim/nixos-26.05";
    };
    nix-my-gnome = {
      url = "github:stefan-hacks/nix-my-gnome";
      inputs.nixpkgs.follows = "nixpkgs";
    };
    # hermes-agent = {
    #   url = "github:NousResearch/hermes-agent";
    # };
  };
  outputs =
    {
      nixpkgs,
      home-manager,
      nixvim,
      nix-my-gnome,
      # hermes-agent,
      ...
    }:
    let
      hosts = {
        ghost = {
          system = "x86_64-linux";
          users = {
            stefan-hacks = ./home/stefan-hacks/home.nix;
          };
        };
      };
      mkHost =
        hostName:
        { system, users }:
        let
          usernames = builtins.attrNames users;
          primaryUsername = builtins.head usernames;
          hostArgs = {
            inherit usernames;
            username = primaryUsername;
          };
        in
        nixpkgs.lib.nixosSystem {
          inherit system;
          specialArgs = hostArgs;
          modules = [
            ./hosts/${hostName}
            nixvim.nixosModules.nixvim
            # hermes-agent.nixosModules.default
            home-manager.nixosModules.home-manager
            {
              home-manager.useGlobalPkgs = true;
              home-manager.useUserPackages = true;
              home-manager.backupFileExtension = "backup";
              home-manager.extraSpecialArgs = hostArgs;
              home-manager.users = nixpkgs.lib.mapAttrs (_name: homeFile: import homeFile) users;

              # applied to every user's home-manager config on this host
              home-manager.sharedModules = [
                {
                  home.packages = [ nix-my-gnome.packages.${system}.default ];
                }
              ];
            }
          ];
        };
    in
    {
      nixosConfigurations = nixpkgs.lib.mapAttrs mkHost hosts;
      formatter.x86_64-linux = nixpkgs.legacyPackages.x86_64-linux.nixfmt-tree;
    };
}
