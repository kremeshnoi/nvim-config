return {
  "nvim-lualine/lualine.nvim",
  event = "VeryLazy",
  lazy = false,
  dependencies = {
    "nvim-tree/nvim-web-devicons",
  },
  config = function()
    vim.opt.laststatus = 3

    require("lualine").setup {
      options = {
        icons_enabled = true,
        section_separators = "",
        component_separators = "",
        globalstatus = true,
      },
      sections = {
        lualine_a = {},
        lualine_b = {},
        lualine_c = {},
        lualine_x = { { "filename", path = 1 }, "branch", "encoding", "filetype" },
        lualine_y = { "location" },
        lualine_z = { "mode" },
      },
      inactive_sections = {
        lualine_a = {},
        lualine_b = {},
        lualine_c = {},
        lualine_x = {},
        lualine_y = {},
        lualine_z = {},
      },
      extensions = {},
    }
  end,
}
