{
  config,
  pkgs,
  ...
}: {
  stylix = {
    enable = true;

    image = /home/ray/files/pictures/wallpapers/elden_ring_tarnished_warrior.jpg;

    polarity = "dark";
    base16Scheme = "${pkgs.base16-schemes}/share/themes/horizon-dark.yaml";

    fonts = {
      sizes.terminal = 12;
      sizes.applications = 11;

      monospace = {
        package = pkgs.fira-code;
        name = "Fira Code";
      };
      sansSerif = {
        package = pkgs.dejavu_fonts;
        name = "DejaVu Sans";
      };
      serif = config.stylix.fonts.sansSerif;
      emoji = config.stylix.fonts.monospace;
    };
  };
}
