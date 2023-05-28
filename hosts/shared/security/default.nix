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


    polkit.enable = true;
    rtkit.enable = true;
  };
}
