{
  pkgs,
  config,
  inputs,
  ...
}: let
  cacheHome = config.xdg.cacheHome;
  configHome = config.xdg.configHome;
in {
  xdg.configFile."starship/starship.toml".source = ./starship.toml;

  home.sessionVariables = {
    STARSHIP_CACHE = "${cacheHome}/starship";
    STARSHIP_CONFIG = "${configHome}/starship/starship.toml";
  };

  programs.starship = {
    enable = true;
  };
}
