{...} @ inputs: {
  programs.zsh.initExtra = ''
    function y() {
      # Wrapper script for cd-on-quit
      # use `quit --no-cwd-file` as a keybind to opt out
      local tmp="$(mktemp -t "yazi-cwd.XXXXXX")"

      yazi "$@" --cwd-file="$tmp"

      if cwd="$(cat -- "$tmp")" && [ -n "$cwd" ] && [ "$cwd" != "$PWD" ]; then
        builtin cd -- "$cwd"
      fi

      rm -f -- "$tmp"
    }
  '';

  programs.yazi = {
    enable = true;
    enableZshIntegration = true;
    enableBashIntegration = true;
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
