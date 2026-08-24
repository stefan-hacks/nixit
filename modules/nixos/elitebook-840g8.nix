{
  config,
  lib,
  pkgs,
  ...
}:
{
  powerManagement.cpuFreqGovernor = "powersave";

  hardware.graphics = {
    enable = true;
    enable32Bit = true;
    extraPackages = with pkgs; [
      intel-media-driver
      vpl-gpu-rt
      intel-compute-runtime
    ];
  };
  environment.variables.LIBVA_DRIVER_NAME = "iHD";

  services.thermald.enable = true;
  services.tlp.enable = lib.mkForce false; # guard: services.nix already has power-profiles-daemon, never both

  services.libinput.enable = true;

  hardware.cpu.intel.updateMicrocode = true;
  hardware.enableRedistributableFirmware = true;

  services.hardware.bolt.enable = true;

  # zramSwap.memoryPercent = 25;
  #
  # Fingerprint reader: confirmed absent from this unit's BOM (serial 5CG2219L32) — no fprintd
}
