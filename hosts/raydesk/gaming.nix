{
  config,
  pkgs,
  lib,
  inputs,
  ...
}:
with lib; {
  options.gaming.enable = mkEnableOption "software and configs required to game on Linux";

  config = mkIf config.gaming.enable {
    specialisation.gaming.configuration = {
      system.nixos.tags = ["gaming"];

      boot = {
        # - BORE is a custom thread scheduler that supposedly is better for gaming
        #   maintaining reactivity for interactive processing under heavy load
        # - LTO is an advanced compiler optimization that considers the whole program to decide to inline functions & loops or remove dead code
        # - x86_64-v3 is a compiler option to enable architecture-specific optimizations (presumably by making use of arch specific machine instructions?)
        # My CPU & GPU are only just about modern enough to be compatible
        kernelPackages = inputs.nix-cachyos-kernel.legacyPackages.${pkgs.stdenv.hostPlatform.system}.linuxPackages-cachyos-bore-lto-x86_64-v3;

        # Changes taken from https://github.com/kronflux/nixos-gaming/blob/main/modules/core/boot.nix
        kernel.sysctl = {
          # Gaming scheduler tuning (from steamos-customizations-jupiter)
          "kernel.sched_cfs_bandwidth_slice_u" = 3000;
          "kernel.sched_latency_ns" = 3000000;
          "kernel.sched_min_granularity_ns" = 300000;
          "kernel.sched_wakeup_granularity_ns" = 500000;
          "kernel.sched_migration_cost_ns" = 50000;
          "kernel.sched_nr_migrate" = 128;

          # Disable split-lock mitigation (performance impact on some games)
          "kernel.split_lock_mitigate" = 0;

          # Required by many modern games (Proton/Wine)
          "vm.max_map_count" = 2147483642;
        };
      };

      programs = {
        steam = {
          enable = true;
          package = pkgs.steam.override {
            extraBwrapArgs = [
              "--bind $HOME/files/games/steam $HOME"
              "--unsetenv XDG_CACHE_HOME"
              "--unsetenv XDG_CONFIG_HOME"
              "--unsetenv XDG_DATA_HOME"
              "--unsetenv XDG_STATE_HOME"
            ];
          };
          extraCompatPackages = [
            pkgs.proton-ge-bin
          ];
        };
        gamescope = {
          enable = true;
          args = [
            "-W 1920"
            "-H 1080"
            "-r 60"
            "-f"
            "--force-grab-cursor"
          ];
        };
        gamemode = {
          enable = true;
          settings = {
            general = {
              renice = 17; # Automatically negated. -20 is highest prio, 19 lowest
              inhibit_screensaver = 0;
            };

            custom = let
              notify-send = lib.getExe' pkgs.libnotify "notify-send";
              hyprctl = lib.getExe' pkgs.hyprland "hyprctl";
              hyprgamemode =
                pkgs.writeShellScriptBin "hyprgamemode"
                ''
                  ${notify-send} 'GameMode toggled' --expire-time 2000
                  # If animations are enabled, disable them and other graphical decorations
                  HYPRGAMEMODE="$(${hyprctl} getoption animations:enabled | awk 'NR==1{print $2}')"
                  if [ "$HYPRGAMEMODE" = 1 ] ; then
                      ${hyprctl} --batch "\
                          keyword animations:enabled 0;\
                          keyword decoration:shadow:enabled 0;\
                          keyword decoration:blur:enabled 0;\
                          keyword decoration:rounding 0"
                      exit
                  fi
                  ${hyprctl} reload # Reload config, discarding runtime configuration
                '';
            in
              lib.mkIf config.home-manager.users.ray.common.hyprland.enable {
                start =
                  lib.optionalString
                  config.home-manager.users.ray.common.hyprland.enable
                  (lib.getExe hyprgamemode);
                end =
                  lib.optionalString
                  config.home-manager.users.ray.common.hyprland.enable
                  (lib.getExe hyprgamemode);
              };
          };
        };
      };

      users.users.ray.extraGroups = ["gamemode"];

      environment.systemPackages = with pkgs; [
        wine-wayland
        gamescope
        # bottles
        # lutris
      ];
    };
  };
}
