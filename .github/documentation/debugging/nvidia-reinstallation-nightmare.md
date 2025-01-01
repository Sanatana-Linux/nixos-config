# Nvidia Reinstallation Lockout Nightmare


- **Notes on Mitigation Efforts**
  - Sara's laptop would not install identical configuration to that running on mine
  - To deduce the issue I reinstalled and hoped to be able to work it out locally under less direct pressure
  - Tons of packages wouldn't rebuild, complaining of still unknown compiler issues with GCC
  - this came with the annoying CUDA packages installing and eating so many resources I had to set `--max-jobs 1` and `--cores 16` to prevent overheating and forced shutdowns on either laptop (yay Intel 14th generation, good thing I undervolted from the BIOS advanced menu before this began setting the voltage regulator to 1.35v from the default of unlimited)
  - Three days of debugging, optimizing and failed boots ensued
    - taxing me greatly in the process and making me question my life decisions, but I held through it and figured it was something with patience could be rectified, it was.
    - learned a lot about the nixOS graphics stack in the process
    - got rid of the flatpak bloat (gimp 3.0 not worth the imperative and bloat heavy RedHat package manager only marginally better than snapd and no less bloated)
  - Turned out the culprit was that I removed the `xorg_sys_opengl` and intel graphics packages, don't do that on hybrid graphics with Nvidia + Intel
  - Didn't solve my issues with her computer, but my desktop environment is restored to working order and much better optimized.
- **Solution or Verdict:** Don't remove the intel-media-driver or xorg system packages. Seriously, don't. Remove other packages

