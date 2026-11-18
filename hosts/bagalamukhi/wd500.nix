{...}: {
  # On-demand unlock + mount for the WD 500G external drive (/dev/sdb1).
  # Unlock is prompted via systemd password agent when the automount is accessed;
  # the drive is not required at boot (noauto, nofail).
  environment.etc.crypttab.text = ''
    wd500 UUID=163b879d-a4e7-48c8-ab8b-7f9b5ad874ed - noauto,nofail,luks
  '';

  fileSystems."/mnt/WD-500" = {
    device = "/dev/mapper/wd500";
    fsType = "ext4";
    options = [
      "noauto"
      "nofail"
      "x-systemd.automount"
      "x-systemd.device-timeout=30"
      "x-systemd.idle-timeout=5min"
      "x-systemd.requires=systemd-cryptsetup@wd500.service"
      "x-systemd.after=systemd-cryptsetup@wd500.service"
    ];
  };
}
