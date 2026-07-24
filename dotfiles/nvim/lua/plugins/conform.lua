-- =============================================================================
-- Formatting — conform.nvim (declarative, Nix-managed formatters)
-- =============================================================================
return {
  "stevearc/conform.nvim",
  event = { "BufWritePre", "BufNewFile" },
  cmd = { "ConformInfo" },
  config = function()
    local conform = require("conform")

    conform.setup({
      formatters_by_ft = {
        rust       = { "rustfmt" },
        nix        = { "nixfmt" },
        bash       = { "shfmt" },
        sh         = { "shfmt" },
        zsh        = { "shfmt" },
        python     = { "ruff_format" },
        lua        = { "stylua" },
        yaml       = { "prettierd", "prettier", stop_after_first = true },
        json       = { "prettierd", "prettier", stop_after_first = true },
        jsonc      = { "prettierd", "prettier", stop_after_first = true },
        markdown   = { "prettierd", "prettier", stop_after_first = true },
        toml       = { "taplo" },
      },
      format_on_save = {
        timeout_ms = 500,
        lsp_fallback = true,
      },
      formatters = {
        -- Ensure formatters use binaries from Nix profile
        rustfmt = {
          command = "rustfmt",
        },
        nixfmt = {
          command = "nixfmt",
        },
        shfmt = {
          command = "shfmt",
          args = { "-i", "2", "-ci", "-bn" },
        },
        ruff_format = {
          command = "ruff",
          args = { "format", "--stdin-filename", "$FILENAME" },
          stdin = true,
        },
        stylua = {
          command = "stylua",
          args = { "--stdin-filepath", "$FILENAME", "-" },
          stdin = true,
        },
        taplo = {
          command = "taplo",
          args = { "format", "--stdin", "-" },
          stdin = true,
        },
      },
    })

    -- Manual format keymap
    vim.keymap.set("n", "<leader>f", function()
      conform.format({ async = true, lsp_fallback = true })
    end, { desc = "Format buffer" })
  end,
}
