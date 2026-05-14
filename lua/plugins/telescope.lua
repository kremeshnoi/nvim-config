return {
  "nvim-telescope/telescope.nvim",
  cmd = "Telescope",
  lazy = false,
  dependencies = {
    { "nvim-lua/plenary.nvim", lazy = false },
    { "nvim-telescope/telescope-fzf-native.nvim", build = "make" },
  },
  config = function()
    local telescope = require "telescope"
    local actions = require "telescope.actions"

    telescope.setup {
      defaults = {
        vimgrep_arguments = {
          "rg",
          "--color=never",
          "--no-heading",
          "--with-filename",
          "--line-number",
          "--column",
          "--smart-case",
          "--hidden",
          "--no-ignore-vcs",
        },
        file_ignore_patterns = {
          "%.git/",
          "node_modules/",
          "%.cache/",
          "dist/",
          "build/",
          "%.next/",
          "%.venv/",
          "__pycache__/",
          "%.lock",
          "%.svg$",
          "%.png$",
          "%.jpg$",
          "%.jpeg$",
          "%.webp$",
          "%.ico$",
        },
        path_display = { "truncate" },
        sorting_strategy = "ascending",
        layout_config = {
          prompt_position = "top",
          horizontal = { preview_width = 0.55 },
        },
        mappings = {
          i = {
            ["<C-j>"] = actions.move_selection_next,
            ["<C-k>"] = actions.move_selection_previous,
            ["<C-q>"] = actions.send_to_qflist + actions.open_qflist,
            ["<esc>"] = actions.close,
          },
          n = {
            ["v"] = actions.select_vertical,
            ["s"] = actions.select_horizontal,
            ["t"] = actions.select_tab,
            ["q"] = actions.close,
            ["<C-q>"] = actions.send_to_qflist + actions.open_qflist,
          },
        },
      },
      pickers = {
        find_files = {
          hidden = true,
          no_ignore = true,
          no_ignore_parent = true,
          find_command = {
            "rg",
            "--files",
            "--hidden",
            "--no-ignore-vcs",
            "--glob=!**/.git/*",
          },
        },
        live_grep = {
          additional_args = function()
            return { "--hidden", "--no-ignore-vcs" }
          end,
        },
        current_buffer_fuzzy_find = {
          skip_empty_lines = true,
        },
        buffers = {
          mappings = {
            n = {
              ["dd"] = actions.delete_buffer,
            },
            i = {
              ["<C-d>"] = actions.delete_buffer,
            },
          },
        },
      },
      extensions = {
        fzf = {
          fuzzy = true,
          override_generic_sorter = true,
          override_file_sorter = true,
          case_mode = "smart_case",
        },
      },
    }

    pcall(telescope.load_extension, "fzf")
  end,
}
