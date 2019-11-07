" [Settings]
" =*=*=*=*=
"
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
set t_Co=256 number numberwidth=4 showcmd noshowmode nomodeline laststatus=2 cursorline cmdheight=1 scrolloff=2 showtabline=0 signcolumn=yes display=lastline

" enable brace matching and for tags
set showmatch matchpairs+=<:>

" command line
set wildmenu wildmode=longest:full,full

" diff
set diffopt=filler diffopt+=iwhite

" autocomplete
set omnifunc=syntaxcomplete#Complete completeopt=longest,menuone,menu

let mapleader="\\"

" [altvim variables]
" =*=*=*=*=*=*=*=*=

" when vim startup auto install altvim plugins if its were not installed
if has_key(g:plugs, "fzf") && !isdirectory(g:plugs["fzf"].dir)
    nohl | PlugInstall --sync | bdelete | source $MYVIMRC
endif

" add nodejs bin to $PATH if needed
if stridx($PATH, 'node') < 0
    let $PATH=$PATH . ':' . g:plugs['altvim'].dir . 'deps/nodejs/bin'
endif

" [Plugins settings]
" =*=*=*=*=*=*=*=*=

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
    let g:coc_node_path = g:plugs["altvim"].dir . 'deps/nodejs/bin/node'
endif
if !exists("g:coc_user_config")
    let g:coc_user_config = {
        \ "npm.binPath": g:plugs["altvim"].dir . 'deps/nodejs/lib/node_modules/yarn/bin/yarn',
        \ "diagnostic.signOffset": 9999999,
        \ "diagnostic.errorSign": "●",
        \ "diagnostic.warningSign": "●",
        \ "diagnostic.infoSign": "●",
        \ "diagnostic.hintSign": "●",
        \ "diagnostic.refreshAfterSave": v:true,
        \ "suggest.noselect": v:false,
        \ "suggest.minTriggerInputLength": 2,
        \ "suggest.timeout": 400,
        \ "suggest.snippetIndicator": "►",
        \ "suggest.maxCompleteItemCount": 15,
        \ "snippets.userSnippetsDirectory": get(g:, 'altvim_snippets'),
        \ "snippets.extends": {
        \   "javascriptreact": ["javascript"],
        \ }
    \ }
endif

" snippets directory
if !exists("g:altvim_snippets")
    let g:altvim_snippets = '~/.vim/snippets'
endif

" auto-pairs
if !exists("g:AutoPairsFlyMode")
    let g:AutoPairsFlyMode = 0
endif
if !exists("g:AutoPairsMultilineClose")
    let g:AutoPairsMultilineClose = 0
endif
if !exists("b:AutoPairs")
    autocmd FileType * let b:AutoPairs = AutoPairsDefine({'<': '>'})
endif

function! altvim#isActivePlugin(pluginName) abort
    return has_key(g:plugs, a:pluginName) && isdirectory(g:plugs[a:pluginName].dir)
endfunction

" indent-line
if !exists("g:indentLine_setColors")
    let g:indentLine_setColors = 0
endif


" [StartUp]
" =*=*=*=*=

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


" [Keybindings]
" =*=*=*=*=*=*=
" - Operation work only when something is selected

" save
SetAction <C-s> <C-o>:w<CR>
" quit
SetAction <C-q> <C-o>:q!<CR>
" command prompt
SetAction <ESC>? <C-o>:

" undo
SetAction <C-z> <C-o>u
" redo
SetAction <ESC>z <C-o><C-r>
" paste
SetAction <C-v> <C-o>:call altvim#paste()<CR>
" copy
SetOperation <C-c> :<C-u>call altvim#copy()<CR>
" cut
SetOperation <C-x> :<C-u>call altvim#cut()<CR>
" clone
SetOperation <C-l> "dyk"dp
" delete
SetOperation <C-d> "_d
" replace
SetOperation <Space> "_c
" join
SetOperation <C-j> J
" replace found
SetAction <C-r> <C-o>:ReplaceFound

" repeat
SetAction <ESC><CR> <C-o>.

" base format
SetOperation <ESC>b :<C-u>call altvim#format()<CR>
" indent to the right
SetOperation <Tab> >gv
" indent to the left
SetOperation <S-Tab> <gv
" move line up
SetOperation <M-up> :m'<-2<CR>gv=gv
" move line down
SetOperation <M-down> :m'>+1<CR>gv=gv
" go to begin of a line
SetAction <C-up> <C-o>^
SetOperation <C-up> ^
" go to end of a line
SetOperation <C-down> $
SetAction <C-down> <C-o>$
" go to next word
SetAction <C-right> <C-o>e
SetOperation <C-right> e
" go to prev word
SetAction <C-left> <C-o>b
SetOperation <C-left> b
" activate search char mode
SetAction <ESC>/ <C-o>:call altvim#jump_to({})<CR>
SetOperation <ESC>/ :<C-u>call altvim#jump_to({"isEnabledSelection": v:true})<CR>
" go to next found char
SetAction <M-right> <C-o>:call altvim#jump_to({"mode": "next"})<CR>
SetOperation <M-right> :<C-u>call altvim#jump_to({"mode": "next", "isEnabledSelection": v:true})<CR>
" go to prev found char
SetAction <M-left> <C-o>:call altvim#jump_to({"mode": "prev"})<CR>
SetOperation <M-left> :<C-u>call altvim#jump_to({"mode": "prev", "isEnabledSelection": v:true})<CR>
" go to next paired braces
SetAction <ESC>% <C-o>%
SetOperation <ESC>% %
" go to prev cursor position
SetAction <ESC><BS> <C-o>g;

" scroll page up
SetAction <M-up> <C-o><C-y>
" scroll page down
SetAction <M-down> <C-o><C-e>

" select last selection
SetAction <ESC>s <C-o>gv
" select all lines
SetAction <C-a> <C-o>gg<C-o>VGg
" select a word
SetAction <C-w> <C-o>:call altvim#select_word()<CR> 
" select line above
SetAction <S-up> <C-o>:call altvim#select_line('prevline', 'n')<CR>
SetOperation <S-up> :<C-u>call altvim#select_line('prevline', 'v')<CR>
" select line below
SetAction <S-down> <C-o>:call altvim#select_line('nextline', 'n')<CR>
SetOperation <S-down> :<C-u>call altvim#select_line('nextline', 'v')<CR>
" select a char
SetAction <S-right> <C-o>v
SetOperation <S-right> <right>
SetAction <S-left> <C-o>v
SetOperation <S-left> <left>
" select content within parentheses
SetOperation ( i(
" ))( select content with parentheses
SetOperation ) a(
" ) select content within braces
SetOperation [ i[
" select content with braces
SetOperation ] a[
" select content within curly braces
SetOperation { i{
" }}{ select content with curly braces
SetOperation } a{
" } select content within single quotes
SetOperation ' i'
" select content within double quotes
SetOperation " i"
" select content withing tags
SetOperation t it
" select content with tags
SetOperation t at

" show workspace symbol
SetAction <ESC>2 <C-o>:CocList -I symbols<CR>
" show current file symbols
SetAction <ESC>3 <C-o>:CocList outline<CR>
" format selected according to code style and editor text-width setting
SetOperation <C-b> :<C-u>call CocActionAsync('formatSelected', visualmode())<CR>
" show errors and warnings
SetAction <C-e> <C-o>:CocList diagnostics<CR>
" navigate diagnostic
SetAction <ESC>1 <C-o>:call CocActionAsync('diagnosticNext')<CR>
SetAction <ESC>! <C-o>:call CocActionAsync('diagnosticPrevious')<CR>

" show all files in projects
SetAction <ESC>` <C-o>:Files<CR>
" show current opened files
SetAction <ESC><Tab> <C-o>:Buffers<CR>
" search in project files
SetAction <ESC>f <C-o>:Ag<CR>
" find in current file
SetAction <C-f> <C-o>:BLines<CR>
" show recent opened files
SetAction <Esc>~ <C-o>:History<CR>
" search selection within current file
SetOperation <C-u> :<C-u>SearchSelectionInFile<CR>
" search selection within root directory
SetOperation <ESC>u :<C-u>SearchSelectionInRoot<CR>

" toggle comment selected text
SetOperation <C-_> :Commentary<CR>
SetAction <C-_> <C-o>:Commentary<CR>
