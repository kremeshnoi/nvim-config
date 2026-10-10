return {
  {
    "windwp/nvim-autopairs",
    event = "InsertEnter",
    dependencies = {
      "nvim-treesitter/nvim-treesitter",
    },
    config = function()
      local autopairs = require "nvim-autopairs"

      autopairs.setup {
        check_ts = true,
        ts_config = {
          lua = { "string" },
          javascript = { "template_string" },
          typescript = { "template_string" },
        },
        disable_filetype = {
          "TelescopePrompt",
          "vim",
        },
        fast_wrap = {
          map = "<M-e>",
          chars = { "{", "[", "(", '"', "'" },
          pattern = [=[[%'%"%>%]%)%}%,]]=],
          end_key = "$",
          keys = "qwertyuiopzxcvbnmasdfghjkl",
          check_comma = true,
          highlight = "Search",
          highlight_grey = "Comment",
        },
      }
    end,
  },
}
