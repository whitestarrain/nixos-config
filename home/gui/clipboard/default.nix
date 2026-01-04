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
  clipmenu = pkgs.writeShellScriptBin "clipmenu" ''
    ${copyq}/bin/copyq menu
  '';
in
{
  services.copyq = {
    enable = true;
    package = copyq;
  };
  home.packages = [
    clipmenu
  ];
  xdg.configFile = {
    "copyq/copyq-commands.ini" = {
      source = ./copyq-commands.ini;
      force = true;
    };
  };
}
