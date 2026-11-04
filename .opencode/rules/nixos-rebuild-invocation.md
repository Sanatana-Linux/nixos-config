# nixos-rebuild Invocation

> Never wrap `nixos-rebuild` in `sudo`. Let `nixos-rebuild` elevate only its activation step.

## Rule

`sudo nixos-rebuild …` is forbidden. Elevation goes on the `nixos-rebuild` command line as `--sudo`:

```bash
# BAD — never do this
sudo nixos-rebuild switch --flake .#bagalamukhi --impure

# GOOD
nixos-rebuild switch --flake .#bagalamukhi --impure --sudo
nixos-rebuild --sudo switch --flake .#bagalamukhi --impure   # equivalent, option may precede the verb
```

`--sudo` is an alias for `--elevate=sudo` in the pinned `nixos-rebuild-ng`. It prefixes only the
activation commands with sudo; evaluation, fetching and building stay in the invoking user's
environment.

## Which verbs need elevation

| Verb                                   | Elevation |
| -------------------------------------- | --------- |
| `build`, `dry-build`, `dry-activate`   | none      |
| `vm`, `iso`, `check`                   | none      |
| `switch`, `boot`, `test`, `rollback`   | `--sudo`  |

Do not add `--sudo` to verbs that never activate.

## Why

- `sudo nixos-rebuild` runs evaluation and the entire build as root: root's `nix.conf`, root's
  substituter keys, root's flake registry and SSH agent. None of that is the operator's environment,
  so the build can fail — or succeed differently — for reasons that do not exist for the user.
- It leaves root-owned GC roots and root-owned files in the flake directory. Those later surface as
  `detected dubious ownership` git errors and permission failures during normal user builds.
- It buries the real error behind a second privilege boundary. With `--sudo`, the failing evaluation
  is the same one you can reproduce as yourself.
- `nixos-rebuild-ng` supports non-root deploys explicitly through `--elevate`; an external `sudo`
  defeats the mechanism and re-introduces the problems above.

## Scope

This applies to every place a rebuild is written or executed: documentation, skills, context files,
host `AGENTS.md` files, shell snippets, and `.opencode/tools/nix-build.ts`. If an older snippet says
`sudo nixos-rebuild`, rewrite it — the rule wins over the snippet.
