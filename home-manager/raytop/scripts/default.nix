{
  config,
  pkgs,
  lib,
  ...
}: let
  inherit (pkgs.writers) writeNuBin;
  inherit (lib.lists) optionals;
in {
  home.packages =
    optionals (
      config.programs.bemenu.enable
      && config.programs.nushell.enable
      && config.common.hyprland.enable
    ) [
      (writeNuBin "monitor_select.nu" ./monitor_select.nu)
    ];
}
