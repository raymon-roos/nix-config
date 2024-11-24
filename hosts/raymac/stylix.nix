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
    fonts = {
      sizes.terminal = 12;
    };
  };
}
