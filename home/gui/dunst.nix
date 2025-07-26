{ pkgs, ... }:

{

  home.packages = (
    with pkgs;
    [
      dunst
      libnotify
    ]
  );
  services.dunst = {
    enable = true;
    settings = {
      global = {
        frame_color = "#d19a66";
        frame_width = 2;

        font = "Monospace 10";
        line_height = 0;
        padding = 8;
        horizontal_padding = 10;
        text_icon_padding = 0;

        alignment = "left";
        vertical_alignment = "center";

        # separator_color = "auto";
        # separator_height = 2;
        gap_size = 5;

        idle_threshold = 120;
        sort = "yes";
        ignore_newline = "no";
        markup = "full";
        format = "%s %p\n%b";

        icon_position = "left";
        min_icon_size = 0;
        max_icon_size = 64;

        notification_limit = 0;
        indicate_hidden = "yes";

        progress_bar = true;
        progress_bar_height = 10;
        progress_bar_frame_width = 1;
        progress_bar_min_width = 150;
        progress_bar_max_width = 300;

        mouse_left_click = "close_current";
        mouse_middle_click = "do_action, close_current";
        mouse_right_click = "close_all";
      };
      urgency_low = {
        background = "#282a36";
        foreground = "#6272a4";
        timeout = 10;
      };
      urgency_normal = {
        background = "#282a36";
        foreground = "#abb2bf";
        timeout = 10;
      };
      urgency_critical = {
        background = "#ff5555";
        foreground = "#f8f8f2";
        frame_color = "#ff5555";
        timeout = 0;
      };
    };
  };
}
