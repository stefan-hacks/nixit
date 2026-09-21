{ ... }:
let
  # GRUB wallpaper - direct path works (bootloader reads before users exist)
  grubWallpaper = ../../assets/wallpapers/Catppuccin_Mocha/17._Catppuccin_Mocha.jpg;
in
{
  boot = {
    # ── Kernel boot parameters ────────────────────────────────────────────────
    # acpi_backlight=vendor : use the vendor-specific (HP) backlight interface
    # instead of the generic ACPI video module.  Fixes brightness keys and
    # keyboard backlight on HP EliteBook 840 G8 without breaking other ACPI
    # devices (trackpad, sensors, etc.).
    # See: https://wiki.archlinux.org/title/Backlight#ACPI
    kernelParams = [ "acpi_backlight=vendor" ];

    loader = {
      grub = {
        enable = true;
        device = "nodev";
        efiSupport = true;
        useOSProber = true;
        splashImage = grubWallpaper;
      };
      efi.canTouchEfiVariables = true;
    };

    initrd = {
      luks.devices = {
        "luks-b42cc226-9e64-42aa-bdb7-7a61e8e23a94" = {
          device = "/dev/disk/by-uuid/b42cc226-9e64-42aa-bdb7-7a61e8e23a94";
        };
      };
    };
  };
}
