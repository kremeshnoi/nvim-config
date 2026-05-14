local M = {}

return {
  "kndndrj/nvim-dbee",
  dependencies = { "MunifTanjim/nui.nvim" },
  cmd = { "Dbee", "DbeeToggle", "DbeeOpen", "DbeeClose" },
  build = function()
    require("dbee").install()
  end,
  keys = {
    {
      "<leader>bb",
      function()
        require("dbee").toggle()
      end,
      desc = "Toggle DB UI (dbee)",
    },
    {
      "<leader>bo",
      function()
        require("dbee").open()
      end,
      desc = "Open DB UI",
    },
    {
      "<leader>bc",
      function()
        require("dbee").close()
      end,
      desc = "Close DB UI",
    },
    {
      "<leader>be",
      function()
        M.toggle_editor_float()
      end,
      desc = "Toggle floating SQL editor",
    },
    {
      "<leader>bx",
      function()
        require("dbee").execute(vim.fn.getline ".")
      end,
      desc = "Execute current line as query",
      mode = "n",
    },
    {
      "<leader>bx",
      function()
        local s = vim.fn.getpos "v"
        local e = vim.fn.getpos "."
        local lines = vim.api.nvim_buf_get_lines(0, math.min(s[2], e[2]) - 1, math.max(s[2], e[2]), false)
        require("dbee").execute(table.concat(lines, "\n"))
      end,
      desc = "Execute selection as query",
      mode = "x",
    },
  },
  config = function()
    local api_ui = require "dbee.api.ui"
    local tools = require "dbee.layouts.tools"

    local float_win = nil

    function M.toggle_editor_float()
      if float_win and vim.api.nvim_win_is_valid(float_win) then
        vim.api.nvim_win_close(float_win, true)
        float_win = nil
        return
      end

      local width = math.floor(vim.o.columns * 0.7)
      local height = math.floor(vim.o.lines * 0.7)
      local buf = vim.api.nvim_create_buf(false, true)
      float_win = vim.api.nvim_open_win(buf, true, {
        relative = "editor",
        width = width,
        height = height,
        row = math.floor((vim.o.lines - height) / 2),
        col = math.floor((vim.o.columns - width) / 2),
        style = "minimal",
        border = "rounded",
        title = " SQL ",
        title_pos = "center",
      })
      api_ui.editor_show(float_win)
    end

    local CustomLayout = {}
    CustomLayout.__index = CustomLayout

    function CustomLayout:new(opts)
      opts = opts or {}
      return setmetatable({
        drawer_width = opts.drawer_width or 40,
        result_ratio = opts.result_ratio or 0.8,
        windows = {},
        egg = nil,
        is_opened = false,
      }, self)
    end

    function CustomLayout:is_open()
      return self.is_opened
    end

    function CustomLayout:open()
      self.egg = tools.save()
      self.windows = {}

      tools.make_only(0)

      local total = vim.o.lines
      local result_h = math.floor(total * self.result_ratio)
      local call_log_h = math.max(total - result_h - 4, 3)

      local result_win = vim.api.nvim_get_current_win()
      api_ui.result_show(result_win)
      self.windows.result = result_win

      vim.cmd("belowright " .. call_log_h .. "split")
      local cl_win = vim.api.nvim_get_current_win()
      api_ui.call_log_show(cl_win)
      self.windows.call_log = cl_win

      vim.cmd("topleft " .. self.drawer_width .. "vsplit")
      local drawer_win = vim.api.nvim_get_current_win()
      api_ui.drawer_show(drawer_win)
      self.windows.drawer = drawer_win

      vim.api.nvim_win_set_height(result_win, result_h)
      vim.api.nvim_set_current_win(result_win)

      self.is_opened = true
    end

    function CustomLayout:reset()
      if self.windows.drawer and vim.api.nvim_win_is_valid(self.windows.drawer) then
        vim.api.nvim_win_set_width(self.windows.drawer, self.drawer_width)
      end
      if self.windows.result and vim.api.nvim_win_is_valid(self.windows.result) then
        vim.api.nvim_win_set_height(self.windows.result, math.floor(vim.o.lines * self.result_ratio))
      end
    end

    function CustomLayout:close()
      for _, win in pairs(self.windows) do
        pcall(vim.api.nvim_win_close, win, false)
      end
      if float_win and vim.api.nvim_win_is_valid(float_win) then
        pcall(vim.api.nvim_win_close, float_win, true)
        float_win = nil
      end
      tools.restore(self.egg)
      self.egg = nil
      self.is_opened = false
    end

    require("dbee").setup {
      drawer = {
        disable_candies = false,
      },
      result = {
        page_size = 100,
      },
      window_layout = CustomLayout:new {
        drawer_width = 40,
        result_ratio = 0.8,
      },
    }
  end,
}
