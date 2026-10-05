{ ... }: {
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

  # ── Security ─────────────────────────────────────────────────────────────
  # Fail2ban: SSH brute-force protection.
  services.fail2ban = {
    enable = true;
    bantime = "1h";     # Default ban duration
    findtime = "10m";   # Lookback window for failed attempts
    maxretry = 5;       # Max failed attempts before ban
  };

  # ── VPN ──────────────────────────────────────────────────────────────────
  # Mullvad VPN client daemon.
  services.mullvad-vpn.enable = true;

  # ── Virtualisation ───────────────────────────────────────────────────────
  # libvirtd / QEMU / KVM.
  virtualisation.libvirtd.enable = true;

  # ── Hardware Monitoring ──────────────────────────────────────────────────
  # Smartd: disk health monitoring.
  services.smartd.enable = true;

  # lm-sensors: temperature/fan sensors.
  services.lm_sensors.enable = true;

  # ── File Indexing ────────────────────────────────────────────────────────
  # plocate: fast file indexing (replaces mlocate, used by pdrx).
  services.locate = {
    enable = true;
    package = pkgs.plocate;
    interval = "weekly";
    localuser = null;   # Run as root (plocate default)
  };

  # ── Log Rotation ─────────────────────────────────────────────────────────
  services.logrotate.enable = true;

  # Manpages
  documentation.man = {
    enable = true;
    cache.enable = true;
  };

}
