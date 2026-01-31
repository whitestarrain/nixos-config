{ pkgs, helper, ... }:

{
  home.packages = ([
    pkgs.neovim
    (pkgs.emacs.override { withImageMagick = true; })
    pkgs.tesseract # ocr engine to get pdf toc
    # enable cuda will build cuda and magma
    # (pkgs.easyocr.override {
    #   torch = pkgs.python313Packages.torch.override { cudaSupport = true; };
    # })
    pkgs.easyocr
  ]);

  programs.bash = {
    initExtra = ''
      export EDITOR='nvim -u NONE'
      export MANPAGER="nvim +Man!"
    '';
  };
}
