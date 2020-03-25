" add nodejs bin to $PATH if needed
if stridx($PATH, 'node') < 0
    let $PATH=$PATH . ':' . g:plugs['altvim'].dir . 'deps/nodejs/bin'
endif

let b:coc_ext_post_install_cmd="HOME=/tmp && yarn install --frozen-lockfile"

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
    Plug 'marlonfan/coc-phpls', {'do': b:coc_ext_post_install_cmd}
    Plug 'neoclide/coc-tsserver', {'do': b:coc_ext_post_install_cmd}
    Plug 'neoclide/coc-emmet', {'do': b:coc_ext_post_install_cmd}
    Plug 'neoclide/coc-eslint', {'do': b:coc_ext_post_install_cmd}
    Plug 'neoclide/coc-css', {'do': b:coc_ext_post_install_cmd}
    Plug 'neoclide/coc-json', {'do': b:coc_ext_post_install_cmd}
    Plug 'neoclide/coc-rls', {'do': b:coc_ext_post_install_cmd}
    Plug 'neoclide/coc-snippets', {'do': b:coc_ext_post_install_cmd}
    " language syntax  
    Plug 'sheerun/vim-polyglot'
    " show on the left panel code line status (added | modified | removed)
    Plug 'mhinz/vim-signify'
endif
