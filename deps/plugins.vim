if exists("g:plugs")
    let b:altvim_install_ls = "HOME=/tmp && yarn install --frozen-lockfile"

    " comments  
    Plug 'tpope/vim-commentary'
    " indent-line  
    Plug 'yggdroot/indentline'
    " search everything interface  
    Plug 'junegunn/fzf', { 'dir': '~/.fzf', 'do': './install --all' }
    Plug 'junegunn/fzf.vim'
    " language server protocol  
    Plug 'neoclide/coc.nvim', {'branch': 'release'}
    " Plug 'neoclide/coc-snippets', {'do': b:altvim_install_ls}
    " Plug 'neoclide/coc-json', {'do': b:altvim_install_ls}
    " language syntax  
    Plug 'sheerun/vim-polyglot'
    " show on the left panel code line status (added | modified | removed)
    Plug 'mhinz/vim-signify'

    " let $PATH=$old_path
endif
