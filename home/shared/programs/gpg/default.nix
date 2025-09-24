{pkgs, ...}: {
  programs.gpg.enable = true;
  programs.gpg.package = pkgs.gnupg;
  services = {
    gpg-agent = {
      enable = true;
      enableSshSupport = true;
      enableExtraSocket = true;
      pinentry.package = pkgs.pinentry-tty;
      enableZshIntegration = true;
      enableBashIntegration = true;
      extraConfig = ''
        allow-loopback-pinentry
        allow-preset-passphrase
      '';
    };
  };
}
