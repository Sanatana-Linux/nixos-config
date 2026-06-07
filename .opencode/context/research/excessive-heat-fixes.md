# Excessive Heat Investigation — bagalamukhi (Lenovo Legion 5 Pro)

**Discovered:** 2026-06-07  
**Source:** Session debugging — sustained 70-80°C idle temperatures on bagalamukhi (Lenovo Legion 5 Pro, Intel i9-14900HX + RTX 4070)

## Summary

Four independent root causes were identified, each contributing to excessive heat. The fixes span three modules: NVIDIA GPU config, CPU undervolt power limits, systemd coredump config, and the laptop power management strategy.

## Root Cause 1: NVIDIA GPU Forced to Full Power

### Problem

A udev rule locked the GPU into D0 full-power state permanently:

```nix
# REMOVED — This was in services.udev.extraRules
ATTR{power/control}="on"
```

Additionally, GPU firmware was disabled and Dynamic Power Management was absent:

```nix
# Was: GPU firmware disabled
"nvidia.NVreg_EnableGpuFirmware=0"
# Was: DynamicPowerManagement not set at all
```

### Fix

- Removed all udev rules from the NVIDIA module
- Enabled GPU firmware: `NVreg_EnableGpuFirmware=1`
- Added Dynamic Power Management: `NVreg_DynamicPowerManagement=0x02`
- PCIe ASPM set to balanced: `pcie_aspm.policy=balanced`

**File:** `modules/nixos/hardware/nvidia.nix`

### Verification

```bash
# Check GPU power control state — should show "auto"
cat /sys/class/drm/card*/device/power/control
# Expected: auto (not "on")

# Check GPU temperature with nvtop or sensors
sensors
nvtop
```

## Root Cause 2: CPU Power Limits Set to 150W in a Laptop

### Problem

The undervolt module (`modules/nixos/performance/undervolt.nix`) had PL1=150W and PL2=150W as defaults. For a Lenovo Legion 5 Pro laptop chassis, sustained limits over ~65W cause excessive heat buildup — the cooling system cannot dissipate 150W continuously.

### Fix

Changed defaults to laptop-appropriate limits:

| Parameter | Old Default | New Default | Rationale |
|-----------|-------------|-------------|-----------|
| PL1 (sustained) | 150W | **65W** | Matches laptop chassis cooling capacity |
| PL2 (short burst) | 150W | **100W** | Allows brief turbo headroom without sustained heat |

The `throttled` service applies these limits on both AC and battery power (5s / 30s update intervals respectively).

**File:** `modules/nixos/performance/undervolt.nix`

### Verification

```bash
cpupower frequency-info
# Check /sys/class/powercap/intel-rapl:* for power limit values
cat /sys/class/powercap/intel-rapl:0/constraint_0_power_limit_uw
# Should show 65000000 (65W)
```

### Configurability

These limits are exposed as module options, so individual hosts can override:

```nix
modules.performance.undervolt = {
  p1Limit = 65;   # sustained watts
  p2Limit = 100;  # short burst watts
};
```

## Root Cause 3: No Active Thermal Coordination (Lenovo Module)

### Problem

The lenovo module (`modules/nixos/hardware/lenovo.nix`) uses `mkForce false` to disable ALL power management daemons:

```nix
auto-cpufreq.enable = mkForce false;
tlp.enable = mkForce false;
power-profiles-daemon.enable = mkForce false;
```

This leaves no software layer coordinating thermals. The system relies entirely on:
- **Fn+Q** (platform_profile) — manual cooling mode switch (quiet/balanced/performance)
- **intel_pstate HWP** (Hardware P-State) — CPU internal frequency governor

Without a daemon, there is no automatic response to thermal events. The laptop will only throttle when CPU hits Tjmax (~100°C) via hardware thermal protection — there is no proactive thermal management.

### Status

**Not fixed.** The `mkForce false` overrides exist because Fn+Q (Lenovo's hardware thermal profile) conflicts with software power managers. This is a known tradeoff documented in the lenovo module. If thermal issues persist after GPU/CPU limit fixes, consider one of:

- Re-enabling a power daemon (e.g. `auto-cpufreq`) and accepting potential Fn+Q conflicts
- Writing a custom udev/systemd rule to set `platform_profile` based on temperature thresholds
- Monitoring temps manually and switching Fn+Q profiles as needed

### Verification

```bash
# Check current platform profile
cat /sys/firmware/acpi/platform_profile
# Shows: low-power / balanced / performance
```

## Root Cause 4: Deprecated systemd Coredump Config

### Problem

The systemd module used a deprecated `extraConfig` directive for coredump:

```nix
# WAS — deprecated extraConfig
systemd.coredump.extraConfig = "Storage=none";
```

### Fix

Replaced with the current NixOS option:

```nix
# NOW — native option
systemd.coredump = {
  enable = true;
  storage = "none";
};
```

**File:** `modules/nixos/system/systemd.nix`

This change does not affect heat but was discovered during the investigation and fixed as a housekeeping item.

## Heat Reduction Results

After applying fixes 1 and 2 (GPU power management + CPU power limits), idle temperatures should drop significantly. The expected improvement:

| Metric | Before | After (expected) |
|--------|--------|------------------|
| Idle GPU temp | ~55-65°C (stuck in D0) | ~40-50°C (entering L0s/L1) |
| Idle CPU temp | ~60-80°C (150W limits) | ~45-60°C (65W limits) |
| Fan noise | Constant | Cycling / off at idle |

## Related Context

- [NVMe Tuning → GPU Overheating on Hybrid Graphics Laptops](./nvme-heat-gpu-correlation.md) — Previous investigation into PCIe ASPM causing GPU heat
- `modules/nixos/hardware/nvidia.nix` — NVIDIA GPU config
- `modules/nixos/performance/undervolt.nix` — CPU undervolt and power limits
- `modules/nixos/system/systemd.nix` — systemd coredump config
- `modules/nixos/hardware/lenovo.nix` — Lenovo power management strategy