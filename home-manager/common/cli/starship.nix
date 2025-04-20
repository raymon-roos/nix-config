{
  config,
  osConfig,
  pkgs,
  lib,
  ...
}: let
  inherit (config.xdg) cacheHome configHome;
  starshipConfig = "${configHome}/starship/starship.toml";
in {
  xdg.configFile."starship.toml".target = starshipConfig;

  home.sessionVariables = {
    STARSHIP_CACHE = "${cacheHome}/starship";
    STARSHIP_CONFIG = starshipConfig;
  };

  programs.starship = {
    enable = true;
    settings = {
      add_newline = false;
      aws = {
        format = "[$symbol($profile)(\\($region\\))($duration\\])]($style) ";
        symbol = "  ";
      };
      buf = {symbol = " ";};
      bun = {format = "[$symbol($version)]($style) ";};
      c = {
        format = "[$symbol($version(-$name))]($style) ";
        symbol = " ";
      };
      cmake = {format = "[$symbol($version)]($style) ";};
      cmd_duration = {format = "[⏱ $duration]($style) ";};
      cobol = {format = "[$symbol($version)]($style) ";};
      conda = {
        format = "[$symbol$environment]($style) ";
        symbol = " ";
      };
      crystal = {
        format = "[$symbol($version)]($style) ";
        symbol = " ";
      };
      daml = {format = "[$symbol($version)]($style) ";};
      dart = {
        format = "[$symbol($version)]($style) ";
        symbol = " ";
      };
      deno = {format = "[$symbol($version)]($style) ";};
      directory = {
        read_only = " 󰌾";
        truncate_to_repo = false;
      };
      docker_context = {
        format = "[$symbol$context]($style) ";
        symbol = " ";
      };
      dotnet = {format = "[$symbol($version)(🎯 $tfm)]($style) ";};
      elixir = {
        format = "[$symbol($version \\(OTP $otp_version\\))]($style) ";
        symbol = " ";
      };
      elm = {
        format = "[$symbol($version)]($style) ";
        symbol = " ";
      };
      erlang = {format = "[$symbol($version)]($style) ";};
      fennel = {
        format = "[$symbol($version)]($style) ";
        symbol = " ";
      };
      fossil_branch = {
        format = "[$symbol$branch]($style) ";
        symbol = " ";
      };
      gcloud = {
        disabled = true;
        format = "[$symbol$account(@$domain)(\\($region\\))]($style) ";
      };
      git_branch = {
        format = "[$symbol$branch]($style) ";
        symbol = " ";
      };
      git_status = {format = "([$all_status$ahead_behind\\]]($style)) ";};
      golang = {
        format = "[$symbol($version)]($style) ";
        symbol = " ";
      };
      gradle = {format = "[$symbol($version)]($style) ";};
      guix_shell = {
        format = "[$symbol]($style) ";
        symbol = " ";
      };
      haskell = {
        format = "[$symbol($version)]($style) ";
        symbol = " ";
      };
      haxe = {
        format = "[$symbol($version)]($style) ";
        symbol = " ";
      };
      helm = {format = "[$symbol($version)]($style) ";};
      hg_branch = {
        format = "[$symbol$branch]($style) ";
        symbol = " ";
      };
      hostname = {ssh_symbol = " ";};
      java = {
        format = "[$symbol($version)]($style) ";
        symbol = " ";
      };
      jobs = {
        format = "[$number$symbol]($style)";
        symbol = "⚙︎";
      };
      julia = {
        format = "[$symbol($version)]($style) ";
        symbol = " ";
      };
      kotlin = {
        format = "[$symbol($version)]($style) ";
        symbol = " ";
      };
      kubernetes = {format = "[$symbol$context( \\($namespace\\))]($style) ";};
      lua = {
        format = "[$symbol($version)]($style) ";
        symbol = " ";
      };
      memory_usage = {
        format = "$symbol[$ram( | $swap)]($style) ";
        symbol = "󰍛 ";
      };
      meson = {
        format = "[$symbol$project]($style) ";
        symbol = "󰔷 ";
      };
      nim = {
        format = "[$symbol($version)]($style) ";
        symbol = "󰆥 ";
      };
      nix_shell = {
        format = "[$symbol$state( \\($name\\))]($style) ";
        symbol = " ";
      };
      nodejs = {
        format = "[$symbol($version)]($style) ";
        symbol = " ";
      };
      ocaml = {
        format = "[$symbol($version)(\\($switch_indicator$switch_name\\))]($style) ";
        symbol = " ";
      };
      opa = {format = "[$symbol($version)]($style) ";};
      openstack = {format = "[$symbol$cloud(\\($project\\))]($style) ";};
      os = {
        format = "[$symbol]($style) ";
        symbols = {
          AlmaLinux = " ";
          Alpaquita = " ";
          Alpine = " ";
          Amazon = " ";
          Android = " ";
          Arch = " ";
          Artix = " ";
          CentOS = " ";
          Debian = " ";
          DragonFly = " ";
          Emscripten = " ";
          EndeavourOS = " ";
          Fedora = " ";
          FreeBSD = " ";
          Garuda = "󰛓 ";
          Gentoo = " ";
          HardenedBSD = "󰞌 ";
          Illumos = "󰈸 ";
          Kali = " ";
          Linux = " ";
          Mabox = " ";
          Macos = " ";
          Manjaro = " ";
          Mariner = " ";
          MidnightBSD = " ";
          Mint = " ";
          NetBSD = " ";
          NixOS = " ";
          OpenBSD = "󰈺 ";
          OracleLinux = "󰌷 ";
          Pop = " ";
          Raspbian = " ";
          RedHatEnterprise = " ";
          Redhat = " ";
          Redox = "󰀘 ";
          RockyLinux = " ";
          SUSE = " ";
          Solus = "󰠳 ";
          Ubuntu = " ";
          Unknown = " ";
          Void = " ";
          Windows = "󰍲 ";
          openSUSE = " ";
        };
      };
      package = {
        format = "[$symbol$version]($style) ";
        symbol = "󰏗 ";
      };
      perl = {
        format = "[$symbol($version)]($style) ";
        symbol = " ";
      };
      php = {
        format = "[$symbol($version)]($style) ";
        symbol = " ";
      };
      pijul_channel = {
        format = "[$symbol$channel]($style) ";
        symbol = " ";
      };
      pulumi = {format = "[$symbol$stack]($style) ";};
      purescript = {format = "[$symbol($version)]($style) ";};
      python = {
        format = "[\${symbol}\${pyenv_prefix}(\${version})(\\($virtualenv\\))]($style) ";
        symbol = " ";
      };
      raku = {format = "[$symbol($version-$vm_version)]($style) ";};
      red = {format = "[$symbol($version)]($style) ";};
      rlang = {symbol = "󰟔 ";};
      ruby = {
        format = "[$symbol($version)]($style) ";
        symbol = " ";
      };
      rust = {
        format = "[$symbol($version)]($style) ";
        symbol = " ";
      };
      scala = {
        format = "[$symbol($version)]($style) ";
        symbol = " ";
      };
      shlvl = {
        disabled = false;
        format = "[$symbol$shlvl]($style) ";
        symbol = "";
        threshold = 3;
      };
      solidity = {format = "[$symbol($version)]($style) ";};
      spack = {format = "[$symbol$environment]($style) ";};
      sudo = {format = "[as $symbol]($style) ";};
      swift = {
        format = "[$symbol($version)]($style) ";
        symbol = " ";
      };
      terraform = {format = "[$symbol$workspace]($style) ";};
      time = {format = "[$time]($style) ";};
      username = {format = "[$user]($style) ";};
      vagrant = {format = "[$symbol($version)]($style) ";};
      vlang = {format = "[$symbol($version)]($style) ";};
      zig = {
        format = "[$symbol($version)]($style) ";
        symbol = " ";
      };
    };
  };
}
