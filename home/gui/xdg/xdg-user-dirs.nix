{ config, helper, ... }:

{
  xdg = {
    enable = true;
    cacheHome = "${config.home.homeDirectory}/.cache";
    configHome = "${config.home.homeDirectory}/.config";
    dataHome = "${config.home.homeDirectory}/.local/share";
    stateHome = "${config.home.homeDirectory}/.local/state";

    userDirs = {
      enable = true;
      desktop = "$HOME/Desktop";
      documents = "$HOME/Documents";
      download = "$HOME/Downloads";
      music = "$HOME/Music";
      pictures = "$HOME/Pictures";
      publicShare = "/var/empty";
      templates = "/var/empty";
      videos = "$HOME/Videos";
      createDirectories = true;
      extraConfig = {
        XDG_SCREENSHOTS_DIR = "${config.xdg.userDirs.pictures}/Screenshots";
      };
    };
  };

  # https://github.com/NixOS/nixpkgs/blob/089d44b6892f5300bbec41c67fc1ecfee621d771/nixos/modules/services/x11/desktop-managers/default.nix#L78
  home.file.".background-image" = {
    source = helper.static.wallpaper;
    force = true;
  };
}
