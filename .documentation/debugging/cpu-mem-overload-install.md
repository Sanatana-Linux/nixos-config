# CPU & Memory Overload During Installation 

- **Date:** 12-27-2024
- **Notes on Mitigation Efforts**
  - With CUDA related packages enabled in the configuration, during a fresh install on either my girlfriend's or my own Lenovo Legion Pro 5 (16irx9), the CPU load and Memory was hitting 100%
  - This caused the Systemd OOM utility to kill vital process (never the build process) and if left unattended would cause the computer to shut off nearly its temperature threshold (good thing I applied voltage regulation to the 14th gen processor before hand)
  - Obviously this made the installation fail, debugging this in the background extended the process considerably.
- **Potential Workarounds/Fixes/Solutions**
  - Two options have emerged to mitigate this issue, but cause the installation process to be longer than it otherwise would disabling the CUDA related bits and then re-emabling them aftrr installation
    1. Install using Calamares a "throw away" DE, once booted these tend to not run into the issue for some reason
    2. apply `--max-jobs 1` to the nixos-install command and optionally `--cores 16` to insure responsiveness is maintaained overall as some cores will be left free to enabke using the system  
- **Solution or Verdict:** HWent with solution two, since install failures take even longer than slower than normal installs anyway. Weird the macbook pro from 2014 didn't have this issue at all but what's the shock Intel (and AMD and Nvvidia) is more interested in making a quick buck than in making quality products worth the extreme prices they charge for them. 
