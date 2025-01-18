{ pkgs, ... }:

{
  environment.systemPackages = with pkgs; [
    # basic
    vim
    wget
    curl
    git
    tmux
    which
    gnutar
    zip
    rsync
    gnused
    gawk
    file
    which
    tree
    ripgrep

    # monitor
    btop # bashtop, replacement of htop/nmon
    iotop # io monitoring
    iftop # network monitoring
    tcpdump
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

    # boot
    efibootmgr

    # misc
    neofetch
    gnupg
    just
    zstd
    mlocate
    openssl
    nix-tree
  ];
}
