local saved_fillchars = nil

local function is_active()
  local ok, state = pcall(require, "no-neck-pain.state")
  return ok and state.enabled == true
end

local function hide_separators()
  if not saved_fillchars then
    saved_fillchars = vim.o.fillchars
  end
  vim.opt.fillchars:append { vert = " " }
end

local function restore_separators()
  if saved_fillchars then
    vim.o.fillchars = saved_fillchars
    saved_fillchars = nil
  end
end

local function toggle()
  if is_active() then
    restore_separators()
  else
    hide_separators()
  end
  vim.cmd "NoNeckPain"
end

return {
  "shortcuts/no-neck-pain.nvim",
  cmd = { "NoNeckPain", "NoNeckPainWidthUp", "NoNeckPainWidthDown", "NoNeckPainResize" },
  keys = {
    { "<leader>z", toggle, desc = "Center code (toggle)" },
    { "<leader>Z=", "<cmd>NoNeckPainWidthUp<CR>", desc = "Center code wider" },
    { "<leader>Z-", "<cmd>NoNeckPainWidthDown<CR>", desc = "Center code narrower" },
  },
  opts = {
    width = 120,
    minSideBufferWidth = 10,
    fallbackOnBufferDelete = true,
    autocmds = {
      enableOnVimEnter = false,
      enableOnTabEnter = false,
      skipEnteringNoNeckPainBuffer = true,
    },
    mappings = { enabled = false },
    buffers = {
      setNames = false,
      colors = { blend = -0.1 },
      wo = { fillchars = "eob: ,vert: " },
    },
    integrations = {
      NeoTree = { position = "left", reopen = true },
      undotree = { position = "left" },
    },
  },
}
