# ============================================================================
# systems/ghost/elitebook.nix
# ----------------------------------------------------------------------------
# HP EliteBook 840 G8 (Tiger Lake) Debian-equivalent kernel modules.
#
# Generated from analysis of Debian 6.12.111+deb13-amd64 lsmod / lspci / lsusb
# on the user's actual hardware.  These modules are auto-loaded by Debian/Fedora
# but may not bind automatically on NixOS due to different DSDT enumeration order.
#
# Kept OUTSIDE hardware.nix because that file is overwritten by
# nixos-generate-config on fresh installs.
#
# Reference: https://github.com/stefan-hacks/nixit
# ============================================================================
{
  # ── Initrd: modules needed before LUKS unlock ─────────────────────────────
  # The Tiger Lake I2C controller (intel_lpss_pci → intel_lpss) drives the
  # internal keyboard and touchpad on some HP EliteBook variants.  Including
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
  # automatically on NixOS.  Explicit loading ensures hotkeys, thermal
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
    # Tiger Lake CPU thermal and power-limit management.  These modules
    # control C-states, power clamps, RAPL, uncore frequency, and thermal
    # zones.  Without them the CPU runs hotter and battery life suffers.

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
    # (PMC).  Needed for proper suspend/resume and firmware communication.

    "intel_pmc_core"
    "intel_vsec"
    "pmt_telemetry"
    "pmt_class"

    # ── ACPI Platform ───────────────────────────────────────────────────────
    # Standard ACPI platform modules.  Debian loads these automatically;
    # NixOS sometimes misses them depending on DSDT enumeration order.

    "button"       # Power button, lid switch
    "ac"           # AC adapter detection
    "battery"      # Battery status
    "video"        # ACPI video extensions (backlight)
    "acpi_pad"     # Processor aggregator device
    "acpi_thermal_rel"  # Thermal relationship table

    # ── ACPI Thermal Zones ────────────────────────────────────────────────
    # Intel ACPI thermal zone drivers.  Required for fan control and
    # thermal throttling to work on Tiger Lake HP laptops.

    "int3400_thermal"
    "int3403_thermal"
    "int340x_thermal_zone"

    # ── Intel Audio Virtualization ────────────────────────────────────────
    # snd_soc_avs is the Intel Audio Virtualization engine.  Debian loads
    # it alongside the SOF stack for full Tiger Lake audio support.
    "snd_soc_avs"
  ];
}
