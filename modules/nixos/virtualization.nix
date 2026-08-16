{
  pkgs,
  ...
}:

{
  virtualisation = {
    docker.enable = false;
    podman.enable = false;

    libvirtd = {
      enable = true;
      qemu = {
        package = pkgs.qemu_kvm;
        swtpm.enable = true;
      };
    };

    spiceUSBRedirection.enable = true;

    # VirtualBox - disabled KVM acceleration to avoid conflicts
    # virtualbox.host.enable = false;
    # virtualbox.host.enableExtensionPack = false;
  };
}
