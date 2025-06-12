{
  config,
  pkgs,
  lib,
  ...
}: let
  inherit (pkgs.writers) writeNuBin writeBashBin;
  inherit (lib.lists) optionals;
in {
  home.packages =
    optionals (
      config.programs.bemenu.enable
      && config.programs.nushell.enable
      && config.common.hyprland.enable
    ) [
      (writeNuBin "monitor_select.nu" ./monitor_select.nu)
      (writeBashBin "set_volume.sh" ./set_volume.sh)
    ];
}
