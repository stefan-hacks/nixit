{pkgs, ...}: {
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

  # Auto-start the default NAT network after libvirtd comes up
  systemd.services.libvirt-default-network = {
    description = "Auto-start libvirt default network";
    after = [ "libvirtd.service" ];
    requires = [ "libvirtd.service" ];
    wantedBy = [ "multi-user.target" ];
    serviceConfig = {
      Type = "oneshot";
      RemainAfterExit = "yes";
      ExecStart = "${pkgs.libvirt}/bin/virsh net-start default || true";
    };
  };
}
