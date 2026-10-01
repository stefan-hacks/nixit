# ============================================================================
# home/firefox.nix
# ----------------------------------------------------------------------------
# Firefox declarative configuration via Home Manager.
#
# Target: Intel iGPU (Gen8+/Broadwell) on Wayland with VA-API hw decode.
#
# Problem: privacy.resistFingerprinting spoofs hardware capabilities and
# reduces timer precision, causing YouTube to serve the wrong adaptive
# bitrate stream and forcing software video decode. This produces the
# laggy playback + UI stutter seen in console-export-2026-10-1_7-9-53.log.
#
# See also:
#   • https://bugzilla.mozilla.org/show_bug.cgi?id=1746601 (RDD sandbox)
#   • nixos/environment.nix  → MOZ_ENABLE_WAYLAND, MOZ_DISABLE_RDD_SANDBOX
#   • systems/ghost/configuration.nix → hardware.graphics.extraPackages
# ============================================================================
{ pkgs, ... }:

{
  programs.firefox = {
    enable = true;

    profiles.default = {
      id = 0;
      name = "default";
      isDefault = true;

      settings = {
        # ── Performance / Video ─────────────────────────────────────────────
        # Ensure Wayland opaque-region optimisation is active.
        "widget.wayland.opaque-region.enabled" = true;

        # Enable VA-API hardware video decode/encode.
        # Requires intel-media-driver + libvdpau-va-gl in system packages.
        "media.ffmpeg.vaapi.enabled" = true;
        "media.ffmpeg.encoder.enabled" = true;
        "media.hardware-video-decoding.enabled" = true;

        # Raise content process count for smoother multi-tab behaviour.
        "dom.ipc.processCount" = 8;

        # ── Disable resistFingerprinting — THE CULPRIT ─────────────────────
        # This setting is the single biggest cause of YouTube lag on Firefox.
        # It breaks adaptive bitrate selection and forces CPU decode.
        # We keep reasonable privacy via Standard ETP below instead.
        "privacy.resistFingerprinting" = false;
        "privacy.resistFingerprinting.letterboxing" = false;

        # ── Privacy without breakage (Standard ETP) ──────────────────────────
        # "Strict" mode enables fingerprinting blocks that break sites.
        # "Standard" blocks trackers and social trackers without spoofing.
        "browser.contentblocking.category" = "standard";
        "privacy.trackingprotection.enabled" = true;
        "privacy.trackingprotection.socialtracking.enabled" = true;

        # Reject third-party cookies from known trackers (equivalent to
        # "Cross-site tracking cookies" in the UI).
        "network.cookie.cookieBehavior" = 5;

        # ── Telemetry / Data collection ─────────────────────────────────────
        "browser.telemetry.unified" = false;
        "toolkit.telemetry.enabled" = false;
        "datareporting.healthreport.uploadEnabled" = false;
        "app.shield.optoutstudies.enabled" = false;
        "browser.discovery.enabled" = false;
        "browser.newtabpage.activity-stream.feeds.telemetry" = false;
        "browser.newtabpage.activity-stream.telemetry" = false;

        # ── Smooth UI / Scroll / Zoom ────────────────────────────────────────
        "general.smoothScroll" = true;
        "apz.allow_zooming" = true;
        "apz.force_enable_desktop_zooming_scrollbars" = true;
        "mousewheel.min_line_scroll_amount" = 30;

        # ── Downloads ───────────────────────────────────────────────────────
        "browser.download.useDownloadDir" = true;
        "browser.download.startDownloadsAutomatically" = true;

        # ── Search / URL bar ────────────────────────────────────────────────
        "browser.search.suggest.enabled" = false;
        "browser.urlbar.suggest.searches" = false;
        "browser.urlbar.showSearchSuggestionsFirst" = false;

        # ── Security ────────────────────────────────────────────────────────
        "browser.safebrowsing.malware.enabled" = true;
        "browser.safebrowsing.phishing.enabled" = true;
      };
    };
  };
}
