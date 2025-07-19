{ pkgs-unstable, lib, ... }:

{
  # dae
  services.dae = {
    enable = true;
    package = pkgs-unstable.dae;
    configFile = ./conf.dae;
  };
  # disable dae autostart
  systemd.services.dae.wantedBy = lib.mkForce [ ];
}
