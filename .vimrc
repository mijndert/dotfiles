set tabstop=2
set shiftwidth=2
set expandtab
set ai
set number
set hlsearch
set ruler
set backspace=2
set wildmenu
set nuw=3
set noswapfile
set paste

filetype plugin indent on
autocmd FileType yaml setlocal ts=2 sts=2 sw=2 expandtab

let g:dracula_colorterm = 0
let g:dracula_italic = 0

packadd! dracula
syntax enable
colorscheme dracula
