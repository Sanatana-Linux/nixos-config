---
title: "Wiki Schema"
type: schema
tags: [wiki, schema, meta, maintenance]
created: 2026-07-15
updated: 2026-07-15
status: active
---

# Wiki Schema

## Directory Structure

Context lives in `.opencode/context/` and is organized by type:

```
.opencode/context/
├── index.md              # Wiki catalog (auto-maintained)
├── log.md                # Chronological operation record (append-only)
├── wiki-schema.md        # This file — describes the wiki structure
├── decisions.md          # Architecture Decision Records (ADRs)
├── *.md                  # Root-level concept/reference pages
├── frameworks/           # Entity/concept pages (architecture, design, conventions)
├── research/             # Raw sources + source summaries (consume, context7, web-research)
└── patterns/             # Pattern pages (discovered patterns, anti-patterns) — not yet populated
```

## YAML Frontmatter Convention

Every context file (except index.md and log.md) uses YAML frontmatter:

```yaml
---
title: "Page Title"
type: entity | concept | source-summary | decision | pattern | synthesis | reference | schema
tags: [tag1, tag2]
created: YYYY-MM-DD
updated: YYYY-MM-DD
sources: [source-slug-1, source-slug-2]    # optional — where the info came from
status: active | needs-review | stale
---
```

## Type Categories

| Type | Directory | Description |
|------|-----------|-------------|
| `concept` | `frameworks/` or root | Design patterns, architecture docs, guides |
| `entity` | `frameworks/` | Specific component descriptions |
| `source-summary` | `research/` | External doc/library summaries |
| `decision` | Root (`decisions.md`) | Architecture Decision Records |
| `pattern` | `patterns/` | Reusable patterns and anti-patterns |
| `synthesis` | Root or `frameworks/` | Cross-cutting synthesis docs |
| `reference` | `frameworks/` or root | Quick-reference pages |
| `schema` | Root | This file |

## Cross-Reference Syntax

Use `[[page-slug]]` wiki-link syntax. The slug is the filename without extension (e.g., `[[nixos-architecture]]` links to `frameworks/nixos-architecture.md`). Cross-references are maintained on every write.

## Compliance Procedures

After any write to `.opencode/context/`:

1. **Update index.md** — Scan all `.md` files, extract frontmatter, rebuild catalog by category
2. **Append to log.md** — Chronological entry with operation, files touched, cross-references added
3. **Add YAML frontmatter** to new files (best-effort for existing files missing it)
4. **Scan for cross-references** — Link new content to existing pages and vice versa

## Hard Constraints

- No vector embeddings — query uses index + keyword + tag matching only
- Raw sources in `research/` are immutable — read but never modified
- Wiki pages are committed (durable context) — values compound across sessions
- index.md and log.md are append-only / regenerated, never deleted
