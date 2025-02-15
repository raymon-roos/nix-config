{
  pkgs,
  config,
  inputs,
  ...
}: {
  imports = [
    ../common
    ./shell.nix
  ];

  desktop-config.lockscreen.enable = true;
  desktop-config.hyprland.enable = true;
  dev.nix.enable = true;
  dev.nodejs.enable = true;
  dev.php.enable = true;
  dev.rust.enable = true;
  HUazureDevops.enable = true;

  home = {
    stateVersion = "23.11"; # don't change

    username = "ray";

    sessionPath = [
      config.xdg.userDirs.extraConfig.BIN_HOME
    ];

    packages = with pkgs; [
      keychain
      remind
      thunderbird
      vesktop
      wl-clipboard-rs
    ];
  };

  services.gpg-agent.pinentryPackage = pkgs.pinentry-qt;

  programs = let
    contact_info = import "${inputs.secrets}/contact_info.nix";
  in {
    git.userEmail = contact_info.personal.address;

    librewolf = {
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

    zathura = {
      enable = true;
      options = {
        recolor = true;
        sandbox = "strict";
        selection-clipboard = "clipboard";
      };
    };
  };

  xresources.path = "${config.xdg.configHome}/X11/Xresources";
  gtk.gtk2.configLocation = "${config.xdg.configHome}/gtk-2.0/gtkrc";
}
