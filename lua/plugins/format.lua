return {
  {
    "stevearc/conform.nvim",
    event = { "BufReadPre", "BufNewFile" },
    lazy = false,
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
        format_on_save = { timeout_ms = 1500, lsp_fallback = false, stop_after_first = true },
        formatters_by_ft = {
          lua = { "stylua" },
          rust = { "rustfmt" },

          javascript = { "eslint_d", "prettier" },
          typescript = { "eslint_d", "prettier" },
          javascriptreact = { "eslint_d", "prettier" },
          typescriptreact = { "eslint_d", "prettier" },
          vue = { "eslint_d", "prettier" },

          json = { "prettier" },
          yaml = { "prettier" },
          markdown = { "prettier" },
          css = { "prettier" },
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
  {
    "mason-org/mason.nvim",
    cmd = "Mason",
    build = ":MasonUpdate",
    opts = {
      ensure_installed = {
        "stylua",
        "prettier",
        "eslint_d",
        "taplo",
        "shfmt",
        "sqlfmt",
        "php-cs-fixer",
        "rubocop",
      },
    },
    config = function(_, opts)
      require("mason").setup(opts)

      local mr = require "mason-registry"
      mr:on("package:install:success", function()
        vim.defer_fn(function()
          require("lazy.core.handler.event").trigger {
            event = "FileType",
            buf = vim.api.nvim_get_current_buf(),
          }
        end, 100)
      end)

      mr.refresh(function()
        for _, tool in ipairs(opts.ensure_installed or {}) do
          local p = mr.get_package(tool)
          if not p:is_installed() then
            p:install()
          end
        end
      end)
    end,
  },
}
