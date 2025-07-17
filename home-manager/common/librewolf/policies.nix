{
  config,
  lib,
  ...
}:
with lib; {
  programs.librewolf.policies = mkIf config.common.librewolf-advanced.enable {
    AutofillAddressEnabled = false;
    AutofillCreditCardEnabled = false;
    Cookies = {
      Behavior = "reject-tracker-and-partition-foreign";
      BehaviorPrivateBrowsing = "reject-tracker-and-partition-foreign";
    };
    DisableFirfoxAccounts = false; # enable account sync for bookmarks
    DisableFirfoxStudies = true;
    DisableFormHistory = true;
    DisablePocket = true;
    DisableSetDesktopBackground = true;
    DisableTelemetry = true;
    DisplayBookmarksToolbar = "never";
    DontCheckDefaultBrowser = true;
    NoDefaultBookmarks = true;
    DNSOverHTTPS = {
      ProviderURL = "https://family.dns.mullvad.net/dns-query";
      Fallback = false;
    };
    EnableTrackingProtection = true;
    FirefoxHome = {
      Search = false;
      TopSites = false;
      SponsoredTopSites = false;
      Highlights = false;
      Pocket = false;
      SponsoredPocket = false;
      Snippets = false;
      Locked = false;
    };
    FirefoxSuggest = {
      WebSuggestions = false;
      SponsoredSuggestions = false;
      ImproveSuggest = false;
      Locked = false;
    };
    HardwareAcceleration = true;
    Homepage = {
      url = "https://search.rhscz.eu/";
      StartPage = "homepage";
    };
    HttpsOnlyMode = "enabled";
    OfferToSaveLogins = false;
    PasswordManagerEnabled = false;
    PopupBlocking.default = true;
    PromptForDownloadLocation = true;
    SearchSuggestEnabled = false;
    SanitizeOnShutdown = {
      Cache = true;
      Cookies = true;
      Downloads = true;
      FormData = true;
      History = true;
      Sessions = true;
      SiteSettings = true;
      OfflineApps = true;
    };
    SearchEngines = {
      Remove = ["Amazon.com" "Bing" "Google" "Wikipedia"];
    };
    UserMessaging = {
      ExtensionRecommendations = false;
      FeatureRecommendations = false;
      UrlbarInterventions = false;
      SkipOnboarding = true;
      MoreFromMozilla = false;
      FirefoxLabs = false;
      Locked = false;
    };
  };
}
