---
created: 2025-09-07T22:55:06 (UTC -07:00)
tags: []
source: https://www.reddit.com/r/NixOS/comments/171cffr/how_do_you_guys_go_about_separating_files_for/
author: lucastso10
---

# How do you guys go about separating files for your config? : r/NixOS

> ## Excerpt
> Mostly: Just put stuff in separate files and then import them.

---
Mostly: Just put stuff in separate files and then [import](https://nixos.wiki/wiki/NixOS_modules) them.

There's one big decision to make: Do you 'activate' the configuration by importing the file, or by importing *and* enabling an option? Activate-by-import is far simpler, so start there, but be aware that all the [NixOS configs](https://github.com/nixos/nixpkgs/tree/master/nixos/modules) are activate-by-enable-option (which works better for extremely large configs like NixOS itself), so your modules will look a little different and behave a little differently.

Concrete examples:

The activate-by-import method:

In `modules/nice-build.nix`:

```
{
  nix.daemonCPUSchedPolicy = "idle";
  nix.daemonIOSchedClass = "idle";
}
```

In `modules/printing.nix`:

```
{
  services = {
    printing.enable = true;
    avahi.enable = true;
    avahi.nssmdns = true;
    rdnssd.enable = true;
  };
}
```

In `configuration.nix`:

```
{
  imports = [
    ./modules/nice-build.nix
    ./modules/printing.nix
  ];
  config = {
    ...
  };
}
```

Contrast, the activate-by-enable-option method:

In `modules/limit-concurrent-coredumps.nix`:

```
{ lib, config, pkgs, ... }:
with lib; {
  options = {
    chkno.limitConcurrentCoredumps = {
      enable = mkOption {
        type = types.bool;
        default = true;
        description = ''
          Limit concurrent coredumps?
        '';
      };
      limit = mkOption {
        type = types.int;
        default = 3;
        description = ''
          This many coredumps may run concurrently.
        '';
      };
    };
  };
  config = mkIf config.chkno.limitConcurrentCoredumps.enable {
    systemd.services.limit-concurrent-cordeumps = {
      description = "Limit concurrent coredumps";
      wantedBy = [ config.systemd.defaultUnit ];
      serviceConfig = {
        Type = "oneshot";
        RemainAfterExit = true;
        ExecStart = "${pkgs.stdenv.shell} -c 'echo ${
            toString config.chkno.limitConcurrentCoredumps.limit
          } > /proc/sys/kernel/core_pipe_limit'";
      };
    };
  };
}
```

In `configuration.nix`:

```
{
  imports = [
    ./modules/limit-concurrent-coredumps.nix
  ];
  config = {
    chkno.limitConcurrentCoredumps.enable = true;
    ...
  };
}
```

When using activate-by-enable-option, merely importing something has no effect, so you can just always import everything. NixOS does this with [a giant module list](https://github.com/NixOS/nixpkgs/blob/master/nixos/modules/module-list.nix), which is good for giant multi-author projects, but you can also use `builtins.readDir` to import everything in `./modules`. Advantages of always-import-everything:

-   Clients need never care about import lists.
    
-   Activation of things is done by options, which compose better:
    
    -   Modules can activate other modules.
        
    -   Modules can *deactivate* other modules.
        
    -   Two modules can *conflict* over whether a third module should be active, raising this to the user's attention in a comprehensible way.
        
-   Errors are detected even in modules not 'active'.
    
-   All available configuration options are defined in a machine-readable way, & so can be browsed, used to generate documentation, etc.
