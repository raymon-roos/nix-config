{
  config,
  inputs,
  ...
}: let
  contact_info = import "${inputs.secrets}/contact_info.nix";
  mailHome = "${config.xdg.dataHome}/mail";
in {
  accounts.email.accounts.personal = {
    primary = true;
    # flavor = "outlook.office365.com";

    realName = contact_info.full_name;
    address = contact_info.personal.address;
    userName = contact_info.personal.address;
    passwordCommand = "pass mbsync/personal | head -1";

    # mbsync.enable = config.programs.mbsync.enable;
    maildir.path = "personal";

    # folders = {
    #   inbox = "inbox";
    #   sent = "Sent";
    #   drafts = "Drafts";
    #   trash = "Deleted";
    # };

    himalaya = {
      enable = config.programs.himalaya.enable;
      settings = {
        backend = {
          type = "maildir";
          maildirpp = false;
          root-dir = "${mailHome}/${config.accounts.email.accounts.personal.maildir.path}";
        };
        folder.aliases = {
          inbox = "inbox";
          sent = "Sent";
          drafts = "Drafts";
          trash = "Deleted";
        };
        # message.send.backend = {
        #   type = "smtp";
        #   host = "smtp.gmail.com";
        #   port = 465;
        #   login = "example@gmail.com";
        #   auth.type = "password";
        #   auth.cmd = "pass mbsync/gmail | head -1";
        # };
      };
    };
  };
}
