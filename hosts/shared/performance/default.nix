{
  pkgs,
  config,
  ...
}: {
  imports = [
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
    # and a value of 100 means IO cost is assumed to be equal.
    "vm.swappiness" = 150;

    # The value controls the tendency of the kernel to reclaim the memory which is used for caching of directory and inode objects (VFS cache).
    # Lowering it from the default value of 100 makes the kernel less inclined to reclaim VFS cache (do not set it to 0, this may produce out-of-memory conditions)
    "vm.vfs_cache_pressure" = 50;

    # Contains, as bytes, the number of pages at which a process which is
    # generating disk writes will itself start writing out dirty data.
    "vm.dirty_bytes" = 268435456;

    # page-cluster controls the number of pages up to which consecutive pages are read in from swap in a single attempt.
    # This is the swap counterpart to page cache readahead. The mentioned consecutivity is not in terms of virtual/physical addresses,
    # but consecutive on swap space - that means they were swapped out together. (Default is 3)
    # increase this value to 1 or 2 if you are using physical swap (1 if ssd, 2 if hdd)
    "vm.page-cluster" = 0;

    # Contains, as bytes, the number of pages at which the background kernel
    # flusher threads will start writing out dirty data.
    "vm.dirty_background_bytes" = 67108864;

    # The kernel flusher threads will periodically wake up and write old data out to disk.  This
    # tunable expresses the interval between those wakeups, in 100'ths of a second (Default is 500).
    "vm.dirty_writeback_centisecs" = 1500;

    # This action will speed up your boot and shutdown, because one less module is loaded. Additionally disabling watchdog timers increases performance and lowers power consumption
    # Disable NMI watchdog
    "kernel.nmi_watchdog" = 0;

    # Enable the sysctl setting kernel.unprivileged_userns_clone to allow normal users to run unprivileged containers.
    "kernel.unprivileged_userns_clone" = 1;

    # TCP Enable ECN Negotiation for both outgoing and incoming connections
    "net.ipv4.tcp_ecn" = 1;

    # Increase netdev receive queue
    # May help prevent losing packets
    "net.core.netdev_max_backlog" = 4096;

    # Disable TCP slow start after idle
    # Helps kill persistent single connection performance
    "net.ipv4.tcp_slow_start_after_idle" = 0;

    # Protect against tcp time-wait assassination hazards, drop RST packets for sockets in the time-wait state. Not widely supported outside of Linux, but conforms to RFC:
    "net.ipv4.tcp_rfc1337" = 1;

    # Set size of file handles and inode cache
    "fs.file-max" = 2097152;
  };
  services.bpftune.enable = true;
}
