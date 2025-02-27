# Error or Issue Template

- **Date:** 06-16-2023
- **Error or Issue Name:** ZSH Errors and Slowdown at Loading Time
- **Notes on Mitigation Efforts**
  - at reinstall z-shell was running slow and spitting out ZLE + completion errors
  - moved zmodule loading to the compeltion init section
  - eliminated redundant plugins
  - rearranged the logic of the configuration a bit
- **Solution or Verdict:** Shell is loading without errors for now

- **Date:** November 2024
  - Shell slowdown and stall upon opening a new terminal window had been wearing on me for a while. On older hardware, it is to be expected to some degree, but had become excessive.
  - With assistance of variable quality from AI, I simplified or eliminated a vast swath of code clogging up the nix rendered `~/.zshenv` and the z-shell completion engine. 
    - Considering even more radical reductions in third party plugins and creating a roughly comparable BASH shell configuration due to the shell being a little too latent still and it reminding me of using `Oh-My-(Bloated)-ZSH` 
      - Fish is also interesting, despite the name, but other alternative shells seem like they are not worth the added investment to learn their quirks (or are Powershell, which I need not deliberate on why that is not a serious contender).
