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

      local ok_navic, navic = pcall(require, "nvim-navic")

      local on_attach = function(client, bufnr)
        if ok_navic and client.server_capabilities.documentSymbolProvider then
          navic.attach(client, bufnr)
        end
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
        volar = {
          filetypes = { "vue" },
        },
        tailwindcss = {},
        jsonls = {},
        yamlls = {},
        intelephense = {},
        solargraph = {},
        rust_analyzer = {
          settings = {
            ["rust-analyzer"] = {
              cargo = { allFeatures = true },
              checkOnSave = true,
              check = {
                command = "check",
              },
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

      local mason_lspconfig = require "mason-lspconfig"
      local available = {}
      for _, name in ipairs(mason_lspconfig.get_available_servers()) do
        available[name] = true
      end

      local ensure = {}
      for name in pairs(servers) do
        if available[name] then
          table.insert(ensure, name)
        end
      end
      table.sort(ensure)

      mason_lspconfig.setup {
        ensure_installed = ensure,
        automatic_enable = true,
      }
    end,
  },
}
