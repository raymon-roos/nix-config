{
  pkgs,
  config,
  lib,
  ...
}:
with lib; {
  options.common.dev.nix.enable = mkEnableOption "Nix dev tools";

  config = mkIf config.common.dev.nix.enable {
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
