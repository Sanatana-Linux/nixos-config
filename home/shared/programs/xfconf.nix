{pkgs, config, ...}:{
  xfce4-session = {
    "startup/ssh-agent/enabled" = false;
    "general/LockCommand" = "screenlocked & ";
  };
}
