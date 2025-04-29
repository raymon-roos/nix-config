{
  pkgs,
  inputs,
  ...
}: {
  environment = {
    etc."kanata/keymap.kbd".source = ./keymap.kbd;
    systemPackages = [pkgs.kanata];
  };

  launchd.daemons = {
    # The driverkit extension has to be installed manually!
    # Since driverkit 4.0.0, its daemon needs to be started explicitly
    # https://github.com/kmonad/kmonad/blob/master/doc/installation.md#starting-the-dext-daemon
    # Both the driverkit daemon & kanata need their binaries added to settings > Privacy & Security > Input Monitoring.
    # Note that for the system shell (bash), spaces in executable paths need to
    # be escaped with a backslash, and backslashes need to be escaped for Nix.
    dext = {
      command = "/Library/Application\\ Support/org.pqrs/Karabiner-DriverKit-VirtualHIDDevice/Applications/Karabiner-VirtualHIDDevice-Daemon.app/Contents/MacOS/Karabiner-VirtualHIDDevice-Daemon";
      serviceConfig = {
        Label = "org.pqrs.service.daemon.Karabiner-VirtualHIDDevice-Daemon";
        KeepAlive = true;
        RunAtLoad = true;
        ProcessType = "Interactive";
        StandardOutPath = /tmp/dext.stdout;
        StandardErrorPath = /tmp/dext.stderr;
      };
    };
    kanata = {
      command = "${pkgs.kanata}/bin/kanata --cfg /etc/kanata/keymap.kbd";
      serviceConfig = {
        Label = "local.kanata";
        KeepAlive = true;
        RunAtLoad = true;
        StandardOutPath = /tmp/kanata.stdout;
        StandardErrorPath = /tmp/kanata.stderr;
      };
    };
  };
}
