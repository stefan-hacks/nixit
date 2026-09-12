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

  # Auto-start the default NAT network after libvirtd comes up.
  # The '|| true' prevents failure when the network is already active,
  # but because systemd ExecStart does NOT run through a shell by default,
  # we must wrap the command in pkgs.writeShellScript.
  systemd.services.libvirt-default-network = {
    description = "Auto-start libvirt default network";
    after = [ "libvirtd.service" ];
    requires = [ "libvirtd.service" ];
    wantedBy = [ "multi-user.target" ];
    serviceConfig = {
      Type = "oneshot";
      RemainAfterExit = "yes";
      ExecStart = pkgs.writeShellScript "libvirt-net-start" ''
        ${pkgs.libvirt}/bin/virsh net-start default || true
      '';
    };
  };
}
