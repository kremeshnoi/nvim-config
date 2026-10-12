local vault_roots = {
  vim.env.OBSIDIAN_VAULTS or "",
  "/mnt/c/Users/Alex/iCloudDrive/Documents/Obsidian Vaults",
  vim.fn.expand "~/Documents",
}

local function find_workspaces()
  local workspaces = {}
  for _, root in ipairs(vault_roots) do
    if root ~= "" then
      for _, marker in ipairs(vim.fn.glob(root .. "/*/.obsidian", false, true)) do
        local path = vim.fs.dirname(marker)
        table.insert(workspaces, { name = vim.fs.basename(path), path = path })
      end
    end
  end
  return workspaces
end

local workspaces = find_workspaces()

local function apply_conceal(enabled)
  for _, win in ipairs(vim.api.nvim_list_wins()) do
    if vim.bo[vim.api.nvim_win_get_buf(win)].filetype == "markdown" then
      vim.wo[win].conceallevel = enabled and 2 or 0
    end
  end
end

local function toggle_ui()
  local ui = require "obsidian.ui"
  local opts = Obsidian.opts.ui
  opts.enable = not opts.enable
  local ns = vim.api.nvim_create_namespace "ObsidianUI"
  for _, buf in ipairs(vim.api.nvim_list_bufs()) do
    if vim.api.nvim_buf_is_loaded(buf) then
      vim.api.nvim_buf_clear_namespace(buf, ns, 0, -1)
      if ui._buf_mark_cache[buf] then
        ui._buf_mark_cache[buf][ns] = {}
      end
    end
  end
  apply_conceal(opts.enable)
  if opts.enable then
    ui.update(0)
  end
  vim.notify("Obsidian UI " .. (opts.enable and "on" or "off"))
end

return {
  "obsidian-nvim/obsidian.nvim",
  version = "*",
  cond = #workspaces > 0,
  ft = { "markdown" },
  cmd = { "Obsidian" },
  dependencies = { "nvim-lua/plenary.nvim", "nvim-telescope/telescope.nvim" },
  keys = {
    { "<leader>m", "<cmd>Obsidian toggle_ui<CR>", desc = "Toggle Obsidian markdown UI", ft = "markdown" },
    { "<leader>oo", "<cmd>Obsidian quick_switch<CR>", desc = "Obsidian find note" },
    { "<leader>os", "<cmd>Obsidian search<CR>", desc = "Obsidian grep notes" },
    { "<leader>on", "<cmd>Obsidian new<CR>", desc = "Obsidian new note" },
    { "<leader>ow", "<cmd>Obsidian workspace<CR>", desc = "Obsidian switch vault" },
    { "<leader>ot", "<cmd>Obsidian tags<CR>", desc = "Obsidian tags" },
    { "<leader>ob", "<cmd>Obsidian backlinks<CR>", desc = "Obsidian backlinks", ft = "markdown" },
    { "<leader>ol", "<cmd>Obsidian links<CR>", desc = "Obsidian links", ft = "markdown" },
    { "<leader>oc", "<cmd>Obsidian toc<CR>", desc = "Obsidian table of contents", ft = "markdown" },
    { "<leader>or", "<cmd>Obsidian rename<CR>", desc = "Obsidian rename note", ft = "markdown" },
    { "<leader>ox", "<cmd>Obsidian toggle_checkbox<CR>", desc = "Obsidian toggle checkbox", ft = "markdown" },
    { "<leader>op", "<cmd>Obsidian paste_img<CR>", desc = "Obsidian paste image", ft = "markdown" },
    { "<leader>oe", ":Obsidian extract_note<CR>", mode = "v", desc = "Obsidian extract to note", ft = "markdown" },
    { "<leader>ok", ":Obsidian link<CR>", mode = "v", desc = "Obsidian link selection", ft = "markdown" },
  },
  opts = {
    legacy_commands = false,
    workspaces = workspaces,
    new_notes_location = "current_dir",
    note_id_func = function(title)
      if title and title ~= "" then
        return title
      end
      return require("obsidian.builtin").zettel_id()
    end,
    link = { style = "wiki", format = "shortest" },
    frontmatter = { enabled = false },
    daily_notes = { enabled = false },
    picker = { name = "telescope.nvim" },
    completion = { min_chars = 2 },
    ui = { enable = true },
    statusline = { enabled = false },
    attachments = { folder = "/" },
  },
  config = function(_, opts)
    require("obsidian").setup(opts)
    require("obsidian.commands").register("toggle_ui", { nargs = 0, func = toggle_ui })
    vim.api.nvim_create_autocmd({ "FileType", "BufWinEnter" }, {
      group = vim.api.nvim_create_augroup("ObsidianUIConceal", { clear = true }),
      callback = function(ev)
        if vim.bo[ev.buf].filetype == "markdown" then
          vim.wo.conceallevel = Obsidian.opts.ui.enable and 2 or 0
        end
      end,
    })
    apply_conceal(Obsidian.opts.ui.enable)
    vim.schedule(function()
      require("obsidian.ui").update(0)
    end)
  end,
}
