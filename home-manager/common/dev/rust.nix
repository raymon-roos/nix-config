{
  pkgs,
  config,
  ...
}: {
  home.sessionVariables = {
    CARGO_HOME = "${config.xdg.dataHome}/cargo";
    RUSTUP_HOME = "${config.xdg.dataHome}/rustup";
  };

  home.packages = with pkgs; [
    rustc
    rust-analyzer
    rustfmt
    bacon
    cargo
    clippy
  ];
}
