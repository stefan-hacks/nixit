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

  # Per-user icon symlink. Falls back to the shared assets/icon2.png unless
  # assets/icons/<name>.png exists, so multi-user hosts don't all get
  # stefan-hacks's face.
  mkIconRule =
    name:
    let
      perUserIcon = ../../assets/icons + "/${name}.png";
      icon = if builtins.pathExists perUserIcon then perUserIcon else ../../assets/icon2.png;
    in
    "L /var/lib/AccountsService/icons/${name} - - - - ${icon}";
in
{
  users.users = lib.genAttrs usernames mkUser;

  # Symlink user icon(s) to accountsservice location for GDM/GNOME
  # (avoids deprecated system.activationScripts)
  systemd.tmpfiles.rules = map mkIconRule usernames;
}
