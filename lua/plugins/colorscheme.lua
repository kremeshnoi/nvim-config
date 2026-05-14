return {
  "Mofiqul/vscode.nvim",
  lazy = false,
  priority = 1000,
  opts = {
    style = "dark",
    transparent = true,
    italic_comments = true,
    color_overrides = {},
    group_overrides = {
      ["@function.method.vue"] = { link = "@tag.attribute.vue" },
      ["@lsp.type.component.vue"] = { link = "@type" },
    },
  },
  config = function(_, opts)
    local vscode = require "vscode"
    vscode.setup(opts)
    vscode.load()
  end,
}
