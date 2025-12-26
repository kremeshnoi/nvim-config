return {
  "nvim-lualine/lualine.nvim",
  event = "VeryLazy",
  lazy = false,
  dependencies = {
    "nvim-tree/nvim-web-devicons",
  },
  config = function()
    require("lualine").setup {
      options = {
        theme = "vscode",
        icons_enabled = true,
        globalstatus = true,
        section_separators = "",
        component_separators = "",
        disabled_filetypes = {
          winbar = {
            "NvimTree",
          },
        },
      },
      winbar = {
        lualine_a = {},
        lualine_b = {},
        lualine_c = {},
        lualine_x = { "branch" },
        lualine_y = { "encoding" },
        lualine_z = {},
      },
      inactive_winbar = {
        lualine_a = {},
        lualine_b = {},
        lualine_c = {},
        lualine_x = { "branch" },
        lualine_y = { "encoding" },
        lualine_z = {},
      },
      sections = {
        lualine_a = {},
        lualine_b = {},
        lualine_c = {},
        lualine_x = {},
        lualine_y = {},
        lualine_z = {},
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
