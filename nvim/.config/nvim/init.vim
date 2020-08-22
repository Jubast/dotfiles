call plug#begin()

Plug 'preservim/nerdtree'
Plug 'altercation/vim-colors-solarized'
Plug 'neoclide/coc.nvim', {'branch': 'release'}
Plug 'vim-airline/vim-airline'

call plug#end()

syntax enable
set background=dark
colorscheme solarized

set relativenumber
set expandtab
set softtabstop=4
set shiftwidth=4

" NerdTree
autocmd vimenter * NERDTree
nmap <A-1> :NERDTreeToggle<CR>

" Coc
runtime coc.vim
