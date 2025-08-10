{ pkgs, pkgs-unstable, flake-inputs, ... }:

let
  steam-run-appid = pkgs.writeShellApplication {
    name = "steam-run-appid";
    text = ''
      if [ $# -lt 1 ]; then
        return
      fi
      steam steam://rungameid/"$*"
    '';
  };
in
{
  environment.sessionVariables = {
    STEAM_FORCE_DESKTOPUI_SCALING = "1.5";
  };

  imports = [
    flake-inputs.nix-gaming.nixosModules.pipewireLowLatency
    flake-inputs.nix-gaming.nixosModules.platformOptimizations
  ];

  environment.systemPackages = [
    steam-run-appid

    # usage: umu-run "/path/to/game.exe" -opengl -SkipBuildPatchPrereq
    # add "Microsoft Visual C ++ Runtime 2022" with winetricks:
      # umu-run winetricks vcrun2022
      # this will cause error, don't use that: WINE=umu-run WINEPREFIX=~/Games/umu/umu-default winetricks
      # Sometimes, `rm -rf ~/Games/umu` can solve all problems
    pkgs.umu-launcher # run proton without steam

    pkgs.lutris

    # some game need to set lang env:
    #   env LC_ALL=ja_JP.UTF-8 LANG=ja_JP.UTF-8 wine xxx.exe
    pkgs.winetricks

    # wine need install dxvk to make sure wine can use the GPU,
      # can install dxvk with winecfg
      # winetricks has more runtime to install than wincfg
    pkgs.wine
    pkgs.wine64

    # minecraft
    pkgs.hmcl # adjust the font if can't display number

    # cheat
    pkgs.scanmem # gameconqueror
    # PINCE have not been packaged
  ];

  services.pipewire = {
    lowLatency = {
      # enable this module
      enable = true;
      # defaults (no need to be set unless modified)
      quantum = 64;
      rate = 48000;
    };
  };

  programs.steam.platformOptimizations.enable = true;

  nix.settings = {
    substituters = [ "https://nix-gaming.cachix.org" ];
    trusted-public-keys = [ "nix-gaming.cachix.org-1:nbjlureqMbRAxR1gJ/f3hxemL9svXaZF/Ees8vCUUs4=" ];
  };

  # Full-screen may cause the game to black the screen when switching tag in dwm
  programs.steam = {
    enable = true;
    protontricks.enable = true;
  };

  # Disable dams(Display Power Management Signaling) to fix the problem of screen turning off when playing games using controller
  # https://wiki.archlinux.org/title/Display_Power_Management_Signaling
  services.xserver.extraConfig = ''
    Section "Extensions"
      Option "DPMS" "false"
    EndSection

    Section "ServerFlags"
      Option "BlankTime" "0"
    EndSection
  '';

  # alvr not is broken when 24.05->24.11 (https://github.com/NixOS/nixpkgs/pull/308097#issue-2272454747)
  # please download realse from github, and run with steam-run
  # init steamVR: sudo setcap CAP_SYS_NICE=eip /path/to/SteamVR/bin/linux64/vrcompositor-launcher
  # streamVR execute args: /path/to/SteamVR/bin/vrmonitor.sh %command%
  programs.alvr = {
    enable = true;
    package = pkgs-unstable.alvr;
    openFirewall = true;
  };
}
