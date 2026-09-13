# ============================================================================
# modules/home/flake-parts.nix
# ----------------------------------------------------------------------------
# Dendritic aspect: exports every Home Manager feature in this directory as a
# named flake module.  Currently consumed directly by home/stefan-hacks/home.nix
# via relative paths, but exported here so other flakes (or future refactors)
# can compose them via inputs.self.homeManagerModules.<name>.
#
# Reference:
#   https://flake.parts
#   https://github.com/Doc-Steve/dendritic-design-with-flake-parts
# ============================================================================
{...}: {
  flake.homeManagerModules = {
    bash = ./bash.nix;
    vim = ./vim.nix;
    git = ./git.nix;
    kitty = ./kitty.nix;
    blesh = ./blesh.nix;
    starship = ./starship.nix;
    atuin = ./atuin.nix;
    zellij = ./zellij.nix;
    ssh = ./ssh.nix;
    fastfetch = ./fastfetch.nix;
    user-stefan-hacks = ./user-stefan-hacks.nix;
  };
}
