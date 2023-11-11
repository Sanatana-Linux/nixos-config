# Error or Issue Template

- **Date:** 06-16-2023
- **Error or Issue Name:** ZSH Errors and Slowdown at Loading Time
- **Notes on Mitigation Efforts**
  - at reinstall z-shell was running slow and spitting out ZLE + completion errors
  - moved zmodule loading to the compeltion init section
  - eliminated redundant plugins
  - rearranged the logic of the configuration a bit
- **Solution or Verdict:** Shell is loading without errors for now
