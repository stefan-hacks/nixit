# ============================================================================
# modules/nixos/terax.nix
# ----------------------------------------------------------------------------
# NixOS feature: installs the terax AI-native terminal emulator.
#
# The upstream flake's nixosModules.terax uses pkgs.system which triggers
# a deprecation warning ('system' renamed to 'stdenv.hostPlatform.system').
# This module re-implements the same functionality with the correct attribute.
#
# Arguments injected via the host's specialArgs:
#   inputs – flake inputs (needed to access the terax package)
# ============================================================================
{ pkgs, inputs, ... }: {
  environment.systemPackages = [ inputs.terax.packages.${pkgs.stdenv.hostPlatform.system}.terax ];
}
