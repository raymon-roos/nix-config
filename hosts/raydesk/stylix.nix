{
  config,
  pkgs,
  ...
}: {
  imports = [
    ../stylix.nix
  ];

  stylix = {
    cursor = {
      package = pkgs.bibata-cursors;
      name = "Bibata-Modern-Classic";
      size = 20;
    };
  };
}
