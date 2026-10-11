{
  config,
  lib,
  pkgs,
  ...
}:
with lib; let
  cfg = config.modules.system.networking.quad9;
  nmCfg = config.modules.system.networking.networkmanager;
  resolvedCfg = config.modules.system.networking.resolved;

  # Quad9's threat-blocking tier with EDNS Client Subnet (ECS). ECS lets
  # Quad9 return geographically relevant answers while still blocking
  # malware domains, at the cost of Quad9 seeing a coarse client subnet.
  # Quad9 publishes two IPv6 forms for the ECS tier; both are listed because
  # either may be reachable depending on peering.
  defaultServers = [
    "9.9.9.11"
    "149.112.112.11"
    "2620:fe::11"
    "2620:fe::fe:11"
  ];

  isV6 = addr: hasInfix ":" addr;
  v4Servers = builtins.filter (addr: !(isV6 addr)) cfg.servers;
  v6Servers = builtins.filter isV6 cfg.servers;

  # nmcli takes "key value" pairs positionally after the connection id, and
  # needs each family's list comma-separated.
  modifyArgs = concatStringsSep " " (
    [
      "ipv4.ignore-auto-dns"
      "yes"
      "ipv6.ignore-auto-dns"
      "yes"
    ]
    ++ optionals (v4Servers != []) ["ipv4.dns ${concatStringsSep "," v4Servers}"]
    ++ optionals (v6Servers != []) ["ipv6.dns ${concatStringsSep "," v6Servers}"]
  );
in {
  options.modules.system.networking.quad9 = {
    enable = mkEnableOption "Quad9 DNS servers with ECS and threat blocking";

    servers = mkOption {
      type = types.listOf types.str;
      default = defaultServers;
      example = [
        "9.9.9.10"
        "149.112.112.110"
        "2620:fe::10"
      ];
      description = "Resolvers that receive every DNS query. Defaults to Quad9's threat-blocking tier with ECS; the .10/.110/::10 set is malware blocking without ECS, and .9/.112/::fe is unfiltered.";
    };
  };

  config = mkIf cfg.enable {
    # Pin the resolvers system-wide so filtering applies regardless of which
    # interface manager owns the link. This is the path NetworkManager does
    # not cover, so without it dhcpcd and manual wpa_supplicant hosts would
    # write DHCP-supplied resolvers straight to /etc/resolv.conf.
    #
    # systemd-resolved owns this option when enabled and points it at its own
    # stub, resolving this module's servers instead.
    networking.nameservers = mkIf (!resolvedCfg.enable) cfg.servers;

    networking.networkmanager = mkIf nmCfg.enable {
      # NixOS implements insertNameservers as a NetworkManager dispatcher that
      # rewrites /etc/resolv.conf in place, prepending these addresses. That
      # is only valid while NetworkManager owns the file. With
      # systemd-resolved enabled, resolv.conf is a symlink to a stub that
      # resolved regenerates, so the dispatcher is skipped and the script below
      # applies the same addresses to the connection instead.
      insertNameservers = mkIf (!resolvedCfg.enable) cfg.servers;

      # With systemd-resolved owning resolution, Quad9 has to reach it through
      # the link's DNS rather than through resolv.conf. NetworkManager hands the
      # connection's DNS to resolved as the upstream, so the connection is
      # pointed at Quad9 and told to ignore the resolvers the DHCP lease offers
      # — otherwise the network's own DNS, not Quad9, becomes the upstream.
      #
      # The connection profile is a user-managed keyfile, so the settings are
      # applied by nmcli when the link comes up rather than by a generated
      # profile. Reapplying is idempotent, so repeated events are harmless.
      #
      # Because nmcli writes through to the saved keyfile, these settings
      # outlive the option: disabling this module stops the dispatcher from
      # running but leaves ipv4.dns and ignore-auto-dns on the existing
      # profile, so DNS stays pinned to Quad9 until it is cleared by hand.
      # Revert with:
      #   nmcli con mod <name> ipv4.ignore-auto-dns no ipv6.ignore-auto-dns no \
      #     ipv4.dns "" ipv6.dns "" && nmcli device reapply <iface>
      #
      # Without NetworkManager there is no per-link DNS to rewrite, so resolved
      # takes Quad9 only as its fallback and DHCP-supplied upstreams still win.
      dispatcherScripts = mkIf resolvedCfg.enable [
        {
          type = "basic";
          source = pkgs.writeText "quad9-dns-dispatcher" ''
            case "$2" in
              up | dhcp4-change | dhcp6-change) ;;
              *) exit 0 ;;
            esac

            nmcli=${pkgs.networkmanager}/bin/nmcli

            "$nmcli" connection modify "$CONNECTION_UUID" ${modifyArgs} >/dev/null 2>&1 || exit 0
            "$nmcli" device reapply "$1" >/dev/null 2>&1 || true
          '';
        }
      ];
    };
  };
}
