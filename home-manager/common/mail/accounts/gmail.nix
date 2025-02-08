{
  config,
  inputs,
  ...
}: let
  contact_info = import "${inputs.secrets}/contact_info.nix";
  mailHome = "${config.xdg.dataHome}/mail";
in {
  accounts.email.accounts.gmail = {
    flavor = "gmail.com";

    realName = contact_info.full_name;
    address = contact_info.gmail.address;
    userName = contact_info.gmail.address;
    passwordCommand = "pass mbsync/gmail | head -1";

    # mbsync = {
    #   enable = config.programs.mbsync.enable;
    #   subFolders = "Verbatim";
    #   create = "maildir";
    # };
    maildir.path = "gmail";

    folders = {
      inbox = "inbox";
      sent = "[Gmail]/Sent Mail";
      drafts = "[Gmail]/Drafts";
      trash = "[Gmail]/Bin";
    };

    himalaya = {
      enable = config.programs.himalaya.enable;
      settings = {
        backend = {
          type = "maildir";
          maildirpp = false;
          root-dir = "${mailHome}/${config.accounts.email.accounts.gmail.maildir.path}";
        };
      };
    };
  };
}
