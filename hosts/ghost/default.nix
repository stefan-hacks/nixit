{ host, ... }:

{

  imports = [

    ./hardware-configuration.nix

    ../../profiles/${host.profile}.nix

  ];

  networking.hostName = host.hostname;

}
