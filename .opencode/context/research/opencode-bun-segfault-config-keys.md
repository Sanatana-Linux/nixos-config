# OpenCode Bun Embedded Runtime — Debug Notes

## The Problem

OpenCode crashes with a segmentation fault when loading certain `.opencode/opencode.jsonc` configs.

## Root Cause

The nixpkgs opencode binary (versions 1.14.23+, both 1.15.13 and 1.17.3) is a **two-stage ELF**:

1. `bin/opencode` — A 16KB ELF bootstrapper
2. `bin/.opencode-wrapped` — A 146-158MB ELF which contains an **embedded bun runtime**

The bun runtime parses `opencode.jsonc` at startup. Unknown/invalid config keys cause the embedded bun to hit unexpected code paths, resulting in a SEGFAULT.

## Config Keys Confirmed Safe

Tested and known to work (from global config `~/.config/opencode/opencode.jsonc`):
- `$schema`
- `model`
- `default_agent`
- `provider` (with `opencode` and `ollama` sub-objects)
- `permission.edit`
- `instructions`
- `mcp` (with `type`, `url`, `headers`)
- `plugin` (array of plugin paths/npm packages)

## Config Keys That Crash

**INVALID** — These are NOT OpenCode config keys and will crash the embedded bun:
- `agents`
- `skills`
- `tools`
- `project` (including sub-keys like `hosts`, `users`, `language`)
- `name`
- `description`
- `git`
- `commands`
- `plugins` (as empty array)
- `mcpServers`
- `rules.paths`
- `rules.alwaysApply`

## Node_modules Dependency Issue

If `.opencode/package.json` exists with `@opencode-ai/plugin` dependency, the embedded bun will try to resolve it. Version mismatch between the plugin SDK and the opencode binary can also trigger segfaults.

## Diagnosis

```bash
# Check which opencode version
which opencode
readlink -f $(which opencode)

# Check if it's the bun-wrapped version
ls -la /nix/store/*opencode*/bin/
# If both `opencode` (16KB) and `.opencode-wrapped` (150MB+) exist, it's bun-embedded

# Check active config for invalid keys
cat .opencode/opencode.jsonc

# Try minimal config
echo '{"$schema":"https://opencode.ai/config.json","default_agent":"hubs","permission":{"edit":{}}}' | python3 -m json.tool
```

## Prevention

- Only write config keys you've seen in working configs
- Never create `agents/`, `skills/`, `tools/` dirs with corresponding config keys
- Keep `.opencode/opencode.jsonc` minimal — use `instructions` to point to AGENTS.md instead
- Never add `package.json` + `node_modules/` to `.opencode/` unless the user explicitly asks for TypeScript tools