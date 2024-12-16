{ pkgs, helper, user, ... }:

{
  # Let Home Manager install and manage itself.
  programs.home-manager.enable = true;

  # install software for through home.packages
  home.packages = (with pkgs;[
    # archives
    zip
    xz
    unzip
    p7zip
    gnutar
    # terminal file manager
    ranger
    # quick cd
    zoxide
    # search, find
    ripgrep
    fd
    fzf
    # file parse
    jq
    yq-go
    # others
    git
    tmux
    starship
    stow
    bat # better cat
    tldr # cheatsheet
    just
  ]);

  programs.git = {
    enable = true;
    userName = user;
    userEmail = helper.constants.githubEmail;
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

  # TODO: copy from file
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

}
