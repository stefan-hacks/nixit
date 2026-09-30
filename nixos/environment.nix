{ ... }: {
  environment.variables = {
    EDITOR = "nvim";
    VISUAL = "nvim";
    TERMINAL = "kitty";
    BROWSER = "firefox";

    # ── Firefox Wayland + VA-API ────────────────────────────────────────────
    # Force Firefox to use the native Wayland compositor instead of XWayland.
    # Eliminates input latency and improves vsync for tear-free video.
    # Must be set before Firefox starts; cannot be toggled at runtime.
    MOZ_ENABLE_WAYLAND = "1";

    # Disable the Remote Data Decoder (RDD) sandbox so the VA-API driver
    # can load in the content process for hardware-accelerated video decode.
    # Required on NixOS; harmless on other distros.
    # See: https://bugzilla.mozilla.org/show_bug.cgi?id=1746601
    MOZ_DISABLE_RDD_SANDBOX = "1";

    # Enable XInput2 for precise scroll/trackpad event handling in Firefox.
    # Fixes jerky/scaled scrolling on GTK3 Wayland.
    MOZ_USE_XINPUT2 = "1";

    # ── Chromium / Electron native Wayland ──────────────────────────────────
    # Forces Chromium, VS Code, Discord and other Electron apps to use the
    # native Wayland backend instead of XWayland.  Reduces input latency
    # and fixes HiDPI scaling on GNOME.
    NIXOS_OZONE_WL = "1";
  };

  environment.localBinInPath = true;
}
