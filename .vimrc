" Vundle config (from
" https://realpython.com/vim-and-python-a-match-made-in-heaven/)
set nocompatible
filetype off

" This config uses Vundle for plugin management
" To get started, install Vundle:
"     git clone https://github.com/gmarik/Vundle.vim.git ~/.vim/bundle/Vundle.vim
" Fire up VIM and run :PluginInstall
" Be sure to check the plugin list below for additional dependencies

set rtp+=~/.vim/bundle/Vundle.vim
call vundle#begin()
Plugin 'gmarik/Vundle.vim'

" ##### BEGIN PLUGINS #####
Plugin 'vim-scripts/indentpython.vim'

" Syntax check on each save
Plugin 'vim-syntastic/syntastic'

" Python autocomplete
" Requires `jedi` to be installed: cd ~/.vim/bundle/jedi-vim/ && git submodule update --init --recursive
Plugin 'davidhalter/jedi-vim'

" PEP-8 checking
" Requires flake8:
"     sudo apt-get install flake8
Plugin 'nvie/vim-flake8'

" REPL for python and others
Plugin 'sillybun/vim-repl'

" Pretty statusline
Plugin 'vim-airline/vim-airline'

" Useful bracket mappings (e.g.: ]l for next syntax error)
Plugin 'tpope/vim-unimpaired'

" Fugitive (Git)
Plugin 'tpope/vim-fugitive'

" Ack for searching. Requires silversearcher-ag (or ack) to be installed
Plugin 'mileszs/ack.vim'

" Fzf. Requires fzf to be installed. The rtp is set for git install:
"   git clone --depth 1 https://github.com/junegunn/fzf.git ~/.fzf && ~/.fzf/install
set rtp+=~/.fzf
Plugin 'junegunn/fzf.vim'

" Conque-shell
Plugin 'wkentaro/conque.vim'

" ##### END PLUGINS   #####
call vundle#end()

filetype plugin indent on

" General config
set tabstop=4 shiftwidth=4 expandtab
set mouse=

set encoding=utf-8

" Mappings
nnoremap gf <C-W>gf
vnoremap gf <C-W>gf

" Ack config
if executable('ag')
  let g:ackprg = 'ag --vimgrep'
endif

" #### PROGRAMMING SETTINGS ####

syntax on

" Folding
set foldmethod=indent
set foldlevel=99

" Bad whitespace
au BufRead, BufNewFile *.py, *pyw, *.c, *.h match BadWhitespace /\s\+$/

" Python programming
au BufNewFile,BufRead *.py
    \ set tabstop=4 |
    \ set softtabstop=4 |
    \ set shiftwidth=4 |
    \ set textwidth=119 |
    \ set colorcolumn=120 |
    \ set expandtab | 
    \ set autoindent |
    \ set fileformat=unix
autocmd FileType python setlocal indentkeys-=<:>
let python_highlight_all=1
let g:syntastic_always_populate_loc_list = 1
let g:syntastic_loc_list_height = 2
let g:syntastic_auto_loc_list = 1
let g:syntastic_check_on_open = 1
let g:syntastic_check_on_wq = 0
let g:syntastic_loc_list_height = 2

" By default use system python (not current virtualenv)
let g:syntastic_python_flake8_exec = '/usr/bin/python'
let g:syntastic_python_flake8_args = ['-m', 'flake8', '--ignore=E731,E126,E127,E128', '--max-line-length=120']

function Py2()
  let g:syntastic_python_python_exec = 'python2'
  let g:syntastic_python_flake8_exec = '/usr/bin/python2'
  SyntasticCheck
endfunction

function Py3()
  let g:syntastic_python_python_exec = 'python3'
  let g:syntastic_python_flake8_exec = '/usr/bin/python3'
  SyntasticCheck
endfunction

autocmd FileType python setlocal completeopt-=preview
let g:jedi#use_tabs_not_buffers = 1
let g:jedi#popup_on_dot = 0
set noshowmode  " call signatures on vim command line don't work with showmode on
let g:jedi#show_call_signatures = 2

let g:repl_program = {
			\	'python': ['ipython'],
			\	'default': ['bash']
			\	}
let g:repl_position = 3
nnoremap <leader>i :REPLToggle<Cr>
tnoremap <C-n> <C-w>N
tnoremap <ScrollWheelUp> <C-w>Nk
tnoremap <ScrollWheelDown> <C-w>Nj

" C Programming
au BufRead,BufNewFile *.h,*.c setlocal cindent textwidth=120 colorcolumn=120 formatoptions+=t

" yml (ansible) and html
au BufRead,BufNewFile *.yml,*.yaml,*.html setlocal tabstop=2 shiftwidth=2

" javascript
au BufRead,BufNewFile *.js,*.json setlocal tabstop=2 shiftwidth=2
let g:syntastic_javascript_checkers = ["standard"]
let g:syntastic_javascript_standard_exec = "semistandard"

" shell
nnoremap <leader>b :ConqueTermVSplit bash<Cr>
nnoremap <leader>hb :ConqueTermSplit bash<Cr>

 
" Sane auto-completion
set wildmode=longest,list,full
set wildmenu
