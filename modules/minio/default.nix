{
  lib,
  pkgs,
  config,
  ...
}:
with lib; let
  cfg = config.tlh.minio;
in {
  options.tlh.minio = {
    enable = mkEnableOption "activate minio";

    domain = mkOption {
      type = types.str;
      default = "s3.my-fast.de";
      description = "Domain name for the minio service";
    };
  };

  config = mkIf cfg.enable {
    # short guide:
    #
    # since we use LetsEncrypt, we need to have a valid domain name.
    # both DNS entries need to be set!
    #
    # ${cfg.domain} -> S3 backend
    # minio.${cfg.domain} -> Admin console
    #
    # we use a secrets file to store the root credentials
    # create the file `/var/src/secrets/minio` with the following content:
    # MINIO_ROOT_USER=your-user-name
    # MINIO_ROOT_PASSWORD=your-password
    # it only should be readable by the root user,
    # so creating it with sudo is the easiest way
    #
    # allow TCP port 80 and 443 in your firewall -> needed for LetsEncrypt
    #
    # also set the following options:
    # security.acme.acceptTerms = true;
    # security.acme.defaults.email = "mail@your-domain";
    #
    # I recommend to create a nginx module, since you basically
    # want to have those settings anyway.
    #

    services.minio = {
      enable = true;
      listenAddress = "127.0.0.1:9000";
      consoleAddress = "127.0.0.1:9001";
      region = "eu-central-1";
      rootCredentialsFile = "/var/src/secrets/minio";
    };

    systemd.services.minio = {
      environment = {
        MINIO_SERVER_URL = "https://${cfg.domain}";
        MINIO_BROWSER_REDIRECT_URL = "https://minio.${cfg.domain}";
      };
    };

    services.nginx = {
      enable = true;
      recommendedOptimisation = true;
      recommendedTlsSettings = true;
      clientMaxBodySize = "128m";
      recommendedProxySettings = true;

      commonHttpConfig = ''
        proxy_headers_hash_max_size 1024;
        proxy_headers_hash_bucket_size 256;
      '';

      virtualHosts = {
        # minio s3 backend
        "${cfg.domain}" = {
          addSSL = true;
          enableACME = true;

          extraConfig = ''
            # To allow special characters in headers
            ignore_invalid_headers off;
            # Allow any size file to be uploaded.
            # Set to a value such as 1000m; to restrict file size to a specific value
            client_max_body_size 0;
            # To disable buffering
            proxy_buffering off;
          '';
          locations = {
            "/" = {
              proxyPass = "http://127.0.0.1:9000";
              extraConfig = ''
                proxy_set_header X-Real-IP $remote_addr;
                proxy_set_header X-Forwarded-For $proxy_add_x_forwarded_for;
                proxy_set_header X-Forwarded-Proto $scheme;
                # proxy_set_header Host $host;
                proxy_connect_timeout 300;
                # Default is HTTP/1, keepalive is only enabled in HTTP/1.1
                proxy_http_version 1.1;
                proxy_set_header Connection "";
                chunked_transfer_encoding off;
              '';
            };
          };
        };

        # minio admin console
        "minio.${cfg.domain}" = {
          addSSL = true;
          enableACME = true;

          extraConfig = ''
            # To allow special characters in headers
            ignore_invalid_headers off;
            # Allow any size file to be uploaded.
            # Set to a value such as 1000m; to restrict file size to a specific value
            client_max_body_size 0;
            # To disable buffering
            proxy_buffering off;
          '';
          locations = {
            "/" = {
              proxyPass = "http://127.0.0.1:9001";
              extraConfig = ''
                proxy_set_header X-Real-IP $remote_addr;
                proxy_set_header X-Forwarded-For $proxy_add_x_forwarded_for;
                proxy_set_header X-Forwarded-Proto $scheme;
                # proxy_set_header Host $host;
                proxy_connect_timeout 300;
                # Default is HTTP/1, keepalive is only enabled in HTTP/1.1
                proxy_http_version 1.1;
                proxy_set_header Connection "";
                chunked_transfer_encoding off;
              '';
            };
          };
        };
      };
    };
  };
}
