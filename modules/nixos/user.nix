{ config, pkgs, lib, username, ... }:

let
  fullName = "stefan-hacks";
  homeDirectory = "/home/${username}";
in
{
  users.users.${username} = {
    isNormalUser = true;
    description = fullName;
    shell = pkgs.bash;
    extraGroups = [
      "wheel"
      "networkmanager"
      "audio"
      "video"
      "kvm"
      "input"
      "uinput"
      "dialout"
      "libvirtd"
    ];
  };

  # Symlink user icon to accountsservice location for GDM/GNOME
  # (avoids deprecated system.activationScripts)
  systemd.tmpfiles.rules = [
    "L /var/lib/AccountsService/icons/${username} - - - - ${../../assets/icon2.png}"
  ];
}
