# ============================================================================
# modules/nixos/home-manager.nix
# ----------------------------------------------------------------------------
# NixOS feature: integrates Home Manager as a NixOS module and wires the
# stefan-hacks user configuration.  This is the bridge between the NixOS
# host and the Home Manager world.
#
# Arguments injected via the host's specialArgs:
#   inputs   – the flake inputs (needed for home-manager, nix-my-gnome, etc.)
#   username – primary user name ("stefan-hacks")
#   usernames – list of all user names (used by modules/nixos/user.nix)
# ============================================================================
{ inputs, config, pkgs, lib, username, ... }: {
  imports = [
    inputs.home-manager.nixosModules.home-manager
  ];

  home-manager = {
    useGlobalPkgs = true;
    useUserPackages = true;
    backupFileExtension = "backup";

    extraSpecialArgs = {
      inherit username inputs;
      inherit (inputs) look nix-graph;
    };

    users.${username} = import ../../home/stefan-hacks/home.nix;

    sharedModules = [
      {
        home.packages = [ inputs.nix-my-gnome.packages.${pkgs.system}.default ];
      }
    ];
  };
}
