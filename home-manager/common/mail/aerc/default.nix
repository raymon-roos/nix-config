{...}: {
  programs.aerc = {
    enable = true;
    extraConfig = {
      general = {
        unsafe-accounts-conf = true;
        default-menu-cmd = "fzf";
      };
      compose = {
        empty-subject-warning = true;
      };
    };
    extraAccounts = {
    };
    extraBinds = builtins.readFile ./binds.conf;
  };
}
