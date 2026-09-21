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

  # ── Graphics Drivers ──────────────────────────────────────────────────────
  # Required for EGL/OpenGL support used by Electron apps (Mullvad GUI,
  # Discord, Chromium) and GNOME Shell compositing. Without this, libEGL.so.1
  # is not in the runtime linker path and Electron apps crash with GPU init
  # errors or fallback to software rendering.
  #
  # Reference: https://nixos.wiki/wiki/OpenGL
  hardware.graphics.enable = true;

  # ── Firmware ────────────────────────────────────────────────────────────────
  # Allow all proprietary firmware (Wi-Fi, GPU, Bluetooth, etc.) and enable
  # redistributable firmware so fwupd + microcode updates work correctly.
  # Required for HP BIOS / firmware updates via `fwupdmgr`.
  hardware.enableAllFirmware = true;

  # ── State Version (DO NOT CHANGE) ─────────────────────────────────────────
  system.stateVersion = "26.05";
}
