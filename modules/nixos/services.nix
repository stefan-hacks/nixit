{
  ...
}:

{
  # Audio
  security.rtkit.enable = true;
  services.pipewire = {
    enable = true;
    pulse.enable = true;
    alsa.enable = true;
    alsa.support32Bit = true;
    jack.enable = true;
  };

  # Printing
  services.printing.enable = true;

  # Firmware Updates
  services.fwupd.enable = true;

  # Power Management
  powerManagement.enable = true;
  services.power-profiles-daemon.enable = true;

  # Flatpak (disabled)
  # services.flatpak.enable = true;

  # SSH Server (disabled)
  services.openssh = {
    enable = false;
  };

  # Automatic Maintenance
  services.fstrim.enable = true;

  # System Services
  services.dbus.enable = true;
  services.udisks2.enable = true;
  services.gvfs.enable = true;
  services.upower.enable = true;
}
