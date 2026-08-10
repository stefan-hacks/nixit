# Nixvim declarative Neovim configuration
# Extracted from the legacy configuration.nix and ported to flakes

{
  config,
  pkgs,
  lib,
  ...
}:

{
  programs.nixvim = {

    enable = true;

    defaultEditor = true;

    # ── Settings ─────────────────────────────────────────────────────────────

    clipboard = {
      providers.wl-copy.enable = pkgs.stdenv.isLinux;
    };

    opts = {
      number = true;
      relativenumber = true;
      clipboard = "unnamedplus";
      tabstop = 2;
      softtabstop = 2;
      showtabline = 2;
      expandtab = true;
      smartindent = true;
      shiftwidth = 2;
      breakindent = true;
      cursorline = true;
      scrolloff = 8;
      mouse = "a";
      foldmethod = "manual";
      foldenable = false;
      linebreak = true;
      spell = false;
      swapfile = false;
      timeoutlen = 300;
      termguicolors = true;
      showmode = false;
      splitbelow = true;
      splitkeep = "screen";
      splitright = true;
      cmdheight = 0;
      fillchars = {
        eob = " ";
      };
    };

    # ── Keymaps ──────────────────────────────────────────────────────────────

    globals.mapleader = " ";

    keymaps = [
      {
        mode = [
          "n"
          "x"
        ];
        key = "j";
        action = "v:count == 0 ? 'gj' : 'j'";
        options = {
          expr = true;
          silent = true;
        };
      }
      {
        mode = [
          "n"
          "x"
        ];
        key = "<Down>";
        action = "v:count == 0 ? 'gj' : 'j'";
        options = {
          expr = true;
          silent = true;
        };
      }
      {
        mode = [
          "n"
          "x"
        ];
        key = "k";
        action = "v:count == 0 ? 'gk' : 'k'";
        options = {
          expr = true;
          silent = true;
        };
      }
      {
        mode = [
          "n"
          "x"
        ];
        key = "<Up>";
        action = "v:count == 0 ? 'gk' : 'k'";
        options = {
          expr = true;
          silent = true;
        };
      }
      {
        mode = "n";
        key = "<C-h>";
        action = "<C-w>h";
        options = {
          desc = "Go to Left Window";
          remap = true;
        };
      }
      {
        mode = "n";
        key = "<C-j>";
        action = "<C-w>j";
        options = {
          desc = "Go to Lower Window";
          remap = true;
        };
      }
      {
        mode = "n";
        key = "<C-k>";
        action = "<C-w>k";
        options = {
          desc = "Go to Upper Window";
          remap = true;
        };
      }
      {
        mode = "n";
        key = "<C-l>";
        action = "<C-w>l";
        options = {
          desc = "Go to Right Window";
          remap = true;
        };
      }
      {
        mode = "n";
        key = "<C-Up>";
        action = "<cmd>resize +2<cr>";
        options = {
          desc = "Increase Window Height";
        };
      }
      {
        mode = "n";
        key = "<C-Down>";
        action = "<cmd>resize -2<cr>";
        options = {
          desc = "Decrease Window Height";
        };
      }
      {
        mode = "n";
        key = "<C-Left>";
        action = "<cmd>vertical resize -2<cr>";
        options = {
          desc = "Decrease Window Width";
        };
      }
      {
        mode = "n";
        key = "<C-Right>";
        action = "<cmd>vertical resize +2<cr>";
        options = {
          desc = "Increase Window Width";
        };
      }
      {
        mode = "n";
        key = "<A-j>";
        action = "<cmd>m .+1<cr>==";
        options = {
          desc = "Move Down";
        };
      }
      {
        mode = "n";
        key = "<A-k>";
        action = "<cmd>m .-2<cr>==";
        options = {
          desc = "Move Up";
        };
      }
      {
        mode = "i";
        key = "<A-j>";
        action = "<esc><cmd>m .+1<cr>==gi";
        options = {
          desc = "Move Down";
        };
      }
      {
        mode = "i";
        key = "<A-k>";
        action = "<esc><cmd>m .-2<cr>==gi";
        options = {
          desc = "Move Up";
        };
      }
      {
        mode = "v";
        key = "<A-j>";
        action = ":m '>+1<cr>gv=gv";
        options = {
          desc = "Move Down";
        };
      }
      {
        mode = "v";
        key = "<A-k>";
        action = ":m '<-2<cr>gv=gv";
        options = {
          desc = "Move Up";
        };
      }
      {
        mode = "i";
        key = ";";
        action = ";<c-g>u";
      }
      {
        mode = "i";
        key = ".";
        action = ".<c-g>u";
      }
      {
        mode = [
          "i"
          "x"
          "n"
          "s"
        ];
        key = "<C-s>";
        action = "<cmd>w<cr><esc>";
        options = {
          desc = "Save File";
        };
      }
      {
        mode = [
          "i"
          "n"
        ];
        key = "<esc>";
        action = "<cmd>noh<cr><esc>";
        options = {
          desc = "Escape and Clear hlsearch";
        };
      }
      {
        mode = "n";
        key = "<leader>ur";
        action = "<Cmd>nohlsearch<Bar>diffupdate<Bar>normal! <C-L><CR>";
        options = {
          desc = "Redraw / Clear hlsearch / Diff Update";
        };
      }
      {
        mode = "n";
        key = "n";
        action = "'Nn'[v:searchforward].'zv'";
        options = {
          expr = true;
          desc = "Next Search Result";
        };
      }
      {
        mode = "x";
        key = "n";
        action = "'Nn'[v:searchforward]";
        options = {
          expr = true;
          desc = "Next Search Result";
        };
      }
      {
        mode = "o";
        key = "n";
        action = "'Nn'[v:searchforward]";
        options = {
          expr = true;
          desc = "Next Search Result";
        };
      }
      {
        mode = "n";
        key = "N";
        action = "'nN'[v:searchforward].'zv'";
        options = {
          expr = true;
          desc = "Prev Search Result";
        };
      }
      {
        mode = "x";
        key = "N";
        action = "'nN'[v:searchforward]";
        options = {
          expr = true;
          desc = "Prev Search Result";
        };
      }
      {
        mode = "o";
        key = "N";
        action = "'nN'[v:searchforward]";
        options = {
          expr = true;
          desc = "Prev Search Result";
        };
      }
      {
        mode = "n";
        key = "<leader>cd";
        action = "vim.diagnostic.open_float";
        options = {
          desc = "Line Diagnostics";
        };
      }
      {
        mode = "n";
        key = "]d";
        action = "diagnostic_goto(true)";
        options = {
          desc = "Next Diagnostic";
        };
      }
      {
        mode = "n";
        key = "[d";
        action = "diagnostic_goto(false)";
        options = {
          desc = "Prev Diagnostic";
        };
      }
      {
        mode = "n";
        key = "]e";
        action = "diagnostic_goto(true 'ERROR')";
        options = {
          desc = "Next Error";
        };
      }
      {
        mode = "n";
        key = "[e";
        action = "diagnostic_goto(false 'ERROR')";
        options = {
          desc = "Prev Error";
        };
      }
      {
        mode = "n";
        key = "]w";
        action = "diagnostic_goto(true 'WARN')";
        options = {
          desc = "Next Warning";
        };
      }
      {
        mode = "n";
        key = "[w";
        action = "diagnostic_goto(false 'WARN')";
        options = {
          desc = "Prev Warning";
        };
      }
      {
        mode = "n";
        key = "<leader>qq";
        action = "<cmd>qa<cr>";
        options = {
          desc = "Quit All";
        };
      }
      {
        mode = "n";
        key = "<leader>ui";
        action = "vim.show_pos";
        options = {
          desc = "Inspect Pos";
        };
      }
      {
        mode = "t";
        key = "<esc><esc>";
        action = "<c-\\><c-n>";
        options = {
          desc = "Enter Normal Mode";
        };
      }
      {
        mode = "t";
        key = "<C-h>";
        action = "<cmd>wincmd h<cr>";
        options = {
          desc = "Go to Left Window";
        };
      }
      {
        mode = "t";
        key = "<C-j>";
        action = "<cmd>wincmd j<cr>";
        options = {
          desc = "Go to Lower Window";
        };
      }
      {
        mode = "t";
        key = "<C-k>";
        action = "<cmd>wincmd k<cr>";
        options = {
          desc = "Go to Upper Window";
        };
      }
      {
        mode = "t";
        key = "<C-l>";
        action = "<cmd>wincmd l<cr>";
        options = {
          desc = "Go to Right Window";
        };
      }
      {
        mode = "t";
        key = "<C-/>";
        action = "<cmd>close<cr>";
        options = {
          desc = "Hide Terminal";
        };
      }
      {
        mode = "n";
        key = "<leader>ww";
        action = "<C-W>p";
        options = {
          desc = "Other Window";
          remap = true;
        };
      }
      {
        mode = "n";
        key = "<leader>wd";
        action = "<C-W>c";
        options = {
          desc = "Delete Window";
          remap = true;
        };
      }
      {
        mode = "n";
        key = "<leader>w-";
        action = "<C-W>s";
        options = {
          desc = "Split Window Below";
          remap = true;
        };
      }
      {
        mode = "n";
        key = "<leader>w|";
        action = "<C-W>v";
        options = {
          desc = "Split Window Right";
          remap = true;
        };
      }
      {
        mode = "n";
        key = "<leader>-";
        action = "<C-W>s";
        options = {
          desc = "Split Window Below";
          remap = true;
        };
      }
      {
        mode = "n";
        key = "<leader>|";
        action = "<C-W>v";
        options = {
          desc = "Split Window Right";
          remap = true;
        };
      }
      {
        mode = "n";
        key = "<leader><tab>l";
        action = "<cmd>tablast<cr>";
        options = {
          desc = "Last Tab";
        };
      }
      {
        mode = "n";
        key = "<leader><tab>f";
        action = "<cmd>tabfirst<cr>";
        options = {
          desc = "First Tab";
        };
      }
      {
        mode = "n";
        key = "<leader><tab><tab>";
        action = "<cmd>tabnew<cr>";
        options = {
          desc = "New Tab";
        };
      }
      {
        mode = "n";
        key = "<leader><tab>]";
        action = "<cmd>tabnext<cr>";
        options = {
          desc = "Next Tab";
        };
      }
      {
        mode = "n";
        key = "<leader><tab>d";
        action = "<cmd>tabclose<cr>";
        options = {
          desc = "Close Tab";
        };
      }
      {
        mode = "n";
        key = "<leader><tab>[";
        action = "<cmd>tabprevious<cr>";
        options = {
          desc = "Previous Tab";
        };
      }

      # ── Neo-tree keymap ──
      {
        mode = [ "n" ];
        key = "<leader>e";
        action = "<cmd>Neotree toggle<cr>";
        options = {
          desc = "Open/Close Neotree";
        };
      }

      # ── Undotree keymap ──
      {
        mode = "n";
        key = "<leader>ut";
        action = "<cmd>UndotreeToggle<CR>";
        options = {
          silent = true;
          desc = "Undotree";
        };
      }

      # ── LazyGit keymap ──
      {
        mode = "n";
        key = "<leader>gg";
        action = "<cmd>LazyGit<CR>";
        options = {
          desc = "LazyGit (root dir)";
        };
      }

      # ── Bufferline keymaps ──
      {
        mode = "n";
        key = "]b";
        action = "<cmd>BufferLineCycleNext<cr>";
        options = {
          desc = "Cycle to next buffer";
        };
      }
      {
        mode = "n";
        key = "[b";
        action = "<cmd>BufferLineCyclePrev<cr>";
        options = {
          desc = "Cycle to previous buffer";
        };
      }
      {
        mode = "n";
        key = "<S-l>";
        action = "<cmd>BufferLineCycleNext<cr>";
        options = {
          desc = "Cycle to next buffer";
        };
      }
      {
        mode = "n";
        key = "<S-h>";
        action = "<cmd>BufferLineCyclePrev<cr>";
        options = {
          desc = "Cycle to previous buffer";
        };
      }
      {
        mode = "n";
        key = "<leader>bd";
        action = "<cmd>bdelete<cr>";
        options = {
          desc = "Delete buffer";
        };
      }
      {
        mode = "n";
        key = "<leader>bl";
        action = "<cmd>BufferLineCloseLeft<cr>";
        options = {
          desc = "Delete buffers to the left";
        };
      }
      {
        mode = "n";
        key = "<leader>bo";
        action = "<cmd>BufferLineCloseOthers<cr>";
        options = {
          desc = "Delete other buffers";
        };
      }
      {
        mode = "n";
        key = "<leader>bp";
        action = "<cmd>BufferLineTogglePin<cr>";
        options = {
          desc = "Toggle pin";
        };
      }
      {
        mode = "n";
        key = "<leader>bP";
        action = "<Cmd>BufferLineGroupClose ungrouped<CR>";
        options = {
          desc = "Delete non-pinned buffers";
        };
      }

      # ── Markdown Preview keymap ──
      {
        mode = "n";
        key = "<leader>mp";
        action = "<cmd>MarkdownPreview<cr>";
        options = {
          desc = "Toggle Markdown Preview";
        };
      }

      # ── Telescope keymaps ──
      {
        mode = "n";
        key = "<leader>sd";
        action = "<cmd>Telescope diagnostics bufnr=0<cr>";
        options = {
          desc = "Document diagnostics";
        };
      }
      {
        mode = "n";
        key = "<leader>fe";
        action = "<cmd>Telescope file_browser<cr>";
        options = {
          desc = "File browser";
        };
      }
      {
        mode = "n";
        key = "<leader>fE";
        action = "<cmd>Telescope file_browser path=%:p:h select_buffer=true<cr>";
        options = {
          desc = "File browser";
        };
      }

      # ── ToggleTerm keymaps ──
      {
        mode = "n";
        key = "<leader>t";
        action = "<cmd>ToggleTerm<cr>";
        options = {
          desc = "Toggle Scratch Terminal";
        };
      }
      {
        mode = "t";
        key = "<Esc><Esc>";
        action = "<C-\\><C-n>";
        options = {
          desc = "Exit Terminal Mode";
        };
      }
    ];

    # ── Auto Commands ────────────────────────────────────────────────────────

    autoGroups = {
      highlight_yank = { };
      vim_enter = { };
      indentscope = { };
      restore_cursor = { };
      filetypes = { };
    };

    autoCmd = [
      {
        group = "highlight_yank";
        event = [ "TextYankPost" ];
        pattern = "*";
        callback = {
          __raw = ''
            function()
              vim.highlight.on_yank()
            end
          '';
        };
      }
      {
        group = "vim_enter";
        event = [ "VimEnter" ];
        pattern = "*";
        callback = {
          __raw = ''
            function()
              vim.cmd('Startup')
            end
          '';
        };
      }
      {
        group = "indentscope";
        event = [ "FileType" ];
        pattern = [
          "help"
          "Startup"
          "startup"
          "neo-tree"
          "Trouble"
          "trouble"
          "notify"
        ];
        callback = {
          __raw = ''
            function()
              vim.b.miniindentscope_disable = true
            end
          '';
        };
      }
      {
        group = "restore_cursor";
        event = [ "BufReadPost" ];
        pattern = "*";
        callback = {
          __raw = ''
            function()
              if
                vim.fn.line "'\"" > 1
                and vim.fn.line "'\"" <= vim.fn.line "$"
                and vim.bo.filetype ~= "commit"
                and vim.fn.index({ "xxd", "gitrebase" }, vim.bo.filetype) == -1
              then
                vim.cmd "normal! g`\""
              end
            end
          '';
        };
      }
    ];

    # ── File Types ───────────────────────────────────────────────────────────

    files."ftdetect/terraformft.lua".autoCmd = [
      {
        group = "filetypes";
        event = [
          "BufRead"
          "BufNewFile"
        ];
        pattern = [
          "*.tf"
          "*.tfvars"
          "*.hcl"
        ];
        command = "set ft=terraform";
      }
    ];

    files."ftdetect/bicepft.lua".autoCmd = [
      {
        group = "filetypes";
        event = [
          "BufRead"
          "BufNewFile"
        ];
        pattern = [
          "*.bicep"
          "*.bicepparam"
        ];
        command = "set ft=bicep";
      }
    ];

    # ── Theme (Catppuccin Macchiato) ─────────────────────────────────────────

    colorschemes = {
      catppuccin = {
        enable = true;
        settings = {
          background = {
            light = "macchiato";
            dark = "mocha";
          };
          custom_highlights = ''
            function(highlights)
              return {
              CursorLineNr = { fg = highlights.peach, style = {} },
              NavicText = { fg = highlights.text },
              }
            end
          '';
          flavour = "macchiato";
          no_bold = false;
          no_italic = false;
          no_underline = false;
          transparent_background = true;
          integrations = {
            cmp = true;
            notify = true;
            gitsigns = true;
            neotree = true;
            which_key = true;
            illuminate = {
              enabled = true;
              lsp = true;
            };
            navic = {
              enabled = true;
              custom_bg = "NONE";
            };
            treesitter = true;
            telescope.enabled = true;
            indent_blankline.enabled = true;
            mini = {
              enabled = true;
              indentscope_color = "rosewater";
            };
            native_lsp = {
              enabled = true;
              inlay_hints = {
                background = true;
              };
              virtual_text = {
                errors = [ "italic" ];
                hints = [ "italic" ];
                information = [ "italic" ];
                warnings = [ "italic" ];
                ok = [ "italic" ];
              };
              underlines = {
                errors = [ "underline" ];
                hints = [ "underline" ];
                information = [ "underline" ];
                warnings = [ "underline" ];
              };
            };
          };
        };
      };
    };

    # ── Completion (nvim-cmp) ────────────────────────────────────────────────

    plugins.cmp = {
      enable = true;
      settings = {
        autoEnableSources = true;
        experimental = {
          ghost_text = false;
        };
        performance = {
          debounce = 60;
          fetchingTimeout = 200;
          maxViewEntries = 30;
        };
        snippet = {
          expand = "luasnip";
        };
        formatting = {
          fields = [
            "kind"
            "abbr"
            "menu"
          ];
        };
        sources = [
          { name = "git"; }
          { name = "nvim_lsp"; }
          {
            name = "buffer";
            option.get_bufnrs.__raw = "vim.api.nvim_list_bufs";
            keywordLength = 3;
          }
          {
            name = "path";
            keywordLength = 3;
          }
          {
            name = "luasnip";
            keywordLength = 3;
          }
        ];
        window = {
          completion = {
            border = "solid";
          };
          documentation = {
            border = "solid";
          };
        };
        mapping = {
          "<C-Tab>" = "cmp.mapping(cmp.mapping.select_next_item(), {'i', 's'})";
          "<C-j>" = "cmp.mapping.select_next_item()";
          "<C-k>" = "cmp.mapping.select_prev_item()";
          "<C-e>" = "cmp.mapping.abort()";
          "<C-b>" = "cmp.mapping.scroll_docs(-4)";
          "<C-f>" = "cmp.mapping.scroll_docs(4)";
          "<C-Space>" = "cmp.mapping.complete()";
          "<C-CR>" = "cmp.mapping.confirm({ select = true })";
          "<S-CR>" = "cmp.mapping.confirm({ behavior = cmp.ConfirmBehavior.Replace, select = true })";
        };
      };
    };

    plugins.cmp-nvim-lsp.enable = true;
    plugins.cmp-buffer.enable = true;
    plugins.cmp-path.enable = true;
    plugins.cmp_luasnip.enable = true;
    plugins.cmp-cmdline.enable = false;

    plugins.lspkind = {
      enable = true;
      settings = {
        maxwidth = 50;
        ellipsis_char = "...";
      };
    };

    plugins.nvim-autopairs = {
      enable = true;
      settings = {
        disable_filetype = [
          "TelescopePrompt"
          "vim"
        ];
      };
    };

    plugins.schemastore = {
      enable = true;
      json = {
        enable = true;
      };
      yaml = {
        enable = true;
      };
    };

    # ── Snippets ───────────────────────────────────────────────────────────

    plugins.luasnip = {
      enable = true;
      settings = {
        enable_autosnippets = true;
        store_selection_keys = "<Tab>";
      };
    };

    # ── Editor Plugins ───────────────────────────────────────────────────────

    plugins.illuminate = {
      enable = true;
      settings = {
        under_cursor = false;
        filetypes_denylist = [
          "Outline"
          "TelescopePrompt"
          "alpha"
          "harpoon"
          "reason"
        ];
      };
    };

    plugins.indent-blankline = {
      enable = true;
    };

    plugins.navic = {
      enable = true;
      settings = {
        separator = "  ";
        highlight = true;
        depthLimit = 5;
        lsp = {
          autoAttach = true;
        };
        icons = {
          Array = "󱃵  ";
          Boolean = "  ";
          Class = "  ";
          Constant = "  ";
          Constructor = "  ";
          Enum = " ";
          EnumMember = " ";
          Event = " ";
          Field = "󰽏 ";
          File = " ";
          Function = "󰡱 ";
          Interface = " ";
          Key = "  ";
          Method = " ";
          Module = "󰕳 ";
          Namespace = " ";
          Null = "󰟢 ";
          Number = " ";
          Object = "  ";
          Operator = " ";
          Package = "󰏖 ";
          String = " ";
          Struct = " ";
          TypeParameter = " ";
          Variable = " ";
        };
      };
    };

    plugins.neo-tree = {
      enable = true;
      settings = {
        sources = [
          "filesystem"
          "buffers"
          "git_status"
          "document_symbols"
        ];
        add_blank_line_at_top = false;
        filesystem = {
          bind_to_cwd = false;
          follow_current_file = {
            enabled = true;
          };
        };
        default_component_configs = {
          indent = {
            with_expanders = true;
            expander_collapsed = "󰅂";
            expander_expanded = "󰅀";
            expander_highlight = "NeoTreeExpander";
          };
          git_status = {
            symbols = {
              added = " ";
              conflict = "󰩌 ";
              deleted = "󱂥";
              ignored = " ";
              modified = " ";
              renamed = "󰑕";
              staged = "󰩍";
              unstaged = "";
              untracked = " ";
            };
          };
        };
      };
    };

    plugins.todo-comments = {
      enable = true;
      settings = {
        colors = {
          error = [
            "DiagnosticError"
            "ErrorMsg"
            "#ED8796"
          ];
          warning = [
            "DiagnosticWarn"
            "WarningMsg"
            "#EED49F"
          ];
          info = [
            "DiagnosticInfo"
            "#EED49F"
          ];
          default = [
            "Identifier"
            "#F5A97F"
          ];
          test = [
            "Identifier"
            "#8AADF4"
          ];
        };
      };
    };

    plugins.treesitter = {
      enable = true;
      settings = {
        indent.enable = true;
      };
      highlight = {
        enable = true;
        disable = [ "nix" ];
      };
      folding.enable = false;
      nixvimInjections = true;
      grammarPackages = with pkgs.vimPlugins.nvim-treesitter.builtGrammars; [
        bash
        bicep
        css
        diff
        dockerfile
        git_config
        git_rebase
        gitattributes
        gitcommit
        gitignore
        go
        gomod
        gosum
        gotmpl
        gowork
        hcl
        helm
        html
        javascript
        json
        lua
        make
        markdown
        markdown_inline
        nix
        python
        regex
        sql
        terraform
        toml
        tsx
        typescript
        vim
        vimdoc
        yaml
      ];
    };

    plugins.treesitter-textobjects = {
      enable = false;
      settings = {
        select = {
          enable = true;
          lookahead = true;
          keymaps = {
            "aa" = "@parameter.outer";
            "ia" = "@parameter.inner";
            "af" = "@function.outer";
            "if" = "@function.inner";
            "ac" = "@class.outer";
            "ic" = "@class.inner";
            "ii" = "@conditional.inner";
            "ai" = "@conditional.outer";
            "il" = "@loop.inner";
            "al" = "@loop.outer";
            "at" = "@comment.outer";
          };
        };
        move = {
          enable = true;
          goto_next_start = {
            "]m" = "@function.outer";
            "]]" = "@class.outer";
          };
          goto_next_end = {
            "]M" = "@function.outer";
            "][" = "@class.outer";
          };
          goto_previous_start = {
            "[m" = "@function.outer";
            "[[" = "@class.outer";
          };
          goto_previous_end = {
            "[M" = "@function.outer";
            "[]" = "@class.outer";
          };
        };
        swap = {
          enable = true;
          swap_next = {
            "<leader>a" = "@parameters.inner";
          };
          swap_previous = {
            "<leader>A" = "@parameter.outer";
          };
        };
      };
    };

    plugins.undotree = {
      enable = true;
      settings = {
        autoOpenDiff = true;
        focusOnToggle = true;
      };
    };

    # ── UI Plugins ─────────────────────────────────────────────────────────

    plugins.bufferline = {
      enable = true;
      settings = {
        options = {
          diagnostics = "nvim_lsp";
          mode = "buffers";
          close_icon = " ";
          buffer_close_icon = "󰱝 ";
          modified_icon = "󰔯 ";
          offsets = [
            {
              filetype = "neo-tree";
              text = "Neo-tree";
              highlight = "Directory";
              text_align = "left";
            }
          ];
        };
      };
    };

    plugins.lualine = {
      enable = true;
      settings = {
        options = {
          globalstatus = true;
          extensions = [
            "fzf"
            "neo-tree"
          ];
          disabledFiletypes = {
            statusline = [
              "startup"
              "alpha"
            ];
          };
          theme = "catppuccin";
        };
        sections = {
          lualine_a = [
            {
              __unkeyed-1 = "mode";
              icon = "";
            }
          ];
          lualine_b = [
            {
              __unkeyed-1 = "branch";
              icon = "";
            }
            {
              __unkeyed-1 = "diff";
              symbols = {
                added = " ";
                modified = " ";
                removed = " ";
              };
            }
          ];
          lualine_c = [
            {
              __unkeyed-1 = "diagnostics";
              sources = [ "nvim_lsp" ];
              symbols = {
                error = " ";
                warn = " ";
                info = " ";
                hint = "󰝶 ";
              };
            }
            { __unkeyed-1 = "navic"; }
          ];
          lualine_x = [
            {
              __unkeyed-1 = "filetype";
              icon_only = true;
              separator = "";
              padding = {
                left = 1;
                right = 0;
              };
            }
            {
              __unkeyed-1 = "filename";
              path = 1;
            }
          ];
          lualine_y = [ { __unkeyed-1 = "progress"; } ];
          lualine_z = [ { __unkeyed-1 = "location"; } ];
        };
      };
    };

    plugins.startup = {
      enable = true;
      settings = {
        colors = {
          background = "#ffffff";
          folded_section = "#ffffff";
        };
        header = {
          type = "text";
          oldfiles_directory = false;
          align = "center";
          fold_section = false;
          title = "Header";
          margin = 5;
          content = [
            " ██████╗░███████╗░█████╗░░█████╗░██████╗░████████╗░░░████████╗███████╗░█████╗░██╗░░██╗"
            " ██╔══██╗██╔════╝██╔══██╗██╔══██╗██╔══██╗╚══██╔══╝░░░╚══██╔══╝██╔════╝██╔══██╗██║░░██║"
            " ██║░░██║█████╗░░██║░░╚═╝██║░░██║██████╔╝░░░██║░░░░░░░░░██║░░░█████╗░░██║░░╚═╝███████║"
            " ██║░░██║██╔══╝░░██║░░██╗██║░░██║██╔══██╗░░░██║░░░░░░░░░██║░░░██╔══╝░░██║░░██╗██╔══██║"
            " ██████╔╝███████╗╚█████╔╝╚█████╔╝██║░░██║░░░██║░░░██╗░░░██║░░░███████╗╚█████╔╝██║░░██║"
            " ╚═════╝░╚══════╝░╚════╝░░╚════╝░╚═╝░░╚═╝░░░╚═╝░░░╚═╝░░░╚═╝░░░╚══════╝░╚════╝░╚═╝░░╚═╝"
          ];
          highlight = "Statement";
          default_color = "";
          oldfiles_amount = 0;
        };
        body = {
          type = "mapping";
          oldfiles_directory = false;
          align = "center";
          fold_section = false;
          title = "Menu";
          margin = 5;
          content = [
            [
              " Find File"
              "Telescope find_files"
              "ff"
            ]
            [
              "󰍉 Find Word"
              "Telescope live_grep"
              "fr"
            ]
            [
              " Recent Files"
              "Telescope oldfiles"
              "fg"
            ]
            [
              " File Browser"
              "Telescope file_browser"
              "fe"
            ]
            [
              "󰧑 SecondBrain"
              "edit ~/projects/personal/SecondBrain"
              "sb"
            ]
          ];
          highlight = "string";
          default_color = "";
          oldfiles_amount = 0;
        };
        options = {
          paddings = [
            1
            3
          ];
        };
        parts = [
          "header"
          "body"
        ];
      };
    };

    # ── LSP ──────────────────────────────────────────────────────────────────

    plugins.lsp-lines.enable = true;
    plugins.helm.enable = true;

    plugins.lsp = {
      enable = true;
      inlayHints = true;
      servers = {
        html = {
          enable = true;
        };
        lua_ls = {
          enable = true;
        };
        nil_ls = {
          enable = true;
        };
        ts_ls = {
          enable = true;
        };
        marksman = {
          enable = true;
        };
        pyright = {
          enable = true;
        };
        gopls = {
          enable = true;
        };
        terraformls = {
          enable = true;
        };
        jsonls = {
          enable = true;
        };
        helm_ls = {
          enable = true;
          extraOptions = {
            settings = {
              "helm_ls" = {
                yamlls = {
                  path = "${pkgs.yaml-language-server}/bin/yaml-language-server";
                };
              };
            };
          };
        };
        yamlls = {
          enable = true;
          extraOptions = {
            settings = {
              yaml = {
                schemas = {
                  kubernetes = "*.yaml";
                  "https://json.schemastore.org/github-workflow" = ".github/workflows/*";
                  "https://json.schemastore.org/github-action" = ".github/action.{yml,yaml}";
                  "https://json.schemastore.org/ansible-stable-2.9" = "roles/tasks/*.{yml,yaml}";
                  "https://json.schemastore.org/kustomization" = "kustomization.{yml,yaml}";
                  "https://json.schemastore.org/ansible-playbook" = "*play*.{yml,yaml}";
                  "https://json.schemastore.org/chart" = "Chart.{yml,yaml}";
                  "https://json.schemastore.org/dependabot-v2" = ".github/dependabot.{yml,yaml}";
                  "https://raw.githubusercontent.com/compose-spec/compose-spec/master/schema/compose-spec.json" =
                    "*docker-compose*.{yml,yaml}";
                  "https://raw.githubusercontent.com/argoproj/argo-workflows/master/api/jsonschema/schema.json" =
                    "*flow*.{yml,yaml}";
                };
              };
            };
          };
        };
      };
      keymaps = {
        silent = true;
        lspBuf = {
          gd = {
            action = "definition";
            desc = "Goto Definition";
          };
          gr = {
            action = "references";
            desc = "Goto References";
          };
          gD = {
            action = "declaration";
            desc = "Goto Declaration";
          };
          gI = {
            action = "implementation";
            desc = "Goto Implementation";
          };
          gT = {
            action = "type_definition";
            desc = "Type Definition";
          };
          K = {
            action = "hover";
            desc = "Hover";
          };
          "<leader>cw" = {
            action = "workspace_symbol";
            desc = "Workspace Symbol";
          };
          "<leader>cr" = {
            action = "rename";
            desc = "Rename";
          };
        };
      };
    };

    plugins.fidget = {
      enable = true;
      settings = {
        logger = {
          level = "warn";
          float_precision = 1.0e-2;
        };
        progress = {
          poll_rate = 0;
          suppress_on_insert = true;
          ignore_done_already = false;
          ignore_empty_message = false;
          clear_on_detach = ''
            function(client_id)
              local client = vim.lsp.get_client_by_id(client_id)
              return client and client.name or nil
            end
          '';
          notification_group = ''
            function(msg) return msg.lsp_client.name end
          '';
          ignore = [ ];
          lsp = {
            progress_ringbuf_size = 0;
          };
          display = {
            render_limit = 16;
            done_ttl = 3;
            done_icon = "✔";
            done_style = "Constant";
            progress_ttl = 10;
            progress_icon = {
              pattern = "dots";
              period = 1;
            };
            progress_style = "WarningMsg";
            group_style = "Title";
            icon_style = "Question";
            priority = 30;
            skip_history = true;
            format_message = ''
              require ("fidget.progress.display").default_format_message
            '';
            format_annote = ''
              function (msg) return msg.title end
            '';
            format_group_name = ''
              function (group) return tostring (group) end
            '';
            overrides = {
              rust_analyzer = {
                name = "rust-analyzer";
              };
            };
          };
        };
        notification = {
          poll_rate = 10;
          filter = "info";
          history_size = 128;
          override_vim_notify = true;
          redirect = {
            __raw = ''
              function(msg, level, opts)
                if opts and opts.on_open then
                  return require("fidget.integration.nvim-notify").delegate(msg, level, opts)
                end
              end
            '';
          };
          configs = {
            default = {
              name = "Notifications";
              icon = "󰏪";
              group = "Notifications";
              annote = true;
              debug = false;
              debug_rate = 0.25;
            };
          };
          window = {
            normal_hl = "Comment";
            winblend = 0;
            border = "none";
            zindex = 45;
            max_width = 0;
            max_height = 0;
            x_padding = 1;
            y_padding = 0;
            align = "bottom";
            relative = "editor";
          };
          view = {
            stack_upwards = true;
            icon_separator = " ";
            group_separator = "---";
            group_separator_hl = "Comment";
          };
        };
      };
    };

    plugins.conform-nvim = {
      enable = true;
      settings = {
        format_on_save = ''
          function(bufnr)
            if vim.g.disable_autoformat or vim.b[bufnr].disable_autoformat then
              return
            end
            if slow_format_filetypes[vim.bo[bufnr].filetype] then
              return
            end
            local function on_format(err)
              if err and err:match("timeout$") then
                slow_format_filetypes[vim.bo[bufnr].filetype] = true
              end
            end
            return { timeout_ms = 200, lsp_fallback = true }, on_format
           end
        '';
        format_after_save = ''
          function(bufnr)
            if vim.g.disable_autoformat or vim.b[bufnr].disable_autoformat then
              return
            end
            if not slow_format_filetypes[vim.bo[bufnr].filetype] then
              return
            end
            return { lsp_fallback = true }
          end
        '';
        notify_on_error = true;
        formatters_by_ft = {
          html = [ "prettier" ];
          css = [ "prettier" ];
          javascript = [ "prettier" ];
          typescript = [ "prettier" ];
          python = [
            "black"
            "isort"
          ];
          lua = [ "stylua" ];
          nix = [ "nixfmt" ];
          markdown = [ "prettier" ];
          yaml = [ "prettier" ];
          terraform = [ "terraform_fmt" ];
          bicep = [ "bicep" ];
          bash = [
            "shellcheck"
            "shellharden"
            "shfmt"
          ];
          json = [ "jq" ];
          "_" = [ "trim_whitespace" ];
        };
        formatters = {
          black = {
            command = "${lib.getExe pkgs.black}";
          };
          isort = {
            command = "${lib.getExe pkgs.isort}";
          };
          nixfmt = {
            command = "${lib.getExe pkgs.nixfmt}";
          };
          alejandra = {
            command = "${lib.getExe pkgs.alejandra}";
          };
          jq = {
            command = "${lib.getExe pkgs.jq}";
          };
          prettier = {
            command = "${lib.getExe pkgs.prettier}";
          };
          stylua = {
            command = "${lib.getExe pkgs.stylua}";
          };
          shellcheck = {
            command = "${lib.getExe pkgs.shellcheck}";
          };
          shfmt = {
            command = "${lib.getExe pkgs.shfmt}";
          };
          shellharden = {
            command = "${lib.getExe pkgs.shellharden}";
          };
          bicep = {
            command = "${lib.getExe pkgs.bicep}";
          };
        };
      };
    };

    # ── Git ──────────────────────────────────────────────────────────────────

    plugins.gitsigns = {
      enable = true;
      settings = {
        signs = {
          add = {
            text = " ";
          };
          change = {
            text = " ";
          };
          delete = {
            text = " ";
          };
          untracked = {
            text = "";
          };
          topdelete = {
            text = "󱂥 ";
          };
          changedelete = {
            text = "󱂧 ";
          };
        };
      };
    };

    extraPlugins = with pkgs.vimPlugins; [
      lazygit-nvim
      ansible-vim
    ];

    # ── Telescope ────────────────────────────────────────────────────────────

    plugins.telescope = {
      enable = true;
      extensions = {
        file-browser = {
          enable = true;
        };
        fzf-native = {
          enable = true;
        };
      };
      settings = {
        defaults = {
          layout_config = {
            horizontal = {
              prompt_position = "top";
            };
          };
          sorting_strategy = "ascending";
        };
      };
      keymaps = {
        "<leader><space>" = {
          action = "find_files";
          options = {
            desc = "Find project files";
          };
        };
        "<leader>/" = {
          action = "live_grep";
          options = {
            desc = "Grep (root dir)";
          };
        };
        "<leader>:" = {
          action = "command_history";
          options = {
            desc = "Command History";
          };
        };
        "<leader>b" = {
          action = "buffers";
          options = {
            desc = "+buffer";
          };
        };
        "<leader>ff" = {
          action = "find_files";
          options = {
            desc = "Find project files";
          };
        };
        "<leader>fr" = {
          action = "live_grep";
          options = {
            desc = "Find text";
          };
        };
        "<leader>fR" = {
          action = "resume";
          options = {
            desc = "Resume";
          };
        };
        "<leader>fg" = {
          action = "oldfiles";
          options = {
            desc = "Recent";
          };
        };
        "<leader>fb" = {
          action = "buffers";
          options = {
            desc = "Buffers";
          };
        };
        "<C-p>" = {
          action = "git_files";
          options = {
            desc = "Search git files";
          };
        };
        "<leader>gc" = {
          action = "git_commits";
          options = {
            desc = "Commits";
          };
        };
        "<leader>gs" = {
          action = "git_status";
          options = {
            desc = "Status";
          };
        };
        "<leader>sa" = {
          action = "autocommands";
          options = {
            desc = "Auto Commands";
          };
        };
        "<leader>sb" = {
          action = "current_buffer_fuzzy_find";
          options = {
            desc = "Buffer";
          };
        };
        "<leader>sc" = {
          action = "command_history";
          options = {
            desc = "Command History";
          };
        };
        "<leader>sC" = {
          action = "commands";
          options = {
            desc = "Commands";
          };
        };
        "<leader>sD" = {
          action = "diagnostics";
          options = {
            desc = "Workspace diagnostics";
          };
        };
        "<leader>sh" = {
          action = "help_tags";
          options = {
            desc = "Help pages";
          };
        };
        "<leader>sH" = {
          action = "highlights";
          options = {
            desc = "Search Highlight Groups";
          };
        };
        "<leader>sk" = {
          action = "keymaps";
          options = {
            desc = "Keymaps";
          };
        };
        "<leader>sM" = {
          action = "man_pages";
          options = {
            desc = "Man pages";
          };
        };
        "<leader>sm" = {
          action = "marks";
          options = {
            desc = "Jump to Mark";
          };
        };
        "<leader>so" = {
          action = "vim_options";
          options = {
            desc = "Options";
          };
        };
        "<leader>sR" = {
          action = "resume";
          options = {
            desc = "Resume";
          };
        };
        "<leader>uC" = {
          action = "colorscheme";
          options = {
            desc = "Colorscheme preview";
          };
        };
      };
    };

    plugins.web-devicons = {
      enable = true;
    };

    # ── Utilities ────────────────────────────────────────────────────────────

    plugins.which-key = {
      enable = true;
    };

    plugins.mini = {
      enable = true;
      modules = {
        indentscope = {
          symbol = "│";
          options = {
            try_as_border = true;
          };
        };
        surround = { };
      };
    };

    plugins.markdown-preview = {
      enable = true;
      settings = {
        browser = "firefox";
        echo_preview_url = 1;
        port = "6969";
        preview_options = {
          disable_filename = 1;
          disable_sync_scroll = 1;
          sync_scroll_type = "middle";
        };
        theme = "dark";
      };
    };

    plugins.obsidian = {
      enable = false;
      settings = {
        workspaces = [
          {
            name = "SecondBrain";
            path = "~/projects/personal/SecondBrain";
          }
        ];
        templates = {
          subdir = "templates";
          dateFormat = "%Y-%m-%d";
          timeFormat = "%H:%M";
          substitutions = { };
        };
        dailyNotes = {
          folder = "0_Daily_Notes";
          dateFormat = "%Y-%m-%d";
          aliasFormat = "%B %-d, %Y";
        };
      };
    };

    plugins.toggleterm = {
      enable = true;
      settings = {
        direction = "float";
        float_opts = {
          border = "curved";
        };
      };
    };

    # ── Lua Configuration ─────────────────────────────────────────────────────

    extraConfigLua = ''
      luasnip = require("luasnip")
      kind_icons = {
        Text = "󰊄",
        Method = " ",
        Function = "󰡱 ",
        Constructor = " ",
        Field = " ",
        Variable = "󱀍 ",
        Class = " ",
        Interface = " ",
        Module = "󰕳 ",
        Property = " ",
        Unit = " ",
        Value = " ",
        Enum = " ",
        Keyword = " ",
        Snippet = " ",
        Color = " ",
        File = "",
        Reference = " ",
        Folder = " ",
        EnumMember = " ",
        Constant = " ",
        Struct = " ",
        Event = " ",
        Operator = " ",
        TypeParameter = " ",
      }

      local cmp = require'cmp'

      -- Use buffer source for `/`
      cmp.setup.cmdline({'/', "?" }, {
        sources = {
          { name = 'buffer' }
        }
      })

      -- Set configuration for specific filetype.
      cmp.setup.filetype('gitcommit', {
        sources = cmp.config.sources({
          { name = 'cmp_git' },
        }, {
          { name = 'buffer' },
        })
      })

      -- Use cmdline & path source for ':'
      cmp.setup.cmdline(':', {
        sources = cmp.config.sources({
          { name = 'path' }
        }, {
          { name = 'cmdline' }
        }),
      })

      require("telescope").setup{
        pickers = {
          colorscheme = {
            enable_preview = true
          }
        }
      }

      local _border = "rounded"

      -- Language servers can emit large volumes of routine stderr output.
      vim.lsp.log.set_level(vim.log.levels.OFF)

      vim.lsp.handlers["textDocument/hover"] = function(err, result, ctx, config)
        config = config or {}
        config.border = _border
        return vim.lsp.handlers.hover(err, result, ctx, config)
      end

      vim.lsp.handlers["textDocument/signatureHelp"] = function(err, result, ctx, config)
        config = config or {}
        config.border = _border
        return vim.lsp.handlers.signature_help(err, result, ctx, config)
      end

      vim.diagnostic.config{
        float={border=_border}
      };

      require('lspconfig.ui.windows').default_options = {
        border = _border
      }

      require("telescope").load_extension("lazygit")

      -- Workaround for treesitter #is-not? predicate missing in some parsers (nix)
      vim.treesitter.query.add_predicate("is-not?", function()
        return true
      end, { force = true, all = false })
    '';

    extraConfigLuaPre = ''
      vim.fn.sign_define("diagnosticsignerror", { text = " ", texthl = "diagnosticerror", linehl = "", numhl = "" })
      vim.fn.sign_define("diagnosticsignwarn", { text = " ", texthl = "diagnosticwarn", linehl = "", numhl = "" })
      vim.fn.sign_define("diagnosticsignhint", { text = "󰌵", texthl = "diagnostichint", linehl = "", numhl = "" })
      vim.fn.sign_define("diagnosticsigninfo", { text = " ", texthl = "diagnosticinfo", linehl = "", numhl = "" })

      local slow_format_filetypes = {}

      vim.api.nvim_create_user_command("FormatDisable", function(args)
         if args.bang then
          vim.b.disable_autoformat = true
        else
          vim.g.disable_autoformat = true
        end
      end, {
        desc = "Disable autoformat-on-save",
        bang = true,
      })
      vim.api.nvim_create_user_command("FormatEnable", function()
        vim.b.disable_autoformat = false
        vim.g.disable_autoformat = false
      end, {
        desc = "Re-enable autoformat-on-save",
      })
      vim.api.nvim_create_user_command("FormatToggle", function(args)
        if args.bang then
          vim.b.disable_autoformat = not vim.b.disable_autoformat
        else
          vim.g.disable_autoformat = not vim.g.disable_autoformat
        end
      end, {
        desc = "Toggle autoformat-on-save",
        bang = true,
      })
    '';

  };
}
