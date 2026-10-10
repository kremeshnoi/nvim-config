return {
  "saghen/blink.cmp",
  version = "1.*",
  event = { "InsertEnter", "CmdlineEnter" },
  dependencies = {
    {
      "L3MON4D3/LuaSnip",
      version = "v2.*",
      dependencies = { "rafamadriz/friendly-snippets" },
      config = function()
        require("luasnip.loaders.from_vscode").lazy_load()
      end,
    },
  },
  opts = {
    keymap = {
      preset = "none",
      ["<C-Space>"] = { "show", "show_documentation", "hide_documentation" },
      ["<C-e>"] = { "hide", "fallback" },
      ["<CR>"] = { "accept", "fallback" },
      ["<Tab>"] = { "select_next", "snippet_forward", "fallback" },
      ["<S-Tab>"] = { "select_prev", "snippet_backward", "fallback" },
    },
    snippets = { preset = "luasnip" },
    completion = {
      documentation = { auto_show = true, auto_show_delay_ms = 200 },
    },
    signature = { enabled = true },
    sources = {
      default = { "lsp", "snippets", "path", "buffer" },
      per_filetype = {
        sql = { "dadbod", "snippets", "buffer" },
        mysql = { "dadbod", "snippets", "buffer" },
        plsql = { "dadbod", "snippets", "buffer" },
      },
      providers = {
        dadbod = { name = "Dadbod", module = "vim_dadbod_completion.blink" },
      },
    },
    fuzzy = { implementation = "prefer_rust_with_warning" },
  },
}
