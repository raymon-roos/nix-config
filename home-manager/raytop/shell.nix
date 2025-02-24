{
  pkgs,
  config,
  ...
}: let
  xdgHome = "${config.home.homeDirectory}/.xdg";
  configHome = "${xdgHome}/config";
  stateHome = "${xdgHome}/local/state";
  notesHome = config.xdg.userDirs.extraConfig.NOTES_HOME;

  profileExtra = ''
    # autostart compositor of choice when logging in on tty1
    if [[ "$XDG_VTNR" == 1 ]]; then
        "Hyprland"
    fi
  '';
  initExtra = ''
    # hack to fix dynamically linked binaries for traditional distros
    NIX_LD="$(nix eval --impure --raw --expr 'let pkgs = import <nixpkgs> {}; NIX_LD = pkgs.lib.fileContents "${pkgs.stdenv.cc}/nix-support/dynamic-linker"; in NIX_LD')"
    export NIX_LD
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
    drag = "ripdrag -nxa";
    keychain = "keychain --dir ${stateHome}/keychain";
    muttsync = "mbsync -a && notmuch new && neomutt";
  };

  programs = {
    bash = {
      inherit profileExtra initExtra;
    };
    zsh = {
      inherit profileExtra initExtra;
    };
  };
}
