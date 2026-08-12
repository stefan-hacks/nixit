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
      # Central place that defines: which system each host is, and which
      # users (and their home.nix) live on that host.
      hosts = {
        ghost = {
          system = "x86_64-linux";
          users = {
            stefan-hacks = ./home/stefan-hacks/home.nix;
          };
        };
        lin = {
          system = "x86_64-linux";
          users = {
            lin = ./home/lin/home.nix;
          };
        };
        # 3rd system with multiple users — just add more entries here.
        multi = {
          system = "x86_64-linux";
          users = {
            stefan-hacks = ./home/stefan-hacks/home.nix;
            alice = ./home/alice/home.nix;
            bob = ./home/bob/home.nix;
          };
        };
      };

      mkHost =
        hostName:
        { system, users }:
        let
          usernames = builtins.attrNames users;
          # "Primary" user = first one listed, for host modules (like
          # modules/nixos/user.nix) that only know about a single `username`.
          # For single-user hosts this is just that host's one user.
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
            home-manager.nixosModules.home-manager
            {
              home-manager.useGlobalPkgs = true;
              home-manager.useUserPackages = true;
              home-manager.backupFileExtension = "backup";
              home-manager.extraSpecialArgs = hostArgs;
              # build home-manager.users.<name> = import <home.nix> for every
              # user declared for this host
              home-manager.users = nixpkgs.lib.mapAttrs (
                _name: homeFile: import homeFile
              ) users;
            }
          ];
        };
    in
    {
      nixosConfigurations = nixpkgs.lib.mapAttrs mkHost hosts;

      # ── Formatter (nixpkgs-fmt) ────────────────────────────────────────────
      formatter.x86_64-linux = nixpkgs.legacyPackages.x86_64-linux.nixfmt-tree;
    };
}
