if !has('gui_running') && &term =~ '^\%(screen\|tmux\)'
  let &t_8f = "\<Esc>[38;2;%lu;%lu;%lum"
  let &t_8b = "\<Esc>[48;2;%lu;%lu;%lum"
endif

syntax on                           

highlight LineNr ctermfg=DarkGrey   
nnoremap <esc><esc> :noh<return>    
colorscheme Dracula

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