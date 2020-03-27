" add nodejs bin to $PATH if needed
if stridx($PATH, 'node') < 0
    let $PATH=$PATH . ':' . g:plugs['altvim'].dir . 'deps/nodejs/bin'
endif

if exists("g:plugs")
    " comments  
    Plug 'tpope/vim-commentary'
    " indent-line  
    Plug 'yggdroot/indentline'
    " search everything interface  
    Plug 'junegunn/fzf', { 'dir': '~/.fzf', 'do': './install --all' }
    Plug 'junegunn/fzf.vim'
    " language server protocol  
    Plug 'neoclide/coc.nvim', {'branch': 'release'}
    " language syntax  
    Plug 'sheerun/vim-polyglot'
    " show on the left panel code line status (added | modified | removed)
    Plug 'mhinz/vim-signify'
endif
