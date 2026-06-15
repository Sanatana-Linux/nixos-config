# Lenovo Legion — Hardware Interface Reference

> EC, WMI, ACPI, and firmware interfaces for Lenovo Legion laptops.  
> Model: Legion Pro 5 16IRX9 (bagalamukhi, BIOS N0CN → model_g8cn).  
> Kernel module: johnfanv2/LenovoLegionLinux (overlay: `352cb4b3`).

## Interface Layers (from OS to Hardware)

```
┌─ userspace ──────────────────────────────────────────────────┐
│  legion_gui (Python/PyQt6) ←── WARNING: partially broken     │
│  legion_cli (Python CLI)    ←── WARNING: partially broken     │
│  legion-fan (shell script)  ←── works, uses hwmon sysfs      │
│  cat /sys/... (manual)      ←── works, raw sysfs access      │
└──────────────────────────────────────────────────────────────┘
                          │
                          ▼
┌─ kernel ─────────────────────────────────────────────────────┐
│  lenovo-legion-module (platform driver)                       │
│  ├── hwmon: fan curves, temps, fan speeds (EC register)      │
│  ├── platform_profile: Fn+Q profiles (ACPI)                  │
│  ├── thermalmode/powermode: EC thermal/power config          │
│  └── WMI calls: power limits, overclocking, etc.             │
│  Intel P-State driver: CPU power limiting (powercap)         │
│  nvidia driver: GPU power limiting (nvidia-smi)              │
└──────────────────────────────────────────────────────────────┘
                          │
                          ▼
┌─ ACPI/WMI ───────────────────────────────────────────────────┐
│  BIOS bytecode (ACPI methods embedded in firmware)            │
│  ├── 14afd777-106f-4c9b-b334-d388dc7809be: Lenovo WMI GP E  │
│  └── da7547f1-824d-405f-be79-d9903e29ced7: Lenovo fan/power │
│  NOTE: On N0CN BIOS, several methods return wrong data types │
└──────────────────────────────────────────────────────────────┘
                          │
                          ▼
┌─ EC (Embedded Controller) ───────────────────────────────────┐
│  ITE or Nuvoton EC chip (model-specific)                      │
│  ├── Fan speed registers                                     │
│  ├── Fan curve registers (10-point)                          │
│  ├── Thermal mode register                                   │
│  ├── Power mode register                                     │
│  ├── Power limit registers (CPU/GPU)                         │
│  └── Overclock register                                      │
│  Access methods for model_g8cn: ACCESS_METHOD_EC             │
└──────────────────────────────────────────────────────────────┘
                          │
                          ▼
┌─ SMM (System Management Mode) ───────────────────────────────┐
│  BIOS-level privilege mode                                    │
│  ├── SREP: exploits SMM call gates to set UEFI variables     │
│  │   (unlocks Advanced BIOS menus)                            │
│  └── MITIGATED in newer BIOS (patched SMM handlers)          │
└──────────────────────────────────────────────────────────────┘
```

## Sysfs Map

### `/sys/devices/platform/legion/`

| File                    | R/W | Description                          | Working? |
| ----------------------- | --- | ------------------------------------ | -------- |
| `thermalmode`             | RW  | EC thermal mode (0-4)                | ✅        |
| `powermode`               | RW  | EC power mode (0-4)                  | ✅        |
| `fan_fullspeed`           | RW  | Force fans to max (0/1)              | ✅        |
| `fan_maxspeed`            | RW  | Set max fan speed (0/1)              | ✅        |
| `lockfancontroller`       | RW  | Lock fan controller (0/1)            | ✅        |
| `overdrive`               | RW  | Overdrive mode (0/1)                 | ✅        |
| `gsync`                   | RW  | G-Sync toggle (0/1)                  | ✅        |
| `touchpad`                | RW  | Touchpad toggle (0/1)                | ✅        |
| `winkey`                  | RW  | Windows key toggle (0/1)             | ✅        |
| `cpu_longterm_powerlimit` | RW  | CPU PL1 in mW                        | ❌ (WMI)  |
| `cpu_shortterm_powerlimit`| RW  | CPU PL2 in mW                        | ❌ (WMI)  |
| `cpu_peak_powerlimit`     | RW  | CPU peak power in mW                 | ❌ (WMI)  |
| `cpu_oc`                  | RW  | CPU overclock toggle (0/1)           | ❌ (WMI)  |
| `gpu_oc`                  | RW  | GPU overclock toggle (0/1)           | ❌ (WMI)  |
| `gpu_ctgp_powerlimit`     | RW  | GPU power limit in mW                | ❌ (WMI)  |
| `gpu_temperature_limit`   | RW  | GPU temp limit in °C                 | ❌ (WMI)  |
| `rapidcharge`             | RW  | Rapid charge toggle (0/1)            | ❌ (WMI)  |
| `platform-profile/`       | dir | Platform profile selection           | ✅        |
| `hwmon/`                  | dir | Hwmon interface (fans, temps)        | ✅        |

### `/sys/class/hwmon/hwmon*/` (name: "legion_hwmon")

| File                            | Description                           | Range  |
| ------------------------------- | ------------------------------------- | ------ |
| `temp1_input`                     | CPU temperature (millidegrees)        | —      |
| `temp2_input`                     | GPU temperature                       | —      |
| `temp3_input`                     | IC/chipset temperature                | —      |
| `fan1_input`                      | Fan 1 RPM                            | —      |
| `fan2_input`                      | Fan 2 RPM                            | —      |
| `pwm*_auto_point*_pwm`             | Fan speed at curve point              | 0-255  |
| `pwm*_auto_point*_temp`            | Temperature threshold at point (°C)   | —      |
| `pwm*_auto_point*_temp_hyst`       | Temperature hysteresis at point       | —      |
| `pwm*_auto_point*_accel`           | Fan acceleration at point             | 2-5    |
| `pwm*_auto_point*_decel`           | Fan deceleration at point             | 2-5    |
| `fan1_max` / `fan2_max`            | Max fan RPM (10000)                   | —      |
| `fan1_target` / `fan2_target`      | Target fan RPM                        | —      |
| `minifancurve`                     | Mini fan curve data                   | —      |

**IMPORTANT**: For model_g8cn (N0CN BIOS), `fan_speed_unit = FAN_SPEED_UNIT_RPM_HUNDRED` internally, but the sysfs interface expects **PWM values (0-255)**, not RPM. The kernel converts PWM ↔ RPM/100 automatically. Accel/decel must be 2-5 (kernel rejects values < 2).

### Intel P-State Powercap (alternative to EC WMI)

```
/sys/devices/virtual/powercap/intel-rapl/intel-rapl:0/
├── constraint_0_power_limit_uw   # PL1 (long-term) in microwatts
├── constraint_1_power_limit_uw   # PL2 (short-term) in microwatts
└── energy_uj                     # Energy consumed
```

This is the **correct** way to set CPU power limits from the OS. It works on any BIOS version and doesn't depend on EC WMI at all. The `undervolt.nix` module uses this interface.

## Thermal/Power Modes

| Value | thermalmode | powermode   | Fan Behavior    | Power Delivery |
| ----- | ----------- | ----------- | --------------- | -------------- |
| 0     | Quiet       | Low Power   | Minimal, slow   | Battery-saver  |
| 1     | Balanced    | Balanced    | Moderate        | Normal         |
| 2     | Performance | Performance | High            | High           |
| 3     | Extreme     | Turbo       | Very aggressive | Maximum        |
| 4     | Full Speed  | Custom      | Full blast      | Custom limits  |

**Current config**: thermalmode=4, powermode=4 (set by `legion-cooling.service`).

## Model-Specific EC Register Map

For model_g8cn (N0CN BIOS, Legion Pro 5 16IRX9):

```c
.registers = &ec_register_offsets_v0,
.access_method_fancurve = ACCESS_METHOD_EC,
.has_minifancurve = true,

.EXT_FAN_CUR_POINT = 0xC534,
.EXT_FAN_POINTS_SIZE = 0xC535,
.EXT_FAN1_BASE = 0xC540,       // Fan 1 curve: 8 registers (points 0-9)
.EXT_FAN2_BASE = 0xC550,       // Fan 2 curve: 8 registers
.EXT_FAN_ACC_BASE = 0xC560,    // Acceleration values
.EXT_FAN_DEC_BASE = 0xC570,    // Deceleration values
.EXT_FAN1_RPM_LSB = 0xC5E0,    // Fan 1 RPM reading (low byte)
.EXT_FAN1_RPM_MSB = 0xC5E1,    // Fan 1 RPM reading (high byte)
.EXT_FAN2_RPM_LSB = 0xC5E2,
.EXT_FAN2_RPM_MSB = 0xC5E3,
.EXT_FAN1_TARGET_RPM = 0xC600, // Fan 1 target RPM
.EXT_FAN2_TARGET_RPM = 0xC601, // Fan 2 target RPM
```

The kernel module writes fan curves by writing to these EC registers via I/O port commands (ACCESS_METHOD_EC). This is a **different access path** from the WMI methods — which is why fan curves work fine even though WMI calls fail.

## WMI GUID Reference

| GUID                                   | Name                          | What It Does                                |
| -------------------------------------- | ----------------------------- | ------------------------------------------- |
| `14afd777-106f-4c9b-b334-d388dc7809be` | Lenovo WMI General Purpose Event | Power limits, OC toggles, rapid charge, etc. |
| `da7547f1-824d-405f-be79-d9903e29ced7` | Lenovo Fan/Power Management   | Fan control, power state queries             |

These GUIDs map to ACPI bytecode methods in the BIOS. On N0CN, several methods under `14afd777` return incorrect data types.

## Access Methods Summary

| Feature Category         | Access Path              | Dependencies            | N0CN Status |
| ------------------------ | ------------------------ | ----------------------- | ----------- |
| Fan curves               | EC registers (I/O ports) | Kernel module           | ✅ Working    |
| Fan RPM / temps          | EC registers (I/O ports) | Kernel module + hwmon   | ✅ Working    |
| Platform profile (Fn+Q)  | ACPI platform_profile    | Kernel built-in         | ✅ Working    |
| Thermal/power modes      | EC registers (I/O ports) | Kernel module           | ✅ Working    |
| Power limits (EC)        | WMI → ACPI → EC          | BIOS ACPI bytecode      | ❌ Firmware bug |
| Overclocking (EC)        | WMI → ACPI → EC          | BIOS ACPI bytecode      | ❌ Firmware bug |
| Power limits (CPU)       | Intel P-State powercap   | Kernel built-in         | ✅ Working    |
| Power limits (GPU)       | nvidia-smi               | NVIDIA driver           | ✅ Working    |
| Advanced BIOS menus      | SMM calls (SREP)         | BIOS SMM handlers       | ✅ (current BIOS) |
