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
    tag = "v0.2.7";
    hash = "sha256-3JVvPzL+jSqB3HJpLkdnQI+bsZQZhWAK/iBWbLquUoQ=";
  };

  cargoHash = "sha256-wKwaLE5mRuJ4PkuSv80+ATMi2bJh2FARzU+5o1KRM4k=";

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
