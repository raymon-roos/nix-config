{pkgs, ...}: {
  programs.git = {
    enable = true;
    userName = "Raymon Roos";
    ignores = [".DS_Store"];
    extraConfig = {
      init = {
        defaultBranch = "main";
      };
      diff = {
        colorMoved = "default";
        tool = "difftastic";
      };
      difftool.prompt = false;
      "difftool \"difftastic\"".cmd = "difft $LOCAL $REMOTE";
      merge = {
        tool = "vimdiff";
        conflictStyle = "zdiff3";
      };
      mergetool = {
        prompt = false;
        keepBackup = false;
      };
      "mergetool \"vimdiff\"".cmd = "nvim -d $LOCAL $BASE $REMOTE $MERGED -c 'wincmd 3l | wincmd J'";
    };
    delta = {
      enable = true;
      options = {
        features = "decorations";
      };
    };
  };

  home.packages = [
    pkgs.difftastic
  ];

  programs.gitui = {
    enable = true;
    keyConfig = ''
      (
        popup_up: Some(( code: Char('p'), modifiers: "CONTROL")),
        popup_down: Some(( code: Char('n'), modifiers: "CONTROL")),
        home: Some(( code: Char('g'), modifiers: "")),
        end: Some(( code: Char('G'), modifiers: "SHIFT")),
        log_find: Some(( code: Char('/'), modifiers: "")),
        branch_find: Some(( code: Char('/'), modifiers: "")),
        file_find: Some(( code: Char('/'), modifiers: "")),
      )
    '';
  };
}
