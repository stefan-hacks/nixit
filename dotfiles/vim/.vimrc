" ============================================================================
" Nixit Vimrc - LazyVim-inspired Native Vim Configuration
" ============================================================================
" 100% native Vim - no plugins, no plugin manager, nothing to install.
" Catppuccin Mocha is the default theme. Press <leader>ta (or run :Theme
" adwaita) to switch to a GNOME Adwaita-inspired theme on the fly.
" Icons use Nerd Font glyphs - if you see boxes instead of icons, install a
" Nerd Font (e.g. JetBrainsMono Nerd Font) and set it as your terminal font.
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
" Theme Engine
" ============================================================================
" Every color in this config is looked up from g:theme_palette, a dict of
" role names -> hex colors. Switching themes just swaps the dict and
" re-applies every highlight group, so nothing else in this file needs to
" know or care which theme is active.

if has('termguicolors')
  set termguicolors
endif
set background=dark

let g:theme_name = 'catppuccin'

let g:palette_catppuccin_mocha = {
      \ 'base':      '#1e1e2e',
      \ 'surface':   '#313244',
      \ 'overlay':   '#45475a',
      \ 'muted':     '#6c7086',
      \ 'subtext':   '#a6adc8',
      \ 'text':      '#cdd6f4',
      \ 'rosewater': '#f5e0dc',
      \ 'flamingo':  '#f2cdcd',
      \ 'pink':      '#f5c2e7',
      \ 'mauve':     '#cba6f7',
      \ 'red':       '#f38ba8',
      \ 'maroon':    '#eba0ac',
      \ 'peach':     '#fab387',
      \ 'yellow':    '#f9e2af',
      \ 'green':     '#a6e3a1',
      \ 'teal':      '#94e2d5',
      \ 'sky':       '#89dceb',
      \ 'sapphire':  '#74c7ec',
      \ 'blue':      '#89b4fa',
      \ 'lavender':  '#b4befe',
      \ }

" GNOME Adwaita-dark inspired palette
let g:palette_adwaita = {
      \ 'base':      '#1e1e1e',
      \ 'surface':   '#2d2d2d',
      \ 'overlay':   '#3d3d3d',
      \ 'muted':     '#9a9996',
      \ 'subtext':   '#c0bfbc',
      \ 'text':      '#ffffff',
      \ 'rosewater': '#f9dbc0',
      \ 'flamingo':  '#f5b199',
      \ 'pink':      '#d56199',
      \ 'mauve':     '#9141ac',
      \ 'red':       '#e62d42',
      \ 'maroon':    '#c6262e',
      \ 'peach':     '#ff7800',
      \ 'yellow':    '#f6d32d',
      \ 'green':     '#33d17a',
      \ 'teal':      '#2190a4',
      \ 'sky':       '#62a0ea',
      \ 'sapphire':  '#1c71d8',
      \ 'blue':      '#3584e4',
      \ 'lavender':  '#b34cd1',
      \ }

let g:theme_palette = g:palette_catppuccin_mocha

function! ApplyTheme()
  let p = g:theme_palette

  " Base highlights
  execute 'highlight Normal guifg=' . p.text . ' guibg=' . p.base
  execute 'highlight Comment guifg=' . p.muted . ' gui=italic'
  execute 'highlight Constant guifg=' . p.peach
  execute 'highlight String guifg=' . p.green
  execute 'highlight Character guifg=' . p.green
  execute 'highlight Number guifg=' . p.peach
  execute 'highlight Boolean guifg=' . p.peach
  execute 'highlight Float guifg=' . p.peach
  execute 'highlight Identifier guifg=' . p.flamingo
  execute 'highlight Function guifg=' . p.blue
  execute 'highlight Statement guifg=' . p.mauve . ' gui=bold'
  execute 'highlight Conditional guifg=' . p.mauve
  execute 'highlight Repeat guifg=' . p.mauve
  execute 'highlight Label guifg=' . p.mauve
  execute 'highlight Operator guifg=' . p.sky
  execute 'highlight Keyword guifg=' . p.mauve . ' gui=bold'
  execute 'highlight Exception guifg=' . p.mauve
  execute 'highlight PreProc guifg=' . p.pink
  execute 'highlight Include guifg=' . p.mauve
  execute 'highlight Define guifg=' . p.pink
  execute 'highlight Macro guifg=' . p.pink
  execute 'highlight PreCondit guifg=' . p.pink
  execute 'highlight Type guifg=' . p.yellow
  execute 'highlight StorageClass guifg=' . p.yellow
  execute 'highlight Structure guifg=' . p.yellow
  execute 'highlight Typedef guifg=' . p.yellow
  execute 'highlight Special guifg=' . p.sky
  execute 'highlight SpecialChar guifg=' . p.sky
  execute 'highlight Tag guifg=' . p.sky
  execute 'highlight Delimiter guifg=' . p.subtext
  execute 'highlight SpecialComment guifg=' . p.muted . ' gui=bold'
  execute 'highlight Debug guifg=' . p.red
  execute 'highlight Error guifg=' . p.base . ' guibg=' . p.red . ' gui=bold'
  execute 'highlight Todo guifg=' . p.base . ' guibg=' . p.yellow . ' gui=bold'
  execute 'highlight Underlined guifg=' . p.blue . ' gui=underline'

  " UI Elements
  execute 'highlight LineNr guifg=' . p.muted . ' guibg=' . p.base
  execute 'highlight CursorLineNr guifg=' . p.text . ' guibg=' . p.surface . ' gui=bold'
  execute 'highlight SignColumn guibg=' . p.base
  execute 'highlight FoldColumn guifg=' . p.muted . ' guibg=' . p.base
  execute 'highlight Folded guifg=' . p.muted . ' guibg=' . p.surface
  execute 'highlight ColorColumn guibg=' . p.surface
  execute 'highlight NonText guifg=' . p.overlay
  execute 'highlight SpecialKey guifg=' . p.overlay

  " Search and Match
  execute 'highlight Search guifg=' . p.base . ' guibg=' . p.yellow . ' gui=bold'
  execute 'highlight IncSearch guifg=' . p.base . ' guibg=' . p.peach . ' gui=bold'
  execute 'highlight MatchParen guifg=' . p.base . ' guibg=' . p.peach . ' gui=bold'

  " Visual Selection
  execute 'highlight Visual guifg=' . p.text . ' guibg=' . p.surface
  execute 'highlight VisualNOS guifg=' . p.text . ' guibg=' . p.surface

  " Popup Menu
  execute 'highlight Pmenu guifg=' . p.text . ' guibg=' . p.surface
  execute 'highlight PmenuSel guifg=' . p.base . ' guibg=' . p.mauve . ' gui=bold'
  execute 'highlight PmenuSbar guibg=' . p.base
  execute 'highlight PmenuThumb guibg=' . p.muted

  " Wild Menu
  execute 'highlight WildMenu guifg=' . p.base . ' guibg=' . p.mauve . ' gui=bold'

  " Status Line Base
  execute 'highlight StatusLine guifg=' . p.text . ' guibg=' . p.surface . ' gui=bold'
  execute 'highlight StatusLineNC guifg=' . p.muted . ' guibg=' . p.base
  execute 'highlight StatusLineTerm guifg=' . p.text . ' guibg=' . p.surface
  execute 'highlight StatusLineTermNC guifg=' . p.muted . ' guibg=' . p.base

  " Tab Line
  execute 'highlight TabLine guifg=' . p.muted . ' guibg=' . p.base
  execute 'highlight TabLineFill guifg=' . p.base . ' guibg=' . p.base
  execute 'highlight TabLineSel guifg=' . p.text . ' guibg=' . p.surface . ' gui=bold'

  " Split Separators - invisible (no distracting divider line)
  execute 'highlight VertSplit guifg=' . p.base . ' guibg=' . p.base

  " Messages
  execute 'highlight ErrorMsg guifg=' . p.red . ' guibg=' . p.base . ' gui=bold'
  execute 'highlight WarningMsg guifg=' . p.peach . ' guibg=' . p.base . ' gui=bold'
  execute 'highlight MoreMsg guifg=' . p.blue . ' guibg=' . p.base
  execute 'highlight Question guifg=' . p.sky . ' guibg=' . p.base

  " Mode-aware status line highlights
  execute 'highlight SLNormal guifg=' . p.base . ' guibg=' . p.mauve . ' gui=bold'
  execute 'highlight SLNormalSep guifg=' . p.mauve . ' guibg=' . p.surface
  execute 'highlight SLInsert guifg=' . p.base . ' guibg=' . p.sky . ' gui=bold'
  execute 'highlight SLInsertSep guifg=' . p.sky . ' guibg=' . p.surface
  execute 'highlight SLVisual guifg=' . p.base . ' guibg=' . p.green . ' gui=bold'
  execute 'highlight SLVisualSep guifg=' . p.green . ' guibg=' . p.surface
  execute 'highlight SLReplace guifg=' . p.base . ' guibg=' . p.red . ' gui=bold'
  execute 'highlight SLReplaceSep guifg=' . p.red . ' guibg=' . p.surface
  execute 'highlight SLCommand guifg=' . p.base . ' guibg=' . p.peach . ' gui=bold'
  execute 'highlight SLCommandSep guifg=' . p.peach . ' guibg=' . p.surface
  execute 'highlight SLFile guifg=' . p.text . ' guibg=' . p.surface
  execute 'highlight SLInfo guifg=' . p.blue . ' guibg=' . p.surface
  execute 'highlight SLPos guifg=' . p.base . ' guibg=' . p.blue . ' gui=bold'
  execute 'highlight SLGit guifg=' . p.green . ' guibg=' . p.surface
  execute 'highlight SLEncoding guifg=' . p.subtext . ' guibg=' . p.surface

  " Dashboard
  execute 'highlight DashboardLogo guifg=' . p.mauve . ' gui=bold'
  execute 'highlight DashboardSubtitle guifg=' . p.subtext . ' gui=italic'
  execute 'highlight DashboardKey guifg=' . p.peach . ' gui=bold'
  execute 'highlight DashboardDesc guifg=' . p.text
  execute 'highlight DashboardFooter guifg=' . p.muted . ' gui=italic'

  " Mode-aware cursor (used by UpdateCursorColor below)
  execute 'highlight Cursor guifg=' . p.base . ' guibg=' . p.mauve

  let g:colors_name = g:theme_name
  redrawstatus!
endfunction

function! s:SetTheme(name)
  if a:name ==# 'adwaita'
    let g:theme_palette = g:palette_adwaita
    let g:theme_name = 'adwaita'
  else
    let g:theme_palette = g:palette_catppuccin_mocha
    let g:theme_name = 'catppuccin'
  endif
  call ApplyTheme()
  echo 'Theme: ' . g:theme_name
endfunction

function! s:ToggleTheme()
  call s:SetTheme(g:theme_name ==# 'catppuccin' ? 'adwaita' : 'catppuccin')
endfunction

" Global wrapper so it can be safely referenced from :execute-built mappings
" (e.g. the dashboard) without worrying about <SID> script-context resolution.
function! ToggleNixitTheme()
  call s:ToggleTheme()
endfunction

command! -nargs=1 -complete=customlist,s:ThemeComplete Theme call s:SetTheme(<q-args>)
function! s:ThemeComplete(...)
  return ['catppuccin', 'adwaita']
endfunction

nnoremap <leader>ta :call ToggleNixitTheme()<CR>
nnoremap <leader>tC :Theme catppuccin<CR>
nnoremap <leader>tA :Theme adwaita<CR>

call ApplyTheme()

" ============================================================================
" Cursor Shape (mode aware, terminal cursor)
" ============================================================================

if has('guicolors') || &term =~? 'xterm\|screen\|tmux'
  let &t_SI = "\e[6 q"
  let &t_SR = "\e[4 q"
  let &t_EI = "\e[2 q"
endif
set guicursor=n-v-c:block,i-ci-ve:ver25,r-cr:hor20,o:hor50

" ============================================================================
" UI Configuration
" ============================================================================

set number
set relativenumber
set showmatch
set matchtime=2
set showcmd
set laststatus=2
set noshowmode

" ============================================================================
" Mode Detection and Status Line
" ============================================================================

function! GetMode()
  let l:mode = mode()
  if l:mode ==# 'n'
    return 'NORMAL'
  elseif l:mode ==# 'i'
    return 'INSERT'
  elseif l:mode ==# 'v'
    return 'VISUAL'
  elseif l:mode ==# 'V'
    return 'V-LINE'
  elseif l:mode ==# "\<C-v>"
    return 'V-BLOCK'
  elseif l:mode ==# 'R' || l:mode ==# 'Rv'
    return 'REPLACE'
  elseif l:mode ==# 'c'
    return 'COMMAND'
  elseif l:mode ==# 't'
    return 'TERMINAL'
  else
    return toupper(l:mode)
  endif
endfunction

function! GetModeColor()
  let l:mode = mode()
  if l:mode ==# 'i'
    return 'SLInsert'
  elseif l:mode ==# 'v' || l:mode ==# 'V' || l:mode ==# "\<C-v>"
    return 'SLVisual'
  elseif l:mode ==# 'R' || l:mode ==# 'Rv'
    return 'SLReplace'
  elseif l:mode ==# 'c'
    return 'SLCommand'
  else
    return 'SLNormal'
  endif
endfunction

function! GetModeSep()
  let l:mode = mode()
  if l:mode ==# 'i'
    return 'SLInsertSep'
  elseif l:mode ==# 'v' || l:mode ==# 'V' || l:mode ==# "\<C-v>"
    return 'SLVisualSep'
  elseif l:mode ==# 'R' || l:mode ==# 'Rv'
    return 'SLReplaceSep'
  elseif l:mode ==# 'c'
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
  let l:sl .= '%#' . l:mode_sep . '#%*'

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

  " Theme name
  let l:sl .= '%#SLEncoding#  ' . g:theme_name . ' %*'

  " Git branch
  let l:branch = GitBranch()
  if strlen(l:branch) > 0 && l:branch !=# 'HEAD'
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

function! UpdateCursorColor()
  let l:mode = mode()
  let p = g:theme_palette
  if l:mode ==# 'i'
    execute 'highlight Cursor guifg=' . p.base . ' guibg=' . p.sky
  elseif l:mode ==# 'v' || l:mode ==# 'V' || l:mode ==# "\<C-v>"
    execute 'highlight Cursor guifg=' . p.base . ' guibg=' . p.green
  elseif l:mode ==# 'R' || l:mode ==# 'Rv'
    execute 'highlight Cursor guifg=' . p.base . ' guibg=' . p.red
  elseif l:mode ==# 'c'
    execute 'highlight Cursor guifg=' . p.base . ' guibg=' . p.peach
  else
    execute 'highlight Cursor guifg=' . p.base . ' guibg=' . p.mauve
  endif
  redrawstatus
endfunction

augroup ModeCursor
  autocmd!
  autocmd ModeChanged * call UpdateCursorColor()
augroup END

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

" Subtle indent guides (native listchars, LazyVim-esque)
set list
set listchars=tab:\│\ ,trail:·,nbsp:␣,extends:›,precedes:‹

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
set splitkeep=screen
nnoremap <leader>q :q<CR>
nnoremap <leader>sv <C-w>v
nnoremap <leader>sh <C-w>s
nnoremap <leader>se <C-w>=
nnoremap <leader>sx :close<CR>
nnoremap <C-h> <C-w>h
nnoremap <C-j> <C-w>j
nnoremap <C-k> <C-w>k
nnoremap <C-l> <C-w>l
nnoremap <C-Up>    :resize -2<CR>
nnoremap <C-Down>  :resize +2<CR>
nnoremap <C-Left>  :vertical resize -2<CR>
nnoremap <C-Right> :vertical resize +2<CR>

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
nnoremap <leader>tl :set list!<CR>
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
" Help / Which-key-lite
" ============================================================================
" Native Vim has no popup which-key, but :map/:map! dump every binding, and
" pressing <leader> then waiting shows Vim's own command completion in the
" wildmenu for anything typed as a command.

nnoremap <leader>h :vert help
nnoremap <leader>mk :map<CR>
nnoremap <leader>mK :map!<CR>
nnoremap <leader>? :map<CR>

" ============================================================================
" Auto-commands
" ============================================================================

autocmd BufReadPost * if line("'\"") > 1 && line("'\"") <= line("$") | exe "normal! g'\"" | endif
autocmd BufWritePre * %s/\s\+$//e
autocmd BufWinLeave *.* mkview
autocmd BufWinEnter *.* silent loadview
autocmd BufWritePost ~/.vimrc source ~/.vimrc

" ============================================================================
" Visual Mode
" ============================================================================

vnoremap * y/<C-R>"<CR>
vnoremap # y?<C-R>"<CR>
vnoremap <C-r> "hy:%s/<C-r>h//gc<left><left><left>

" ============================================================================
" Command Line
" ============================================================================

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
" Dashboard (LazyVim-style start screen)
" ============================================================================
" Shown only when Vim is launched with no file argument and nothing piped
" in on stdin - a quiet, centered menu instead of a blank buffer.

let s:dashboard_logo = [
      \ '  _   _ _      _ _   ',
      \ ' | \ | (_)_  _(_) |_ ',
      \ ' |  \| | \ \/ / | __|',
      \ ' | |\  | |>  <| | |_ ',
      \ ' |_| \_|_/_/\_\_|\__|',
      \ ]

function! s:DashboardCenter(line, width)
  let l:pad = (a:width - strdisplaywidth(a:line)) / 2
  return l:pad > 0 ? repeat(' ', l:pad) . a:line : a:line
endfunction

function! s:OpenDashboard()
  enew
  setlocal buftype=nofile bufhidden=wipe noswapfile nobuflisted
  setlocal nonumber norelativenumber nocursorline nolist statusline=\
  setlocal filetype=dashboard

  let l:width = winwidth(0)
  let l:lines = []
  call add(l:lines, '')
  call add(l:lines, '')
  for l:logo_line in s:dashboard_logo
    call add(l:lines, s:DashboardCenter(l:logo_line, l:width))
  endfor
  call add(l:lines, s:DashboardCenter('native vim · no plugins · ' . g:theme_name, l:width))
  call add(l:lines, '')

  let l:menu = [
        \ ['f', 'Find file', ':find '],
        \ ['e', 'Explorer', ':Lexplore<CR>'],
        \ ['n', 'New file', ':enew<CR>'],
        \ ['g', 'Live grep', ':vimgrep // **/*<Left><Left><Left><Left><Left><Left>'],
        \ ['c', 'Edit config', ':e ~/.vimrc<CR>'],
        \ ['t', 'Toggle theme', ':call ToggleNixitTheme()<CR>'],
        \ ['q', 'Quit', ':q<CR>'],
        \ ]
  for l:item in l:menu
    let l:entry = printf('[%s]  %s', l:item[0], l:item[1])
    call add(l:lines, s:DashboardCenter(l:entry, l:width))
  endfor
  call add(l:lines, '')
  call add(l:lines, s:DashboardCenter('press a key above to get started', l:width))

  call setline(1, l:lines)
  setlocal nomodifiable nomodified

  " Highlight the sections
  let l:logo_start = 3
  let l:logo_end = l:logo_start + len(s:dashboard_logo) - 1
  execute 'syntax match DashboardLogo /\%' . l:logo_start . 'l.*\%' . l:logo_end . 'l/'
  execute 'syntax match DashboardSubtitle /\%' . (l:logo_end + 1) . 'l.*/'
  syntax match DashboardKey /\[.\]/
  syntax match DashboardFooter /press a key.*/

  for l:item in l:menu
    execute 'nnoremap <buffer> ' . l:item[0] . ' ' . l:item[2]
  endfor
  nnoremap <buffer> q :q<CR>
endfunction

command! Dashboard call s:OpenDashboard()

augroup NixitDashboard
  autocmd!
  autocmd VimEnter * if argc() == 0 && line2byte('$') == -1 && !exists('s:std_in') | call s:OpenDashboard() | endif
augroup END

" ============================================================================
" Welcome Message
" ============================================================================

autocmd VimEnter * echo 'Nixit Vim · ' . g:theme_name . ' · <leader>ta to swap theme'
