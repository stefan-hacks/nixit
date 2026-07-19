{
  # ---------------------------------------------------------------------------
  # Host Identity
  # ---------------------------------------------------------------------------

  hostname = "ghost";

  username = "stefan-hacks";

  fullName = "stefan-hacks";

  email = "";

  timezone = "America/Sao_Paulo";

  locale = "en_GB.UTF-8";

  # ---------------------------------------------------------------------------
  # Profiles
  # ---------------------------------------------------------------------------

  profile = "workstation";

  desktop = "gnome";

  editor = "lazyvim";

  shell = "bash";

  terminal = "kitty";

  keyboard = "kanata";

  virtualization = "virtualbox";

  # ---------------------------------------------------------------------------
  # Feature Flags
  # ---------------------------------------------------------------------------

  features = {

    bluetooth = true;

    printing = true;

    pipewire = true;

    flatpak = true;

    virtualbox = true;

    docker = false;

    podman = false;

    libvirt = false;

    openssh = false;

    avahi = false;

  };

}
