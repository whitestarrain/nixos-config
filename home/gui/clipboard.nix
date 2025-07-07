{
  pkgs,
  lib,
  helper,
  ...
}:

{
  services.copyq = {
    enable = true;
    package = helper.lib.wrapEnv pkgs.copyq "bin/copyq" {
      QT_SCALE_FACTOR = 1.5;
    };
  };
}
