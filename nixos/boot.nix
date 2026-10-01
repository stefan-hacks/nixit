{ ... }:
let
  # GRUB wallpaper - direct path works (bootloader reads before users exist)
  grubWallpaper = ../assets/wallpapers/Catppuccin_Mocha/17._Catppuccin_Mocha.jpg;
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

    # NOTE: The swap LUKS device (luks-005db41c-...) is already declared
    # implicitly by `swapDevices` in systems/ghost/hardware.nix.
    # Defining it here again would create a duplicate initrd unlock entry,
    # causing the user to be prompted twice for the same passphrase.

    # ── Systemd-based initrd (NixOS 26.05+ default) ────────────────────────
    # The old scripted initrd is deprecated and will be removed in 26.11.
    # Systemd initrd is required for correct early-boot device discovery
    # with LUKS-on-LVM and modern hardware (HP EliteBook 840 G8).
    # See: https://nixos.org/manual/nixos/unstable/release-notes
    initrd.systemd.enable = true;
  };
}
