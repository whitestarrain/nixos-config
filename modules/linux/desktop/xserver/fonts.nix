{ pkgs, pkgs-unstable, ... }: {
  fonts = {
    enableDefaultPackages = false;
    fontDir.enable = true;

    packages = (with pkgs; [
      # icon fonts
      material-design-icons
      font-awesome

      noto-fonts-emoji

      fira-code
      fira-code-symbols
      font-awesome
      hanazono
      liberation_ttf
      noto-fonts
      noto-fonts-cjk-sans
      noto-fonts-cjk-serif
      noto-fonts-emoji-blob-bin
      noto-fonts-extra
      source-code-pro
      source-han-code-jp
      source-han-mono
      source-han-sans
      source-han-serif
      source-sans
      source-sans-pro
      source-serif
      source-serif-pro
      source-code-pro
      terminus_font_ttf
      ubuntu_font_family

      julia-mono
      dejavu_fonts
    ]) ++ [
      pkgs-unstable.nerd-fonts.symbols-only
      pkgs-unstable.nerd-fonts.fira-code
      pkgs-unstable.nerd-fonts.jetbrains-mono
      pkgs-unstable.nerd-fonts.iosevka
      pkgs-unstable.nerd-fonts.hack
    ];

    # user defined fonts
    # the reason there's Noto Color Emoji everywhere is to override DejaVu's
    # B&W emojis that would sometimes show instead of some Color emojis
    fontconfig.defaultFonts = {
      serif = [ "Source Han Serif SC" "Source Han Serif TC" "Noto Color Emoji" ];
      sansSerif = [ "Source Han Sans SC" "Source Han Sans TC" "Noto Color Emoji" ];
      monospace = [ "JetBrainsMono Nerd Font" "Noto Color Emoji" ];
      emoji = [ "Noto Color Emoji" ];
    };
  };

  # # https://wiki.archlinux.org/title/KMSCON
  # services.kmscon = {
  #   enable = true;
  #   fonts = [
  #     {
  #       name = "Source Code Pro";
  #       package = pkgs.source-code-pro;
  #     }
  #   ];
  #   extraOptions = "--term xterm-256color";
  #   extraConfig = "font-size=12";
  #   # Whether to use 3D hardware acceleration to render the console.
  #   hwRender = true;
  # };
}
