{ pkgs, lib, ... }:

{
  home.sessionVariables = {
    MOZ_X11_EGL = "1";
    MOZ_USE_XINPUT2 = "1";
    MOZ_DISABLE_RDD_SANDBOX = "1";
  };

  # https://github.com/mozilla/policy-templates/blob/master/README.md
  programs.firefox = {
    enable = true;
    languagePacks = [ "zh-CN" ];
    # policies = { };
    profiles.default = {
      id = 0;
      name = "default";
      isDefault = true;
      bookmarks = { };
      settings = {
        # common
        "browser.newtabpage.activity-stream.feeds.topsites" = false;
        "browser.newtabpage.activity-stream.feeds.section.topstories" = false;
        "browser.toolbars.bookmarks.visibility" = "never";
        "findBar.highlightAll" = true;
        "browser.shell.checkDefaultBrowser" = false;
        # about:config
        "browser.aboutConfig.showWarning" = false;
        # gfx
        "gfx.webrender.all" = true;
        "gfx.webrender.compositor.force-enabled" = true;
        "gfx.x11-egl.force-enabled" = true;
        # media
        "media.av1.enabled" = true;
        "media.ffmpeg.vaapi.enabled" = true;
        "media.hardware-video-decoding.force-enabled" = true;
        "media.hls.enabled" = true;
        "media.videocontrols.picture-in-picture.enabled" = false;
        # security
        "security.insecure_connection_text.enabled" = true;
        "security.insecure_connection_text.pbmode.enabled" = true;
        "security.osclientcerts.autoload" = true;
        # disable auto update
        "app.update.auto" = false;
        "extensions.update.autoUpdateDefault" = false;
        # default theme
        "extension.activeThemeID" = "firefox-compact-dark@mozilla.org";
        # disable pocket
        "extensions.pocket.enabled" = false;
        # smooth scrool
        "general.smoothScroll" = true;
        "general.smoothScroll.currentVelocityWeighting" = 0;
        "general.smoothScroll.mouseWheel.durationMaxMS" = 150;
        "general.smoothScroll.stopDecelerationWeighting" = 0.82;
        "mousewheel.min_line_scroll_amount" = 10;
        "general.smoothScroll.msdPhysics.enabled" = true;
        # zoom
        "apz.doubletapzoom.defaultzoomin" = 1.2;
        # scale
        "layout.css.devPixelsPerPx" = 0.87;
        # disable ocsp_must_staple
        # "security.ssl.enable_ocsp_must_staple" = false;
      };
    };
  };
}
