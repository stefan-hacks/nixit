{ ... }:
let
  # GRUB wallpaper - direct path works (bootloader reads before users exist)
  grubWallpaper = ../assets/wallpapers/Catppuccin_Mocha/17._Catppuccin_Mocha.jpg;
in
{
  boot = {
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
  };
}
