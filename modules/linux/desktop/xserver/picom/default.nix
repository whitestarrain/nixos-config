{ pkgs, lib, ... }:

{
  services.picom = {
    enable = true;
    package = (
      pkgs.picom.overrideAttrs (
        finalAttrs: previousAttrs: {
          postInstall =
            (previousAttrs.postInstall or "")
            + ''
              rm -rf $out/etc/xdg/autostart
            '';
        }
      )
    );
  };
  systemd.user.services.picom.serviceConfig.ExecStart = lib.mkForce ''
    ${pkgs.picom}/bin/picom --config ${./picom.conf}
  '';
}
