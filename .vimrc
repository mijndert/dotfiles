" Enable true colors for terminals that support it
if !has('gui_running') && &term =~ '^\%(screen\|tmux\)'
  let &t_8f = "\<Esc>[38;2;%lu;%lu;%lum"
  let &t_8b = "\<Esc>[48;2;%lu;%lu;%lum"
endif

" vim-plug
call plug#begin('~/.vim/plugged')

" Catppuccin theme
Plug 'catppuccin/vim', { 'as': 'catppuccin' }

" FZF 
Plug 'junegunn/fzf', { 'do': { -> fzf#install() } }
Plug 'junegunn/fzf.vim'

" NERDTree for a file tree
Plug 'preservim/nerdtree'

" Terraform plugin
Plug 'hashivim/vim-terraform'

" Add the vim-commentary plugin
Plug 'tpope/vim-commentary'

call plug#end()

" Set the Catppuccin Mocha theme
colorscheme catppuccin_mocha

" Enable syntax highlighting
syntax on

" NERDTree configuration
" Open NERDTree automatically when vim starts and no file is specified
autocmd StdinReadPre * let s:std_in=1
autocmd VimEnter * if argc() == 0 && !exists("s:std_in") | NERDTree | endif

" Close vim if NERDTree is the only window left
autocmd BufEnter * if tabpagenr('$') == 1 && winnr('$') == 1 && exists('b:NERDTree') | q | endif

" Map <C-n> to toggle NERDTree
nnoremap <C-n> :NERDTreeToggle<CR>

" Enable mouse mode
set mouse=a

" Settings from previous vimrc
nnoremap <esc><esc> :noh<return>
set tabstop=2
set shiftwidth=2
set expandtab
set ai
set number
set hlsearch
set ruler
set backspace=2
set wildmenu
set path=$PWD/**
set wildmode=longest:list,full
set pastetoggle=<leader>p
set nuw=3
set noswapfile
set clipboard=unnamed
set termguicolors

" VSCode-like key bindings
" Save with Ctrl+S
nnoremap <C-s> :w<CR>
inoremap <C-s> <Esc>:w<CR>a

" Find in files with Ctrl+Shift+F
nnoremap <C-S-f> :Rg<CR>

" Comment lines with Ctrl+/
nnoremap <C-/> :Commentary<CR>
vnoremap <C-/> :Commentary<CR>

" Navigate between splits with Ctrl+H/J/K/L
nnoremap <C-h> <C-w>h
nnoremap <C-j> <C-w>j
nnoremap <C-k> <C-w>k
nnoremap <C-l> <C-w>l

" Open fzf with C-f 
nnoremap <C-f> :Files<CR>
