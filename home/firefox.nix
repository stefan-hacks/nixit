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
# NOTE: Firefox on this NixOS machine stores profiles under
# ~/.config/mozilla/firefox/ (XDG_CONFIG_HOME).  Home Manager's
# programs.firefox creates its own managed profile, but Firefox may
# continue using a pre-existing default profile.  To guarantee the
# settings reach the running profile, we ALSO inject user.js into
# every .default* directory under ~/.config/mozilla/firefox/ via a
# home.activation hook.
#
# See also:
#   • https://bugzilla.mozilla.org/show_bug.cgi?id=1746601 (RDD sandbox)
#   • nixos/environment.nix  → MOZ_ENABLE_WAYLAND, MOZ_DISABLE_RDD_SANDBOX
#   • systems/ghost/configuration.nix → hardware.graphics.extraPackages
# ============================================================================
{ pkgs, lib, ... }:

let
  # ── Preference map ────────────────────────────────────────────────────────
  # Centralised so the same values are used by both the HM-managed profile
  # and the activation-injected user.js.
  firefoxSettings = {
    # ── Performance / Video ───────────────────────────────────────────────
    # Ensure Wayland opaque-region optimisation is active.
    "widget.wayland.opaque-region.enabled" = true;

    # Enable VA-API hardware video decode/encode.
    # Requires intel-media-driver + libvdpau-va-gl in system packages.
    "media.ffmpeg.vaapi.enabled" = true;
    "media.ffmpeg.encoder.enabled" = true;
    "media.hardware-video-decoding.enabled" = true;

    # Raise content process count for smoother multi-tab behaviour.
    "dom.ipc.processCount" = 8;

    # ── Disable resistFingerprinting — THE CULPRIT ────────────────────────
    # This setting is the single biggest cause of YouTube lag on Firefox.
    # It breaks adaptive bitrate selection and forces CPU decode.
    # We keep reasonable privacy via Standard ETP below instead.
    "privacy.resistFingerprinting" = false;
    "privacy.resistFingerprinting.letterboxing" = false;
    "privacy.fingerprintingProtection" = false;

    # ── Privacy without breakage (Standard ETP) ───────────────────────────
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

    # ── Smooth UI / Scroll / Zoom ───────────────────────────────────────
    "general.smoothScroll" = true;
    "apz.allow_zooming" = true;
    "apz.force_enable_desktop_zooming_scrollbars" = true;
    "mousewheel.min_line_scroll_amount" = 30;

    # ── Downloads ─────────────────────────────────────────────────────────
    "browser.download.useDownloadDir" = true;
    "browser.download.startDownloadsAutomatically" = true;

    # ── Search / URL bar ─────────────────────────────────────────────────
    "browser.search.suggest.enabled" = false;
    "browser.urlbar.suggest.searches" = false;
    "browser.urlbar.showSearchSuggestionsFirst" = false;

    # ── Security ────────────────────────────────────────────────────────
    "browser.safebrowsing.malware.enabled" = true;
    "browser.safebrowsing.phishing.enabled" = true;
  };

  # Generate user.js text from the attrset.  Bool → true/false,
  # String → quoted, Int → bare number.
  userJsText = lib.concatStringsSep "\n" (lib.mapAttrsToList (k: v:
    let
      valStr =
        if builtins.isBool v then (if v then "true" else "false")
        else if builtins.isString v then ''"${v}"''
        else toString v;
    in
    ''user_pref("${k}", ${valStr});''
  ) firefoxSettings);
in

{
  programs.firefox = {
    enable = true;

    profiles.default = {
      id = 0;
      name = "default";
      isDefault = true;

      settings = firefoxSettings;
    };
  };

  # ── Activation hook: inject user.js into existing XDG profile ───────────
  # Firefox on NixOS with XDG_CONFIG_HOME=$HOME/.config stores profiles
  # under ~/.config/mozilla/firefox/.  The declarative programs.firefox
  # profile may not be the one Firefox actually launches if a pre-existing
  # default profile is already present.  This activation writes user.js
  # into every .default* directory so the lag-fixing prefs are applied
  # regardless of which profile Firefox selects.
  #
  # NOTE: user.js is read at Firefox startup.  You MUST fully quit Firefox
  # (not just close windows) and relaunch for these changes to take effect.
  home.activation.firefoxUserJs = lib.hm.dag.entryAfter [ "writeBoundary" ] ''
    MOZ_DIR="$HOME/.config/mozilla/firefox"
    if [ -d "$MOZ_DIR" ]; then
      for profile in "$MOZ_DIR"/*.default "$MOZ_DIR"/*.default-*; do
        if [ -d "$profile" ]; then
          echo "[nixit] Writing user.js to $(basename "$profile")"
          cat > "$profile/user.js" <<'EOF'
// ============================================================================
// Generated by Home Manager — nixit/home/firefox.nix
// Injected into the active default profile because Firefox stores profiles
// under XDG_CONFIG_HOME ($HOME/.config/mozilla/firefox) on this machine.
//
// These settings fix YouTube lag by disabling fingerprinting protection
// and enabling hardware-accelerated video decode.
//
// IMPORTANT: Restart Firefox completely for these changes to take effect.
// ============================================================================
${userJsText}
EOF
        fi
      done
    fi
  '';
}
