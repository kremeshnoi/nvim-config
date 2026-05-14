return {
  "nvim-lualine/lualine.nvim",
  event = "VeryLazy",
  dependencies = { "nvim-tree/nvim-web-devicons" },
  config = function()
    local lualine = require "lualine"

    local macro_recording = {
      function()
        local reg = vim.fn.reg_recording()
        if reg == "" then
          return ""
        end
        return "recording @" .. reg
      end,
      color = { fg = "#ff5555", gui = "bold" },
    }

    local search_count = {
      function()
        if vim.v.hlsearch == 0 then
          return ""
        end
        local ok, result = pcall(vim.fn.searchcount, { maxcount = 999, timeout = 250 })
        if not ok or not result.total or result.total == 0 then
          return ""
        end
        return string.format("%d/%d", result.current, result.total)
      end,
      icon = "",
    }

    local lazy_updates = {
      require("lazy.status").updates,
      cond = require("lazy.status").has_updates,
      color = { fg = "#ff9e64" },
    }

    local lsp_clients = {
      function()
        local clients = vim.lsp.get_clients { bufnr = 0 }
        if #clients == 0 then
          return ""
        end
        local names = {}
        for _, c in ipairs(clients) do
          table.insert(names, c.name)
        end
        return " " .. table.concat(names, ", ")
      end,
    }

    local filename = {
      "filename",
      path = 1,
      symbols = {
        modified = " ●",
        readonly = " ",
        unnamed = "[No Name]",
      },
    }

    local diagnostics = {
      "diagnostics",
      sources = { "nvim_diagnostic" },
      symbols = { error = " ", warn = " ", info = " ", hint = " " },
      update_in_insert = false,
    }

    local diff = {
      "diff",
      symbols = { added = " ", modified = " ", removed = " " },
    }

    lualine.setup {
      options = {
        theme = "vscode",
        globalstatus = true,
        section_separators = { left = "", right = "" },
        component_separators = { left = "", right = "" },
        disabled_filetypes = {
          statusline = { "dashboard", "alpha", "neo-tree" },
          winbar = {},
        },
      },
      sections = {
        lualine_a = { "mode" },
        lualine_b = { "branch", diff, diagnostics },
        lualine_c = { filename, macro_recording, search_count },
        lualine_x = { lazy_updates, lsp_clients, "encoding", "fileformat", "filetype" },
        lualine_y = { "progress" },
        lualine_z = { "location" },
      },
      inactive_sections = {
        lualine_a = {},
        lualine_b = {},
        lualine_c = { filename },
        lualine_x = { "location" },
        lualine_y = {},
        lualine_z = {},
      },
      extensions = { "neo-tree", "lazy", "mason", "quickfix" },
    }
  end,
}
