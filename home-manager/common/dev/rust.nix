{
  pkgs,
  config,
  lib,
  ...
}:
with lib; {
  options.common.dev.rust.enable = mkEnableOption "Rust dev tools";

  config = mkIf config.common.dev.rust.enable {
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
  };
}
