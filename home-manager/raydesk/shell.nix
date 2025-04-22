{
  config,
  lib,
  ...
}: let
  notesHome = config.xdg.userDirs.extraConfig.NOTES_HOME;
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
    rm = "rm -I --preserve-root";
    chmod = "chmod --preserve-root";
    chown = "chown --preserve-root";
    chgrp = "chgrp --preserve-root";
    zettel = "[ \"$PWD\" = ${notesHome} ] || pushd ${notesHome} && nvim index-202202270044.md";
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
