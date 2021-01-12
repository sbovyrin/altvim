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
" set synmaxcol=200
set nofoldenable
set foldmethod=manual
set foldlevel=0
set lazyredraw
set redrawtime=5000
" set regexpengine=1 "?

" indentation
set expandtab autoindent smartindent tabstop=4 softtabstop=4 shiftwidth=4
" soft wrap
set wrap linebreak breakindent breakindentopt=shift:4

" formatting
set formatoptions=2ql
" completion
set complete=.,b,u,t,i
set completeopt=menu
" set omnifunc=syntaxcomplete#Complete

" in-text search 
set incsearch nohlsearch ignorecase smartcase wrapscan
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

" configure statusline
set statusline=%#Error#%{altvim#lsp_status()}%#StatusLineNC#%r\ %.60F\ %y\ %{&fenc}%=Col:\ %c\ \|\ Line:\ %l/%L

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


" LSP
if exists("g:plugs") && has_key(g:plugs, "coc.nvim")
    let g:coc_data_home = g:altvim_dir . 'deps/lsp'
    let g:coc_config_home = g:altvim_dir . 'deps/lsp/config'

    if exists("g:altvim_lsp")
        let g:coc_node_path = get(g:altvim_lsp, 'nodejs', '/usr/bin/node')
    endif
    
    let g:coc_user_config = {
        \ "npm.binPath": exists("g:altvim_lsp") ? get(g:altvim_lsp, 'npm', 'npm') : '/usr/bin/npm',
        \ "suggest.autoTrigger": "none",
        \ "suggest.floatEnable": v:false,
        \ "suggest.triggerCompletionWait": 200,
        \ "suggest.maxCompleteItemCount": 10,
        \ "suggest.minTriggerInputLength": 10,
        \ "suggest.snippetIndicator": "",
        \ "suggest.preferCompleteThanJumpPlaceholder": v:true,
        \ "suggest.noselect": v:false,
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
        \ "emmet.includeLanguages": ["html", "javascript", "javascriptreact", "php", "css", "svelte"],
        \ "emmet.excludeLanguages": [],
        \ "codeLens.enable": v:false
    \ }

    hi! link CocErrorHighlight Error
    hi! link CocWarningHighlight WarningMsg
    hi! link CocUnderline Underlined
endif

" indent-line
let g:indentLine_fileTypeExclude = ['markdown']
let g:indentLine_defaultGroup = 'Conceal'

" FZF settings
let g:fzf_layout = {'window': 'enew'}

" Start Up commands
" language specific tab
autocmd FileType javascript setlocal shiftwidth=2 tabstop=2 softtabstop=2 breakindentopt=shift:2
autocmd FileType svelte setlocal shiftwidth=2 tabstop=2 softtabstop=2 breakindentopt=shift:2
autocmd FileType css setlocal shiftwidth=2 tabstop=2 softtabstop=2 breakindentopt=shift:2
autocmd FileType html setlocal shiftwidth=2 tabstop=2 softtabstop=2 breakindentopt=shift:2
autocmd FileType markdown setlocal shiftwidth=2 tabstop=2 softtabstop=2 breakindentopt=shift:2

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
    let l:cmd = mode() == 'i' ? 'V' : ''
    
    return GetPrefix() . l:cmd . '"_d'
endfun

fun! X_Copy()
    let l:lines = split(@0, "\n")
    let l:first_line = substitute(l:lines[0], '^\s\+', '', '')
    let l:first_line = substitute(l:first_line, '\s\+$', '', '')
    let l:first_line = substitute(l:first_line, '\^I', '', 'i')
    let @0 = join([l:first_line] + l:lines[1:], "\n")

    " windows wsl tweak
    if system('uname -r') =~ 'microsoft'
        call system('clip.exe', @0)
    endif
endfun

fun! XCopy()
    return GetPrefix() . '"0y' . GetPrefix() . ":call X_Copy()\<cr>"
endfun

fun! XCut()
    return GetPrefix() . '"0d'
endfun

fun! XPaste()
    return GetPrefix() . '"0P'
endfun

fun! XSelect(dir)
    let l:cmd = mode() == 'v' ? "" : "v"
    
    if (l:cmd == '' && a:dir == 'right')
        let l:cmd = l:cmd . "l"
    elseif (a:dir == 'left')
        let l:cmd = l:cmd . "h"
    elseif (a:dir == 'up')
        let l:cmd = l:cmd . 'k'
    elseif (a:dir == 'down')
        let l:cmd = l:cmd . 'j'
    endif

    return GetPrefix() . l:cmd
endfun

fun! XSelectLine(type)
    let l:mode = mode() == 'v' ? '' : 'v'
    let l:cmd = '$h'
    
    if (a:type == 'begin')
        let l:cmd = '^'
    endif
    
    return GetPrefix() . l:mode . l:cmd
endfun

fun! XSelectBlock()
    return GetPrefix() . "\<C-v>"
endfun

fun! XSelectAll()
    return GetPrefix() . 'gg' . GetPrefix() . 'vG$'
endfun

fun! XReselect()
    return GetPrefix() . 'gv'
endfun

fun! XSelectPasted()
    return GetPrefix() . '`[' . GetPrefix() . 'v`]'
endfun

fun! XSmartSelect()
    let l:obj = nr2char(getchar())
    let l:objs = ['"', "'", '`', ')', ']', '}', '>', 't']
    
    if (index(l:objs, l:obj) == -1) | return '' | endif

    let l:cmd = mode() == 'v' ? '' : 'v'
    return GetPrefix() . l:cmd . "i" . l:obj
endfun

fun! XToChanges(dir)
    let l:cmd = a:dir == 'next' ? "g," : "g;"
    return GetPrefix() . l:cmd
endfun

fun! XSearchInText(dir)
    let l:char = nr2char(getchar())
    if (l:char == "\<ESC>") | return '' | endif
    
    let l:dir = a:dir == 'next' ? '/' : '?'

    return GetPrefix() . l:dir . l:char . "\<cr>"
endfun

fun! XNextFound()
    let l:cmd = v:searchforward ? 'n' : 'N'
    return GetPrefix() . l:cmd
endfun

fun! XPrevFound()
    let l:cmd = v:searchforward ? 'N' : 'n'
    return GetPrefix() . l:cmd
endfun

fun! XLineEnd()
    let l:cmd = mode() == 'v' ? (GetPrefix() . 'h') : ''
    return GetPrefix() . "$" . l:cmd
endfun

fun! XLineBegin()
    return GetPrefix() . "^"
endfun

fun! XWordBegin(dir)
    let l:cmd = mode() == 'v' ? 'h' : ''
    let l:dir = a:dir == 'next' ? '/' : '?'
    return GetPrefix() . l:dir . '\(\(\A\|\n\)\zs\(\a\|\d\)\)\|\(\l\zs\u\)' . "\<cr>" . l:cmd
endfun

fun! XWordEnd(dir)
    let l:cmd = mode() == 'v' ? '' : 'l'
    let l:dir = a:dir == 'next' ? '/' : '?'
    return GetPrefix() . l:dir . '\(\a\|\d\)\(\A\|\n\)\|\(\l\(\u\|\d\)\)' . "\<cr>" . GetPrefix() . l:cmd
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
    return GetPrefix() . "/"
endfun

fun! XSearchInFiles()
    return GetPrefix() . ":Rg\<cr>"
endfun

fun! XShowErrors()
    return GetPrefix() . ":CocList diagnostics\<cr>"
endfun

fun! XNextError()
    return GetPrefix() . ":call CocAction('diagnosticNext', 'error')\<cr>"
endfun

fun! XPrevError()
    return GetPrefix() . ":call CocAction('diagnosticPrevious', 'error')\<cr>"
endfun

fun! XFormat()
    let l:cmd = (mode() == 'v' ? '' : 'V')
    let l:fmt = l:cmd . '='
    
    if exists("g:plugs") && has_key(g:plugs, "coc.nvim")
     let l:fmt = ":call CocAction('formatSelected', visualmode())\<cr>"
    endif
    
    return GetPrefix() . l:fmt
endfun

fun! XComment()
    return GetPrefix() . ":Commentary\<cr>"
endfun

fun! XIndent()
    let l:cmd = mode() == 'v' ? (GetPrefix() . ">gv") : "\<Tab>"
    return l:cmd
endfun

fun! XOutdent()
    let l:cmd = mode() == 'v' ? "<gv" : "<<"
    return GetPrefix() . l:cmd
endfun

fun! XJoin()
    return GetPrefix() . "J"
endfun

fun! XClone()
    let l:cmd = mode() == 'v' ? '' : 'V'
    return GetPrefix() . l:cmd . '"cy' . GetPrefix() . '"cP'
endfun

fun! XClosePanel()
    if (get(getloclist(0, {'winid':0}), 'winid', 0))
        return GetPrefix() . ":lclose\<cr>"
    endif

    return "\<ESC>"
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

fun! XClearDefaultKeys()
    let l:keyboard_keys = ['<space>', 'q', 'w', 'e', 'r', 't', 'y', 'u', 'i', 'o', 'p', '[', ']', 'a', 's', 'd', 'f', 'g', 'h', 'j', 'k', 'l', ';', 'z', 'x', 'c', 'v', 'b', 'n', 'm', ',', '.', '_', '-', '=', '`', '/', '?', ')', '(', '[', ']', '{', '}', '"', '"']
    let l:keyboard_modif = ['C', 'M', 'S', 'M-S']

    for l:keyboard_key in l:keyboard_keys
        exe 'noremap ' . l:keyboard_key . " <Nop>"
    endfor

    for l:keyboard_modif in l:keyboard_modif
        for l:keyboard_key in l:keyboard_keys
            if (l:keyboard_modif == 'C' && l:keyboard_key == 'M')
                continue
            endif
            if (l:keyboard_modif == 'C' && l:keyboard_key == '[')
                continue
            endif
            if (l:keyboard_modif != 'S')
                exe 'inoremap <' . l:keyboard_modif . '-' . l:keyboard_key . "> <Nop>"
            endif
            exe 'noremap <' . l:keyboard_modif . '-' . l:keyboard_key . "> <Nop>"
        endfor
    endfor
endfun

" Clear
call XClearDefaultKeys()
" Base
call Shortcut("<ESC>", "XClosePanel()", "Close popup panel")
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
call Shortcut("<C-j>", "XJoin()", "Join")
call Shortcut("<C-l>", "XClone()", "Clone")
call Shortcut("<Tab>", "XIndent()", "Indent line")
call Shortcut("<S-Tab>", "XOutdent()", "Outdent line")
" Selection
call Shortcut("<M-s>", "XSmartSelect()", "Smart select")
call Shortcut("<C-S-down>", "XSelectLine('end')", "Select to line end")
call Shortcut("<C-S-up>", "XSelectLine('begin')", "Select to line begin")
call Shortcut("<C-space>", "XSelectBlock()", "Select block")
call Shortcut("<C-a>", "XSelectAll()", "Select all")
call Shortcut("<S-down>", "XSelect('down')", "Select line down")
call Shortcut("<S-up>", "XSelect('up')", "Select line up")
call Shortcut("<S-right>", "XSelect('right')", "Select")
call Shortcut("<S-left>", "XSelect('left')", "Select")
call Shortcut("<M-p>", "XSelectPasted()", "Select pasted")
call Shortcut("<M-l>", "XReselect()", "Reselect")

" Movements
call Shortcut("<M-[>", "XToChanges('prev')", "To prev changes")
call Shortcut("<M-]>", "XToChanges('next')", "To next changes")
call Shortcut("<M-f>", "XSearchInText('next')", "Search in text")
call Shortcut("<M-S-f>", "XSearchInText('prev')", "Backward search in text")
call Shortcut("<M-right>", "XNextFound()", "To next found")
call Shortcut("<M-left>", "XPrevFound()", "To previous found")
call Shortcut("<C-down>", "XLineEnd()", "To end of current line")
call Shortcut("<C-up>", "XLineBegin()", "To begin  of current line")
call Shortcut("<C-right>", "XWordEnd('next')", "To next word")
call Shortcut("<C-left>", "XWordBegin('prev')", "To prev word")
call Shortcut("<M-2>", "XNextError()", "Go to next error")
call Shortcut("<M-3>", "XPrevError()", "Go to prev error")

fun! XSmartTab()
    let l:line = getline('.')
    let l:prevChar = strpart(l:line, col('.') - 2, 1)
    
    if (pumvisible())
        return "\<C-n>"
    endif
    
    if (l:prevChar == " " || col('.') == 1)
        return XIndent()
    endif

    return coc#refresh()
endfun

fun! XSmartSTab()
    let l:line = getline('.')
    let l:prevChar = strpart(l:line, col('.') - 2, 1)
    
    if (pumvisible())
        return "\<C-p>"
    endif

    if (l:prevChar == " " || col('.') == 1)
        return XOutdent()
    endif

    return coc#refresh()
endfun

inoremap <silent> <expr> <Tab> XSmartTab()
inoremap <silent> <expr> <S-Tab> XSmartSTab()

