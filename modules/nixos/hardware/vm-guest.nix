{
  config,
  lib,
  ...
}:
with lib; let
  cfg = config.modules.hardware.vmGuest;
in {
  options.modules.hardware.vmGuest = {
    enable = mkEnableOption "guest-side tuning for a QEMU/KVM virtual machine";

    guestAgent = mkOption {
      type = types.bool;
      default = true;
      description = ''
        Run the QEMU guest agent, which lets the hypervisor read the guest's
        addresses, freeze filesystems for a snapshot, and request a clean
        shutdown instead of cutting virtual power.
      '';
    };

    balloon = mkOption {
      type = types.bool;
      default = true;
      description = ''
        Load the virtio memory balloon so the host can reclaim guest RAM the
        guest has stopped using.
      '';
    };

    sharedFilesystems = mkOption {
      type = types.bool;
      default = true;
      description = ''
        Load the 9p and virtiofs transports used to share host directories
        with the guest.
      '';
    };

    mitigations = mkOption {
      type = types.enum ["auto" "off"];
      default = "auto";
      description = ''
        CPU vulnerability mitigations. `"off"` removes the retpoline, IBRS and
        MDS cost from the guest's hot paths; it is only appropriate when the
        hypervisor runs on the same trusted machine, because the guest cannot
        see which physical CPU it is scheduled on.
      '';
    };
  };

  config = mkIf cfg.enable {
    # The guest boots from virtio-blk or virtio-scsi, so those drivers have to
    # be in the initrd or the root filesystem is never found.
    boot.initrd.kernelModules =
      ["virtio_pci" "virtio_blk" "virtio_scsi" "virtio_net" "virtio_console"]
      ++ optional cfg.balloon "virtio_balloon";

    boot.kernelModules =
      optional cfg.sharedFilesystems "9pnet_virtio"
      ++ optional cfg.sharedFilesystems "virtiofs";

    boot.kernelParams =
      [
        # Paravirtual clock in place of emulated TSC/HPET: reads come from a
        # shared page instead of a VM exit, so timers cost the host less CPU
        # and wakeups land more punctually.
        "clocksource=kvm-clock"
        # Every kernel this repo ships has PREEMPT_DYNAMIC, so the preemption
        # model is a boot parameter rather than a build-time choice.
        "preempt=full"
      ]
      ++ optional (cfg.mitigations == "off") "mitigations=off";

    services.qemuGuest.enable = cfg.guestAgent;

    # A guest desktop wants the same latency tuning as a physical one.
    modules.hardware.scheduler.enable = mkDefault true;

    # Deliberately not set here:
    #   tsc=reliable      — the guest TSC is virtual and may be trapped; kvm-clock
    #                       is the clock source that can be trusted.
    #   idle=poll         — trades host CPU burn for latency, the opposite of
    #                       keeping the guest's footprint small.
    #   processor.max_cstate / intel_idle.* — cpuidle states in a guest are
    #                       emulated; the knob changes nothing real.
  };
}
