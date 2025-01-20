{ pkgs, lib, config, ... }:

{
  networking = {
    # systemd can handle dhcp itself, disable dhcpd
    useDHCP = lib.mkForce false;
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
