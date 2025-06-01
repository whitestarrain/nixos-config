{ config, pkgs, ... }:

{
  xdg = {
    enable = true;
    configFile."mimeapps.list".force = true;
    # mime types: https://www.iana.org/assignments/media-types/media-types.xhtml
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
          image = [ "sxiv.desktop" "mpv.desktop" ];
        in
        {
          "inode/directory" = [ "thunar.desktop" ];

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

          "x-scheme-handler/discord" = [ "discord.desktop" ];
          "x-scheme-handler/tg" = [ "org.telegram.desktop.desktop " ];
          "x-scheme-handler/vscode" = [ "code-url-handler.desktop" ]; # open `vscode://` url with `code-url-handler.desktop`
          "x-scheme-handler/vscode-insiders" = [ "code-insiders-url-handler.desktop" ]; # open `vscode-insiders://` url with `code-insiders-url-handler.desktop`
          # define default applications for some url schemes.
          # https://github.com/microsoft/vscode/issues/146408

          "image/avif" = image;
          "image/heif" = image;
          "image/jpeg" = image;
          "image/jxl" = image;
          "image/png" = image;
          "image/bmp" = image;
          "image/x-eps" = image;
          "image/x-icns" = image;
          "image/x-ico" = image;
          "image/x-portable-bitmap" = image;
          "image/x-portable-graymap" = image;
          "image/x-portable-pixmap" = image;
          "image/x-xbitmap" = image;
          "image/x-xpixmap" = image;
          "image/tiff" = image;
          "image/x-psd" = image;
          "image/x-webp" = image;
          "image/webp" = image;
          "image/x-tga" = image;
          "image/x-xcf" = image;
          "image/gif" = video;

          "application/ogg" = audio;
          "application/x-cue" = audio;
          "application/x-ogg" = audio;
          "application/xspf+xml" = audio;
          "audio/aac" = audio;
          "audio/flac" = audio;
          "audio/midi" = audio;
          "audio/mp3" = audio;
          "audio/mp4" = audio;
          "audio/mpeg" = audio;
          "audio/mpegurl" = audio;
          "audio/ogg" = audio;
          "audio/prs.sid" = audio;
          "audio/wav" = audio;
          "audio/x-flac" = audio;
          "audio/x-it" = audio;
          "audio/x-mod" = audio;
          "audio/x-mp3" = audio;
          "audio/x-mpeg" = audio;
          "audio/x-mpegurl" = audio;
          "audio/x-ms-asx" = audio;
          "audio/x-ms-wma" = audio;
          "audio/x-musepack" = audio;
          "audio/x-s3m" = audio;
          "audio/x-scpls" = audio;
          "audio/x-stm" = audio;
          "audio/x-vorbis+ogg" = audio;
          "audio/x-wav" = audio;
          "audio/x-wavpack" = audio;
          "audio/x-xm" = audio;
          "x-content/audio-cdda" = audio;

          "application/mxf" = video;
          "application/sdp" = video;
          "application/smil" = video;
          "application/streamingmedia" = video;
          "application/vnd.apple.mpegurl" = video;
          "application/vnd.ms-asf" = video;
          "application/vnd.rn-realmedia-vbr" = video;
          "application/vnd.rn-realmedia" = video;
          "application/x-extension-m4a" = video;
          "application/x-extension-mp4" = video;
          "application/x-matroska" = video;
          "application/x-mpegurl" = video;
          "application/x-ogm-audio" = video;
          "application/x-ogm" = video;
          "application/x-ogm-video" = video;
          "application/x-shorten" = video;
          "application/x-smil" = video;
          "application/x-streamingmedia" = video;
          "video/3gpp2" = video;
          "video/3gpp" = video;
          "video/3gp" = video;
          "video/avi" = video;
          "video/divx" = video;
          "video/dv" = video;
          "video/fli" = video;
          "video/flv" = video;
          "video/mkv" = video;
          "video/mp2t" = video;
          "video/mp4v-es" = video;
          "video/mp4" = video;
          "video/mpeg" = video;
          "video/msvideo" = video;
          "video/ogg" = video;
          "video/quicktime" = video;
          "video/vnd.avi" = video;
          "video/vnd.divx" = video;
          "video/vnd.mpegurl" = video;
          "video/vnd.rn-realvideo" = video;
          "video/webm" = video;
          "video/x-avi" = video;
          "video/x-flc" = video;
          "video/x-flic" = video;
          "video/x-flv" = video;
          "video/x-m4v" = video;
          "video/x-matroska" = video;
          "video/x-mpeg2" = video;
          "video/x-mpeg3" = video;
          "video/x-ms-afs" = video;
          "video/x-ms-asf" = video;
          "video/x-msvideo" = video;
          "video/x-ms-wmv" = video;
          "video/x-ms-wmx" = video;
          "video/x-ms-wvxvideo" = video;
          "video/x-ogm+ogg" = video;
          "video/x-ogm" = video;
          "video/x-theora+ogg" = video;
          "video/x-theora" = video;
          "video/MP2T" = video;
        };

      associations.removed = { };
    };
  };
}
