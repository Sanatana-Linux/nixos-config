---
title: "ZSH Keybindings"
type: reference
tags: [zsh, keybindings, shell, vi-mode]
created: 2026-07-15
updated: 2026-07-15
sources: [.documentation/zsh-keybindings.md]
status: active
---

# ZSH Keybindings

Custom keybindings defined in `modules/home-manager/shell/zsh/default.nix`.

## Line Navigation

| Binding   | Action                    |
|-----------|---------------------------|
| `Ctrl+A`  | Beginning of line         |
| `Ctrl+E`  | End of line               |
| `Home`    | Beginning of line         |
| `End`     | End of line               |

## Word Navigation

| Binding      | Action       |
|--------------|--------------|
| `Ctrl+Right` | Forward word |
| `Ctrl+Left`  | Backward word|

## Word Deletion

| Binding          | Action           |
|------------------|------------------|
| `Ctrl+Backspace` | Delete word back |

## History Search

| Binding | Action                                      |
|---------|---------------------------------------------|
| `Up`    | Search backward through history for match   |
| `Down`  | Search forward through history for match    |

## Completion Menu Navigation (Vi-style)

When the tab completion menu is open:

| Key | Action     |
|-----|------------|
| `h` | Move left  |
| `j` | Move down  |
| `k` | Move up    |
| `l` | Move right |

## Vi Mode

The shell uses vi insert mode (`viins`) as the default keymap. Press `Esc` to enter command mode (`vicmd`). All navigation keybindings work in both insert and command modes.

## Terminal Compatibility

Home/End keybindings cover multiple escape sequences: xterm (standard), alternative, Kitty/terminfo, and application mode — ensuring broad terminal compatibility.
