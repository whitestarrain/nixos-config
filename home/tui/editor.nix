{ pkgs, ... }:

{
  home.packages = (with pkgs;[
    neovim
    emacs
  ]);

  programs.bash = {
    initExtra = ''
      export EDITOR='nvim -u NONE'
    '';
  };
}


