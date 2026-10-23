---
title: "CUDA Build Strategy — Keeping NixOS Substitution-Only"
type: concept
tags: [nix, cuda, nvidia, build, substitution, cache]
created: 2026-10-22
updated: 2026-10-23
status: active
---

# CUDA Build Strategy

Why `nixos-rebuild` on this flake occasionally tries to compile CUDA packages
locally, how to stop it, and what the override arguments are actually called.

## The mechanism

`modules/nixos/hardware/nvidia.nix` sets:

```nix
nixpkgs.config.cudaSupport = cfg.cuda.enable;
```

That global flag makes every package whose derivation reads
`enableCuda ? config.cudaSupport` build a CUDA-flavoured variant. The flake
follows `nixos-unstable-small`, and **CUDA builds are only published for the
full `nixos-unstable` rev** — a rev-specific hash from `nixos-unstable-small`
exists in no binary cache. Hydra does not build it, `cache.nixos-cuda.org` does
not carry it. Nix therefore compiles it locally with `nvcc`.

Observed consequence: a rebuild that should substitute everything starts
compiling `opencv`, `ncnn`, and `peakperf` locally.

## Cache facts (verified 2026-10-22)

| Fact | Evidence |
|------|----------|
| `cache.nixos-cuda.org` is reachable and healthy | `narinfo` returns `200` over both HTTP/1.1 and HTTP/2 |
| CUDA paths **do** substitute when the rev matches | `cuda-merged`, `libcublas`, `libcusolver`, `saxpy` all copied from `https://cache.nixos-cuda.org` |
| The CDN intermittently resets HTTP/2 streams | `cuda13.4-cuda_sanitizer_api` download aborted, then "no substituter can build it" |
| `nixos-unstable-small` revs are not in the CUDA jobset | every CUDA-variant hash misses; the base hashes hit |
| Some CUDA toolkit components still build locally | `cuda_opencl` is pulled by the nix-ld library list in `modules/nixos/system/apps/runtimes/nix-ld.nix` and has no cached variant |

## The override argument is `enableCuda`, not `cudaSupport`

`config.cudaSupport` is the *config flag*; `enableCuda` is the *derivation
argument* that reads it. Passing `cudaSupport` to `.override` fails at
evaluation:

```
error: function 'anonymous lambda' called with unexpected argument 'cudaSupport'
```

Correct form:

```nix
opencv4 = prev.opencv4.override { enableCuda = false; };
peakperf = prev.peakperf.override { enableCuda = false; };
```

With `enableCuda = false` the derivation is byte-identical to the published
non-CUDA build and substitutes from `cache.nixos.org`.

## What actually needs CUDA here

| Consumer | Needs CUDA? |
|----------|-------------|
| `ollama` (`modules/nixos/system/apps/ai/ollama.nix`) | yes — `ollama-cuda` is the inference path |
| ComfyUI / PyTorch | yes |
| `ncnn` upscalers (`upscayl`, `realesrgan-ncnn-vulkan`, `realcugan`, `video2x`) | no — they use Vulkan; ncnn has no `cudaSupport` argument |
| `opencv` (only consumer: `frei0r` → `shotcut`) | no — CPU video effects |
| `ffmpeg-full` | pinned to stable specifically so its `withCudaNVCC` variant never builds |
| `peakperf` | no — the GPU path targets `compute_50`, which CUDA 13 dropped (`nvcc fatal: Unsupported gpu architecture 'compute_50'`) |

## Build-throughput settings

`modules/nixos/base/nix.nix`:

```nix
max-jobs = cfg.maxJobs;   # default 4 — was 32
cores = 6;                # caps NIX_BUILD_CORES so cargo/rust stop spawning one job per core
```

At `max-jobs = 32` on a 31 GiB machine the kernel OOM killer reaped the desktop
(Firefox renderers, `oom_score_adj=200`) during a rebuild. Four jobs with six
cores each keeps peak usage under memory while still using the machine.

### The settings only apply after activation

`nix-daemon` reads `/etc/nix/nix.conf` at start, and that file is written by
activation. A rebuild therefore runs under the **previous** generation's
values — editing `maxJobs` mid-flight does nothing to the build in progress.
Observed: config said `max-jobs = 4` / `cores = 6` while `nix config show`
still reported `max-jobs = 32` and `cores = 0` (unlimited: every job gets all
32 threads), which is why gcc/rustc saturated the machine and load average
reached 80+ on a 32-thread box.

`cores = 0` is the trap: it hands each derivation the full core count, so a
concurrency cap alone does not bound CPU use.

### Weights, not quotas, for interactivity

Capping `max-jobs` bounds how much a build *asks for*; it does not stop the
granted jobs from monopolising the CPU. cgroup v2 weights make the daemon's
build subtree yield to the session proportionally:

```nix
systemd.services.nix-daemon.serviceConfig = {
  CPUWeight = 15;   # against user.slice's default 100
  IOWeight = 40;
};
```

Applied at runtime with `systemctl set-property --runtime nix-daemon.service
CPUWeight=15 IOWeight=40` it takes effect immediately, without killing running
builds — the surgical alternative to killing a rebuild. Builds keep the whole
machine when idle and give way when the desktop needs CPU.

`nix.daemonCPUSchedPolicy = "idle"` achieves a stronger version, but it applies
SCHED_IDLE to activation builds too, which can starve the very switch that
installs it. `CPUQuota = "1400%"` is the hard-cap alternative: predictable
response, roughly doubled rebuild times.

## Operator rules for a long rebuild

- Watch the log for `building '...cuda...'` / `nvcc` / `opencv` / `ncnn`; those
  are the signals that substitution has been lost.
- `peakperf` and `opencv` appearing in the build list means an `enableCuda`
  override is missing, not that the cache is down.
- Run the rebuild detached and kill by **process group** (`/tmp/rebuild.pgid`),
  never `pkill -f`: a `-f` pattern matches the killer's own command line and
  takes down the shell.
- A wall-clock test failure under load (e.g. `svgwrite`
  `test_performance < 0.1 s`, measured 0.26 s) is a load artifact, not a
  regression — disable that check in the package scope rather than raising
  `max-jobs`.

## CUDA 13 dropped Pascal — the 13.4 assertion and the pin

CUDA 13 removed compute 5.0–7.0 (Maxwell, Pascal, Volta). nixpkgs defaults
`cudaPackages` to `cudaPackages_13_4`, and that set's `backendStdenv` asserts on
any requested capability below 7.5:

```
cudaPackages_13_4.backendStdenv has failed assertions:
  Requested CUDA capabilities which are too old for CUDA 13.4: ["6.1"]
```

`kamala` requests `capabilities = [ "6.1" ]` (GTX 1080), so every CUDA package
in its closure failed to evaluate. Probe results with `cudaCapabilities = ["6.1"]`:

| Package set            | `backendStdenv` |
| ---------------------- | --------------- |
| `cudaPackages` (13.4)    | throws          |
| `cudaPackages_12_9`      | evaluates       |

All 15 `cudaPackages` attributes this repo references exist in both sets.

**Rule**: when a host requests a capability below `"7.5"`, pin
`cudaPackages = prev.cudaPackages_12_9` via an overlay
(`modules/nixos/hardware/nvidia.nix`). Do not simply drop the capability —
binaries built without `sm_61` cannot run on a Pascal card at all.

Result: `kamala` builds CUDA against 12.9, hosts without capabilities
(`bagalamukhi`) stay on the 13.4 default. See ADR-022.

## References

- [[decisions]] — ADR-019, ADR-022
- `modules/nixos/hardware/nvidia.nix`
- `modules/nixos/base/nix.nix`
- `overlays/default.nix`
