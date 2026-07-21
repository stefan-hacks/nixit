" ============================================================================
" Nixit Vimrc - LazyVim-inspired Native Vim Configuration
" ============================================================================
" This .vimrc uses ONLY native Vim features - no external plugins required
" Designed for NixOS nixit dotfiles
" ============================================================================

" ============================================================================
" Essential Settings
" ============================================================================

" Use Vim settings, rather than Vi settings
set nocompatible

" Enable file type detection, plugins, and indentation
filetype plugin indent on

" Enable syntax highlighting
syntax enable

" Set encoding
set encoding=utf-8
set fileencoding=utf-8

" ============================================================================
" Leader Key (LazyVim uses Space)
" ============================================================================

let mapleader = " "
let maplocalleader = " "

" ============================================================================
" UI Configuration
" ============================================================================

" Show line numbers (relative + absolute hybrid like LazyVim)
set number
set relativenumber

" Show cursor line and column
set cursorline
" set cursorcolumn

" Color column at 80 characters (guide line)
" set colorcolumn=80

" Enable true colors if supported
if has('termguicolors')
  set termguicolors
endif

" Use a dark color scheme (native vim)
set background=dark
colorscheme default

" Show matching brackets
set showmatch
set matchtime=2

" Show partial commands in status line
set showcmd

" Always show status line
set laststatus=2

" Status line format (mimics LazyVim's statusline)
set statusline=
set statusline+=%#ModeMsg#%{(mode()=='n')?\ '\ [NORMAL]\ ':''}
set statusline+=%#ModeMsg#%{(mode()=='i')?\ '\ [INSERT]\ ':''}
set statusline+=%#ModeMsg#%{(mode()=='v')?\ '\ [VISUAL]\ ':''}
set statusline+=%#ModeMsg#%{(mode()=='V')?\ '\ [V-LINE]\ ':''}
set statusline+=%#ModeMsg#%{(mode()=='\<C-v>')?\ '\ [V-BLOCK]\ ':''}
set statusline+=%#ModeMsg#%{(mode()=='R')?\ '\ [REPLACE]\ ':''}
set statusline+=%#LineNr#
set statusline+=\ %f
set statusline+=\ %m
set statusline+=\ %r
set statusline+=%=
set statusline+=%#CursorLine#
set statusline+=\ %y
set statusline+=\ %{&fileencoding?&fileencoding:&encoding}
set statusline+=\ [%{&fileformat}]
set statusline+=%#Normal#
set statusline+=\ %l/%L:%c
set statusline+=\ %p%%

" Show line numbers in netrw
let g:netrw_bufsettings = 'noma nomod nu nobl nowrap ro'

" ============================================================================
" Tabs and Indentation
" ============================================================================

" Use spaces instead of tabs
set expandtab

" Be smart when using tabs
set smarttab

" 1 tab = 2 spaces (LazyVim default)
set shiftwidth=2
set tabstop=2
set softtabstop=2

" Auto indent and smart indent
set autoindent
set smartindent

" Copy indent from current line when starting new line
set copyindent

" ============================================================================
" Search Configuration
" ============================================================================

" Highlight search results
set hlsearch

" Show search matches as you type
set incsearch

" Make search case-insensitive by default
set ignorecase

" But case-sensitive if uppercase letters are used
set smartcase

" Clear search highlighting with Escape
nnoremap <Esc> :nohlsearch<CR>

" Search visually selected text
vnoremap // y/\V<C-R>=escape(@",'/\')<CR><CR>

" ============================================================================
" Split Windows and Navigation
" ============================================================================

" Natural split directions (LazyVim-like)
set splitbelow
set splitright

" Window navigation with Ctrl+hjkl
nnoremap <C-h> <C-w>h
nnoremap <C-j> <C-w>j
nnoremap <C-k> <C-w>k
nnoremap <C-l> <C-w>l

" Resize windows with arrows
nnoremap <C-Up>    :resize +2<CR>
nnoremap <C-Down>  :resize -2<CR>
nnoremap <C-Left>  :vertical resize -2<CR>
nnoremap <C-Right> :vertical resize +2<CR>

" Split window shortcuts
nnoremap <leader>- :split<CR>
nnoremap <leader>\| :vsplit<CR>
nnoremap <leader>q :q<CR>

" ============================================================================
" Buffer Management
" ============================================================================

" Buffer navigation
nnoremap <leader>bn :bnext<CR>
nnoremap <leader>bp :bprevious<CR>
nnoremap <leader>bd :bdelete<CR>
nnoremap <leader>bb :buffers<CR>
nnoremap <leader>1 :buffer 1<CR>
nnoremap <leader>2 :buffer 2<CR>
nnoremap <leader>3 :buffer 3<CR>
nnoremap <leader>4 :buffer 4<CR>
nnoremap <leader>5 :buffer 5<CR>
nnoremap <leader>6 :buffer 6<CR>
nnoremap <leader>7 :buffer 7<CR>
nnoremap <leader>8 :buffer 8<CR>
nnoremap <leader>9 :buffer 9<CR>

" Close buffer without closing window
nnoremap <leader>Q :bp<bar>sp<bar>bn<bar>bd<CR>

" ============================================================================
" File Explorer (Netrw - Native Vim File Tree)
" ============================================================================

" Netrw configuration (mimics nvim-tree)
let g:netrw_banner = 0           " Hide banner
let g:netrw_liststyle = 3        " Tree view
let g:netrw_browse_split = 4     " Open in previous window
let g:netrw_altv = 1             " Open splits to the right
let g:netrw_winsize = 25         " Width of explorer
let g:netrw_sort_sequence = '[\/]$,*'
let g:netrw_hide = 1             " Hide dotfiles by default
let g:netrw_list_hide = '^\..*'  " Pattern to hide dotfiles

" Toggle file explorer (like <leader>e in LazyVim)
nnoremap <leader>e :Lexplore<CR>
nnoremap <leader>E :Lexplore %:p:h<CR>

" Refresh netrw
autocmd FileType netrw nmap <buffer> r <Plug>NetrwRefresh

" ============================================================================
" File Operations
" ============================================================================

" Save file
nnoremap <leader>w :w<CR>
inoremap <C-s> <Esc>:w<CR>a
nnoremap <C-s> :w<CR>

" Save and quit
nnoremap <leader>x :x<CR>

" Quit without saving
nnoremap <leader>Q :q!<CR>

" Save all buffers
nnoremap <leader>W :wa<CR>

" ============================================================================
" Fuzzy Finding (Native Vim)
" ============================================================================

" Find files (uses find command)
nnoremap <leader>ff :find
nnoremap <leader>fF :find **/*

" Find in files (grep)
nnoremap <leader>fg :vimgrep // **/*<Left><Left><Left><Left><Left><Left>
nnoremap <leader>fG :vimgrep <C-R>=expand("<cword>")<CR> **/*<CR>

" Open quickfix list
nnoremap <leader>fq :copen<CR>
nnoremap <leader>fn :cnext<CR>
nnoremap <leader>fp :cprevious<CR>

" Search and replace (like telescope's replace)
nnoremap <leader>fr :%s///g<Left><Left><Left>
vnoremap <leader>fr "hy:%s/<C-r>h//g<Left><Left>

" ============================================================================
" Text Editing Enhancements
" ============================================================================

" Move lines up/down (like LazyVim)
nnoremap <A-j> :m .+1<CR>==
nnoremap <A-k> :m .-2<CR>==
inoremap <A-j> <Esc>:m .+1<CR>==gi
inoremap <A-k> <Esc>:m .-2<CR>==gi
vnoremap <A-j> :m '>+1<CR>gv=gv
vnoremap <A-k> :m '<-2<CR>gv=gv

" Indent/Unindent and keep selection
vnoremap < <gv
vnoremap > >gv

" Indent/Unindent with Tab in visual mode
vnoremap <Tab> >gv
vnoremap <S-Tab> <gv

" Duplicate line
nnoremap <leader>d yyp

" Delete without yanking
nnoremap <leader>D "_d
vnoremap <leader>D "_d

" Paste without overwriting register in visual
vnoremap p "_dP

" Copy to system clipboard (if compiled with +clipboard)
if has('clipboard')
  vnoremap <leader>y "+y
  nnoremap <leader>Y "+yg_
  nnoremap <leader>y "+y
  nnoremap <leader>yy "+yy
  vnoremap <leader>p "+p
  vnoremap <leader>P "+P
endif

" Select all
nnoremap <leader>a ggVG

" ============================================================================
" Code Navigation
" ============================================================================

" Go to definition (native tags support)
nnoremap gd <C-]>
nnoremap gD :tags<CR>

" Go back/forward in jump list
nnoremap <leader>o <C-o>
nnoremap <leader>i <C-i>

" Jump to matching bracket
nnoremap % %
nnoremap <leader>m %

" ============================================================================
" Folding
" ============================================================================

" Enable folding
set foldenable
set foldmethod=indent
set foldlevel=99
set foldlevelstart=99

" Toggle fold with space
nnoremap <leader>z za
nnoremap <leader>Z zA

" Fold all / Unfold all
nnoremap <leader>zc zM
nnoremap <leader>zo zR

" ============================================================================
" Terminal Integration
" ============================================================================

if has('terminal')
  " Open terminal in split
"  nnoremap <leader>t :term<CR>
"  nnoremap <leader>T :vsplit term://bash<CR>

  " Exit terminal mode with Esc
  tnoremap <Esc> <C-\><C-n>
  tnoremap <C-h> <C-\><C-n><C-w>h
  tnoremap <C-j> <C-\><C-n><C-w>j
  tnoremap <C-k> <C-\><C-n><C-w>k
  tnoremap <C-l> <C-\><C-n><C-w>l
endif

" ============================================================================
" Completion and Auto-commands
" ============================================================================

" Enable wildmenu for command-line completion
set wildmenu
set wildmode=longest:full,full

" Ignore certain files in wildmenu
set wildignore+=*.pyc,*.o,*.obj,*.class,*.jar,*.gif,*.png,*.jpg,*.jpeg
set wildignore+=*/.git/*,*/node_modules/*,*/__pycache__/*

" Omnifunc completion
set omnifunc=syntaxcomplete#Complete

" Complete options
set completeopt=menu,menuone,noselect

" Auto-complete with Tab
inoremap <expr> <Tab>   pumvisible() ? "\<C-n>" : "\<Tab>"
inoremap <expr> <S-Tab> pumvisible() ? "\<C-p>" : "\<S-Tab>"
inoremap <expr> <CR>    pumvisible() ? "\<C-y>" : "\<CR>"

" ============================================================================
" Session Management (Native :mksession)
" ============================================================================

" Save session
nnoremap <leader>Ss :mksession! ~/.vim/session.vim<CR>

" Load session
nnoremap <leader>Sl :source ~/.vim/session.vim<CR>

" Auto-create session directory
silent! !mkdir -p ~/.vim

" ============================================================================
" Spell Check
" ============================================================================

" Toggle spell check
nnoremap <leader>us :set spell!<CR>

" Spell check settings
set spelllang=en_us

" Add spell check for certain filetypes
autocmd FileType markdown,txt,text setlocal spell

" ============================================================================
" Git Integration (Native)
" ============================================================================

" Git blame for current line
nnoremap <leader>gb :.!git blame %<CR>

" Show git log for file
nnoremap <leader>gl :!git log --oneline -20 %<CR>

" Show git diff
nnoremap <leader>gd :!git diff %<CR>

" Show git status
nnoremap <leader>gs :!git status<CR>

" ============================================================================
" Quick Edit Config
" ============================================================================

" Edit vimrc
nnoremap <leader>ev :e ~/.vimrc<CR>

" Source vimrc
nnoremap <leader>sv :source ~/.vimrc<CR>

" ============================================================================
" Miscellaneous Useful Shortcuts
" ============================================================================

" Toggle line numbers
nnoremap <leader>tn :set number!<CR>

" Toggle relative line numbers
nnoremap <leader>tr :set relativenumber!<CR>

" Toggle wrap
nnoremap <leader>tw :set wrap!<CR>

" Toggle paste mode
nnoremap <leader>tp :set paste!<CR>

" Show current file path
nnoremap <leader>fp :echo expand('%:p')<CR>

" Change to directory of current file
nnoremap <leader>cd :cd %:p:h<CR>:pwd<CR>

" ============================================================================
" Performance and Backup Settings
" ============================================================================

" Disable backup files (NixOS handles this)
set nobackup
set nowritebackup
set noswapfile

" Keep undo history
if has('persistent_undo')
  set undofile
  set undodir=~/.vim/undo
  silent! !mkdir -p ~/.vim/undo
endif

" Faster timeout for key sequences
set timeoutlen=300
set ttimeoutlen=0

" Update time for CursorHold events
set updatetime=300

" ============================================================================
" Scrolling and Viewport
" ============================================================================

" Keep cursor centered when scrolling
set scrolloff=8
set sidescrolloff=8

" Smooth scrolling feel
set ttyfast
set lazyredraw

" Show as much as possible of last line
set display+=lastline

" ============================================================================
" Mouse Support
" ============================================================================

" Enable mouse in all modes
if has('mouse')
  set mouse=a
endif

" ============================================================================
" Language-Specific Settings
" ============================================================================

" Python
autocmd FileType python setlocal expandtab shiftwidth=4 tabstop=4 softtabstop=4

" JavaScript/TypeScript
autocmd FileType javascript,typescript setlocal expandtab shiftwidth=2 tabstop=2

" HTML/XML
autocmd FileType html,xhtml,xml setlocal expandtab shiftwidth=2 tabstop=2

" CSS/SCSS
autocmd FileType css,scss,sass setlocal expandtab shiftwidth=2 tabstop=2

" JSON
autocmd FileType json setlocal expandtab shiftwidth=2 tabstop=2

" YAML
autocmd FileType yaml setlocal expandtab shiftwidth=2 tabstop=2

" Markdown
autocmd FileType markdown setlocal wrap linebreak textwidth=80

" ============================================================================
" Help Shortcuts
" ============================================================================

" Open help in vertical split
nnoremap <leader>h :vert help

" Show key mappings
nnoremap <leader>mk :map<CR>
nnoremap <leader>mK :map!<CR>

" ============================================================================
" Auto-commands
" ============================================================================

" Return to last edit position when opening files
autocmd BufReadPost * if line("'\"") > 1 && line("'\"") <= line("$") | exe "normal! g'\"" | endif

" Strip trailing whitespace on save
autocmd BufWritePre * %s/\s\+$//e

" Remember folds
autocmd BufWinLeave *.* mkview
autocmd BufWinEnter *.* silent loadview

" Auto-reload vimrc when changed
autocmd BufWritePost ~/.vimrc source ~/.vimrc

" ============================================================================
" Visual Mode Enhancements
" ============================================================================

" Stay in visual mode when shifting
vnoremap < <gv
vnoremap > >gv

" Search for selection with *
vnoremap * y/<C-R>"<CR>
vnoremap # y?<C-R>"<CR>

" Replace selection
vnoremap <C-r> "hy:%s/<C-r>h//gc<left><left><left>

" ============================================================================
" Command Mode Enhancements
" ============================================================================

" Better command-line completion
set wildmenu
set wildmode=list:longest,full

" Emacs-style command line editing
cnoremap <C-a> <Home>
cnoremap <C-e> <End>
cnoremap <C-b> <Left>
cnoremap <C-f> <Right>
cnoremap <C-d> <Delete>
cnoremap <C-k> <C-\>estrpart(getcmdline(),0,getcmdpos()-1)<CR>

" ============================================================================
" Quickfix and Location List
" ============================================================================

" Toggle quickfix
nnoremap <leader>c :cwindow<CR>
nnoremap <leader>l :lwindow<CR>

" Navigate quickfix
nnoremap ]q :cnext<CR>
nnoremap [q :cprevious<CR>
nnoremap ]Q :clast<CR>
nnoremap [Q :cfirst<CR>

" Navigate location list
nnoremap ]l :lnext<CR>
nnoremap [l :lprevious<CR>

" ============================================================================
" Marks and Registers
" ============================================================================

" List all marks
nnoremap <leader>ma :marks<CR>

" List all registers
nnoremap <leader>reg :registers<CR>

" ============================================================================
" Initialization Message
" ============================================================================

autocmd VimEnter * echo "Welcome to Nixit Vim! Leader key: <Space>"

" ============================================================================
" End of Configuration
" ============================================================================
