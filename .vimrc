let mapleader = "\<Space>"
"
set nocompatible

"" Auto install
if empty(glob('~/.vim/autoload/plug.vim'))
  silent !curl -fLo ~/.vim/autoload/plug.vim --create-dirs
        \ https://raw.githubusercontent.com/junegunn/vim-plug/master/plug.vim
  autocmd VimEnter * PlugInstall --sync | source $MYVIMRC
endif


call plug#begin('~/.vim/bundle')
Plug 'https://github.com/altercation/vim-colors-solarized'
Plug 'https://github.com/scrooloose/nerdcommenter'
Plug 'https://github.com/scrooloose/nerdtree'
Plug 'https://github.com/junegunn/fzf.vim' " FZF keybindings
Plug 'qpkorr/vim-bufkill'
"Plug 'https://github.com/vim-scripts/taglist.vim'
Plug 'https://github.com/brooth/far.vim'
Plug 'https://github.com/tpope/vim-fugitive'
Plug 'https://github.com/itchyny/lightline.vim'
Plug 'neoclide/coc.nvim', {'branch': 'release'}

call plug#end()

"Setup common coc plugins
if empty(glob('~/.config/coc/extensions/node_modules/coc-clangd'))
  autocmd VimEnter * CocInstall coc-clangd
  autocmd VimEnter * CocCommand clangd.install
  autocmd VimEnter * CocInstall coc-json
  autocmd VimEnter * CocInstall coc-python
  autocmd VimEnter * CocInstall coc-sh
endif

"LSP / coc.nvim OPTIONS"
" Use tab for trigger completion with characters ahead and navigate.

" Used to check if normal tab should be inserted, rather than triggering autocomplete.
function! CheckBackspace() abort
  let col = col('.') - 1
  return !col || getline('.')[col - 1]  =~# '\s'
endfunction

inoremap <silent><expr> <TAB>
      \ coc#pum#visible() ? coc#pum#next(1):
      \ CheckBackspace() ? "\<Tab>" :
      \ coc#refresh()
inoremap <expr><S-TAB> coc#pum#visible() ? coc#pum#prev(1) : "\<C-h>"

"" Highlight symbol under cursor on CursorHold
autocmd CursorMoved * silent call CocActionAsync('highlight')

"" Mapping for running a CodeAction
"nmap <silent> ma <Plug>(coc-codeaction-selected)<CR>

"" Mapping for GoTo Definition/Declaration
nmap <silent> <Leader>g <Plug>(coc-definition)

"" Mapping for Find References
"nmap <silent> mr <Plug>(coc-references)<CR>

"" Mapping for Rename
"nmap <silent> mR <Plug>(coc-rename)

"" Mapping for showing Implementation of Interface
"nmap <silent> mi <Plug>(coc-implementation)

"" Mapping for Type Definition
nmap <silent> <Leader>t <Plug>(coc-type-definition)



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
nmap <silent> <C-p> :Files ~/driving/<CR>
nmap <silent> <C-]> :Buffers<CR>

"Lightline OPTIONS
set laststatus=2 "always show the status line (vim option)
" Requires fugitive to also be installed
let g:lightline = {
      \ 'colorscheme': 'solarized',
      \ 'active': {
      \   'left': [ [ 'paste' ],
      \             [ 'gitbranch', 'readonly', 'filename', 'modified' ] ]
      \ },
      \ 'component_function': {
      \   'gitbranch': 'fugitive#head'
      \ },
      \ }

"Fugutive OPTIONS
nmap <silent> <leader>q :cnext<CR>
nmap <silent> <leader>p :cprev<CR>


" Custom Functions

command Black !black -l 120 %:p

function! NumberToggle()
	if(&relativenumber == 1)
		set norelativenumber
	else
		set relativenumber
	endif
endfunc
" use leader n to toggle the line number counting method
nnoremap <silent> <Leader>n :call NumberToggle()<cr>

function! s:gotobuild() abort
    let l:file_path=@%  
    let l:file_name=split(l:file_path, '/')[-1]
    let l:file_directory=trim(system('dirname ' . l:file_path))          
    let l:worktree=trim(system("git -C " . l:file_directory . " rev-parse --show-toplevel"))
    if l:worktree =~ "fatal: not a git repository"
      echo "Doing nothing, not in a git repository"
      return            
    endif               
    " Use ripgrep if available
    if trim(system('which rg')) != ''
      let l:command='rg ' . l:file_name . ' --glob "BUILD" --vimgrep ' . l:worktree
    else                
      let l:command='grep -r ' . l:file_name . ' ' . l:worktree . ' -n --include "BUILD"'
    endif               
    let l:result=trim(system(l:command))
    if l:result == ""   
      echo 'No corresponding BUILD file found'
    else                
      let l:result_list=split(l:result, ':')
      let l:build_file_name=l:result_list[0]
      let l:build_file_line=l:result_list[1]
      execute 'edit +' . l:build_file_line l:build_file_name
      execute 'normal! zz'
    endif               
endfunction             
"command! -complete=command GOTOBuild call <SID>gotobuild()
"nnoremap <silent> <Leader>b :GOTOBuild<CR>

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
set noswapfile


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

autocmd FileType json syntax match Comment +\/\/.\+$+

"set path to directory of current file
autocmd BufEnter * silent! lcd %:p:h

"turn on rnu when entering a buffer
autocmd BufEnter * set relativenumber	

" disable auto commenting
autocmd FileType * setlocal formatoptions-=c formatoptions-=r formatoptions-=o

" Save window view when changing between buffers
autocmd! BufWinLeave * let b:winview = winsaveview()
autocmd! BufWinEnter * if exists('b:winview') | call winrestview(b:winview) | unlet b:winview

" Run TRI cpp formatter on save
autocmd BufWritePost *.{cc,h} execute 'silent !~/driving/src/clang_format.sh %:p' | edit

" map for ctags next/prev options
nnoremap <Leader>] :tnext<CR>
nnoremap <Leader>[ :tprev<CR>

" move vertically by visual line
nnoremap <silent> j gj
nnoremap <silent> k gk

" map ctrl h/l to change buffers
nmap <silent> <C-h> :bp<CR>
nmap <silent> <C-l> :bn<CR>

"bubble single lines
nmap <C-k> ddkP
nmap <C-j> ddp
"bubble multiple lines
vmap <C-k> xkP`[V`]
vmap <C-j> xp`[V`]

" remap esc
imap jj <Esc>

" leader o to open a new buffer with nerdtree
nmap <silent> <Leader>o :NERDTree <CR>

"leader h turns off highlighting
:map <silent> <Leader>h :noh<CR>

"leader d shows current dir
:map <silent> <Leader>d :!pwd<CR>

"Leader s starts find/replace on word under cursor
:nnoremap <Leader>s :%s/<C-r><C-w>/

" Leader j swaps between header and src file (*.h, *.cc, must be in same directory)
:map <silent> <Leader>j :e %:p:s,.h$,.X123X,:s,.cc$,.h,:s,.X123X$,.cc,<CR>
