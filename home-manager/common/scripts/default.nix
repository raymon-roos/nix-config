{
  config,
  pkgs,
  lib,
  ...
}: let
  inherit (pkgs.writers) writeBashBin writeNuBin;
  inherit (lib.lists) optionals;
in {
  home.packages =
    optionals config.programs.bemenu.enable [
      (writeBashBin "directories_bemenu.sh" ./directories_bemenu.sh)
    ]
    ++ optionals (
      config.programs.password-store.enable && config.programs.bemenu.enable
    ) [
      (writeBashBin "passmenu_custom" ./passmenu_custom.sh)
    ]
    ++ optionals (config.programs.nushell.enable && config.common.email.enable) [
      (writeNuBin "newmail" ./newmail.nu)
    ];
}
