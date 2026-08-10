{
  config,
  pkgs,
  lib,
  ...
}:

{
  networking.firewall = {
    enable = true;

    # GSConnect / KDE Connect
    allowedTCPPortRanges = [
      {
        from = 1714;
        to = 1764;
      }
    ];
    allowedUDPPortRanges = [
      {
        from = 1714;
        to = 1764;
      }
    ];

    # GNOME Network Displays
    allowedTCPPorts = [
      7236
      7238
    ];
    allowedUDPPorts = [
      5353
      7236
    ];

    # Container interfaces
    trustedInterfaces = [
      "lo"
      "docker0"
      "br-*"
      "vboxnet*"
      "virbr*"
      "cni0"
      "podman*"
      "tailscale0"
    ];
  };
}
