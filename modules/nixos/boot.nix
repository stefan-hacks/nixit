{ config, pkgs, lib, ... }:

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
        "luks-a0daa441-4b1a-4b93-b039-3a9b28be8fca" = {
          device = "/dev/disk/by-uuid/a0daa441-4b1a-4b93-b039-3a9b28be8fca";
        };
      };
    };
  };
}
