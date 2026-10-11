# Knowledge Graph — ShizNix

> Hybrid retrieval over this repo's context, rules, skills, and Nix sources: embedding recall → classifier gate → cross-encoder rerank → graph refine.

## Where It Lives

| Artifact | Path | Tracked? |
|----------|------|----------|
| Graph (nodes/edges) | `.opencode/state/vector/graph.db` | ✗ gitignored |
| Context vectors | `.opencode/state/vector/context.db` | ✗ gitignored |
| Code vectors | `.opencode/state/vector/code.db` | ✗ gitignored |
| Source corpus | `.opencode/context/` (44 files) | ✓ committed |
| Corpus of Nix | repo-wide `.nix` files (497 files) | ✓ committed |

The database is a derived cache. Nothing in it is authoritative — if it is lost,
rebuild it; never hand-edit it and never commit it.

## Current Shape

2,572 nodes / 14,339 edges, from 403 context chunks + 2,316 code chunks:

| Node type | Count | Node type | Count |
|-----------|------:|-----------|------:|
| symbol | 1,585 | reference | 152 |
| file | 497 | skill | 139 |
| module | 127 | agent | 31 |
| source-summary | 20 | concept | 10 |
| rule | 8 | decision / entity / synthesis | 1 each |

## Query It

Prefer graph recall over grepping — it ranks by meaning, not substring.

```jsonc
// graphQuery
{ "action": "query",  "query": "enable-by-option module pattern", "topK": 5 }
{ "action": "neighbors", "id": "rule:nix-module-patterns", "depth": 1 }
{ "action": "impact",  "id": "module:modules/nixos/base/packages/development.nix" }
{ "action": "path",   "id": "rule:nix-module-patterns", "to": "skill:nixos-module" }
{ "action": "stats" }
```

`rerank` scores documents directly against a query when you already have
candidates in hand and want them ordered.

## Rebuild After Corpus Changes

```bash
export OPCODE_DIR=/etc/nixos
G=/home/tlh/.config/opencode/skills/graph-context/scripts/graph.ts
V=/home/tlh/.config/opencode/skills/vectorize-context/scripts/vectorize.ts

node $V            # embeddings for context + code (index-time, may download)
node $G build      # fold context, rules, registry and code into the graph
```

Run `vectorize` **before** `graph build`. The code layer is derived from
`code.db`, so a build without a prior vectorize silently skips symbols.

Both steps are incremental — unchanged files are skipped by content hash.

## Why Embedding → Classifier → Reranker

Each stage exists because the one before it fails in a specific, observable way:

1. **Embedding** (`bge-small-en-v1.5`, 384-dim, CLS-pooled + L2-normalised)
   gives cheap cosine recall over the whole corpus. Cosine similarity is
   direction-only, so it happily ranks a file that shares vocabulary with the
   query above one that answers it.
2. **Classifier gate** (`mobilebert-uncased-mnli`) scores candidates as
   entailment against the query and drops the ones that merely look related.
3. **Reranker** (`bge-reranker-base`) is a cross-encoder: it reads the query and
   each document **together**, which is the only stage that can prefer a
   document for *answering* the query over a document that merely *resembles*
   it. Measured on this corpus it puts the correct rule at ~0.94 and unrelated
   documents at ~0.00004.
4. **Graph refine** expands from the surviving hits along `part_of`,
   `related_to`, `uses`, and `defines` edges, so a hit on a leaf rule also
   surfaces the skills and modules that depend on it.

Never reorder 3 before 2: reranking 200 candidates costs far more than the
gate saved, and gating after a rerank throws away the rerank's work.

## Rules

- **Rebuilding is explicit.** The graph is never refreshed as a side effect of
  editing `.nix` files; run the two commands above when the corpus changed
  materially.
- **A miss is a signal.** If `query` returns nothing useful, the corpus or the
  graph is stale — rebuild before concluding the knowledge does not exist.
- **Context stays manual.** Adding nodes by hand is out of scope; write the
  durable markdown under `.opencode/context/` and rebuild, so the graph stays
  derivable from the corpus.