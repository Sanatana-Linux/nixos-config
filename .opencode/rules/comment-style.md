# Comment Style Rule for Nix Files

## Core Principle

**Comments explain code as it exists, not as it changed.**

## What to Write

- **Purpose comments**: What does this code block do? Why is it here?
- **Behavior comments**: What does this config option control? What happens when enabled?
- **Rationale**: Why was a particular value chosen? What tradeoff does it represent?
- **Guidance**: What should an AI agent or future maintainer know when modifying this?

## What to Avoid

- **Change history**: Do not write "MOVED from X", "formerly Y", "extracted from Z"
- **Migration notes**: Do not write "was previously", "replaced by", "moved to"
- **Self-referential comments**: The code is the source of truth, not its history
- **TODO-as-documentation-deferral**: If a TODO says "add comments explaining these settings", perform the task rather than leaving the TODO

## Examples

### Good (explains as-is)
```nix
# Emoji font used system-wide by Stylix for all targets
emoji = {
  package = pkgs.noto-fonts-color-emoji;
  name = "Noto Color Emoji";
};
```

### Bad (explains changes)
```nix
# MOVED: multimedia.* → modules.system.multimedia.*
# Formerly in base.packages, extracted during 2026-06-21 refactor
```

## Enforcement

When writing or editing Nix files in this project:
1. If you encounter a TODO about missing comments, write the comments
2. If you see a comment describing what changed, rewrite it to describe what exists
3. If a comment repeats what the code obviously says, remove it
4. Version history belongs in `git log`, not in source code comments
