{
  config,
  pkgs,
  lib,
  ...
}: let
  inherit (config.xdg) configHome stateHome;
  inherit (config.xdg.userDirs.extraConfig) FILES_HOME NOTES_HOME;

  shellAliases =
    {
      # Aliases with strictly Bourne-compatible syntax.
      # Not suited for Non-posix shells, such as Nushell.
      yg = "gitui -d $XDG_DATA_HOME/yadm/repo.git -w $HOME/.xdg --watcher";

      nixrc = ''[ "$PWD" = ${configHome}/nix ] || pushd ${configHome}/nix && nvim flake.nix'';
      vimrc = ''[ "$PWD" = ${configHome}/nvim ] || pushd ${configHome}/nvim && vim init.lua'';
      calrc = ''[ "$PWD" = ${FILES_HOME}/calendar ] || pushd ${FILES_HOME}/calendar && vim -o school.rem personal.rem'';
      rem = ''cal -m3 && remind -qgaad ${FILES_HOME}/calendar'';
      remc = "remind -mcu12b1@2,2,1wtt ${FILES_HOME}/calendar | less --raw";
    }
    // lib.optionalAttrs pkgs.stdenv.isLinux {
      zettel = ''[ "$PWD" = ${NOTES_HOME} ] || pushd ${NOTES_HOME} && nvim index-202202270044.md'';
    };
in {
  home.shellAliases =
    {
      "rm -rf /" = ''echo "ha lol no lets not"'';
      ls = lib.mkIf config.programs.eza.enable "eza";
      nrs = "nh os switch";
      vimdiff = "nvim -d";
      vim = "nvim";
      clip = "wl-clip -selection clipboard";
      lw = "librewolf";
      gg = "gitui";
      gs = "git status --short --branch --show-stash";
      gS = "git status";
      go = "git checkout";
      ga = "git add";
      gA = "git add -A";
      gb = "git branch -vva";
      gbd = "git branch -D";
      gd = "git diff";
      gD = "git diff --staged";
      gdi = "git difftool";
      gDi = "git difftool --staged";
      gl = "git log --pretty='%C(magenta)%h %C(yellow)%ad %C(reset)%s %C(auto) %d' --date=short --graph";
      gc = "git commit";
      gca = "git commit --amend";
      gC = "git commit -m";
      gf = "git fetch -a";
      gv = "git remote -vvv";
      gpl = "git pull";
      gplr = "git pull --rebase --autostash";
      gps = "git push";
      gpsf = "git push --force";
      gpsu = "git push -u";
      gr = "git rebase -i";
      gm = "git merge -e";
      gst = "git stash";
      gsl = "git stash list";
      gsp = "git stash pop";
    }
    // lib.optionalAttrs pkgs.stdenv.isLinux {
      drag = "ripdrag -nxa";
      keychain = "keychain --dir ${stateHome}/keychain";
    };

  programs = {
    bash = {inherit shellAliases;};
    zsh = {inherit shellAliases;};
  };
}
