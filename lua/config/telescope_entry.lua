local M = {}

local lang_cache = {}

local function lang_for(filename)
  local ext = filename:match "%.([^./]+)$" or filename
  if lang_cache[ext] == nil then
    local ft = vim.filetype.match { filename = filename }
    local lang = ft and vim.treesitter.language.get_lang(ft)
    lang_cache[ext] = (lang and pcall(vim.treesitter.language.add, lang)) and lang or false
  end
  return lang_cache[ext] or nil
end

local function code_highlights(text, lang, offset)
  local highlights = {}
  local query = vim.treesitter.query.get(lang, "highlights")
  if not query then
    return highlights
  end
  local ok, parser = pcall(vim.treesitter.get_string_parser, text, lang)
  if not ok then
    return highlights
  end
  local tree = parser:parse()[1]
  if not tree then
    return highlights
  end
  for id, node in query:iter_captures(tree:root(), text, 0, 1) do
    local name = query.captures[id]
    if not name:match "^_" and name ~= "spell" and name ~= "nospell" then
      local start_row, start_col, end_row, end_col = node:range()
      if start_row == 0 then
        if end_row > 0 then
          end_col = #text
        end
        table.insert(highlights, { { offset + start_col, offset + end_col }, "@" .. name .. "." .. lang })
      end
    end
  end
  return highlights
end

function M.gen_from_quickfix(opts)
  local utils = require "telescope.utils"
  local base = require("telescope.make_entry").gen_from_quickfix(opts)

  local make_display = function(entry)
    local display_filename, path_style = utils.transform_path(opts, entry.filename)
    local prefix = string.format("%s:%d:%d: ", display_filename, entry.lnum, entry.col)
    local text = vim.trim(entry.text or ""):gsub(".* | ", "")

    local highlights = {}
    for _, hl in ipairs(path_style or {}) do
      table.insert(highlights, hl)
    end
    table.insert(highlights, { { #display_filename, #prefix }, "TelescopeResultsLineNr" })

    local lang = lang_for(entry.filename)
    if lang then
      vim.list_extend(highlights, code_highlights(text, lang, #prefix))
    end

    return prefix .. text, highlights
  end

  return function(item)
    local entry = base(item)
    if entry then
      entry.display = make_display
    end
    return entry
  end
end

function M.picker(name)
  return function(opts)
    opts = opts or {}
    opts.entry_maker = M.gen_from_quickfix(opts)
    require("telescope.builtin")[name](opts)
  end
end

return M
