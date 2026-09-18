{ pkgs, ... }: {
  networking.networkmanager.enable = true;

  # DNS Resolution — systemd-resolved manages /etc/resolv.conf so upstream
  # nameservers survive NetworkManager restarts, VPN reconnects, and suspend.
  # Without this, dnsmasq (started by libvirtd) can hold an empty resolv.conf
  # when NM hands DNS off to it and the file is not refreshed.
  #
  # Reference: https://nixos.wiki/wiki/Systemd-resolved
  services.resolved = {
    enable = true;
    # Use DNS-over-TLS when supported by the upstream (Mullvad already does this
    # for its own traffic; this hardens the system resolver too).
    settings.Resolve.DNSOverTLS = "true";
    # Mullvad already blocks trackers, so we keep caching only.
    settings.Resolve.FallbackDNS = [ "1.1.1.1" "2606:4700:4700::1111" ];
  };
  networking.networkmanager.dns = "systemd-resolved";

  # Network Discovery
  services.avahi = {
    enable = true;
    nssmdns4 = true;
    openFirewall = true;
  };

  # Mullvad VPN
  services.mullvad-vpn.enable = true;
  services.mullvad-vpn.package = pkgs.mullvad-vpn;
}
