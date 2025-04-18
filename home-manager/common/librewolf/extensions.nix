{
  config,
  lib,
  ...
}:
with lib; {
  programs.librewolf.policies = mkIf config.common.librewolf-advanced.enable {
    ExtensionSettings = let
      mkExt = name: uuid:
        nameValuePair uuid {
          installation_mode = "force_installed";
          install_url = "https://addons.mozilla.org/firefox/downloads/latest/${name}/latest.xpi";
        };
    in
      listToAttrs [
        # Best open source blocker
        (mkExt "ublock-origin" "uBlock0@raymondhill.net")
        # Prevent network requests to common CDNs
        (mkExt "localcdn-fork-of-decentraleyes" "{b86e4813-687a-43e6-ab65-0bde4ab75758}")
        # Dark mode everywhere
        (mkExt "darkreader" "addon@darkreader.org")
        # Make youtube bearable
        (mkExt "sponsorblock" "sponsorBlocker@ajay.app")
      ]
      // {
        # Vim emulation in the browser
        "tridactyl.vim.betas@cmcaine.co.uk" = {
          installation_mode = "force_installed";
          install_url = "https://tridactyl.cmcaine.co.uk/betas/tridactyl-latest.xpi";
        };
      };

    ExtensionUpdate = true;
  };
}
