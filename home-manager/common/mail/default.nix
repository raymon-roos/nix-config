{
  config,
  pkgs,
  lib,
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
        python3 # requirement for mutt_ouath2.py
        cyrus-sasl-xoauth2
        (
          pkgs.fetchurl {
            url = "https://raw.githubusercontent.com/neomutt/neomutt/refs/heads/main/contrib/oauth2/mutt_oauth2.py";
            sha256 = "fCE3pX9tsI8AQ2xpNMQ+GGsrdpNIeKpmZX5LGdYqQio=";
          }
          |> builtins.readFile
          |> pkgs.writers.writePython3Bin "mutt_oauth2.py" {doCheck = false;}
        )
        w3m
      ];

      shellAliases = {
        mbsync = "mbsync --config ${configHome}/isync/isyncrc";
      };
      sessionVariables."W3M_DIR" = "${stateHome}/w3m";
    };

    xdg.configFile."isyncrc".target = "${configHome}/isync/isyncrc";

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
