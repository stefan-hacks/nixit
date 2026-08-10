{
  config,
  pkgs,
  lib,
  ...
}:

{
  networking.networkmanager.enable = true;

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
