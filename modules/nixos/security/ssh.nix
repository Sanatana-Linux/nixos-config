{
  config,
  lib,
  ...
}:
with lib; let
  cfg = config.modules.security.ssh;
in {
  options.modules.security.ssh = {
    enable = mkEnableOption "openssh server with secure defaults";

    passwordAuthentication = mkOption {
      type = types.bool;
      default = false;
      description = "Allow password authentication";
    };

    permitRootLogin = mkOption {
      type = types.str;
      default = "no";
      description = "Permit root login setting";
    };

    port = mkOption {
      type = types.int;
      default = 22;
      description = "SSH port";
    };

    maxAuthTries = mkOption {
      type = types.int;
      default = 3;
      description = "Maximum authentication attempts per connection";
    };

    clientAliveInterval = mkOption {
      type = types.int;
      default = 300;
      description = "Timeout in seconds after which the server will send a message to the client asking for a response";
    };
  };

  config = mkIf cfg.enable {
    services.openssh = {
      enable = true;
      ports = [cfg.port];
      settings = {
        PasswordAuthentication = lib.mkForce cfg.passwordAuthentication;
        PermitRootLogin = lib.mkForce cfg.permitRootLogin;
        MaxAuthTries = cfg.maxAuthTries;
        ClientAliveInterval = cfg.clientAliveInterval;
        ClientAliveCountMax = 2;
        # Security hardening
        PubkeyAuthentication = true;
        AuthenticationMethods =
          if cfg.passwordAuthentication
          then "publickey password"
          else "publickey";
        KbdInteractiveAuthentication = true;
        UsePAM = cfg.passwordAuthentication;
        X11Forwarding = true;
        AllowAgentForwarding = true;
        AllowTcpForwarding = true;
        GatewayPorts = "no";
        PermitTunnel = "no";
      };

      # Additional security settings
      extraConfig = ''
        # Only allow specific users (can be overridden by hosts)
        AllowUsers *

        # Protocol and cipher restrictions
        Protocol 2
        Ciphers chacha20-poly1305@openssh.com,aes256-gcm@openssh.com,aes128-gcm@openssh.com
        MACs hmac-sha2-256-etm@openssh.com,hmac-sha2-512-etm@openssh.com
        KexAlgorithms curve25519-sha256@libssh.org,diffie-hellman-group16-sha512

        # Logging
        SyslogFacility AUTHPRIV
        LogLevel INFO
      '';
    };

    # Ensure SSH is allowed through firewall if firewall module is enabled
    modules.security.firewall.allowSSH = mkDefault (config.modules.security.firewall.enable);
  };
}
