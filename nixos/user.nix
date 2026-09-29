{
  pkgs,
  lib,
  usernames,
  ...
}:
let
  commonGroups = [
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

  mkUser = name: {
    isNormalUser = true;
    description = name;
    shell = pkgs.bash;
    extraGroups = commonGroups;
  };

  # Per-user icon symlink.
  mkIconRule = name: "L /var/lib/AccountsService/icons/${name} - - - - ${../assets/icon2.png}";
in
{
  users.users = lib.genAttrs usernames mkUser;

  # Symlink user icon(s) to accountsservice location for GDM/GNOME
  # (avoids deprecated system.activationScripts)
  systemd.tmpfiles.rules = map mkIconRule usernames;
}
