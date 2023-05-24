{
  config,
  pkgs,
  ...
}: {
  console = {
    font = "ter-c14b";
    keyMap = "us";
    #-------------------------------------------#
    # normally would abstract the below to a
    # different file, but its been giving me fits,
    # so it stays where it is as inspired by the
    # auspicious learnings of the Trashmen's
    # Surfin Bird playing on repeat
    #
    packages = with pkgs; [terminus_font];
    # Change Console Colors to match theme
    colors = [
      "1c1c1c"
      "ff3d81"
      "85ff94"
      "f0ffaa"
      "00caff"
      "660ed0"
      "00eaff"
      "b6b6b6"
      "ff28a8"
      "4dd564"
      "ffff73"
      "0badff"
      "85ff95"
      "8265ff"
      "919191"
    ];
  };
  # shell
  users.defaultUserShell = pkgs.zsh;

  security.doas = {
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

  security.sudo.wheelNeedsPassword = false;
}
