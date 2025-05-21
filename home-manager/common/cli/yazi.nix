{config, ...}: {
  programs.yazi = {
    enable = true;
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
        {
          run = ''
            shell -- ripdrag -nx "$@"
          '';
          on = ["<C-n>"];
        }
      ];
    };
  };
}
