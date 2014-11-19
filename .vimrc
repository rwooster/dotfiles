let mapleader = "\<Space>"

set nocompatible
filetype off

set rtp+=~/.vim/bundle/Vundle.vim
call vundle#begin()

Plugin 'gmarik/Vundle.vim'
Plugin 'https://github.com/zeis/vim-kolor'
Plugin 'https://github.com/scrooloose/nerdtree'
Plugin 'https://github.com/Valloric/YouCompleteMe'

call vundle#end()


"Enable filetypes
filetype plugin indent on
syntax on			"turn on syntax highliting

let g:ycm_global_ycm_extra_conf = '~/.ycm_extra_conf.py'

set autoindent
set smarttab
set cindent 	"c style indenting
set nobackup	"stop vim from creating backup files
set wildmenu	"nicer menu for autocompleting commands
set showmatch	"match parens, brackets, etc
set tabstop=4	"number of visual spaces per tab
set shiftwidth=4	"control tab length with << >> and c style indent
set softtabstop=4	"how many columns for using tab in insert mode
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

set t_Co=256
color kolor 
hi Normal ctermbg=None
hi NonText ctermbg=None

"set path to directory of current file
autocmd BufEnter * silent! lcd %:p:h

"turn on rnu when entering a buffer
autocmd BufEnter * set relativenumber	

" disable auto commenting
autocmd FileType * setlocal formatoptions-=c formatoptions-=r formatoptions-=o

" move vertically by visual line
nnoremap j gj
nnoremap k gk

" map ctrl h/l to change buffers
nmap <silent> <C-h> :bp<return>
nmap <silent> <C-l> :bn<return>

"bubble single lines
nmap <C-k> ddkP
nmap <C-j> ddp
"bubble multiple lines
vmap <C-k> xkP`[V`]
vmap <C-j> xp`[V`]

" remove inconsistency b/w escape and ctrl c
vnoremap <C-c> <Esc>

" use leader n to toggle the line number counting method
function! NumberToggle()
	if(&relativenumber == 1)
		set number
	else
		set relativenumber
	endif
endfunc

nnoremap <silent> <Leader>n :call NumberToggle()<cr>

" leader o to open a new buffer with nerdtree
nmap <silent> <Leader>o :NERDTree <return>

"hightlight lines over 100 characters
highlight OverLength ctermbg=red ctermfg=white guibg=#592929
match OverLength /\%121v.\+/

"f5 saves all and builds
:map <F5> :wa<return> :make<return> 

" leader p turns the current character to an arrow then goes to next line
:map <Leader>p dhi-><Esc>j

" leader . turns the next 2 characters (->) to . then goes to next line
:map <Leader>. d2hi.<Esc>jhh

"leader h turns off highlighting
:map <silent> <Leader>h :noh<return>

"Leader s starts find/replace on word under cursor
:nnoremap <Leader>s :%s/<C-r><C-w>/
