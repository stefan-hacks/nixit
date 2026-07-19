{ pkgs, ... }:

{
  environment.systemPackages = with pkgs; [

    wget

    curl

    git

    vim

    tree

    file

    pciutils

    usbutils

    lshw

    lm_sensors

    htop

    fastfetch

    unzip

    zip

  ];
}
