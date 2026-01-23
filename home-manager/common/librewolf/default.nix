{
  config,
  pkgs,
  lib,
  ...
}:
with lib; {
  options.common.librewolf.enable = mkEnableOption ''
    firefox-based browser optimized for privacy
  '';

  options.common.librewolf-advanced.enable = mkEnableOption ''
    fully declarative browser profiles configuration. Must first
    remove existing browser profile. The goal is to have maximum
    cookie isolation accross websites.
  '';

  imports = [
    ./policies.nix
    ./extensions.nix
    ./preferences.nix
  ];

  config = mkIf config.common.librewolf.enable {
    programs.librewolf = let
      inherit (config.programs.librewolf) settings;
      containers = {
        bitacademy = {
          id = 2;
          color = "green";
        };
        discord = {
          id = 3;
          color = "purple";
        };
        github = {
          id = 4;
          color = "blue";
        };
        hu = {
          id = 5;
          color = "turquoise";
        };
        banking = {
          id = 6;
          color = "green";
        };
        google = {
          id = 7;
          color = "red";
        };
        atlassian = {
          id = 8;
          color = "red";
        };
        private = {
          id = 9;
          color = "toolbar";
        };
        shopping = {
          id = 10;
          color = "purple";
        };
        microsoft = {
          id = 11;
          color = "purple";
        };
      };
      search = {
        # home-manager will always fail to rebuild with this off due to
        # a file conflict. Will overwrite existing search configurations.
        force = true;
        default = "searx";
        privateDefault = "searx";
        engines = {
          "searx" = {
            urls = [{template = "https://search.rhscz.eu/search?q={searchTerms}";}];
            definedAliases = ["s"];
          };
          "ddglite" = {
            urls = [{template = "https://lite.duckduckgo.com/lite/";}];
            definedAliases = ["ddg"];
          };
          "mynixos" = {
            urls = [{template = "https://mynixos.com/search?q={searchTerms}";}];
            definedAliases = ["my"];
          };
          "noogle.dev" = {
            urls = [{template = "https://noogle.dev/q?term={searchTerms}";}];
            definedAliases = ["no"];
          };
          "wiki.nixos" = {
            urls = [{template = "https://wiki.nixos.org/w/index.php?search={searchTerms}";}];
            definedAliases = ["wix"];
          };
          "github" = {
            urls = [{template = "https://github.com/search?q={searchTerms}";}];
            definedAliases = ["gh"];
          };
          "discogs" = {
            urls = [{template = "https://www.discogs.com/search?q={searchTerms}";}];
            definedAliases = ["dis"];
          };
        };
        order = ["searx" "ddglite" "github" "mynixos" "discogs"];
      };
    in {
      enable = true;
      languagePacks = ["en-GB" "nl"];
      profiles = mkIf config.common.librewolf-advanced.enable {
        default = {
          isDefault = true;
          containersForce = true;
          inherit search containers settings;
        };
      };
    };
  };
}
