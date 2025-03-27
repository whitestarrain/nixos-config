{
  # ssh config
  programs.ssh = {
    enable = true;
    extraConfig = ''
      # Sometimes github.com will resolve to a foreign ip, causing it to be unable to connect
      Host github.com
          HostName ssh.github.com
          Port 443
    '';
  };
}
