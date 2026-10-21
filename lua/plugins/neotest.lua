return {
  "nvim-neotest/neotest",
  lazy = true,
  dependencies = {
    "nvim-neotest/nvim-nio",
    "nvim-lua/plenary.nvim",
    "nvim-treesitter/nvim-treesitter",
    "mrcjkb/rustaceanvim",
  },
  config = function()
    require("neotest").setup {
      adapters = {
        require "rustaceanvim.neotest",
      },
      status = { virtual_text = true },
      output = { open_on_run = false },
    }
  end,
}
