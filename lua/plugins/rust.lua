return {
  "mrcjkb/rustaceanvim",
  version = "^9",
  lazy = false,
  init = function()
    local mason = vim.env.MASON or (vim.fn.stdpath "data" .. "/mason")

    vim.g.rustaceanvim = function()
      return {
        server = {
          cmd = { mason .. "/bin/rust-analyzer" },
          capabilities = require("blink.cmp").get_lsp_capabilities(),
          on_attach = function(client)
            client.server_capabilities.documentFormattingProvider = false
            client.server_capabilities.documentRangeFormattingProvider = false
          end,
          default_settings = {
            ["rust-analyzer"] = {
              cargo = { allFeatures = true },
              checkOnSave = true,
              check = { command = "check" },
              procMacro = { enable = true },
            },
          },
        },
      }
    end
  end,
}
