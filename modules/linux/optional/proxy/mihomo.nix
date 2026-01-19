{ pkgs, lib, config, ... }:

let
  clashtui_config_dir = "/etc/clashtui";
  mihomo_config_path = "${clashtui_config_dir}/mihomo_config";
  clashtui = pkgs.writeShellApplication {
    name = "clashtui";
    text = ''
      ${pkgs.clashtui}/bin/clashtui -c ${clashtui_config_dir} "$@"
    '';
  };
  clashtui_mihomo_update_command = lib.getExe (
    pkgs.writeShellApplication {
      name = "clashtui_mihomo_update_command";
      text = ''
        ${clashtui}/bin/clashtui -u
      '';
    }
  );
in
{
  environment.systemPackages = [
    clashtui
    pkgs.mihomo
  ];
  system.activationScripts.makeVaultWardenDir = ''
    dirs=(
      ${clashtui_config_dir}
      ${clashtui_config_dir}/profile_cache
      ${clashtui_config_dir}/profiles
      ${clashtui_config_dir}/templates
      ${mihomo_config_path}
    )
    for dir in "''${dirs[@]}"
    do
      mkdir -p $dir
      chown mihomo $dir
      chgrp mihomo $dir
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
      text = ''
        basic:
          clash_config_dir: '${mihomo_config_path}'
          clash_bin_path: ${lib.getExe pkgs.mihomo}
          clash_config_path: '${mihomo_config_path}/config.yaml'
          timeout: null
        service:
          clash_srv_name: 'clashtui_mihomo'
          is_user: false
        extra:
          edit_cmd: 'st -e nvim "%s"'
          open_dir_cmd: 'st -e nvim "%s"'
      '';
    };
    "clashtui/basic_clash_config.yaml" = {
      user = "mihomo";
      group = "mihomo";
      text = ''
        mixed-port: ${config.wsainHostOption.proxy-port}
        allow-lan: true
        external-controller: 127.0.0.1:9090
        external-ui: ${mihomo_config_path}/metacubexd
        ipv6: true
        unified-delay: true
        global-client-fingerprint: chrome
        geodata-mode: true
        mode: global
        profile:
          store-selected: true
          store-fake-ip: true
        dns:
          enable: true
          prefer-h3: true
          #listen: :1053       # for redirect/tproxy
          ipv6: false
          respect-rules: true
          enhanced-mode: fake-ip
          fake-ip-filter:
            - "*"
            - "+.lan"
            - "+.local"
          nameserver:
            - https://120.53.53.53/dns-query
            - https://223.5.5.5/dns-query
          proxy-server-nameserver:
            - https://120.53.53.53/dns-query
            - https://223.5.5.5/dns-query
          nameserver-policy:
            geosite:cn,private:
              #- 114.114.114.114
              #- 223.5.5.5
              - https://120.53.53.53/dns-query
              - https://223.5.5.5/dns-query
            geosite:geolocation-!cn:
              #- 8.8.8.8
              - https://dns.cloudflare.com/dns-query
              - https://dns.google/dns-query
      '';
    };
    "clashtui/mihomo_config/metacubexd" = {
      source = pkgs.metacubexd;
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
