{
  config,
  pkgs,
  lib,
  inputs,
  ...
}: let
  inherit (config.xdg) configHome dataHome stateHome;
in {
  imports = [
    ./accounts.nix
    ./aerc
  ];

  options.common.email = {
    enable = lib.mkEnableOption "highly opiniated, comprehensive, terminal-based email setup";
  };

  config = lib.mkIf config.common.email.enable {
    home = {
      packages = with pkgs; [
        cyrus-sasl-xoauth2
        oama
        w3m
      ];

      shellAliases = {
        mbsync = "mbsync --config ${configHome}/isync/isyncrc";
        oama = "oama -c ${configHome}/oama/config.yaml";
      };
      sessionVariables."W3M_DIR" = "${stateHome}/w3m";
    };

    xdg.configFile = {
      "isyncrc".target = "${configHome}/isync/isyncrc";

      "oama/config.yaml".text = lib.generators.toYAML {} {
        encryption = {
          tag = "GPG";
          contents = "secretray";
        };
        services = let
          inherit (import "${inputs.secrets}/contact_info.nix") oauth_providers;
        in {
          microsoft = {
            auth_endpoint = "https://login.microsoftonline.com/common/oauth2/v2.0/devicecode";
            token_endpoint = "https://login.microsoftonline.com/common/oauth2/v2.0/token";
            auth_http_method = "GET";
            token_params_mode = "RequestBodyForm";
            auth_scope = "
              https://outlook.office.com/IMAP.AccessAsUser.All
              https://outlook.office.com/SMTP.Send
              offline_access
            ";
            inherit (oauth_providers.microsoft) client_id;
            client_secret = ""; # This client_id only works with --device auth flow, and doesn't need a secret
            tenant = "common";
            prompt = "select_account";
          };
          google = {
            auth_endpoint = "https://accounts.google.com/o/oauth2/auth";
            token_endpoint = "https://accounts.google.com/o/oauth2/token";
            auth_scope = "https://mail.google.com/";
            inherit (oauth_providers.google) client_id client_secret;
          };
        };
      };
    };

    programs = {
      mbsync = {
        enable = true;
        package = pkgs.isync.override {withCyrusSaslXoauth2 = true;};
        extraConfig = ''
          CopyArrivalDate yes
          Create Both
          Remove Both
          Expunge both
        '';
      };

      # used to have a consistent "send mail" interface across MUAs that
      # supports Oauth, as home-manager's smtp configuration does not.
      msmtp.enable = true;

      himalaya = {
        enable = true;
        settings = {
          downloads-dir = config.xdg.userDirs.download;
        };
      };

      thunderbird = lib.mkIf pkgs.stdenv.isLinux {
        enable = true;
        profiles.default.isDefault = true;
        settings = {
          "mailnews.default_sort_type" = 18; # Sort by date
          "mailnews.default_sort_order" = 2; # sort desc
          "mailnews.default_view_flags" = 33; # 0 - no threads, 1 - collapsed threads, 33 - expanded threads
        };
      };
    };

    accounts.email = {
      maildirBasePath = "${dataHome}/mail";
    };
  };
}
