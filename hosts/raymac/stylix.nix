{
  config,
  pkgs,
  ...
}: {
  imports = [
    ../stylix.nix
  ];

  stylix = {
    autoEnable = false;
  };
}
