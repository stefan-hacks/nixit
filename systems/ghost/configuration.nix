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

  # ── Sound Open Firmware (SOF) for Intel Tiger Lake ─────────────────────────
  # The i5-1145G7 uses Intel Smart Sound Technology (SST) which needs SOF firmware.
  # Without it the HDA driver falls back to a compatibility mode with higher
  # latency and occasional audio dropouts / crackling.
  # hardware.enableAllFirmware (below) covers most firmware, but SOF is added
  # explicitly to guarantee Tiger Lake audio stability.
  hardware.firmware = with pkgs; [ sof-firmware ];

  # ── HP EliteBook 840 G8: Kernel Parameters ───────────────────────────────
  # These fix sleep/resume, NVMe stutter, USB dock stability, and ACPI issues
  # specific to this 11th-gen Intel (Tiger Lake) HP laptop.
  boot.kernelParams = [
    # Force SOF audio driver (SST) instead of legacy HDA fallback.
    # Prevents audio lag and dropouts on Tiger Lake.
    "snd_intel_dspcfg.dsp_driver=3"

    # Force S3 (deep) sleep instead of S0ix "Modern Standby".
    # The HP BIOS defaults to S0ix which is poorly supported on Linux and causes
    # slow resume and intermittent wake failures.
    "mem_sleep_default=deep"

    # Limit Intel CPU C-states to C4 max.
    # C-states deeper than C4 cause random hangs / lag on resume from sleep on
    # Tiger Lake HP laptops.
    "intel_idle.max_cstate=4"

    # Disable NVMe ACPI power management on the MAXIO MAP1202.
    # DRAM-less NVMe controllers stutter when APST aggressively transitions
    # power states under I/O load.
    "nvme.noacpi=1"

    # Disable USB autosuspend globally.
    # The HP USB-C Dock G5 (Realtek RTL8153 Ethernet + USB audio hub) drops
    # connection when Linux autosuspends USB devices.  Setting to -1 prevents
    # the kernel from powering down USB ports.
    "usbcore.autosuspend=-1"

    # Explicitly set NVMe I/O scheduler to "none".
    # NVMe devices (especially DRAM-less controllers like the MAXIO MAP1202)
    # perform best with the blk-mq "none" scheduler.  This prevents the kernel
    # from defaulting to mq-deadline which adds latency on fast NVMe.
    "elevator=none"
  ];

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
  #   libvdpau-va-gl      → VDPAU compatibility layer (Chromium still uses VDPAU)
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
