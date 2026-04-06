{ pkgs, sysConfig, ... }:
let
  sdcv_clipboard_word = (
    pkgs.writeShellApplication {
      name = "sdcv_clipboard_word";
      runtimeInputs = with pkgs; [
        xclip
        gawk
        sdcv
      ];
      text = ''
        word=$(xclip -selection clipboard -o | awk '{print $1}')
        if [ -z "$word" ]; then
          return
        fi
        sdcv "$word" | less && exit
      '';
    }
  );
in
{
  home.packages = (
    with pkgs;
    [
      sdcv
      sdcv_clipboard_word
      crow-translate
    ]
  );

  programs.translate-shell = {
    enable = true;
    settings = {
      tl = [ "zh" ];
      proxy = "127.0.0.1:${sysConfig.wsainHostOption.proxy-port}";
    };
  };

}
