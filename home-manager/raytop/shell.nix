{
  config,
  lib,
  ...
}: let
  notesHome = config.xdg.userDirs.extraConfig.NOTES_HOME;

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
    zettel = "[ \"$PWD\" = ${notesHome} ] || pushd ${notesHome} && nvim index-202202270044.md";
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
