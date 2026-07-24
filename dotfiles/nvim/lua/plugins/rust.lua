-- =============================================================================
-- Rustaceanvim — enhanced Rust LSP + Cargo integration (no Mason)
-- =============================================================================
return {
  "mrcjkb/rustaceanvim",
  version = vim.fn.has("nvim-0.10") == 1 and "^5" or "^4",
  ft = { "rust" },
  dependencies = {
    "nvim-lua/plenary.nvim",
    "mfussenegger/nvim-dap",
  },
  config = function()
    vim.g.rustaceanvim = {
      -- Use the rust-analyzer installed by Nix
      server = {
        cmd = { "rust-analyzer" },
        default_settings = {
          ["rust-analyzer"] = {
            cargo = {
              allFeatures = true,
              loadOutDirsFromCheck = true,
              buildScripts = {
                enable = true,
              },
            },
            checkOnSave = {
              enable = true,
              command = "clippy",
              extraArgs = { "--no-deps" },
            },
            procMacro = {
              enable = true,
              ignored = {
                ["async-trait"] = { "async_trait" },
                ["napi-derive"] = { "napi" },
                ["async-recursion"] = { "async_recursion" },
              },
            },
            diagnostics = {
              enable = true,
              disabled = { "proc-macro" },
              enableExperimental = true,
            },
            inlayHints = {
              bindingModeHints = {
                enable = false,
              },
              chainingHints = {
                enable = true,
              },
              closingBraceHints = {
                enable = true,
                minLines = 25,
              },
              closureReturnTypeHints = {
                enable = "never",
              },
              lifetimeElisionHints = {
                enable = "never",
                useParameterNames = false,
              },
              maxLength = 25,
              parameterHints = {
                enable = true,
              },
              reborrowHints = {
                enable = "never",
              },
              renderColons = true,
              typeHints = {
                enable = true,
                hideClosureInitialization = false,
                hideNamedConstructor = false,
              },
            },
          },
        },
      },
      dap = {
        autoload_configurations = true,
      },
      tools = {
        enable_clippy = true,
        enable_nextest = false,
        hover_actions = {
          auto_focus = false,
        },
      },
    }

    -- Keymaps for rustaceanvim
    vim.api.nvim_create_autocmd("FileType", {
      pattern = "rust",
      callback = function()
        local bufnr = vim.api.nvim_get_current_buf()
        vim.keymap.set("n", "<leader>cr", "<cmd>RustLsp runnables<cr>", { buffer = bufnr, desc = "Rust Runnables" })
        vim.keymap.set("n", "<leader>cd", "<cmd>RustLsp debuggables<cr>", { buffer = bufnr, desc = "Rust Debuggables" })
        vim.keymap.set("n", "<leader>cc", "<cmd>RustLsp openCargo<cr>", { buffer = bufnr, desc = "Open Cargo.toml" })
        vim.keymap.set("n", "<leader>cp", "<cmd>RustLsp parentModule<cr>", { buffer = bufnr, desc = "Parent Module" })
        vim.keymap.set("n", "<leader>co", "<cmd>RustLsp openDocs<cr>", { buffer = bufnr, desc = "Open Docs" })
        vim.keymap.set("n", "<leader>cm", "<cmd>RustLsp expandMacro<cr>", { buffer = bufnr, desc = "Expand Macro" })
        vim.keymap.set("n", "<A-k>", "<cmd>RustLsp hover actions<cr>", { buffer = bufnr, desc = "Hover Actions" })
        vim.keymap.set("n", "<A-d>", "<cmd>RustLsp relatedDiagnostics<cr>", { buffer = bufnr, desc = "Related Diagnostics" })
      end,
    })
  end,
}
