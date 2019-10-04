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

" disable netrw directory listing on startup
let loaded_netrw = 0

" [Plugins settings]
" =*=*=*=*=*=*=*=*=

" setting up emmet
let g:user_emmet_install_global=0
autocmd FileType html,css,php,js,jsx EmmetInstall
let g:user_emmet_leader_key=','

" customize status bar
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

" setting up fzf
let g:fzf_layout = {'down': '50%'}

" setting up lsp 
let g:coc_node_path = expand("~/.vim/plugged/altvim/deps/nodejs/bin/node")
let g:coc_user_config = {
    \ "npm.binPath": expand("~/.vim/plugged/altvim/deps/nodejs/lib/node_modules/yarn/bin/yarn"),
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
    \ "snippets.userSnippetsDirectory": expand("~/.vim/snippets"),
    \ "snippets.extends": {
    \   "javascriptreact": ["javascript"],
    \ }
\ }
    
" set language based settings
let g:php_var_selector_is_identifier=1
let g:vim_markdown_conceal_code_blocks = 0


" [Utils]
" =*=*=*=

function! Format()
    if (line("'>") - line("'<") + 1) > 1
        normal! gv=
    else
        normal! gv=gvgq
    endif
endfunction

function! s:replace_found(...)
    exe "cdo s/" . a:1 . "/ge | :silent nohl | :silent only"
endfunction

function! s:get_selection()
    let [line_start, column_start] = getpos("'<")[1:2]
    let [line_end, column_end] = getpos("'>")[1:2]
    let lines = getline(line_start, line_end)
    if len(lines) == 0
        return ''
    endif
    let lines[-1] = lines[-1][: column_end - 2]
    let lines[0] = lines[0][column_start - 1:]
    return join(lines, "\n")
endfunction

" Nowhere using
" function! s:getchar(...)
"     let l:chars = a:0 > 0 ? a:1 : {}
"     let l:char = nr2char(getchar())
"     if l:char =~ '\a'
"         let l:chars.operation = l:char
"         return l:chars
"     endif
"     let l:chars.count =  has_key(l:chars, 'count') 
"                 \ ? get(l:chars, 'count') .  l:char
"                 \ : l:char
"     return s:getchar(l:chars)
" endfunction

" Go to a specific char in a line or a specific line
" Usage:
"   - 12d   go to char 'd' in 12 line
"   - 12    go to 12 line
"   - d     go to char 'd' in current line
" Note:
"   - [!] work in visual mode too
function! GoTo(mode)
    let l:searchPattern = input("")
    let l:number = get(split(l:searchPattern, '\D'), 0)
    let l:char = get(split(l:searchPattern, '\d'), 0)

    let l:cmd = ''

    if l:number == 0 && l:char != ''
        let l:cmd = 'f' . l:char
    elseif l:number != 0 && l:char != ''
        let l:cmd = l:number . 'Gf' . l:char
    elseif l:number != 0 && l:char == ''
        let l:cmd = l:number . 'G'
    endif
    let l:cmd = a:mode == 'v' ? 'gv' . l:cmd : l:cmd
    exe 'normal! ' . l:cmd
endfunction

function! SelectWord()
    let l:currSymbol = getline('.')[col('.') - 1]
    let l:prevSymbol = getline('.')[col('.') - 2]

    let l:condition =  (matchstr(l:prevSymbol, '\w') != '' && matchstr(l:currSymbol, '\w') != '')

    exe 'normal! ' . (l:condition ? 'bv' : 'v') . 'eh'
endfunction

function! SelectLine(type, mode)
    if a:type == 'nextline'
        exe 'normal! ' . (a:mode == 'V' ? 'gv' . v:count1 . 'j' : 'V')
    elseif a:type == 'prevline'
        exe 'normal! ' . (a:mode == 'V' ? 'gv' . v:count1 . 'k' : 'V')
    endif
endfunction

command! -nargs=* SetAction inoremap <args>
command! -nargs=* SetOperation vnoremap <silent> <args>
command! -nargs=0 OpenInBrowser !google-chrome %
command! -nargs=0 SearchSelectionInFile execute ":BLines '" . s:get_selection()
command! -nargs=0 SearchSelectionInRoot execute ":Ag '" . s:get_selection()
command! -nargs=1 ReplaceFound call s:replace_found(<f-args>)


" [StartUp]
" =*=*=*=*=

" Show file search after start on directory
autocmd VimEnter * nested if argc() == 1 && isdirectory(argv()[0]) |
            \   sleep 100m |
            \   exe "FZF! --reverse --multi" |
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
SetAction <C-v> <C-o>p
" copy
SetOperation <C-c> y
" cut
SetOperation <C-x> d
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
SetOperation <ESC>b :<C-u>call Format()<CR>
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
SetAction <ESC>/ <C-o>:call GoTo('n')<CR>
SetOperation <ESC>/ :<C-u>call GoTo('v')<CR>
" go to next found char
SetAction <M-right> <C-o>;
SetOperation <M-right> ;
" go to prev found char
SetAction <M-left> <C-o>,
SetOperation <M-left> ,
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
SetAction <C-w> <C-o>:call SelectWord()<CR> 
" select line above
SetAction <S-up> <C-o>:call SelectLine('prevline', 'n')<CR>
SetOperation <S-up> :<C-u>call SelectLine('prevline', 'v')<CR>
" select line below
SetAction <S-down> <C-o>:call SelectLine('nextline', 'n')<CR>
SetOperation <S-down> :<C-u>call SelectLine('nextline', 'v')<CR>
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
