{
  pkgs,
  lib,
  config,
  helper,
  ...
}:

let
  copyq = helper.lib.wrapEnv pkgs.copyq "bin/copyq" {
    QT_SCALE_FACTOR = 1.5;
  };
  backupScript = pkgs.writeShellScriptBin "clipmenu" ''
    ${copyq}/bin/copyq menu
  '';
in
{
  services.copyq = {
    enable = true;
    package = copyq;
  };
  home.packages = [
    backupScript
  ];
}
