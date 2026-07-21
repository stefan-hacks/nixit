" ============================================================================
" Nixit Vimrc - LazyVim-inspired Native Vim Configuration
" ============================================================================
" This .vimrc uses ONLY native Vim features - no external plugins required
" Designed for NixOS nixit dotfiles
" Catppuccin Mocha Theme
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
" Catppuccin Mocha Color Scheme (Manual Definition)
" ============================================================================

" Enable true colors
if has('termguicolors')
  set termguicolors
endif
set background=dark

" Define Catppuccin Mocha colors
" Base: #1e1e2e (crust/base)
" Surface: #313244
" Overlay: #6c7086
" Muted: #a6adc8
" Text: #cdd6f4
" Lavender: #b4befe
" Blue: #89b4fa
" Sapphire: #74c7ec
" Sky: #89dceb
" Teal: #94e2d5
" Green: #a6e3a1
" Yellow: #f9e2af
" Peach: #fab387
" Maroon: #eba0ac
" Red: #f38ba8
" Mauve: #cba6f7
" Pink: #f5c2e7
" Flamingo: #f2cdcd
" Rosewater: #f5e0dc

" Define highlight groups
highlight Normal guifg=#cdd6f4 guibg=#1e1e2e
highlight Comment guifg=#6c7086 gui=italic
highlight Constant guifg=#fab387
highlight String guifg=#a6e3a1
highlight Character guifg=#a6e3a1
highlight Number guifg=#fab387
highlight Boolean guifg=#fab387
highlight Float guifg=#fab387
highlight Identifier guifg=#f2cdcd
highlight Function guifg=#89b4fa
highlight Statement guifg=#cba6f7 gui=bold
highlight Conditional guifg=#cba6f7
highlight Repeat guifg=#cba6f7
highlight Label guifg=#cba6f7
highlight Operator guifg=#89dceb
highlight Keyword guifg=#cba6f7 gui=bold
highlight Exception guifg=#cba6f7
highlight PreProc guifg=#f5c2e7
highlight Include guifg=#cba6f7
highlight Define guifg=#f5c2e7
highlight Macro guifg=#f5c2e7
highlight PreCondit guifg=#f5c2e7
highlight Type guifg=#f9e2af
highlight StorageClass guifg=#f9e2af
highlight Structure guifg=#f9e2af
highlight Typedef guifg=#f9e2af
highlight Special guifg=#89dceb
highlight SpecialChar guifg=#89dceb
highlight Tag guifg=#89dceb
highlight Delimiter guifg=#9399b2
highlight SpecialComment guifg=#6c7086 gui=bold
highlight Debug guifg=#f38ba8

" UI Elements
highlight LineNr guifg=#6c7086 guibg=#1e1e2e
highlight CursorLineNr guifg=#f9e2af guibg=#313244 gui=bold
highlight SignColumn guibg=#1e1e2e
highlight FoldColumn guifg=#6c7086 guibg=#1e1e2e
highlight Folded guifg=#6c7086 guibg=#313244

" DISABLED: cursorline and cursorcolumn
" highlight CursorLine guibg=#313244
" highlight CursorColumn guibg=#313244

" Status Line Colors
highlight StatusLine guifg=#cdd6f4 guibg=#313244 gui=bold
highlight StatusLineNC guifg=#6c7086 guibg=#1e1e2e
highlight StatusLineMode guifg=#1e1e2e guibg=#cba6f7 gui=bold
highlight StatusLineModeInsert guifg=#1e1e2e guibg=#89dceb gui=bold
highlight StatusLineModeVisual guifg=#1e1e2e guibg=#a6e3a1 gui=bold
highlight StatusLineModeReplace guifg=#1e1e2e guibg=#f38ba8 gui=bold
highlight StatusLineFile guifg=#cdd6f4 guibg=#313244
highlight StatusLineInfo guifg=#89b4fa guibg=#313244
highlight StatusLinePercent guifg=#cba6f7 guibg=#313244 gui=bold
highlight StatusLinePos guifg=#1e1e2e guibg=#89b4fa gui=bold

" Search
highlight Search guifg=#1e1e2e guibg=#f9e2af gui=bold
highlight IncSearch guifg=#1e1e2e guibg=#f38ba8 gui=bold
highlight MatchParen guifg=#f9e2af guibg=#6c7086 gui=bold

" Visual Selection
highlight Visual guifg=#cdd6f4 guibg=#45475a
highlight VisualNOS guifg=#cdd6f4 guibg=#45475a

" Popup Menu
highlight Pmenu guifg=#cdd6f4 guibg=#313244
highlight PmenuSel guifg=#1e1e2e guibg=#cba6f7 gui=bold
highlight PmenuSbar guibg=#1e1e2e
highlight PmenuThumb guibg=#6c7086

" Split separators - subtle
highlight VertSplit guifg=#313244 guibg=#1e1e2e
highlight StatusLineTerm guifg=#cdd6f4 guibg=#313244
highlight StatusLineTermNC guifg=#6c7086 guibg=#1e1e2e

" Tab Line
highlight TabLine guifg=#6c7086 guibg=#1e1e2e
highlight TabLineFill guifg=#1e1e2e guibg=#1e1e2e
highlight TabLineSel guifg=#cdd6f4 guibg=#313244 gui=bold

" Cursor
highlight Cursor guifg=#1e1e2e guibg=#f5e0dc
highlight iCursor guifg=#1e1e2e guibg=#f5e0dc
highlight vCursor guifg=#1e1e2e guibg=#cba6f7

" Wild Menu
highlight WildMenu guifg=#1e1e2e guibg=#cba6f7 gui=bold

" Error and Warning
highlight ErrorMsg guifg=#f38ba8 guibg=#1e1e2e gui=bold
highlight WarningMsg guifg=#fab387 guibg=#1e1e2e gui=bold
highlight MoreMsg guifg=#89b4fa guibg=#1e1e2e
highlight Question guifg=#89dceb guibg=#1e1e2e

" Non-Text and Special
highlight NonText guifg=#45475a
highlight SpecialKey guifg=#45475a
highlight Whitespace guifg=#313244

" Title
highlight Title guifg=#cba6f7 gui=bold

" ============================================================================
" UI Configuration
" ============================================================================

" Show line numbers (relative + absolute hybrid like LazyVim)
set number
set relativenumber

" DISABLED: cursor line and column highlight
" set cursorline
" set cursorcolumn

" DISABLED: Color column at 80 characters
" set colorcolumn=80

" Show matching brackets
set showmatch
set matchtime=2

" Show partial commands in status line
set showcmd

" Always show status line
set laststatus=2

" ============================================================================
" Beautiful Status Line (Catppuccin Mocha)
" ============================================================================

" Function to get current mode with nice name
function! GetMode()
  let l:mode = mode()
  if l:mode == 'n'
    return 'NORMAL'
  elseif l:mode == 'i'
    return 'INSERT'
  elseif l:mode == 'v'
    return 'VISUAL'
  elseif l:mode == 'V'
    return 'V-LINE'
  elseif l:mode == "\<C-v>"
    return 'V-BLOCK'
  elseif l:mode == 'R'
    return 'REPLACE'
  elseif l:mode == 'c'
    return 'COMMAND'
  elseif l:mode == 't'
    return 'TERMINAL'
  else
    return toupper(l:mode)
  endif
endfunction

" Function to get git branch
function! GitBranch()
  return system("git rev-parse --abbrev-ref HEAD 2>/dev/null | tr -d '\n'")
endfunction

" Function to get file size
function! FileSize()
  let l:bytes = getfsize(expand('%:p'))
  if l:bytes <= 0
    return ''
  endif
  if l:bytes < 1024
    return l:bytes . 'B'
  elseif l:bytes < 1024*1024
    return printf('%.1fK', l:bytes / 1024.0)
  else
    return printf('%.1fM', l:bytes / (1024.0*1024.0))
  endif
endfunction

" Main status line function
function! BuildStatusLine()
  let l:mode = GetMode()
  let l:mode_group = '%#StatusLineMode#'
  let l:reset = '%*'
  
  if l:mode == 'INSERT'
    let l:mode_group = '%#StatusLineModeInsert#'
  elseif l:mode == 'VISUAL' || l:mode == 'V-LINE' || l:mode == 'V-BLOCK'
    let l:mode_group = '%#StatusLineModeVisual#'
  elseif l:mode == 'REPLACE'
    let l:mode_group = '%#StatusLineModeReplace#'
  endif
  
  " Build status line components
  let l:sl = ''
  
  " Left side: Mode
  let l:sl .= l:mode_group . '  ' . l:mode . '  ' . l:reset
  
  " File info with icon
  let l:sl .= '%#StatusLineFile#  '
  let l:sl .= '%{&mod ? "● " : &readonly ? "🔒 " : "📄 "}'
  let l:sl .= '%t'
  let l:sl .= '%m%r'
  let l:sl .= '  ' . l:reset
  
  " File type and size
  let l:sl .= '%#StatusLineInfo#  '
  if strlen(&filetype) > 0
    let l:sl .= '⬦ ' . toupper(&filetype) . '  '
  endif
  let l:size = FileSize()
  if strlen(l:size) > 0
    let l:sl .= '⬓ ' . l:size . '  '
  endif
  let l:sl .= l:reset
  
  " Right side
  let l:sl .= '%='
  
  " Git branch
  let l:branch = GitBranch()
  if strlen(l:branch) > 0 && l:branch != 'HEAD'
    let l:sl .= '%#StatusLineInfo#  ⎇ ' . l:branch . '  %*'
  endif
  
  " Encoding and format
  let l:sl .= '%#StatusLineFile#  '
  let l:sl .= &fileencoding ? &fileencoding : &encoding
  let l:sl .= '  [' . &fileformat . ']  '
  let l:sl .= '%*'
  
  " Position indicator
  let l:sl .= '%#StatusLinePos#  %l:%c  %p%%  %*'
  
  return l:sl
endfunction

" Set status line
set statusline=%!BuildStatusLine()

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

" DISABLED: Natural split directions
" set splitbelow
" set splitright

" DISABLED: Window navigation shortcuts (keep native)
" nnoremap <C-h> <C-w>h
" nnoremap <C-j> <C-w>j
" nnoremap <C-k> <C-w>k
" nnoremap <C-l> <C-w>l

" DISABLED: Split window shortcuts
" nnoremap <leader>- :split<CR>
" nnoremap <leader>\| :vsplit<CR>
" nnoremap <leader>q :q<CR>

" Keep only these window commands
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
nnoremap <leader>! :q!<CR>

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
  " Open terminal
  nnoremap <leader>t :term<CR>
  
  " Exit terminal mode with Esc
  tnoremap <Esc> <C-\><C-n>
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

" Update status line on mode change
autocmd ModeChanged * redrawstatus

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

autocmd VimEnter * echo "Nixit Vim • Catppuccin Mocha • Leader: <Space>"

" ============================================================================
" End of Configuration
" ============================================================================