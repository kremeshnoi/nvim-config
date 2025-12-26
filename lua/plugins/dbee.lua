return {
  "kndndrj/nvim-dbee",
  lazy = false,
  dependencies = {
    "MunifTanjim/nui.nvim",
  },
  build = function()
    require("dbee").install()
  end,
  config = function()
    require("dbee").setup()
  end,
}
