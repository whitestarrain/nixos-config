{ pkgs, ... }:

{
  environment.systemPackages = with pkgs; [ impala ];
  networking.wireless.iwd.enable = true;
}
