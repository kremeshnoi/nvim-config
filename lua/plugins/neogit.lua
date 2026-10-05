return {
  "NeogitOrg/neogit",
  dependencies = {
    "nvim-lua/plenary.nvim",
    "esmuellert/codediff.nvim",
    "nvim-telescope/telescope.nvim",
  },
  cmd = "Neogit",
  opts = {
    diff_viewer = "codediff",
    integrations = {
      codediff = true,
      telescope = true,
    },
    graph_style = "unicode",
  },
}
