-- =============================================================================
-- Keymaps
-- =============================================================================
local map = vim.keymap.set
local opts = { noremap = true, silent = true }

-- =============================================================================
-- Leader key
-- =============================================================================
map("n", "<Space>", "", opts)
vim.g.mapleader = " "
vim.g.maplocalleader = " "

-- =============================================================================
-- Better window navigation
-- =============================================================================
map("n", "<C-h>", "<C-w>h", opts)
map("n", "<C-j>", "<C-w>j", opts)
map("n", "<C-k>", "<C-w>k", opts)
map("n", "<C-l>", "<C-w>l", opts)

-- =============================================================================
-- Resize with arrows
-- =============================================================================
map("n", "<C-Up>", ":resize +2<CR>", opts)
map("n", "<C-Down>", ":resize -2<CR>", opts)
map("n", "<C-Left>", ":vertical resize -2<CR>", opts)
map("n", "<C-Right>", ":vertical resize +2<CR>", opts)

-- =============================================================================
-- Buffer navigation
-- =============================================================================
map("n", "<S-l>", ":bnext<CR>", opts)
map("n", "<S-h>", ":bprevious<CR>", opts)
map("n", "<leader>bd", ":Bdelete!<CR>", { desc = "Close Buffer" })

-- =============================================================================
-- Better paste
-- =============================================================================
map("v", "p", '"_dP', opts)

-- =============================================================================
-- Stay in indent mode
-- =============================================================================
map("v", "<", "<gv", opts)
map("v", ">", ">gv", opts)

-- =============================================================================
-- Move text up and down
-- =============================================================================
map("v", "<A-j>", ":m .+1<CR>==", opts)
map("v", "<A-k>", ":m .-2<CR>==", opts)
map("x", "<A-j>", ":m '>+1<CR>gv=gv", opts)
map("x", "<A-k>", ":m '<-2<CR>gv=gv", opts)
map("n", "<A-j>", ":m .+1<CR>==", opts)
map("n", "<A-k>", ":m .-2<CR>==", opts)

-- =============================================================================
-- Clear highlights
-- =============================================================================
map("n", "<Esc>", ":noh<CR>", { desc = "Clear Highlights" })

-- =============================================================================
-- Save file
-- =============================================================================
map({ "i", "n", "v" }, "<C-s>", "<cmd>w<cr><esc>", { desc = "Save File" })

-- =============================================================================
-- Quit
-- =============================================================================
map("n", "<leader>qq", "<cmd>qa<cr>", { desc = "Quit All" })

-- =============================================================================
-- Lazy
-- =============================================================================
map("n", "<leader>l", "<cmd>Lazy<cr>", { desc = "Lazy" })

-- =============================================================================
-- LazyGit (if installed)
-- =============================================================================
map("n", "<leader>gg", "<cmd>LazyGit<cr>", { desc = "LazyGit" })

-- =============================================================================
-- Telescope (loaded by plugin)
-- =============================================================================
map("n", "<leader>ff", "<cmd>Telescope find_files<cr>", { desc = "Find Files" })
map("n", "<leader>fg", "<cmd>Telescope live_grep<cr>", { desc = "Live Grep" })
map("n", "<leader>fb", "<cmd>Telescope buffers<cr>", { desc = "Buffers" })
map("n", "<leader>fh", "<cmd>Telescope help_tags<cr>", { desc = "Help Tags" })

-- =============================================================================
-- NvimTree
-- =============================================================================
map("n", "<leader>e", "<cmd>NvimTreeToggle<cr>", { desc = "Explorer" })

-- =============================================================================
-- LSP
-- =============================================================================
map("n", "gd", "<cmd>lua vim.lsp.buf.definition()<cr>", { desc = "Goto Definition" })
map("n", "gr", "<cmd>lua vim.lsp.buf.references()<cr>", { desc = "Goto References" })
map("n", "gI", "<cmd>lua vim.lsp.buf.implementation()<cr>", { desc = "Goto Implementation" })
map("n", "<leader>rn", "<cmd>lua vim.lsp.buf.rename()<cr>", { desc = "Rename" })
map("n", "<leader>ca", "<cmd>lua vim.lsp.buf.code_action()<cr>", { desc = "Code Action" })
map("n", "K", "<cmd>lua vim.lsp.buf.hover()<cr>", { desc = "Hover" })
map("n", "<leader>D", "<cmd>lua vim.lsp.buf.type_definition()<cr>", { desc = "Type Definition" })
map("n", "<leader>f", "<cmd>lua vim.lsp.buf.format()<cr>", { desc = "Format" })

-- =============================================================================
-- Diagnostics
-- =============================================================================
map("n", "<leader>xx", "<cmd>TroubleToggle<cr>", { desc = "Diagnostics (Trouble)" })
map("n", "<leader>xX", "<cmd>TroubleToggle workspace_diagnostics<cr>", { desc = "Workspace Diagnostics" })
map("n", "[d", "<cmd>lua vim.diagnostic.goto_prev()<cr>", { desc = "Prev Diagnostic" })
map("n", "]d", "<cmd>lua vim.diagnostic.goto_next()<cr>", { desc = "Next Diagnostic" })
map("n", "<leader>cd", "<cmd>lua vim.diagnostic.open_float()<cr>", { desc = "Line Diagnostics" })

-- =============================================================================
-- Kitty Scrollback Integration
-- =============================================================================
map("n", "<leader>K", "<cmd>KittyScrollbackCheckHealth<cr>", { desc = "Kitty Scrollback Health" })
