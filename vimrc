"################################## VIM SETUP COMMANDS ####################################

"BASIC SETUP
set nocompatible            											" disable compatibility with vi
set showcmd                 											" show all commands typed
set showmode                											" show currentmode of VIM
set number                  											" set line number
set mouse=a                 											" enable mouse support in vim
set title                   											" Show title
set autoread                											" automatically read file that has been changed outside vim
set autochdir               											" automatically change the current Dir
set backspace=indent,eol,start  										" make backspace work
set noerrorbells
"set relativenumber         											" set relative numbering
"set visualbell
"let mapleader=","                                                     " leader is comma instead of \

"FORMAT OPRIONS
set formatoptions=qtn1
set formatoptions-=r
set encoding=utf-8          											" UTF-8 text encoding by default
set t_Co=256                                                            " enable 256 colors
" set termguicolors
set fileformat=unix
"set spell spelllang=en_us

"DISPLAY
set ruler                   											" display current cursor position in lower right corner
set cursorcolumn            											" highlite current column
set cursorline             											    " highlite current row
set scrolloff=3             											" option determines the number of context lines you would like to see above and below the cursor.
set sidescrolloff=15             										" scroll horizontall
set lazyredraw                                                          " redraw only when we need to.
"set list                   											" end of lines show as '$' and carriage returns usually show as '^M'
"set listchars=tab:▶\
"set listchars+=eol:$
"set listchars+=trail:◥
"set listchars+=nbsp:•
"set listchars+=extends:❯
"set listchars+=precedes:❮
"match ErrorMsg '\s\+$"

"GVIM DIFF
if &diff
    " diff mode
    set diffopt+=iwhite
    set diffopt+=horizontal
endif

"SEARCHING IN FILE
" with both ignorecase and smartcase turned on, a search is case-insensitive if you enter the search string in ALL lower case ; if your search string
" has one or more characters in upper case, it will assume that you want a case-sensitive search
set ignorecase
set smartcase
set incsearch               											" incremental search:search when you type
set hlsearch                											" highlite search pattern
set showmatch               											" show matching brackets
"set nowrapscan

"COMPLETION MENU
set completeopt=longest,menuone 										" popup menu doesn't select the first completion item, but rather just inserts the longest common text of all matches
set modelines=0             											" read the first and last few lines of each file for ex commands.

"TABS
set tabstop=4               											" actual tab character =4 white spaces
set shiftwidth=4            											" indentation of 4 white space   s
set softtabstop=4           											" tab key will be combination of tab & space
set expandtab               											" will insert spaces instead of tabs character
set smarttab                											" insert insert tabs/spaces to go to next indent

"WRAP
set wrap
set wrapmargin=2            											" turn off physical insertion of lines
"set textwidth=100           											" automatically wrap after 150 cols
" set colorcolumn=100

"INDENTATION
set autoindent
set smartindent
set copyindent
set cindent
set linebreak
if has('linebreak')
    set showbreak=->
endif
nnoremap    <F6>        gg=G                  							" Indent all file

"FOLDING
set foldenable                                                          " fold by default
"set nofoldenable                                                       " don't fold by default
set foldmethod=indent          											" automatically fold based on indentation
"set foldmethod=marker                                                  " The fold markers are {{{ and }}}
set foldlevelstart=10           										" fold for all files
set foldlevel=12
set foldnestmax=12
"set foldcolumn=12
nnoremap    <space>     za            								    " map space to toggle fold

"WINDOW MANAGEMENT
if has('windows')
    set splitbelow                      								" open horizontal splits below current window
endif
if has('vertsplit')
    set splitright                     									" open vertical splits to the right of the current window
endif

"STATUS LINE
set laststatus=2
set statusline=
"set statusline+=%#PmenuSel#
set statusline +=%1*\ %n\ %*                                            " buffer number
set statusline +=%2*%y%*                                                " file type
set statusline +=%<%F%*                                                 " full path
set statusline +=%<%F%*                                                 " full path
set statusline +=%*%m%*                                                 " modified flag
set statusline +=%1*%=%5l%*                                             " current line
set statusline +=%2*/%L%*                                               " total lines
set statusline +=%1*%4v\ %*                                            " virtual column number

"MISC.
set hidden                  											" hide buffers instead of closing them
set ttyfast                 											" fast scrolling
set gdefault                											" %s/foo/bar/ will assume %s/foo/bar/g
"set shortmess+=A               										" ignore annoying swapfile messages
set shortmess+=W                										" don't echo [w]/[written] when writing
set shortmess+=a                										" use abbreviations in messages eg. `[RO]` instead of `[readonly]`
set guifont=Courier\ 10\ Pitch  										" Default font
set updatecount=80              										" update swapfiles every 80 typed chars
set updatetime=200              										" same as YCM
set tag=tags

"UNDO
if !isdirectory($HOME."/.vim/.undo-dir")
    call mkdir($HOME."/.vim/.undo-dir","", 0700)
endif
" set undodir=~/.vim/.undo-dir//
set history=100
set undolevels=100
" set undofile

"BACKUP
if !isdirectory($HOME."/.vim/.backup-dir")
    call mkdir($HOME."/.vim/.backup-dir","", 0700)
    call mkdir($HOME."/.vim/.backupskip-dir","", 0700)
endif
set backupdir=~/.vim/.backup-dir/
set backupskip=~/.vim/.backupskip-dir/
set backup
set writebackup
set backupext=.org
"set patchmode=.bak

"SWAP FILES
if !isdirectory($HOME."/.vim/.swp-dir")
    call mkdir($HOME."/.vim/.swp-dir","", 0700)
endif
set directory=~/.vim/.swp-dir/
set swapfile

" FINDING FILES
set path+=**                											" search in subfolder ; provide tab-completion
set wildmenu                											" display all matching files when tab in bottom
set wildmode=list:longest,full
set wildignore=*.swp,*.bak,*.pyc,*.class,*.o        					" ignore following in wildmode
set wildignore+=*/tmp/*,*.so,*.zip,*.tar,*.tar.gz

"SYSTEMVERILOG SYNTAX
syntax on
syntax enable
au BufNewFile,BufRead *.sv,*.vpp,*.svh,*.vh,*.v so ~/.vim/syntax/verilog_systemverilog.vim

" USE ONLY WHEN OPENING VERY LARGE FILES FOR VIEWING
"set noswapfile                                                           " no swap files ; we are saving very often anyways
"set nobackup                                                            " no backup files
"set nowritebackup                                                       " only in case you don't want a backup file while editing
"set noundofile                                                          " no undofile

"################################## MAPPINGS ####################################

"DISBALE ARROW KEYS
"noremap    <Up>    <NOP>
"noremap    <Down>  <NOP>
"noremap    <Left>  <NOP>
"noremap    <Right> <NOP>
"
" move vertically by visual line"
nnoremap    j       gj
nnoremap    k       gk

" move to beginning/end of line
nnoremap    B       ^
nnoremap    E       $

" highlight last inserted text
nnoremap    gV      `[v`]

" jk is escape
inoremap    jk      <esc>

"DISABLE HELP
"inoremap   <F1>    <ESC>
"nnoremap   <F1>    <ESC>
"vnoremap   <F1>    <ESC>

"MAKE BACKSPACE WORK IN VIM
inoremap    BS      <^H>
nnoremap    BS      <^H>
vnoremap    BS      <^H>

inoremap    (       ()<Esc>i
inoremap    <       <><Esc>i
inoremap    {       {}<Esc>i
inoremap    [       []<Esc>i
inoremap    "       ""<Esc>i
inoremap    '       ''<Esc>i
inoremap    `       ``<Esc>i

"WINDOW NAVIGATION
nnoremap    <C-j>   <C-w>j
nnoremap    <C-k>   <C-w>k
nnoremap    <C-h>   <C-w>h
nnoremap    <C-l>   <C-w>l

"################################## HIGHLIGHTS ####################################

hi MatchParen       ctermfg=Blue                    guifg=Blue
hi Search           ctermbg=Yellow ctermfg=Red      guibg=Yellow guifg=Red
hi Comment          cterm=italic                    gui=italic
hi ColorColumn      ctermbg=Gray                    guibg=grey95
hi Cursor           cterm=Bold                      gui=Bold
hi CursorLine       ctermbg=LightGrey               guibg=grey97
hi CursorColumn     ctermbg=LightGrey               guibg=grey97
hi Directory        cterm=Bold                      gui=Bold
hi ErrorMsg         ctermbg=Red cterm=Bold          guibg=Red gui=Bold
hi WarningMsg       cterm=Bold ctermbg=DarkYellow   guibg=DarkYellow gui=Bold
hi Folded           cterm=Bold ctermbg=Grey         gui=Bold guibg=Grey
hi NonText          cterm=Bold                      gui=Bold
hi Constant         cterm=Bold,italic                      gui=Bold,italic
hi SpecialKey       cterm=Bold                      gui=Bold
"hi SpellBad        cterm=Bold                      gui=Bold
"hi SpellCap        cterm=Bold                      gui=Bold

" highlight extra whitespaces
hi ExtraWhitespace  ctermbg=Brown                    guibg=Brown
match ExtraWhitespace /\s\+$/
"
"GUI fg/bg COLORS
"highlight Normal                                   guibg=lightyellow
"highlight Normal                                   guibg=grey90

"STATUS LINE COLORS
hi User1            ctermfg=Gray ctermbg=Black      guifg=#eea040 guibg=Black
hi User2            ctermfg=Gray ctermbg=Black      guifg=#eea040 guibg=Black
hi User3            ctermfg=Gray ctermbg=Black      guifg=#eea040 guibg=Black
hi User4            ctermfg=Gray ctermbg=Black      guifg=#eea040 guibg=Black
hi User5            ctermfg=Gray ctermbg=Black      guifg=#eea040 guibg=Black
hi User6            ctermfg=Gray ctermbg=Black      guifg=#eea040 guibg=Black
hi User7            ctermfg=Gray ctermbg=Black      guifg=#eea040 guibg=Black
hi User8            ctermfg=Gray ctermbg=Black      guifg=#eea040 guibg=Black
hi User9            ctermfg=Gray ctermbg=Black      guifg=#eea040 guibg=Black

"################################## FUNCTIONS ####################################

" strips trailing whitespace at the end of files. this
function! <SID>StripTrailingWhitespaces()
    " save last search & cursor position
    let _s=@/
    let l = line(".")
    let c = col(".")
    %s/\s\+$//e
    let @/=_s
    call cursor(l, c)
endfunction

" toggle between number and relativenumber
function! ToggleNumber()
    if(&relativenumber == 1)
        set norelativenumber
        set number
    else
        set relativenumber
    endif
endfunc

" These need vim-go plugin
function! <SID>RunFile()
    let ext = expand("%:e")
    if(ext == "go")
        :GoRun
    endif
endfunc

function! <SID>BuildFile()
    let ext = expand("%:e")
    if(ext == "go")
        :GoBuild
    endif
endfunc

"################################## AUTOGROUPS ####################################

augroup configgroup
    autocmd!
    autocmd VimEnter    *           highlight clear SignColumn
    autocmd VimEnter    *           :call <SID>StripTrailingWhitespaces()                           " remove trailing spaces before opening any file
    "autocmd BufWritePre *.php,*.py,*.js,*.txt,*.hs,*.java,*.md,*.sh,*.c,*.cc,*.cpp  \
    "                                :call <SID>StripTrailingWhitespaces()                          " remove trailing spaces before writing these files
    autocmd FileType    python      setlocal commentstring=#\ %s
    autocmd BufEnter    Makefile    setlocal noexpandtab
    "autocmd BufEnter *.sh setlocal softtabstop=2
    "SYNTAX HIGHLIGHTING FOR TRACE FILES
    au BufRead,BufNewFile   *.trc     so $UTILS_HOME/verif/vim
augroup END
let fts = ['trc', 'trace', 'dump', 'dmp', 'hex']
if index(fts, &filetype) == -1
    set noswapfile                                                           " no swap files ; we are saving very often anyways
    set nobackup                                                            " no backup files
    set nowritebackup                                                       " only in case you don't want a backup file while editing
    "set noundofile                                                          " no undofile
endif

""################################## PLUGINS ####################################
""VUNDLE
"
"filetype off
"set rtp+=~/.vim/bundle/Vundle.vim           							" set the runtime path to include Vundle and initialize
"
"call vundle#begin()         		    							    " a path where Vundle should install plugins
"Plugin 'VundleVim/Vundle.vim'               							" let Vundle manage Vundle, required
"Plugin 'scrooloose/nerdtree'
"Plugin 'Xuyuanp/nerdtree-git-plugin'
"Plugin 'godlygeek/tabular.git'
"Plugin 'majutsushi/tagbar'
"Plugin 'scrooloose/syntastic'
"Plugin 'Rykka/riv.vim'
"Plugin 'kien/ctrlp.vim'
"Plugin 'fatih/vim-go'
""Plugin 'nathanaelkane/vim-indent-guides'
"
""NERDTree
"let NERDTreeQuitOnOpen=0
""let g:NERDTreeDirArrowExpandable = '▸'
""let g:NERDTreeDirArrowCollapsible = '▾'
"let NERDTreeMinimalUI = 1
"let NERDTreeDirArrows = 0
"let NERDTreeAutoDeleteBuffer = 1
""autocmd vimentre * NERDTree
"
""Tagbar
"let g:tagbar_ctags_bin = "ctags"
"let g:tagbar_show_visibility = 1
"let g:tagbar_autofocus = 0
"
""Syntastic
"set statusline+=%#warningmsg#
"set statusline+=%{SyntasticStatuslineFlag()}
"set statusline+=%*
"
"let g:syntastic_always_populate_loc_list = 1
"let g:syntastic_auto_loc_list = 1
"let g:syntastic_check_on_open = 1
"let g:syntastic_check_on_wq = 0
""let g:syntastic_c_no_default_include_dirs=1   " disable default includes
"let g:syntastic_c_include_dirs = [ '-I.',' -I..',' -Iinclude ',' -Iincludes',' -I../include ',' -I../includes', '../include', 'include']
""let g:syntastic_cpp_no_default_include_dirs=1   " disable default includes
"let g:syntastic_cpp_auto_refresh_includes = 0
"let g:syntastic_cpp_remove_include_errors = 0
"let g:syntastic_cpp_include_dirs = [ '-I.',' -I..',' -Iinclude ',' -Iincludes',' -I../include ',' -I../includes', '../include', 'include' , '-I./TESTBENCH/INC' , '-I./TESTBENCH/INC/NSIM_HOME', '-I./TESTBENCH/INC/ZEBU_IP_ROOT' , '-I./TESTBENCH/INC/ZEBU_ROOT/' ]
"let g:syntastic_cpp_compiler_options = ' -std=c++11'
""let g:syntastic_cpp_compiler = 'clang++'           " use default g++
"
"
"
"" CtrlP settings
"let g:ctrlp_match_window = 'bottom,order:ttb'
"let g:ctrlp_switch_buffer = 0
"let g:ctrlp_working_path_mode = 0
"let g:ctrlp_user_command = 'ag %s -l --nocolor --hidden -g ""'
""let g:ctrlp_user_command = 'find %s -type f'
"
"call vundle#end()            " required

"COLORSCHEME
"colorscheme solarized
colorscheme default

" call  "filetype plugin on" after pulgins are done
"ENABLE FILETYPES
filetype on
filetype plugin on
filetype indent on          											" automatic, language-dependent indentation, syntax coloring and other functionality
let do_syntax_sel_menu=1

if &filetype ==# 'c' || &filetype ==# 'cpp' || &filetype ==# 'cc'
    let c_space_errors = 1
endif


"############################################################ TMUX SPECIFIC #################################################################"
" allows cursor change in tmux mode
if exists('$TMUX')
    let &t_SI = "\<Esc>Ptmux;\<Esc>\<Esc>]50;CursorShape=1\x7\<Esc>\\"
    let &t_EI = "\<Esc>Ptmux;\<Esc>\<Esc>]50;CursorShape=0\x7\<Esc>\\"
else
    let &t_SI = "\<Esc>]50;CursorShape=1\x7"
    let &t_EI = "\<Esc>]50;CursorShape=0\x7"
endif

"############################################################ GVIM/gui SPECIFIC #################################################################"

if has('gui_running')
    " gvim specific settings here
    "set guioptions-=r                                                  " remove righthand scroll bars
    "set guioptions-=l                                                  " remove lefthand scroll bar
    "set guioptions-=m                                                  " remove menu bar
    "set guioptions-=T                                                  " remove tool bar
    "set guioptions-=b
    "set go+=m                                                          " display the menu bar
    set guipty                                                          " pseudo tty for :! command
    "set guitablabel
    set fillchars+=vert:│"
endif
