{ pkgs, ... }:

{
  environment.systemPackages = with pkgs; [
    sshfs
  ];

  # Enable the OpenSSH daemon.
  services.openssh = {
    enable = true;
    ports = [ 2222 ];
    allowSFTP = true;
    settings = {
      PasswordAuthentication = false; # disable password login
    };
  };
}
