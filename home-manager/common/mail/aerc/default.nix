{
  config,
  lib,
  pkgs,
  ...
}: {
  programs.aerc = {
    enable = true;
    extraConfig = {
      general = {
        unsafe-accounts-conf = true;
        default-menu-cmd = "fzf";
        enable-osc8 = true; # hyprlinks
      };
      ui = {
        completion-delay = "100ms";
        dirlist-delay = "130ms";
        dirlist-tree = true;
        icon-encrypted = "󰌾 ";
        icon-signed-encrypted = "󱦚 ";
        icon-signed = "󰕥 ";
        icon-unknown = " ";
        icon-invalid = "󰻍 ";
        icon-new = " ";
        icon-replied = " ";
        icon-forwarded = " ";
        icon-flagged = " ";
        icon-attachment = "󰁦 ";
        icon-marked = "";
        icon-deleted = " ";
        icon-draft = " ";
        sort = "-r date from";
        tab-title-account = "{{.Account}} {{if .Unread}}({{.Unread}}){{end}}";
        thread-prefix-tip = "";
        thread-prefix-indent = "";
        thread-prefix-stem = "│";
        thread-prefix-limb = "─";
        thread-prefix-folded = "+";
        thread-prefix-unfolded = "";
        thread-prefix-first-child = "┬";
        thread-prefix-has-siblings = "├";
        thread-prefix-orphan = "┌";
        thread-prefix-dummy = "┬";
        thread-prefix-lone = " ";
        thread-prefix-last-sibling = "╰";
      };
      viewer = {
        pager = ''bat --color=always --style=plain --wrap=never --file-name="$AERC_FILENAME"'';
      };
      filters = let
        wrap = "${config.programs.aerc.package}/libexec/aerc/filters/wrap";
        colorize = "${config.programs.aerc.package}/libexec/aerc/filters/colorize";
        calendar = "${config.programs.aerc.package}/libexec/aerc/filters/calendar";
        html = "${config.programs.aerc.package}/libexec/aerc/filters/html";
        nu = c: ''nu --no-config-file --no-std-lib --no-history --stdin -c "${c}"'';
      in
        {
          "text/plain" = "${wrap} -w 90 | ${colorize}";
          "text/html" = "${html} | ${colorize}";
          "text/calendar" = calendar;
          "image/*" = "kitten icat";
          "message/delivery-status" = "colorize";
        }
        // lib.optionalAttrs config.programs.nushell.enable {
          ".filename,~.*.csv" = nu "from csv --flexible | table -e -w 9999";
          ".filename,~.*.ssv" = nu "from csv --flexible --separator ';' | table -e -w 9999";
          ".filename,~.*.tsv" = nu "from csv --flexible --separator (char tab) | table -e -w 9999";
        }
        // lib.optionalAttrs (lib.any (p: p == pkgs.nushellPlugins.formats) config.programs.nushell.plugins && config.programs.nushell.enable) {
          "application/ics" = nu "${pkgs.writeScriptBin "filter_ics" ''
            #!/usr/bin/env -S nu --stdin
            def main [] {
              plugin use formats
              $in | from ics | table -e -w 9999
            }
          ''}/bin/filter_ics";
        };
      opener = {
        "application/pdf" = "zathura";
        "text/html" = "librewolf --private-window";
        "text/plain" = "kitty -c nvim";
      };
      compose = {
        empty-subject-warning = true;
        no-attachment-warning = "^[^>]*(attach(ed|ment)|(hier)?(bij|(gevoegd|lagen?)))";
        format-flowed = true; # Plain text with benefits
      };
    };
    extraBinds = builtins.readFile ./binds.conf;
  };
}
