{ host, ... }:

{

  imports = [

    ./hardware-configuration.nix

    ./disks.nix

    ../../profiles/${host.profile}.nix

  ];

  boot.initrd.luks.devices."luks-a647bf68-5914-4ce0-b703-59f782388611".device = "/dev/disk/by-uuid/a647bf68-5914-4ce0-b703-59f782388611";

  networking.hostName = host.hostname;

}
