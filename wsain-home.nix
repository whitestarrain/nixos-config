{ config, pkgs, pkgs-unstable, ... }:

{
  home.username = "wsain";
  home.homeDirectory = "/home/wsain";

  # Directly link the configuration file of the current folder to the specified location under the Home directory
  # home.file.".config/i3/wallpaper.jpg".source = ./wallpaper.jpg;

  # Recursively link files in a folder to the specified location in the Home directory
  # home.file.".config/i3/scripts" = {
  #   source = ./scripts;
  #   recursive = true;   # recursive the whole folder
  #   executable = true;  # chmod +x
  # };

  # Directly hardcode the file content in the nix configuration file as text
  # home.file.".xxx".text = ''
  #     xxx
  # '';

  # 设置鼠标指针大小以及字体 DPI（适用于 4K 显示器）
  # xresources.properties = {
  #   "Xcursor.size" = 16;
  #   "Xft.dpi" = 172;
  # };

  # install software for through home.packages
  home.packages = (with pkgs;[
    neofetch
    just

    # editor
    emacs
    neovim

    nnn # terminal file manager
    ranger

    zoxide # quick cd

    # archives
    zip
    xz
    unzip
    p7zip

    # utils
    ripgrep # recursively searches directories for a regex pattern
    jq # A lightweight and flexible command-line JSON processor
    yq-go # yaml processor https://github.com/mikefarah/yq
    eza # A modern replacement for ‘ls’
    fzf # A command-line fuzzy finder

    # networking tools
    mtr # A network diagnostic tool
    iperf3
    dnsutils # `dig` + `nslookup`
    ldns # replacement of `dig`, it provide the command `drill`
    aria2 # A lightweight multi-protocol & multi-source command-line download utility
    socat # replacement of openbsd-netcat
    nmap # A utility for network discovery and security auditing
    ipcalc # it is a calculator for the IPv4/v6 addresses

    # misc
    cowsay
    file
    which
    tree
    gnused
    gnutar
    gawk
    zstd
    gnupg

    # nix related
    #
    # it provides the command `nom` works just like `nix`
    # with more details log output
    nix-output-monitor

    # productivity
    # hugo # static site generator
    glow # markdown previewer in terminal

    btop # bashtop, replacement of htop/nmon
    iotop # io monitoring
    iftop # network monitoring

    # system call monitoring
    strace # system call monitoring
    ltrace # library call monitoring
    lsof # list open files

    # system tools
    sysstat
    lm_sensors # for `sensors` command
    # ethtool
    pciutils # lspci
    usbutils # lsusb

    nixfmt-rfc-style
  ]);

  # git config
  programs.git = {
    enable = true;
    userName = "wsain";
    userEmail = "55945266+whitestarrain@users.noreply.github.com";
  };

  # starship
  programs.starship = {
    enable = true;
    settings = {
      add_newline = true;
      aws.disabled = true;
      gcloud.disabled = true;
      line_break.disabled = false;
    };
  };

  # zoxide
  programs.zoxide = {
    enable = true;
  };

  programs.bash = {
    enable = true;
    enableCompletion = true;
    # bashrc content
    bashrcExtra = ''
      # If not running interactively, don't do anything
      [[ $- != *i* ]] && return
      
      # XDG
      export XDG_CONFIG_HOME=~/.config
      export XDG_CACHE_HOME=~/.cache
      export XDG_DATA_HOME=~/.local/share
      export XDG_STATE_HOME=~/.local/state
      
      # GnuPG
      export GNUPGHOME="$XDG_DATA_HOME"/gnupg
      
      # Javascript
      export NODE_REPL_HISTORY="$XDG_DATA_HOME"/node_repl_history
      export NPM_CONFIG_USERCONFIG="$XDG_CONFIG_HOME"/npm/npmrc
      
      # Python
      export PYTHONSTARTUP="$XDG_CONFIG_HOME"/python/repl_startup.py
      export PYTHONPYCACHEPREFIX="$XDG_CACHE_HOME"/python
      export PYTHONUSERBASE="$XDG_DATA_HOME"/python
      export IPYTHONDIR="$XDG_DATA_HOME"/ipython
      
      # Rust
      export CARGO_HOME="$XDG_DATA_HOME"/cargo
      export RUSTUP_HOME="$XDG_DATA_HOME"/rustup
      
      # default editor, manpager
      if which nvim &>/dev/null; then
        export EDITOR='nvim -u NONE'
        export MANPAGER="nvim +Man!"
      fi
      
      # prevent timeout
      export TMOUT=0
      
      # don't logout when press ctrl-d
      set -o ignoreeof
      
      # dircolors
      test -r ~/.dir_colors && eval "$(dircolors ~/.dir_colors)"
      
      # prompt before overwrite
      alias ls='ls --color=auto'
      alias grep='grep --color=auto'
      alias ssh='TERM=xterm-256color ssh'
      alias hisupdate='history -a; history -c; history -r;'
      
      PATH=$PATH:~/go/bin
      PATH=$PATH:~/.bin
      
      # history format
      export HISTTIMEFORMAT="[%Y-%m-%d %H:%M:%S] "
      
      # command history limit
      export HISTFILESIZE=10000                            # HISTFILE limit
      export HISTSIZE=2000                                 # shell session history limit
      export HISTIGNORE="&:[ ]*:exit:clear:ls:pwd:nvim:sp" # ignore command pattern, separated by :
      
      # history append
      shopt -s histappend
      
      # realtime update history file
      export PROMPT_COMMAND="history -a; $PROMPT_COMMAND"
      
      # support multiline command
      shopt -s cmdhist
      shopt -s lithist
      HISTTIMEFORMAT='%F %T '
    '';

    # alias
    shellAliases = {
      ra = "ranger";
    };
  };

  # This value determines the Home Manager release that your
  # configuration is compatible with. This helps avoid breakage
  # when a new Home Manager release introduces backwards
  # incompatible changes.
  #
  # You can update Home Manager without changing this value. See
  # the Home Manager release notes for a list of state version
  # changes in each release.
  home.stateVersion = "24.05";

  # Let Home Manager install and manage itself.
  programs.home-manager.enable = true;
}
