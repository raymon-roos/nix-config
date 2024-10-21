{
  pkgs,
  config,
  ...
}: {
  home.sessionVariables = {
  };

  home.packages = with pkgs; [
    nix-tree
    alejandra
    nil
    nixd
  ];
}
