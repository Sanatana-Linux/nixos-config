{pkgs, ...}: {
  environment.systemPackages = with pkgs; [
    # john # hash cracker
    # p0f # passive os fingerprinting
    aircrack-ng # wifi tool
    amass # network enumeration and mapping tool
    arp-scan-rs # local network ARP-based scanner
    arping # arp tool
    bettercap # mitm tool
    bitwarden #password management
    bitwarden-desktop # password management native app
    bws # bitwarden secrets management
    certgraph # ssl certificate graph crawler
    crunch # wordlist generator
    # deepsecrets # find secrets in code
    dnsenum # dns enumeration
    enchive # encrypted archive
    encpipe # encrypt pipe
    # enum4linux-ng # enumerate info from windows/samba
    fcrackzip # zip password cracker
    ghorg # mass clone git repos
    hashcat # hash cracker
    hcxdumptool # capture packets from wifi
    hcxtools # wifi capture and convert to hashcat/john
    iaito # gui for radare2
    keyguard # alternative bitwarden client
    ldapnomnom # ldap user brute force
    libtpms # tpm library
    msldapdump # ldap enumeration
    nikto # web server scanner
    nmap # network scanner
    onesixtyone # snmp scanner
    openssl.dev # TSL/SSL
    python312Packages.tpm2-pytss
    radare2 # reverse engineering framework
    sqlmap # sql injection tool
    ssh-tpm-agent
    sslscan # ssl scanner
    swtpm # software tpm
    tcpdump # dump network packets
    testssl # ssl checker
    thc-hydra # network logon cracker
    tor # privacy network protocol
    tor-browser-bundle-bin # firefox with integrated tor connections by default
    tpm2-abrmd # TPM2 resource manage
    tpm2-tools # tools for working with TPM chip
    tpm2-tss #  OSS implementation of the TCG TPM2 Software Stack
    tpmmanager # manage TPM hardware
    wireshark # network traffic analyzer
    zap # web app penetration testing
  ];
  security = {
    # I am told this is a better choice, I don't notice much difference but its more ergonomic to type
    doas = {
      enable = true;
      extraRules = [
        {
          # TODO implement users variable determined in /hosts/[host]/default.nix instead
          users = ["tlh" "smg"];
          groups = ["wheel" "networkmanager"];
          noPass = true;
          keepEnv = true;
          persist = false;
        }
      ];
    };
    # Just in case ;]
    sudo = {
      enable = true;
      wheelNeedsPassword = false;
      extraConfig = ''
        # clear warning in sudo lectures after each reboot.
        Defaults lecture = never
         # password input feedback - makes typed password visible as asterisks.
        Defaults pwfeedback # WARNING: where the buffer overload vulnerability comes from
        # Keep SSH_AUTH_SOCK so that pam_ssh_agent_auth.so can do its magic.
        Defaults env_keep+=SSH_AUTH_SOCK
      '';
    };

    pam = {
      sshAgentAuth.enable = true;
      # solve open file limits
      loginLimits = [
        {
          domain = "*";
          type = "soft";
          item = "nofile";
          value = "81920";
        }
      ];
    };
    polkit.enable = true;
    rtkit.enable = true;
    tpm2 = {
      enable = true;
      pkcs11.enable = true;
      abrmd.enable = true;
    };
  };
}
