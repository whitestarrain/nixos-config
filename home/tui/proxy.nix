{ pkgs, lib, ... }:

let
  clash-verge-pkg = pkgs.clash-verge-rev;
  switchproxy = pkgs.writeShellApplication {
    name = "switchproxy";
    text = ''
      default_proxy="http://127.0.0.1:7890"

      # run with proxy
      if [ $# -gt 0 ]; then
        export http_proxy="$default_proxy"
        export https_proxy="$default_proxy"
        export all_proxy="$default_proxy"
        "$@"
        exit
      fi

      # switch proxy
      if [ -n "$http_proxy" ] || [ -n "$https_proxy" ] || [ -n "$all_proxy" ]; then
        echo "unset terminal proxy"
        unset http_proxy https_proxy all_proxy
        exit
      fi
      export http_proxy="$default_proxy"
      export https_proxy="$default_proxy"
      export all_proxy="$default_proxy"
      echo "set terminal proxy"
    '';
  };
in
{
  home.packages = [
    pkgs.proxychains-ng
    switchproxy
  ];

  programs.bash.shellAliases = {
    sp = "switchproxy";
  };
}


