{
  config,
  lib,
  ...
}:
with lib; {
  programs.librewolf.policies = mkIf config.common.librewolf-advanced.enable {
    ExtensionSettings = let
      mkExt = name: uuid:
        nameValuePair uuid {
          installation_mode = "force_installed";
          install_url = "https://addons.mozilla.org/firefox/downloads/latest/${name}/latest.xpi";
        };
    in
      listToAttrs [
        # Best open source blocker
        (mkExt "ublock-origin" "uBlock0@raymondhill.net")
        # Prevent network requests to common CDNs
        (mkExt "localcdn-fork-of-decentraleyes" "{b86e4813-687a-43e6-ab65-0bde4ab75758}")
        # Dark mode everywhere
        (mkExt "darkreader" "addon@darkreader.org")
        # Make youtube bearable
        (mkExt "sponsorblock" "sponsorBlocker@ajay.app")
      ]
      // {
        # Vim emulation in the browser
        "tridactyl.vim.betas@cmcaine.co.uk" = {
          installation_mode = "force_installed";
          install_url = "https://tridactyl.cmcaine.co.uk/betas/tridactyl-latest.xpi";
        };
      };

    "3rdparty".Extensions = {
      "uBlock0@raymondhill.net" = {
        adminSettings = {
          userSettings = {
            advancedUserEnabled = true;
            cloudStorageEnabled = true;
            uiTheme = "dark";
            externalLists = "https://filters.adtidy.org/extension/ublock/filters/14.txt\nhttps://malware-filter.gitlab.io/pup-filter/pup-filter.txt\nhttps://secure.fanboy.co.nz/fanboy-annoyance_ubo.txt";
            firewallPaneMinimized = false;
            importedLists = [
              "https://filters.adtidy.org/extension/ublock/filters/14.txt"
              "https://malware-filter.gitlab.io/pup-filter/pup-filter.txt"
              "https://secure.fanboy.co.nz/fanboy-annoyance_ubo.txt"
            ];
          };
          popupPanelSections = 63;
          selectedFilterLists = [
            "LegitimateURLShortener"
            "NLD-0"
            "RUS-0"
            "RUS-1"
            "adguard-cookies"
            "adguard-generic"
            "adguard-mobile"
            "adguard-mobile-app-banners"
            "adguard-other-annoyances"
            "adguard-popup-overlays"
            "adguard-social"
            "adguard-spyware"
            "adguard-spyware-url"
            "adguard-widgets"
            "block-lan"
            "curben-phishing"
            "dpollock-0"
            "easylist"
            "easylist-annoyances"
            "easylist-chat"
            "easylist-newsletters"
            "easylist-notifications"
            "easyprivacy"
            "fanboy-cookiemonster"
            "fanboy-social"
            "fanboy-thirdparty_social"
            "https://filters.adtidy.org/extension/ublock/filters/14.txt"
            "https://malware-filter.gitlab.io/pup-filter/pup-filter.txt"
            "https://secure.fanboy.co.nz/fanboy-annoyance_ubo.txt"
            "plowe-0"
            "ublock-annoyances"
            "ublock-badware"
            "ublock-cookies-adguard"
            "ublock-cookies-easylist"
            "ublock-filters"
            "ublock-privacy"
            "ublock-quick-fixes"
            "ublock-unbreak"
            "urlhaus-1"
            "user-filters"
          ];
        };
      };
    };
    ExtensionUpdate = true;
  };
}
