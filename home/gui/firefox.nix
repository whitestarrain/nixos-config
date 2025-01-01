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
        "app.update.auto" = false;
        "browser.shell.checkDefaultBrowser" = false;
        "browser.aboutConfig.showWarning" = false;

        "extension.activeThemeID" = "firefox-compact-dark@mozilla.org";

        "browser.newtabpage.activity-stream.feeds.topsites" = false;
        "browser.newtabpage.activity-stream.feeds.section.topstories" = false;

        "browser.toolbars.bookmarks.visibility" = "never";

        "extensions.pocket.enabled" = false;

        "findBar.highlightAll" = true;
      };
    };
  };
}
