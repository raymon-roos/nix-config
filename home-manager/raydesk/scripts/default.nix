{
  config,
  pkgs,
  ...
}: let
  inherit (pkgs.writers) writeNuBin writeBashBin;
in {
  home.packages = [
    (
      if config.programs.nushell.enable
      then writeNuBin "lyrics_in_terminal" ./lyrics_in_terminal.nu
      else writeBashBin "lyrics_in_terminal" ./lyrics_in_terminal.sh
    )
  ];
}
