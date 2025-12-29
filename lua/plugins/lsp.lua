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

      local on_attach = function(_, _) end

      local on_attach_noformat = function(client, bufnr)
        client.server_capabilities.documentFormattingProvider = false
        client.server_capabilities.documentRangeFormattingProvider = false
        on_attach(client, bufnr)
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
          "ts_ls",
          "eslint",
          "html",
          "cssls",
          "tailwindcss",
          "jsonls",
          "emmet_ls",
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

      local vue_language_server_path = vim.fn.expand "$MASON/packages"
        .. "/vue-language-server/node_modules/@vue/language-server"

      local vue_plugin = {
        name = "@vue/typescript-plugin",
        location = vue_language_server_path,
        languages = { "vue" },
        configNamespace = "typescript",
      }

      local function vue_ts_forwarder(client)
        client.handlers["tsserver/request"] = function(_, result, context)
          local clients = vim.lsp.get_clients { bufnr = context.bufnr, name = "vtsls" }
          if #clients == 0 then
            return
          end
          local ts_client = clients[1]
          local param = result[1]
          local id = param[1]
          local command = param[2]
          local payload = param[3]
          ts_client:exec_cmd({
            title = "vue_request_forward",
            command = "typescript.tsserverRequest",
            arguments = { command, payload },
          }, { bufnr = context.bufnr }, function(_, r)
            local response = r and r.body
            client:notify("tsserver/response", { { id, response } })
          end)
        end
      end

      local servers = {
        vue_ls = {
          capabilities = capabilities,
          on_attach = on_attach,
          filetypes = { "vue" },
          init_options = { vue = { hybridMode = true } },
          on_init = vue_ts_forwarder,
        },

        vtsls = {
          capabilities = capabilities,
          on_attach = on_attach_noformat,
          settings = {
            vtsls = {
              tsserver = {
                globalPlugins = { vue_plugin },
              },
            },
          },
          filetypes = { "typescript", "javascript", "javascriptreact", "typescriptreact", "vue" },
        },

        ts_ls = {
          capabilities = capabilities,
          on_attach = on_attach_noformat,
          filetypes = { "typescript", "javascript", "typescriptreact", "javascriptreact" },
        },

        eslint = {
          capabilities = capabilities,
          on_attach = on_attach_noformat,
          filetypes = { "javascript", "javascriptreact", "typescript", "typescriptreact", "vue" },
        },

        html = { capabilities = capabilities, on_attach = on_attach },
        cssls = { capabilities = capabilities, on_attach = on_attach },

        emmet_ls = {
          capabilities = capabilities,
          on_attach = on_attach,
          filetypes = {
            "html",
            "css",
            "scss",
            "sass",
            "less",
            "javascriptreact",
            "typescriptreact",
            "vue",
          },
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
          settings = { json = { validate = { enable = true } } },
        },

        yamlls = {
          capabilities = capabilities,
          on_attach = on_attach,
          settings = { yaml = { validate = true, keyOrdering = false } },
        },

        dockerls = { capabilities = capabilities, on_attach = on_attach },
        bashls = { capabilities = capabilities, on_attach = on_attach },
        taplo = { capabilities = capabilities, on_attach = on_attach },
        marksman = { capabilities = capabilities, on_attach = on_attach },

        lua_ls = {
          capabilities = capabilities,
          on_attach = on_attach,
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
          settings = {
            intelephense = {
              files = { maxSize = 2000000 },
              format = { enable = false },
            },
          },
        },

        ruby_lsp = {
          capabilities = capabilities,
          on_attach = on_attach_noformat,
        },
      }

      for name, cfg in pairs(servers) do
        vim.lsp.config(name, cfg)
      end

      vim.lsp.enable(vim.tbl_keys(servers))
    end,
  },
}
