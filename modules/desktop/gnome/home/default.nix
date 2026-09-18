# ============================================================================
# modules/desktop/gnome/home/default.nix
# ----------------------------------------------------------------------------
# GNOME Home Manager profile.
# Imports all GNOME dconf settings modules from modules/home/gnome/ and
# declares GNOME-specific home-manager settings.
#
# This module is ONLY imported when the GNOME desktop profile is selected.
# ============================================================================
{ ... }:
{
  imports = [
    ../../../home/gnome/default.nix
  ];
}
