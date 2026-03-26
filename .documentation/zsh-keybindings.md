# ZSH Keybindings

This document describes all custom keybindings enabled in the ZSH configuration.

## Line Navigation

| Keybinding | Action | Description |
|------------|--------|-------------|
| `Ctrl+A` | `vi-beginning-of-line` | Jump to beginning of line |
| `Ctrl+E` | `vi-end-of-line` | Jump to end of line |
| `Home` | `beginning-of-line` | Jump to beginning of line |
| `End` | `end-of-line` | Jump to end of line |

## Word Navigation

| Keybinding | Action | Description |
|------------|--------|-------------|
| `Ctrl+Right` | `forward-word` | Move forward one word |
| `Ctrl+Left` | `backward-word` | Move backward one word |

## Word Deletion

| Keybinding | Action | Description |
|------------|--------|-------------|
| `Ctrl+Backspace` | `backward-kill-word` | Delete word before cursor |

## History Search

| Keybinding | Action | Description |
|------------|--------|-------------|
| `Up` | History substring search | Search backward through history for matches |
| `Down` | History substring search | Search forward through history for matches |

## Completion Menu Navigation

When the tab completion menu is open, use vim-style navigation:

| Keybinding | Action | Description |
|------------|--------|-------------|
| `h` | `vi-backward-char` | Move left in completion menu |
| `j` | `vi-down-line-or-history` | Move down in completion menu |
| `k` | `vi-up-line-or-history` | Move up in completion menu |
| `l` | `vi-forward-char` | Move right in completion menu |

## Vi Mode

The shell uses vi insert mode (`viins`) as the default keymap. This provides:
- Standard vi insert mode behavior for typing
- Press `Esc` to enter command mode (`vicmd`)
- All navigation keybindings work in both insert and command modes

## Terminal Compatibility

The Home/End keybindings cover multiple terminal escape sequences for broad compatibility:
- Standard xterm sequences (`^[[H`, `^[[F`)
- Alternative sequences (`^[[1~`, `^[[4~`)
- Kitty/terminfo sequences (`^[[7~`, `^[[8~`)
- Application mode (`^[OH`, `^[OF`)

## Configuration Source

All keybindings are defined in `modules/home-manager/shell/zsh/default.nix`.
