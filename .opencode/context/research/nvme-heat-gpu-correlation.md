# NVMe Tuning → GPU Overheating on Hybrid Graphics Laptops

**Discovered:** 2026-05-08  
**Source:** Session debugging — RTX 4070 running excessively hot on Lenovo Legion 5 Pro (bagalamukhi)

## The Problem

The RTX 4070 dGPU was running way hotter than expected during normal desktop use (sync mode, driving display 24/7).

## Root Cause

NVMe PCIe power-saving/performance tuning parameters were interfering with PCIe ASPM (Active State Power Management), preventing the NVIDIA GPU from reaching lower power states.

### The Culprits (all removed):

**In `boot.nix` and `udev.nix`:**
- `nvme_core.default_ps_max_latency_us=0` — Forces NVMe to never enter power-saving states
- `nvme.poll_queues=8` — Increases polling interrupt load
- `pcie_aspm.policy=performance` — Disables PCIe ASPM aggressively
- `pci=pcie_bus_perf,realloc` — Forces PCIe performance mode

**NVMe udev tuning:**
- `queue/scheduler="none"` — Bypasses I/O scheduler
- `queue/rq_affinity="2"` — CPU affinity tuning
- `queue/nomerges="1"` — Disables request merging
- `queue/iostats="0"` — Disables I/O statistics

### Why It Causes Heat

On NVIDIA Prime sync mode laptops, the dGPU and NVMe both sit behind the same PCIe root port. When NVMe tuning forces PCIe to stay in high-performance mode (or disables ASPM entirely via `pcie_aspm.policy=performance`), the GPU's PCIe link can never enter L1/L1.1/L1.2 substates — it stays in L0 (full power) 24/7.

## Verification

Removing ALL of these NVMe/PCIe customizations caused the GPU temperature to drop back to normal idle levels. The NVIDIA and Lenovo modules were **not** the cause — they were restored along with all their customizations and the heat stayed gone.

## Lesson

Never tune NVMe or PCIe ASPM parameters on hybrid graphics laptops with dGPU sync mode. The NVMe and dGPU share PCIe tree topology, and ASPM tuning that seems NVMe-specific will prevent the dGPU from idling.
