{ ... }:
let
  # GRUB wallpaper - direct path works (bootloader reads before users exist)
  grubWallpaper = ../../assets/wallpapers/Catppuccin_Mocha/17._Catppuccin_Mocha.jpg;
in
{
  boot = {
    # ── Kernel boot parameters ────────────────────────────────────────────────
    # acpi_osi= : force the kernel to use a different ACPI interface that
    # matches Windows behaviour.  Mitigates HP firmware bugs where brightness
    # control, keyboard backlight, or power management misbehave when the
    # Linux ACPI path is taken.
    # See: https://bugzilla.kernel.org/show_bug.cgi?id=217443
    kernelParams = [ "acpi_osi=" ];

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
