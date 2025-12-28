return {
  "Mofiqul/vscode.nvim",
  lazy = false,
  priority = 1000,
  opts = {
    style = "dark",
    transparent = false,
    italic_comments = true,
    disable_nvimtree_bg = true,
    color_overrides = {},
    group_overrides = {},
  },
  config = function(_, opts)
    local vscode = require "vscode"
    vscode.setup(opts)
    vscode.load()
  end,
}
