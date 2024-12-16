{
  boot.loader.systemd-boot = {
    enable = true;
  };
  boot.loader.efi.canTouchEfiVariables = true;

  # boot animation
  # boot.plymouth = {
  #   enable = true;
  # };
}
