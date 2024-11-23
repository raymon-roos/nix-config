{...}: {
  programs.yazi = {
    enable = true;
    enableZshIntegration = true;
    enableBashIntegration = true;
    shellWrapperName = "y";
    settings = {
      manager = {
        show_hidden = true;
      };
    };
    keymap = {
      manager.prepend_keymap = [
        {
          run = "quit --no-cwd-file";
          on = ["q"];
        }
        {
          run = "quit";
          on = ["<C-g>"];
        }
      ];
    };
    # plugins = {
    #   relative-motions = builtins.fetchGit {
    #     url = "https://github.com/dedukun/relative-motions.yazi.git";
    #     rev = "73f554295f4b69756597c9fe3caf3750a321acea";
    #   };
    # };
  };
}
