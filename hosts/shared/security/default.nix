{pkgs, ...}: {
  security = {
    # I am told this is a better choice, I don't notice much difference but its more ergonomic to type
    doas = {
      enable = true;
      extraRules = [
        {
          users = ["tlh"];
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
    };
    # solve open file limits
    pam.loginLimits = [
      {
        domain = "*";
        type = "soft";
        item = "nofile";
        value = "81920";
      }
    ];

    polkit.enable = true;
    rtkit.enable = true;
    tpm2 = {
      enable = false;
    };
  };
}
