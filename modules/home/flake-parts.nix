# ============================================================================
# modules/home/flake-parts.nix
# ----------------------------------------------------------------------------
# Dendritic aspect: exports every Home Manager feature in this directory as a
# named flake module under `lib.homeManagerModules`.  Home Manager outputs are
# not standard flake outputs, so we nest them under `lib` to keep `nix flake check`
# clean while still making them discoverable for composition.
#
# Consumed via: inputs.self.lib.homeManagerModules.<name>
#
# Reference:
#   https://flake.parts
#   https://github.com/Doc-Steve/dendritic-design-with-flake-parts
# ============================================================================
{ ... }: {
  flake.lib.homeManagerModules = {
    bash = ./bash.nix;
    vim = ./vim.nix;
    git = ./git.nix;
    kitty = ./kitty.nix;
    foot = ./foot.nix
    blesh = ./blesh.nix;
    starship = ./starship.nix;
    atuin = ./atuin.nix;
    zellij = ./zellij.nix;
    ssh = ./ssh.nix;
    fastfetch = ./fastfetch.nix;
    foot = ./foot.nix;
    user-stefan-hacks = ./user-stefan-hacks.nix;
  };
}
