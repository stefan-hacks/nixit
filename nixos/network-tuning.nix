# ============================================================================
# nixos/network-tuning.nix
# ----------------------------------------------------------------------------
# Intel AX201 Wi-Fi 6 optimizations for HP EliteBook 840 G8.
# The AX201 (PCIe + CNVi) works best with iwlwifi power-saving disabled
# and regulatory domain set correctly, otherwise you get disconnects and
# throughput drops on 5 GHz channels.
#
# Reference:
#   https://wiki.archlinux.org/title/Network_configuration/Wireless#iwlwifi
# ============================================================================
{ lib, ... }:
{
  # Disable iwlwifi power management.  The AX201 firmware crashes when
  # aggressively power-cycling the radio under load (e.g. video calls),
  # causing random disconnects.
  boot.extraModprobeConfig = lib.mkDefault ''
    options iwlwifi power_save=0
    options iwlwifi uapsd_disable=1
  '';

  # Wi-Fi regulatory database.  Without this the AX201 may refuse to use
  # 5 GHz / 6 GHz channels and falls back to 2.4 GHz with lower throughput.
  hardware.wirelessRegulatoryDatabase = true;
}
