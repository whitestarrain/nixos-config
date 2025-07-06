{ pkgs, lib, ... }:

let
  copyq-wrapped = lib.hiPrio (
    pkgs.runCommand "copyq" { nativeBuildInputs = with pkgs; [ makeWrapper ]; } ''
      mkdir -p $out/bin
      makeWrapper \
        ${pkgs.copyq}/bin/copyq \
        $out/bin/copyq \
        --set QT_SCALE_FACTOR "1.5"
    ''
  );
in
{
  services.copyq = {
    enable = true;
    package = copyq-wrapped;
  };
}
