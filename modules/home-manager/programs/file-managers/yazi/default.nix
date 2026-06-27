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
      plugins = {
        bookmarks = pkgs.yaziPlugins.bookmarks;
        chmod = pkgs.yaziPlugins.chmod;
        compress = pkgs.yaziPlugins.compress;
        dupes = pkgs.yaziPlugins.dupes;
        full-border = pkgs.yaziPlugins.full-border;
        git = pkgs.yaziPlugins.git;
        gitui = pkgs.yaziPlugins.gitui;
        glow = pkgs.yaziPlugins.glow;
        gvfs = pkgs.yaziPlugins.gvfs;
        mime-ext = pkgs.yaziPlugins.mime-ext;
        mount = pkgs.yaziPlugins.mount;
        nav-parent-panel = pkgs.yaziPlugins.nav-parent-panel;
        ouch = pkgs.yaziPlugins.ouch;
        piper = pkgs.yaziPlugins.piper;
        recycle-bin = pkgs.yaziPlugins.recycle-bin;
        restore = pkgs.yaziPlugins.restore;
        smart-enter = pkgs.yaziPlugins.smart-enter;
        smart-paste = pkgs.yaziPlugins.smart-paste;
        sudo = pkgs.yaziPlugins.sudo;
        yatline = pkgs.yaziPlugins.yatline;
      };
      initLua = ''
        -- Git status icons
        require("git"):setup()

        -- Full border around panels
        require("full-border"):setup()

        -- Smart enter: directories -> enter, files -> open
        require("smart-enter"):setup({ open_multi = true })

        -- Bookmarks with persistent storage
        require("bookmarks"):setup({
          persist = "all",
          desc_format = "full",
          file_pick_mode = "hover",
          notify = { enable = true, timeout = 2 },
        })

        -- Recycle bin integration
        require("recycle-bin"):setup()

        -- MIME type extension (better file type detection + linemodes)
        require("mime-ext"):setup()

        -- Yatline status bar
        require("yatline"):setup({
          section_separator = { open = "", close = "" },
          part_separator = { open = "", close = "" },
          inverse_separator = { open = "", close = "" },

          style_a = {
            fg = "black",
            bg_mode = {
              normal = "white",
              select = "brightyellow",
              un_set = "brightred"
            }
          },
          style_b = { bg = "brightblack", fg = "brightwhite" },
          style_c = { bg = "black", fg = "brightwhite" },

          permissions_t_fg = "green",
          permissions_r_fg = "yellow",
          permissions_w_fg = "red",
          permissions_x_fg = "cyan",
          permissions_s_fg = "white",

          tab_width = 20,
          tab_use_inverse = false,

          selected = { icon = "󰻭", fg = "yellow" },
          copied = { icon = "", fg = "green" },
          cut = { icon = "", fg = "red" },

          total = { icon = "󰮍", fg = "yellow" },
          succ = { icon = "", fg = "green" },
          fail = { icon = "", fg = "red" },
          found = { icon = "󰮕", fg = "blue" },
          processed = { icon = "󰐍", fg = "green" },

          show_background = true,

          display_header_line = true,
          display_status_line = true,

          component_positions = { "header", "tab", "status" },

          header_line = {
            left = {
              section_a = {
                {type = "line", custom = false, name = "tabs", params = {"left"}},
              },
              section_b = {},
              section_c = {}
            },
            right = {
              section_a = {},
              section_b = {},
              section_c = {}
            }
          },

          status_line = {
            left = {
              section_a = {
                {type = "string", custom = false, name = "tab_mode"},
              },
              section_b = {
                {type = "string", custom = false, name = "hovered_size"},
              },
              section_c = {
                {type = "string", custom = false, name = "hovered_path"},
                {type = "coloreds", custom = false, name = "count"},
              }
            },
            right = {
              section_a = {
                {type = "string", custom = false, name = "cursor_position"},
              },
              section_b = {
                {type = "string", custom = false, name = "cursor_percentage"},
              },
              section_c = {
                {type = "string", custom = false, name = "hovered_file_extension", params = {true}},
                {type = "coloreds", custom = false, name = "permissions"},
              }
            }
          },
        })
      '';
    };

    home.file = {
      ".config/yazi/yazi.toml".source = ./yazi.toml;
      ".config/yazi/keymap.toml".source = ./keymap.toml;
      # Don't install theme file to avoid conflicts with stylix
      # ".config/yazi/theme.toml".source = ./theme.toml;
    };
  };
}
