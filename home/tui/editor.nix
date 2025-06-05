{ pkgs, pkgs-2411, ... }:

{
  home.packages = ([
    pkgs-2411.neovim
    pkgs.emacs
  ]);

  programs.bash = {
    initExtra = ''
      export EDITOR='nvim -u NONE'
      export MANPAGER="nvim +Man!"
    '';
  };
}
