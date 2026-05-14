return {
  "mistweaverco/kulala.nvim",
  ft = { "http", "rest" },
  opts = {
    default_view = "body",
    default_env = "dev",
    debug = false,
    winbar = true,
    show_icons = "on_request",
  },
  config = function(_, opts)
    require("kulala").setup(opts)

    vim.api.nvim_create_autocmd("FileType", {
      pattern = { "http", "rest" },
      callback = function(ev)
        local k = require "kulala"
        local map = function(lhs, rhs, desc)
          vim.keymap.set("n", lhs, rhs, { buffer = ev.buf, desc = desc })
        end

        map("<leader>qr", k.run, "Run nearest request")
        map("<leader>qa", k.run_all, "Run all requests in file")
        map("<leader>ql", k.replay, "Replay last request")
        map("<leader>qi", k.inspect, "Inspect parsed request")
        map("<leader>qc", k.copy, "Copy as curl")
        map("<leader>qp", k.from_curl, "Paste curl as http")
        map("<leader>qt", k.toggle_view, "Toggle body/headers view")
        map("<leader>qx", k.close, "Close response window")
        map("]q", k.jump_next, "Next request in file")
        map("[q", k.jump_prev, "Previous request in file")
      end,
    })

    vim.keymap.set("n", "<leader>qs", function()
      require("kulala").scratchpad()
    end, { desc = "HTTP scratchpad" })
  end,
}
