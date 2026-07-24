-- =============================================================================
-- Mini.nvim plugins (ai, surround, comment)
-- =============================================================================
return {
  -- mini.icons
  {
    "echasnovski/mini.icons",
    version = false,
    lazy = true,
    config = function()
      require("mini.icons").setup()
    end,
  },

  -- mini.ai — extended text objects
  {
    "echasnovski/mini.ai",
    version = false,
    event = "VeryLazy",
    config = function()
      require("mini.ai").setup({
        n_lines = 500,
        custom_textobjects = nil,
      })
    end,
  },

  -- mini.surround — surround text objects
  {
    "echasnovski/mini.surround",
    version = false,
    event = "VeryLazy",
    opts = {
      mappings = {
        add = "gsa",
        delete = "gsd",
        find = "gsf",
        find_left = "gsF",
        highlight = "gsh",
        replace = "gsr",
        update_n_lines = "gsn",
      },
    },
  },

  -- mini.comment — toggle comments
  {
    "echasnovski/mini.comment",
    version = false,
    event = "VeryLazy",
    opts = {
      mappings = {
        comment = "gc",
        comment_line = "gcc",
        comment_visual = "gc",
        textobject = "gc",
      },
    },
  },
}
