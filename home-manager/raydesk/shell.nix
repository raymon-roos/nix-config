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

  notesHome = config.xdg.userDirs.extraConfig.NOTES_HOME;
  shellAliases = {
    # Aliases with syntax strictly Bourne-compatible.
    # Not suited for Non-posix shells, such as Nushell.
    zettel = "[ \"$PWD\" = ${notesHome} ] || pushd ${notesHome} && nvim index-202202270044.md";
  };
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
      inherit profileExtra shellAliases;
    };
    zsh = {
      inherit profileExtra shellAliases;
    };
  };
}
