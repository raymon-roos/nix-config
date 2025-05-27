{
  config,
  pkgs,
  lib,
  ...
}: let
  inherit (pkgs.writers) writeBashBin;
  inherit (lib.lists) optionals;
in {
  home.packages =
    optionals (
      config.programs.password-store.enable
      && config.programs.bemenu.enable
    )
    [(writeBashBin "passmenu_custom" ./passmenu_custom.sh)];
}
