{
  config,
  lib,
  inputs,
  ...
}:
with lib; let
  inherit (config.xdg) configHome;
  contact_info = import "${inputs.secrets}/contact_info.nix";
  mailHome = "${config.xdg.dataHome}/mail";
  cfg = config.common.email;
in {
  options.common.email = {
    accounts = mkOption {
      type = types.listOf (types.attrsOf types.anything);
      default = [];
      description = ''
        List of crucial values to use for configuring each account
      '';
    };
  };

  config.accounts.email.accounts = mkIf (cfg.enable && length cfg.accounts > 0) (
    cfg.accounts
    |> builtins.map ({
      accountName,
      flavor,
      primary ? false,
    }:
      nameValuePair accountName {
        inherit flavor primary;
        realName = contact_info.full_name;
        address = contact_info.${accountName}.address;
        userName = contact_info.${accountName}.address;
        # Manually run `oama -c <config> authorize <email>` first. Microsoft additionally requires the `--device` flag
        passwordCommand = "oama -c ${configHome}/oama/config.yaml access ${contact_info.${accountName}.address}";

        maildir.path = accountName;

        # "Standard" folders. Himalaya needs these in order to draft/send/delete etc.
        # These folders usually cannot be renamed on the server side, and different
        # providers have different names for them. Hence why channel groups are used
        # below to map remote folder names to this naming standard.
        folders = {
          inbox = "inbox";
          sent = "sent";
          drafts = "drafts";
          trash = "bin";
        };

        mbsync = {
          inherit (config.programs.mbsync) enable;
          extraConfig.account = {
            AuthMechs = "XOAUTH2"; # Requires cyrus-sasl-xoauth2
          };

          groups.${accountName} = mkIf (flavor == "outlook.office365.com" || flavor == "gmail.com") {
            channels =
              if flavor == "outlook.office365.com"
              then {
                # Catch-all for top-level folders that aren't part of another group
                inbox = {
                  farPattern = "";
                  nearPattern = "";
                  patterns = ["*" ''"!Sync Issues*"'' "!Snoozed" "!Notes" "!Archive" "!Outbox" "!Drafts" "!Sent" "!Deleted" "!Junk" "!drafts" "!sent" "!bin" "!junk"];
                };
                # Map folders on the remote to local folders adhering to the naming scheme
                drafts = {
                  farPattern = "Drafts";
                  nearPattern = "drafts";
                };
                sent = {
                  farPattern = "Sent";
                  nearPattern = "sent";
                };
                bin = {
                  farPattern = "Deleted";
                  nearPattern = "bin";
                };
                junk = {
                  farPattern = "Junk";
                  nearPattern = "junk";
                };
              }
              else {
                # Catch-all for top-level folders that aren't part of another group
                inbox = {
                  farPattern = "";
                  nearPattern = "";
                  patterns = ["*" "![Gmail]*" "!drafts" "!sent" "!bin" "!junk"];
                };
                # Map some common folders from weird gmail naming to standard names on the local maildir side
                drafts = {
                  farPattern = "[Gmail]/Drafts";
                  nearPattern = "drafts";
                };
                sent = {
                  farPattern = "[Gmail]/Sent Mail";
                  nearPattern = "sent";
                };
                bin = {
                  farPattern = "[Gmail]/Bin";
                  nearPattern = "bin";
                };
                junk = {
                  farPattern = "[Gmail]/Spam";
                  nearPattern = "junk";
                };
              };
          };
        };

        msmtp = {
          inherit (config.programs.msmtp) enable;
          extraConfig = {
            auth =
              if flavor == "outlook.office365.com"
              then "xoauth2"
              else "oauthbearer";
          };
        };

        himalaya = {
          inherit (config.programs.himalaya) enable;
          settings = {
            backend = {
              type = "maildir";
              root-dir = "${mailHome}/${accountName}";
            };
            message = {
              delete.style = "folder";
              send.backend = {
                type = "sendmail";
                cmd = "msmtp --read-envelope-from --read-recipients";
              };
            };
          };
        };

        aerc = {
          inherit (config.programs.aerc) enable;
          extraAccounts = {
            source = "maildir://${mailHome}/${accountName}";
            check-mail = 0;
            check-mail-cmd = "mbsync --config ${configHome}/isync/isyncrc ${accountName}";
            check-mail-timeout = "40s";
            outgoing = "msmtp --read-envelope-from --read-recipients";
            use-terminal-pinentry = false;
            folders-sort = ["inbox" "drafts" "sent" "bin" "junk"];
          };
        };
      })
    |> builtins.listToAttrs
  );
}
