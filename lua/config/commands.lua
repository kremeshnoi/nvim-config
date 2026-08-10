local function project_root()
  local file = vim.fn.expand "%:p"
  local start = file ~= "" and file or vim.fn.getcwd()
  return vim.fs.root(start, { ".git" }) or vim.fn.getcwd()
end

local function relative_path()
  local file = vim.fn.expand "%:p"
  if file == "" then
    return nil
  end
  local root = project_root()
  return vim.fn.fnamemodify(file, ":p"):gsub("^" .. vim.pesc(root) .. "/", "")
end

vim.api.nvim_create_user_command("Cfp", function()
  local path = relative_path()
  if not path then
    vim.notify("No file in current buffer", vim.log.levels.WARN)
    return
  end
  vim.fn.setreg("+", path)
  vim.notify(path, vim.log.levels.INFO)
end, { desc = "Copy file path relative to project root" })

vim.api.nvim_create_user_command("Cfpa", function()
  local file = vim.fn.expand "%:p"
  if file == "" then
    vim.notify("No file in current buffer", vim.log.levels.WARN)
    return
  end
  vim.fn.setreg("+", file)
  vim.notify(file, vim.log.levels.INFO)
end, { desc = "Copy absolute file path" })

vim.api.nvim_create_user_command("Cfpcl", function()
  local path = relative_path()
  if not path then
    vim.notify("No file in current buffer", vim.log.levels.WARN)
    return
  end
  local lnum = vim.api.nvim_win_get_cursor(0)[1]
  local line = vim.api.nvim_buf_get_lines(0, lnum - 1, lnum, false)[1] or ""
  local result = string.format("%s:%d\n%s", path, lnum, line)
  vim.fn.setreg("+", result)
  vim.notify(result, vim.log.levels.INFO)
end, { desc = "Copy file path + current line" })
