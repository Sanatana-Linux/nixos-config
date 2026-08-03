# Kitty Keybindings Reference

> **kitty_mod** = `ctrl+shift` (default, unchanged)
>
> Generated from `modules/home-manager/programs/kitty.nix` + upstream defaults.
> Configured overrides are marked with ⚙️. Unchanged defaults are unmarked.

---

## Window Management

| Shortcut | Action | Notes |
|----------|--------|-------|
| `kitty_mod+enter` | `new_window` | |
| `kitty_mod+n` | `new_os_window` | New OS-level window |
| `kitty_mod+w` | `close_window` | |
| `kitty_mod+]` | `next_window` | |
| `kitty_mod+[` | `previous_window` | |
| `kitty_mod+f` | `move_window_forward` | |
| `kitty_mod+b` | `move_window_backward` | |
| `kitty_mod+`` | `move_window_to_top` | |
| `kitty_mod+r` | `start_resizing_window` | Interactive resize mode |
| `kitty_mod+1` … `kitty_mod+0` | `first_window` … `tenth_window` | Switch to window by number |
| `kitty_mod+f7` | `focus_visible_window` | Overlay numbers on windows |
| `kitty_mod+f8` | `swap_with_window` | Visually swap with another window |
| ⚙️ `shift+alt+up` | `move_window up` | Move window up in layout |
| ⚙️ `shift+alt+left` | `move_window left` | Move window left in layout |
| ⚙️ `shift+alt+right` | `move_window right` | Move window right in layout |
| ⚙️ `shift+alt+down` | `move_window down` | Move window down in layout |
| ⚙️ `kitty_mod+left` | `neighboring_window left` | Focus window to the left |
| ⚙️ `kitty_mod+right` | `neighboring_window right` | Focus window to the right |
| ⚙️ `kitty_mod+up` | `neighboring_window up` | Focus window above |
| ⚙️ `kitty_mod+down` | `neighboring_window down` | Focus window below |
| ⚙️ `alt+shift+q` | `close_window` | Alternative close window |

---

## Tab Management

| Shortcut | Action | Notes |
|----------|--------|-------|
| `kitty_mod+t` | `new_tab` | |
| `kitty_mod+q` | `close_tab` | |
| `kitty_mod+right` | `next_tab` | |
| `kitty_mod+left` | `previous_tab` | |
| `kitty_mod+.` | `move_tab_forward` | |
| `kitty_mod+,` | `move_tab_backward` | |
| `kitty_mod+alt+t` | `set_tab_title` | |
| `ctrl+tab` | `next_tab` | |
| `ctrl+shift+tab` | `previous_tab` | |
| ⚙️ `alt+t` | `new_tab_with_cwd` | New tab in current working directory |
| ⚙️ `alt+n` | `next_tab` | Next tab |
| ⚙️ `alt+b` | `previous_tab` | Previous tab |
| ⚙️ `alt+q` | `close_tab` | Close current tab |
| ⚙️ `alt+.` | `move_tab_forward` | Move tab right |
| ⚙️ `alt+,` | `move_tab_backward` | Move tab left |
| ⚙️ `alt+1` | `goto_tab 1` | Go to tab 1 |
| ⚙️ `alt+2` | `goto_tab 2` | Go to tab 2 |
| ⚙️ `alt+3` | `goto_tab 3` | Go to tab 3 |
| ⚙️ `alt+4` | `goto_tab 4` | Go to tab 4 |
| ⚙️ `alt+5` | `goto_tab 5` | Go to tab 5 |
| ⚙️ `alt+6` | `goto_tab 6` | Go to tab 6 |
| ⚙️ `alt+7` | `goto_tab 7` | Go to tab 7 |
| ⚙️ `alt+8` | `goto_tab 8` | Go to tab 8 |
| ⚙️ `alt+9` | `goto_tab 9` | Go to tab 9 |

---

## Splits (Layout)

| Shortcut | Action | Notes |
|----------|--------|-------|
| ⚙️ `alt+/` | `launch --cwd=current --location=vsplit` | Vertical split in cwd |
| ⚙️ `alt+-` | `launch --cwd=current --location=hsplit` | Horizontal split in cwd |
| ⚙️ `shift+alt+/` | `launch --location vsplit` | Vertical split (extraConfig) |
| ⚙️ `shift+alt+-` | `launch --location hsplit` | Horizontal split (extraConfig) |
| `kitty_mod+l` | `next_layout` | Cycle through enabled layouts |

> Only the `splits` layout is enabled (`enabled_layouts splits`).

---

## Font Size

| Shortcut | Action | Notes |
|----------|--------|-------|
| `kitty_mod+equal` | `change_font_size all +2.0` | |
| `kitty_mod+plus` | `change_font_size all +2.0` | |
| `kitty_mod+minus` | `change_font_size all -2.0` | |
| `kitty_mod+backspace` | `change_font_size all 0` | Reset to default |
| ⚙️ `kitty_mod+equal` | `change_font_size all +1.0` | Override: +1.0 instead of +2.0 |
| ⚙️ `kitty_mod+minus` | `change_font_size all -1.0` | Override: -1.0 instead of -2.0 |
| ⚙️ `kitty_mod+0` | `change_font_size all 0` | Override: uses `0` instead of `backspace` |

---

## Clipboard

| Shortcut | Action | Notes |
|----------|--------|-------|
| `kitty_mod+c` | `copy_to_clipboard` | Copy selection to clipboard |
| `kitty_mod+v` | `paste_from_clipboard` | Paste from clipboard |
| `kitty_mod+s` | `paste_from_selection` | Paste from selection buffer |
| `kitty_mod+o` | `pass_selection_to_program` | Pass selection to external program |
| `shift+insert` | `paste_from_selection` | Alternative paste from selection |

---

## Scrolling

| Shortcut | Action | Notes |
|----------|--------|-------|
| `kitty_mod+k` | `scroll_line_up smooth` | Line up (kitty_mod+up is overridden) |
| `kitty_mod+j` | `scroll_line_down smooth` | Line down (kitty_mod+down is overridden) |
| `kitty_mod+page_up` | `scroll_page_up` | Page up |
| `kitty_mod+page_down` | `scroll_page_down` | Page down |
| `kitty_mod+home` | `scroll_home` | Scroll to top |
| `kitty_mod+end` | `scroll_end` | Scroll to bottom |
| `kitty_mod+z` | `scroll_to_prompt -1` | Scroll to previous shell prompt |
| `kitty_mod+x` | `scroll_to_prompt 1` | Scroll to next shell prompt |
| `kitty_mod+h` | `show_scrollback` | Browse scrollback in pager |
| `kitty_mod+g` | `show_last_command_output` | Browse last command output |
| `kitty_mod+/` | `search_scrollback` | Search scrollback in pager |

---

## Clear / Reset

| Shortcut | Action | Notes |
|----------|--------|-------|
| `kitty_mod+delete` | `clear_terminal reset active` | Full terminal reset |
| ⚙️ `alt+k` | `combine : clear_terminal scrollback active` | Clear screen + scrollback |

---

## Hints & URL Selection

| Shortcut | Action | Notes |
|----------|--------|-------|
| `kitty_mod+e` | `open_url_with_hints` | Open visible URL |
| `kitty_mod+p>f` | `kitten hints --type path --program -` | Insert selected path |
| `kitty_mod+p>shift+f` | `kitten hints --type path` | Open selected path |
| `kitty_mod+p>c` | `kitten choose-files` | Insert chosen file |
| `kitty_mod+p>d` | `kitten choose-files --mode=dir` | Insert chosen directory |
| `kitty_mod+p>l` | `kitten hints --type line --program -` | Insert selected line |
| `kitty_mod+p>w` | `kitten hints --type word --program -` | Insert selected word |
| `kitty_mod+p>h` | `kitten hints --type hash --program -` | Insert selected hash |
| `kitty_mod+p>n` | `kitten hints --type linenum` | Open file at line number |
| `kitty_mod+p>y` | `kitten hints --type hyperlink` | Open hyperlink |

---

## Miscellaneous

| Shortcut | Action | Notes |
|----------|--------|-------|
| `kitty_mod+f1` | `show_kitty_doc overview` | Show documentation |
| `kitty_mod+f3` | `command_palette` | Command palette |
| `kitty_mod+f11` | `toggle_fullscreen` | Toggle fullscreen |
| `kitty_mod+f10` | `toggle_maximized` | Toggle maximized |
| `kitty_mod+u` | `kitten unicode_input` | Unicode character input |
| `kitty_mod+f2` | `edit_config_file` | Edit kitty.conf |
| `kitty_mod+escape` | `kitty_shell window` | Open kitty command shell |
| `kitty_mod+a>m` | `set_background_opacity +0.1` | Increase opacity |
| `kitty_mod+a>l` | `set_background_opacity -0.1` | Decrease opacity |
| `kitty_mod+a>1` | `set_background_opacity 1` | Full opacity |
| `kitty_mod+a>d` | `set_background_opacity default` | Reset opacity |
| `kitty_mod+f5` | `load_config_file` | Reload kitty.conf |
| `kitty_mod+f6` | `debug_config` | Debug configuration |

---

## macOS-Only Defaults

| Shortcut | Action |
|----------|--------|
| `cmd+c` | `copy_or_noop` |
| `cmd+v` | `paste_from_clipboard` |
| `cmd+enter` | `new_window` |
| `cmd+n` | `new_os_window` |
| `cmd+t` | `new_tab` |
| `cmd+w` | `close_tab` |
| `cmd+0` | `change_font_size all 0` |
| `cmd+,` | `edit_config_file` |
| `cmd+h` | `hide_macos_app` |
| `cmd+m` | `minimize_macos_window` |
| `cmd+q` | `quit` |
| `cmd+`` | `macos_cycle_through_os_windows` |
| `cmd+k` | `clear_terminal to_cursor active` |
| `cmd+l` | `clear_terminal last_command active` |
| `cmd+f` | `search_scrollback` |
| `cmd+r` | `start_resizing_window` |
| `cmd+plus` | `change_font_size all +2.0` |
| `cmd+minus` | `change_font_size all -2.0` |
| `cmd+up` | `scroll_line_up smooth` |
| `cmd+down` | `scroll_line_down smooth` |
| `cmd+home` | `scroll_home` |
| `cmd+end` | `scroll_end` |
| `cmd+page_up` | `scroll_page_up` |
| `cmd+page_down` | `scroll_page_down` |
| `shift+cmd+d` | `close_window` |
| `shift+cmd+]` | `next_tab` |
| `shift+cmd+[` | `previous_tab` |
| `shift+cmd+w` | `close_os_window` |
| `shift+cmd+i` | `set_tab_title` |
| `shift+cmd+/` | `open_url https://sw.kovidgoyal.net/kitty/` |
| `ctrl+cmd+f` | `toggle_fullscreen` |
| `ctrl+cmd+,` | `load_config_file` |
| `ctrl+cmd+space` | `kitten unicode_input` |
| `opt+cmd+r` | `clear_terminal reset active` |
| `opt+cmd+,` | `debug_config` |
| `opt+cmd+s` | `toggle_macos_secure_keyboard_entry` |
| `opt+cmd+h` | `hide_macos_other_apps` |
| `option+cmd+k` | `clear_terminal scrollback active` |
| `cmd+ctrl+l` | `clear_terminal to_cursor_scroll active` |

---

## Legend

| Symbol | Meaning |
|--------|---------|
| ⚙️ | Configured override in `kitty.nix` (replaces or adds to default) |
| No marker | Default kitty binding, unchanged |
| `kitty_mod` | `ctrl+shift` |

> **Note:** `kitty_mod+up` and `kitty_mod+down` are overridden to `neighboring_window` actions.
> Use `kitty_mod+k` / `kitty_mod+j` for line scrolling instead.
>
> `kitty_mod+left` and `kitty_mod+right` are overridden to `neighboring_window` actions.
> Use `ctrl+tab` / `ctrl+shift+tab` for tab navigation, or the configured `alt+n` / `alt+b`.
