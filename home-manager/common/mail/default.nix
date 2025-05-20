{
  config,
  pkgs,
  lib,
  ...
}: {
  imports = [
    ./accounts.nix
    ./aerc
  ];

  options.common.email = {
    enable = lib.mkEnableOption "highly opiniated, comprehensive, terminal-based email setup";
  };

  config = lib.mkIf config.common.email.enable {
    home.packages = with pkgs; [
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

    xdg.configFile."isyncrc".target = "${config.xdg.configHome}/isync/isyncrc";

    home.shellAliases = {
      mbsync = "mbsync --config ${config.xdg.configHome}/isync/isyncrc";
    };

    programs = {
      mbsync = {
        enable = true;
        package = pkgs.isync.override {withCyrusSaslXoauth2 = true;};
        extraConfig = ''
          CopyArrivalDate yes
        '';
      };

      himalaya = {
        enable = true;
        settings = {
          downloads-dir = config.xdg.userDirs.download;
        };
      };
    };

    accounts.email = {
      maildirBasePath = "${config.xdg.dataHome}/mail";
    };
  };
}
