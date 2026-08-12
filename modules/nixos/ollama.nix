{ config, lib, pkgs, ... }:
{
  services.ollama = {
    enable = true;

    # Listens on localhost only by default (127.0.0.1:11434), which is
    # what modules/nixos/hermes.nix points at. Set this to "0.0.0.0:11434"
    # if you need it reachable from other machines on your network.
    # host = "127.0.0.1";
    # port = 11434;

    # Pull Kimi 2.6 automatically on activation so it's ready before
    # hermes-agent tries to talk to it. Adjust the exact tag if the
    # published name in the Ollama library differs.
    loadModels = [ "kimi-2.6:cloud" ];

    # Uncomment if you have a GPU and want Ollama to use it.
    # acceleration = "cuda"; # or "rocm"
  };
}
