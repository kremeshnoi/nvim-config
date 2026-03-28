local keymap = vim.keymap

local function telescope()
  return require "telescope.builtin"
end

local function refactoring()
  return require "refactoring"
end

local function fugitive(cmd)
  return function()
    require("lazy").load { plugins = { "vim-fugitive" } }
    vim.cmd(cmd)
  end
end

-- General
keymap.set("n", "<Esc>", "<cmd>nohlsearch<CR>", { desc = "Clear search highlight" })

-- Buffers (C-h/l/x/a in normal mode)
keymap.set("n", "<C-h>", "<cmd>bprev<CR>", { desc = "Previous buffer" })
keymap.set("n", "<C-l>", "<cmd>bnext<CR>", { desc = "Next buffer" })
keymap.set("n", "<C-x>", "<cmd>bdelete<CR>", { desc = "Close buffer" })
keymap.set("n", "<C-a>", "<cmd>%bd|e#|bd#<CR>", { desc = "Close all but current" })

-- Multi-cursor (C-n/j/k in normal/visual mode)
keymap.set("n", "<C-n>", "<Plug>(VM-Find-Under)", { desc = "VM: Select next occurrence" })
keymap.set("x", "<C-n>", "<Plug>(VM-Find-Subword-Under)", { desc = "VM: Select next occurrence" })
keymap.set("n", "<C-j>", "<Plug>(VM-Add-Cursor-Down)", { desc = "VM: Add cursor below" })
keymap.set("n", "<C-k>", "<Plug>(VM-Add-Cursor-Up)", { desc = "VM: Add cursor above" })
keymap.set("x", "<C-j>", "<Plug>(VM-Add-Cursor-Down)", { desc = "VM: Add cursor below" })
keymap.set("x", "<C-k>", "<Plug>(VM-Add-Cursor-Up)", { desc = "VM: Add cursor above" })

-- Window splits (leader+w)
keymap.set("n", "<leader>wl", "<cmd>vnew<CR>", { desc = "New split right" })
keymap.set("n", "<leader>wj", "<cmd>below new<CR>", { desc = "New split below" })
keymap.set("n", "<leader>wk", "<cmd>above new<CR>", { desc = "New split above" })

-- Last window
keymap.set("n", "<leader>;", "<C-w>p", { desc = "Last window" })

-- Find (leader+f) — Telescope
keymap.set("n", "<leader>ff", function()
  telescope().live_grep()
end, { desc = "Find (live grep)" })

keymap.set("n", "<leader>fu", function()
  telescope().lsp_references()
end, { desc = "Find Usages" })

keymap.set("n", "<leader>fe", function()
  telescope().builtin()
end, { desc = "Search Everywhere" })

keymap.set("n", "<leader>fa", function()
  telescope().commands()
end, { desc = "Go to Action" })

keymap.set("n", "<leader>fo", function()
  telescope().find_files()
end, { desc = "Go to File" })

keymap.set("n", "<leader>fc", function()
  telescope().lsp_document_symbols()
end, { desc = "Go to Class/Symbol (document)" })

keymap.set("n", "<leader>fb", function()
  telescope().lsp_workspace_symbols()
end, { desc = "Go to Symbol (workspace)" })

keymap.set("n", "<leader>f/", function()
  telescope().current_buffer_fuzzy_find()
end, { desc = "Fuzzy in current buffer" })

keymap.set("n", "<leader>fk", function()
  telescope().keymaps()
end, { desc = "Keymaps" })

-- Refactoring (leader+r)
keymap.set("n", "<leader>rr", function()
  require("grug-far").open { prefills = { paths = vim.fn.expand "%" } }
end, { desc = "Replace (current file)" })

keymap.set("n", "<leader>rp", function()
  require("grug-far").open()
end, { desc = "Replace in Path (project)" })

keymap.set("n", "<leader>re", vim.lsp.buf.rename, { desc = "Rename Element" })

keymap.set("n", "<leader>ro", function()
  local old = vim.fn.expand "%:p"
  local new = vim.fn.input("New name: ", vim.fn.expand "%:t")
  if new == "" or new == vim.fn.expand "%:t" then
    return
  end
  local dir = vim.fn.expand "%:p:h"
  local new_path = dir .. "/" .. new
  vim.lsp.util.rename(old, new_path)
end, { desc = "Rename File" })

keymap.set({ "n", "x" }, "<leader>rl", function()
  refactoring().refactor "Inline Variable"
end, { desc = "Inline" })

keymap.set({ "n", "x" }, "<leader>rm", function()
  refactoring().refactor "Extract Function To File"
end, { desc = "Move (extract to file)" })

keymap.set({ "n", "x" }, "<leader>rv", function()
  refactoring().refactor "Extract Variable"
end, { desc = "Extract variable" })

keymap.set({ "n", "x" }, "<leader>rf", function()
  refactoring().refactor "Extract Function"
end, { desc = "Extract function" })

keymap.set({ "n", "x" }, "<leader>rb", function()
  refactoring().refactor "Extract Block"
end, { desc = "Extract block" })

keymap.set({ "n", "x" }, "<leader>R", function()
  refactoring().select_refactor()
end, { desc = "Select refactor" })

-- LSP (leader+d)
vim.api.nvim_create_autocmd("LspAttach", {
  group = vim.api.nvim_create_augroup("UserLspConfig", {}),
  callback = function(ev)
    local opts = { buffer = ev.buf, silent = true }

    local map = function(mode, lhs, rhs, desc)
      opts.desc = desc
      keymap.set(mode, lhs, rhs, opts)
    end

    map("n", "<leader>dd", vim.lsp.buf.definition, "Go to definition")
    map("n", "<leader>da", vim.lsp.buf.declaration, "Go to declaration")
    map("n", "<leader>dr", function()
      require("telescope.builtin").lsp_references()
    end, "References")
    map("n", "<leader>di", function()
      require("telescope.builtin").lsp_implementations()
    end, "Implementation")
    map("n", "<leader>dk", vim.lsp.buf.hover, "Hover")
    map({ "n", "v" }, "<leader>ds", vim.lsp.buf.code_action, "Code action")
    map("n", "<leader>dx", vim.diagnostic.open_float, "Line diagnostics")
    map("n", "<leader>dh", vim.diagnostic.goto_prev, "Prev diagnostic")
    map("n", "<leader>dl", vim.diagnostic.goto_next, "Next diagnostic")
  end,
})

-- Git (leader+g + standalone)
keymap.set("n", "<leader>gg", fugitive "Git", { desc = "Git status (fugitive)" })
keymap.set("n", "<leader>gc", fugitive "Git commit", { desc = "Git commit" })
keymap.set("n", "<leader>u", fugitive "Git pull", { desc = "Git pull (update)" })
keymap.set("n", "<leader>p", fugitive "Git push", { desc = "Git push" })

-- Git telescope
keymap.set("n", "<leader>gs", function()
  telescope().git_status()
end, { desc = "Git Status" })

keymap.set("n", "<leader>gl", function()
  telescope().git_commits()
end, { desc = "Git Commits" })

keymap.set("n", "<leader>gw", function()
  telescope().git_bcommits()
end, { desc = "Git Buffer Commits" })

keymap.set("n", "<leader>gb", function()
  telescope().git_branches()
end, { desc = "Git Branches" })

-- Git hunks (leader+h)
local M = {}

M.gitsigns_on_attach = function(bufnr)
  local gs = package.loaded.gitsigns
  local gitsigns_keymap = vim.keymap

  local function map(mode, l, r, opts)
    opts = opts or {}
    opts.buffer = bufnr
    gitsigns_keymap.set(mode, l, r, opts)
  end

  map("n", "<leader>hl", function()
    if vim.wo.diff then
      return "]c"
    end
    vim.schedule(gs.next_hunk)
    return "<Ignore>"
  end, { expr = true, desc = "Next hunk" })

  map("n", "<leader>hh", function()
    if vim.wo.diff then
      return "[c"
    end
    vim.schedule(gs.prev_hunk)
    return "<Ignore>"
  end, { expr = true, desc = "Prev hunk" })

  map("n", "<leader>hs", gs.stage_hunk, { desc = "Stage hunk" })
  map("n", "<leader>hr", gs.reset_hunk, { desc = "Reset hunk" })

  map("v", "<leader>hs", function()
    gs.stage_hunk { vim.fn.line ".", vim.fn.line "v" }
  end, { desc = "Stage hunk" })

  map("v", "<leader>hr", function()
    gs.reset_hunk { vim.fn.line ".", vim.fn.line "v" }
  end, { desc = "Reset hunk" })

  map("n", "<leader>ha", gs.stage_buffer, { desc = "Stage buffer" })
  map("n", "<leader>hu", gs.undo_stage_hunk, { desc = "Undo stage hunk" })
  map("n", "<leader>hp", gs.preview_hunk, { desc = "Preview hunk" })

  map("n", "<leader>hb", function()
    gs.blame_line { full = true }
  end, { desc = "Blame line" })

  map("n", "<leader>ht", gs.toggle_current_line_blame, { desc = "Toggle line blame" })

  map("n", "<leader>hd", gs.diffthis, { desc = "Diff this" })
  map("n", "<leader>hw", function()
    gs.diffthis "~"
  end, { desc = "Diff against HEAD~" })

  map("n", "<leader>hz", gs.toggle_deleted, { desc = "Toggle deleted" })

  map({ "o", "x" }, "hi", ":<C-U>Gitsigns select_hunk<CR>", { desc = "Select hunk" })
end

-- Tools (leader+e)
keymap.set("n", "<leader>ep", "<cmd>NvimTreeToggle<CR>", { desc = "Project (NvimTree)" })


keymap.set("n", "<leader>ef", function()
  telescope().oldfiles { only_cwd = true }
end, { desc = "Recent Files" })

keymap.set("n", "<leader>el", function()
  telescope().diagnostics { bufnr = nil }
end, { desc = "Problems (diagnostics)" })

keymap.set("n", "<leader>et", "<cmd>TodoTelescope<CR>", { desc = "TODO" })

keymap.set("n", "<leader>eq", "<cmd>q<CR>", { desc = "Close window" })

return M
