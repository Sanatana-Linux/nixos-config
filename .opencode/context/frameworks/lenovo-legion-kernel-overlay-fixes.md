# Lenovo Legion Kernel Driver Overlay Fixes

> Two critical patches to the nixpkgs `lenovo-legion` package (v0.0.20) in `/etc/nixos/overlays/default.nix`.

## Fix 1: Sysfs Path — PNP0C09:00 → legion

### Root Cause

The nixpkgs package (v0.0.20, rev `f559df04`) hardcodes:

```python
LEGION_SYS_BASEPATH = '/sys/module/legion_laptop/drivers/platform:legion/PNP0C09:00'
```

On kernel 7.x+ (xanmod 7.0.12), the `legion_laptop` driver registers as:

```
/sys/module/legion_laptop/drivers/platform:legion/legion
```

The upstream source (johnfanv2/LenovoLegionLinux `main` branch) already has the kernel version check:

```python
kernel_version = tuple(map(int, os.uname().release.split('-')[0].split('.')))
if kernel_version >= (7, 0, 0):
    LEGION_SYS_BASEPATH = '/sys/module/legion_laptop/drivers/platform:legion/legion'
else:
    LEGION_SYS_BASEPATH = '/sys/module/legion_laptop/drivers/platform:legion/PNP0C09:00'
```

### The Fix

```nix
substituteInPlace ./legion_linux/legion.py \
  --replace-fail "LEGION_SYS_BASEPATH = '/sys/module/legion_laptop/drivers/platform:legion/PNP0C09:00'" \
  "LEGION_SYS_BASEPATH = '/sys/module/legion_laptop/drivers/platform:legion/legion'"
```

All `FileFeature` objects now resolve their sysfs paths correctly. Before this fix, every feature returned `path: None` with `WARNING: does not exist`.

---

## Fix 2: Graceful Error Handling for EC WMI Failures

### Root Cause

After the path fix, features now find their sysfs files — but the *BIOS* (N0CN on Legion Pro 5 16IRX9) returns garbage when the kernel module queries certain EC registers via WMI:

```
Unexpected ACPI result for 14afd777-106f-4c9b-b334-d388dc7809be:1: expected type 3 but got 1; expected length 16 but got 0;
WMI evaluation error for: da7547f1-824d-405f-be79-d9903e29ced7:8
```

When the kernel encounters these firmware errors, the sysfs `read()` returns `EINVAL` (errno 22). The Python code in `_read_file_str` catches the `IOError`, logs it — and then **re-raises** it:

```python
def _read_file_str(self, file_path) -> str:
    try:
        with open(file_path, "r", encoding=DEFAULT_ENCODING) as filepointer:
            out = str(filepointer.read()).strip()
        return out
    except IOError as err:
        log.error('Feature %s reading error %s', self.name(), str(err))
        log.error(get_dmesg(only_tail=True, filter_log=False))
        raise err   # <-- re-raises, crashing the GUI
```

And `_read_file_int` has no error handling at all:

```python
def _read_file_int(self, file_path) -> int:
    return int(self._read_file_str(file_path))
```

This means the GUI crashes with `OSError: [Errno 22] Invalid argument` whenever it tries to display features like `RapidChargingFeature`, `CPUOverclock`, `CPULongtermPowerLimit`, `GPUTemperatureLimit`, etc.

### The Fix

Wrap `_read_file_int` in a try/except:

```python
def _read_file_int(self, file_path) -> int:
    try:
        return int(self._read_file_str(file_path))
    except (IOError, ValueError):
        log.warning("Feature _read_file_int failed for %s, returning 0", file_path)
        return 0
```

Features that the BIOS WMI methods fail for will show as `0` in the GUI instead of crashing the entire application.

### Implementation

```nix
${final.python313.interpreter} -c "
import re
with open('./legion_linux/legion.py') as f:
    content = f.read()
old = '    def _read_file_int(self, file_path) -> int:\n        return int(self._read_file_str(file_path))'
new = '    def _read_file_int(self, file_path) -> int:\n        try:\n            return int(self._read_file_str(file_path))\n        except (IOError, ValueError):\n            log.warning(\"Feature _read_file_int failed for %s, returning 0\", file_path)\n            return 0'
content = content.replace(old, new)
with open('./legion_linux/legion.py', 'w') as f:
    f.write(content)
"
```

### Features That Work vs. Show 0

| Works (ACPI-based, no EC WMI needed) | Shows 0 (EC WMI fails on N0CN BIOS) |
|--------------------------------------|-------------------------------------|
| LockFanController                    | RapidChargingFeature                |
| MaximumFanSpeedFeature               | CPUOverclock                        |
| Overdrive                            | CPULongtermPowerLimit              |
| Gsync                                | CPUShorttermPowerLimit             |
| Winkey                               | CPUPeakPowerLimit                   |
| Touchpad                             | CPUCrossLoadingPowerLimit          |
| PlatformProfile                      | CPUAPUSPPTPowerLimit               |
| FnLock                               | GPUOverclock                        |
| BatteryConservation                  | GPUCTGPPowerLimit                  |
| CameraPower                          | GPUPPABPowerLimit                  |
| AlwaysOnUSBCharging                  | GPUTemperatureLimit                |

### Why These Fail

GUID `14afd777-106f-4c9b-b334-d388dc7809be` is the **Lenovo WMI General Purpose Event** interface. It wraps EC register reads/writes in ACPI methods. The kernel module calls these WMI methods, and the ACPI bytecode in the N0CN BIOS returns unexpected data types (empty buffers when integers are expected). This is a firmware-level bug — not fixable at the OS layer.

GUID `da7547f1-824d-405f-be79-d9903e29ced7` is a **Lenovo-specific WMI** interface for fan/power management. It has the same firmware-level issues.

### What's NOT Affected

These features work fine because they use different access methods:

- **Fan curves** → hwmon PWM auto-points via EC register writes (not WMI) **WORKING**
- **thermalmode / powermode** → direct platform driver sysfs (not WMI) **WORKING**
- **Platform profile** → ACPI platform_profile interface (not EC WMI) **WORKING**
- **CPU power limits** → Intel P-State powercap interface (separate from EC WMI) **WORKING**
- **GPU power limits** → nvidia-smi (separate from EC WMI) **WORKING**
