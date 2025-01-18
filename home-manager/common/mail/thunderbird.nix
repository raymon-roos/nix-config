{config, ...}: {
  programs.thunderbird = {
    enable = true;
    settings = {
      # about:config settings under settings > general > config editor > show all
      privacy.donottrackheader.enabled = true;
      network.cookie.cookieBehavior = 1; # never accept third-party cookies
    };
    profiles.default = {
      isDefault = true;
      settings = {
        # user.js settings
      };
    };
  };
}
