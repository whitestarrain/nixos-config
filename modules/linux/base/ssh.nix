{ pkgs, ... }:

{
  environment.systemPackages = with pkgs; [
    sshfs
  ];

  # Enable the OpenSSH daemon.
  services.openssh = {
    enable = true;
    allowSFTP = true;
    settings = {
      PasswordAuthentication = false; # disable password login
    };
  };
}
