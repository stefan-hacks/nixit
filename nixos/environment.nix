{ ... }: {
  environment.variables = {
    EDITOR = "nvim";
    VISUAL = "nvim";
    TERMINAL = "kitty";
    BROWSER = "firefox";

    # ── Firefox VA-API on NixOS ─────────────────────────────────────────────
    # Firefox's Remote Data Decoder (RDD) sandbox blocks the VA-API driver
    # from loading in the content process.  Disabling the RDD sandbox is
    # required for hardware-accelerated video decode on NixOS.
    # See: https://bugzilla.mozilla.org/show_bug.cgi?id=1746601
    MOZ_DISABLE_RDD_SANDBOX = "1";
  };

  environment.localBinInPath = true;
}
