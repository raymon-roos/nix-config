{
  config,
  lib,
  ...
}:
with lib; {
  programs.librewolf.settings = mkIf config.common.librewolf.enable {
    ## PRIVACY (most of these probably apply only to firefox, and not librewolf)
    "app.normandy.api_url" = "";
    "app.normandy.enabled" = false;
    "app.normandy.first_run" = false;
    "app.shield.optoutstudies.enabled" = false;
    "beacon.enabled" = false;
    "browser.contentblocking.category" = "strict";
    "browser.discovery.enabled" = false;
    "browser.newtabpage.activity-stream.feeds.telemetry" = false;
    "browser.newtabpage.activity-stream.section.highlights.includePocket" = false;
    "browser.newtabpage.activity-stream.telemetry" = false;
    "browser.ping-centre.telemetry" = false;
    "browser.translations.automaticallyPopup" = false;
    "browser.urlbar.suggest.engines" = false;
    "browser.urlbar.suggest.history" = false;
    "browser.urlbar.suggest.openpage" = false;
    "browser.urlbar.suggest.recentsearches" = false;
    "browser.vpn_promo.enabled" = false;
    "datareporting.healthreport.uploadEnabled" = false; # disable Health Reports
    "datareporting.policy.dataSubmissionEnabled" = false; # disable new data submission
    "dom.event.clipboardevents.enabled" = false; # don't tell websites what I selected/copied
    "dom.private-attribution.submission.enabled" = false; # weird Mozilla "private" ad tech thingy
    "experiments.activeExperiment" = false;
    "experiments.enabled" = false;
    "experiments.supported" = false;
    "extensions.getAddons.showPane" = false; # disable recommendation pane in about:addons (uses Google Analytics)
    "extensions.htmlaboutaddons.recommendations.enabled" = false; # recommendations in about:addons' Extensions and Themes panes [FF68+]
    "extensions.pocket.api" = "";
    "extensions.pocket.enabled" = false;
    "extensions.pocket.oAuthConsumerKey" = "";
    "extensions.pocket.showHome" = false;
    "extensions.pocket.site" = "";
    "network.allow-experiments" = false;
    "network.http.referer.XOriginPolicy" = 2; # Referer header lets websites know how you got there. 2 for same-host-only
    "places.history.enabled" = false;
    "privacy.clearOnShutdown.downloads" = true;
    "privacy.clearOnShutdown.history" = true;
    "privacy.donottrackheader.enabled" = true;
    "privacy.resistFingerprinting" = true;
    "toolkit.coverage.endpoint.base" = "";
    "toolkit.coverage.opt-out" = true;
    "toolkit.telemetry.archive.enabled" = false;
    "toolkit.telemetry.bhrPing.enabled" = false;
    "toolkit.telemetry.coverage.opt-out" = true;
    "toolkit.telemetry.enabled" = false;
    "toolkit.telemetry.firstShutdownPing.enabled" = false;
    "toolkit.telemetry.hybridContent.enabled" = false;
    "toolkit.telemetry.newProfilePing.enabled" = false;
    "toolkit.telemetry.reportingpolicy.firstRun" = false;
    "toolkit.telemetry.server" = "data:,";
    "toolkit.telemetry.shutdownPingSender.enabled" = false;
    "toolkit.telemetry.shutdownPingSender.enabledFirstsession" = false; # disable PingCentre telemetry (used in several System Add-ons) [FF57+]
    "toolkit.telemetry.unified" = false;
    "toolkit.telemetry.updatePing.enabled" = false;
    "webgl.disabled" = true; # Webgl is a really strong fingerpinting factor

    ## PREFERENCES
    "StartDownloadsInTempDirectory" = true;
    "browser.cache.disk.parent_directory" = "/tmp/librewolf"; # Store cache-on-disk in ramfs instead, reduce writes to SSD

    "browser.uidensity" = 1;
    "sidebar.revamp" = true;
    "sidebar.verticalTabs" = true; # Use sidebar to control tabs
    "sidebar.visibility" = "hide-sidebar"; # Hide sidebar by default, for maximum screen real estate
    "sidebar.main.tools" = "";

    "browser.uiCustomization.state" = ''{"placements":{"widget-overflow-fixed-list":["preferences-button","developer-button","panic-button"],"unified-extensions-area":["sponsorblocker_ajay_app-browser-action"],"nav-bar":["sidebar-button","back-button","forward-button","stop-reload-button","vertical-spacer","customizableui-special-spring1","urlbar-container","customizableui-special-spring2","save-to-pocket-button","downloads-button","unified-extensions-button","ublock0_raymondhill_net-browser-action","addon_darkreader_org-browser-action","_b86e4813-687a-43e6-ab65-0bde4ab75758_-browser-action","_testpilot-containers-browser-action"],"toolbar-menubar":["menubar-items"],"TabsToolbar":[],"vertical-tabs":["tabbrowser-tabs"],"PersonalToolbar":["import-button","personal-bookmarks"]},"seen":["developer-button","ublock0_raymondhill_net-browser-action","addon_darkreader_org-browser-action","_b86e4813-687a-43e6-ab65-0bde4ab75758_-browser-action","sponsorblocker_ajay_app-browser-action","_testpilot-containers-browser-action"],"dirtyAreaCache":["nav-bar","PersonalToolbar","toolbar-menubar","TabsToolbar","unified-extensions-area","widget-overflow-fixed-list","vertical-tabs"],"currentVersion":21,"newElementCount":4}'';
    "devtools.cache.disabled" = true; # No network caching during development
    "extensions.autoDisableScopes" = 0; # auto-enable extension on first launch
    "identity.fxaccounts.enabled" = true; # enable encrypted sync for bookmarks
    "layout.css.devPixelsPerPx" = "0.70"; # shrink ui
    "media.ffmpeg.vaapi.enabled" = true; # Force hardware acceleration (vaapi), particularly for video decoding
    "media.hardware-video-decoding.force-enabled" = true;
  };
}
