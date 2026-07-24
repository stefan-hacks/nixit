-- =============================================================================
-- Linting — nvim-lint (declarative, Nix-managed linters)
-- =============================================================================
return {
  "mfussenegger/nvim-lint",
  event = { "BufReadPre", "BufNewFile", "BufWritePost" },
  config = function()
    local lint = require("lint")

    lint.linters_by_ft = {
      rust     = { "clippy" },
      nix      = { "statix" },
      bash     = { "shellcheck" },
      sh       = { "shellcheck" },
      python   = { "ruff" },
      yaml     = { "yamllint" },
      markdown = { "markdownlint" },
      lua      = { "selene" },  -- install selene via Nix if needed
    }

    -- Lint on save (with small debounce)
    vim.api.nvim_create_autocmd({ "BufWritePost" }, {
      callback = function()
        require("lint").try_lint()
      end,
    })

    -- Manual lint trigger
    vim.keymap.set("n", "<leader>cl", function()
      require("lint").try_lint()
    end, { desc = "Lint buffer" })
  end,
}
