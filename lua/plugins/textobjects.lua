return {
  "nvim-treesitter/nvim-treesitter-textobjects",
  branch = "main",
  dependencies = { "nvim-treesitter/nvim-treesitter" },
  event = "VeryLazy",
  config = function()
    require("nvim-treesitter-textobjects").setup {
      select = {
        lookahead = true,
        include_surrounding_whitespace = false,
      },
      move = {
        set_jumps = true,
      },
    }

    local select = require("nvim-treesitter-textobjects.select").select_textobject
    local move = require "nvim-treesitter-textobjects.move"

    local function sel(query)
      return function()
        select(query, "textobjects")
      end
    end

    -- Text objects: af/if = function, ac/ic = class, aa/ia = parameter
    vim.keymap.set({ "x", "o" }, "af", sel "@function.outer", { desc = "a function" })
    vim.keymap.set({ "x", "o" }, "if", sel "@function.inner", { desc = "inner function" })
    vim.keymap.set({ "x", "o" }, "ac", sel "@class.outer", { desc = "a class" })
    vim.keymap.set({ "x", "o" }, "ic", sel "@class.inner", { desc = "inner class" })
    vim.keymap.set({ "x", "o" }, "aa", sel "@parameter.outer", { desc = "a parameter/argument" })
    vim.keymap.set({ "x", "o" }, "ia", sel "@parameter.inner", { desc = "inner parameter/argument" })

    -- Jumps between functions/classes
    vim.keymap.set("n", "]f", function()
      move.goto_next_start("@function.outer", "textobjects")
    end, { desc = "Next function start" })
    vim.keymap.set("n", "[f", function()
      move.goto_previous_start("@function.outer", "textobjects")
    end, { desc = "Prev function start" })
    vim.keymap.set("n", "]F", function()
      move.goto_next_end("@function.outer", "textobjects")
    end, { desc = "Next function end" })
    vim.keymap.set("n", "[F", function()
      move.goto_previous_end("@function.outer", "textobjects")
    end, { desc = "Prev function end" })
  end,
}
