-- =============================================================================
-- kitty-scrollback.nvim
-- =============================================================================
return {
  "mikesmithgh/kitty-scrollback.nvim",
  cmd = { "KittyScrollbackGenerateKittens", "KittyScrollbackCheckHealth", "KittyScrollbackGenerateCommandLineParsing" },
  event = { "User KittyScrollbackLaunch" },
  config = function()
    require("kitty-scrollback").setup({
      -- Global settings
      status_window = {
        enabled = true,
        style_simple = false,
        show_timer = true,
        autoclose = false,
      },
      
      -- Paste window settings
      paste_window = {
        -- Highlight the yanked region
        highlight_as_normal_buf = nil,
        -- Footer window
        footer_win = {
          enabled = true,
          height = 3,
          width = 1,
          -- Border style
          border = {
            enabled = true,
            style = "rounded",
            text = {
              top = " kitty-scrollback.nvim ",
              top_align = "center",
            },
          },
        },
      },
      
      -- Keymaps
      keymaps_enabled = true,
      
      -- Visual selection settings
      visual_selection_enabled = true,
      visual_selection_highlight_as_normal_buf = nil,
      
      -- Scrollback buffer settings
      scrollback_buffer = {
        -- Enabled by default
        enabled = true,
        -- Visuals
        visual_selection = {
          enabled = true,
        },
      },
      
      -- Check terminal health
      checkhealth = {
        kitty_version = {
          min = "0.32.0",
        },
        kitty_shell_integration = {
          enabled = true,
        },
      },
      
      -- Kitten aliases (for kitty.conf)
      -- These are automatically generated
      -- kitty-scrollback.nvim Kitten
      -- action_alias kitty_scrollback_nvim kitten ~/.local/share/nvim/lazy/kitty-scrollback.nvim/python/kitty_scrollback_nvim.py
      
      -- Browse scrollback buffer in nvim
      -- map ctrl+shift+h kitty_scrollback_nvim
      
      -- Browse output of the last shell command in nvim
      -- map ctrl+shift+g kitty_scrollback_nvim --config ksb_builtin_last_cmd_output
      
      -- Show clicked command output in nvim
      -- mouse_map ctrl+shift+right press ungrabbed combine : mouse_select_command_output : kitty_scrollback_nvim --config ksb_builtin_last_visited_cmd_output
    })
  end,
  dependencies = {
    "catppuccin/nvim",
  },
}
