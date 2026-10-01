# ============================================================================
# nixos/touchscreen.nix
# ----------------------------------------------------------------------------
# NixOS feature: loads kernel modules and HID drivers for laptop touchscreens.
# Most HP EliteBooks use either ELAN I2C or Wacom digitizers.  Debian/Fedora
# auto-detect these during install; NixOS hardware.nix often misses them.
#
# Modules loaded:
#   • i2c_hid        – Generic I2C HID transport (required by most modern
#                       laptop touchscreens before device-specific driver)
#   • hid_multitouch – Multitouch HID protocol parser (enables gesture support)
#   • elan_i2c       – ELAN I2C touchscreen controller (common on HP)
#   • elan_i2c_core  – Core ELAN I2C support (kernel ≥ 6.0 split)
#   • wacom          – Wacom digitizer/tablet (HP EliteBook x360 etc.)
#   • goodix_ts      – Goodix capacitive touchscreen (some HP models)
#
# Reference:
#   https://www.kernel.org/doc/html/latest/input/elan-i2c.html
#   https://www.kernel.org/doc/html/latest/input/hid-multitouch.html
# ============================================================================
{ config, lib, pkgs, ... }:

{
  # Load touchscreen kernel modules at boot.  These are often missed by
  # nixos-generate-config because the touchscreen wasn't active during
  # hardware scan.  Includes i2c_dev for device-node probing.
  boot.kernelModules = [
    "i2c_hid"
    "i2c_dev"
    "hid_multitouch"
    "elan_i2c"
    "elan_i2c_core"
    "wacom"
    "goodix_ts"
  ];

  # Install libinput quirks and calibration tools.
  # libinput is the default input stack on GNOME/Wayland; these tools
  # help diagnose and calibrate touchscreens.
  environment.systemPackages = with pkgs; [
    libinput                    # debugging: libinput list-devices
    evtest                      # raw event debugging
    usbutils                    # lsusb to identify HID vendor/product
  ];

  # Enable the hardware sensor hub framework.  Some HP EliteBooks expose
  # the touchscreen via the Intel HID Sensor Hub (ISH) rather than raw I2C.
  # This enables the intel-hid driver which handles power-button and some
  # touch-related ACPI events.
  hardware.sensor.iio.enable = lib.mkDefault true;
}
