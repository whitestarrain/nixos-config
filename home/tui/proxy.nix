{ pkgs, lib, config, sysConfig, ... }:

let
  with-proxy = pkgs.writeShellApplication {
    name = "with-proxy";
    text = ''
      default_proxy="http://127.0.0.1:${sysConfig.wsainHostOption.proxy-port}"

      # run with proxy
      if [ $# -gt 0 ]; then
        export http_proxy="$default_proxy"
        export https_proxy="$default_proxy"
        export all_proxy="$default_proxy"
        "$@"
        exit
      fi
    '';
  };
in
{
  home.packages = [
    pkgs.proxychains-ng
    with-proxy
  ];

  home.file.".proxychains/proxychains.conf".text = ''
    [ProxyList]
    http 127.0.0.1 ${sysConfig.wsainHostOption.proxy-port}
  '';

  programs.bash = {
    initExtra = ''
      alias pc='proxychains4'
      # swich proxy
      alias sp="switchproxy"
      function switchproxy {
        if [ -n "$http_proxy" ] || [ -n "$https_proxy" ] || [ -n "$all_proxy" ]; then
          echo "unset terminal proxy"
          unset http_proxy https_proxy all_proxy
          return
        fi
        default_proxy="http://127.0.0.1:${sysConfig.wsainHostOption.proxy-port}"
        export http_proxy="$default_proxy"
        export https_proxy="$default_proxy"
        export all_proxy="$default_proxy"
        echo "set terminal proxy"
      }
    '';
  };
}


