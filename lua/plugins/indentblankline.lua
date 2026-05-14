return {
  "lukas-reineke/indent-blankline.nvim",
  main = "ibl",
  event = { "BufReadPre", "BufNewFile" },
  opts = {
    indent = {
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
