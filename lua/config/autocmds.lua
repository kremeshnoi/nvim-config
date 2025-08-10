vim.api.nvim_create_autocmd({ "WinEnter", "BufWinEnter" }, {
  callback = function()
    vim.opt_local.cursorline = false
    vim.opt_local.cursorcolumn = false
  end,
})

local function nvimtree_no_cursorline()
  if vim.bo.filetype ~= "NvimTree" then
    return
  end

  vim.wo.cursorline = false
  vim.wo.cursorcolumn = false

  local wh = vim.wo.winhighlight or ""
  if not wh:find "CursorLine:" then
    wh = wh .. ",CursorLine:NvimTreeNormal"
  else
    wh = wh:gsub("CursorLine:[^,]+", "CursorLine:NvimTreeNormal")
  end

  if not wh:find "CursorLineNr:" then
    wh = wh .. ",CursorLineNr:NvimTreeLineNr"
  else
    wh = wh:gsub("CursorLineNr:[^,]+", "CursorLineNr:NvimTreeLineNr")
  end

  vim.wo.winhighlight = wh
end

local grp = vim.api.nvim_create_augroup("NoCursorLineInNvimTree", { clear = true })

vim.api.nvim_create_autocmd("FileType", {
  group = grp,
  pattern = "NvimTree",
  callback = function()
    vim.schedule(nvimtree_no_cursorline)
  end,
})

vim.api.nvim_create_autocmd("VimEnter", {
  group = grp,
  callback = function()
    vim.schedule(function()
      for _, win in ipairs(vim.api.nvim_list_wins()) do
        local buf = vim.api.nvim_win_get_buf(win)
        if vim.bo[buf].filetype == "NvimTree" then
          vim.api.nvim_set_current_win(win)
          nvimtree_no_cursorline()
        end
      end
    end)
  end,
})

local function nvimtree_disable_opened_folder_highlight()
  pcall(vim.api.nvim_set_hl, 0, "NvimTreeOpenedFolderName", { link = "NvimTreeFolderName" })
  pcall(
    vim.api.nvim_set_hl,
    0,
    "NvimTreeHighlights",
    { fg = nil, bg = nil, sp = nil, underline = false, bold = false, italic = false }
  )
end

local grp = vim.api.nvim_create_augroup("NvimTreeNoOpenedFolderHL", { clear = true })

vim.api.nvim_create_autocmd("ColorScheme", {
  group = grp,
  callback = nvimtree_disable_opened_folder_highlight,
})

vim.api.nvim_create_autocmd("FileType", {
  group = grp,
  pattern = "NvimTree",
  callback = function()
    vim.schedule(nvimtree_disable_opened_folder_highlight)
  end,
})

vim.api.nvim_create_autocmd("VimEnter", {
  group = grp,
  callback = function()
    vim.schedule(nvimtree_disable_opened_folder_highlight)
  end,
})

local function clear_bg(name)
  local ok, cur = pcall(vim.api.nvim_get_hl, 0, { name = name, link = false })
  if ok and cur then
    cur.bg = nil
    cur.ctermbg = nil
    vim.api.nvim_set_hl(0, name, cur)
  else
    vim.api.nvim_set_hl(0, name, { bg = "NONE", ctermbg = "NONE" })
  end
end

local function clear_bg_many(list)
  for _, name in ipairs(list) do
    clear_bg(name)
  end
end

local function clear_bg_prefix(prefix)
  local names = vim.fn.getcompletion(prefix, "highlight")
  for _, name in ipairs(names) do
    clear_bg(name)
  end
end

local function barbar_transparent_all()
  clear_bg_many {
    "TabLine",
    "TabLineSel",
    "TabLineFill",

    "BufferCurrent",
    "BufferCurrentIndex",
    "BufferCurrentMod",
    "BufferCurrentSign",
    "BufferCurrentTarget",
    "BufferCurrentIcon",

    "BufferVisible",
    "BufferVisibleIndex",
    "BufferVisibleMod",
    "BufferVisibleSign",
    "BufferVisibleTarget",
    "BufferVisibleIcon",

    "BufferInactive",
    "BufferInactiveIndex",
    "BufferInactiveMod",
    "BufferInactiveSign",
    "BufferInactiveTarget",
    "BufferInactiveIcon",

    "BufferTabpage",
    "BufferTabpageFill",
    "BufferOffset",
    "BufferOffsetIcon",
  }

  clear_bg_many {
    "BufferCurrentSignRight",
    "BufferVisibleSignRight",
    "BufferInactiveSignRight",

    "BufferCurrentModRight",
    "BufferVisibleModRight",
    "BufferInactiveModRight",

    "BufferCurrentSeparator",
    "BufferVisibleSeparator",
    "BufferInactiveSeparator",
  }

  clear_bg_many {
    "BufferCurrentERROR",
    "BufferCurrentWARN",
    "BufferCurrentINFO",
    "BufferCurrentHINT",
    "BufferVisibleERROR",
    "BufferVisibleWARN",
    "BufferVisibleINFO",
    "BufferVisibleHINT",
    "BufferInactiveERROR",
    "BufferInactiveWARN",
    "BufferInactiveINFO",
    "BufferInactiveHINT",

    "BufferCurrentERRORIcon",
    "BufferCurrentWARNIcon",
    "BufferCurrentINFOIcon",
    "BufferCurrentHINTIcon",
    "BufferVisibleERRORIcon",
    "BufferVisibleWARNIcon",
    "BufferVisibleINFOIcon",
    "BufferVisibleHINTIcon",
    "BufferInactiveERRORIcon",
    "BufferInactiveWARNIcon",
    "BufferInactiveINFOIcon",
    "BufferInactiveHINTIcon",
  }

  clear_bg_prefix "Buffer"

  clear_bg "TabLineFill"
end

local grp = vim.api.nvim_create_augroup("BarbarTransparentAll", { clear = true })

local function apply()
  vim.schedule(barbar_transparent_all)
end

vim.api.nvim_create_autocmd("ColorScheme", { group = grp, callback = apply })
vim.api.nvim_create_autocmd("VimEnter", { group = grp, callback = apply })

vim.api.nvim_create_autocmd({ "BufEnter", "BufAdd", "BufDelete", "BufModifiedSet" }, { group = grp, callback = apply })
vim.api.nvim_create_autocmd("DiagnosticChanged", { group = grp, callback = apply })

vim.api.nvim_create_autocmd("User", { group = grp, pattern = "GitSignsUpdate", callback = apply })
vim.api.nvim_create_autocmd("User", { group = grp, pattern = "GitSignsChanged", callback = apply })

local function clear_bg(name)
  local ok, cur = pcall(vim.api.nvim_get_hl, 0, { name = name, link = false })
  if ok and cur then
    cur.bg = nil
    cur.ctermbg = nil
    vim.api.nvim_set_hl(0, name, cur)
  else
    vim.api.nvim_set_hl(0, name, { bg = "NONE", ctermbg = "NONE" })
  end
end

local function lualine_transparent_except_mode()
  clear_bg "StatusLine"
  clear_bg "StatusLineNC"

  for _, name in ipairs(vim.fn.getcompletion("lualine_", "highlight")) do
    if not name:match "^lualine_a_" then
      clear_bg(name)
    end
  end

  vim.cmd "redrawstatus"
end

local grp = vim.api.nvim_create_augroup("LualineTransparentExceptMode", { clear = true })

local function apply()
  vim.schedule(lualine_transparent_except_mode)
end

vim.api.nvim_create_autocmd({ "VimEnter", "ColorScheme", "ModeChanged", "WinEnter", "BufEnter" }, {
  group = grp,
  callback = apply,
})
