return {
  "folke/zen-mode.nvim",
  cmd = "ZenMode",
  opts = {
    window = {
      backdrop = 0.95,
      width = 120,
      height = 1,
    },
    plugins = {
      options = {
        enabled = true,
        ruler = false,
        showcmd = false,
        laststatus = 0,
      },
      gitsigns = { enabled = false },
    },
  },
  keys = {
    {
      "<leader>Z",
      "<cmd>ZenMode<cr>",
      desc = "Toggle Zen Mode",
    },
  },
}
