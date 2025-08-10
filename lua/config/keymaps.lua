local keymap = vim.keymap

-- Lazy-safe telescope accessor
local function telescope()
  return require "telescope.builtin"
end

-- General
keymap.set("n", "<Esc>", "<cmd>nohlsearch<CR>", { desc = "Clear search highlight" })

-- Open URL under cursor (Linux)
keymap.set("n", "gx", "<cmd>silent !xdg-open <cfile> &<CR>", { desc = "Open URL under cursor" })

-- Window focus
keymap.set("n", "<C-h>", "<C-w>h", { desc = "Focus left window" })
keymap.set("n", "<C-l>", "<C-w>l", { desc = "Focus right window" })
keymap.set("n", "<C-j>", "<C-w>j", { desc = "Focus down window" })
keymap.set("n", "<C-k>", "<C-w>k", { desc = "Focus up window" })

-- Telescope: two-letter "f*" layer
-- LSP Pickers
keymap.set("n", "<leader>fr", function()
  telescope().lsp_references()
end, { desc = "LSP References" })

keymap.set("n", "<leader>fa", function()
  telescope().lsp_completions()
end, { desc = "LSP Completion" })

keymap.set("n", "<leader>fd", function()
  telescope().lsp_definitions()
end, { desc = "LSP Definitions" })

keymap.set("n", "<leader>f1", function()
  telescope().lsp_incoming_calls()
end, { desc = "LSP Incoming calls" })

keymap.set("n", "<leader>f0", function()
  telescope().lsp_outgoing_calls()
end, { desc = "LSP Outgoing calls" })

keymap.set("n", "<leader>fe", function()
  telescope().diagnostics { bufnr = 0 }
end, { desc = "LSP Document Diagnostics" })

keymap.set("n", "<leader>fee", function()
  telescope().diagnostics { bufnr = nil }
end, { desc = "LSP Workspace Diagnostics" })

-- Vim Pickers
keymap.set("n", "<leader>fk", function()
  telescope().keymaps()
end, { desc = "Keymaps" })

-- Git Pickers
keymap.set("n", "<leader>fcc", function()
  telescope().git_commits()
end, { desc = "Git Commits" })

keymap.set("n", "<leader>fc", function()
  telescope().git_bcommits()
end, { desc = "Git Buffer Commits" })

keymap.set("n", "<leader>fb", function()
  telescope().git_branches()
end, { desc = "Git Branches" })

keymap.set("n", "<leader>fs", function()
  telescope().git_status()
end, { desc = "Git Status" })

-- File Pickers
keymap.set("n", "<leader>fo", function()
  telescope().find_files()
end, { desc = "Find Files" })

keymap.set("n", "<leader>fq", function()
  telescope().git_files()
end, { desc = "Git Files" })

keymap.set("n", "<leader>fp", function()
  telescope().grep_string()
end, { desc = "Grep String" })

keymap.set("n", "<leader>ff", function()
  telescope().live_grep()
end, { desc = "Live Grep" })

keymap.set("n", "<leader>f/", function()
  telescope().current_buffer_fuzzy_find()
end, { desc = "Fuzzy in current buffer" })

-- Tabs
keymap.set("n", "<A-,>", "<Cmd>BufferPrevious<CR>", { desc = "Previous buffer" })
keymap.set("n", "<A-.>", "<Cmd>BufferNext<CR>", { desc = "Next buffer" })
keymap.set("n", "<A-c>", "<Cmd>BufferClose<CR>", { desc = "Close buffer" })
keymap.set("n", "<A-cx>", "<Cmd>BufferCloseAllButCurrent<CR>", { desc = "Close all but current buffer" })

for i = 1, 9 do
  keymap.set("n", "<A-" .. i .. ">", "<Cmd>BufferGoto " .. i .. "<CR>", { desc = "Go to buffer " .. i })
end
keymap.set("n", "<A-0>", "<Cmd>BufferLast<CR>", { desc = "Go to last buffer" })

-- Git
keymap.set("n", "<leader>gb", ":GitBlameToggle<CR>", { desc = "Toggle git blame" })

-- Refactoring
keymap.set("n", "<leader>rr", function()
  require("refactoring").select_refactor()
end, { desc = "Refactor" })

-- LSP
vim.api.nvim_create_autocmd("LspAttach", {
  group = vim.api.nvim_create_augroup("UserLspConfig", {}),
  callback = function(ev)
    local opts = { buffer = ev.buf, silent = true }

    local map = function(mode, lhs, rhs, desc)
      opts.desc = desc
      keymap.set(mode, lhs, rhs, opts)
    end

    map("n", "<leader>d", vim.lsp.buf.definition, "Go to definition")
    map("n", "<leader>dd", vim.lsp.buf.declaration, "Go to declaration")
    map("n", "<leader>dr", function()
      require("telescope.builtin").lsp_references()
    end, "References")
    map("n", "<leader>di", function()
      require("telescope.builtin").lsp_implementations()
    end, "Implementation")
    map("n", "<leader>dk", vim.lsp.buf.hover, "Hover")
    map("n", "<leader>dr", vim.lsp.buf.rename, "Rename")
    map({ "n", "v" }, "<leader>da", vim.lsp.buf.code_action, "Code action")
    map("n", "<leader>de", vim.diagnostic.open_float, "Line diagnostics")
    map("n", "<leader>[d", vim.diagnostic.goto_prev, "Prev diagnostic")
    map("n", "<leader>]d", vim.diagnostic.goto_next, "Next diagnostic")
  end,
})

local M = {}

M.gitsigns_on_attach = function(bufnr)
  local gs = package.loaded.gitsigns
  local keymap = vim.keymap

  local function map(mode, l, r, opts)
    opts = opts or {}
    opts.buffer = bufnr
    keymap.set(mode, l, r, opts)
  end

  -- Navigation
  map("n", "]c", function()
    if vim.wo.diff then
      return "]c"
    end
    vim.schedule(gs.next_hunk)
    return "<Ignore>"
  end, { expr = true, desc = "Next hunk" })

  map("n", "[c", function()
    if vim.wo.diff then
      return "[c"
    end
    vim.schedule(gs.prev_hunk)
    return "<Ignore>"
  end, { expr = true, desc = "Prev hunk" })

  -- Actions: <leader>gh + lowercase
  map("n", "<leader>ghs", gs.stage_hunk, { desc = "Stage hunk" })
  map("n", "<leader>ghr", gs.reset_hunk, { desc = "Reset hunk" })

  map("v", "<leader>ghs", function()
    gs.stage_hunk { vim.fn.line ".", vim.fn.line "v" }
  end, { desc = "Stage hunk" })

  map("v", "<leader>ghr", function()
    gs.reset_hunk { vim.fn.line ".", vim.fn.line "v" }
  end, { desc = "Reset hunk" })

  map("n", "<leader>gha", gs.stage_buffer, { desc = "Stage buffer" }) -- a = all
  map("n", "<leader>ghu", gs.undo_stage_hunk, { desc = "Undo stage hunk" })
  map("n", "<leader>ghx", gs.reset_buffer, { desc = "Reset buffer" }) -- x = drop
  map("n", "<leader>ghp", gs.preview_hunk, { desc = "Preview hunk" })

  map("n", "<leader>ghb", function()
    gs.blame_line { full = true }
  end, { desc = "Blame line" })

  map("n", "<leader>ght", gs.toggle_current_line_blame, { desc = "Toggle line blame" })

  map("n", "<leader>ghd", gs.diffthis, { desc = "Diff this" })
  map("n", "<leader>ghw", function()
    gs.diffthis "~"
  end, { desc = "Diff against HEAD~" })

  map("n", "<leader>ghz", gs.toggle_deleted, { desc = "Toggle deleted" })

  -- Text object
  map({ "o", "x" }, "ih", ":<C-U>Gitsigns select_hunk<CR>", { desc = "Select hunk" })
end

-- NvimTree
keymap.set("n", "<leader>ep", ":NvimTreeToggle<CR>", { desc = "Toggle Nvim-tree" })

-- Insert mode navigation
keymap.set("i", "<C-h>", "<Left>", { desc = "Left (insert)" })
keymap.set("i", "<C-l>", "<Right>", { desc = "Right (insert)" })
keymap.set("i", "<C-j>", "<Down>", { desc = "Down (insert)" })
keymap.set("i", "<C-k>", "<Up>", { desc = "Up (insert)" })

-- VM: select next/skip + add cursor above/below
keymap.set("n", "<A-n>", "<Plug>(VM-Find-Under)", { desc = "VM: Select next occurrence" })
keymap.set("x", "<A-n>", "<Plug>(VM-Find-Subword-Under)", { desc = "VM: Select next occurrence" })

keymap.set("n", "<A-j>", "<Plug>(VM-Add-Cursor-Down)", { desc = "VM: Add cursor below" })
keymap.set("n", "<A-k>", "<Plug>(VM-Add-Cursor-Up)", { desc = "VM: Add cursor above" })
keymap.set("x", "<A-j>", "<Plug>(VM-Add-Cursor-Down)", { desc = "VM: Add cursor below" })
keymap.set("x", "<A-k>", "<Plug>(VM-Add-Cursor-Up)", { desc = "VM: Add cursor above" })

return M
