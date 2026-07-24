-- =============================================================================
-- Which-key — keybinding hints
-- =============================================================================
return {
  "folke/which-key.nvim",
  event = "VeryLazy",
  opts = {
    preset = "helix",
    delay = 500,
    plugins = {
      marks = true,
      registers = true,
      spelling = {
        enabled = true,
        suggestions = 20,
      },
    },
    win = {
      border = "rounded",
      padding = { 1, 2 },
    },
    layout = {
      height = { min = 4, max = 25 },
      width = { min = 20, max = 50 },
      spacing = 3,
      align = "left",
    },
    icons = {
      breadcrumb = "»",
      separator = "➜",
      group = "+",
      mappings = false,
    },
  },
  config = function(_, opts)
    local wk = require("which-key")
    wk.setup(opts)

    -- Register key groups
    wk.add({
      { "<leader>b", group = "buffer" },
      { "<leader>c", group = "code" },
      { "<leader>f", group = "file/find" },
      { "<leader>g", group = "git" },
      { "<leader>h", group = "gitsigns" },
      { "<leader>q", group = "quit/session" },
      { "<leader>r", group = "rename" },
      { "<leader>s", group = "search" },
      { "<leader>t", group = "toggle" },
      { "<leader>x", group = "diagnostics" },
      { "<leader>", group = "leader" },
      { "g", group = "goto" },
    })
  end,
}
