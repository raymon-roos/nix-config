{
  ...
}: {
  environment.variables = {
    "HOMEBREW_NO_ANALYTICS" = "1";
  };

  homebrew = {
    enable = true;
    onActivation.cleanup = "zap";

    taps = [
      "homebrew/core"
      "homebrew/cask"
      "homebrew/bundle"
      "nikitabobko/tap"
      "garden-rs/garden"
      "lindell/multi-gitter"
    ];

    brews = [
      "circleci"
      "garden"
      "helm"
      "multi-gitter"
    ];

    casks = [
      "dbngin"
      "herd"
      "librewolf"
      "plover"
      "dbeaver-community"
    ];
  };
}
