silent !stty -ixon

" [Base VIM settings]

" disable back-compatibility with Vi
set nocompatible

" enable auto filetype determination 
" and autoloading appropriated plugins for the filetype
filetype plugin indent on

" syntax highlighting
syntax enable

" permanent insert mode by default
set insertmode

set encoding=utf-8

" indentations
set autoindent expandtab copyindent shiftround shiftwidth=4
set smartindent smarttab softtabstop=4 breakindent

" text wrap
set wrap linebreak breakindent nolist showbreak=\ \ \ 

" search
set hlsearch incsearch ignorecase smartcase

" tweaks
set hidden ttyfast undolevels=500 history=500 backspace=indent,eol,start
set lazyredraw title autoread noswapfile nobackup nowritebackup
set clipboard=unnamedplus updatetime=300 updatecount=100 regexpengine=1 autoread 

" UI
set t_Co=256 number numberwidth=4 showcmd noshowmode nomodeline laststatus=2
set cursorline cmdheight=1 scrolloff=2 showtabline=0 signcolumn=yes
set display=lastline termguicolors guicursor=a:block-blinkoff0

" enable brace matching and for tags
set showmatch matchpairs+=<:>

" command line
set wildmenu wildmode=longest:full,full

" diff
set diffopt=filler diffopt+=iwhite

" autocomplete
" set completeopt=menu,menuone,noinsert,noselect
set omnifunc=syntaxcomplete#Complete
set shortmess+=c

set statusline=%#StatusLineNC#%m%r\ %.60F\ %y\ %{&fenc}%=Col:\ %c\ \|\ Line:\ %l/%L

let mapleader="\\"


" [StartUp]

" disable netrw directory listing on startup
let loaded_netrw = 0
" Show file search after start on directory
autocmd VimEnter * nested
            \ if argc() == 1 && isdirectory(argv()[0])
            \ | sleep 100m
            \ | exe "call fzf#vim#files(
            \   (argv()[0] == getcwd()) ? getcwd() : getcwd() . '/' . argv()[0],
            \   {'options' : ['--preview', 'head -40 {}'], 'down': '100%'})"
            \ | endif 

" FZF tweak
autocmd! FileType fzf exe 'set laststatus=0 | IndentLinesToggle'
    \| autocmd BufLeave <buffer> exe 'set laststatus=2 | IndentLinesToggle'

" language specific tab
autocmd FileType javascript setlocal shiftwidth=2 softtabstop=2 showbreak=↳\ 
autocmd FileType css setlocal shiftwidth=2 softtabstop=2 showbreak=↳\ 
autocmd FileType html setlocal shiftwidth=2 softtabstop=2 showbreak=↳\ 
autocmd FileType markdown setlocal shiftwidth=2 softtabstop=2 showbreak=↳\ 


" [Commands]
" run fzf-file-search in a current directory
command! -bang ProjectFiles
    \ call fzf#vim#files(
    \   (argv()[0] == getcwd()) 
    \       ? getcwd() 
    \       : (isdirectory(argv()[0])
    \           ? getcwd() . '/' . argv()[0]
    \           : fnamemodify(getcwd() . '/' . argv()[0], ':h')),
    \   {'options' : ['--preview', 'head -10 {}']},
    \   <bang>0
    \ )

command! -nargs=1 SetHotkey call altvim#set_hotkey(<f-args>)

command! -nargs=0 OpenInBrowser !google-chrome %


" [Configurations]
if exists("g:plugs")
    let g:altvim_plugin_dir = g:plugs['altvim'].dir
    let g:altvim_defined_plugins = keys(g:plugs)
    let g:altvim_installed_plugins = filter(keys(g:plugs), 'isdirectory(g:plugs[v:val].dir)')
    function! altvim#install_plugins() abort
        PlugInstall --sync
    endfunction
endif

" when vim startup auto install altvim plugins if its were not installed
if len(g:altvim_defined_plugins) != len(g:altvim_installed_plugins)
    nohl | call altvim#install_plugins() | bdelete | source $MYVIMRC
endif

" indent-line
let g:indentLine_fileTypeExclude = ['markdown']

" setting up fzf
let g:fzf_layout = {'down': '60%'}

" setting up lsp
let g:coc_data_home = g:altvim_plugin_dir . 'deps/lsp'
let g:coc_config_home = g:altvim_plugin_dir . 'deps/lsp/config'

if exists("g:altvim_node_path")
    let g:coc_node_path = g:altvim_node_path
endif

let b:altvim_coc_user_config = {
    \ "diagnostic.refreshOnInsertMode": v:true,
    \ "diagnostic.refreshAfterSave": v:true,
    \ "diagnostic.messageTarget": "echo",
    \ "diagnostic.virtualText": v:true,
    \ "diagnostic.enableMessage": "always",
    \ "diagnostic.locationList": v:false,
    \ "diagnostic.enableSign": v:true,
    \ "diagnostic.errorSign": "●",
    \ "diagnostic.warningSign": "●",
    \ "diagnostic.infoSign": "●",
    \ "diagnostic.hintSign": "●",
    \ "suggest.noselect": v:false,
    \ "suggest.minTriggerInputLength": 2,
    \ "suggest.timeout": 3000,
    \ "suggest.snippetIndicator": "►",
    \ "suggest.maxCompleteItemCount": 12,
    \ "suggest.enablePreview": v:false,
    \ "suggest.floatEnable": v:false,
    \ "snippets.userSnippetsDirectory": g:altvim_plugin_dir . 'snippets',
    \ "snippets.extends": {
    \   "javascriptreact": ["javascript"],
    \ },
    \ "signature.target": "echo",
    \ "emmet.showExpandedAbbreviation": v:false,
    \ "coc.preferences.hoverTarget": "echo",
    \ "coc.preferences.extensionUpdateCheck": "never"
\ }

if exists("g:coc_user_config")
    let g:coc_user_config = extend(
        \ b:altvim_coc_user_config,
        \ g:coc_user_config
        \)
endif

" [Editor]
SetHotkey <M-`> = :
SetHotkey <C-s> = call altvim#save()
SetHotkey <C-q> = call altvim#quit()
SetHotkey <C-w> = call altvim#close_file()

" [Navigation]
SetHotkey <M-/> = call altvim#go_to_specific_place(),
    \ call altvim#select_to_specific_place()
SetHotkey <M-right> = call altvim#find_specific_place('next'),
    \ call altvim#select_to_found_specific_place('next')
SetHotkey <M-left> = call altvim#find_specific_place('prev'),
    \ call altvim#select_to_found_specific_place('prev')
SetHotkey <M-.> = call altvim#go_to_block('next'), call altvim#select_to_block('next')
SetHotkey <M-,> = call altvim#go_to_block('prev'), call altvim#select_to_block('prev')
SetHotkey <M-p> = call altvim#go_to_paired(), call altvim#select_to_paired()
SetHotkey <M-w> = call altvim#go_to_occurrence('next')
SetHotkey <M-e> = call altvim#go_to_occurrence('prev')
SetHotkey <C-right> = call altvim#go_to_word('next')
SetHotkey <C-left> = call altvim#go_to_word('prev')
SetHotkey <M-BS> = call altvim#go_to_last_change()
SetHotkey <C-up> = call altvim#go_to_line('begin')
SetHotkey <C-down> = call altvim#go_to_line('end')

" [Selection]
SetHotkey <M-b> = call altvim#select_rectangular()
SetHotkey <C-S-right> = call altvim#select_to_word('next')
SetHotkey <C-S-left> = call altvim#select_to_word('prev')
SetHotkey <M-s> = call altvim#select_last_selection()
SetHotkey <C-a> = call altvim#select_all() 
SetHotkey <M-C-right> = call altvim#select_till_char('next')
SetHotkey <M-C-left> = call altvim#select_till_char('prev')
SetHotkey <S-down> = call altvim#select_line('next')
SetHotkey <S-up> = call altvim#select_line('prev')
SetHotkey <S-right> = call altvim#select_char('next')
SetHotkey <S-left> = call altvim#select_char('prev')
SetHotkey <C-S-up> = call altvim#select_till_line('begin')
SetHotkey <C-S-down> = call altvim#select_till_line('end')
SetHotkey ) = _, call altvim#select_scope( 'parentheses')
SetHotkey } = _, call altvim#select_scope('braces')
SetHotkey ] = _, call altvim#select_scope('square_brackets')
SetHotkey t = _, call altvim#select_scope('tag_content')
SetHotkey > = _, call altvim#select_scope('tag')
SetHotkey ' = _, call altvim#select_scope('single_quotes')
SetHotkey " = _, call altvim#select_scope('double_quotes')
SetHotkey ` = _, call altvim#select_scope('back_quotes')
SetHotkey w = _, call altvim#select_scope('word')

" [Editing]
SetHotkey <C-d> = call altvim#delete_line()
SetHotkey <BS> = _, call altvim#delete()
SetHotkey <Space> = _, call altvim#delete()
SetHotkey <C-z> = call altvim#undo()
SetHotkey <M-z> = call altvim#redo()
SetHotkey <C-v> = call altvim#paste()
SetHotkey <M-v> = call altvim#multiclipboard()
SetHotkey <C-c> = call altvim#copy()
SetHotkey <C-x> = call altvim#cut()
SetHotkey <C-l> = call altvim#clone_line()
SetHotkey <C-j> = call altvim#join_lines()
SetHotkey <Tab> = _, call altvim#indent()
SetHotkey <S-Tab> = _, call altvim#outdent()

SetHotkey <C-h> = call altvim#replace()
SetHotkey <M-h> = call altvim#replace_all()

" [Plugins]
SetHotkey <C-b> = call altvim#format()
SetHotkey <C-e> = call altvim#show_problems()
SetHotkey <M-1> = call altvim#find_project_files()
SetHotkey <M-2> = call altvim#show_open_files()
SetHotkey <M-f> = call altvim#find_in_project_files()
SetHotkey <M-r> = call altvim#show_recent_files()
SetHotkey <C-f> = call altvim#find_in_file()
SetHotkey <C-_> = call altvim#toggle_comment()
