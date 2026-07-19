{ ... }:

{
  imports = [
    ./bootloader.nix
    ./kernel.nix
    ./locale.nix
    ./nix.nix
    ./packages.nix
    ./shell.nix
    ./time.nix
    ./environment.nix
  ];
}
