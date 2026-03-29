{
  pkgs,
  config,
  lib,
  ...
}:
with lib; {
  options.common.newsraft.enable = mkEnableOption "newsraft: the lighter, newsboat-like terminal RSS reader";

  config = mkIf config.common.newsraft.enable {
    home.packages = [pkgs.newsraft];

    xdg.configFile = {
      "newsraft/feeds".source = ./feeds;
      "newsraft/config".text = ''
        list-entry-date-format %F %T
        menu-item-sorting time-publication-desc

        bind m exec mpv "%l"
      '';
    };
  };
}
