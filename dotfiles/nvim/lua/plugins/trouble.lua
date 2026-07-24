-- =============================================================================
-- Trouble — diagnostics list / quickfix UI
-- =============================================================================
return {
  "folke/trouble.nvim",
  cmd = { "Trouble", "TroubleToggle", "TroubleRefresh" },
  dependencies = { "nvim-tree/nvim-web-devicons" },
  opts = {
    position = "bottom",
    height = 10,
    width = 50,
    icons = true,
    mode = "workspace_diagnostics",
    severity = nil,
    fold_open = "",
    fold_closed = "",
    group = true,
    padding = true,
    cycle_results = true,
    action_keys = {
      close = "q",
      cancel = "<esc>",
      refresh = "r",
      jump = { "<cr>", "<tab>" },
      jump_close = { "o" },
      toggle_mode = "m",
      toggle_preview = "P",
      hover = "K",
      preview = "p",
      close_folds = { "zM", "zm" },
      open_folds = { "zR", "zr" },
      toggle_fold = { "zA", "za" },
      previous = "k",
      next = "j",
    },
  },
}
