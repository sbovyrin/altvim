
" - Completion by dictionary (https://i.stack.imgur.com/x8B6U.gif)
" setlocal complete+=k
" setlocal dictionary+=/path/to/fontawesome.txt
" setlocal iskeyword+=-

silent !stty -ixon

" disable back-compatibility with Vi
set nocompatible
" enable auto filetype determination 
" and autoloading appropriated plugins for the filetype
filetype plugin indent on
" syntax highlighting
syntax enable
" hide background buffer
set hidden
" fix backspace
set backspace=indent,eol,start
" disable swap file
set noswapfile
" disable backup files
set nobackup
" permanent insert mode by default
set insertmode
" default editor encoding
set encoding=utf-8
" copy, cut to '0' register
set clipboard=unnamedplus
" keep 50 commands in history
set history=50
" set editor message format
set shortmess+=c

" boost performance
set nocursorline
set nocursorcolumn 
set scrolljump=5
set synmaxcol=200
set nofoldenable
set foldmethod=manual
set foldlevel=0
set lazyredraw
set nowrap "?
" set regexpengine=1 "?

" indentation
set shiftwidth=4 tabstop=4 softtabstop=4 expandtab autoindent smartindent

" text width
" set colorcolumn=80

" set whichwrap+=<,>,[,]

" in-text search 
set incsearch ignorecase smartcase wrapscan
" highlight search only while in-search
augroup vimrc-incsearch-highlight
        autocmd!
        autocmd CmdlineEnter /,\? :set hlsearch
        autocmd CmdlineLeave /,\? :set nohlsearch
augroup END

" show matched pairs
set showmatch matchpairs+=<:>

" UI
set termguicolors guicursor=a:block-blinkon0 number signcolumn=yes:1 showcmd cmdheight=1 noshowmode noruler laststatus=2 nomodeline

" command line completion by <Tab>
set wildmenu wildmode=longest:full,full

" set autocomplete engine and options
" set completeopt=menu,menuone,noinsert,noselect
" set omnifunc=lsc#complete#complete

" configure statusline
set statusline=%#StatusLineNC#%m%{altvim#lsp_status()}%r\ %.60F\ %y\ %{&fenc}%=Col:\ %c\ \|\ Line:\ %l/%L

" disable netrw directory listing on startup
let loaded_netrw = 0

" Plugins settings
" altvim settings
if exists("g:plugs")
    let g:altvim_dir = g:plugs['altvim'].dir
    let g:altvim_defined_plugins = keys(g:plugs)
    let g:altvim_installed_plugins = filter(keys(g:plugs), 'isdirectory(g:plugs[v:val].dir)')

    function! altvim#install_plugins() abort
        PlugInstall --sync
    endfunction

    " when vim startup auto install altvim plugins if its were not installed
    if len(g:altvim_defined_plugins) != len(g:altvim_installed_plugins)
        nohl | call altvim#install_plugins() | bdelete | source $MYVIMRC
    endif
endif

" indent-line
let g:indentLine_fileTypeExclude = ['markdown']
let g:indentLine_defaultGroup = 'Conceal'

" LSP
if exists("g:plugs") && has_key(g:plugs, "coc.nvim")
    let g:coc_data_home = g:altvim_dir . 'deps/lsp'
    let g:coc_config_home = g:altvim_dir . 'deps/lsp/config'

    if exists("g:altvim_lsp")
        let g:coc_node_path = get(g:altvim_lsp, 'nodejs', '/usr/bin/node')
    endif

    let g:coc_user_config = {
        \ "npm.binPath": exists("g:altvim_lsp") ? get(g:altvim_lsp, 'npm', 'npm') : '/usr/bin/npm',
        \ "suggest.autoTrigger": "always",
        \ "suggest.floatEnable": v:false,
        \ "suggest.triggerCompletionWait": 200,
        \ "suggest.maxCompleteItemCount": 7,
        \ "suggest.minTriggerInputLength": 3,
        \ "suggest.snippetIndicator": "",
        \ "suggest.preferCompleteThanJumpPlaceholder": v:true,
        \ "suggest.keepCompleteopt": v:true,
        \ "signature.target": "echo",
        \ "signature.messageTarget": "echo",
        \ "diagnostic.level": "error",
        \ "diagnostic.refreshOnInsertMode": v:true,
        \ "diagnostic.refreshAfterSave": v:true,
        \ "diagnostic.messageTarget": "echo",
        \ "diagnostic.warningSign": "#",
        \ "diagnostic.errorSign": "*",
        \ "diagnostic.infoSign": "",
        \ "diagnostic.hintSign": "",
        \ "coc.preferences.hoverTarget": "echo",
        \ "coc.preferences.bracketEnterImprove": v:false,
        \ "coc.preferences.snippets.enable": v:false,
        \ "coc.preferences.extensionUpdateCheck": "never",
        \ "coc.preferences.maxFileSize": "5MB",
        \ "coc.preferences.enableFloatHighlight": v:false,
        \ "coc.preferences.messageLevel": "error",
        \ "emmet.showExpandedAbbreviation": v:false,
        \ "emmet.includeLanguages": ["html", "javascript", "javascriptreact", "php"],
        \ "emmet.excludeLanguages": [],
        \ "codeLens.enable": v:false
    \ }

    hi! link CocErrorHighlight Error
    hi! link CocWarningHighlight WarningMsg
    hi! link CocUnderline Underlined
endif

" FZF settings
let g:fzf_layout = {'window': 'enew'}

" Start Up commands
" language specific tab
autocmd FileType javascript setlocal shiftwidth=2 tabstop=2
autocmd FileType css setlocal shiftwidth=2 tabstop=2
autocmd FileType html setlocal shiftwidth=2 tabstop=2
autocmd FileType markdown setlocal shiftwidth=2 tabstop=2

" show file search after start on directory
autocmd VimEnter * nested
            \ if argc() == 1 && isdirectory(argv()[0])
            \ | sleep 100m
            \ | exe "call fzf#vim#files(
            \   (argv()[0] == getcwd()) ? getcwd() : getcwd() . '/' . argv()[0],
            \   {'options' : ['--preview', 'head -50 {}', '--preview-window', 'down:50%']})"
            \ | endif 

" FZF tweak
autocmd! FileType fzf exe 'set laststatus=0 | IndentLinesToggle'
            \| autocmd BufLeave <buffer> exe 'set laststatus=2 | IndentLinesToggle'

" Commands
command! -bang ProjectFiles
            \ call fzf#vim#files(
            \   (argv()[0] == getcwd()) 
            \       ? getcwd() 
            \       : (isdirectory(argv()[0])
            \           ? getcwd() . '/' . argv()[0]
            \           : fnamemodify(getcwd() . '/' . argv()[0], ':h')),
            \   {'options' : ['--preview', 'head -50 {}', '--preview-window', 'down:50%']},
            \   <bang>0
            \ )

command! -bang -nargs=? Buffers
    \ call fzf#vim#buffers(
    \   <q-args>,
    \   fzf#vim#with_preview('down:50%'),
    \   <bang>0
    \ )

command! -bang -nargs=* Rg
    \ call fzf#vim#grep(
    \   'rg --smart-case
    \       --line-number
    \       --no-heading
    \       --color=always
    \       --colors=line:none
    \       --colors=path:none
    \       --colors=match:none
    \       --colors=column:none
    \       -- ' . shellescape(<q-args>),
    \   1,
    \   fzf#vim#with_preview('down:50%'),
    \   <bang>0
    \ )


" Hotkeys

fun! GetPrefix()
    return mode() == 'i' ? "\<C-\>\<C-o>" : ""
endfun

fun! XSave()
    return GetPrefix() . ":w\<cr>"
endfun

fun! XClose()
    return GetPrefix() . ":bdelete\<cr>"
endfun

fun! XQuit()
    return GetPrefix() . ":q!\<cr>"
endfun

fun! XUndo()
    return GetPrefix() . "u"
endfun

fun! XRedo()
    return GetPrefix() . "\<c-r>"
endfun

fun! XDelete()
    return GetPrefix() . '"_d'
endfun

fun! XClear()
    return 'h"_d'
endfun

fun! XCopy()
    return GetPrefix() . '"0y'
endfun

fun! XCut()
    return GetPrefix() . '"0d'
endfun

fun! XPaste()
    let l:lines = split(@0, "\n")
    let l:first_line = substitute(l:lines[0], '^\s\+', '', '')
    let l:first_line = substitute(l:first_line, '\s\+$', '', '')
    let l:first_line = substitute(l:first_line, '^I', '', '')
    let @0 = join([l:first_line] + l:lines[1:], "\n")

    let l:mode = col('.') == 1  ? "P" : "p"
    return GetPrefix() . '"0' . l:mode
endfun

fun! XSelect()
    return GetPrefix() . "v"
endfun

fun! XSelectLine()
    return GetPrefix() . 'V'
endfun

fun! XSearchInText()
    return GetPrefix() . "/"
endfun

fun! XNextFound()
    return GetPrefix() . "n"
endfun

fun! XPrevFound()
    return GetPrefix() . "N"
endfun

fun! XLineEnd()
    return GetPrefix() . "$"
endfun

fun! XLineBegin()
    return GetPrefix() . "^"
endfun

fun! XWordBegin()
    return GetPrefix() . '/\(\(\A\|\n\)\zs\(\a\|\d\)\)\|\(\l\zs\u\)' . "\<cr>"
endfun

fun! XWordEnd()
    return GetPrefix() . '/\(\a\|\d\)\(\A\|\n\)\|\(\l\(\u\|\d\)\)' . "\<cr>"
endfun

fun! XRepeat()
    return GetPrefix() . "."
endfun

fun! XCmd()
    return GetPrefix() . ":"
endfun

fun! XOpenFile()
    return GetPrefix() . ":ProjectFiles\<cr>"
endfun

fun! XSwitchFile()
    return GetPrefix() . ":Buffers\<cr>"
endfun

fun! XRecentFile()
    return GetPrefix() . ":History\<cr>"
endfun

fun! XSearchInFile()
    return GetPrefix() . ":BLines\<cr>"
endfun

fun! XSearchInFiles()
    return GetPrefix() . ":Rg\<cr>"
endfun

fun! XShowErrors()
    return GetPrefix() . ":CocList diagnostic\<cr>"
endfun

fun! XFormat()
    return GetPrefix() . ":call CocActionAsync('formatSelected', visualmode())\<cr>"
endfun

fun! XComment()
    return GetPrefix() . ":Commentary\<cr>"
endfun

fun! XIndent()
    return GetPrefix() . ">"
endfun

fun! XOutdent()
    return GetPrefix() . "<"
endfun

fun! Shortcut(key, act, ...)
    let l:key = split(a:key, " ")
    if l:key[0] != '_' || (l:key[0] == '_' && len(l:key) > 1)
        exe 'noremap <silent> <expr> ' . get(l:key, 1, l:key[0]) . ' ' . a:act
    endif

    if l:key[0] != '_'
        exe 'inoremap <silent> <expr> ' . l:key[0] . ' ' . a:act
    endif
endfun

" Base
call Shortcut("<M-`>", "XCmd()", "Command prompt")
call Shortcut("<C-s>", "XSave()", "Save")
call Shortcut("<C-w>", "XClose()", "Close file")
call Shortcut("<C-q>", "XQuit()", "Quit VIM")
call Shortcut("<C-z>", "XUndo()", "Undo")
call Shortcut("<M-z>", "XRedo()", "Redo")
call Shortcut("<C-e>", "XOpenFile()", "Open file")
call Shortcut("<C-r>", "XSwitchFile()", "Switch file")
call Shortcut("<C-h>", "XRecentFile()", "Recent file")
call Shortcut("<C-f>", "XSearchInFile()", "Search in file")
call Shortcut("<C-g>", "XSearchInFiles()", "Search in files")
call Shortcut("<M-1>", "XShowErrors()", "Show errors")
call Shortcut("<C-b>", "XFormat()", "Format")
call Shortcut("<C-_>", "XComment()", "Comment")

" Actions
call Shortcut("<M-a>", "XRepeat()", "Repeat last action")
call Shortcut("<C-c>", "XCopy()", "Copy")
call Shortcut("<C-x>", "XCut()", "Cut")
call Shortcut("<C-v>", "XPaste()", "Paste")
call Shortcut("<C-d>", "XDelete()", "Delete")
call Shortcut("_ <Space>", "XClear()", "Clear")
call Shortcut("<S-down>", "XSelectLine()", "Select line")
call Shortcut("<S-up>", "XSelectLine()", "Select line")
call Shortcut("<S-right>", "XSelect()", "Select")
call Shortcut("<S-left>", "XSelect()", "Select")
call Shortcut("<Tab>", "XIndent()", "Indent line")
call Shortcut("<S-Tab>", "XOutdent()", "Outdent line")

" Movements
call Shortcut("<M-f>", "XSearchInText()", "Search in text")
call Shortcut("<M-right>", "XNextFound()", "To next found")
call Shortcut("<M-left>", "XPrevFound()", "To previous found")
call Shortcut("<C-down>", "XLineEnd()", "To end of current line")
call Shortcut("<C-up>", "XLineBegin()", "To begin  of current line")
call Shortcut("<M-w>", "XWordBegin()", "To begin of word")
call Shortcut("<M-e>", "XWordEnd()", "To end of word")

