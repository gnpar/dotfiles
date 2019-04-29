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

" PEP-8 checking
" Requires flake8:
"     sudo apt-get install flake8
Plugin 'nvie/vim-flake8'

" Pretty statusline
Plugin 'vim-airline/vim-airline'

" Useful bracket mappings (e.g.: ]l for next syntax error)
Plugin 'tpope/vim-unimpaired'

" ##### END PLUGINS   #####
call vundle#end()

filetype plugin indent on

" General config
set tabstop=4 shiftwidth=4 expandtab
set mouse=

set encoding=utf-8

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
    \ set textwidth=79 |
    \ set colorcolumn=80 |
    \ set expandtab | 
    \ set autoindent |
    \ set fileformat=unix
let python_highlight_all=1
let g:syntastic_always_populate_loc_list = 1
let g:syntastic_auto_loc_list = 1
let g:syntastic_check_on_open = 1
let g:syntastic_check_on_wq = 0


" C Programming
au BufRead,BufNewFile *.h,*.c setlocal cindent textwidth=120 colorcolumn=120 formatoptions+=t

" yml (ansible) and html
au BufRead,BufNewFile *.yml,*.yaml,*.html setlocal tabstop=2 shiftwidth=2
