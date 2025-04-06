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
        s = "preview-tabbed";
        z = "autojump";
        c = "cdpath";
        m = "chksum"; # Create and verify checksums
        f = "finder"; # find
        n = "fixname"; # fix name
        b = "oldbigfile"; # List large files by access time
        o = "nuke";
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
    ];
  };

  # add -c option to swallow window
  programs.bash = {
    initExtra = (builtins.readFile ./quitcd.sh);
  };
}
