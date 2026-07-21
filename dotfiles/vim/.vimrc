" ============================================================================
" Nixit Vimrc - LazyVim-inspired Native Vim Configuration
" ============================================================================
" This .vimrc uses ONLY native Vim features - no external plugins required
" Designed for NixOS nixit dotfiles
" Catppuccin Mocha Theme with Mode-Aware Cursor
" ============================================================================

" ============================================================================
" Essential Settings
" ============================================================================

set nocompatible
filetype plugin indent on
syntax enable
set encoding=utf-8
set fileencoding=utf-8

" ============================================================================
" Leader Key
" ============================================================================

let mapleader = " "
let maplocalleader = " "

" ============================================================================
" Catppuccin Mocha Color Scheme
" ============================================================================

if has('termguicolors')
  set termguicolors
endif
set background=dark

" Catppuccin Mocha Palette
let g:ctp_base = '#1e1e2e'
let g:ctp_surface = '#313244'
let g:ctp_overlay = '#45475a'
let g:ctp_muted = '#6c7086'
let g:ctp_subtext = '#a6adc8'
let g:ctp_text = '#cdd6f4'
let g:ctp_lavender = '#b4befe'
let g:ctp_blue = '#89b4fa'
let g:ctp_sapphire = '#74c7ec'
let g:ctp_sky = '#89dceb'
let g:ctp_teal = '#94e2d5'
let g:ctp_green = '#a6e3a1'
let g:ctp_yellow = '#f9e2af'
let g:ctp_peach = '#fab387'
let g:ctp_maroon = '#eba0ac'
let g:ctp_red = '#f38ba8'
let g:ctp_mauve = '#cba6f7'
let g:ctp_pink = '#f5c2e7'
let g:ctp_flamingo = '#f2cdcd'
let g:ctp_rosewater = '#f5e0dc'

" Base highlights
execute 'highlight Normal guifg=' . g:ctp_text . ' guibg=' . g:ctp_base
execute 'highlight Comment guifg=' . g:ctp_muted . ' gui=italic'
execute 'highlight Constant guifg=' . g:ctp_peach
execute 'highlight String guifg=' . g:ctp_green
execute 'highlight Character guifg=' . g:ctp_green
execute 'highlight Number guifg=' . g:ctp_peach
execute 'highlight Boolean guifg=' . g:ctp_peach
execute 'highlight Float guifg=' . g:ctp_peach
execute 'highlight Identifier guifg=' . g:ctp_flamingo
execute 'highlight Function guifg=' . g:ctp_blue
execute 'highlight Statement guifg=' . g:ctp_mauve . ' gui=bold'
execute 'highlight Conditional guifg=' . g:ctp_mauve
execute 'highlight Repeat guifg=' . g:ctp_mauve
execute 'highlight Label guifg=' . g:ctp_mauve
execute 'highlight Operator guifg=' . g:ctp_sky
execute 'highlight Keyword guifg=' . g:ctp_mauve . ' gui=bold'
execute 'highlight Exception guifg=' . g:ctp_mauve
execute 'highlight PreProc guifg=' . g:ctp_pink
execute 'highlight Include guifg=' . g:ctp_mauve
execute 'highlight Define guifg=' . g:ctp_pink
execute 'highlight Macro guifg=' . g:ctp_pink
execute 'highlight PreCondit guifg=' . g:ctp_pink
execute 'highlight Type guifg=' . g:ctp_yellow
execute 'highlight StorageClass guifg=' . g:ctp_yellow
execute 'highlight Structure guifg=' . g:ctp_yellow
execute 'highlight Typedef guifg=' . g:ctp_yellow
execute 'highlight Special guifg=' . g:ctp_sky
execute 'highlight SpecialChar guifg=' . g:ctp_sky
execute 'highlight Tag guifg=' . g:ctp_sky
execute 'highlight Delimiter guifg=' . g:ctp_subtext
execute 'highlight SpecialComment guifg=' . g:ctp_muted . ' gui=bold'
execute 'highlight Debug guifg=' . g:ctp_red
execute 'highlight Error guifg=' . g:ctp_base . ' guibg=' . g:ctp_red . ' gui=bold'
execute 'highlight Todo guifg=' . g:ctp_base . ' guibg=' . g:ctp_yellow . ' gui=bold'
execute 'highlight Underlined guifg=' . g:ctp_blue . ' gui=underline'

" UI Elements
execute 'highlight LineNr guifg=' . g:ctp_muted . ' guibg=' . g:ctp_base
execute 'highlight CursorLineNr guifg=' . g:ctp_text . ' guibg=' . g:ctp_surface . ' gui=bold'
execute 'highlight SignColumn guibg=' . g:ctp_base
execute 'highlight FoldColumn guifg=' . g:ctp_muted . ' guibg=' . g:ctp_base
execute 'highlight Folded guifg=' . g:ctp_muted . ' guibg=' . g:ctp_surface
execute 'highlight ColorColumn guibg=' . g:ctp_surface
execute 'highlight NonText guifg=' . g:ctp_overlay
execute 'highlight SpecialKey guifg=' . g:ctp_overlay

" Search and Match
execute 'highlight Search guifg=' . g:ctp_base . ' guibg=' . g:ctp_yellow . ' gui=bold'
execute 'highlight IncSearch guifg=' . g:ctp_base . ' guibg=' . g:ctp_peach . ' gui=bold'
execute 'highlight MatchParen guifg=' . g:ctp_base . ' guibg=' . g:ctp_peach . ' gui=bold'

" Visual Selection
execute 'highlight Visual guifg=' . g:ctp_text . ' guibg=' . g:ctp_surface
execute 'highlight VisualNOS guifg=' . g:ctp_text . ' guibg=' . g:ctp_surface

" Popup Menu
execute 'highlight Pmenu guifg=' . g:ctp_text . ' guibg=' . g:ctp_surface
execute 'highlight PmenuSel guifg=' . g:ctp_base . ' guibg=' . g:ctp_mauve . ' gui=bold'
execute 'highlight PmenuSbar guibg=' . g:ctp_base
execute 'highlight PmenuThumb guibg=' . g:ctp_muted

" Wild Menu
execute 'highlight WildMenu guifg=' . g:ctp_base . ' guibg=' . g:ctp_mauve . ' gui=bold'

" Status Line Base
execute 'highlight StatusLine guifg=' . g:ctp_text . ' guibg=' . g:ctp_surface . ' gui=bold'
execute 'highlight StatusLineNC guifg=' . g:ctp_muted . ' guibg=' . g:ctp_base
execute 'highlight StatusLineTerm guifg=' . g:ctp_text . ' guibg=' . g:ctp_surface
execute 'highlight StatusLineTermNC guifg=' . g:ctp_muted . ' guibg=' . g:ctp_base

" Tab Line
execute 'highlight TabLine guifg=' . g:ctp_muted . ' guibg=' . g:ctp_base
execute 'highlight TabLineFill guifg=' . g:ctp_base . ' guibg=' . g:ctp_base
execute 'highlight TabLineSel guifg=' . g:ctp_text . ' guibg=' . g:ctp_surface . ' gui=bold'

" Split Separators - INVISIBLE (no red line!)
execute 'highlight VertSplit guifg=' . g:ctp_base . ' guibg=' . g:ctp_base
execute 'highlight WinSeparator guifg=' . g:ctp_base . ' guibg=' . g:ctp_base

" Messages
execute 'highlight ErrorMsg guifg=' . g:ctp_red . ' guibg=' . g:ctp_base . ' gui=bold'
execute 'highlight WarningMsg guifg=' . g:ctp_peach . ' guibg=' . g:ctp_base . ' gui=bold'
execute 'highlight MoreMsg guifg=' . g:ctp_blue . ' guibg=' . g:ctp_base
execute 'highlight Question guifg=' . g:ctp_sky . ' guibg=' . g:ctp_base

" ============================================================================
" Mode-Aware Cursor Colors
" ============================================================================

" NORMAL mode cursor - Mauve (Purple)
execute 'highlight NormalCursor guifg=' . g:ctp_base . ' guibg=' . g:ctp_mauve

" INSERT mode cursor - Sky/Cyan
execute 'highlight InsertCursor guifg=' . g:ctp_base . ' guibg=' . g:ctp_sky

" VISUAL mode cursor - Green
execute 'highlight VisualCursor guifg=' . g:ctp_base . ' guibg=' . g:ctp_green

" REPLACE mode cursor - Red
execute 'highlight ReplaceCursor guifg=' . g:ctp_base . ' guibg=' . g:ctp_red

" COMMAND mode cursor - Peach
execute 'highlight CommandCursor guifg=' . g:ctp_base . ' guibg=' . g:ctp_peach

" ============================================================================
" Mode-Aware Status Line Colors
" ============================================================================

" NORMAL
execute 'highlight SLNormal guifg=' . g:ctp_base . ' guibg=' . g:ctp_mauve . ' gui=bold'
execute 'highlight SLNormalSep guifg=' . g:ctp_mauve . ' guibg=' . g:ctp_surface

" INSERT
execute 'highlight SLInsert guifg=' . g:ctp_base . ' guibg=' . g:ctp_sky . ' gui=bold'
execute 'highlight SLInsertSep guifg=' . g:ctp_sky . ' guibg=' . g:ctp_surface

" VISUAL
execute 'highlight SLVisual guifg=' . g:ctp_base . ' guibg=' . g:ctp_green . ' gui=bold'
execute 'highlight SLVisualSep guifg=' . g:ctp_green . ' guibg=' . g:ctp_surface

" REPLACE
execute 'highlight SLReplace guifg=' . g:ctp_base . ' guibg=' . g:ctp_red . ' gui=bold'
execute 'highlight SLReplaceSep guifg=' . g:ctp_red . ' guibg=' . g:ctp_surface

" COMMAND
execute 'highlight SLCommand guifg=' . g:ctp_base . ' guibg=' . g:ctp_peach . ' gui=bold'
execute 'highlight SLCommandSep guifg=' . g:ctp_peach . ' guibg=' . g:ctp_surface

" Other statusline elements
execute 'highlight SLFile guifg=' . g:ctp_text . ' guibg=' . g:ctp_surface
execute 'highlight SLInfo guifg=' . g:ctp_blue . ' guibg=' . g:ctp_surface
execute 'highlight SLPos guifg=' . g:ctp_base . ' guibg=' . g:ctp_blue . ' gui=bold'
execute 'highlight SLGit guifg=' . g:ctp_green . ' guibg=' . g:ctp_surface
execute 'highlight SLEncoding guifg=' . g:ctp_subtext . ' guibg=' . g:ctp_surface

" ============================================================================
" Cursor Configuration (No Line/Column Highlight)
" ============================================================================

" DISABLED: No cursor line or column highlighting
set nocursorline
set nocursorcolumn
set colorcolumn=

" Cursor shape and color - mode aware
" Use guicursor to change cursor color by mode
if has('guicolors')
  set guicursor=n:block-Cursor/lCursor
  set guicursor=i:ver25-iCursor
  set guicursor=v:block-vCursor
  set guicursor=r:block-rCursor
  set guicursor=c:block-cCursor
endif

" ============================================================================
" UI Configuration
" ============================================================================

set number
set relativenumber
set showmatch
set matchtime=2
set showcmd
set laststatus=2

" ============================================================================
" Mode Detection and Status Line
" ============================================================================

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
  elseif l:mode == 'R' || l:mode == 'Rv'
    return 'REPLACE'
  elseif l:mode == 'c'
    return 'COMMAND'
  elseif l:mode == 't'
    return 'TERMINAL'
  else
    return toupper(l:mode)
  endif
endfunction

function! GetModeColor()
  let l:mode = mode()
  if l:mode == 'i'
    return 'SLInsert'
  elseif l:mode == 'v' || l:mode == 'V' || l:mode == "\<C-v>"
    return 'SLVisual'
  elseif l:mode == 'R' || l:mode == 'Rv'
    return 'SLReplace'
  elseif l:mode == 'c'
    return 'SLCommand'
  else
    return 'SLNormal'
  endif
endfunction

function! GetModeSep()
  let l:mode = mode()
  if l:mode == 'i'
    return 'SLInsertSep'
  elseif l:mode == 'v' || l:mode == 'V' || l:mode == "\<C-v>"
    return 'SLVisualSep'
  elseif l:mode == 'R' || l:mode == 'Rv'
    return 'SLReplaceSep'
  elseif l:mode == 'c'
    return 'SLCommandSep'
  else
    return 'SLNormalSep'
  endif
endfunction

function! GitBranch()
  return system("git rev-parse --abbrev-ref HEAD 2>/dev/null | tr -d '\n'")
endfunction

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

function! BuildStatusLine()
  let l:mode = GetMode()
  let l:mode_color = GetModeColor()
  let l:mode_sep = GetModeSep()
  
  let l:sl = ''
  
  " Left: Mode indicator with color
  let l:sl .= '%#' . l:mode_color . '#  ' . l:mode . '  %*'
  let l:sl .= '%#' . l:mode_sep . '#%*'
  
  " File icon and name
  let l:sl .= '%#SLFile# '
  let l:sl .= '%{&mod ? "● " : &readonly ? "󰌾 " : "󰈤 "}'
  let l:sl .= '%t %m%r %*'
  
  " File info
  let l:sl .= '%#SLInfo# '
  if strlen(&filetype) > 0
    let l:sl .= toupper(&filetype) . '  '
  endif
  let l:size = FileSize()
  if strlen(l:size) > 0
    let l:sl .= l:size . '  '
  endif
  let l:sl .= '%*'
  
  " Right side
  let l:sl .= '%='
  
  " Git branch
  let l:branch = GitBranch()
  if strlen(l:branch) > 0 && l:branch != 'HEAD'
    let l:sl .= '%#SLGit# 󰘬 ' . l:branch . ' %*'
  endif
  
  " Encoding
  let l:sl .= '%#SLEncoding# '
  let l:sl .= &fileencoding ? &fileencoding : &encoding
  let l:sl .= ' [%{&fileformat}] %*'
  
  " Position with mode color
  let l:sl .= '%#SLPos# %l:%c %*'
  let l:sl .= '%#' . l:mode_color . '# %p%% %*'
  
  return l:sl
endfunction

set statusline=%!BuildStatusLine()

" ============================================================================
" Mode-Change Auto-Commands (Update Cursor and Status Line)
" ============================================================================

" Update cursor color based on mode
function! UpdateCursorColor()
  let l:mode = mode()
  if l:mode == 'i'
    execute 'highlight Cursor guifg=' . g:ctp_base . ' guibg=' . g:ctp_sky
  elseif l:mode == 'v' || l:mode == 'V' || l:mode == "\<C-v>"
    execute 'highlight Cursor guifg=' . g:ctp_base . ' guibg=' . g:ctp_green
  elseif l:mode == 'R' || l:mode == 'Rv'
    execute 'highlight Cursor guifg=' . g:ctp_base . ' guibg=' . g:ctp_red
  elseif l:mode == 'c'
    execute 'highlight Cursor guifg=' . g:ctp_base . ' guibg=' . g:ctp_peach
  else
    execute 'highlight Cursor guifg=' . g:ctp_base . ' guibg=' . g:ctp_mauve
  endif
  redrawstatus
endfunction

" Trigger cursor color update on mode change
augroup ModeCursor
  autocmd!
  autocmd ModeChanged * call UpdateCursorColor()
  autocmd InsertEnter * call UpdateCursorColor()
  autocmd InsertLeave * call UpdateCursorColor()
  autocmd CmdlineEnter * call UpdateCursorColor()
  autocmd CmdlineLeave * call UpdateCursorColor()
augroup END

" Initialize cursor color
execute 'highlight Cursor guifg=' . g:ctp_base . ' guibg=' . g:ctp_mauve

" ============================================================================
" Tabs and Indentation
" ============================================================================

set expandtab
set smarttab
set shiftwidth=2
set tabstop=2
set softtabstop=2
set autoindent
set smartindent
set copyindent

" ============================================================================
" Search Configuration
" ============================================================================

set hlsearch
set incsearch
set ignorecase
set smartcase
nnoremap <Esc> :nohlsearch<CR>
vnoremap // y/\V<C-R>=escape(@",'/\')<CR><CR>

" ============================================================================
" Window Management (Minimal)
" ============================================================================

set nosplitbelow
set nosplitright
nnoremap <leader>q :q<CR>

" ============================================================================
" Buffer Management
" ============================================================================

nnoremap <leader>bn :bnext<CR>
nnoremap <leader>bp :bprevious<CR>
nnoremap <leader>bd :bdelete<CR>
nnoremap <leader>bb :buffers<CR>
for i in range(1, 9)
  execute 'nnoremap <leader>' . i . ' :buffer ' . i . '<CR>'
endfor
nnoremap <leader>Q :bp<bar>sp<bar>bn<bar>bd<CR>

" ============================================================================
" File Explorer (Netrw)
" ============================================================================

let g:netrw_banner = 0
let g:netrw_liststyle = 3
let g:netrw_browse_split = 4
let g:netrw_altv = 1
let g:netrw_winsize = 25
let g:netrw_hide = 1
let g:netrw_list_hide = '^\..*'
let g:netrw_bufsettings = 'noma nomod nu nobl nowrap ro'

nnoremap <leader>e :Lexplore<CR>
nnoremap <leader>E :Lexplore %:p:h<CR>
autocmd FileType netrw nmap <buffer> r <Plug>NetrwRefresh

" ============================================================================
" File Operations
" ============================================================================

nnoremap <leader>w :w<CR>
inoremap <C-s> <Esc>:w<CR>a
nnoremap <C-s> :w<CR>
nnoremap <leader>x :x<CR>
nnoremap <leader>! :q!<CR>
nnoremap <leader>W :wa<CR>

" ============================================================================
" Fuzzy Finding
" ============================================================================

nnoremap <leader>ff :find 
nnoremap <leader>fF :find **/*
nnoremap <leader>fg :vimgrep // **/*<Left><Left><Left><Left><Left><Left>
nnoremap <leader>fG :vimgrep <C-R>=expand("<cword>")<CR> **/*<CR>
nnoremap <leader>fq :copen<CR>
nnoremap <leader>fn :cnext<CR>
nnoremap <leader>fp :cprevious<CR>
nnoremap <leader>fr :%s///g<Left><Left><Left>
vnoremap <leader>fr "hy:%s/<C-r>h//g<Left><Left>

" ============================================================================
" Text Editing
" ============================================================================

nnoremap <A-j> :m .+1<CR>==
nnoremap <A-k> :m .-2<CR>==
inoremap <A-j> <Esc>:m .+1<CR>==gi
inoremap <A-k> <Esc>:m .-2<CR>==gi
vnoremap <A-j> :m '>+1<CR>gv=gv
vnoremap <A-k> :m '<-2<CR>gv=gv
vnoremap < <gv
vnoremap > >gv
vnoremap <Tab> >gv
vnoremap <S-Tab> <gv
nnoremap <leader>d yyp
nnoremap <leader>D "_d
vnoremap <leader>D "_d
vnoremap p "_dP

if has('clipboard')
  vnoremap <leader>y "+y
  nnoremap <leader>Y "+yg_
  nnoremap <leader>y "+y
  nnoremap <leader>yy "+yy
  vnoremap <leader>p "+p
  vnoremap <leader>P "+P
endif

nnoremap <leader>a ggVG

" ============================================================================
" Navigation
" ============================================================================

nnoremap gd <C-]>
nnoremap gD :tags<CR>
nnoremap <leader>o <C-o>
nnoremap <leader>i <C-i>
nnoremap <leader>m %

" ============================================================================
" Folding
" ============================================================================

set foldenable
set foldmethod=indent
set foldlevel=99
set foldlevelstart=99
nnoremap <leader>z za
nnoremap <leader>Z zA
nnoremap <leader>zc zM
nnoremap <leader>zo zR

" ============================================================================
" Terminal
" ============================================================================

if has('terminal')
  nnoremap <leader>t :term<CR>
  tnoremap <Esc> <C-\><C-n>
endif

" ============================================================================
" Completion
" ============================================================================

set wildmenu
set wildmode=longest:full,full
set wildignore+=*.pyc,*.o,*.obj,*.class,*.jar,*.gif,*.png,*.jpg,*.jpeg
set wildignore+=*/.git/*,*/node_modules/*,*/__pycache__/*
set omnifunc=syntaxcomplete#Complete
set completeopt=menu,menuone,noselect
inoremap <expr> <Tab>   pumvisible() ? "\<C-n>" : "\<Tab>"
inoremap <expr> <S-Tab> pumvisible() ? "\<C-p>" : "\<S-Tab>"
inoremap <expr> <CR>    pumvisible() ? "\<C-y>" : "\<CR>"

" ============================================================================
" Session Management
" ============================================================================

nnoremap <leader>Ss :mksession! ~/.vim/session.vim<CR>
nnoremap <leader>Sl :source ~/.vim/session.vim<CR>
silent! !mkdir -p ~/.vim

" ============================================================================
" Spell Check
" ============================================================================

set spelllang=en_us
nnoremap <leader>us :set spell!<CR>
autocmd FileType markdown,txt,text setlocal spell

" ============================================================================
" Git Integration
" ============================================================================

nnoremap <leader>gb :.!git blame %<CR>
nnoremap <leader>gl :!git log --oneline -20 %<CR>
nnoremap <leader>gd :!git diff %<CR>
nnoremap <leader>gs :!git status<CR>

" ============================================================================
" Config
" ============================================================================

nnoremap <leader>ev :e ~/.vimrc<CR>
nnoremap <leader>sv :source ~/.vimrc<CR>

" ============================================================================
" Toggles
" ============================================================================

nnoremap <leader>tn :set number!<CR>
nnoremap <leader>tr :set relativenumber!<CR>
nnoremap <leader>tw :set wrap!<CR>
nnoremap <leader>tp :set paste!<CR>
nnoremap <leader>fp :echo expand('%:p')<CR>
nnoremap <leader>cd :cd %:p:h<CR>:pwd<CR>

" ============================================================================
" Performance
" ============================================================================

set nobackup
set nowritebackup
set noswapfile
if has('persistent_undo')
  set undofile
  set undodir=~/.vim/undo
  silent! !mkdir -p ~/.vim/undo
endif
set timeoutlen=300
set ttimeoutlen=0
set updatetime=300
set scrolloff=8
set sidescrolloff=8
set ttyfast
set lazyredraw
set display+=lastline

" ============================================================================
" Mouse
" ============================================================================

if has('mouse')
  set mouse=a
endif

" ============================================================================
" Language Settings
" ============================================================================

autocmd FileType python setlocal expandtab shiftwidth=4 tabstop=4
autocmd FileType javascript,typescript setlocal expandtab shiftwidth=2 tabstop=2
autocmd FileType html,xhtml,xml setlocal expandtab shiftwidth=2 tabstop=2
autocmd FileType css,scss,sass setlocal expandtab shiftwidth=2 tabstop=2
autocmd FileType json setlocal expandtab shiftwidth=2 tabstop=2
autocmd FileType yaml setlocal expandtab shiftwidth=2 tabstop=2
autocmd FileType markdown setlocal wrap linebreak textwidth=80

" ============================================================================
" Help
" ============================================================================

nnoremap <leader>h :vert help 
nnoremap <leader>mk :map<CR>
nnoremap <leader>mK :map!<CR>

" ============================================================================
" Auto-commands
" ============================================================================

autocmd BufReadPost * if line("'\"") > 1 && line("'\"") <= line("$") | exe "normal! g'\"" | endif
autocmd BufWritePre * %s/\s\+$//e
autocmd BufWinLeave *.* mkview
autocmd BufWinEnter *.* silent loadview
autocmd BufWritePost ~/.vimrc source ~/.vimrc
autocmd ModeChanged * redrawstatus

" ============================================================================
" Visual Mode
" ============================================================================

vnoremap < <gv
vnoremap > >gv
vnoremap * y/<C-R>"<CR>
vnoremap # y?<C-R>"<CR>
vnoremap <C-r> "hy:%s/<C-r>h//gc<left><left><left>

" ============================================================================
" Command Line
" ============================================================================

set wildmenu
set wildmode=list:longest,full
cnoremap <C-a> <Home>
cnoremap <C-e> <End>
cnoremap <C-b> <Left>
cnoremap <C-f> <Right>
cnoremap <C-d> <Delete>
cnoremap <C-k> <C-\>estrpart(getcmdline(),0,getcmdpos()-1)<CR>

" ============================================================================
" Quickfix
" ============================================================================

nnoremap <leader>c :cwindow<CR>
nnoremap <leader>l :lwindow<CR>
nnoremap ]q :cnext<CR>
nnoremap [q :cprevious<CR>
nnoremap ]Q :clast<CR>
nnoremap [Q :cfirst<CR>
nnoremap ]l :lnext<CR>
nnoremap [l :lprevious<CR>

" ============================================================================
" Marks and Registers
" ============================================================================

nnoremap <leader>ma :marks<CR>
nnoremap <leader>reg :registers<CR>

" ============================================================================
" Welcome Message
" ============================================================================

autocmd VimEnter * echo "Nixit Vim • Catppuccin Mocha • Mode-aware cursor"
