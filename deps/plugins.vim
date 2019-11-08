if exists("g:plugs")
    " surround smth in smth, i.e. test to (test)
    Plug 'tpope/vim-surround'
    " auto-pairs  
    Plug 'jiangmiao/auto-pairs'
    " comments  
    Plug 'tpope/vim-commentary'
    " indent-line  
    Plug 'yggdroot/indentline'
    " status line  
    Plug 'itchyny/lightline.vim'
    " search everything interface  
    Plug 'junegunn/fzf', { 'dir': '~/.fzf', 'do': './install --all' }
    Plug 'junegunn/fzf.vim'
    " language server protocol  
    Plug 'neoclide/coc.nvim', {'branch': 'release'}
    " language syntax  
    Plug 'sheerun/vim-polyglot'
    " emmet  
    Plug 'mattn/emmet-vim'
    " git  
    Plug 'tpope/vim-fugitive'
    " show on the left panel code line status (added | modified | removed)
    Plug 'mhinz/vim-signify'
endif

if exists("g:vundle#bundle_dir")
    " surround smth in smth, i.e. test to (test)
    Plugin 'tpope/vim-surround'
    " auto-pairs  
    Plugin 'jiangmiao/auto-pairs'
    " comments  
    Plugin 'tpope/vim-commentary'
    " indent-line  
    Plugin 'yggdroot/indentline'
    " status line  
    Plugin 'itchyny/lightline.vim'
    " search everything interface  
    Plugin 'junegunn/fzf', { 'dir': '~/.fzf', 'do': './install --all' }
    Plugin 'junegunn/fzf.vim'
    " language server protocol  
    Plugin 'neoclide/coc.nvim', {'branch': 'release'}
    " language syntax  
    Plugin 'sheerun/vim-polyglot'
    " emmet  
    Plugin 'mattn/emmet-vim'
    " git  
    Plugin 'tpope/vim-fugitive'
    " show on the left panel code line status (added | modified | removed)
    Plugin 'mhinz/vim-signify'
endif
