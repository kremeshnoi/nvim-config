return {
  "lukas-reineke/indent-blankline.nvim",
  main = "ibl",
  lazy = false,
  event = { "BufReadPre", "BufNewFile" },
  opts = {
    indent = {
      char = "│",
      highlight = "IblIndent",
    },
    scope = {
      enabled = false,
    },
  },
  config = function(_, opts)
    require("ibl").setup(opts)
  end,
}
