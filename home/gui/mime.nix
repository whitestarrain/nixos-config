{ config, pkgs, ... }:

{
  xdg = {
    enable = true;
    mimeApps = {
      enable = true;
      # let `xdg-open` to open the url with the correct application.
      # `ls /run/current-system/sw/share/applications/` to get desktop app
      defaultApplications =
        let
          browser = [ "firefox.desktop" ];
          editor = [ "nvim.desktop" ];
          video = [ "mpv.desktop" "vlc.desktop" ];
          audio = [ "audacious.desktop" "mpv.desktop" ];
          image = [ "sxiv.desktop" "imv-dir.desktop" ];
        in
        {
          "inode/directory" = [ "thunar.desktop" ];

          "application/ogg" = audio;
          "application/x-cue" = audio;
          "application/x-ogg" = audio;
          "application/xspf+xml" = audio;
          "x-content/audio-cdda" = audio;

          "application/json" = browser;
          "application/pdf" = browser;
          "application/rdf+xml" = browser;
          "application/rss+xml" = browser;
          "application/x-extension-htm" = browser;
          "application/x-extension-html" = browser;
          "application/x-extension-shtml" = browser;
          "application/x-extension-xht" = browser;
          "application/x-extension-xhtml" = browser;
          "application/xhtml+xml" = browser;
          "application/xml" = browser;
          "text/html" = browser;
          "text/markdown" = browser;
          "text/xml" = browser;
          "x-scheme-handler/about" = browser; # open `about:` url with `browser`
          "x-scheme-handler/ftp" = browser; # open `ftp:` url with `browser`
          "x-scheme-handler/http" = browser;
          "x-scheme-handler/https" = browser;

          "application/x-wine-extension-ini" = editor;
          "text/plain" = editor;

          "application/mxf" = video;
          "application/sdp" = video;
          "application/smil" = video;
          "application/streamingmedia" = video;
          "application/vnd.apple.mpegurl" = video;
          "application/vnd.ms-asf" = video;
          "application/vnd.rn-realmedia" = video;
          "application/vnd.rn-realmedia-vbr" = video;
          "application/x-extension-m4a" = video;
          "application/x-extension-mp4" = video;
          "application/x-matroska" = video;
          "application/x-mpegurl" = video;
          "application/x-ogm" = video;
          "application/x-ogm-audio" = video;
          "application/x-ogm-video" = video;
          "application/x-shorten" = video;
          "application/x-smil" = video;
          "application/x-streamingmedia" = video;

          "x-scheme-handler/discord" = [ "discord.desktop" ];
          "x-scheme-handler/tg" = [ "org.telegram.desktop.desktop " ];
          "x-scheme-handler/vscode" = [ "code-url-handler.desktop" ]; # open `vscode://` url with `code-url-handler.desktop`
          "x-scheme-handler/vscode-insiders" = [ "code-insiders-url-handler.desktop" ]; # open `vscode-insiders://` url with `code-insiders-url-handler.desktop`
          # define default applications for some url schemes.
          # https://github.com/microsoft/vscode/issues/146408

          "audio/*" = audio;
          "video/*" = video;
          "image/*" = image;
        };

      associations.removed = { };
    };
  };
}
