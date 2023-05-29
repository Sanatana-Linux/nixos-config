# Notes on Flakes

## Table of Contents

- [Notes on Flakes](#notes-on-flakes)
  - [Table of Contents](#table-of-contents)
  - [Introduction](#introduction)
  - [Submodule Alternative](#submodule-alternative)
    - [Converting Current Submodules to NixOS Flakes](#converting-current-submodules-to-nixos-flakes)


-----

## Introduction

**NixOS** **flakes** provide a new way to manage your system configuration, dependencies, and software builds, using a declarative, reproducible, and atomic approach.

- traditionally the system configuration is defined in a single file called `/etc/nixos/configuration.nix`.
  - This file specifies all the packages, services, users, and other system settings that should be installed and configured on the system.
    - this approach can become cumbersome as the system configuration grows more complex
- with **NixOS** **flakes** the system configuration is defined in a set of declarative files called "**flake inputs**"
  - that describe the system's configuration and dependencies.
    - easily composed and shared across multiple systems
      - making it easier to manage large and complex **NixOS** deployments.
- Flake inputs can include not only the system configuration but also the entire package build process
  - including source code, dependencies, and build instructions.
    - which can be easily reused and shared
- provide atomic updates
  - meaning that system updates are applied as a whole and can be rolled back if necessary

## Submodule Alternative

Depending on use case, they may also be a convenient way of including other code and projects your **NixOS** configuration may require - this also eases the integration of the submodule into one's **NixOS** environment as part of the system's configuration, which is vital for including things that would otherwise be lost in the Nix Store - this applies to things like grub themes for instance - see the inclusion of my own grub theme in this repo as an example that was relatively easy to write up (thanks to darkmatter-grub-theme existing with a flake [here](https://gitlab.com/VandalByte/darkmatter-grub-theme/-/blob/main/flake.nix))

### Converting Current Submodules to NixOS Flakes 

At the time of writing and when this process began, two submodules were included as vital parts of this repository: 
  1. My AwesomeWM configuration 
  2. My ZSH configuration 
The latter is not as imperative of a submodule and may be replaced entirely with a declarative configuration. 