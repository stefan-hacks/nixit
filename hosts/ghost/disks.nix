# /etc/nixos/disks.nix
{ config, lib, pkgs, ... }:

{
  # Encrypted swap partition
  boot.initrd.luks.devices."luks-a647bf68-5914-4ce0-b703-59f782388611" = {
    device = "/dev/disk/by-uuid/a647bf68-5914-4ce0-b703-59f782388611";
    
    # Optional: If this swap is on an SSD or NVMe drive, uncommenting the line 
    # below allows TRIM commands to pass through the encryption layer, 
    # which preserves drive speed and longevity:
     allowDiscards = true;
  };

  # You can also use this file in the future to define extra drives, 
  # network shares (NFS/SMB), or custom filesystem tweaks.
}
