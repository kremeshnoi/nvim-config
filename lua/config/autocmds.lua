local function force_black_background()
  local vm_sources = {
    VM_Mono = "IncSearch",
    VM_Cursor = "Visual",
    VM_Extend = "PmenuSel",
    VM_Insert = "DiffChange",
    VM_Selection = "Visual",
    MultiCursor = "Visual",
  }

  local vm_preserve = {}
  for group, source in pairs(vm_sources) do
    local ok, hl = pcall(vim.api.nvim_get_hl, 0, { name = source, link = true })
    if ok and hl and next(hl) ~= nil then
      vm_preserve[group] = hl
    end
  end

  local names = vim.fn.getcompletion("", "highlight")
  for _, name in ipairs(names) do
    if
      name == "ColorColumn"
      or name == "CurSearch"
      or name == "DiffChange"
      or name == "IncSearch"
      or name == "MultiCursor"
      or name == "PmenuSel"
      or name == "Search"
      or name:match "^Visual"
      or name:match "^VM_"
      or name:match "^VisualMulti"
    then
      goto continue
    end
    local ok, hl = pcall(vim.api.nvim_get_hl, 0, { name = name, link = false })
    if ok and hl then
      hl.bg = "#190019"
      hl.ctermbg = 0
      vim.api.nvim_set_hl(0, name, hl)
    else
      vim.api.nvim_set_hl(0, name, { bg =  "#190019", ctermbg = 0 })
    end
    ::continue::
  end

  for group, hl in pairs(vm_preserve) do
    vim.api.nvim_set_hl(0, group, hl)
  end
end

local grp = vim.api.nvim_create_augroup("ForceBlackBackground", { clear = true })

local function apply()
  vim.schedule(function()
    force_black_background()
  end)
end

vim.api.nvim_create_autocmd({ "VimEnter", "UIEnter", "ColorScheme" }, {
  group = grp,
  callback = apply,
})

vim.api.nvim_create_autocmd("User", {
  group = grp,
  pattern = "LazyDone",
  callback = apply,
})
