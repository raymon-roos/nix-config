{
  config,
  pkgs,
  lib,
  ...
}: let
  inherit (config.xdg) configHome stateHome;
in {
  home.shellAliases =
    {
      "rm -rf /" = "echo 'ha lol no lets not'";
      ls = "eza";
      nrs =
        if pkgs.stdenv.isDarwin
        then "darwin-rebuild switch --flake ${configHome}/nix"
        else "nh os switch ${configHome}/nix";
      nixrc = "[ \"$PWD\" = ${configHome}/nix ] || pushd ${configHome}/nix && nvim flake.nix";
      vimrc = "[ \"$PWD\" = ${configHome}/nvim ] || pushd ${configHome}/nvim && vim init.lua";
      vimdiff = "nvim -d";
      clip =
        if pkgs.stdenv.isLinux
        then "wl-clip -selection clipboard"
        else "pbcopy";
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

}
