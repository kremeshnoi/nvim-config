return {
  {
    "neovim/nvim-lspconfig",
    event = { "BufReadPre", "BufNewFile" },
    lazy = false,
    dependencies = {
      { "mason-org/mason.nvim", cmd = "Mason", opts = {} },
      { "mason-org/mason-lspconfig.nvim", opts = {} },
      { "j-hui/fidget.nvim", opts = {} },
    },
    config = function()
      vim.diagnostic.config {
        virtual_text = false,
        severity_sort = true,
        underline = true,
        float = { border = "rounded", source = "if_many" },
        signs = true,
        update_in_insert = false,
      }

      local on_attach = function(_, bufnr)
        if vim.lsp.inlay_hint then
          pcall(vim.lsp.inlay_hint.enable, false, { bufnr = bufnr })
        end
      end

      local capabilities = vim.lsp.protocol.make_client_capabilities()
      local ok_cmp, cmp_lsp = pcall(require, "cmp_nvim_lsp")
      if ok_cmp then
        capabilities = cmp_lsp.default_capabilities(capabilities)
      end

      local servers = {
        ts_ls = {},
        eslint = {},
        html = {},
        cssls = {},
        tailwindcss = {},
        jsonls = {},
        yamlls = {},
        rust_analyzer = {
          settings = {
            ["rust-analyzer"] = {
              cargo = { allFeatures = true },
              checkOnSave = { command = "clippy" },
            },
          },
        },
        lua_ls = {
          settings = {
            Lua = {
              diagnostics = { globals = { "vim" } },
              workspace = { checkThirdParty = false },
              telemetry = { enable = false },
            },
          },
        },
        dockerls = {},
        bashls = {},
        sqlls = {},
        marksman = {},
      }

      if vim.lsp and vim.lsp.config then
        for name, cfg in pairs(servers) do
          vim.lsp.config(
            name,
            vim.tbl_deep_extend("force", {
              capabilities = capabilities,
              on_attach = on_attach,
            }, cfg)
          )
        end
      else
        local lspconfig = require "lspconfig"
        for name, cfg in pairs(servers) do
          lspconfig[name].setup(vim.tbl_deep_extend("force", {
            capabilities = capabilities,
            on_attach = on_attach,
          }, cfg))
        end
      end

      require("mason-lspconfig").setup {
        ensure_installed = vim.tbl_keys(servers),
        automatic_enable = true,
      }
    end,
  },
}
