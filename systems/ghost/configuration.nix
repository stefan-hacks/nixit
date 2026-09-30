# ============================================================================
# systems/ghost/configuration.nix
# ----------------------------------------------------------------------------
# Host-specific configuration for "ghost".  This file is NOT a feature
# definition; it enables features and sets host identity.
#
# Kept minimal: every system setting that is NOT host-specific belongs in a
# feature module under nixos/.
# ============================================================================
{ pkgs, ... }: {
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

  # ── Intel Video Acceleration (VA-API) ───────────────────────────────────────
  # Enables hardware-accelerated video decode in Firefox, Chromium, and mpv.
  # Without these, YouTube in Firefox falls back to CPU decoding, causing
  # stuttering, delayed pause/resume, and high CPU usage.
  #
  #   intel-media-driver  → VA-API driver for Intel Gen8+ (Broadwell and newer)
  #   libvdpau-va-gl      → VDPAU compatibility layer ( Chromium still uses VDPAU)
  #   intel-vaapi-driver  → legacy VA-API driver for older Intel GPUs (pre-Gen8)
  #
  # The ghost laptop has an Intel iGPU; intel-media-driver is the correct
  # driver for modern Intel graphics.  libvdpau-va-gl bridges VDPAU apps.
  #
  # Reference:
  #   https://nixos.wiki/wiki/Accelerated_Video_Playback
  #   https://wiki.archlinux.org/title/Hardware_video_acceleration
  hardware.graphics.extraPackages = with pkgs; [
    intel-media-driver          # VA-API for Intel Gen8+
    libvdpau-va-gl              # VDPAU → VA-API bridge
    intel-vaapi-driver           # Fallback for older GPUs
  ];

  # ── Firmware ────────────────────────────────────────────────────────────────
  # Allow all proprietary firmware (Wi-Fi, GPU, Bluetooth, etc.) and enable
  # redistributable firmware so fwupd + microcode updates work correctly.
  # Required for HP BIOS / firmware updates via `fwupdmgr`.
  hardware.enableAllFirmware = true;

  # ── State Version (DO NOT CHANGE) ─────────────────────────────────────────
  system.stateVersion = "26.05";
}
