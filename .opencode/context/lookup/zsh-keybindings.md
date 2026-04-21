# ZSH Keybindings

Core concept: Custom ZSH keybindings using vi insert mode with enhanced navigation, word deletion, and history search.

Key Points:
- Vi insert mode default (`viins`), Esc for command mode (`vicmd`)
- `Ctrl+A/E` or `Home/End` — line beginning/end
- `Ctrl+Left/Right` — word navigation
- `Ctrl+Backspace` — backward kill word
- `Up/Down` — history substring search
- Completion menu: `h/j/k/l` for vim-style navigation
- Home/End keys cover xterm, kitty, and application mode sequences

Example:
```nix
bindkey -M viins "^A" vi-beginning-of-line
bindkey -M viins "^E" vi-end-of-line
```

Reference: [.documentation/zsh-keybindings.md](../../.documentation/zsh-keybindings.md)