{...}: {
  imports = [
    ./cachy.nix
    ./oomd.nix
    ./undervolt.nix
    ./zram.nix
  ];

  boot.kernel.sysctl = {
    # https://wiki.archlinux.org/title/Zram#Optimizing_swap_on_zram
    # https://github.com/pop-os/default-settings/blob/master_noble/etc/sysctl.d/10-pop-default-settings.conf
    # https://github.com/CachyOS/CachyOS-Settings/blob/master/usr/lib/sysctl.d/99-cachyos-settings.conf

    # The sysctl swappiness parameter determines the kernel's preference for pushing anonymous pages or page cache to disk in memory-starved situations.
    # A low value causes the kernel to prefer freeing up open files (page cache), a high value causes the kernel to try to use swap space,
    # and a value of 100 means  cost is assumed to be equal.
    "vm.swappiness" = 120;

    # This parameter determines how aggressively the kernel will reclaim memory used by the VFS
    # cache. Values >100 mean the kernel will reclaim VFS cache more aggressively
    "vm.vfs_cache_pressure" = 150;

    # page-cluster controls the number of pages up to which consecutive pages are read in from swap in a single attempt.
    # This is the swap counterpart to page cache readahead. The mentioned consecutivity is not in terms of virtual/physical addresses,
    # but consecutive on swap space - that means they were swapped out together. (Default is 3)
    # increase this value to 1 or 2 if you are using physical swap (1 if ssd, 2 if hdd)
    "vm.page-cluster" = 1;

    # This action will speed up your boot and shutdown, because one less module is loaded. Additionally disabling watchdog timers increases performance and lowers power consumption
    # Disable NMI watchdog
    "kernel.nmi_watchdog" = 0;

    # Enable the sysctl setting kernel.unprivileged_userns_clone to allow normal users to run unprivileged containers.
    "kernel.unprivileged_userns_clone" = 1;

    # controls whether the Out-of-Memory (OOM) killer should kill the task that is allocating memory when the system
    # runs out of memory. This can be particularly useful in scenarios where a single process is causing a memory
    # leak or is consuming a large amount of memory, leading to an OOM condition.
    "vm.oom_kill_allocating_task" = true;
    "vm.oom_dump_tasks" = false;

    # controls the behavior of the "Magic SysRq" key, which allows the user to send commands directly to the kernel.
    # This can be very useful for debugging and recovery in situations where the system is unresponsive or un unresponsive.
    "kernel.sysrq" = 438;

    # For lenovo-legion kernel module
    "lenovo-legion.force" = 1; # laptop

    "vm.overcommit_memory" = 1;
  };
  services.bpftune.enable = true;
}
