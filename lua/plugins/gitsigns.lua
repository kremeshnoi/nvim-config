return {
  {
    "lewis6991/gitsigns.nvim",
    event = { "BufReadPre", "BufNewFile" },
    opts = {
      on_attach = function(bufnr)
        require("config.keymaps").gitsigns_on_attach(bufnr)
      end,
    },
  },
}
