{ pkgs, ... }:

{
  services.picom = {
    enable = true;
    settings = {
      # Animations
      animations = true;
      animation-for-open-window = "slide-up";
      animation-for-transient-window = "slide-down";
      animation-for-unmap-window = "slide-up";
      animation-stiffness = 300.0;
      animation-window_mass = 1.0;
      animation-dampening = 26;
      animation-delta = 10;
      animation-force_steps = false;
      animation-clamping = true;

      blur-background = false;
      blur-background-frame = false;
      blur-background-exclude = [
        "class_g ^= 'dwm'"
        "class_g = 'Chromium'"
        "class_g = 'Firefox'"
        "class_g = 'Gimp'"
        "name    = 'normalal'"
      ];

      shadow = true;
      shadow-radius = 10;
      shadow-opacity = 0.7;
      shadow-offset-x = -10;
      shadow-offset-y = -9;

      fading = true;
      fade-in-step = 0.07;
      fade-out-step = 0.07;

      corner-radius = 9;

      # Backend
      backend = "xrender";
      # backend ="glx";

      vsync = true;

      glx-no-stencil = true;
      glx-no-rebind-pixmap = false;
      use-damage = true;

      # Window type settings
      wintypes = {
        dialog = { animation = "zoom"; animation-unmap = "zoom"; fade = true; shadow = true; blur-background = false; focus = true; };
        splash = { animation = "zoom"; animation-unmap = "slide-down"; fade = true; shadow = true; blur-background = false; focus = false; };
      };
    };
  };
}
