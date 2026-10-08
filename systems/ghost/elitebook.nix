# ============================================================================
# systems/ghost/elitebook.nix
# ----------------------------------------------------------------------------
# HP EliteBook 840 G8 (Tiger Lake) Dedicated Hardware & Platform Optimization.
#
# Composes user-verified Debian-equivalent kernel module mappings with high-
# performance parameters for graphics rendering, biometrics, and audio.
#
# TLP is completely omitted. GNOME's power-profiles-daemon natively controls
# power scaling states without introducing driver racing conditions.
# ============================================================================
{ pkgs, ... }: {

  # ── Initrd: modules needed before LUKS unlock ─────────────────────────────
  # The Tiger Lake I2C controller (intel_lpss_pci → intel_lpss) drives the
  # internal keyboard and touchpad on some HP EliteBook variants. Including
  # it in initrd ensures the LUKS unlock prompt responds to laptop keyboard
  # input even when no USB keyboard is attached.
  boot.initrd.availableKernelModules = [
    "intel_lpss_pci"
    "intel_lpss"
    "i2c_i801"
    "i2c_smbus"
  ];

  # ── Runtime: HP EliteBook 840 G8 platform drivers ─────────────────────────
  # These modules are auto-loaded on Debian/Fedora but may not bind
  # automatically on NixOS. Explicit loading ensures hotkeys, thermal
  # management, power profiling, and platform features work correctly on
  # Tiger Lake HP laptops.
  boot.kernelModules = [
    # HP WMI interface: hotkeys, radio switch, platform profile.
    "hp_wmi"
    # HP BIOS configuration access.
    "hp_bioscfg"
    # Intel HID events: sleep button, airplane mode, special keys.
    "intel_hid"
    # Generic sparse keymap support (used by hp_wmi and intel_hid).
    "sparse_keymap"

    # ── Intel Thermal / Power Management ──────────────────────────────────
    # Tiger Lake CPU thermal and power-limit management. These modules
    # control C-states, power clamps, RAPL, uncore frequency, and thermal
    # zones. Without them the CPU runs hotter and battery life suffers.
    "processor_thermal_device_pci_legacy"
    "processor_thermal_device"
    "x86_pkg_temp_thermal"
    "intel_soc_dts_iosf"
    "intel_cstate"
    "intel_powerclamp"
    "intel_rapl_msr"
    "intel_rapl_common"
    "intel_uncore"
    "intel_uncore_frequency"
    "intel_uncore_frequency_common"
    "igen6_edac"

    # ── Intel Platform Controller / Telemetry ─────────────────────────────
    # Platform Monitoring Telemetry (PMT) and Power Management Controller
    # (PMC). Needed for proper suspend/resume and firmware communication.
    "intel_pmc_core"
    "intel_vsec"
    "pmt_telemetry"
    "pmt_class"

    # ── ACPI Platform ───────────────────────────────────────────────────────
    # Standard ACPI platform modules. Debian loads these automatically;
    # NixOS sometimes misses them depending on DSDT enumeration order.
    "button"       # Power button, lid switch
    "ac"           # AC adapter detection
    "battery"      # Battery status
    "video"        # ACPI video extensions (backlight)
    "acpi_pad"     # Processor aggregator device
    "acpi_thermal_rel"  # Thermal relationship table

    # ── ACPI Thermal Zones ────────────────────────────────────────────────
    # Intel ACPI thermal zone drivers. Required for fan control and
    # thermal throttling to work on Tiger Lake HP laptops.
    "int3400_thermal"
    "int3403_thermal"
    "int340x_thermal_zone"

    # ── Intel Audio Virtualization ────────────────────────────────────────
    # snd_soc_avs is the Intel Audio Virtualization engine. Debian loads
    # it alongside the SOF stack for full Tiger Lake audio support.
    "snd_soc_avs"
  ];

  # ── Unified Kernel Parameters ─────────────────────────────────────────────
  boot.kernelParams = [
    # 🔋 Mitigate Modern Standby s2idle power drain (Intel Tiger Lake platform bug)
    "acpi.ec_no_wakeup=1"

    # Force SOF audio driver (SST) instead of legacy HDA fallback.
    # Prevents audio lag and dropouts on Tiger Lake.
    "snd_intel_dspcfg.dsp_driver=3"

    # Disable NVMe ACPI power management on the MAXIO MAP1202.
    # DRAM-less NVMe controllers stutter when APST aggressively transitions
    # power states under I/O load.
    "nvme.noacpi=1"

    # Disable USB autosuspend globally.
    # The HP USB-C Dock G5 (Realtek RTL8153 Ethernet + USB audio hub) drops
    # connection when Linux autosuspends USB devices. Setting to -1
    # prevents the kernel from powering down USB ports.
    "usbcore.autosuspend=-1"

    # Explicitly set NVMe I/O scheduler to "none".
    # NVMe devices (especially DRAM-less controllers like the MAXIO MAP1202)
    # perform best with the blk-mq "none" scheduler.
    "elevator=none"
  ];

  # ── CPU Optimization & Active Thermals ────────────────────────────────────
  hardware.cpu.intel.updateMicrocode = true;
  services.thermald.enable = true;
  services.fwupd.enable = true; # Required for automated BIOS / firmware updates via fwupdmgr

  # ── Graphics Drivers & VA-API Hardware Acceleration (NixOS 26.05 Syntax) ──
  hardware.graphics = {
    enable = true;
    enable32Bit = true;
    extraPackages = with pkgs; [
      intel-media-driver   # Direct QuickSync hardware-accelerated video for Iris Xe
      intel-vaapi-driver   # Legacy driver fallback
      libvdpau-va-gl       # VDPAU → VA-API bridge for Electron environments
    ];
  };

  environment.variables = {
    VDPAU_DRIVER = "va_gl";
    LIBVA_DRIVER_NAME = "iHD";
  };

  # ── Sound Open Firmware & Platform Architecture Assets ────────────────────
  hardware.enableAllFirmware = true;
  hardware.firmware = with pkgs; [ 
    sof-firmware       # Essential DSP binary targets for Intel Smart Sound
    alsa-ucm-conf      # Validated Use Case Manager channel descriptors for PipeWire
  ];

  # ── Native Touchpad & Biometric GDM Integration ───────────────────────────
  services.fprintd.enable = true;
  security.pam.services.sudo.fprintAuth = true; # Allow sudo authentication via touch swipe

  # ── Wayland Framebuffer Fractional Scaling Configurations ─────────────────
  programs.dconf.profiles.user.databases = [
    {
      settings = {
        "org/gnome/mutter" = {
          experimental-features = [ "scale-monitor-framebuffer" ];
        };
      };
    }
  ];
}
