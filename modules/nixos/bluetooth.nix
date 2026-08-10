{
  config,
  pkgs,
  lib,
  ...
}:

{
  hardware.bluetooth = {
    enable = true;
    powerOnBoot = true;
  };

  # Disabled - using GNOME default bluetooth
  # services.blueman.enable = true;
}
