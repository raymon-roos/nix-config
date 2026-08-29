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
  version = "v0.2.11";
in {
  pname = name;
  inherit version;

  src = fetchFromGitHub {
    owner = "SuaveIV";
    repo = name;
    tag = version;
    hash = "sha256-jXFAUCAtX0R17AFlhl6Fdr+D17aRmhMAi/slN4nktrs=";
  };

  cargoHash = "sha256-TrMzK78uCRAaig4Igy3yOgstxOuk3JyInwfQM3ECORY=";

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
