{
  config,
  lib,
  ...
}: let
  profileExtra = ''
    # autostart compositor of choice when logging in on tty1
    if [[ "$XDG_VTNR" == 1 ]]; then
        "Hyprland"
    fi
  '';
in {
  imports = [
    ../common/shell
  ];

  programs = lib.mkIf config.common.hyprland.enable {
    bash = {
      inherit profileExtra;
    };
    zsh = {
      inherit profileExtra;
    };
  };
}
