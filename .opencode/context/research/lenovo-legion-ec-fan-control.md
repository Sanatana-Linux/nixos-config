# Lenovo Legion EC Fan & Thermal Control

> Research on the Lenovo Legion embedded controller (EC) fan/thermal system for the Legion Pro 5 16IRX9 (bagalamukhi).

## Kernel Module: `lenovo-legion-module`

The `lenovo-legion-module` kernel module (from [johnfanv2/LenovoLegionLinux](https://github.com/johnfanv2/LenovoLegionLinux)) provides sysfs control over the EC. It is already loaded and working on bagalamukhi.

### Sysfs Interface: `/sys/devices/platform/legion/`

| Attribute | Type | Values | Description |
|-----------|------|--------|-------------|
| `fan_fullspeed` | RW | 0/1 | Force both fans to full speed immediately |
| `fan_maxspeed` | RW | 0/1 | Set fans to maximum speed (EC-controlled max) |
| `lockfancontroller` | RW | 0/1 | Lock the EC fan controller |
| `thermalmode` | RW | 0-4 | Thermal mode (higher = more aggressive cooling) |
| `powermode` | RW | 0-4 | Power mode (higher = more performance) |
| `overdrive` | RW | 0/1 | Overdrive mode |
| `gsync` | RW | 0/1 | G-Sync toggle |
| `touchpad` | RW | 0/1 | Touchpad toggle |
| `winkey` | RW | 0/1 | Windows key toggle |
| `cpu_longterm_powerlimit` | RW | mW | CPU long-term power limit (PL1) |
| `cpu_shortterm_powerlimit` | RW | mW | CPU short-term power limit (PL2) |
| `cpu_peak_powerlimit` | RW | mW | CPU peak power limit |
| `gpu_ctgp_powerlimit` | RW | mW | GPU power limit |
| `gpu_temperature_limit` | RW | °C | GPU temperature limit |
| `platform-profile/` | dir | | Platform profile control |

### Platform Profile

```
/sys/devices/platform/legion/platform-profile/platform-profile-0/
├── choices        # "low-power balanced performance custom"
├── profile        # Current profile (RW)
```

Valid profiles: `low-power`, `balanced`, `performance`, `custom`

### Hwmon Interface: `/sys/devices/platform/legion/hwmon/hwmon*/`

| Attribute | Description |
|-----------|-------------|
| `temp1_input` | CPU temperature (millidegrees) |
| `temp2_input` | GPU temperature (millidegrees) |
| `temp3_input` | IC/chipset temperature (millidegrees) |
| `fan1_input` | Fan 1 RPM |
| `fan2_input` | Fan 2 RPM |
| `fan1_max` | Fan 1 max RPM (10000) |
| `fan2_max` | Fan 2 max RPM (10000) |
| `fan1_target` | Fan 1 target RPM |
| `fan2_target` | Fan 2 target RPM |
| `pwm1_auto_point{1-10}_temp` | Fan 1 curve temp thresholds (°C) |
| `pwm1_auto_point{1-10}_pwm` | Fan 1 curve PWM values (0-255) |
| `pwm2_auto_point{1-10}_temp` | Fan 2 curve temp thresholds (°C) |
| `pwm2_auto_point{1-10}_pwm` | Fan 2 curve PWM values (0-255) |
| `auto_points_size` | Number of auto points (10) |

### Thermal & Power Modes

| Mode | thermalmode | powermode | Behavior |
|------|-------------|-----------|----------|
| 0 | Quiet/Cool | Low Power | Minimal fan, power saving |
| 1 | Balanced | Balanced | Default balanced |
| 2 | Performance | Performance | Higher fan, more power |
| 3 | Extreme | Turbo | Aggressive cooling, max power |
| 4 | Full Speed | Custom | Fans max, custom power limits |

## ExtremeCooling4Linux AppImage Analysis

The AppImage (`ExtremeCooling4Linux-v0.3-x86_64.AppImage`) is a Python 3.6 GTK application that uses direct I/O port access to communicate with the EC.

### Mechanism

1. **`portio` C extension module** — A custom CPython module that wraps Linux `ioperm()`/`iopl()` syscalls and `inb()`/`outb()` port I/O functions
2. **Direct EC register access** — Uses `iopl(3)` to gain full I/O port privileges, then reads/writes EC registers via I/O ports (typically 0x6C/0x6D or 0x62/0x66 for EC)
3. **GTK3 UI** — Glade-based UI for controlling fan speed, thermal mode, and power mode

### Key Functions (from portio module)

- `iopl(level)` — Set I/O privilege level (3 = full access)
- `ioperm(from, extent, enable)` — Set port access permissions
- `inb(port)` — Read byte from I/O port
- `outb(data, port)` — Write byte to I/O port
- `inw(port)` — Read 16-bit word from I/O port
- `outw(data, port)` — Write 16-bit word to I/O port

### Why It Works So Reliably

The AppImage bypasses the kernel module entirely and talks directly to the EC hardware via I/O ports. This is the most reliable way to control fans because:
- It works at the hardware level, not through any kernel driver
- It doesn't depend on ACPI or platform driver support
- It can set EC registers that the kernel module may not expose

## Recommended Approach

**Prefer the kernel module sysfs interface** over direct I/O port access because:
1. No root privileges needed for sysfs (with proper udev rules)
2. Safer — can't crash the EC
3. More portable across kernel versions
4. Already loaded and working

For maximum cooling under load:
1. Set `thermalmode=4` (full speed cooling)
2. Set `powermode=4` (turbo power delivery)
3. Set `platform-profile=performance`
4. Optionally set `fan_fullspeed=1` for immediate max fans
5. Write an aggressive custom fan curve via `pwm*_auto_point*` sysfs attributes

### Aggressive Fan Curve (10-point)

```
Point  Temp(°C)  PWM(0-255)
1      40        80    (30% at 40°C)
2      45        100   (40% at 45°C)
3      50        120   (50% at 50°C)
4      55        140   (55% at 55°C)
5      60        160   (65% at 60°C)
6      65        180   (70% at 65°C)
7      70        200   (80% at 70°C)
8      75        220   (85% at 75°C)
9      80        240   (95% at 80°C)
10     85        255   (100% at 85°C)
```

### One-liner for max cooling

```bash
# Immediate full fans
echo 1 | sudo tee /sys/devices/platform/legion/fan_fullspeed

# Or set extreme thermal mode
echo 4 | sudo tee /sys/devices/platform/legion/thermalmode
echo 4 | sudo tee /sys/devices/platform/legion/powermode
```
