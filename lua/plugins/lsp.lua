return {
  {
    "neovim/nvim-lspconfig",
    dependencies = {
      { "williamboman/mason.nvim", config = true },
      { "mason-org/mason-lspconfig.nvim" },
      { "hrsh7th/cmp-nvim-lsp" },
    },
    config = function()
      local capabilities = vim.lsp.protocol.make_client_capabilities()
      local ok_cmp, cmp_lsp = pcall(require, "cmp_nvim_lsp")
      if ok_cmp then
        capabilities = cmp_lsp.default_capabilities(capabilities)
      end

      local on_attach = function(client, bufnr)
        client.server_capabilities.documentFormattingProvider = false
        client.server_capabilities.documentRangeFormattingProvider = false
      end

      vim.diagnostic.config {
        virtual_text = true,
        severity_sort = true,
        underline = true,
        update_in_insert = false,
        float = { border = "rounded", source = "if_many" },
      }

      require("mason-lspconfig").setup {
        ensure_installed = {
          "vue_ls",
          "vtsls",
          "eslint",
          "html",
          "cssls",
          "tailwindcss",
          "jsonls",
          "yamlls",
          "dockerls",
          "bashls",
          "taplo",
          "marksman",
          "lua_ls",
          "rust_analyzer",
          "intelephense",
          "ruby_lsp",
        },
        automatic_enable = false,
      }

      local mason_root = vim.env.MASON or (vim.fn.stdpath "data" .. "/mason")
      local vue_language_server_path = mason_root .. "/packages/vue-language-server/node_modules/@vue/language-server"

      local vue_plugin = {
        name = "@vue/typescript-plugin",
        location = vue_language_server_path,
        languages = { "vue" },
        configNamespace = "typescript",
      }

      local servers = {
        vue_ls = {
          capabilities = capabilities,
          on_attach = on_attach,
          filetypes = { "vue" },
        },

        vtsls = {
          capabilities = capabilities,
          on_attach = on_attach,
          settings = {
            vtsls = {
              tsserver = {
                globalPlugins = { vue_plugin },
              },
            },
          },
          filetypes = { "typescript", "javascript", "javascriptreact", "typescriptreact", "vue" },
        },

        eslint = {
          capabilities = capabilities,
          on_attach = on_attach,
          filetypes = { "javascript", "javascriptreact", "typescript", "typescriptreact", "vue" },
        },

        html = {
          capabilities = capabilities,
          on_attach = on_attach,
          filetypes = { "html", "vue", "typescriptreact", "typescript", "javascriptreact", "javascript" },
        },

        cssls = {
          capabilities = capabilities,
          on_attach = on_attach,
          filetypes = { "css", "scss", "less" },
        },

        tailwindcss = {
          capabilities = capabilities,
          on_attach = on_attach,
          filetypes = {
            "html",
            "css",
            "scss",
            "sass",
            "less",
            "javascript",
            "javascriptreact",
            "typescript",
            "typescriptreact",
            "vue",
          },
        },

        jsonls = {
          capabilities = capabilities,
          on_attach = on_attach,
          filetypes = { "json", "jsonc" },
          settings = { json = { validate = { enable = true } } },
        },

        yamlls = {
          capabilities = capabilities,
          on_attach = on_attach,
          filetypes = { "yaml" },
          settings = { yaml = { validate = true, keyOrdering = false } },
        },

        dockerls = {
          capabilities = capabilities,
          on_attach = on_attach,
          filetypes = { "dockerfile" },
        },

        bashls = {
          capabilities = capabilities,
          on_attach = on_attach,
          filetypes = { "sh" },
        },

        taplo = {
          capabilities = capabilities,
          on_attach = on_attach,
          filetypes = { "toml" },
        },

        marksman = {
          capabilities = capabilities,
          on_attach = on_attach,
          filetypes = { "markdown" },
        },

        lua_ls = {
          capabilities = capabilities,
          on_attach = on_attach,
          filetypes = { "lua" },
          settings = {
            Lua = {
              runtime = { version = "LuaJIT" },
              diagnostics = { globals = { "vim" } },
              workspace = {
                checkThirdParty = false,
                library = { vim.env.VIMRUNTIME },
              },
              telemetry = { enable = false },
            },
          },
        },

        rust_analyzer = {
          capabilities = capabilities,
          on_attach = on_attach,
          filetypes = { "rust" },
          settings = {
            ["rust-analyzer"] = {
              cargo = { allFeatures = true },
              checkOnSave = true,
              check = {
                command = "check",
              },
              procMacro = { enable = true },
            },
          },
        },

        intelephense = {
          capabilities = capabilities,
          on_attach = on_attach,
          filetypes = { "php" },
          settings = {
            intelephense = {
              files = { maxSize = 2000000 },
              format = { enable = false },
            },
          },
        },

        ruby_lsp = {
          capabilities = capabilities,
          on_attach = on_attach,
          filetypes = { "ruby" },
        },
      }

      for name, cfg in pairs(servers) do
        vim.lsp.config(name, cfg)
      end

      vim.lsp.enable(vim.tbl_keys(servers))
    end,
  },
}
