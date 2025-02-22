{pkgs, ...}: {
  programs.gpg.enable = true;
  programs.gpg.package = pkgs.gnupg;
  services = {
    gpg-agent = {
      enable = true;
      enableSshSupport = true;
      pinentryPackage = pkgs.pinentry-tty;
      enableZshIntegration = true;
      extraConfig = ''
        allow-loopback-pinentry
        allow-preset-passphrase
      '';
    };
  };
}
