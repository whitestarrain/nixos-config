{ pkgs, ... }:

{
  environment.systemPackages = with pkgs; [
    # basic
    vim
    neovim
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
    killall

    # monitor
    btop # bashtop, replacement of htop/nmon
    iotop # io monitoring
    iftop # network monitoring
    tcpdump
    sysstat
    smartmontools
    # system call monitoring
    strace # system call monitoring
    ltrace # library call monitoring
    lsof # list open files
    # system tools
    lm_sensors # for `sensors` command
    ethtool
    pciutils # lspci
    usbutils # lsusb
    lshw
    parted
    hdparm
    dmidecode

    # usb
    udisks
    eject

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

  # BCC - Tools for BPF-based Linux IO analysis, networking, monitoring, and more
  # https://github.com/iovisor/bcc
  # programs.bcc.enable = true;

  # replace default editor with neovim
  environment.variables.EDITOR = "nvim";
}
