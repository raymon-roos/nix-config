{
  stdenv,
  lib,
  rustPlatform,
  pkg-config,
  alsa-lib,
  nix-update-script,
  fetchFromGitHub,
}:
rustPlatform.buildRustPackage (finalAttrs: let
  name = "nu_plugin_audio";
  version = "v0.2.12";
in {
  pname = name;
  inherit version;

  src = fetchFromGitHub {
    owner = "SuaveIV";
    repo = name;
    tag = version;
    hash = "sha256-tNjr/8XV8bactjz1YU0XU78y1ng3kLdaemigzPZtNcI=";
  };

  cargoHash = "sha256-qfW5/RFKMN2ln/pYtry2C6kg9gRepsGBAkkk9tASZ9I=";

  nativeBuildInputs = [pkg-config] ++ lib.optionals stdenv.cc.isClang [rustPlatform.bindgenHook];
  buildInputs = [alsa-lib];

  doCheck = false; # No tests from what I could see

  passthru.updateScript = nix-update-script {};

  meta = {
    description = "Nushell plugin for interacting with audio files & data";
    mainProgram = name;
    license = lib.licenses.mit;
    # maintainers = witk pkgs.lib.maintainers [];
  };
})
