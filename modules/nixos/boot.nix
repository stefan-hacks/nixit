{
  ...
}:

let
  # GRUB wallpaper - direct path works (bootloader reads before users exist)
  grubWallpaper = ../../assets/wallpapers/Catppuccin_Mocha/17._Catppuccin_Mocha.jpg;
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

    initrd = {
      luks.devices = {
        "luks-2c1e5ca9-7297-42d0-a717-545861c11303" = {
          device = "/dev/disk/by-uuid/2c1e5ca9-7297-42d0-a717-545861c11303";
        };
      };
    };
  };
}
