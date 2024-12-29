{ pkgs, lib, ... }:

{
  environment.variables = {
    MOZ_X11_EGL = "1";
    MOZ_USE_XINPUT2 = "1";
    MOZ_DISABLE_RDD_SANDBOX = "1";
  };

  # https://github.com/mozilla/policy-templates/blob/master/README.md
  programs.firefox = {
    enable = true;
    languagePacks = [ "zh-CN" ];
    # policies = { };
    preferences = {
      "browser.aboutConfig.showWarning" = false;
      "gfx.webrender.all" = true;
      "gfx.webrender.compositor.force-enabled" = true;
      "gfx.x11-egl.force-enabled" = true;
      "media.av1.enabled" = true;
      "media.ffmpeg.vaapi.enabled" = true;
      "media.hardware-video-decoding.force-enabled" = true;
      "media.hls.enabled" = true;
      "media.videocontrols.picture-in-picture.enabled" = false;
      "security.insecure_connection_text.enabled" = true;
      "security.insecure_connection_text.pbmode.enabled" = true;
      "security.osclientcerts.autoload" = true;
    };
    preferencesStatus = "locked";
  };
}
