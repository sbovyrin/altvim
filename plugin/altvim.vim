" TODO:
" - Move lines up and down with ALT+J/K
" execute "set <M-j>=\ej"
" execute "set <M-k>=\ek"
" nnoremap <M-j> :m .+0<CR>==
" nnoremap <M-k> :m .-3<CR>==
" inoremap <M-j> <Esc>:m .+0<CR>==gi
" inoremap <M-k> <Esc>:m .-3<CR>==gi
" vnoremap <M-j> :m '>+0<CR>gv=gv
" vnoremap <M-k> :m '<-3<CR>gv=gv

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

command! -bang -nargs=* Rg
    \ call fzf#vim#grep(
    \   'rg -uu
    \       --smart-case
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

" Editor
" temp normal mode for one command
inoremap <Esc> <C-o>
" command prompt
inoremap <M-`> <C-o>:
noremap <M-`> : 
" save
inoremap <C-s> <cmd>w<cr>
noremap <C-s> <cmd>w<cr>
" quit
inoremap <C-q> <cmd>q!<cr>
noremap <C-q> <cmd>q!<cr>
inoremap <C-w> <cmd>bdelete<cr>
noremap <C-w> <cmd>bdelete<cr>
" copy
inoremap <silent> <C-c> <cmd>call altvim#copy()<cr>
noremap <silent> <C-c> <cmd>call altvim#copy()<cr>
" paste
inoremap <silent> <C-v> <cmd>call altvim#paste()<cr>
noremap <silent> <C-v> <cmd>call altvim#paste()<cr>
" cut
inoremap <silent> <C-x> <cmd>norm! "0d<cr>
noremap <silent> <C-x> "0d
" undo
inoremap <silent> <C-z> <cmd>undo<cr>
noremap <silent> <C-z> <cmd>undo<cr>
" redo
inoremap <silent> <M-z> <cmd>redo<cr>
noremap <silent> <M-z> <cmd>redo<cr>
" show last change
inoremap <M-BS> <cmd>norm! g;<cr>
" open a file/s
inoremap <silent> <C-e> <C-o>:exe 'ProjectFiles'<cr>
noremap <silent> <C-e> :<C-u>exe 'ProjectFiles'<cr>
" switch opened files
inoremap <silent> <C-r> <C-o>:exe 'Buffers'<cr>
noremap <silent> <C-r> :<C-u>exe 'Buffers'<cr>
" show history files
inoremap <silent> <C-h> <C-o>:exe 'History'<cr>
noremap <silent> <C-h> :<C-u>exe 'History'<cr>
" find in file
inoremap <silent> <C-f> <C-o>:exe 'BLines'<cr>
noremap <silent> <C-f> :<C-u>exe 'BLines'<cr>
" find in project files
inoremap <silent> <C-g> <C-o>:exe 'Rg'<cr>
noremap <silent> <C-g> :<C-u>exe 'Rg'<cr>
" show errors
inoremap <silent> <M-1> <cmd>CocList diagnostics<cr>
noremap <silent> <M-1> <cmd>CocList diagnostics<cr>
" record action
inoremap <M-.> <cmd>call altvim#record()<cr>
noremap <M-.> <cmd>call altvim#record()<cr>
" repeat last action
inoremap <silent> <M-a> <C-o>@a
noremap <silent> <M-a> @a

" Selection
" select line
inoremap <silent> <S-down> <C-o>:norm! V<cr>
vnoremap <silent> <S-down> :<C-u>norm! V<cr>
" select char
inoremap <silent> <S-right> <C-o>:norm! v<cr>
inoremap <silent> <S-left> <C-o>:norm! v<cr>
vnoremap <silent> <S-right> :<C-u>norm! v<cr>
vnoremap <silent> <S-left> :<C-u>norm! v<cr>
" select all
inoremap <silent> <C-a> <C-o>:norm! ggVG<cr>
vnoremap <silent> <C-a> :<C-u>norm! ggVG<cr>
" select word
vnoremap <silent> w :<C-u>norm vbpOe<cr>
" select block
vnoremap <silent> b <C-v>
" select last selection
vnoremap <silent> l :<C-u>norm! gv<cr>
" select pasted
vnoremap <silent> p :<C-u>norm! `[v`]<cr>
" select inside square brackets
vnoremap <silent> ] i]
" select square brackets with content
vnoremap <silent> [ a]
" select inside parentheses
vnoremap <silent> } i}
" select parentheses with content
vnoremap <silent> { a}
" select inside brackets
vnoremap <silent> ) i)
" select brackets with content
vnoremap <silent> ( a)
" select inside angle brackets
vnoremap <silent> > i>
" select angle brackets with content
vnoremap <silent> < a>
" select inside tag
vnoremap <silent> t it
" select tag
vnoremap <silent> T at
" select quotes
vnoremap <silent> " i"
" select single quotes
vnoremap <silent> ' i'
" select backward quotes
vnoremap <silent> ` i`


" Motions
" to line begin
inoremap <silent> <C-up> <C-o>:norm! ^<cr>
noremap <C-up> ^
" to line start
inoremap <silent> <C-S-up> <C-o>:norm! 0<cr>
noremap <C-S-up> 0
" to line end
inoremap <silent> <C-down> <C-o>:norm! $<cr>
noremap <C-down> $
" to char/s
inoremap <M-/> <C-o>/
noremap / /
" to next found
inoremap <silent> <M-right> <cmd>norm! n<cr>
noremap <M-right> n
" to prev found
inoremap <silent> <M-left> <cmd>norm! N<cr>
noremap <M-left> N
" to word end
inoremap <silent> <M-e> <C-o>/\(\a\\|\d\)\(\A\\|\n\)\\|\(\l\(\u\\|\d\)\)<cr>
noremap <silent> e /\(\a\\|\d\)\(\A\\|\n\)\\|\(\l\(\u\\|\d\)\)<cr>
" to word start
inoremap <silent> <M-b> <C-o>/\(\(\A\\|\n\)\zs\(\a\\|\d\)\)\\|\(\l\zs\(\u\\|\d\)\)<cr>
noremap <silent> b /\(\(\A\\|\n\)\zs\(\a\\|\d\)\)\\|\(\l\zs\(\u\\|\d\)\)<cr>
" to matched pair
inoremap <silent> <M-,> <cmd>norm! %<cr>
noremap , %

" Operators
" delete
noremap d "_d
" clear
noremap <Space> "_c
" join
noremap j J
" uppercase
noremap U gU
" lowercase
noremap u gu
" format
noremap f :<C-u>call CocActionAsync('formatSelected', visualmode())<cr>
" clone on new line
noremap <silent> c "1y:let @1=join(split(@1, "\n"), "\n")<cr>o<C-o>:norm! "1P<cr>

" indent right
noremap <silent> <Tab> >
" indent left 
inoremap <silent> <S-Tab> <cmd>norm! <<<cr>
noremap <silent> <S-Tab> <
" comment
inoremap <silent> <C-_> <cmd>Commentary<cr>
noremap <silent> <C-_> :<C-u>'<,'>Commentary<cr>
