{ pkgs, pkgs-unstable, ... }:

{
  programs.nnn = {
    enable = true;
    package = (pkgs-unstable.nnn.override {
      withNerdIcons = true;
    }).overrideAttrs (old: {
      patches = (old.patches or [ ]) ++ [ ./patches/keymap.patch ];
    });
    plugins = {
      src = "${pkgs.nnn}/share/plugins";
      mappings = {
        p = "preview-tui";
        # TODO: use st rather than xterm
        s = "preview-tabbed";
        z = "autojump";
        b = "cdpath"; # cd bookmark
        f = "finder"; # find
        n = "fixname"; # fix name
        o = "nuke";
        c = "chksum"; # create and verify checksums
        m = "nmount";
      };
    };
    extraPackages = with pkgs; [
      zoxide
      fzf
      renameutils
      moreutils
      mpv
      sxiv
      zathura
      tabbed
      nsxiv
      vim
      mktemp
      xdotool
      ueberzugpp
      atool # archive command line helper
      jq
      udisks
      # util-linux # lsblk
    ];
  };

  # add -c option to swallow window
  programs.bash = {
    initExtra = (builtins.readFile ./quitcd.sh);
  };
}
