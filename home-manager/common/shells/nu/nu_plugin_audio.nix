{
  stdenv,
  lib,
  rustPlatform,
  pkg-config,
  alsa-lib,
  nix-update-script,
  fetchFromGitHub,
}:
rustPlatform.buildRustPackage (finalAttrs: {
  pname = "nu_plugin_audio";
  version = "v0.2.7";

  src = fetchFromGitHub {
    owner = "SuaveIV";
    repo = "nu_plugin_audio";
    rev = "dependabot/cargo/nushell-c29c2c90a6";
    hash = "sha256-9xu1VXmonTXm6BmhehIsuy9bGGj20wrc10i/6RbxkzM=";
  };

  cargoHash = "sha256-rmg6MHtIUsC54CfqLCBsArypug8wOztlBIsgs3NtLow=";

  nativeBuildInputs = [pkg-config] ++ lib.optionals stdenv.cc.isClang [rustPlatform.bindgenHook];
  buildInputs = [alsa-lib];

  doCheck = false; # No tests from what I could see

  passthru.updateScript = nix-update-script {};

  meta = {
    description = "Nushell plugin for interacting with audio files & data";
    mainProgram = "nu_plugin_audio";
    license = lib.licenses.mit;
    # maintainers = witk pkgs.lib.maintainers [];
  };
})
