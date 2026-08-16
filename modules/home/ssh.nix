{
  config,
  lib,
  ...
}:

{
  # Deploy SSH config
  home.file.".ssh/config".source = ../../dotfiles/.ssh/config;

  # Create controlmasters directory with user ownership.
  # ControlMaster sockets are written by the user's SSH client and must
  # be user-owned — root ownership causes "Permission denied" on connect.
  home.activation.sshControlMasters = lib.hm.dag.entryAfter [ "writeBoundary" ] ''
    if [ ! -d "${config.home.homeDirectory}/.ssh/controlmasters" ]; then
      mkdir -p "${config.home.homeDirectory}/.ssh/controlmasters"
      chmod 700 "${config.home.homeDirectory}/.ssh/controlmasters"
    fi
  '';
}
