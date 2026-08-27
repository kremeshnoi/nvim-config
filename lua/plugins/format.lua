return {
  {
    "stevearc/conform.nvim",
    event = { "BufReadPre", "BufNewFile" },
    opts = function()
      local eslint_config_files = {
        "eslint.config.js",
        "eslint.config.cjs",
        "eslint.config.mjs",
        "eslint.config.ts",
        "eslint.config.cts",
        "eslint.config.mts",
        ".eslintrc",
        ".eslintrc.js",
        ".eslintrc.cjs",
        ".eslintrc.json",
        ".eslintrc.yaml",
        ".eslintrc.yml",
      }

      local function read_json(path)
        local file = io.open(path, "r")
        if not file then
          return nil
        end

        local content = file:read "*all"
        file:close()

        local ok, data = pcall(vim.json.decode, content)
        if not ok then
          return nil
        end

        return data
      end

      local function eslint_root(ctx)
        local root = vim.fs.root(ctx.dirname, eslint_config_files)
        if root then
          return root
        end

        local package_json = vim.fs.find("package.json", { path = ctx.dirname, upward = true, limit = 1 })[1]
        if not package_json then
          return nil
        end

        local package_data = read_json(package_json)
        if package_data and package_data.eslintConfig then
          return vim.fs.dirname(package_json)
        end

        return nil
      end

      return {
        format_on_save = { timeout_ms = 1500, lsp_fallback = false },
        formatters_by_ft = {
          lua = { "stylua" },
          rust = { "rustfmt" },
          python = { "ruff_organize_imports", "ruff_format" },
          java = { "google-java-format" },
          kotlin = { "ktlint" },
          clojure = { "cljfmt" },

          javascript = { "prettier", "eslint_d" },
          typescript = { "prettier", "eslint_d" },
          javascriptreact = { "prettier", "eslint_d" },
          typescriptreact = { "prettier", "eslint_d" },
          vue = { "prettier", "eslint_d" },

          json = { "prettier" },
          jsonc = { "prettier" },
          yaml = { "prettier" },
          markdown = { "prettier" },
          css = { "prettier" },
          scss = { "prettier" },
          less = { "prettier" },
          html = { "prettier" },
          php = { "php_cs_fixer" },
          ruby = { "rubocop" },

          toml = { "taplo" },
          bash = { "shfmt" },
          sql = { "sqlfmt" },
        },
        formatters = {
          eslint_d = {
            cwd = function(_, ctx)
              return eslint_root(ctx)
            end,
            condition = function(_, ctx)
              return eslint_root(ctx) ~= nil
            end,
          },
        },
      }
    end,
  },
}
