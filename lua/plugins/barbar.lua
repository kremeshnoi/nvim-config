return {
  "romgrk/barbar.nvim",
  dependencies = {
    "nvim-tree/nvim-web-devicons",
    "lewis6991/gitsigns.nvim",
  },
  event = "VeryLazy",
  init = function()
    vim.g.barbar_auto_setup = false
  end,
  config = function()
    require("barbar").setup {
      animation = false,
      auto_hide = false,
      tabpages = true,
      clickable = true,
      icons = {
        buffer_index = false,
        buffer_number = false,
        filetype = { enabled = true },

        separator = { left = "", right = "" },
        inactive = { separator = { left = "", right = "" } },

        modified = { button = "●" },

        diagnostics = {
          [vim.diagnostic.severity.ERROR] = { enabled = true, icon = " " },
          [vim.diagnostic.severity.WARN] = { enabled = true, icon = " " },
        },

        gitsigns = {
          added = { enabled = true, icon = "+" },
          changed = { enabled = true, icon = "~" },
          deleted = { enabled = true, icon = "-" },
        },
      },

      sidebar_filetypes = {
        NvimTree = { text = "", align = "center" },
      },

      highlight_alternate = false,
      highlight_inactive_file_icons = false,
      highlight_visible = true,
    }
  end,
}
