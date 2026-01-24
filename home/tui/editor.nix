{ pkgs, ... }:

{
  home.packages = ([
    pkgs.neovim
    (pkgs.emacs.override { withImageMagick = true; })
  ]);

  programs.bash = {
    initExtra = ''
      export EDITOR='nvim -u NONE'
      export MANPAGER="nvim +Man!"
    '';
  };
}
