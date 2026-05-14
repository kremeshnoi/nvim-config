return {
  "Bekaboo/dropbar.nvim",
  event = { "BufReadPost", "BufNewFile" },
  dependencies = { "nvim-telescope/telescope-fzf-native.nvim" },
  config = function()
    local dropbar = require "dropbar"
    dropbar.setup {
      bar = {
        enable = function(buf, win)
          if
            not vim.api.nvim_buf_is_valid(buf)
            or not vim.api.nvim_win_is_valid(win)
            or vim.fn.win_gettype(win) ~= ""
            or vim.wo[win].diff
            or vim.api.nvim_win_get_config(win).zindex
          then
            return false
          end
          local ft = vim.bo[buf].filetype
          local disabled = { "neo-tree", "dashboard", "alpha", "TelescopePrompt", "lazy", "mason" }
          for _, d in ipairs(disabled) do
            if ft == d then
              return false
            end
          end
          return vim.bo[buf].buftype == "" and vim.api.nvim_buf_get_name(buf) ~= ""
        end,
      },
    }

    vim.keymap.set("n", "<leader>bp", function()
      require("dropbar.api").pick()
    end, { desc = "Breadcrumbs pick" })
  end,
}
