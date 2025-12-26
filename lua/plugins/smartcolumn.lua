return {
  "m4xshen/smartcolumn.nvim",
  event = "BufReadPre",
  lazy = false,
  opts = {
    colorcolumn = "120",
    disabled_filetypes = {
      "help",
      "text",
      "markdown",
      "NvimTree",
      "neo-tree",
      "TelescopePrompt",
      "TelescopeResults",
    },
  },
}
