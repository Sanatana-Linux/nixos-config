{pkgs, ...}: {
  security = {
    # I am told this is a better choice, I don't notice much difference but its more ergonomic to type
    doas = {
      enable = true;
      extraRules = [
        {
          users = ["tlh"];
          groups = ["wheel"];
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

    pam = {
      loginLimits = [
        {
          domain = "@wheel";
          item = "nofile";
          type = "soft";
          value = "524288";
        }
        {
          domain = "@wheel";
          item = "nofile";
          type = "hard";
          value = "1048576";
        }
      ];

      services = {
        lightdm.enableGnomeKeyring = true;
        login.enableGnomeKeyring = true;
      };
    };

    polkit.enable = true;
    rtkit.enable = true;
  };
}
