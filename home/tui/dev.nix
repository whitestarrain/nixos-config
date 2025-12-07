{ pkgs, ... }:

{
  home.packages = (
    with pkgs;
    [
      # bash
      dos2unix
      shellcheck
      shfmt

      # c
      autoconf
      automake
      binutils
      bison
      clang-analyzer
      clang-tools # format, lsp
      lldb # debug
      cmake
      cppcheck
      fakeroot
      file
      findutils
      flex
      gawk
      gcc
      gdb
      gettext
      gnumake
      groff
      libtool
      lldb
      m4
      patch
      pkgconf
      texinfo
      which

      # golang
      go

      # latex
      # texlive.combined.scheme-full

      # lua
      lua5_4_compat
      lua54Packages.luarocks
      lua-language-server

      # nodejs
      nodejs
      nodePackages.npm

      # python
      python313

      # java
      jdk17

      # python
      black
      virtualenv
      yapf

      # Rust
      rustup

      # ruby
      ruby

      # nix related
      nix-output-monitor # it provides the command `nom` works just like `nix` with more details log output
      nix-index # A small utility to index nix store paths
      nix-init # generate nix derivation from url
      nix-melt # A TUI flake.lock viewer
      nix-tree # A TUI to visualize the dependency graph of a nix derivation
      nix-diff # Explain why two Nix derivations differ
      hydra-check # check hydra(nix's build farm) for the build status of a package
      nixfmt-rfc-style
      nixpkgs-fmt
      nil # nix language server

      # misc
      protobuf
      subversion # version control
    ]
  );

  programs.go = {
    enable = true;
    goBin = ".local/bin";
    goPath = ".local/share/go";
  };

  programs.bash.initExtra = ''
    nix-dev() {
      nix develop $* -c nix shell nixpkgs#bashInteractive -c bash
    }
  '';

  xdg.configFile."pip/pip.conf".text = ''
    [global]
    index-url = https://mirrors.aliyun.com/pypi/simple
  '';

  programs = {
    direnv = {
      enable = true;
      nix-direnv.enable = true;
      enableBashIntegration = true;
    };
  };

  # extra jdk version
  home.file = (
    builtins.listToAttrs (
      builtins.map
        (jdk: {
          name = ".dev/jdks/${jdk.pname}_${jdk.version}";
          value = {
            source = jdk;
          };
        })
        [
          pkgs.jdk8
          pkgs.jdk11_headless
          pkgs.jdk17_headless
          pkgs.jdk21_headless
          pkgs.jdk25_headless
          pkgs.zulu11
          pkgs.zulu17
          pkgs.zulu25
        ]
    )
  );
}
