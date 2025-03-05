{
  pkgs,
  config,
  lib,
  ...
}:
with lib; {
  options.dev.nix.enable = mkEnableOption "Nix dev tools";

  config = mkIf config.dev.nix.enable {
    # home.sessionVariables = { };

    home.packages = with pkgs; [
      nix-tree
      alejandra
      nil
      nixd
      statix
    ];
  };
}
