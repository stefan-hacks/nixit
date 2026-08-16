{ ... }:
{
  services.hermes-agent = {
    enable = true;

    # ── Model: Kimi 2.6 served locally by Ollama ────────────────────────
    # Ollama exposes an OpenAI-compatible endpoint at /v1. No API key is
    # required by Ollama itself, but hermes-agent still wants a non-empty
    # value in OPENAI_API_KEY (or OPENROUTER_API_KEY, unused here) — put
    # any placeholder string in the env file below once you enter it.
    settings.model = {
      base_url = "http://127.0.0.1:11434/v1";
      default = "kimi-2.6:cloud";
    };

    # ── Secrets ──────────────────────────────────────────────────────────
    # You said you'll enter the Ollama key/env separately once launched.
    # Point this at whatever file you end up using (plain file, sops-nix,
    # or agenix secret path) — e.g.:
    #   environmentFiles = [ "/var/lib/hermes/env" ];
    # or, with sops-nix:
    #   environmentFiles = [ config.sops.secrets."hermes-env".path ];
    environmentFiles = [ ];

    addToSystemPackages = true;
  };
}
