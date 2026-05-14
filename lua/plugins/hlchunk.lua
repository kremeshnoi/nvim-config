return {
  "shellRaining/hlchunk.nvim",
  event = { "BufReadPre", "BufNewFile" },
  config = function()
    local ChunkMod = require "hlchunk.mods.chunk"
    local cFunc = require "hlchunk.utils.cFunc"
    local Scope = require "hlchunk.utils.scope"
    local orig_render = ChunkMod.render
    ChunkMod.render = function(self, range, opts)
      local beg_blank_len = cFunc.get_indent(range.bufnr, range.start)
      local end_blank_len = cFunc.get_indent(range.bufnr, range.finish)
      if beg_blank_len == 0 and end_blank_len == 0 then
        self:stopRender()
        self:clear(Scope(range.bufnr, 0, vim.api.nvim_buf_line_count(range.bufnr)))
        self:updatePreState({}, {}, {}, false)
        return
      end
      return orig_render(self, range, opts)
    end

    require("hlchunk").setup {
      chunk = {
        enable = true,
        notify = false,
        use_treesitter = true,
        chars = {
          horizontal_line = "─",
          vertical_line = "│",
          left_top = "╭",
          left_bottom = "╰",
          right_arrow = "─",
        },
        style = {
          { fg = "#806d9c" },
          { fg = "#c21f30" },
        },
        delay = 0,
        exclude_filetypes = {
          ["neo-tree"] = true,
          TelescopePrompt = true,
          TelescopeResults = true,
          lazy = true,
          mason = true,
          NeogitStatus = true,
          NeogitCommitMessage = true,
          NeogitPopup = true,
          gitcommit = true,
          help = true,
          checkhealth = true,
          dropbar_menu = true,
          notify = true,
          noice = true,
          dashboard = true,
          alpha = true,
        },
      },
      indent = { enable = false },
      line_num = { enable = false },
      blank = { enable = false },
    }
  end,
}
