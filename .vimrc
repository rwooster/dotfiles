let mapleader = "\<Space>"

set nocompatible
filetype off

set rtp+=~/.vim/bundle/Vundle.vim
call vundle#begin()

Plugin 'gmarik/Vundle.vim'
Plugin 'https://github.com/zeis/vim-kolor'
Plugin 'https://github.com/scrooloose/nerdcommenter'
Plugin 'https://github.com/scrooloose/nerdtree'
Plugin 'https://github.com/Shougo/neocomplete.vim'
Plugin 'https://github.com/kien/ctrlp.vim'
Plugin 'https://github.com/rbgrouleff/bclose.vim'
Plugin 'https://github.com/vim-scripts/taglist.vim'

call vundle#end()

"Enable filetypes
filetype plugin indent on
syntax on			"turn on syntax highliting

"NeoComplete OPTIONS
let g:acp_enableAtStartup = 0
" Use neocomplete.
let g:neocomplete#enable_at_startup = 1
" Use smartcase.
let g:neocomplete#enable_smart_case = 1
" Set minimum syntax keyword length.
let g:neocomplete#sources#syntax#min_keyword_length = 3
let g:neocomplete#lock_buffer_name_pattern = '\*ku\*'


" <TAB>: completion.
inoremap <expr><TAB>  pumvisible() ? "\<C-n>" :
	\ <SID>check_back_space() ? "\<TAB>" :
	\ neocomplete#start_manual_complete()
function! s:check_back_space() "{{{
let col = col('.') - 1
return !col || getline('.')[col - 1]  =~ '\s'
endfunction"}}}


"NERDTree OPTIONS
let NERDTreeQuitOnOpen=1

"Taglist OPTIONS
nnoremap <silent> <leader>t :TlistToggle<CR>
let Tlist_WinWidth = 45
let Tlist_Exit_OnlyWindow = 1
let Tlist_Show_One_File = 1
let Tlist_Close_On_Select = 1

" always show the status line
set laststatus=2

" a friendly, useful, and descriptive status line
set statusline=%t       "tail of the filename
set statusline+=[%{strlen(&fenc)?&fenc:'none'}, "file encoding
set statusline+=%{&ff}] "file format
set statusline+=%h      "help file flag
set statusline+=%m      "modified flag
set statusline+=%r      "read only flag
set statusline+=%y      "filetype
set statusline+=%=      "left/right separator
set statusline+=%c:%v,     "cursor column (actual,virtual - great with tabs)
set statusline+=%l/%L   "cursor line/total lines
set statusline+=\ %P    "percent through file

set completeopt-=preview "disable preview menu
set autoindent
set smarttab
set nobackup	"stop vim from creating backup files
set wildmenu	"nicer menu for autocompleting commands
set wildmode=longest,list "bash like tab completion on menu
set showmatch	"match parens, brackets, etc
set tabstop=4
set shiftwidth=4
set softtabstop=4
set nu				" default line numbers on
set rnu				"default relative line numbers to on
set incsearch           " search as characters are entered
set hlsearch            " highlight matches
set ignorecase			"case insensitive search
set smartcase
set autowrite		"save buffers before they are hidden
set hidden			"switch buffers w/o saving
set mousehide		"hide mouse while typing
set backspace=2		"fixes issue with backspace not working
set nostartofline	"stops cursor from moving to start of line on buffer switch

autocmd BufRead,BufNewFile *.py set expandtab
autocmd BufRead,BufNewFile *.json set expandtab
autocmd BufRead,BufNewFile *.sh set expandtab

"We use 2 space js 
autocmd Filetype javascript setlocal ts=2 sts=2 sw=2 expandtab
autocmd Filetype css setlocal ts=2 sts=2 sw=2 expandtab


"set 256 color mode
set t_Co=256

"set vim to search for tags file starting at the dir of file and moving up
set tags=./tags;

"set colorscheme
color kolor 

"set background color to transparent
hi Normal ctermbg=None
hi NonText ctermbg=None

"fix confusing brace highliting
highlight MatchParen ctermfg=None

"set path to directory of current file
autocmd BufEnter * silent! lcd %:p:h

"turn on rnu when entering a buffer
autocmd BufEnter * set relativenumber	

" disable auto commenting
autocmd FileType * setlocal formatoptions-=c formatoptions-=r formatoptions-=o

" map for ctags next/prev options
nnoremap <Leader>] :tnext<return>
nnoremap <Leader>[ :tprev<return>

" move vertically by visual line
nnoremap <silent> j gj
nnoremap <silent> k gk

" map ctrl h/l to change buffers
nmap <silent> <C-h> :bp<return>
nmap <silent> <C-l> :bn<return>

"bubble single lines
nmap <C-k> ddkP
nmap <C-j> ddp
"bubble multiple lines
vmap <C-k> xkP`[V`]
vmap <C-j> xp`[V`]

" use leader n to toggle the line number counting method
function! NumberToggle()
	if(&relativenumber == 1)
		set norelativenumber
	else
		set relativenumber
	endif
endfunc

" Delete all trailing whitespace
function! TrimWhiteSpace()
  %s/\s*$//
  ''
:endfunction
map <F2> :call TrimWhiteSpace()<CR>
map! <F2> :call TrimWhiteSpace()<CR>

nnoremap <silent> <Leader>n :call NumberToggle()<cr>

" remap esc
imap jj <Esc>

" leader o to open a new buffer with nerdtree
nmap <silent> <Leader>o :NERDTree <return>

"f5 saves all and builds
:map <F5> :wa<return> :make<return> 

" leader p turns the current character to an arrow then goes to next line
:map <Leader>p dhi-><Esc>j

" leader . turns the next 2 characters (->) to . then goes to next line
:map <Leader>. d2hi.<Esc>jhh

"leader h turns off highlighting
:map <silent> <Leader>h :noh<return>

"leader d shows current dir
:map <silent> <Leader>d :!pwd<return>

"Leader s starts find/replace on word under cursor
:nnoremap <Leader>s :%s/<C-r><C-w>/

"Leader b to close current buffer w/o closing window
:nnoremap <Leader>b :Bclose<return>
