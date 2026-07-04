{
  config,
  lib,
  pkgs,
  ...
}:
with lib; {
  options.modules.programs.yazi.enable = mkEnableOption "Yazi file manager";

  config = mkIf config.modules.programs.yazi.enable {
    programs.yazi = {
      enable = true;
      shellWrapperName = "r";
      enableZshIntegration = true;
      enableBashIntegration = true;

      settings = {
        mgr = {
          layout = [2 4 3];
          sort_by = "alphabetical";
          sort_sensitive = true;
          sort_reverse = false;
          sort_dir_first = true;
          linemode = "mtime";
          show_hidden = true;
          show_symlink = true;
        };
        preview = {
          tab_size = 3;
          max_width = 640;
          max_height = 860;
          cache_dir = "";
        };
        opener = {
          folder = [
            {run = "thunar \"$@\""; desc = "Reveal in Thunar";}
            {run = ''$EDITOR "$@"'';}
          ];
          archive = [{run = "dtrx \"$1\""; desc = "Extract here";}];
          text = [{run = ''$EDITOR "$@"''; block = true;}];
          image = [
            {run = "feh \"$@\"";}
            {run = "imv \"$@\"";}
            {
              run = "exiftool \"$1\"; echo \"Press enter to exit\"; read";
              block = true;
              desc = "Show EXIF";
            }
          ];
          svg = [
            {run = "inkscape \"$@\"";}
            {run = "loupe \"$@\"";}
          ];
          video = [
            {run = "vlc \"$@\"";}
            {
              run = "mediainfo \"$1\"; echo \"Press enter to exit\"; read";
              block = true;
              desc = "Show media info";
            }
          ];
          audio = [
            {run = "vlc \"$@\"";}
            {
              run = "mediainfo \"$1\"; echo \"Press enter to exit\"; read";
              block = true;
              desc = "Show media info";
            }
          ];
        };
        open = {
          rules = [
            {mime = "inode/directory"; use = "folder";}
            {url = "*.svg"; use = "svg";}
            {mime = "text/*"; use = "text";}
            {mime = "image/*"; use = "image";}
            {mime = "video/*"; use = "video";}
            {mime = "audio/*"; use = "audio";}
            {mime = "inode/x-empty"; use = "text";}
            {mime = "application/json"; use = "text";}
            {mime = "*/javascript"; use = "text";}
            {mime = "application/zip"; use = "archive";}
            {mime = "application/gzip"; use = "archive";}
            {mime = "application/x-tar"; use = "archive";}
            {mime = "application/x-bzip"; use = "archive";}
            {mime = "application/x-bzip2"; use = "archive";}
            {mime = "application/x-7z-compressed"; use = "archive";}
            {mime = "application/x-rar"; use = "archive";}
            {mime = "*"; use = "fallback";}
          ];
        };
        tasks = {
          micro_workers = 5;
          macro_workers = 10;
          bizarre_retry = 5;
        };
        plugin = {
          previewers = [
            {url = "*.md"; run = "glow";}
            {url = "*.zip"; run = "ouch";}
            {url = "*.7z"; run = "ouch";}
            {url = "*.rar"; run = "ouch";}
            {url = "*.tar"; run = "ouch";}
            {url = "*.tar.gz"; run = "ouch";}
            {url = "*.tar.xz"; run = "ouch";}
            {url = "*.tar.bz2"; run = "ouch";}
            {url = "*.tar.zst"; run = "ouch";}
          ];
          prepend_fetchers = [
            {id = "git"; url = "*"; run = "git"; group = "git";}
            {id = "git"; url = "*/"; run = "git"; group = "git";}
          ];
        };
        log = {
          enabled = false;
        };
      };

      keymap = {
        mgr = {
          prepend_keymap = [
            {on = "l"; run = "plugin smart-enter"; desc = "Enter directory or open file";}
            {on = "p"; run = "plugin smart-paste"; desc = "Paste into hovered directory or CWD";}
            {on = "m"; run = "plugin bookmarks save"; desc = "Save current position as a bookmark";}
            {on = "'"; run = "plugin bookmarks jump"; desc = "Jump to a bookmark";}
            {on = "`"; run = "plugin bookmarks jump"; desc = "Jump to a bookmark";}
            {on = ["b" "d"]; run = "plugin bookmarks delete"; desc = "Delete a bookmark";}
            {on = ["b" "D"]; run = "plugin bookmarks delete_all"; desc = "Delete all bookmarks";}
            {on = ["c" "m"]; run = "plugin chmod"; desc = "Chmod on selected files";}
            {on = ["c" "a" "a"]; run = "plugin compress"; desc = "Archive selected files";}
            {on = ["c" "a" "p"]; run = "plugin compress -p"; desc = "Archive with password";}
            {on = ["c" "a" "h"]; run = "plugin compress -ph"; desc = "Archive with password + header encryption";}
            {on = ["c" "a" "l"]; run = "plugin compress -l"; desc = "Archive with compression level";}
            {on = ["c" "a" "u"]; run = "plugin compress -phl"; desc = "Archive with password + header + level";}
            {on = "C"; run = "plugin ouch"; desc = "Compress with ouch";}
            {on = "M"; run = "plugin mount"; desc = "Mount manager";}
            {on = ["g" "v" "m"]; run = "plugin gvfs -- select-then-mount --jump"; desc = "Mount GVFS device and jump to it";}
            {on = ["g" "v" "u"]; run = "plugin gvfs -- select-then-unmount --eject"; desc = "Unmount/eject GVFS device";}
            {on = ["g" "v" "a"]; run = "plugin gvfs -- add-mount"; desc = "Add a GVFS mount URI";}
            {on = ["g" "v" "j"]; run = "plugin gvfs -- jump-to-device"; desc = "Jump to a mounted GVFS device";}
            {on = ["g" "i"]; run = "plugin gitui"; desc = "Open gitui";}
            {on = ["R" "b"]; run = "plugin recycle-bin"; desc = "Open Recycle Bin menu";}
            {on = ["R" "o"]; run = "plugin recycle-bin -- open"; desc = "Open Trash directory";}
            {on = ["R" "r"]; run = "plugin recycle-bin -- restore"; desc = "Restore from Trash";}
            {on = ["R" "d"]; run = "plugin recycle-bin -- delete"; desc = "Delete from Trash";}
            {on = ["R" "e"]; run = "plugin recycle-bin -- empty"; desc = "Empty Trash";}
            {on = ["R" "D"]; run = "plugin recycle-bin -- emptyDays"; desc = "Empty Trash by days";}
            {on = "U"; run = "plugin restore"; desc = "Restore last deleted files/folders";}
            {on = ["<A-d>" "i"]; run = "plugin dupes interactive"; desc = "Find duplicates (interactive)";}
            {on = ["<A-d>" "o"]; run = "plugin dupes override"; desc = "Find duplicates (custom jdupes args)";}
            {on = ["<A-d>" "d"]; run = "plugin dupes dry"; desc = "Find duplicates (dry run)";}
            {on = ["<A-d>" "a"]; run = "plugin dupes apply"; desc = "Find and delete duplicates";}
            {on = ["[" "d"]; run = "plugin nav-parent-panel prev"; desc = "Previous sibling directory";}
            {on = ["]" "d"]; run = "plugin nav-parent-panel next"; desc = "Next sibling directory";}
            {on = ["<A-s>" "p"]; run = "plugin sudo -- paste"; desc = "Sudo paste";}
            {on = ["<A-s>" "P"]; run = "plugin sudo -- paste --force"; desc = "Sudo force paste";}
            {on = ["<A-s>" "r"]; run = "plugin sudo -- rename"; desc = "Sudo rename";}
            {on = ["<A-s>" "d"]; run = "plugin sudo -- remove"; desc = "Sudo trash";}
            {on = ["<A-s>" "D"]; run = "plugin sudo -- remove --permanently"; desc = "Sudo permanent delete";}
            {on = ["<A-s>" "a"]; run = "plugin sudo -- create"; desc = "Sudo create file/directory";}
            {on = ["<A-s>" "l"]; run = "plugin sudo -- link"; desc = "Sudo symlink (absolute)";}
            {on = ["<A-s>" "L"]; run = "plugin sudo -- hardlink"; desc = "Sudo hardlink";}
            {on = ["<A-s>" "m"]; run = "plugin sudo -- chmod"; desc = "Sudo chmod";}
          ];
          keymap = [
            {on = "<Esc>"; run = "escape"; desc = "Exit visual mode, clear selection, or cancel search";}
            {on = "<C-[>"; run = "escape"; desc = "Exit visual mode, clear selection, or cancel search";}
            {on = "q"; run = "quit"; desc = "Quit the process";}
            {on = "Q"; run = "quit --no-cwd-file"; desc = "Quit without outputting cwd-file";}
            {on = "<C-c>"; run = "close"; desc = "Close the current tab, or quit if last";}
            {on = "<C-z>"; run = "suspend"; desc = "Suspend the process";}
            {on = "k"; run = "arrow prev"; desc = "Previous file";}
            {on = "j"; run = "arrow next"; desc = "Next file";}
            {on = "<Up>"; run = "arrow prev"; desc = "Previous file";}
            {on = "<Down>"; run = "arrow next"; desc = "Next file";}
            {on = "<C-u>"; run = "arrow -50%"; desc = "Move cursor up half page";}
            {on = "<C-d>"; run = "arrow 50%"; desc = "Move cursor down half page";}
            {on = "<C-b>"; run = "arrow -100%"; desc = "Move cursor up one page";}
            {on = "<C-f>"; run = "arrow 100%"; desc = "Move cursor down one page";}
            {on = "<S-PageUp>"; run = "arrow -50%"; desc = "Move cursor up half page";}
            {on = "<S-PageDown>"; run = "arrow 50%"; desc = "Move cursor down half page";}
            {on = "<PageUp>"; run = "arrow -100%"; desc = "Move cursor up one page";}
            {on = "<PageDown>"; run = "arrow 100%"; desc = "Move cursor down one page";}
            {on = ["g" "g"]; run = "arrow top"; desc = "Go to top";}
            {on = "G"; run = "arrow bot"; desc = "Go to bottom";}
            {on = "h"; run = "leave"; desc = "Back to the parent directory";}
            {on = "<Left>"; run = "leave"; desc = "Back to the parent directory";}
            {on = "<Right>"; run = "enter"; desc = "Enter the child directory";}
            {on = "H"; run = "back"; desc = "Back to previous directory";}
            {on = "L"; run = "forward"; desc = "Forward to next directory";}
            {on = "<Space>"; run = ["toggle" "arrow 1"]; desc = "Toggle the current selection state";}
            {on = "<C-a>"; run = "toggle_all --state=on"; desc = "Select all files";}
            {on = "<C-r>"; run = "toggle_all"; desc = "Invert selection of all files";}
            {on = "v"; run = "visual_mode"; desc = "Enter visual mode (selection mode)";}
            {on = "V"; run = "visual_mode --unset"; desc = "Enter visual mode (unset mode)";}
            {on = "K"; run = "seek -5"; desc = "Seek up 5 units in the preview";}
            {on = "J"; run = "seek 5"; desc = "Seek down 5 units in the preview";}
            {on = "<Tab>"; run = "spot"; desc = "Spot hovered file";}
            {on = "o"; run = "open"; desc = "Open selected files";}
            {on = "O"; run = "open --interactive"; desc = "Open selected files interactively";}
            {on = "<Enter>"; run = "open"; desc = "Open selected files";}
            {on = "<S-Enter>"; run = "open --interactive"; desc = "Open selected files interactively";}
            {on = "y"; run = "yank"; desc = "Yank selected files (copy)";}
            {on = "x"; run = "yank --cut"; desc = "Yank selected files (cut)";}
            {on = "Y"; run = "unyank"; desc = "Cancel the yank status";}
            {on = "X"; run = "unyank"; desc = "Cancel the yank status";}
            {on = "P"; run = "paste --force"; desc = "Paste yanked files (overwrite if exists)";}
            {on = "-"; run = "link"; desc = "Symlink the absolute path of yanked files";}
            {on = "_"; run = "link --relative"; desc = "Symlink the relative path of yanked files";}
            {on = "<C-->"; run = "hardlink"; desc = "Hardlink yanked files";}
            {on = "d"; run = "remove"; desc = "Trash selected files";}
            {on = "D"; run = "remove --permanently"; desc = "Permanently delete selected files";}
            {on = "a"; run = "create"; desc = "Create a file (ends with / for directories)";}
            {on = "A"; run = "bulk_create"; desc = "Bulk create files";}
            {on = "r"; run = "rename --cursor=before_ext"; desc = "Rename selected file(s)";}
            {on = ";"; run = "shell --interactive"; desc = "Run a shell command";}
            {on = ":"; run = "shell --block --interactive"; desc = "Run a shell command (block until finishes)";}
            {on = "."; run = "hidden toggle"; desc = "Toggle the visibility of hidden files";}
            {on = "s"; run = "search --via=fd"; desc = "Search files by name via fd";}
            {on = "S"; run = "search --via=rg"; desc = "Search files by content via ripgrep";}
            {on = "<C-s>"; run = "escape --search"; desc = "Cancel the ongoing search";}
            {on = "z"; run = "plugin fd-fzf"; desc = "Jump to a directory via fd+fzf";}
            {on = "Z"; run = "plugin fuzzy-search zoxide"; desc = "Jump to a directory via zoxide";}
            {on = ["m" "s"]; run = "linemode size"; desc = "Linemode: size";}
            {on = ["m" "p"]; run = "linemode permissions"; desc = "Linemode: permissions";}
            {on = ["m" "b"]; run = "linemode btime"; desc = "Linemode: btime";}
            {on = ["m" "m"]; run = "linemode mtime"; desc = "Linemode: mtime";}
            {on = ["m" "o"]; run = "linemode owner"; desc = "Linemode: owner";}
            {on = ["m" "n"]; run = "linemode none"; desc = "Linemode: none";}
            {on = ["c" "c"]; run = "copy path"; desc = "Copy file URL";}
            {on = ["c" "d"]; run = "copy dirname"; desc = "Copy directory URL";}
            {on = ["c" "f"]; run = "copy filename"; desc = "Copy filename";}
            {on = ["c" "n"]; run = "copy name_without_ext"; desc = "Copy filename without extension";}
            {on = "f"; run = "filter --smart"; desc = "Filter files";}
            {on = "/"; run = "find --smart"; desc = "Find next file";}
            {on = "?"; run = "find --previous --smart"; desc = "Find previous file";}
            {on = "n"; run = "find_arrow"; desc = "Next found";}
            {on = "N"; run = "find_arrow --previous"; desc = "Previous found";}
            {on = ["," "m"]; run = ["sort mtime --reverse=no" "linemode mtime"]; desc = "Sort by modified time";}
            {on = ["," "M"]; run = ["sort mtime --reverse=yes" "linemode mtime"]; desc = "Sort by modified time (reverse)";}
            {on = ["," "b"]; run = ["sort btime --reverse=no" "linemode btime"]; desc = "Sort by birth time";}
            {on = ["," "B"]; run = ["sort btime --reverse=yes" "linemode btime"]; desc = "Sort by birth time (reverse)";}
            {on = ["," "e"]; run = "sort extension --reverse=no"; desc = "Sort by extension";}
            {on = ["," "E"]; run = "sort extension --reverse=yes"; desc = "Sort by extension (reverse)";}
            {on = ["," "a"]; run = "sort alphabetical --reverse=no"; desc = "Sort alphabetically";}
            {on = ["," "A"]; run = "sort alphabetical --reverse=yes"; desc = "Sort alphabetically (reverse)";}
            {on = ["," "n"]; run = "sort natural --reverse=no"; desc = "Sort naturally";}
            {on = ["," "N"]; run = "sort natural --reverse=yes"; desc = "Sort naturally (reverse)";}
            {on = ["," "s"]; run = ["sort size --reverse=no" "linemode size"]; desc = "Sort by size";}
            {on = ["," "S"]; run = ["sort size --reverse=yes" "linemode size"]; desc = "Sort by size (reverse)";}
            {on = ["," "r"]; run = "sort random --reverse=no"; desc = "Sort randomly";}
            {on = ["g" "h"]; run = "cd ~"; desc = "Go home";}
            {on = ["g" "c"]; run = "cd ~/.config"; desc = "Go ~/.config";}
            {on = ["g" "d"]; run = "cd ~/Downloads"; desc = "Go ~/Downloads";}
            {on = ["g" "n"]; run = "cd /etc/nixos"; desc = "Go to NixOS configuration";}
            {on = ["g" "t"]; run = "cd /tmp"; desc = "Go to /tmp";}
            {on = ["g" "<Space>"]; run = "cd --interactive"; desc = "Jump interactively";}
            {on = ["g" "f"]; run = "follow"; desc = "Follow hovered symlink";}
            {on = ["t" "t"]; run = "tab_create --current"; desc = "Create a new tab in CWD";}
            {on = ["t" "r"]; run = "tab_rename --interactive"; desc = "Rename current tab";}
            {on = "1"; run = "tab_switch 0"; desc = "Switch to first tab";}
            {on = "2"; run = "tab_switch 1"; desc = "Switch to second tab";}
            {on = "3"; run = "tab_switch 2"; desc = "Switch to third tab";}
            {on = "4"; run = "tab_switch 3"; desc = "Switch to fourth tab";}
            {on = "5"; run = "tab_switch 4"; desc = "Switch to fifth tab";}
            {on = "6"; run = "tab_switch 5"; desc = "Switch to sixth tab";}
            {on = "7"; run = "tab_switch 6"; desc = "Switch to seventh tab";}
            {on = "8"; run = "tab_switch 7"; desc = "Switch to eighth tab";}
            {on = "9"; run = "tab_switch 8"; desc = "Switch to ninth tab";}
            {on = "["; run = "tab_switch -1 --relative"; desc = "Switch to previous tab";}
            {on = "]"; run = "tab_switch 1 --relative"; desc = "Switch to next tab";}
            {on = "{"; run = "tab_swap -1"; desc = "Swap current tab with previous tab";}
            {on = "}"; run = "tab_swap 1"; desc = "Swap current tab with next tab";}
            {on = "w"; run = "tasks:show"; desc = "Show task manager";}
            {on = "~"; run = "help"; desc = "Open help";}
            {on = "<F1>"; run = "help"; desc = "Open help";}
          ];
        };
        tasks = {
          keymap = [
            {on = "<Esc>"; run = "close"; desc = "Close task manager";}
            {on = "<C-[>"; run = "close"; desc = "Close task manager";}
            {on = "<C-c>"; run = "close"; desc = "Close task manager";}
            {on = "w"; run = "close"; desc = "Close task manager";}
            {on = "k"; run = "arrow prev"; desc = "Previous task";}
            {on = "j"; run = "arrow next"; desc = "Next task";}
            {on = "<Up>"; run = "arrow prev"; desc = "Previous task";}
            {on = "<Down>"; run = "arrow next"; desc = "Next task";}
            {on = "<Enter>"; run = "inspect"; desc = "Inspect the task";}
            {on = "x"; run = "cancel"; desc = "Cancel the task";}
            {on = "~"; run = "help"; desc = "Open help";}
            {on = "<F1>"; run = "help"; desc = "Open help";}
          ];
        };
        spot = {
          keymap = [
            {on = "<Esc>"; run = "close"; desc = "Close the spot";}
            {on = "<C-[>"; run = "close"; desc = "Close the spot";}
            {on = "<C-c>"; run = "close"; desc = "Close the spot";}
            {on = "<Tab>"; run = "close"; desc = "Close the spot";}
            {on = "k"; run = "arrow prev"; desc = "Previous line";}
            {on = "j"; run = "arrow next"; desc = "Next line";}
            {on = "h"; run = "swipe prev"; desc = "Swipe to previous file";}
            {on = "l"; run = "swipe next"; desc = "Swipe to next file";}
            {on = "<Up>"; run = "arrow prev"; desc = "Previous line";}
            {on = "<Down>"; run = "arrow next"; desc = "Next line";}
            {on = "<Left>"; run = "swipe prev"; desc = "Swipe to previous file";}
            {on = "<Right>"; run = "swipe next"; desc = "Swipe to next file";}
            {on = ["c" "c"]; run = "copy cell"; desc = "Copy selected cell";}
            {on = "~"; run = "help"; desc = "Open help";}
            {on = "<F1>"; run = "help"; desc = "Open help";}
          ];
        };
        pick = {
          keymap = [
            {on = "<Esc>"; run = "close"; desc = "Cancel pick";}
            {on = "<C-[>"; run = "close"; desc = "Cancel pick";}
            {on = "<C-c>"; run = "close"; desc = "Cancel pick";}
            {on = "<Enter>"; run = "close --submit"; desc = "Submit the pick";}
            {on = "k"; run = "arrow prev"; desc = "Previous option";}
            {on = "j"; run = "arrow next"; desc = "Next option";}
            {on = "<Up>"; run = "arrow prev"; desc = "Previous option";}
            {on = "<Down>"; run = "arrow next"; desc = "Next option";}
            {on = "~"; run = "help"; desc = "Open help";}
            {on = "<F1>"; run = "help"; desc = "Open help";}
          ];
        };
        input = {
          keymap = [
            {on = "<C-c>"; run = "close"; desc = "Cancel input";}
            {on = "<Enter>"; run = "close --submit"; desc = "Submit input";}
            {on = "<Esc>"; run = "escape"; desc = "Back to normal mode, or cancel input";}
            {on = "<C-[>"; run = "escape"; desc = "Back to normal mode, or cancel input";}
            {on = "i"; run = "insert"; desc = "Enter insert mode";}
            {on = "I"; run = ["move first-char" "insert"]; desc = "Move to BOL, and enter insert mode";}
            {on = "a"; run = "insert --append"; desc = "Enter append mode";}
            {on = "A"; run = ["move eol" "insert --append"]; desc = "Move to EOL, and enter append mode";}
            {on = "v"; run = "visual"; desc = "Enter visual mode";}
            {on = "r"; run = "replace"; desc = "Replace a single character";}
            {on = "V"; run = ["move bol" "visual" "move eol"]; desc = "Select from BOL to EOL";}
            {on = "<C-A>"; run = ["move eol" "visual" "move bol"]; desc = "Select from EOL to BOL";}
            {on = "<C-E>"; run = ["move bol" "visual" "move eol"]; desc = "Select from BOL to EOL";}
            {on = "h"; run = "move -1"; desc = "Move back a character";}
            {on = "l"; run = "move 1"; desc = "Move forward a character";}
            {on = "<Left>"; run = "move -1"; desc = "Move back a character";}
            {on = "<Right>"; run = "move 1"; desc = "Move forward a character";}
            {on = "<C-b>"; run = "move -1"; desc = "Move back a character";}
            {on = "<C-f>"; run = "move 1"; desc = "Move forward a character";}
            {on = "b"; run = "backward"; desc = "Move back to start of current/previous word";}
            {on = "B"; run = "backward wide"; desc = "Move back to start of current/previous WORD";}
            {on = "w"; run = "forward"; desc = "Move forward to start of next word";}
            {on = "W"; run = "forward wide"; desc = "Move forward to start of next WORD";}
            {on = "e"; run = "forward --end-of-word"; desc = "Move forward to end of current/next word";}
            {on = "E"; run = "forward wide --end-of-word"; desc = "Move forward to end of current/next WORD";}
            {on = "<A-b>"; run = "backward lean"; desc = "Move back to start of current/previous word";}
            {on = "<A-f>"; run = "forward lean --end-of-word"; desc = "Move forward to end of current/next word";}
            {on = "<C-Left>"; run = "backward lean"; desc = "Move back to start of current/previous word";}
            {on = "<C-Right>"; run = "forward lean --end-of-word"; desc = "Move forward to end of current/next word";}
            {on = "0"; run = "move bol"; desc = "Move to the BOL";}
            {on = "$"; run = "move eol"; desc = "Move to the EOL";}
            {on = "_"; run = "move first-char"; desc = "Move to first non-whitespace character";}
            {on = "^"; run = "move first-char"; desc = "Move to first non-whitespace character";}
            {on = "<C-a>"; run = "move bol"; desc = "Move to the BOL";}
            {on = "<C-e>"; run = "move eol"; desc = "Move to the EOL";}
            {on = "<Home>"; run = "move bol"; desc = "Move to the BOL";}
            {on = "<End>"; run = "move eol"; desc = "Move to the EOL";}
            {on = "<Backspace>"; run = "backspace"; desc = "Delete character before cursor";}
            {on = "<Delete>"; run = "backspace --under"; desc = "Delete character under cursor";}
            {on = "<C-h>"; run = "backspace"; desc = "Delete character before cursor";}
            {on = "<C-d>"; run = "backspace --under"; desc = "Delete character under cursor";}
            {on = "<C-u>"; run = "kill bol"; desc = "Kill backwards to BOL";}
            {on = "<C-k>"; run = "kill eol"; desc = "Kill forwards to EOL";}
            {on = "<C-w>"; run = "kill backward"; desc = "Kill backwards to start of current word";}
            {on = "<A-d>"; run = "kill forward"; desc = "Kill forwards to end of current word";}
            {on = "<C-Backspace>"; run = "kill backward"; desc = "Kill backwards to start of current word";}
            {on = "<C-Delete>"; run = "kill forward"; desc = "Kill forwards to end of current word";}
            {on = "d"; run = "delete --cut"; desc = "Cut selected characters";}
            {on = "D"; run = ["delete --cut" "move eol"]; desc = "Cut until EOL";}
            {on = "c"; run = "delete --cut --insert"; desc = "Cut and enter insert mode";}
            {on = "C"; run = ["delete --cut --insert" "move eol"]; desc = "Cut until EOL and enter insert mode";}
            {on = "s"; run = ["delete --cut --insert" "move 1"]; desc = "Cut current character and insert";}
            {on = "S"; run = ["move bol" "delete --cut --insert" "move eol"]; desc = "Cut from BOL to EOL and insert";}
            {on = "x"; run = ["delete --cut" "move 1 --in-operating"]; desc = "Cut current character";}
            {on = "y"; run = "yank"; desc = "Copy selected characters";}
            {on = "p"; run = "paste"; desc = "Paste after cursor";}
            {on = "P"; run = "paste --before"; desc = "Paste before cursor";}
            {on = "u"; run = ["undo" "casefy lower"]; desc = "Undo, or lowercase in visual mode";}
            {on = "U"; run = "casefy upper"; desc = "Uppercase";}
            {on = "<C-r>"; run = "redo"; desc = "Redo the last operation";}
            {on = "~"; run = "help"; desc = "Open help";}
            {on = "<F1>"; run = "help"; desc = "Open help";}
          ];
        };
        confirm = {
          keymap = [
            {on = "<Esc>"; run = "close"; desc = "Cancel the confirm";}
            {on = "<C-[>"; run = "close"; desc = "Cancel the confirm";}
            {on = "<C-c>"; run = "close"; desc = "Cancel the confirm";}
            {on = "<Enter>"; run = "close --submit"; desc = "Submit the confirm";}
            {on = "n"; run = "close"; desc = "Cancel the confirm";}
            {on = "y"; run = "close --submit"; desc = "Submit the confirm";}
            {on = "k"; run = "arrow prev"; desc = "Previous line";}
            {on = "j"; run = "arrow next"; desc = "Next line";}
            {on = "<Up>"; run = "arrow prev"; desc = "Previous line";}
            {on = "<Down>"; run = "arrow next"; desc = "Next line";}
            {on = "~"; run = "help"; desc = "Open help";}
            {on = "<F1>"; run = "help"; desc = "Open help";}
          ];
        };
        cmp = {
          keymap = [
            {on = "<C-c>"; run = "close"; desc = "Cancel completion";}
            {on = "<Tab>"; run = "close --submit"; desc = "Submit the completion";}
            {on = "<Enter>"; run = ["close --submit" "input:close --submit"]; desc = "Complete and submit the input";}
            {on = "<A-k>"; run = "arrow prev"; desc = "Previous item";}
            {on = "<A-j>"; run = "arrow next"; desc = "Next item";}
            {on = "<Up>"; run = "arrow prev"; desc = "Previous item";}
            {on = "<Down>"; run = "arrow next"; desc = "Next item";}
            {on = "<C-p>"; run = "arrow prev"; desc = "Previous item";}
            {on = "<C-n>"; run = "arrow next"; desc = "Next item";}
            {on = "~"; run = "help"; desc = "Open help";}
            {on = "<F1>"; run = "help"; desc = "Open help";}
          ];
        };
        help = {
          keymap = [
            {on = "<Esc>"; run = "escape"; desc = "Enter normal mode, or hide help menu";}
            {on = "<C-[>"; run = "escape"; desc = "Enter normal mode, or hide help menu";}
            {on = "<C-c>"; run = "close"; desc = "Close help menu";}
            {on = "<Enter>"; run = "close --submit"; desc = "Close help menu and run selected action(s)";}
            {on = "k"; run = "arrow prev"; desc = "Previous line";}
            {on = "j"; run = "arrow next"; desc = "Next line";}
            {on = "<Up>"; run = "arrow prev"; desc = "Previous line";}
            {on = "<Down>"; run = "arrow next"; desc = "Next line";}
            {on = "<C-p>"; run = "arrow prev"; desc = "Previous line";}
            {on = "<C-n>"; run = "arrow next"; desc = "Next line";}
          ];
        };
      };

      plugins = {
        # Plugins with settings/setup — submodule form
        git = {
          package = pkgs.yaziPlugins.git;
          settings = {
            show_branch = true;
          };
        };
        full-border = {
          package = pkgs.yaziPlugins.full-border;
          settings = {
            type = "ROUNDED";
          };
        };
        smart-enter = {
          package = pkgs.yaziPlugins.smart-enter;
          settings = {
            open_multi = true;
          };
        };
        bookmarks = {
          package = pkgs.yaziPlugins.bookmarks;
          settings = {
            persist = "all";
            desc_format = "full";
            file_pick_mode = "hover";
            notify = {
              enable = true;
              timeout = 2;
            };
          };
        };
        recycle-bin = {
          package = pkgs.yaziPlugins.recycle-bin;
          settings = {};
        };
        dupes = {
          package = pkgs.yaziPlugins.dupes;
          settings = {
            save_op = false;
            auto_confirm = false;
            profiles = {
              interactive = {args = ["-r"];};
              apply = {
                args = ["-r" "-N" "-d"];
                save_op = true;
              };
            };
          };
        };
        restore = {
          package = pkgs.yaziPlugins.restore;
          settings = {
            show_confirm = true;
            suppress_success_notification = true;
          };
        };
        gvfs = {
          package = pkgs.yaziPlugins.gvfs;
          settings = {};
        };
        yatline = {
          package = pkgs.yaziPlugins.yatline;
          settings = {
            section_separator = {open = ""; close = "";};
            part_separator = {open = ""; close = "";};
            inverse_separator = {open = ""; close = "";};
            style_a = {
              fg = "black";
              bg_mode = {
                normal = "white";
                select = "brightyellow";
                un_set = "brightred";
              };
            };
            style_b = {bg = "brightblack"; fg = "brightwhite";};
            style_c = {bg = "black"; fg = "brightwhite";};
            permissions_t_fg = "green";
            permissions_r_fg = "yellow";
            permissions_w_fg = "red";
            permissions_x_fg = "cyan";
            permissions_s_fg = "white";
            tab_width = 20;
            tab_use_inverse = false;
            selected = {icon = "󰻭"; fg = "yellow";};
            copied = {icon = "󰆐"; fg = "green";};
            cut = {icon = "󰆐"; fg = "red";};
            total = {icon = "󰮍"; fg = "yellow";};
            succ = {icon = "󰄬"; fg = "green";};
            fail = {icon = "󰄬"; fg = "red";};
            found = {icon = "󰮕"; fg = "blue";};
            processed = {icon = "󰐍"; fg = "green";};
            show_background = true;
            display_header_line = true;
            display_status_line = true;
            component_positions = ["header" "tab" "status"];
            header_line = {
              left = {
                section_a = [{type = "line"; custom = false; name = "tabs"; params = ["left"];}];
                section_b = {};
                section_c = {};
              };
              right = {
                section_a = {};
                section_b = {};
                section_c = {};
              };
            };
            status_line = {
              left = {
                section_a = [{type = "string"; custom = false; name = "tab_mode";}];
                section_b = [{type = "string"; custom = false; name = "hovered_size";}];
                section_c = [
                  {type = "string"; custom = false; name = "hovered_path";}
                  {type = "coloreds"; custom = false; name = "count";}
                ];
              };
              right = {
                section_a = [{type = "string"; custom = false; name = "cursor_position";}];
                section_b = [{type = "string"; custom = false; name = "cursor_percentage";}];
                section_c = [
                  {type = "string"; custom = false; name = "hovered_file_extension"; params = [true];}
                  {type = "coloreds"; custom = false; name = "permissions";}
                ];
              };
            };
          };
        };
        # Plugins without setup — package-only form
        chmod = pkgs.yaziPlugins.chmod;
        mount = pkgs.yaziPlugins.mount;
        ouch = pkgs.yaziPlugins.ouch;
        smart-paste = pkgs.yaziPlugins.smart-paste;
        sudo = pkgs.yaziPlugins.sudo;
        compress = pkgs.yaziPlugins.compress;
        gitui = pkgs.yaziPlugins.gitui;
        nav-parent-panel = pkgs.yaziPlugins.nav-parent-panel;
        # External plugins — not yet in nixpkgs yaziPlugins
        fd-fzf = pkgs.fetchFromGitHub {
          owner = "masaki39";
          repo = "fd-fzf.yazi";
          rev = "main";
          hash = "sha256-oiSNOWAvYSLNbna5ojIWw4+eBMYD47geSM7d6aKKMn8=";
        };
        fuzzy-search = pkgs.fetchFromGitHub {
          owner = "onelocked";
          repo = "fuzzy-search.yazi";
          rev = "main";
          hash = "sha256-vW6o5vbYXr++cFAcyvl7E2tYHQMV5lGK2rEOG5iiRPg=";
        };
      };
    };

    # External CLI tools referenced by opener and previewer config
    home.packages = with pkgs; [
      dtrx
      feh
      imv
      exiftool
      inkscape
      loupe
      vlc
      mediainfo
      ouch
    ];
  };
}
