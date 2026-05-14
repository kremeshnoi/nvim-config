return {
  "nvim-neo-tree/neo-tree.nvim",
  branch = "v3.x",
  lazy = false,
  dependencies = {
    "nvim-lua/plenary.nvim",
    "nvim-tree/nvim-web-devicons",
    "MunifTanjim/nui.nvim",
  },
  config = function()
    local green = "#a7c080"
    local yellow = "#dbbc7f"
    local red = "#e67e80"
    local gray = "#859289"
    local function set_git_hl()
      vim.api.nvim_set_hl(0, "NeoTreeGitAdded", { fg = green })
      vim.api.nvim_set_hl(0, "NeoTreeGitStaged", { fg = green })
      vim.api.nvim_set_hl(0, "NeoTreeGitRenamed", { fg = green })
      vim.api.nvim_set_hl(0, "NeoTreeGitUntracked", { fg = red })
      vim.api.nvim_set_hl(0, "NeoTreeGitModified", { fg = yellow })
      vim.api.nvim_set_hl(0, "NeoTreeGitUnstaged", { fg = yellow })
      vim.api.nvim_set_hl(0, "NeoTreeGitDeleted", { fg = red })
      vim.api.nvim_set_hl(0, "NeoTreeGitConflict", { fg = red })
      vim.api.nvim_set_hl(0, "NeoTreeGitIgnored", { fg = gray })
      vim.api.nvim_set_hl(0, "NeoTreeModified", { fg = yellow })
    end
    set_git_hl()
    vim.api.nvim_create_autocmd("ColorScheme", { callback = set_git_hl })

    require("neo-tree").setup {
      close_if_last_window = true,
      enable_git_status = true,
      enable_diagnostics = true,
      popup_border_style = "rounded",
      resize_timer_interval = 500,
      hide_root_node = true,
      retain_hidden_root_indent = true,
      default_component_configs = {
        container = {
          enable_character_fade = true,
          width = "100%",
          right_padding = 0,
        },
        name = {
          trailing_slash = false,
          use_git_status_colors = true,
        },
      },
      renderers = {
        directory = {
          { "indent" },
          { "icon" },
          { "current_filter" },
          {
            "container",
            content = {
              { "dir_name", zindex = 10 },
              { "clipboard", zindex = 10 },
              { "diagnostics", errors_only = true, zindex = 20, align = "right", hide_when_expanded = true },
            },
          },
        },
        file = {
          { "indent" },
          { "icon" },
          {
            "container",
            content = {
              { "name", zindex = 10 },
              { "clipboard", zindex = 10 },
              { "bufnr", zindex = 10 },
              { "modified", zindex = 20, align = "right" },
              { "diagnostics", zindex = 20, align = "right" },
            },
          },
        },
      },
      window = {
        popup = {
          size = { height = "80%", width = "50%" },
          position = "50%",
        },
      },
      filesystem = {
        components = {
          dir_name = function(config, node, state)
            local cc = require "neo-tree.sources.common.components"
            local with_git = vim.tbl_extend("force", config, { use_git_status_colors = true })
            local result = cc.name(with_git, node, state)
            if result and result.highlight == "NeoTreeGitIgnored" then
              return result
            end
            return cc.name(config, node, state)
          end,
        },
        filtered_items = {
          visible = true,
          hide_dotfiles = false,
          hide_gitignored = false,
          never_show = { ".git" },
        },
        follow_current_file = { enabled = true },
        use_libuv_file_watcher = true,
      },
    }
  end,
}
