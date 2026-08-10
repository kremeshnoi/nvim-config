local keymap = vim.keymap

local is_mac = vim.fn.has "mac" == 1 or vim.fn.has "macunix" == 1

local function mod(lhs)
  if is_mac then
    return lhs
  end
  local m, rest = lhs:match "^<([CAM])%-(.+)$"
  if not m then
    return lhs
  end
  return (m == "C" and "<A-" or "<C-") .. rest
end

local function telescope()
  return require "telescope.builtin"
end

local function refactoring()
  return require "refactoring"
end

local function neogit(cmd)
  return function()
    require("lazy").load { plugins = { "neogit" } }
    vim.cmd(cmd)
  end
end

-- General
keymap.set("n", "<Esc>", "<cmd>nohlsearch<CR>", { desc = "Clear search highlight" })
keymap.set("n", "<leader>T", function()
  vim.wo.relativenumber = not vim.wo.relativenumber
end, { desc = "Toggle relative line numbers" })
keymap.set("n", "<leader>cp", "<cmd>Cfp<CR>", { desc = "Copy file path" })
keymap.set("n", "<leader>cf", "<cmd>Cfpa<CR>", { desc = "Copy absolute file path" })
keymap.set("n", "<leader>cl", "<cmd>Cfpcl<CR>", { desc = "Copy file path + current line" })

keymap.set("n", "<leader>/", "gcc", { desc = "Toggle comment", remap = true })
keymap.set("v", "<leader>/", "gc", { desc = "Toggle comment", remap = true })

-- Buffers (C-h/l/x/a in normal mode)
local function smart_bdelete()
  local buf = vim.api.nvim_get_current_buf()
  local alt = vim.fn.bufnr "#"
  if alt ~= -1 and alt ~= buf and vim.fn.buflisted(alt) == 1 then
    vim.cmd "buffer #"
  else
    vim.cmd "bprevious"
  end
  if vim.api.nvim_buf_is_valid(buf) then
    vim.cmd("bdelete! " .. buf)
  end
end

keymap.set("n", mod "<C-h>", "<cmd>bprev<CR>", { desc = "Previous buffer" })
keymap.set("n", mod "<C-l>", "<cmd>bnext<CR>", { desc = "Next buffer" })
keymap.set("n", mod "<C-x>", smart_bdelete, { desc = "Close buffer (keep window)" })
keymap.set("n", mod "<C-a>", "<cmd>%bd|e#|bd#<CR>", { desc = "Close all buffers but current" })

-- Multi-cursor (C-n/j/k in normal/visual mode)
keymap.set("n", mod "<C-n>", "<Plug>(VM-Find-Under)", { desc = "Select next occurrence" })
keymap.set("x", mod "<C-n>", "<Plug>(VM-Find-Subword-Under)", { desc = "Select next occurrence" })
keymap.set("n", mod "<C-j>", "<Plug>(VM-Add-Cursor-Down)", { desc = "Add cursor below" })
keymap.set("n", mod "<C-k>", "<Plug>(VM-Add-Cursor-Up)", { desc = "Add cursor above" })
keymap.set("x", mod "<C-j>", "<Plug>(VM-Add-Cursor-Down)", { desc = "Add cursor below" })
keymap.set("x", mod "<C-k>", "<Plug>(VM-Add-Cursor-Up)", { desc = "Add cursor above" })

if not is_mac then
  for _, k in ipairs { "w", "o", "i", "d", "u", "f", "b", "e", "y", "r", "v", "g", "t", "]", "^" } do
    keymap.set({ "n", "x" }, "<A-" .. k .. ">", "<C-" .. k .. ">", { desc = "Ctrl-" .. k })
  end
  for _, k in ipairs { "w", "r", "v", "o", "d", "t", "n", "p", "a", "x" } do
    keymap.set("i", "<A-" .. k .. ">", "<C-" .. k .. ">", { desc = "Ctrl-" .. k })
  end
  for _, k in ipairs { "r", "w", "f", "d", "e", "v" } do
    keymap.set("c", "<A-" .. k .. ">", "<C-" .. k .. ">", { desc = "Ctrl-" .. k })
  end
end

-- Window splits (leader+w)
keymap.set("n", "<leader>wl", "<cmd>vnew<CR>", { desc = "New split right" })
keymap.set("n", "<leader>wj", "<cmd>below new<CR>", { desc = "New split below" })
keymap.set("n", "<leader>wk", "<cmd>above new<CR>", { desc = "New split above" })
keymap.set("n", "<leader>wq", "<cmd>q<CR>", { desc = "Close window" })
keymap.set("n", "<leader>wh", "<cmd>hide<CR>", { desc = "Hide window (keep buffer)" })

-- Find (leader+f) — Telescope
keymap.set("n", "<leader>fg", function()
  telescope().live_grep()
end, { desc = "Find (live grep)" })

keymap.set("n", "<leader>ff", function()
  telescope().current_buffer_fuzzy_find()
end, { desc = "Fuzzy in current buffer" })

keymap.set("n", "<leader>fc", function()
  telescope().commands()
end, { desc = "Commands" })

keymap.set("n", "<leader>fo", function()
  telescope().find_files()
end, { desc = "Go to File" })

keymap.set("n", "<leader>fs", function()
  telescope().lsp_document_symbols()
end, { desc = "Go to Symbol" })

keymap.set("n", "<leader>fk", function()
  telescope().keymaps()
end, { desc = "Keymaps" })

keymap.set("n", "<leader>fb", function()
  telescope().buffers {
    sort_mru = true,
    initial_mode = "normal",
  }
end, { desc = "Buffers (Enter open, dd kill)" })

keymap.set("n", "<leader>fr", function()
  telescope().oldfiles { only_cwd = true }
end, { desc = "Recent Files" })

keymap.set("n", "<leader>ft", "<cmd>TodoTelescope<CR>", { desc = "TODO" })

-- Diagnostics list (global, not buffer-LSP-bound)
keymap.set("n", "<leader>dq", function()
  telescope().diagnostics { bufnr = nil }
end, { desc = "Diagnostics list" })

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

keymap.set({ "n", "x" }, "<leader>ri", function()
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
    map({ "n", "v" }, "<leader>D", vim.lsp.buf.code_action, "Code action")
    map("n", "<leader>dx", vim.diagnostic.open_float, "Line diagnostics")
    map("n", "<leader>dh", vim.diagnostic.goto_prev, "Prev diagnostic")
    map("n", "<leader>dl", vim.diagnostic.goto_next, "Next diagnostic")
  end,
})

-- Git (leader+g + standalone)
keymap.set("n", "<leader>G", neogit "Neogit", { desc = "Git status (Neogit)" })
keymap.set("n", "<leader>gc", neogit "Neogit commit", { desc = "Git commit" })
keymap.set("n", "<leader>gu", neogit "Neogit pull", { desc = "Git pull" })
keymap.set("n", "<leader>gp", neogit "Neogit push", { desc = "Git push" })

keymap.set("n", "<leader>gd", function()
  if require("diffview.lib").get_current_view() then
    vim.cmd "DiffviewClose"
  else
    vim.cmd "DiffviewOpen"
  end
end, { desc = "Diffview / merge tool (toggle)" })

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

-- Harpoon (leader+y)
local function harpoon()
  return require "harpoon"
end

keymap.set("n", "<leader>ya", function()
  harpoon():list():add()
end, { desc = "Add to Harpoon" })

keymap.set("n", "<leader>Y", function()
  harpoon().ui:toggle_quick_menu(harpoon():list())
end, { desc = "Harpoon menu" })

keymap.set("n", "<leader>yh", function()
  harpoon():list():prev()
end, { desc = "Harpoon prev" })

keymap.set("n", "<leader>yl", function()
  harpoon():list():next()
end, { desc = "Harpoon next" })

-- Tools (leader+e)
keymap.set("t", "<Esc>", "<C-\\><C-n>", { desc = "Exit terminal mode" })

keymap.set("n", "<leader>t", "<cmd>terminal<CR>i", { desc = "Terminal (here)" })

keymap.set("n", "<leader>n", "<cmd>Neotree toggle position=left<CR>", { desc = "Project (Neo-tree)" })

keymap.set("n", "<leader>N", "<cmd>Neotree toggle position=float<CR>", { desc = "Project popup (Neo-tree float)" })

return M
