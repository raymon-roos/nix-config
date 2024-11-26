{
  pkgs,
  config,
  ...
}: {
  imports = [
    ../common
  ];

  dev.nix.enable = true;
  dev.php.enable = true;
  dev.nodejs.enable = true;

  home = {
    stateVersion = "23.11"; # don't change

    username = "ray";

    sessionPath = [
      config.home.sessionVariables.BIN_HOME
    ];

    sessionVariables = {
      EDITOR = "nvim";
    };

    shellAliases = {
      vim = "nvim";
    };

    packages = with pkgs; [
      # colima
      argocd
      difftastic
      wireguard-tools
    ];
  };

  programs = {
    git.userEmail = "raymon@fixico.com";

    k9s = {
      enable = true;
      settings = {
      };
    };

    gh = {
      enable = true;
      settings = {
        git_protocol = "ssh";
      };
    };
  };

  # stylix.autoEnable = false;
  # stylix.targets = {
  #   bat.enable = true;
  #   fzf.enable = true;
  #   gitui.enable = true;
  #   k9s.enable = true;
  #   kitty.enable = true;
  #   yazi.enable = true;
  # };
}
