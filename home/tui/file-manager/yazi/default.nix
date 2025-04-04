{ pkgs, pkgs-unstable, ... }:

{
  home.packages = (with pkgs;[
    ffmpeg-full
    p7zip
    jq
    poppler
    fd
    ripgrep
    fzf
    zoxide
    imagemagick
    xclip
    ueberzugpp
  ]);

  programs.yazi = {
    enable = true;
    package = pkgs-unstable.yazi;
    shellWrapperName = "y";
    settings = {
      manager = {
        show_hidden = true;
        sort_by = "natural";
        sort_dir_first = true;
        linemode = "size";
        show_symlink = true;
      };
    };
    keymap = {
      input.prepend_keymap = [
      ];
      manager.prepend_keymap = [
        { run = "quit"; on = [ "Q" ]; }
        { run = "quit --no-cwd-file"; on = [ "q" ]; }
      ];
    };
  };

  xdg.configFile = {
    "yazi/theme.toml" = {
      source = ./theme.toml;
      force = true;
    };
  };
}
