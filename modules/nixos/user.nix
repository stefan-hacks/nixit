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

  # Copy user icon to accountsservice location for GDM/GNOME
  system.activationScripts.user-icon = ''
    ICON_SRC="${../../assets/icon2.png}"
    ACCOUNT_ICON="/var/lib/AccountsService/icons/${username}"

    if [ -f "$ICON_SRC" ]; then
      ${pkgs.coreutils}/bin/mkdir -p /var/lib/AccountsService/icons
      ${pkgs.coreutils}/bin/cp "$ICON_SRC" "$ACCOUNT_ICON"
      ${pkgs.coreutils}/bin/chmod 644 "$ACCOUNT_ICON"
    fi
  '';
}
