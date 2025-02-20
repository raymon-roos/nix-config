{
  config,
  lib,
  ...
}:
with lib; {
  options.common.librewolf.enable = mkEnableOption ''
    firefox-based browser optimized for privacy
  '';

  config = mkIf config.common.librewolf.enable {
    programs.librewolf = {
      enable = true;
      settings = {
        "identity.fxaccounts.enabled" = true;
        "privacy.donottrackheader.enabled" = true;
        "privacy.resistFingerprinting" = true;
        "privacy.clearOnShutdown.history" = true;
        "privacy.clearOnShutdown.downloads" = true;
        "browser.contentblocking.category" = "strict";
        "network.http.referer.XOriginPolicy" = 2; # Referer header lets websites know how you got there. 2 for same-host-only
        "webgl.disabled" = false;

        "browser.startup.homepage" = "https://search.rhscz.eu/";
        "browser.urlbar.suggest.engines" = false;
        "browser.urlbar.suggest.history" = false;
        "browser.urlbar.suggest.openpage" = false;
        "browser.urlbar.suggest.recentsearches" = false;
        "layout.css.devPixelsPerPx" = "0.70"; # shrink ui

        # Force hardware acceleration (vaapi), particularly for video decoding
        "media.ffmpeg.vaapi.enabled" = true;
        "media.hardware-video-decoding.force-enabled" = true;
      };
      languagePacks = ["en-GB" "nl"];
    };
  };
}
