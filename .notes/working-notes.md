# Notes on Flakes

## Submodule Alternative

Depending on use case, they may also be a convenient way of including other code and projects your **NixOS** configuration may require - this also eases the integration of the submodule into one's **NixOS** environment as part of the system's configuration, which is vital for including things that would otherwise be lost in the Nix Store - this applies to things like grub themes for instance - see the inclusion of my own grub theme in this repo as an example that was relatively easy to write up (thanks to darkmatter-grub-theme existing with a flake [here](https://gitlab.com/VandalByte/darkmatter-grub-theme/-/blob/main/flake.nix))

### Converting Current Submodules to NixOS Flakes

At the time of writing and when this process began, two submodules were included as vital parts of this repository:

1. My AwesomeWM configuration
2. My ZSH configuration
   The latter is not as imperative of a submodule and may be replaced entirely with a declarative configuration.

## Making Sense of Modules vs. Configurations

**Modules** - custom implementations in which the 
