{pkgs, ...}: {
  imports = [
    ./php.nix
    ./nodejs.nix
    ./rust.nix
    ./nix.nix
    ./python.nix
    ./go.nix
    ./container.nix
  ];

  home.packages = with pkgs; [
    gcc # For automatically compiling treesitter parsers
    gnumake # for building telescope-fzf-native nvim plugin
    lua51Packages.lua
    lua51Packages.luarocks-nix # For installing nvim plugins
    universal-ctags # For my custom zettelkasten setup
    # LSPs
    ltex-ls-plus # Maintained fork of ltex-ls
    harper # Newer, faster Ltex-ls alternative. English only.
    vscode-langservers-extracted # CSS/HTML/ESlint/JSON/MarkDown
    superhtml # Stricter HTML LSP
    # tailwindcss-language-server
    emmet-language-server # HTML real time snippet "language"
    lua-language-server
    # docker-compose-language-service
    # dockerfile-language-server-nodejs
    # haskell-language-server
    # arduino-language-server

    # Formatters
    stylelint # The stylelint CSS linter with automatic formatting/fix-on-save
    shfmt
    shellharden
    nodePackages.prettier # Opiniated everything-formatter
    # blade-formatter # not making a lot of frontend pages at the moment

    # Linters
    stylelint # Css
    shellcheck-minimal
    selene # Latest Lua linter
    # hadolint # Dockerfile
  ];

  programs.direnv = {
    enable = true;
    nix-direnv.enable = true;
    silent = true;
    stdlib = ''
      declare -A direnv_layout_dirs
      direnv_layout_dir() {
          local hash path
          echo "''${direnv_layout_dirs[$PWD]:=$(
              hash="$(sha1sum - <<< "$PWD" | head -c20)"
              path="''${PWD//[^a-zA-Z0-9]/-}"
              echo "''${XDG_CACHE_HOME}/direnv/layouts/$hash$path"
          )}"
      }
    '';
  };
}
