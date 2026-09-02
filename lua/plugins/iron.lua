return {
  {
    "Vigemus/iron.nvim",
    ft = { "lua", "javascript", "javascriptreact", "typescript", "typescriptreact", "clojure" },
    cmd = { "IronRepl", "IronReplHere", "IronRestart", "IronFocus", "IronHide", "IronSend", "IronWatch", "IronAttach" },
    config = function()
      local iron = require "iron.core"
      local view = require "iron.view"
      local common = require "iron.fts.common"

      local node = {
        command = { "node" },
        open = ".editor\n",
        close = "\04",
      }

      local deno = {
        command = { "deno", "repl", "-q", "--allow-all" },
        format = common.bracketed_paste,
      }

      local function clojure_command(meta)
        local buf_name = vim.api.nvim_buf_get_name(meta.current_bufnr)
        local dir = buf_name ~= "" and vim.fs.dirname(buf_name) or vim.fn.getcwd()

        if vim.fs.root(dir, { "deps.edn", "bb.edn" }) then
          return { "clj" }
        end
        if vim.fs.root(dir, { "project.clj" }) then
          return { "lein", "repl" }
        end
        if vim.fs.root(dir, { "build.boot" }) then
          return { "boot", "repl" }
        end

        return vim.fn.executable "clj" == 1 and { "clj" } or { "lein", "repl" }
      end

      iron.setup {
        config = {
          scratch_repl = true,
          close_window_on_exit = true,
          repl_open_cmd = view.split.vertical.botright(0.4),
          repl_definition = {
            lua = { command = { "lua" } },

            javascript = node,
            javascriptreact = node,

            typescript = deno,
            typescriptreact = deno,

            clojure = { command = clojure_command },
          },
        },
        keymaps = {
          toggle_repl = "<leader>ir",
          restart_repl = "<leader>iR",
          send_file = "<leader>if",
          send_line = "<leader>il",
          send_paragraph = "<leader>ip",
          send_until_cursor = "<leader>iu",
          send_code_block = "<leader>ib",
          send_code_block_and_move = "<leader>in",
          send_motion = "<leader>is",
          visual_send = "<leader>is",
          send_mark = "<leader>im",
          mark_motion = "<leader>iM",
          mark_visual = "<leader>iM",
          remove_mark = "<leader>id",
          cr = "<leader>i<CR>",
          interrupt = "<leader>i<Space>",
          exit = "<leader>iq",
          clear = "<leader>ic",
        },
        highlight = { italic = true },
        ignore_blank_lines = true,
      }
    end,
  },
}
