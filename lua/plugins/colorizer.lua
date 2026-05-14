return {
  "catgoose/nvim-colorizer.lua",
  event = { "BufReadPre", "BufNewFile" },
  opts = {
    filetypes = { "*" },
    user_default_options = {
      RGB = true,
      RRGGBB = true,
      RRGGBBAA = true,
      AARRGGBB = true,
      names = false,
      rgb_fn = true,
      hsl_fn = true,
      css = true,
      css_fn = true,
      tailwind = "both",
      tailwind_opts = { update_names = true },
      sass = { enable = true, parsers = { "css" } },
      mode = "background",
      virtualtext = "■",
      always_update = true,
    },
  },
}
