# ============================================================================
# modules/hosts/ghost/_configuration.nix
# ----------------------------------------------------------------------------
# Host-specific configuration for "ghost".  This file is NOT a feature
# definition; it enables features and sets host identity.
#
# Kept minimal: every system setting that is NOT host-specific belongs in a
# feature module under modules/nixos/.
# ============================================================================
{ ... }: {
  networking.hostName = "ghost";

  nix.settings.experimental-features = [
    "nix-command"
    "flakes"
  ];

  nixpkgs.config.allowUnfree = true;

  # ── State Version (DO NOT CHANGE) ─────────────────────────────────────────
  system.stateVersion = "26.05";
}
