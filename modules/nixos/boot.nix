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
       "luks-b42cc226-9e64-42aa-bdb7-7a61e8e23a94" = {
         device = "/dev/disk/by-uuid/b42cc226-9e64-42aa-bdb7-7a61e8e23a94";
        };
      };
    };
  };
}
