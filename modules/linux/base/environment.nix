{ pkgs, config, ... }:

{

  environment.systemPackages = with pkgs; [
    linux-manual
    man-pages
    man-pages-posix
  ];

  documentation = {
    enable = true;
    man = {
      enable = true;
      generateCaches = false; # really slow
    };
    dev = {
      enable = true;
    };
  };

  environment.enableAllTerminfo = true;
  environment.homeBinInPath = true;
  environment.localBinInPath = true;

  hardware.ksm.enable = !config.boot.isContainer;

  services.fstrim.enable = !config.boot.isContainer;
  services.irqbalance.enable = !config.boot.isContainer;
  services.journald.extraConfig = ''
    ForwardToConsole=no
    ForwardToKMsg=no
    ForwardToWall=no
    Storage=persistent
    SystemMaxFileSize=10M
    SystemMaxUse=100M
  '';

  programs = {
    command-not-found.enable = false;
    htop.enable = true;
    iftop.enable = true;
    iotop.enable = true;
    less = {
      enable = true;
      lessopen = null;
    };
    mtr.enable = true;
    traceroute.enable = true;

    fuse = {
      mountMax = 32767;
      userAllowOther = true;
    };
  };
  system.fsPackages = [ pkgs.bindfs ];

  environment.sessionVariables = {
     QT_AUTO_SCREEN_SCALE_FACTOR=1;
  };
}
