{
  config,
  lib,
  ...
}: let
  inherit (config.xdg) configHome;

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

  home.shellAliases = {
    hledger-ui = "hledger-ui --theme=terminal";
    imapfilter = "imapfilter -c ${configHome}/imapfilter/config.lua";
  };

  programs = lib.mkIf config.common.hyprland.enable {
    bash = {
      inherit profileExtra;
    };
    zsh = {
      inherit profileExtra;
    };
  };
}
