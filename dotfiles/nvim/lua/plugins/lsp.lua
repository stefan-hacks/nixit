-- =============================================================================
-- LSP Configuration — Nix-managed servers (no Mason)
-- =============================================================================
return {
  {
    "neovim/nvim-lspconfig",
    event = { "BufReadPre", "BufNewFile" },
    dependencies = {
      "hrsh7th/cmp-nvim-lsp",
      { "folke/neodev.nvim", opts = {} },
    },
    config = function()
      local lspconfig = require("lspconfig")
      local cmp_nvim_lsp = require("cmp_nvim_lsp")
      local capabilities = cmp_nvim_lsp.default_capabilities()

      -- Helper to setup servers with common defaults
      local function setup_server(name, opts)
        opts = opts or {}
        opts.capabilities = opts.capabilities or capabilities
        lspconfig[name].setup(opts)
      end

      -- Lua
      setup_server("lua_ls", {
        settings = {
          Lua = {
            diagnostics = { globals = { "vim" } },
            workspace = {
              library = {
                [vim.fn.expand("$VIMRUNTIME/lua")] = true,
                [vim.fn.stdpath("config") .. "/lua"] = true,
              },
            },
            telemetry = { enable = false },
          },
        },
      })

      -- Bash
      setup_server("bashls")

      -- Nix
      setup_server("nixd", {
        cmd = { "nixd" },
        settings = {
          nixd = {
            nixpkgs = { expr = "import <nixpkgs> { }" },
            formatting = { command = { "nixfmt" } },
          },
        },
      })

      -- Python (basedpyright)
      setup_server("basedpyright")

      -- Rust (rust-analyzer configured via rustaceanvim; keep this minimal)
      -- rustaceanvim handles its own LSP setup

      -- YAML
      setup_server("yamlls", {
        settings = {
          yaml = {
            keyOrdering = false,
          },
        },
      })

      -- TOML (taplo)
      setup_server("taplo")

      -- Markdown
      setup_server("marksman")

      -- JSON
      setup_server("jsonls")

      -- Diagnostics UI
      vim.diagnostic.config({
        virtual_text = true,
        signs = true,
        underline = true,
        update_in_insert = false,
        severity_sort = true,
        float = {
          border = "rounded",
          source = true,
        },
      })

      -- Sign icons
      local signs = {
        Error = "",
        Warn  = "",
        Hint  = "",
        Info  = "",
      }
      for type, icon in pairs(signs) do
        local hl = "DiagnosticSign" .. type
        vim.fn.sign_define(hl, { text = icon, texthl = hl, numhl = hl })
      end
    end,
  },

  -- Signature help
  {
    "ray-x/lsp_signature.nvim",
    event = "VeryLazy",
    config = function()
      require("lsp_signature").setup({
        hint_enable = true,
        hint_prefix = "",
      })
    end,
  },
}
