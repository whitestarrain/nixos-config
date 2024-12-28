{ config, lib, pkgs, helper, ... }:

{
  users.mutableUsers = false;

  users.users.wsain = {
    isNormalUser = true;
    extraGroups = [ "wheel" "networkmanager" "mlocate" ];
    openssh.authorizedKeys.keys = helper.constants.sshAuthorizedKeys;
    hashedPassword = "$7$CU..../....9Jbzo2I2ZKSynZSRGDTq/.$zNXBGm5xiuRRYNoA0EBmDciiLOGUksa3IrtjhNNsb./";
  };

  users.groups = {
    wsain = {};
    docker = {};
    container = {};
    mlocate = {};
  };

  home-manager.users.wsain = rec {
    imports = (helper.lib.scanRelativeRootPath "home/tui") ++ [{ _module.args = { user = "wsain"; }; }];
    home.username = "wsain";
    home.homeDirectory = "/home/wsain";
    home.stateVersion = "24.05";
  };
}
