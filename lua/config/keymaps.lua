local keymap = vim.keymap

local is_mac = vim.fn.has "macunix" == 1
local mod_key = is_mac and "D" or "A"

local function alt_or_cmd(lhs)
  return "<" .. mod_key .. "-" .. lhs .. ">"
end

local function telescope()
  return require "telescope.builtin"
end

local function refactoring()
  return require "refactoring"
end

-- General
keymap.set("n", "<Esc>", "<cmd>nohlsearch<CR>", { desc = "Clear search highlight" })

-- Window focus
keymap.set("n", "<C-h>", "<C-w>h", { desc = "Focus left window" })
keymap.set("n", "<C-l>", "<C-w>l", { desc = "Focus right window" })
keymap.set("n", "<C-j>", "<C-w>j", { desc = "Focus down window" })
keymap.set("n", "<C-k>", "<C-w>k", { desc = "Focus up window" })

-- Telescope
-- LSP
keymap.set("n", "<leader>fr", function()
  telescope().lsp_references()
end, { desc = "LSP References" })

keymap.set("n", "<leader>fa", function()
  telescope().lsp_completions()
end, { desc = "LSP Completion" })

keymap.set("n", "<leader>fd", function()
  telescope().lsp_definitions()
end, { desc = "LSP Definitions" })

keymap.set("n", "<leader>fl", function()
  telescope().lsp_incoming_calls()
end, { desc = "LSP Incoming calls" })

keymap.set("n", "<leader>fh", function()
  telescope().lsp_outgoing_calls()
end, { desc = "LSP Outgoing calls" })

keymap.set("n", "<leader>fe", function()
  telescope().diagnostics { bufnr = nil }
end, { desc = "LSP Workspace Diagnostics" })

-- Vim
keymap.set("n", "<leader>fk", function()
  telescope().keymaps()
end, { desc = "Keymaps" })

-- Git
keymap.set("n", "<leader>fc", function()
  telescope().git_commits()
end, { desc = "Git Commits" })

keymap.set("n", "<leader>fw", function()
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

keymap.set("n", "<leader>ff", function()
  telescope().live_grep()
end, { desc = "Live Grep" })

keymap.set("n", "<leader>f/", function()
  telescope().current_buffer_fuzzy_find()
end, { desc = "Fuzzy in current buffer" })

-- Tabs
keymap.set("n", alt_or_cmd "h", "<Cmd>BufferPrevious<CR>", { desc = "Previous buffer" })
keymap.set("n", alt_or_cmd "l", "<Cmd>BufferNext<CR>", { desc = "Next buffer" })
keymap.set("n", alt_or_cmd "x", "<Cmd>BufferClose<CR>", { desc = "Close buffer" })
keymap.set("n", alt_or_cmd "xa", "<Cmd>BufferCloseAllButCurrent<CR>", { desc = "Close all but current buffer" })

for i = 1, 9 do
  keymap.set("n", alt_or_cmd(tostring(i)), "<Cmd>BufferGoto " .. i .. "<CR>", { desc = "Go to buffer " .. i })
end
keymap.set("n", alt_or_cmd "0", "<Cmd>BufferLast<CR>", { desc = "Go to last buffer" })

-- Refactoring
keymap.set("n", "<leader>rr", function()
  refactoring().select_refactor()
end, { desc = "Refactor" })

keymap.set({ "n", "x" }, "<leader>re", function()
  refactoring().refactor "Extract Function"
end, { desc = "Extract function" })

keymap.set({ "n", "x" }, "<leader>rw", function()
  refactoring().refactor "Extract Function To File"
end, { desc = "Extract function to file" })

keymap.set({ "n", "x" }, "<leader>ri", function()
  refactoring().refactor "Extract Variable"
end, { desc = "Extract variable" })

keymap.set({ "n", "x" }, "<leader>ro", function()
  refactoring().refactor "Inline Variable"
end, { desc = "Inline variable" })

keymap.set({ "n", "x" }, "<leader>ru", function()
  refactoring().refactor "Inline Function"
end, { desc = "Inline function" })

keymap.set({ "n", "x" }, "<leader>rj", function()
  refactoring().refactor "Extract Block"
end, { desc = "Extract block" })

keymap.set({ "n", "x" }, "<leader>rk", function()
  refactoring().refactor "Extract Block To File"
end, { desc = "Extract block to file" })

-- LSP
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
    map("n", "<leader>de", vim.lsp.buf.rename, "Rename")
    map({ "n", "v" }, "<leader>ds", vim.lsp.buf.code_action, "Code action")
    map("n", "<leader>dx", vim.diagnostic.open_float, "Line diagnostics")
    map("n", "<leader>dh", vim.diagnostic.goto_prev, "Prev diagnostic")
    map("n", "<leader>dl", vim.diagnostic.goto_next, "Next diagnostic")
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

  -- Actions: <leader>h + lowercase
  map("n", "<leader>hs", gs.stage_hunk, { desc = "Stage hunk" })
  map("n", "<leader>hr", gs.reset_hunk, { desc = "Reset hunk" })

  map("v", "<leader>hs", function()
    gs.stage_hunk { vim.fn.line ".", vim.fn.line "v" }
  end, { desc = "Stage hunk" })

  map("v", "<leader>hr", function()
    gs.reset_hunk { vim.fn.line ".", vim.fn.line "v" }
  end, { desc = "Reset hunk" })

  map("n", "<leader>ha", gs.stage_buffer, { desc = "Stage buffer" }) -- a = all
  map("n", "<leader>hu", gs.undo_stage_hunk, { desc = "Undo stage hunk" })
  map("n", "<leader>hr", gs.reset_buffer, { desc = "Reset buffer" }) -- x = drop
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

  -- Text object
  map({ "o", "x" }, "hi", ":<C-U>Gitsigns select_hunk<CR>", { desc = "Select hunk" })
end

-- NvimTree
keymap.set("n", "<leader>ep", ":NvimTreeToggle<CR>", { desc = "Toggle Nvim-tree" })

-- Insert mode navigation
keymap.set("i", "<C-h>", "<Left>", { desc = "Left (insert)" })
keymap.set("i", "<C-l>", "<Right>", { desc = "Right (insert)" })
keymap.set("i", "<C-j>", "<Down>", { desc = "Down (insert)" })
keymap.set("i", "<C-k>", "<Up>", { desc = "Up (insert)" })

-- VM: select next/skip + add cursor above/below
keymap.set("n", alt_or_cmd "n", "<Plug>(VM-Find-Under)", { desc = "VM: Select next occurrence" })
keymap.set("x", alt_or_cmd "n", "<Plug>(VM-Find-Subword-Under)", { desc = "VM: Select next occurrence" })

keymap.set("n", alt_or_cmd "j", "<Plug>(VM-Add-Cursor-Down)", { desc = "VM: Add cursor below" })
keymap.set("n", alt_or_cmd "k", "<Plug>(VM-Add-Cursor-Up)", { desc = "VM: Add cursor above" })
keymap.set("x", alt_or_cmd "j", "<Plug>(VM-Add-Cursor-Down)", { desc = "VM: Add cursor below" })
keymap.set("x", alt_or_cmd "k", "<Plug>(VM-Add-Cursor-Up)", { desc = "VM: Add cursor above" })

return M
