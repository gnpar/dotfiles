" Vundle config (from
" https://realpython.com/vim-and-python-a-match-made-in-heaven/)
set nocompatible
filetype off
set rtp+=~/.vim/bundle/Vundle.vim
call vundle#begin()
Plugin 'gmarik/Vundle.vim'
" ##### BEGIN PLUGINS #####
Plugin 'vim-scripts/indentpython.vim'

" Syntax check on each save
Plugin 'vim-syntastic/syntastic'

" PEP-8 checking
Plugin 'nvie/vim-flake8'

"Auto completion, check
"https://github.com/Valloric/YouCompleteMe#mac-os-x-super-quick-installation
"for installation instructions
"Plugin 'Valloric/YouCompleteMe'

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
    \ set textwidth=120 |
    \ set expandtab | 
    \ set autoindent |
    \ set fileformat=unix
let python_highlight_all=1

" C Programming
au BufRead,BufNewFile *.h,*.c setlocal cindent textwidth=120 colorcolumn=120 formatoptions+=t

" yml (ansible) and html
au BufRead,BufNewFile *.yml,*.yaml,*.html setlocal tabstop=2 shiftwidth=2
