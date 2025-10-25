{
  pkgs,
  inputs,
  ...
}: let
  contact_info = import "${inputs.secrets}/contact_info.nix";
in {
  programs = {
    git = {
      enable = true;
      settings = {
        user.name = contact_info.full_name;
        user.email = contact_info.personal.address;
        init = {
          defaultBranch = "main";
        };
        diff = {
          colorMoved = "default";
          tool = "difftastic";
        };
        difftool.prompt = false;
        # Some base16 dark themes I like don't work with difftastic's dark background
        "difftool \"difftastic\"".cmd = "difft --background='light' --display='side-by-side' $LOCAL $REMOTE";
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
      ignores = [".DS_Store"];
    };

    delta = {
      enable = true;
      enableGitIntegration = true;
      options = {
        features = "decorations";
        navigate = true;
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
