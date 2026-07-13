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
            {
              run = "thunar \"$@\"";
              desc = "Reveal in Thunar";
            }
            {run = ''$EDITOR "$@"'';}
          ];
          archive = [
            {
              run = "dtrx \"$1\"";
              desc = "Extract here";
            }
          ];
          text = [
            {
              run = ''$EDITOR "$@"'';
              block = true;
            }
          ];
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
            {
              mime = "inode/directory";
              use = "folder";
            }
            {
              url = "*.svg";
              use = "svg";
            }
            {
              mime = "text/*";
              use = "text";
            }
            {
              mime = "image/*";
              use = "image";
            }
            {
              mime = "video/*";
              use = "video";
            }
            {
              mime = "audio/*";
              use = "audio";
            }
            {
              mime = "inode/x-empty";
              use = "text";
            }
            {
              mime = "application/json";
              use = "text";
            }
            {
              mime = "*/javascript";
              use = "text";
            }
            {
              mime = "application/zip";
              use = "archive";
            }
            {
              mime = "application/gzip";
              use = "archive";
            }
            {
              mime = "application/x-tar";
              use = "archive";
            }
            {
              mime = "application/x-bzip";
              use = "archive";
            }
            {
              mime = "application/x-bzip2";
              use = "archive";
            }
            {
              mime = "application/x-7z-compressed";
              use = "archive";
            }
            {
              mime = "application/x-rar";
              use = "archive";
            }
            {
              mime = "*";
              use = "fallback";
            }
          ];
        };
        tasks = {
          micro_workers = 5;
          macro_workers = 10;
          bizarre_retry = 5;
        };
        plugin = {
          # prepend_previewers adds rules BEFORE the built-in defaults
          # (previewers would REPLACE the defaults entirely — breaking code preview)
          prepend_previewers = [
            {
              url = "*.zip";
              run = "ouch";
            }
            {
              url = "*.7z";
              run = "ouch";
            }
            {
              url = "*.rar";
              run = "ouch";
            }
            {
              url = "*.tar";
              run = "ouch";
            }
            {
              url = "*.tar.gz";
              run = "ouch";
            }
            {
              url = "*.tar.xz";
              run = "ouch";
            }
            {
              url = "*.tar.bz2";
              run = "ouch";
            }
            {
              url = "*.tar.zst";
              run = "ouch";
            }
          ];
        };
        log = {
          enabled = false;
        };
      };

      keymap = {
        mgr = {
          prepend_keymap = [
            {
              on = "l";
              run = "plugin smart-enter";
              desc = "Enter directory or open file";
            }
            {
              on = "p";
              run = "plugin smart-paste";
              desc = "Paste into hovered directory or CWD";
            }
            {
              on = "m";
              run = "plugin bookmarks save";
              desc = "Save current position as a bookmark";
            }
            {
              on = "'";
              run = "plugin bookmarks jump";
              desc = "Jump to a bookmark";
            }
            {
              on = "`";
              run = "plugin bookmarks jump";
              desc = "Jump to a bookmark";
            }
            {
              on = ["b" "d"];
              run = "plugin bookmarks delete";
              desc = "Delete a bookmark";
            }
            {
              on = ["b" "D"];
              run = "plugin bookmarks delete_all";
              desc = "Delete all bookmarks";
            }
            {
              on = ["c" "m"];
              run = "plugin chmod";
              desc = "Chmod on selected files";
            }
            {
              on = ["c" "a" "a"];
              run = "plugin compress";
              desc = "Archive selected files";
            }
            {
              on = ["c" "a" "p"];
              run = "plugin compress -p";
              desc = "Archive with password";
            }
            {
              on = ["c" "a" "h"];
              run = "plugin compress -ph";
              desc = "Archive with password + header encryption";
            }
            {
              on = ["c" "a" "l"];
              run = "plugin compress -l";
              desc = "Archive with compression level";
            }
            {
              on = ["c" "a" "u"];
              run = "plugin compress -phl";
              desc = "Archive with password + header + level";
            }
            {
              on = "C";
              run = "plugin ouch";
              desc = "Compress with ouch";
            }
            {
              on = "X";
              run = "shell --block -- ouch decompress --yes %s";
              desc = "Extract archive with ouch";
              for = "unix";
            }
            {
              on = "M";
              run = "plugin mount";
              desc = "Mount manager";
            }
            {
              on = ["g" "v" "m"];
              run = "plugin gvfs -- select-then-mount --jump";
              desc = "Mount GVFS device and jump to it";
            }
            {
              on = ["g" "v" "u"];
              run = "plugin gvfs -- select-then-unmount --eject";
              desc = "Unmount/eject GVFS device";
            }
            {
              on = ["g" "v" "a"];
              run = "plugin gvfs -- add-mount";
              desc = "Add a GVFS mount URI";
            }
            {
              on = ["g" "v" "j"];
              run = "plugin gvfs -- jump-to-device";
              desc = "Jump to a mounted GVFS device";
            }
            {
              on = ["g" "i"];
              run = "plugin gitui";
              desc = "Open gitui";
            }
            {
              on = ["R" "b"];
              run = "plugin recycle-bin";
              desc = "Open Recycle Bin menu";
            }
            {
              on = ["R" "o"];
              run = "plugin recycle-bin -- open";
              desc = "Open Trash directory";
            }
            {
              on = ["R" "r"];
              run = "plugin recycle-bin -- restore";
              desc = "Restore from Trash";
            }
            {
              on = ["R" "d"];
              run = "plugin recycle-bin -- delete";
              desc = "Delete from Trash";
            }
            {
              on = ["R" "e"];
              run = "plugin recycle-bin -- empty";
              desc = "Empty Trash";
            }
            {
              on = ["R" "D"];
              run = "plugin recycle-bin -- emptyDays";
              desc = "Empty Trash by days";
            }
            {
              on = "U";
              run = "plugin restore";
              desc = "Restore last deleted files/folders";
            }
            {
              on = ["<A-d>" "i"];
              run = "plugin dupes interactive";
              desc = "Find duplicates (interactive)";
            }
            {
              on = ["<A-d>" "o"];
              run = "plugin dupes override";
              desc = "Find duplicates (custom jdupes args)";
            }
            {
              on = ["<A-d>" "d"];
              run = "plugin dupes dry";
              desc = "Find duplicates (dry run)";
            }
            {
              on = ["<A-d>" "a"];
              run = "plugin dupes apply";
              desc = "Find and delete duplicates";
            }
            {
              on = ["[" "d"];
              run = "plugin nav-parent-panel prev";
              desc = "Previous sibling directory";
            }
            {
              on = ["]" "d"];
              run = "plugin nav-parent-panel next";
              desc = "Next sibling directory";
            }
            {
              on = ["<A-s>" "p"];
              run = "plugin sudo -- paste";
              desc = "Sudo paste";
            }
            {
              on = ["<A-s>" "P"];
              run = "plugin sudo -- paste --force";
              desc = "Sudo force paste";
            }
            {
              on = ["<A-s>" "r"];
              run = "plugin sudo -- rename";
              desc = "Sudo rename";
            }
            {
              on = ["<A-s>" "d"];
              run = "plugin sudo -- remove";
              desc = "Sudo trash";
            }
            {
              on = ["<A-s>" "D"];
              run = "plugin sudo -- remove --permanently";
              desc = "Sudo permanent delete";
            }
            {
              on = ["<A-s>" "a"];
              run = "plugin sudo -- create";
              desc = "Sudo create file/directory";
            }
            {
              on = ["<A-s>" "l"];
              run = "plugin sudo -- link";
              desc = "Sudo symlink (absolute)";
            }
            {
              on = ["<A-s>" "L"];
              run = "plugin sudo -- hardlink";
              desc = "Sudo hardlink";
            }
            {
              on = ["<A-s>" "m"];
              run = "plugin sudo -- chmod";
              desc = "Sudo chmod";
            }
          ];
          # Built-in defaults apply for all mgr keybindings not listed in prepend_keymap
        };
        # Built-in defaults apply for tasks, spot, pick, input, confirm, cmp, and help modes
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
            section_separator = {
              open = "";
              close = "";
            };
            part_separator = {
              open = "";
              close = "";
            };
            inverse_separator = {
              open = "";
              close = "";
            };
            style_a = {
              fg = "black";
              bg_mode = {
                normal = "white";
                select = "brightyellow";
                un_set = "brightred";
              };
            };
            style_b = {
              bg = "brightblack";
              fg = "brightwhite";
            };
            style_c = {
              bg = "black";
              fg = "brightwhite";
            };
            permissions_t_fg = "green";
            permissions_r_fg = "yellow";
            permissions_w_fg = "red";
            permissions_x_fg = "cyan";
            permissions_s_fg = "white";
            tab_width = 20;
            tab_use_inverse = false;
            selected = {
              icon = "󰻭";
              fg = "yellow";
            };
            copied = {
              icon = "󰆐";
              fg = "green";
            };
            cut = {
              icon = "󰆐";
              fg = "red";
            };
            total = {
              icon = "󰮍";
              fg = "yellow";
            };
            succ = {
              icon = "󰄬";
              fg = "green";
            };
            fail = {
              icon = "󰄬";
              fg = "red";
            };
            found = {
              icon = "󰮕";
              fg = "blue";
            };
            processed = {
              icon = "󰐍";
              fg = "green";
            };
            show_background = true;
            display_header_line = true;
            display_status_line = true;
            component_positions = ["header" "tab" "status"];
            header_line = {
              left = {
                section_a = [
                  {
                    type = "line";
                    custom = false;
                    name = "tabs";
                    params = ["left"];
                  }
                ];
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
                section_a = [
                  {
                    type = "string";
                    custom = false;
                    name = "tab_mode";
                  }
                ];
                section_b = [
                  {
                    type = "string";
                    custom = false;
                    name = "hovered_size";
                  }
                ];
                section_c = [
                  {
                    type = "string";
                    custom = false;
                    name = "hovered_path";
                  }
                  {
                    type = "coloreds";
                    custom = false;
                    name = "count";
                  }
                ];
              };
              right = {
                section_a = [
                  {
                    type = "string";
                    custom = false;
                    name = "cursor_position";
                  }
                ];
                section_b = [
                  {
                    type = "string";
                    custom = false;
                    name = "cursor_percentage";
                  }
                ];
                section_c = [
                  {
                    type = "string";
                    custom = false;
                    name = "hovered_file_extension";
                    params = [true];
                  }
                  {
                    type = "coloreds";
                    custom = false;
                    name = "permissions";
                  }
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
      pkgs.stable.inkscape
      loupe
      vlc
      mediainfo
      ouch
    ];
  };
}
