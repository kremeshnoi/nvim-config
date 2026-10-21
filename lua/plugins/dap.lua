return {
  "mfussenegger/nvim-dap",
  lazy = true,
  dependencies = {
    {
      "igorlfs/nvim-dap-view",
      version = "1.*",
      opts = {
        auto_toggle = true,
        virtual_text = { enabled = true },
      },
    },
  },
  config = function()
    vim.fn.sign_define("DapBreakpoint", { text = "●", texthl = "DiagnosticError" })
    vim.fn.sign_define("DapBreakpointCondition", { text = "◆", texthl = "DiagnosticWarn" })
    vim.fn.sign_define("DapLogPoint", { text = "◉", texthl = "DiagnosticInfo" })
    vim.fn.sign_define("DapStopped", { text = "▶", texthl = "DiagnosticOk", linehl = "Visual" })
    vim.fn.sign_define("DapBreakpointRejected", { text = "○", texthl = "DiagnosticHint" })
  end,
}
