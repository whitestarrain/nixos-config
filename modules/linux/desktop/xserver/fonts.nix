{ pkgs, pkgs-unstable, ... }: {
  fonts = {
    enableDefaultPackages = false;
    fontDir.enable = true;

    packages = (with pkgs; [
      dejavu_fonts
      fira-code
      fira-code-symbols
      font-awesome
      font-awesome
      hanazono
      julia-mono
      liberation_ttf
      material-design-icons
      noto-fonts
      noto-fonts-cjk-sans
      noto-fonts-cjk-serif
      noto-fonts-emoji
      noto-fonts-emoji-blob-bin
      noto-fonts-extra
      recursive
      sarasa-gothic
      source-code-pro
      source-code-pro
      source-han-code-jp
      source-han-mono
      source-han-sans
      source-han-serif
      source-sans
      source-sans-pro
      source-serif
      source-serif-pro
      terminus_font_ttf
      ubuntu-sans-mono
      ubuntu_font_family
      wqy_microhei
      wqy_zenhei
    ]) ++ [
      pkgs-unstable.nerd-fonts.symbols-only
      pkgs-unstable.nerd-fonts.fira-code
      pkgs-unstable.nerd-fonts.jetbrains-mono
      pkgs-unstable.nerd-fonts.iosevka
      pkgs-unstable.nerd-fonts.hack
      pkgs-unstable.nerd-fonts.sauce-code-pro
      pkgs-unstable.nerd-fonts.noto
      pkgs-unstable.nerd-fonts.dejavu-sans-mono
      pkgs-unstable.nerd-fonts.terminess-ttf
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
