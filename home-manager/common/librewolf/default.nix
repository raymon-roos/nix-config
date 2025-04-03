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
    cookie isolation, across study, work, and personal browser
    profiles, each with slightly different auto containers.
  '';

  imports = [
    ./policies.nix
    ./extensions.nix
    ./preferences.nix
  ];

  config = mkIf config.common.librewolf.enable {
    programs.librewolf = let
      settings = config.programs.librewolf.settings;
      containers = {
        fixico = {
          id = 0;
          color = "turquoise";
        };
        bitacademy = {
          id = 1;
          color = "green";
        };
        discord = {
          id = 2;
          color = "purple";
        };
        github = {
          id = 3;
          color = "blue";
        };
        hu = {
          id = 4;
          color = "turquoise";
        };
        banking = {
          id = 5;
          color = "green";
        };
        google = {
          id = 6;
          color = "red";
        };
        attlassian = {
          id = 7;
          color = "red";
        };
        private = {
          id = 8;
          color = "toolbar";
        };
        shopping = {
          id = 9;
          color = "purple";
        };
        microsoft = {
          id = 10;
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
        school = {
          id = 1;
          containersForce = true;
          inherit search containers settings;
        };
        work = {
          id = 2;
          containersForce = true;
          inherit search containers settings;
        };
      };
    };

    home.packages =
      lib.optional
      (config.common.hyprland.enable && config.common.librewolf.enable && config.common.librewolf-advanced.enable)
      (pkgs.writeShellScriptBin "browser_profile_select.sh" ''
        # Launch browser with selected profile
        librewolf -P "$(rg 'Name=' ~/.librewolf/profiles.ini | awk -F '=' '{print $2}' | bemenu)"
      '');
  };
}
