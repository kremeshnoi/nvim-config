return {
  {
    "stevearc/conform.nvim",
    event = { "BufReadPre", "BufNewFile" },
    lazy = false,
    opts = {
      format_on_save = { timeout_ms = 1500, lsp_fallback = true },
      formatters_by_ft = {
        lua = { "stylua" },
        rust = { "rustfmt" },

        javascript = { "prettierd", "prettier" },
        typescript = { "prettierd", "prettier" },
        javascriptreact = { "prettierd", "prettier" },
        typescriptreact = { "prettierd", "prettier" },
        vue = { "prettierd", "prettier" },

        json = { "prettierd", "prettier" },
        yaml = { "prettierd", "prettier" },
        markdown = { "prettierd", "prettier" },
        css = { "prettierd", "prettier" },
        html = { "prettierd", "prettier" },
        php = { "php_cs_fixer" },
        ruby = { "rubocop" },

        toml = { "taplo" },
        bash = { "shfmt" },
        sql = { "sqlfmt", "sqlfluff" },
      },
    },
  },
  {
    "mason-org/mason.nvim",
    cmd = "Mason",
    build = ":MasonUpdate",
    opts = {
      ensure_installed = {
        "stylua",
        "prettierd",
        "prettier",
        "taplo",
        "shfmt",
        "sqlfmt",
        "sqlfluff",
        "php-cs-fixer",
        "rubocop",
        "vue-language-server",
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
