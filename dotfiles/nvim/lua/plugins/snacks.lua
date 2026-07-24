-- =============================================================================
-- Snacks.nvim — UI enhancements (dashboard, scratch, notify, etc.)
-- =============================================================================
return {
  "folke/snacks.nvim",
  priority = 1000,
  lazy = false,
  opts = {
    -- Enable the modules you want
    bigfile = { enabled = true },
    dashboard = {
      enabled = true,
      sections = {
        { section = "header" },
        { section = "keys", gap = 1, padding = 1 },
        { section = "startup" },
      },
      preset = {
        keys = {
          { icon = " ", key = "f", desc = "Find File", action = "<cmd>Telescope find_files<cr>" },
          { icon = " ", key = "g", desc = "Find Text", action = "<cmd>Telescope live_grep<cr>" },
          { icon = " ", key = "n", desc = "New File", action = ":ene <bar> startinsert" },
          { icon = " ", key = "r", desc = "Recent Files", action = "<cmd>Telescope oldfiles<cr>" },
          { icon = " ", key = "l", desc = "Lazy", action = "<cmd>Lazy<cr>" },
          { icon = " ", key = "q", desc = "Quit", action = "<cmd>qa<cr>" },
        },
      },
    },
    indent = {
      enabled = true,
      indent = { char = "│" },
      scope = { char = "│" },
    },
    input = { enabled = true },
    notifier = {
      enabled = true,
      timeout = 3000,
    },
    quickfile = { enabled = true },
    scroll = {
      enabled = true,
      animate = {
        duration = { step = 15, total = 250 },
        easing = "linear",
      },
    },
    statuscolumn = { enabled = true },
    words = { enabled = true },
    zen = { enabled = true },
    explorer = { enabled = true },
    scope = { enabled = true },
    picker = { enabled = true },
  },
  config = function(_, opts)
    local snacks = require("snacks")
    snacks.setup(opts)

    -- Use snacks for vim.ui.select
    vim.ui.select = snacks.picker.select

    -- Keymaps for snacks
    vim.keymap.set("n", "<leader>.", function() snacks.scratch() end, { desc = "Toggle Scratch Buffer" })
    vim.keymap.set("n", "<leader>S", function() snacks.scratch.select() end, { desc = "Select Scratch Buffer" })
    vim.keymap.set("n", "<leader>n", function() snacks.notifier.show_history() end, { desc = "Notification History" })
    vim.keymap.set("n", "<leader>un", function() snacks.notifier.hide() end, { desc = "Dismiss All Notifications" })
    vim.keymap.set("n", "<leader>z", function() snacks.zen() end, { desc = "Zen Mode" })
    vim.keymap.set("n", "<leader>Z", function() snacks.zen.zoom() end, { desc = "Zoom Mode" })
  end,
}
