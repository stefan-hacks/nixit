{
  config,
  pkgs,
  lib,
  ...
}:

{
  programs.bash = {
    enable = true;
    completion.enable = true;
  };

  programs.git.enable = true;

  # OpenSSH agent disabled - using GNOME's gcr-ssh-agent instead

  programs.gnupg.agent = {
    enable = true;
  };

  programs.direnv = {
    enable = true;
    nix-direnv.enable = true;
  };

  programs.virt-manager = {
    enable = true;
  };

  programs.command-not-found.enable = true;
}
