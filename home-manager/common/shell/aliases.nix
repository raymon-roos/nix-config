{config, ...}: let
  stateHome = config.xdg.stateHome;
  configHome = config.xdg.configHome;
in {
  home.shellAliases = {
    "rm -rf /" = "echo 'ha lol no lets not'";
    ls = "eza";
    nrs = "nh os switch ${configHome}/nix";
    hms = "nh home switch --flake ${configHome}/nix";

    nixrc = "[ \"$PWD\" = ${configHome}/nix ] || pushd ${configHome}/nix && nvim flake.nix";
    vimrc = "[ \"$PWD\" = ${configHome}/nvim ] || pushd ${configHome}/nvim && vim init.lua";

    vimdiff = "nvim -d";
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

    yg = "gitui -d $XDG_DATA_HOME/yadm/repo.git -w $HOME/.xdg --watcher";
    yo = "yadm checkout";
    ys = "yadm status --short --branch --show-stash";
    yS = "yadm status";
    ya = "yadm add";
    yai = "yadm add --interactive";
    yA = "yadm add -A";
    yb = "yadm branch -vva";
    ybd = "yadm branch -D";
    yd = "yadm diff";
    yD = "yadm diff --staged";
    ydi = "yadm difftool";
    yDi = "yadm difftool --staged";
    yl = "yadm log --pretty='%C(magenta)%h %C(yellow)%ad %C(reset)%s %C(auto) %d' --date=short --graph";
    yc = "yadm commit";
    yC = "yadm commit -m";
    yf = "yadm fetch -a";
    yv = "yadm remote -vvv";
    ypl = "yadm pull";
    yplr = "yadm pull --rebase --autostash";
    yps = "yadm push";
    ypsf = "yadm push --force";
    ypsu = "yadm push -u";
    yr = "yadm rebase -i";
    ym = "yadm merge -e";
    yst = "yadm stash";
    ysl = "yadm stash list";
    ysp = "yadm stash pop";
  };
}
