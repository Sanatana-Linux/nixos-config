# Submodule Sync Rule

## Core Principle

**Always update submodules to track `origin/main` or `origin/master` and pull their latest changes before any `git push`, `git commit` that includes submodule changes, or other git operations that might depend on submodule state.**

## Required Workflow

Before performing git operations in this project:

1. **Detect default branch for each submodule** in `external/`:
   ```bash
   git -C external/<submodule> symbolic-ref refs/remotes/origin/HEAD 2>/dev/null | sed 's@^refs/remotes/origin/@@' || echo main
   ```

2. **Fetch and update each submodule to track origin's default branch**:
   ```bash
   git -C external/<submodule> fetch origin
   git -C external/<submodule> checkout -B main origin/main 2>/dev/null || git -C external/<submodule> checkout -B master origin/master 2>/dev/null
   ```

   Or more concisely:
   ```bash
   git submodule foreach 'git fetch origin && git checkout $(git symbolic-ref -q refs/remotes/origin/HEAD | sed "s@.*/@@") && git pull origin $(git symbolic-ref -q refs/remotes/origin/HEAD | sed "s@.*/@@")'
   ```

3. **Update submodule pointers in the superproject**:
   ```bash
   git add external/
   ```

4. **Only then proceed with `git commit` and `git push`**

## When to Apply

Apply this rule for:
- Any `git push` operation
- `git commit` when `git status` shows modified submodules (`M` or `m`)
- Creating or updating PRs
- Operations that would publish local state

## Notes

- Submodules in `external/` are managed in their own repos; they must stay in sync with their origins
- The `m` flag indicates modified content in submodules (normal after history rewrites, but we still want them tracking latest)
- Never modify files inside submodules directly unless explicitly instructed by the user
- Use `git submodule update --remote --merge` as an alternative when appropriate, but prefer checking out the default branch directly to avoid detached HEAD
