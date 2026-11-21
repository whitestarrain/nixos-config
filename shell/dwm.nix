{ pkgs ? import <nixpkgs> { } }:

pkgs.mkShell {
  # 继承 nixpkgs#dwm 的全部构建依赖
  inputsFrom = [ pkgs.dwm ];

  # 在 dwm 环境基础上，追加 patch 的依赖
  buildInputs = [ pkgs.libxcursor pkgs.libxcb ];
}
