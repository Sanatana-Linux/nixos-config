# Project Constraints

> 🚨 CRITICAL: These are hard rules for AI agents. Breaking them wastes user time and damages trust.

## 1. Submodules Are Separate OpenCode Projects

The `external/` directory contains git submodules. Each one is an independent OpenCode project:

| Submodule | Own Repo | Own `.opencode/` |
|-----------|----------|-----------------|
| `external/awesome/` | Awesome WM config repo | Yes — separate project |
| `external/nvim/` | Neovim config repo | Yes — separate project |
| `external/firefox/` | Firefox theme repo | Yes — separate project |
| `external/secrets/` | SOPS secrets repo | Yes — separate project |

**Rules:**
- DO NOT modify `external/` submodule files unless explicitly instructed
- DO NOT create/modify `.opencode/` configs inside submodules from the main repo
- DO NOT run provisioning tools across submodule boundaries
- The `m` in `git status` for submodules means "modified content" — this is NORMAL for rewritten history (filter-branch)

## 2. Validate Before Writing Config Files

Before writing or modifying any `.opencode/` configuration file:

1. **Check the real schema** — Only use keys you've seen in working configs
2. **Known valid keys** for OpenCode config: `$schema`, `model`, `default_agent`, `provider`, `permission`, `instructions`, `mcp`, `plugin`
3. **INVALID keys** that will crash the bun-embedded runtime: `agents`, `skills`, `tools`, `project`, `rules` (as top-level keys), `name`, `description`, `git`, `commands`, `plugins` (as empty array), `mcpServers`
4. **Test the config** — If possible, validate JSON parses cleanly
5. **Ask first** — If unsure about a key's validity, ASK before writing

## 3. Git History Operations

- `git filter-branch` rewrites ALL commit hashes — submodule pointers become dirty (`m` flag)
- Always warn the user before rewriting history
- Never assume filter-branch effects are harmless
- After filter-branch, submodule refs need `git submodule update` or manual fix

## 4. No Assumptions About What "Needs" to Be Created

- Do NOT provision agents, skills, tools, or rules unless explicitly requested
- Do NOT assume the project needs project-specific wrappers around global agents
- Do NOT create TypeScript tool files (they need `@opencode-ai/plugin` deps that bloat `.opencode/`)
- Do NOT register non-existent config keys
- If in doubt, ask the user instead of guessing

## 5. Submodule opencode.jsonc Pattern

Submodules use minimal configs with only: `$schema`, `model`, `default_agent`, `permission`, `instructions`.
They do NOT have `agents/`, `skills/`, `tools/` directories.
They do NOT have `package.json` + `node_modules/` for tool dependencies (except where pre-existing).

## 6. Revert First, Explain Later

If a change breaks the user's workflow:
1. Revert/remove the breaking change immediately
2. Then explain what happened and why
3. Don't argue — just fix it