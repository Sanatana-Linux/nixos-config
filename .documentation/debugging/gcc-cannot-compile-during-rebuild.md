# Error or Issue Template

- **Date:** 12-27-2024
- **Error or Issue Name:** Failed Rebuild With Complaints that GCC is There But Cannot Compile Executables
- **Notes on Mitigation Efforts**
  - Rebuilds only starting throwing error upon update, which was triggered to refresh the firefox build to reflect recent commits.
  - Internet has yielded no relevant or obviously related information other than potentially relating to the `--impure` flag and sandboxing of the build environment.
- **Potential Workarounds**

  - So far I have deleted all the related Nix files, clearned then optimized and repaired the store to no avail.
  - Will see if the `--impure` flag has any effect on next rebuild attempt

- **Solution or Verdict:** How problem was solved or issue overcome if by other means
