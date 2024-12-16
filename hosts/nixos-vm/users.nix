{ config, lib, pkgs, helper, ... }:

{
  users.users.wsain = {
    isNormalUser = true;
    extraGroups = [ "wheel" "networkmanager" ]; # Enable ‘sudo’ for the user.
    openssh.authorizedKeys.keys = helper.constants.sshAuthorizedKeys;
  };

  home-manager.users.wsain = rec {
    imports = (helper.lib.scanRelativeRootPath "home/tui") ++ [{ _module.args = { user = "wsain"; }; }];
    home.username = "wsain";
    home.homeDirectory = "/home/wsain";
    home.stateVersion = "24.05";
  };
}
