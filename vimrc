
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
set title
"set relativenumber         											" set relative numbering
"set backup
"set backupext=.org
"set patchmode=.bak 
"set visualbell
"set noerrorbell

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
set modelines=0             											" read the first and last few lines of each file for ex  commands.

"TABS 
set tabstop=4               											" actual tab character =4 white spaces
set shiftwidth=4            											" indentation of 4 white space   s
set softtabstop=4           											" tab key will be combination of tab & space
set expandtab               											" will insert spaces instead of tabs character
set smarttab                											" insert insert tabs/spaces to go to next indent 

"WRAP
set wrap
set wrapmargin=0            											" turn off physical insertion of lines
set textwidth=100           											" automatically wrap after 150 cols
set colorcolumn=100
set formatoptions-=t

"INDENTATION
set autoindent
set smartindent
set copyindent
set cindent
set linebreak
if has('linebreak')
    set showbreak=↪\ 
endif
nnoremap <F6> gg=G                  									" Indent all file

"FOLDING
set foldmethod=indent          											" automatically fold based on indentation
set foldlevelstart=1           											" fold for all files
set foldlevel=12
set foldnestmax=12
"set foldcolumn=12
"set nofoldenable " don't fold by default"
nnoremap <space> za            										 " map space to toggle fold

"FORMAT OPRIONS
set formatoptions=qrn1
set formatoptions+=t
set encoding=utf-8          											" UTF-8 text encoding by default

"DISPLAY
set ruler                   											" display current cursor position in lower right corner
set cursorcolumn            											" highlite current column 
set cursorline             											    " highlite current row

set scrolloff=3             											" option determines the number of context lines you would like to see above and below the cursor.
"set list                   											" end of lines show as '$' and carriage returns usually show as '^M'
"set listchars=tab:▶\
"set listchars+=eol:$
"set listchars+=trail:◥
"set listchars+=nbsp:•
"set listchars+=extends:❯
"set listchars+=precedes:❮

"match ErrorMsg '\s\+$"

"WINDOW MANAGEMENT
if has('windows')
    set splitbelow                      								" open horizontal splits below current window
endif
if has('vertsplit')
    set splitright                     									" open vertical splits to the right of the current window
endif

"WINDOW NAVIGATION 
nnoremap <C-j> <C-w>j
nnoremap <C-k> <C-w>k
nnoremap <C-h> <C-w>h
nnoremap <C-l> <C-w>l

"STATUS LINE
"set statusline=%f         											    " path to the file
"set statusline+=\ -\      											    " separator
"set statusline+=%=        											    " switch to the right side
"set statusline+=FileType: 											    " label
"set statusline+=%y        											    " filetype of the file
"set statusline=%l         											    " current line
"set statusline+=%L        											    " total lines
set laststatus=2

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
set history=100
set undolevels=100
" Create undo-dir if it doesnot exist
if !isdirectory($HOME."/.vim/undo-dir")
    call mkdir($HOME."/.vim/undo-dir", "", 0700)
endif
set undodir=~/.vim/undo-dir
set undofile

" FINDING FILES
set path+=**                											" search in subfolder ; provide tab-completion  
set wildmenu                											" display all matching files when tab in bottom
set wildmode=list:longest,full
set wildignore=*.swp,*.bak,*.pyc,*.class,*.o        					" ignore following in wildmode

"SYSTEMVERILOG SYNTAX
syntax on
syntax enable
au BufNewFile,BufRead *.sv,*.vpp,*.svh,*.vh,*.v so ~/.vim/syntax/verilog_systemverilog.vim


" USE ONLY WHEN OPENING VERY LARGE FILES FOR VIEWING
set noswapfile                                                           " no swap files ; we are saving veru often anyways
"set nobackup                                                            " no backup files
"set nowritebackup                                                       " only in case you don't want a backup file while editing
"set noundofile                                                          " no undofile


"DISBALE KEYS
"noremap <Up> <NOP>
"noremap <Down> <NOP>
"noremap <Left> <NOP>
"noremap <Right> <NOP>
"nnoremap j gj
"nnoremap k gk

"DISABLE HELP
"inoremap <F1> <ESC>
"nnoremap <F1> <ESC>
"vnoremap <F1> <ESC>

inoremap ( ()<Esc>i
inoremap < <><Esc>i
inoremap { {}<Esc>i

" HIGHLIGHTS
"hi MatchParen cterm=bold ctermbg=none ctermfg=Red                      " hls clr
hi Search ctermbg=LightYellow
hi Search ctermfg=Red
highlight ExtraWhitespace ctermbg=darkgreen guibg=lightgreen
highlight CursorLine guibg=lightblue ctermbg=lightgray
highlight CursorLineNr term=bold guibg=#eee9d4
highlight Comment cterm=italic gui=italic
"highlight Normal guibg=lightyellow 
"highlight Normal guibg=grey90
"highlight Cursor guibg=Green guifg=NONE
"highlight NonText guibg=grey80
"highlight Constant gui=NONE guibg=grey95
"highlight Special gui=NONE guibg=grey95

"SYNTAX HIGHLIGHTING FOR TRACE FILES
au BufRead,BufNewFile *.trc so ~/trc.vim




"##################################PLUGINS####################################
"VUNDLE

nmap  :TagbarToggle

filetype off
set rtp+=~/.vim/bundle/Vundle.vim           							" set the runtime path to include Vundle and initialize
call vundle#begin()         		    							    " a path where Vundle should install plugins
Plugin 'VundleVim/Vundle.vim'               							" let Vundle manage Vundle, required
Plugin 'scrooloose/nerdtree'
Plugin 'Xuyuanp/nerdtree-git-plugin'
Plugin 'godlygeek/tabular.git'
Plugin 'majutsushi/tagbar'
Plugin 'kien/ctrlp.vim'
Plugin 'scrooloose/syntastic'
Plugin 'nathanaelkane/vim-indent-guides'
Plugin 'Rykka/riv.vim'

"NERDTree
let NERDTreeQuitOnOpen=0
"let g:NERDTreeDirArrowExpandable = '▸'
"let g:NERDTreeDirArrowCollapsible = '▾'
let NERDTreeMinimalUI = 1
let NERDTreeDirArrows = 1
let NERDTreeAutoDeleteBuffer = 1
"autocmd vimentre * NERDTree

"Tagbar
let g:tagbar_ctags_bin = "ctags"
let g:tagbar_show_visibility = 1
let g:tagbar_autofocus = 0

"Syntastic
set statusline+=%#warningmsg#
set statusline+=%{SyntasticStatuslineFlag()}
set statusline+=%*

let g:syntastic_always_populate_loc_list = 1
let g:syntastic_auto_loc_list = 1
let g:syntastic_check_on_open = 1
let g:syntastic_check_on_wq = 0

call vundle#end()            " required

"COLORSCHEME
"colorscheme solarized
"colorscheme default

" call  "filetype plugin on" after pulgins are done
"ENABLE FILETYPES
filetype on
filetype plugin on
filetype indent on          											" automatic, language-dependent indentation, syntax coloring and other functionality
let do_syntax_sel_menu=1

if &filetype ==# 'c' || &filetype ==# 'cpp' || &filetype ==# 'cc' 
    let c_space_errors = 1
endif

"############################################################ GVIM SPECIFIC #################################################################"

if has('gui_running')
    " gvim specific settings here
    set guioptions-=r " remove the scroll bars
    set guioptions-=l
    set guioptions-=b"
    "set fillchars+=vert:│"
endif

