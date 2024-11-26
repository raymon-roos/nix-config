{
  config,
  pkgs,
  ...
}: {
  imports = [
    ../common.nix
    ./homebrew.nix
    ./aerospace.nix
  ];

  users.users.ray = {
    shell = pkgs.zsh;
    home = /Users/ray;
  };

  security.pam.enableSudoTouchIdAuth = true;

  # use with rosetta, run `softwareupdate --install-rosetta --agree-to-license` first
  nix = {
    optimise.automatic = true;
    settings.extra-platforms = [ "x86_64-darwin" "aarch64-darwin" ];
  };

  nixpkgs.hostPlatform = "aarch64-darwin";

  # Auto upgrade nix package and the daemon service.
  services = {
    nix-daemon.enable = true;
  };

  environment = {
    darwinConfig = ./configuration.nix;

    variables = {
      XDG_CACHE_HOME = "$HOME/.xdg/cache";
      XDG_CONFIG_HOME = "$HOME/.xdg/config";
      XDG_DATA_HOME = "$HOME/.xdg/local/share";
      XDG_STATE_HOME = "$HOME/.xdg/local/state";
    };
  };

  stylix = {
    autoEnable = false;
    fonts = {
      sizes.terminal = 12;
    };
  };

  launchd.daemons = {
      kmonad = {
        command = "/usr/local/bin/kmonad";
        serviceConfig = {
          Label = "local.kmonad";
          ProgramArguments = ["/Users/ray/.xdg/config/kmonad/keymap.kbd"];
          KeepAlive = true;
          RunAtLoad = true;
          StandardOutPath = /tmp/kmonad.stdout;
          StandardErrorPath = /tmp/kmonad.stderr;
        };
    };
  };

  system = {
    stateVersion = 5; # Do not change
    activationScripts.postUserActivation.text = ''
      # activateSettings -u reloads and applies settings from the database to the current session,
      # so no need to log out and in again
      /System/Library/PrivateFrameworks/SystemAdministration.framework/Resources/activateSettings -u
    '';

    defaults = {
      dock = {
        autohide = true;
        tilesize = 40;
        launchanim = false;
        mru-spaces = false;
      };

      trackpad = {
        ActuationStrength = 0; # 0 for Silent click
        FirstClickThreshold = 0; # 0 for light force
      };

      NSGlobalDomain = {
        "com.apple.trackpad.forceClick" = false;
        "com.apple.trackpad.scaling" = 3.0;
        AppleInterfaceStyle = "Dark";
        ApplePressAndHoldEnabled = false; # click-and-drag anywhere to move floating windows
        InitialKeyRepeat = 14; # Key repeat delay
        KeyRepeat = 2; # Key repeat rate
        NSTableViewDefaultSizeMode = 1; # Sidebar icon size, 1 for small
        _HIHideMenuBar = true;
      };

      finder = {
        ShowPathbar = true; # path breadcrumbs
        CreateDesktop = false; # desktop icons
        QuitMenuItem = true; # Allow quiting finder
        ShowStatusBar = true;
        _FXSortFoldersFirst = true; # Sort folders on top
        AppleShowAllExtensions = true;
        AppleShowAllFiles = true;
        FXPreferredViewStyle = "clmv"; # clmv for column view
        _FXShowPosixPathInTitle = true;
        FXDefaultSearchScope = "SCcf"; # FCcf to search only in current folder
      };

      CustomUserPreferences = {
        "com.apple.desktopservices" = {
          # Avoid creating .DS_Store files on network or USB volumes
          DSDontWriteNetworkStores = true;
          DSDontWriteUSBStores = true;
        };
        "com.apple.WindowManager" = {
          StandardHideDesktopIcons = 1; # Show items on desktop
          HideDesktop = 1; # Do not hide items on desktop & stage manager
        };
        "com.apple.AdLib".allowApplePersonalizedAdvertising = false;
      };
     
    };
    keyboard = {
      enableKeyMapping = true;
      remapCapsLockToControl = true;
      nonUS.remapTilde = true;
    };
  };
}
