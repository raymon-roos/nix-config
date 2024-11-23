{
  pkgs,
  config,
  ...
} @ inputs: let
  xdgHome = "${config.home.homeDirectory}/.xdg";
  configHome = "${xdgHome}/config";
  stateHome = "${xdgHome}/local/state";
  notesHome = config.xdg.userDirs.extraConfig.NOTES_HOME;
in {
  imports = [
    ../common/shell
  ];

  home.shellAliases =
    config.home.shellAliases
    // {
      rm = "rm -I --preserve-root";
      chmod = "chmod --preserve-root";
      chown = "chown --preserve-root";
      chgrp = "chgrp --preserve-root";
      zettel = "[ \"$PWD\" = ${notesHome} ] || pushd ${notesHome} && nvim index-202202270044.md";
      hledger-ui = "hledger-ui --theme=terminal";
      drag = "ripdrag -nxa";
      sucklessmake = "sudo make install && make clean && rm -f config.h";
      clip = "xclip -r -selection clipboard";
      imapfilter = "imapfilter -c ${configHome}/imapfilter/config.lua";
      keychain = "keychain --dir ${stateHome}/keychain";
      muttsync = "mbsync -a && notmuch new && neomutt";
    };

  programs = {
    bash = {
      profileExtra = ''
        # autostart compositor of choice when logging in on tty1
        if [[ "$XDG_VTNR" == 1 ]]; then
            "${pkgs.hyprland}/bin/Hyprland"
        fi
      '';
      initExtra = ''
        # hack to fix dynamically linked binaries for traditional distros
        NIX_LD="$(nix eval --impure --raw --expr 'let pkgs = import <nixpkgs> {}; NIX_LD = pkgs.lib.fileContents "${pkgs.stdenv.cc}/nix-support/dynamic-linker"; in NIX_LD')"
        export NIX_LD
      '';
    };

    zsh = {
      profileExtra = config.programs.bash.profileExtra;
      initExtra = config.programs.bash.initExtra;
    };
  };
}
