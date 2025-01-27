{ pkgs, ... }:

{
  environment.systemPackages = with pkgs; [ bluetuith ];
  hardware.bluetooth = {
    enable = true;
    powerOnBoot = false;
  };
}
