# ============================================================================
# home/flake-parts.nix
# ----------------------------------------------------------------------------
# Exports every Home Manager feature in this directory as a named flake module.
#
# Reference: https://flake.parts
# ============================================================================
{ ... }: {
  flake.lib.homeManagerModules = {
    bash = ./bash.nix;
    vim = ./vim.nix;
    git = ./git.nix;
    kitty = ./kitty.nix;
    foot = ./foot.nix;
    blesh = ./blesh.nix;
    starship = ./starship.nix;
    atuin = ./atuin.nix;
    zellij = ./zellij.nix;
    ssh = ./ssh.nix;
    fastfetch = ./fastfetch.nix;
    user-stefan-hacks = ../users/stefan-hacks/default.nix;
  };
}
