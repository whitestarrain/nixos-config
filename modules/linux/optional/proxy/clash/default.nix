{
  pkgs,
  lib,
  config,
  helper,
  ...
}:

let
  clashtui_config_dir = "/etc/clashtui";
  mihomo_config_path = "${clashtui_config_dir}/mihomo_config";
  singbox_config_path = "${clashtui_config_dir}/singbox_config";
  clashtui = pkgs.writeShellApplication {
    name = "clashtui";
    text = ''
      ${helper.derivations.clashtui}/bin/clashtui --config-dir=${clashtui_config_dir} "$@"
    '';
  };
  clashtui_mihomo_update_command = lib.getExe (
    pkgs.writeShellApplication {
      name = "clashtui_mihomo_update_command";
      text = ''
        ${clashtui}/bin/clashtui profile update --all
      '';
    }
  );
in
{
  environment.systemPackages = [
    clashtui
    pkgs.mihomo
    pkgs.sing-box
  ];
  security.wrappers = {
    clashtui = {
      setuid = true;
      owner = "mihomo";
      group = "mihomo";
      permissions = "u=rx+s,go=rx"; # Read, execute, and setuid bit
      source = lib.getExe clashtui;
    };
  };
  system.activationScripts.makeVaultWardenDir = ''
    dirs=(
      ${clashtui_config_dir}
      ${clashtui_config_dir}/mihomo/profiles
      ${clashtui_config_dir}/mihomo/templates
      ${mihomo_config_path}
      ${singbox_config_path}
    )
    for dir in "''${dirs[@]}"
    do
      mkdir -p $dir
      chown -R mihomo $dir
      chgrp -R mihomo $dir
      chmod 2775 $dir
    done

    if [[ ! -f ${mihomo_config_path}/config.yaml ]]; then
    cat > ${mihomo_config_path}/config.yaml << EOF
      mixed-port: ${config.wsainHostOption.proxy-port}
      external-controller: 127.0.0.1:9090
    EOF
    fi
  '';
  users.users.mihomo = {
    isSystemUser = true;
    group = "mihomo";
  };
  environment.etc = {
    "clashtui/config.yaml" = {
      user = "mihomo";
      group = "mihomo";
      source = pkgs.replaceVarsWith {
        src = ./clashtui/config.yaml;
        replacements = {
          mihomo_core_config_dir = mihomo_config_path;
          mihomo_core_bin_path = lib.getExe pkgs.mihomo;
          mihomo_core_config_path = "${mihomo_config_path}/config.yaml";
          singbox_core_config_dir = singbox_config_path;
          singbox_core_bin_path = lib.getExe pkgs.sing-box;
          singbox_core_config_path = "${singbox_config_path}/config.json";
        };
      };
    };
    "clashtui/default_theme.yaml" = {
      user = "mihomo";
      group = "mihomo";
      source = ./clashtui/default_theme.yaml;
    };
    "clashtui/default_keymap.yaml" = {
      user = "mihomo";
      group = "mihomo";
      source = ./clashtui/default_keymap.yaml;
    };
    "clashtui/mihomo/core_override_config.yaml" = {
      user = "mihomo";
      group = "mihomo";
      source = ./clashtui/mihomo/core_override_config.yaml;
    };
  };
  systemd.services.clashtui_mihomo = {
    enable = true;
    unitConfig = {
      Description = "Mihomo daemon, A rule-based proxy in Go.";
      After = [
        "network-online.target"
      ];
    };
    serviceConfig = {
      User = "mihomo";
      Group = "mihomo";
      ExecStart = lib.concatStringsSep " " [
        (lib.getExe pkgs.mihomo)
        "-d ${mihomo_config_path}"
      ];
      Restart = "on-failure";
      RestartSec = 5;
      Type = "simple";
    };
    # auto start
    wantedBy = [ "multi-user.target" ];
  };

  systemd.services.clashtui_mihomo_update = {
    enable = true;
    unitConfig = {
      Description = "update mihomo config using clashtui";
    };
    serviceConfig = {
      Type = "oneshot";
      ExecStart = clashtui_mihomo_update_command;
    };
  };

  systemd.timers.clashtui_mihomo_update = {
    enable = true;
    unitConfig = {
      Description = "mihomo config update timer";
    };
    timerConfig = {
      OnActiveSec = "1min";
      OnUnitInactiveSec = "5h";
      Unit = "clashtui_mihomo_update.service";
    };
    wantedBy = [ "timers.target" ];
  };
}
