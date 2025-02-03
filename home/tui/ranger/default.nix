{ pkgs, helper, flake-inputs, user, ... }:

{
  home.packages = (with pkgs;[
    # terminal file manager
    ranger
    ueberzugpp # used to preview image in terminal
  ]);

  # ranger
  programs.ranger = {
    enable = true;
    extraConfig = ''
      # icon
      default_linemode devicons
      set preview_images true
      set preview_images_method ueberzug
    '';
    settings = {
      show_hidden = "true";
    };
    mappings = {
      a = "console touch%space";
      r = "rename_append";
    };
    plugins = [
      {
        name = "ranger_devicons";
        src = helper.static.ranger_devicons;
      }
    ];
  };

  xdg.configFile."ranger/rifle.conf" = {
    source = ./rifile.conf;
    force = true;
  };

  programs.bash = {
    initExtra = (builtins.readFile "${flake-inputs.dotfiles}/bash/.bashrc.d/ranger.sh");
  };
}
