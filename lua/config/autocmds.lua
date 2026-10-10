local accent_opacity = 0.7

local untouched_patterns = {
  "^lualine_",
  "^Cursor$",
  "^lCursor$",
  "^CursorIM$",
  "Thumb$",
}

local accent_patterns = {
  "[Dd]iff",
  "^Visual",
  "Search$",
  "^Substitute$",
  "^MatchParen$",
  "^WildMenu$",
  "^QuickFixLine$",
  "Sel$",
  "Selection",
  "^TelescopePreviewLine$",
  "^TelescopePreviewMatch$",
  "^GitSigns%a*Preview$",
  "^GitSigns%a*Ln$",
  "VirtLn",
  "^GitSignsVirtLnum$",
  "^NeogitHunk",
  "^CodeDiff",
  "^VM_",
  "^MultiCursor$",
  "^LspReference",
  "^[Ii]lluminated",
  "^SnippetTabstop",
  "ActiveParameter$",
  "^DropBarCurrentContext",
  "^DropBarHover$",
  "^DropBarMenuCurrentContext$",
  "^DropBarMenuHoverEntry$",
}

local function matches_any(name, patterns)
  for _, pattern in ipairs(patterns) do
    if name:match(pattern) then
      return true
    end
  end
  return false
end

local function dim(color)
  local r = math.floor(bit.rshift(color, 16) * accent_opacity)
  local g = math.floor(bit.band(bit.rshift(color, 8), 0xff) * accent_opacity)
  local b = math.floor(bit.band(color, 0xff) * accent_opacity)
  return bit.bor(bit.lshift(r, 16), bit.lshift(g, 8), b)
end

local dimmed = {}

local function force_transparent_background()
  for _, name in ipairs(vim.fn.getcompletion("", "highlight")) do
    if not matches_any(name, untouched_patterns) then
      local ok, hl = pcall(vim.api.nvim_get_hl, 0, { name = name, link = false })
      if ok and hl and hl.bg and dimmed[name] ~= hl.bg then
        if matches_any(name, accent_patterns) and not name:match "^NeogitDiffContext" then
          hl.bg = dim(hl.bg)
          dimmed[name] = hl.bg
        else
          hl.bg = nil
          hl.ctermbg = nil
        end
        vim.api.nvim_set_hl(0, name, hl)
      end
    end
  end
end

local grp = vim.api.nvim_create_augroup("ForceTransparentBackground", { clear = true })

local function apply()
  vim.schedule(force_transparent_background)
end

vim.api.nvim_create_autocmd("ColorScheme", {
  group = grp,
  callback = function()
    dimmed = {}
    apply()
  end,
})

vim.api.nvim_create_autocmd({ "VimEnter", "UIEnter" }, {
  group = grp,
  callback = apply,
})

vim.api.nvim_create_autocmd("User", {
  group = grp,
  pattern = { "LazyDone", "LazyLoad" },
  callback = apply,
})
