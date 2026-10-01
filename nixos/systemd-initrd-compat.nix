# ============================================================================
# nixos/systemd-initrd-compat.nix
# ----------------------------------------------------------------------------
# Compatibility layer for NixOS 26.05+ systemd-based initrd.
# Ensures existing LUKS-on-LVM-on-ext4 configurations continue working when
# boot.initrd.systemd.enable = true (which is now the default and will be
# required in NixOS 26.11).
#
# The old scripted initrd used boot.initrd.luks.devices.*.device paths directly.
# Systemd initrd wraps LUKS unlock in systemd units, which changes how
# device nodes and dependencies are managed.  This module adds the missing
# systemd-specific LUKS declarations.
#
# References:
#   • NixOS 26.05 release notes: https://nixos.org/blog/announcements/2026/nixos-2605/
#   • systemd-initrd migration: https://nixos.org/manual/nixos/unstable/release-notes
#   • LUKS in systemd stage 1: https://search.nixos.org/options?query=boot.initrd.systemd
# ============================================================================
{ config, lib, ... }:
let
  # Collect all LUKS devices declared in the old-style initrd config.
  # These are typically defined in hardware.nix by nixos-generate-config.
  oldLuksDevices = config.boot.initrd.luks.devices or { };
in
{
  # Only apply when systemd initrd is enabled.  This allows the module to
  # be imported unconditionally — it becomes a no-op on old scripted initrd.
  config = lib.mkIf config.boot.initrd.systemd.enable {

    # ── LUKS unlock services ─────────────────────────────────────────────────
    # Systemd initrd needs explicit systemd-cryptsetup generators for each
    # LUKS device.  NixOS automatically translates boot.initrd.luks.devices
    # into systemd units, BUT only if the device is referenced by a fileSystem
    # or swapDevices entry.  The root device is auto-discovered, but swap
    # devices may need an explicit systemd-cryptsetup target.
    #
    # If boot hangs at "Waiting for device /dev/mapper/luks-..." after
    # switching to systemd initrd, add the device name here.
    boot.initrd.systemd.services =
      # Auto-generate cryptsetup targets for every LUKS device.
      (lib.mapAttrs' (name: _cfg: {
        name = "systemd-cryptsetup@${name}";
        value = {
          description = "Cryptography Setup for %I";
          wantedBy = [ "initrd.target" ];
          before = [ "sysroot.mount" ];
        };
      }) oldLuksDevices)
      # Ensure the tty passphrase agent is active so LUKS prompts appear
      # on the physical console.
      // {
        systemd-ask-password-console = {
          wantedBy = [ "initrd.target" ];
        };
      };

  };
}
