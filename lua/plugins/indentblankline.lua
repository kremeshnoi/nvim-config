return {
  "lukas-reineke/indent-blankline.nvim",
  main = "ibl",
  event = { "BufReadPre", "BufNewFile" },
  opts = {
    indent = {
      highlight = "IblIndent",
    },
    scope = {
      enabled = true,
      highlight = "IblScope",
      show_start = false,
      show_end = false,
    },
  },
  config = function(_, opts)
    require("ibl").setup(opts)
  end,
}
