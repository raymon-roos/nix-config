{
  pkgs,
  config,
  inputs,
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
      COLIMA_HOME = "${config.xdg.configHome}/colima";
      DOCKER_CONFIG = "${config.xdg.configHome}/docker";
      DOCKER_HOST = "unix://${config.home.sessionVariables.COLIMA_HOME}/default/docker.sock";
      KUBECONFIG = "${config.xdg.configHome}/kubectl/config";
      KUBECACHEDIR = "${config.xdg.cacheHome}/kubectl";
    };

    shellAliases = {
      vim = "nvim";
    };

    packages = with pkgs; let
      gdk = pkgs.google-cloud-sdk.withExtraComponents (with pkgs.google-cloud-sdk.components; [
        gcloud-man-pages
        kubectl-darwin-arm
        gke-gcloud-auth-plugin-darwin-arm
        cloud-sql-proxy-darwin-arm
        docker-credential-gcr
      ]);
    in [
      colima # VM docker runtime
      docker
      docker-compose
      gdk # requires manual authentication
      argocd
      wireguard-tools
    ];
  };

  programs = let
    contact_info = import "${inputs.secrets}/contact_info.nix";
  in {
    git.userEmail = contact_info.fixico.address;

    k9s = {
      enable = true;
      settings.k9s = {
        ui.logoless = true;
      };
    };

    ssh.extraConfig = ''
      IdentityAgent "~/Library/Group Containers/2BUA8C4S2C.com.1password/t/agent.sock"
    '';

    gh = {
      enable = true;
      settings = {
        git_protocol = "ssh";
      };
    };

    kitty.settings = {
      macos_option_as_alt = "both";
      hide_window_decorations = "titlebar-only";
      confirm_os_window_close = 0;
    };
  };

  stylix = {
    autoEnable = false;
    targets = {
      bat.enable = true;
      firefox.enable = true;
      fzf.enable = true;
      gitui.enable = true;
      k9s.enable = true;
      kitty.enable = true;
      yazi.enable = true;
    };
  };
}
