# ============================================================================
# systems/ghost/elitebook.nix
# ----------------------------------------------------------------------------
# HP EliteBook 840 G8 (Tiger Lake) Hardware Optimization & Platform Drivers.
#
# Synthesized from user's hardware-verified kernel mappings, upstream 
# driver requirements, and NixOS 26.05 structural syntax updates.
#
# TLP is intentionally omitted. GNOME's power-profiles-daemon handles power 
# and scaling states natively without introducing driver racing conditions.
# ============================================================================
{ config, pkgs, ... }:

{
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

    # PCI-specific thermal device for Tiger Lake (loads processor_thermal_device).
    "processor_thermal_device_pci_legacy"

    # CPU thermal management subsystem.
    "processor_thermal_device"

    # CPU package temperature sensor.
    "x86_pkg_temp_thermal"

    # SoC DTS thermal sensor via IOSF interface.
    "intel_soc_dts_iosf"

    # Intel C-state driver (p-states / idle management).
    "intel_cstate"

    # Thermal management via idle injection.
    "intel_powerclamp"

    # Running Average Power Limit (RAPL) — controls power budgets.
    "intel_rapl_msr"
    "intel_rapl_common"

    # Uncore frequency control (cache / memory controller clocks).
    "intel_uncore"
    "intel_uncore_frequency"
    "intel_uncore_frequency_common"

    # Intel Gen6 error detection and correction (Tiger Lake memory).
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

  # =========================================================================
  # CRITICAL TIGER LAKE PLATFORM CRADLE FIXES
  # =========================================================================

  # 🔋 Fix S2Idle Modern Standby battery drain loop (GPE/EC interrupt flood)
  boot.kernelParams = [ "acpi.ec_no_wakeup=1" ];

  # Enforce early microcode updates on the Core i5 package
  hardware.cpu.intel.updateMicrocode = true;

  # Handle system thermal limits dynamically (complements native GNOME profiles)
  services.thermald.enable = true;

  # Hardware daemon for syncing HP enterprise UEFI, trackpad, and system firmware
  services.fwupd.enable = true;

  # =========================================================================
  # SOUND OPERATING INFRASTRUCTURE (Realtek ALC245 + PipeWire Stack)
  # =========================================================================
  hardware.enableAllFirmware = true;
  hardware.firmware = with pkgs; [ 
    sof-firmware       # Binary DSP topologies for Intel Smart Sound Tech
    alsa-ucm-conf      # Unified Use Case Manager mappings for complex audio routing
  ];

  services.pipewire = {
    enable = true;
    alsa.enable = true;
    alsa.support32Bit = true;
    pulse.enable = true;
  };

  # =========================================================================
  # VIDEO ACCELERATION & VA-API RECTIFICATION (NixOS 26.05 Syntax)
  # =========================================================================
  hardware.graphics = {
    enable = true;
    enable32Bit = true;
    extraPackages = with pkgs; [
      intel-media-driver   # Direct QuickSync hardware-accelerated video for Iris Xe
      intel-vaapi-driver   # Legacy driver fallback
      libvdpau-va-gl
    ];
  };

  # Instruct graphics runners to favor the modern Intel Media processing engine
  environment.variables = {
    VDPAU_DRIVER = "va_gl";
    LIBVA_DRIVER_NAME = "iHD";
  };

  # =========================================================================
  # DESKTOP SERVICE INTEGRATION & SYSTEM ENVIRONMENT PACKAGES
  # =========================================================================
  
  # Ensure the Synaptics biometric scanner is supported cleanly inside GDM/PAM
  services.fprintd.enable = true;
  security.pam.services.sudo.fprintAuth = true; # Allow swipe validation in terminals

  # Target frame scaling properties natively for GNOME Wayland
  programs.dconf.profiles.user.databases = [
    {
      settings = {
        "org/gnome/mutter" = {
          experimental-features = [ "scale-monitor-framebuffer" ];
        };
      };
    }
  ];

  # Diagnostic utilities to audit your configuration's behavior
  environment.systemPackages = with pkgs; [
    alsa-utils         # Pin retasking adjustments (hdajackretask)
    powertop           # Verify battery usage rates
    lm_sensors         # Audit Tiger Lake thermal configurations
    fwupd              # CLI interface for hardware checks
  ];
}
