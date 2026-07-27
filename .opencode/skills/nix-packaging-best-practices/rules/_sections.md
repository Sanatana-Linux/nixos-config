---
title: Rule Sections and Reading Order
impact: LOW
impactDescription: Guide for reading rules in logical order
tags: sections, reading-order, guide
---

# Rule Sections

This guide defines the reading order for all rules in this skill.

## Reading Order

Read rules in this order for comprehensive understanding:

### Foundation (Read First)

1. **[essential-pattern](essential-pattern.md)** - The core pattern for sourcing archives
   - Why source from original archives
   - Basic .deb package structure

2. **[dependencies](dependencies.md)** - The three dependency categories
   - nativeBuildInputs vs buildInputs vs propagatedBuildInputs
   - What goes where and why

### Core Skills

3. **[archive-formats](archive-formats.md)** - Different archive types
   - .deb, .rpm, .tar.gz, .zip extraction methods
   - Format-specific tools and commands

4. **[source-files](source-files.md)** - Local vs remote sources
   - Relative paths for local files
   - fetchurl for remote files

5. **[version-management](version-management.md)** - Using the version variable
   - Single source of truth
   - rec keyword

### Debugging

6. **[finding-libraries](finding-libraries.md)** - Finding missing dependencies
   - Using ldd to identify missing libraries
   - Common library mappings

7. **[quick-testing](quick-testing.md)** - Rapid testing with steam-run
   - Quick prototyping before packaging
   - steam-run for fast verification

8. **[troubleshooting-autoPatchelf](troubleshooting-autoPatchelf.md)** - Debugging dependency errors
   - Reading autoPatchelf error logs
   - Systematic dependency resolution

9. **[common-mistakes](common-mistakes.md)** - Pitfalls and how to avoid them
   - Pre-extracted directories
   - Absolute paths
   - Wrong dependency categories

### Advanced Topics

10. **[electron-apps](electron-apps.md)** - Packaging Electron applications
    - Extensive dependency lists
    - GPU sandbox flags
    - Desktop entries

11. **[build-phases](build-phases.md)** - Customizing the build process
    - The 7 standard phases
    - pre/post hooks
    - Skipping phases

12. **[wrapper-programs](wrapper-programs.md)** - Using wrapProgram
    - Setting environment variables
    - Adding default flags
    - makeWrapper usage

13. **[advanced-fhs-env](advanced-fhs-env.md)** - FHS environments for resistant binaries
    - buildFHSEnv for DRM-protected software
    - When autoPatchelfHook fails

## Quick Start

For your first binary package, read in this order:

1. essential-pattern
2. dependencies
3. finding-libraries

Then reference other rules as needed.

## By Impact Level

### CRITICAL Rules

- essential-pattern - Core principle
- dependencies - Correct dependency categories
- finding-libraries - Making binaries run

### HIGH Rules

- archive-formats - Format-specific extraction
- source-files - Portability
- common-mistakes - Avoiding pitfalls
- electron-apps - Popular use case
- troubleshooting-autoPatchelf - Debugging dependency errors

### MEDIUM Rules

- version-management - Maintainability
- build-phases - Customization
- wrapper-programs - Runtime customization
- quick-testing - Rapid prototyping

### LOW Rules

- advanced-fhs-env - Edge cases
- _sections - This file
