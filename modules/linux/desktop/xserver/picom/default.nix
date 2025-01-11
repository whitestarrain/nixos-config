{ pkgs, lib, ... }:

{
  services.picom = {
    enable = true;
  };
  systemd.user.services.picom.serviceConfig.ExecStart = lib.mkForce ''
    ${pkgs.picom}/bin/picom --config ${./picom.conf}
  '';
}
