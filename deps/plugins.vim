if exists("g:plugs")
    " surround smth in smth, i.e. test to (test)
    Plug 'tpope/vim-surround'
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
