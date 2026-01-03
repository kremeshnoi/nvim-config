return {
  {
    "nvim-treesitter/nvim-treesitter",
    branch = "main",
    lazy = false,
    build = ":TSUpdate",

    config = function()
      local parsers = {
        "hcl",
        "vim",
        "sql",
        "vue",
        "tsx",
        "css",
        "scss",
        "html",
        "http",
        "bash",
        "nginx",
        "regex",
        "mermaid",

        "lua",
        "php",
        "ruby",
        "rust",
        "clojure",
        "javascript",
        "typescript",

        "dot",
        "csv",
        "make",
        "yaml",
        "toml",
        "json",
        "scheme",
        "markdown",
        "gitignore",
        "gitcommit",
        "dockerfile",
        "gitattributes",

        "jsdoc",
        "luadoc",
        "vimdoc",
        "phpdoc",
        "comment",
      }

      local ts = require "nvim-treesitter"
      ts.install(parsers)

      vim.g.vim_regex_highlighting = false

      vim.opt.foldenable = false

      local group = vim.api.nvim_create_augroup("TreesitterHighlight", { clear = true })
      vim.api.nvim_create_autocmd("FileType", {
        group = group,
        callback = function(args)
          pcall(vim.treesitter.start, args.buf)
        end,
      })
    end,
  },
}
