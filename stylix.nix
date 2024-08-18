{
  config,
  pkgs,
  ...
}: {
  stylix = {
    enable = true;
    image = /home/ray/files/pictures/wallpapers/elden_ring_tarnished_warrior.jpg;
    base16Scheme = "${pkgs.base16-schemes}/share/themes/snazzy.yaml";
    polarity = "dark";
    fonts = {
      sizes.terminal = 9;
      sizes.applications = 11;
      monospace.package = pkgs.fira-code-nerdfont;
      monospace.name = "Fira Code";
      serif = config.stylix.fonts.monospace;
      sansSerif = config.stylix.fonts.monospace;
      emoji = config.stylix.fonts.monospace;
    };
    cursor = {
      package = pkgs.bibata-cursors;
      name = "Bibata-Modern-Classic";
      size = 20;
    };
  };
}
