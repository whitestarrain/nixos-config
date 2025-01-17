{
  pkgs,
  lib,
  config,
  ...
}:
let
  dnsServers = [
    "8.8.8.8"
    "2001:4860:4860::8888"
  ];
in
{
  # enable power saving on Intel Wi-Fi
  boot.extraModprobeConfig = ''
    options iwlmvm power_scheme=1
    options iwlwifi power_save=Y power_level=5
  '';

  # `sysctl -a` or `sysctl -a --pattern ...` to display all values currently available.
  boot.kernel.sysctl = {
    # better congestion control algorithm
    "net.core.default_qdisc" = "fq";
    "net.ipv4.tcp_congestion_control" = "bbr";

    # https://wiki.archlinux.org/title/sysctl
    "net.ipv4.tcp_fastopen" = 3;
    "net.ipv4.tcp_max_tw_buckets" = 2000000;
    "net.ipv4.tcp_max_syn_backlog" = 8192;
    "net.ipv4.tcp_tw_reuse" = 1;
    # Set by nix-gaming module
    # "net.ipv4.tcp_fin_timeout" = 10;
    "net.ipv4.tcp_slow_start_after_idle" = 0;
    "net.ipv4.tcp_keepalive_time" = 60;
    "net.ipv4.tcp_keepalive_intvl" = 10;
    "net.ipv4.tcp_keepalive_probes" = 6;
    "net.ipv4.tcp_mtu_probing" = 1;
    "net.ipv4.tcp_syncookies" = 1;

    "net.ipv4.conf.all.forwarding" = lib.mkForce 1;
    "net.ipv4.conf.default.forwarding" = lib.mkForce 1;
    "net.ipv4.conf.*.forwarding" = lib.mkForce 1;
    "net.ipv6.conf.all.forwarding" = lib.mkForce 1;
    "net.ipv6.conf.default.forwarding" = lib.mkForce 1;
    "net.ipv6.conf.*.forwarding" = lib.mkForce 1;

    "net.ipv4.conf.all.rp_filter" = lib.mkForce 0;
    "net.ipv4.conf.default.rp_filter" = lib.mkForce 0;
    "net.ipv4.conf.*.rp_filter" = lib.mkForce 0;
    "net.ipv4.conf.all.accept_redirects" = lib.mkForce 0;
    "net.ipv4.conf.default.accept_redirects" = lib.mkForce 0;
    "net.ipv4.conf.*.accept_redirects" = lib.mkForce 0;
    "net.ipv4.conf.all.secure_redirects" = 0;
    "net.ipv4.conf.default.secure_redirects" = 0;
    "net.ipv4.conf.*.secure_redirects" = 0;
    "net.ipv4.conf.all.send_redirects" = 0;
    "net.ipv4.conf.default.send_redirects" = 0;
    "net.ipv4.conf.*.send_redirects" = 0;
    "net.ipv6.conf.all.accept_redirects" = lib.mkForce 0;
    "net.ipv6.conf.default.accept_redirects" = lib.mkForce 0;
    "net.ipv6.conf.*.accept_redirects" = lib.mkForce 0;

    # Force ARP respond on same interface
    # https://serverfault.com/questions/834512/why-does-linux-answer-to-arp-on-incorrect-interfaces
    # But do not set all or *
    # https://serverfault.com/questions/935366/why-does-arp-ignore-1-break-arp-on-pointopoint-interfaces-kvm-guest
    "net.ipv4.conf.all.arp_ignore" = 0;
    "net.ipv4.conf.default.arp_ignore" = 1;
    "net.ipv4.conf.all.arp_announce" = 0;
    "net.ipv4.conf.default.arp_announce" = 2;
  };

  # networking tools
  networking.iproute2.enable = true;

  networking = {
    hostId = lib.substring 0 8 (builtins.hashString "sha256" config.networking.hostName);
    useDHCP = false;
    domain = "wsain.pub";
    firewall.enable = false;
    firewall.checkReversePath = false;
    nat.enable = false;
    resolvconf.dnsExtensionMechanism = true;
    resolvconf.dnsSingleRequest = true;
    search = [ "wsain.pub" ];
    tempAddresses = "disabled";
    nameservers = dnsServers;

    # systemd-networkd breaks resolv.conf, but fixed with resolv-conf-setup.service
    useNetworkd = lib.mkForce true;
  };

  # systemd-networkd config
  systemd.network.enable = true;

  systemd.network.wait-online.enable = false;
  environment.etc."systemd/networkd.conf".text = ''
    [Network]
    ManageForeignRoutes=false
    ManageForeignRoutingPolicyRules=false
  '';
  systemd.services.systemd-networkd.restartIfChanged = false;

  services.resolved.enable = false;

  # https://github.com/nix-community/srvos/blob/main/nixos/common/networking.nix
  systemd.services.systemd-networkd.stopIfChanged = false;
  systemd.services.systemd-resolved.stopIfChanged = false;

  systemd.services.network-setup-resolv-conf =
    let
      cfg = config.networking;
    in
    {
      enable = !cfg.networkmanager.enable;
      description = "Setup resolv.conf";
      after = [
        "network-pre.target"
        "systemd-udevd.service"
        "systemd-sysctl.service"
      ];
      before = [
        "network.target"
        "shutdown.target"
      ];
      wants = [ "network.target" ];
      conflicts = [ "shutdown.target" ];
      wantedBy = [ "multi-user.target" ];

      unitConfig.ConditionCapability = "CAP_NET_ADMIN";

      serviceConfig = {
        Type = "oneshot";
        RemainAfterExit = true;
      };

      unitConfig.DefaultDependencies = false;

      script = ''
        # Set the static DNS configuration, if given.
        ${pkgs.openresolv}/sbin/resolvconf -m 1 -a static <<EOF
        ${lib.optionalString (cfg.nameservers != [ ] && cfg.domain != null) ''
          domain ${cfg.domain}
        ''}
        ${lib.optionalString (cfg.search != [ ]) ("search " + lib.concatStringsSep " " cfg.search)}
        ${lib.flip lib.concatMapStrings cfg.nameservers (ns: ''
          nameserver ${ns}
        '')}
        EOF
      '';
    };

  # Disable systemd-nspawn container's default addresses.
  environment.etc."systemd/network/80-container-ve.network".text = ''
    [Match]
    Name=ve-*
    Driver=veth

    [Network]
    LinkLocalAddressing=ipv6
    DHCPServer=no
    IPMasquerade=no
    LLDP=no
    IPv6SendRA=no
  '';

  # Disable automatic DHCP server for netns interfaces
  environment.etc."systemd/network/80-namespace-ns.network".text = ''
    [Match]
    Name=ve-*
    Driver=veth

    [Network]
    LinkLocalAddressing=ipv6
    DHCPServer=no
    IPMasquerade=no
    LLDP=no
    IPv6SendRA=no
  '';

  # Support network namespaces
  systemd.tmpfiles.rules = [ "d /run/netns 755 root root" ];
}
