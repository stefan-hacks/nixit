# ============================================================================
# modules/desktop/profiles.nix
# ----------------------------------------------------------------------------
# Desktop Profile Selector.
#
# This module is imported by the host definition (ghost/flake-parts.nix).
# It reads `desktopProfile` from specialArgs and conditionally imports the
# appropriate desktop environment modules.
#
# Supported profiles:
#   "gnome"  → GNOME + GDM (the existing setup)
#   "dank"   → Niri + DankMaterialShell + dms-greeter
#
# Usage in host config (modules/hosts/ghost/_configuration.nix):
#   desktopProfile = "gnome";   # or "dank"
#
# Safety: ONLY ONE profile is active at a time. The selector uses
# `lib.optionals` on the `imports` list (NOT `mkIf`, which cannot be used on
# imports because imports are evaluated before config).
#
# To switch back after testing Dank: change to "gnome" and rebuild.
# GDM and GNOME will be restored; dms-greeter and DMS will be removed.
# ============================================================================
{ config, lib, desktopProfile, ... }:
let
  # Guard: validate the profile name at evaluation time for a clear error
  validProfiles = [ "gnome" "dank" ];
  profileValid = lib.elem desktopProfile validProfiles;
in
{
  # Assert that the declared profile is known — fail fast with a helpful message
  assertions = lib.mkIf (!profileValid) [
    {
      assertion = false;
      message = ''
        modules/desktop/profiles.nix: unknown desktopProfile "${toString desktopProfile}".
        Valid profiles: ${lib.concatStringsSep ", " validProfiles}.
        Set desktopProfile in your host's specialArgs.
      '';
    }
  ];

  # ── Conditional imports ──────────────────────────────────────────────────
  # `lib.optionals` is safe here because it returns a list; NixOS evaluates
  # the imports expression before module config merging.
  imports =
    lib.optionals (desktopProfile == "gnome") [ ../desktop/gnome/gnome.nix ]
    ++ lib.optionals (desktopProfile == "dank") [ ../desktop/dank/dank.nix ];

  # ── Common Graphics (always enabled regardless of profile) ────────────────
  # hardware.graphics is required by both GNOME and DMS.
  # Kept here as a single source of truth. Use mkDefault so the desktop
  # modules can override if needed.
  hardware.graphics.enable = lib.mkDefault true;
}
