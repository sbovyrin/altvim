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

" indent-line
if !exists("g:indentLine_setColors")
    let g:indentLine_setColors = 0
endif
if !exists("g:indentLine_setConceal")
    let g:indentLine_setConceal = 0
endif

" [Utils]
" =*=*=*=
function! altvim#format()
    if (line("'>") - line("'<") + 1) > 1
        normal! gv=
    else
        normal! gv=gvgq
    endif
endfunction

function! altvim#replace_found(...) abort
    exe "cdo s/" . a:1 . "/ge | :silent nohl | :silent only"
endfunction

function! altvim#get_selection()
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

function! altvim#copy()
    normal! gvy
    let @+ = substitute(@+, '\n\+$', '', '')
    let @+ = substitute(@+, '^\s*', '', '')
endfunction

function! altvim#paste()
    normal! p
endfunction

function! altvim#cut()
    normal! gvd
endfunction

" Jump to start of specific char
" Params:
"   - opts: {'mode': 'next'|'prev', 'isEnabledSelection': true|false}
" Usage:
"   - type "an" to jump first found "an" chars sequence in current file
"   - search next result if passed 'next' as first param
"   - search previous result if passed 'prev' as first param
" Note:
"   - [!] case-insensitive
"   - [!] also works in visual mode until first found
function! altvim#jump_to(opts)
    let l:mode = get(a:opts, 'mode', 'base')
    let l:isEnabledSelection = get(a:opts, 'isEnabledSelection', v:false)

    if l:mode == 'base' | let b:altvimJumpToChar = nr2char(getchar()) . nr2char(getchar()) | endif

    if l:mode == 'prev'
        let l:searchFlag = 'b'
    else
        let l:searchFlag = ''
    endif
    
    let [l:lineNumber, l:pos] = searchpos(get(b:, 'altvimJumpToChar', ''), l:searchFlag)
        
    if l:isEnabledSelection
        if l:mode == 'prev'
            let l:selectionDirection = "'<"
            let l:pos = l:pos + 1
        else
            let l:selectionDirection = "'>"
            let l:pos = l:pos - 1
        endif
        call setpos(l:selectionDirection, [0, l:lineNumber, l:pos, 0])
        normal! gv
    endif
endfunction

function! altvim#select_word()
    let l:currSymbol = getline('.')[col('.') - 1]
    let l:prevSymbol = getline('.')[col('.') - 2]

    let l:condition =  (matchstr(l:prevSymbol, '\w') != '' && matchstr(l:currSymbol, '\w') != '')

    exe 'normal! ' . (l:condition ? 'bv' : 'v') . 'eh'
endfunction

function! altvim#select_line(type, mode)
    if a:type == 'nextline'
        exe 'normal! ' . (a:mode == 'V' ? 'gv' . v:count1 . 'j' : 'V')
    elseif a:type == 'prevline'
        exe 'normal! ' . (a:mode == 'V' ? 'gv' . v:count1 . 'k' : 'V')
    endif
endfunction

function! altvim#get_known_filetypes() abort
    return map(split(globpath(&rtp, 'ftplugin/*.vim'), '\n'), 'fnamemodify(v:val, ":t:r")')
endfunction

command! -nargs=* SetAction inoremap <args>
command! -nargs=* SetOperation vnoremap <silent> <args>
command! -nargs=0 OpenInBrowser !google-chrome %
command! -nargs=0 SearchSelectionInFile execute ":BLines '" . altvim#get_selection()
command! -nargs=0 SearchSelectionInRoot execute ":Ag '" . altvim#get_selection()
command! -nargs=1 ReplaceFound call altvim#replace_found(<f-args>)


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
SetOperation <C-z> :<C-u>normal! u<CR>
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
SetOperation <BS> "_d
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
