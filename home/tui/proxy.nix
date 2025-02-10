{ pkgs, lib, ... }:

let
  clash-verge-pkg = pkgs.clash-verge-rev;
in
{
  home.packages = [
    pkgs.proxychains-ng
  ];

  programs.bash = {
    initExtra = ''
      # swich proxy
      alias sp="switchproxy"
      function switchproxy {
        if [ -n "$http_proxy" ] || [ -n "$https_proxy" ] || [ -n "$all_proxy" ]; then
          echo "unset terminal proxy"
          unset http_proxy https_proxy all_proxy
          return
        fi
        default_proxy="http://127.0.0.1:7890"
        export http_proxy="$default_proxy"
        export https_proxy="$default_proxy"
        export all_proxy="$default_proxy"
        echo "set terminal proxy"
      }
    '';
  };
}


