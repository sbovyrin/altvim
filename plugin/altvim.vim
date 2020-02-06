" [Base VIM settings] 
" <=============I===o

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
set autoindent expandtab copyindent shiftround shiftwidth=4 smartindent smarttab softtabstop=4

" text wrap
set wrap linebreak breakindent nolist showbreak=↳\ \ \ 

" search
set hlsearch incsearch ignorecase smartcase

" tweaks
set hidden ttyfast undolevels=500 history=500 backspace=indent,eol,start lazyredraw title autoread noswapfile nobackup nowritebackup clipboard=unnamedplus updatetime=300 updatecount=100

" UI
set t_Co=256 number numberwidth=4 showcmd noshowmode nomodeline laststatus=2 cursorline cmdheight=1 scrolloff=2 showtabline=0 signcolumn=yes display=lastline termguicolors

" enable brace matching and for tags
set showmatch matchpairs+=<:>

" command line
set wildmenu wildmode=longest:full,full

" diff
set diffopt=filler diffopt+=iwhite

" autocomplete
" set completeopt=menu,menuone,noinsert,noselect
set omnifunc=syntaxcomplete#Complete

let mapleader="\\"


" o=I=====>
" [StartUp] 
" <=====I=o

" disable netrw directory listing on startup
let loaded_netrw = 0
" Show file search after start on directory
autocmd VimEnter * nested if argc() == 1 && isdirectory(argv()[0]) |
            \   sleep 100m |
            \   exe "call fzf#run({'sink': 'e', 'options': '--height 99% --reverse --multi'})" |
            \ endif 

" language specific tab
autocmd FileType javascript setlocal shiftwidth=2 softtabstop=2 showbreak=↳\ 
autocmd FileType css setlocal shiftwidth=2 softtabstop=2 showbreak=↳\ 
autocmd FileType html setlocal shiftwidth=2 softtabstop=2 showbreak=↳\ 
autocmd FileType markdown setlocal shiftwidth=2 softtabstop=2 showbreak=↳\ 


" o=I======>
" [Commands] 
" <======I=o
command! -nargs=1 SetHotkey call altvim#set_hotkey(<f-args>)
command! -nargs=1 ReplaceFound call altvim#replace_found(<f-args>)
command! -nargs=0 OpenInBrowser !google-chrome %

" o==I========>
" [Keybindings] 
" <========I==o

""" Editor
""""""""""
" command prompt
SetHotkey <ESC>/ = :

SetHotkey <C-s> = call altvim#save()
SetHotkey <C-q> = call altvim#quit()
SetHotkey <C-w> = call altvim#close_file()

""" Edit text
"""""""""""""
SetHotkey <C-z> = call altvim#undo()
SetHotkey <ESC>z = call altvim#redo()

SetHotkey <C-v> = call altvim#paste()
SetHotkey <ESC>v = call altvim#multiclipboard()
SetHotkey <C-c> = call altvim#copy()
SetHotkey <C-x> = call altvim#cut()
SetHotkey <C-l> = call altvim#clone_line()
SetHotkey <C-d> = call altvim#delete_line()
SetHotkey <BS> = _, call altvim#delete_line()
SetHotkey <Space> = _, call altvim#clear_line()
SetHotkey <C-j> = call altvim#join_lines()
SetHotkey <C-r> = call altvim#replace()

SetHotkey <ESC><CR> = call altvim#repeat_hotkey()

SetHotkey <Tab> = _, call altvim#indent()
SetHotkey <S-Tab> = _, call altvim#outdent()

SetHotkey <C-b> = call altvim#format()

SetHotkey <C-_> = call altvim#toggle_comment()

SetHotkey <S-M-down> = call altvim#move_line('down')
SetHotkey <S-M-up> = call altvim#move_line('up')

""" GoTo
""""""""
SetHotkey <ESC><BS> = call altvim#goto_last_change()
SetHotkey <C-up> = call altvim#goto_line_begin()
SetHotkey <C-down> = call altvim#goto_line_end()
SetHotkey <C-right> = call altvim#goto_next_word()
SetHotkey <C-left> = call altvim#goto_prev_word()
SetHotkey <M-right> = call altvim#goto_char('next')
SetHotkey <M-left> = call altvim#goto_char('prev')


""" Scrolling
"""""""""""""
SetHotkey <M-up> = call altvim#scroll_page('up')
SetHotkey <M-down> = call altvim#scroll_page('down')


""" Selection
"""""""""""""
SetHotkey <ESC>s = call altvim#select_last_selection()
SetHotkey <C-a> = call altvim#select_all() 
SetHotkey <C-t> = call altvim#select_word()
SetHotkey <C-S-right> = call altvim#select_next_word()
SetHotkey <C-S-left> = call altvim#select_prev_word()
SetHotkey <S-up> = call altvim#select_prev_line()
SetHotkey <S-down> = call altvim#select_next_line()
SetHotkey <S-right> = call altvim#select_next_char()
SetHotkey <S-left> = call altvim#select_prev_char()

SetHotkey ( = _, call altvim#select_content_within('parentheses')
SetHotkey ) = _, call altvim#select_content_within_included('parentheses')
SetHotkey { = _, call altvim#select_content_within('braces')
SetHotkey } = _, call altvim#select_content_within_included('braces')
SetHotkey [ = _, call altvim#select_content_within('square_brackets')
SetHotkey ] = _, call altvim#select_content_within_included('square_brackets')
SetHotkey t = _, call altvim#select_content_within('tag')
SetHotkey T = _, call altvim#select_content_within_included('tag')
SetHotkey < = _, call altvim#select_content_within('lessthan')
SetHotkey > = _, call altvim#select_content_within_included('lessthan')
SetHotkey ' = _, call altvim#select_content_within('single_quotes')
SetHotkey " = _, call altvim#select_content_within('double_quotes')
SetHotkey ` = _, call altvim#select_content_within('back_quotes')


""" Project
"""""""""""
" SetHotkey <ESC>2 = call altvim#show_project_symbols()
" SetHotkey <ESC>3 = call altvim#show_file_symbols()

SetHotkey <C-e> = call altvim#show_problems()
" SetHotkey <ESC>1 = call altvim#goto_next_problem()
" SetHotkey <ESC>! = call altvim#goto_prev_problem()

SetHotkey <ESC>` = call altvim#find_project_files()
SetHotkey <ESC><Tab> = call altvim#show_open_files()
SetHotkey <ESC>f = call altvim#find_in_project_files()
SetHotkey <ESC>h = call altvim#show_recent_files()
SetHotkey <C-f> = call altvim#find_in_file()


" o====I===================>
" [The plugin configuration] 
" <===================I====o

if exists("g:plugs")
    let g:altvim#plugin_dir = g:plugs['altvim'].dir
    let g:altvim#defined_plugins = keys(g:plugs)
    let g:altvim#installed_plugins = filter(keys(g:plugs), 'isdirectory(g:plugs[v:val].dir)')
    function! altvim#install_plugins() abort
        PlugInstall --sync
    endfunction
endif

" when vim startup auto install altvim plugins if its were not installed
if len(g:altvim#defined_plugins) != len(g:altvim#installed_plugins)
    nohl | call altvim#install_plugins() | bdelete | source $MYVIMRC
endif

" add nodejs bin to $PATH if needed
if stridx($PATH, 'node') < 0
    let $PATH=$PATH . ':' . g:altvim#plugin_dir . 'deps/nodejs/bin'
endif

" snippets directory
if !exists("g:altvim_snippets")
    let g:altvim_snippets = '~/.vim/snippets'
endif


" o===I============>
" [Plugins settings]
" <============I===o

" setting up emmet
if !exists("g:user_emmet_install_global")
    let g:user_emmet_install_global = 0
    autocmd FileType html,css,php,js,jsx EmmetInstall
endif
if !exists("g:user_emmet_leader_key")
    let g:user_emmet_leader_key = ','
endif

" customize status bar
if !exists("g:lightline")
    let g:lightline = {
                \ 'active': {
                \   'left': [ [], ['modified', 'filename', 'readonly'] ],
                \   'right': [ ['lspstatus'], ['fileencoding', 'filetype', 'lineinfo'] ]
                \ },
                \ 'component' : {
                \   'filename': '%F'
                \ },
                \ 'component_expand': {
                \   'lspstatus': 'coc#status'
                \ }}
endif

" setting up fzf
if !exists("g:fzf_layout")
    let g:fzf_layout = {'down': '50%'}
endif

" setting up lsp 
if !exists("g:coc_node_path")
    let g:coc_node_path = g:altvim#plugin_dir . 'deps/nodejs/bin/node'
endif
if !exists("g:coc_user_config")
    let g:coc_user_config = {
        \ "npm.binPath": g:altvim#plugin_dir . 'deps/nodejs/lib/node_modules/yarn/bin/yarn',
        \ "diagnostic.signOffset": 9999999,
        \ "diagnostic.errorSign": "●",
        \ "diagnostic.warningSign": "●",
        \ "diagnostic.infoSign": "●",
        \ "diagnostic.hintSign": "●",
        \ "diagnostic.refreshAfterSave": v:true,
        \ "diagnostic.refreshOnInsertMode": v:true,
        \ "suggest.noselect": v:false,
        \ "suggest.minTriggerInputLength": 2,
        \ "suggest.timeout": 3000,
        \ "suggest.snippetIndicator": "►",
        \ "suggest.maxCompleteItemCount": 15,
        \ "snippets.userSnippetsDirectory": get(g:, 'altvim_snippets'),
        \ "snippets.extends": {
        \   "javascriptreact": ["javascript"],
        \ }
\ }
endif

" indent-line
if !exists("g:indentLine_setColors")
    let g:indentLine_setColors = 0
endif
if !exists("g:indentLine_setConceal")
    let g:indentLine_setConceal = 0
endif
