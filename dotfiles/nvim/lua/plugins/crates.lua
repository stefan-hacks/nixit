-- =============================================================================
-- Crates.nvim — Cargo.toml dependency management
-- =============================================================================
return {
  "saecki/crates.nvim",
  event = { "BufReadPre Cargo.toml", "BufNewFile Cargo.toml" },
  dependencies = { "nvim-lua/plenary.nvim" },
  config = function()
    require("crates").setup({
      smart_insert = true,
      insert_closing_quote = true,
      avoid_prerelease = true,
      autoload = true,
      autoupdate = true,
      loading_indicator = true,
      date_format = "%Y-%m-%d",
      thousands_separator = ",",
      notification_title = "Crates",
      curl_args = { "-sL", "--retry", "1" },
      max_parallel_requests = 80,
      open_programs = { "xdg-open", "open" },
      expand_crate_moves_cursor = true,
      enable_update_available_highlight = true,
      on_attach = function(bufnr)
        local map = vim.keymap.set
        local opts = { buffer = bufnr, silent = true }
        map("n", "<leader>Ct", require("crates").toggle, opts)
        map("n", "<leader>Cr", require("crates").reload, opts)
        map("n", "<leader>Cv", require("crates").show_versions_popup, opts)
        map("n", "<leader>Cf", require("crates").show_features_popup, opts)
        map("n", "<leader>Cd", require("crates").show_dependencies_popup, opts)
        map("n", "<leader>Cu", require("crates").update_crate, opts)
        map("v", "<leader>Cu", require("crates").update_crates, opts)
        map("n", "<leader>Ca", require("crates").update_all_crates, opts)
        map("n", "<leader>CU", require("crates").upgrade_crate, opts)
        map("v", "<leader>CU", require("crates").upgrade_crates, opts)
        map("n", "<leader>CA", require("crates").upgrade_all_crates, opts)
        map("n", "<leader>Ce", require("crates").expand_plain_crate_to_inline_table, opts)
        map("n", "<leader>CE", require("crates").extract_crate_into_table, opts)
        map("n", "<leader>CH", require("crates").open_homepage, opts)
        map("n", "<leader>CR", require("crates").open_repository, opts)
        map("n", "<leader>CD", require("crates").open_documentation, opts)
        map("n", "<leader>CC", require("crates").open_crates_io, opts)
      end,
    })
  end,
}
