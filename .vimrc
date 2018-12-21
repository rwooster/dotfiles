let mapleader = "\<Space>"

set nocompatible
filetype off

set rtp+=~/.vim/bundle/Vundle.vim
call vundle#begin()

Plugin 'gmarik/Vundle.vim'
Plugin 'https://github.com/altercation/vim-colors-solarized'
Plugin 'https://github.com/scrooloose/nerdcommenter'
Plugin 'https://github.com/scrooloose/nerdtree'
Plugin 'https://github.com/junegunn/fzf.vim' " FZF keybindings
Plugin 'qpkorr/vim-bufkill'
Plugin 'https://github.com/vim-scripts/taglist.vim'
Plugin 'https://github.com/brooth/far.vim'

Plugin 'Valloric/YouCompleteMe'

call vundle#end()

"Enable filetypes
filetype plugin indent on
syntax on			"turn on syntax highliting


" YouCompleteMe ----------------------------------------------------------- {{{

"let g:ycm_filetype_specific_completion_to_disable = {'erl':1, 'hrl':1}
"let g:ycm_confirm_extra_conf = 1
let g:ycm_add_preview_to_completeopt = 1
let g:ycm_autoclose_preview_window_after_completion = 0
let g:ycm_autoclose_preview_window_after_insertion = 1
"let g:ycm_seed_identifiers_with_syntax = 1
""let g:ycm_key_invoke_completion = '<C-q>'
"let g:ycm_show_diagnostics_ui = 0
"let g:ycm_enable_diagnostic_signs = 0
"let g:ycm_enable_diagnostic_highlighting = 0
"nmap <silent><Leader> cm :YcmForceCompileAndDiagnostics<CR>
let g:ycm_global_ycm_extra_conf = '~/.ycm_extra_conf.py'
let g:ycm_confirm_extra_conf = 0
let g:ycm_collect_identifiers_from_comments_and_strings = 1
let g:ycm_collect_identifiers_from_tags_files = 0 " Let YCM read tags from Ctags file
let g:ycm_use_ultisnips_completer = 1 " Default 1, just ensure
let g:ycm_seed_identifiers_with_syntax = 1 " Completion for programming language's keyword
let g:ycm_complete_in_comments = 1 " Completion in comments
let g:ycm_complete_in_strings = 1 " Completion in string
let g:ycm_always_populate_location_list = 1 " make it so location list is populated for :lnext and :lprevious
let g:ycm_key_list_select_completion = ['<TAB>', '<Down>']
let g:ycm_show_diagnostics_ui = 1

nnoremap <silent> <Leader>g :YcmCompleter GoTo<CR>
nnoremap <silent> <Leader>t :YcmCompleter GetType<CR>
nnoremap <silent> <Leader>f :YcmCompleter FixIt<CR>

let g:ycm_server_log_level = 'debug'

map <Leader>n :lnext <CR>

"
"let g:ycm_key_list_select_completion = ['<C-j>', '<Down>']
"let g:ycm_key_list_previous_completion = ['<C-k>', '<Up>']
"nnoremap <leader>jd :YcmCompleter GoTo<CR>

" }}}

"NERDTree OPTIONS
let NERDTreeQuitOnOpen=1

"Taglist OPTIONS
nnoremap <silent> <leader>l :TlistToggle<CR>
let Tlist_WinWidth = 45
let Tlist_Exit_OnlyWindow = 1
let Tlist_Show_One_File = 1
let Tlist_Close_On_Select = 1

"FZF OPTIONS
set rtp+=~/.fzf "Enable FZF in vim. Required by fzf.vim plugin
nmap <silent> <C-p> :Files ~/driving/<return>

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
set tabstop=2
set shiftwidth=2
set softtabstop=2
set nu				" default line numbers on
set rnu				"default relative line numbers to on
set incsearch           " search as characters are entered
set hlsearch            " highlight matches
set ignorecase			"case insensitive search
set smartcase
set hidden			"switch buffers w/o saving
set mousehide		"hide mouse while typing
set backspace=2		"fixes issue with backspace not working
set nostartofline	"stops cursor from moving to start of line on buffer switch
set cursorcolumn    "highlight line the cursor is on
set expandtab       "tab inserts spaces instead


"set 256 color mode
set t_Co=256

"set vim to search for tags file starting at the dir of file and moving up
set tags=./tags;

" TRI Specific tag files
set tags+=~/driving/src/tags
set tags+=~/tdl/tags

"set colorscheme
set background=dark
let g:solarized_termcolors=256
color solarized

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

" Save window view when changing between buffers
autocmd! BufWinLeave * let b:winview = winsaveview()
autocmd! BufWinEnter * if exists('b:winview') | call winrestview(b:winview) | unlet b:winview

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

nnoremap <silent> <Leader>n :call NumberToggle()<cr>

" remap esc
imap jj <Esc>

" leader o to open a new buffer with nerdtree
nmap <silent> <Leader>o :NERDTree <return>

"leader h turns off highlighting
:map <silent> <Leader>h :noh<return>

"leader d shows current dir
:map <silent> <Leader>d :!pwd<return>

"Leader s starts find/replace on word under cursor
:nnoremap <Leader>s :%s/<C-r><C-w>/
