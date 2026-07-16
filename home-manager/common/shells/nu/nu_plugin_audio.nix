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
  version = "v0.2.9";

  src = fetchFromGitHub {
    owner = "SuaveIV";
    repo = "nu_plugin_audio";
    tag = "v0.2.9";
    hash = "sha256-dc/PgCp+nUb2hKp2IUpy3geNAiFZyMcsC3SQGaWog18=";
  };

  cargoHash = "sha256-lUElkLey9gdUFXIfX0J3jPMv3znkVREwbOpWe5bj3fg=";

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
