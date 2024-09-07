{config, ...}: let
  stateHome = config.xdg.stateHome;
  configHome = config.xdg.configHome;
in {
  home.shellAliases = {
    "rm -rf /" = "echo ha lol no lets not";
    rm = "rm -I --preserve-root";
    chmod = "chmod --preserve-root";
    chown = "chown --preserve-root";
    chgrp = "chgrp --preserve-root";
    # ls = "ls -lah --color=auto --group-directories-first";
    ls = "eza";

    nrs = "nh os switch ${configHome}/nix";
    hms = "nh home switch --flake ${configHome}/nix";
    nixrc = "nvim ${configHome}/nix/flake.nix -c 'cd %:p:h' -c pwd";

    # y = "yazi";
    vimdiff = "nvim -d";
    lw = "librewolf";
    hledger-ui = "hledger-ui --theme=terminal";

    drag = "ripdrag -nxa";
    sucklessmake = "sudo make install && make clean && rm -f config.h";
    clip = "xclip -r -selection clipboard";

    imapfilter = "imapfilter -c ${configHome}/imapfilter/config.lua";
    keychain = "keychain --dir ${stateHome}/keychain";

    zettel = "nvim $NOTES_HOME/index-202202270044.md -c 'cd %:p:h' -c pwd";
    vimrc = "nvim ${configHome}/nvim/init.lua -c 'cd %:p:h' -c pwd";
    bashrc = "nvim ${configHome}/bash/bash_profile -c 'cd %:p:h' -c pwd && source ${configHome}/bash/bash_profile";
    muttsync = "mbsync -a && notmuch new && neomutt";

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
    yr = "git rebase -i";
    ym = "git merge -e";
    yst = "yadm stash";
    ysl = "yadm stash list";
    ysp = "yadm stash pop";

    tsc = "sudo timeshift --create --comments";
    tsl = "sudo timeshift --list";
    tsd = "sudo timeshift --delete";

    dcu = "docker-compose up -d";
    dcd = "docker-compose down";
  };
}
