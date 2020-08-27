silent !stty -ixon

" disable back-compatibility with Vi
set nocompatible
" watch file outside changing
set autoread
" enable auto filetype determination 
" and autoloading appropriated plugins for the filetype
filetype plugin indent on
" syntax highlighting
syntax enable
" faster linting
set updatetime=2000
" hide background buffer
set hidden
" disable report on line changing
set report=0
" enable lazy editor redraw
set lazyredraw
" enable magic regex patterns
set magic
" permanent insert mode by default
set insertmode
" default editor encoding
set encoding=utf-8
" copy, cut to '0' register
set clipboard=unnamedplus
" disable creating a backup files
set nobackup
" disable swap file
set noswapfile
" keep 50 commands in history
set history=50

" indent a new line as prev line
set autoindent
" indent after C-lang blocks
set smartindent
" visually break a long line to next line and keep indent
set breakindent
" add 2 indent to breakindented line
set breakindentopt=shift:2,min:80
" tab to space
set expandtab
" set tab length (4 spaces)
set shiftwidth=4
set tabstop=4
" round indent to shiftwidth value
set shiftround
" text wrap
set whichwrap+=<,>,[,]

" disable break lines after one-letter word
set formatoptions+=1
" disable auto-wrap text
set formatoptions-=t
" remove comment leader when joining lines
set formatoptions+=j

" add only one space with join command
set nojoinspaces

" show found while typing in search
set incsearch
" ignore case sensitivity
set ignorecase
" if word has only lowercase, search lowercase, etc.
set smartcase
" search around the end of the file
set wrapscan
" highlight search only while typing
augroup vimrc-incsearch-highlight
        autocmd!
        autocmd CmdlineEnter /,\? :set hlsearch
        autocmd CmdlineLeave /,\? :set nohlsearch
augroup END

" show matched pairs
set showmatch
" add < > to pairs highlighting
set matchpairs+=<:>

" show incomplete command in the lower right corner
set showcmd
" hide mode info
set noshowmode
" hide cursor info
set noruler
" number of lines to use for the command-line
set cmdheight=1
" show line numbers
set number
" show signs at editor gutter
set signcolumn=yes:2
" highlight current line
set cursorline
" disable folding
set nofoldenable
" show statusline
set laststatus=2
" hide mode status
set nomodeline
" support advanced colors
set termguicolors
" change cursor to block
set guicursor=a:block-blinkoff0

" command line completion by <Tab>
set wildmenu 
" set command line compleltion mode
set wildmode=longest:full,full

" set autocomplete engine and options
" set completeopt=menu,menuone,noinsert,noselect
" set omnifunc=lsc#complete#complete

" set editor message format
set shortmess+=c

" configure statusline
set statusline=%#StatusLineNC#%m%{altvim#lsp_status()}%r\ %.60F\ %y\ %{&fenc}%=Col:\ %c\ \|\ Line:\ %l/%L

" disable netrw directory listing on startup
let loaded_netrw = 0


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
            \   {'options' : ['--preview', 'head -40 {}'], 'down': '100%'})"
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
            \   {'options' : ['--preview', 'head -10 {}']},
            \   <bang>0
            \ )


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

" FZF settings
let g:fzf_layout = {'down': '60%'}

"diagnostic.refreshOnInsertMode": v:true,
"diagnostic.refreshAfterSave": v:true,

" LSP
if exists("g:plugs") && has_key(g:plugs, "coc.nvim")
    let g:coc_data_home = g:altvim_dir . 'deps/lsp'
    let g:coc_config_home = g:altvim_dir . 'deps/lsp/config'
    
    if exists("g:altvim_lsp")
        let g:coc_node_path = get(g:altvim_lsp, 'nodejs', 'node')
    endif
    
    let g:coc_user_config = {
        \ "npm.binPath": exists("g:altvim_lsp") ? get(g:altvim_lsp, 'npm', 'npm') : 'npm',
        \ "suggest.autoTrigger": "always",
        \ "suggest.floatEnable": v:false,
        \ "suggest.maxCompleteItemCount": 7,
        \ "suggest.minTriggerInputLength": 3,
        \ "suggest.noselect": v:false,
        \ "suggest.snippetIndicator": "",
        \ "signature.target": "echo",
        \ "signature.messageTarget": "echo",
        \ "diagnostic.messageTarget": "echo",
        \ "diagnostic.warningSign": ">",
        \ "diagnostic.errorSign": "*",
        \ "diagnostic.infoSign": "?",
        \ "diagnostic.hintSign": "#",
        \ "coc.preferences.hoverTarget": "echo",
        \ "coc.preferences.bracketEnterImprove": v:false,
        \ "coc.preferences.snippets.enable": v:false,
        \ "coc.preferences.extensionUpdateCheck": "never",
        \ "emmet.showExpandedAbbreviation": v:false,
        \ "emmet.includeLanguages": ["html", "javascript", "javascriptreact", "php"],
        \ "emmet.excludeLanguages": [],
        \ "codeLens.enable": v:false
    \ }

    highlight CocErrorHighlight ctermfg=Red  guifg=#ff0000
endif

" TODO:
" - move lines up and down with ALT+J/K
" execute "set <M-j>=\ej"
" execute "set <M-k>=\ek"
" nnoremap <M-j> :m .+1<CR>==
" nnoremap <M-k> :m .-2<CR>==
" inoremap <M-j> <Esc>:m .+1<CR>==gi
" inoremap <M-k> <Esc>:m .-2<CR>==gi
" vnoremap <M-j> :m '>+1<CR>gv=gv
" vnoremap <M-k> :m '<-2<CR>gv=gv


" Hotkeys

" Editor
" temp normal mode for one command
inoremap <Esc> <C-o>
" command prompt
inoremap <C-Bslash> <C-o>:
vnoremap <C-Bslash> : 
" save
inoremap <C-s> <cmd>w<cr>
vnoremap <C-s> <cmd>w<cr>
" quit
inoremap <C-q> <cmd>q!<cr>
vnoremap <C-q> <cmd>q!<cr>
inoremap <C-w> <cmd>bdelete<cr>
vnoremap <C-w> <cmd>bdelete<cr>
" copy
inoremap <silent> <C-c> <cmd>call altvim#copy()<cr>
vnoremap <silent> <C-c> <cmd>call altvim#copy()<cr>
" paste
inoremap <silent> <C-v> <cmd>call altvim#paste()<cr>
vnoremap <silent> <C-v> <cmd>call altvim#paste()<cr>
" cut
inoremap <silent> <C-x> <cmd>norm! "0d<cr>
vnoremap <silent> <C-x> "0d
" undo
inoremap <silent> <C-z> <cmd>undo<cr>
vnoremap <silent> <C-z> <cmd>undo<cr>
" redo
inoremap <silent> <M-z> <cmd>redo<cr>
vnoremap <silent> <M-z> <cmd>redo<cr>
" show last change
inoremap <M-BS> <cmd>norm! g;<cr>
" open a file/s
inoremap <silent> <C-e> <C-o>:exe 'ProjectFiles'<cr>
vnoremap <silent> <C-e> :<C-u>exe 'ProjectFiles'<cr>
" switch opened files
inoremap <silent> <C-r> <C-o>:exe 'Buffers'<cr>
vnoremap <silent> <C-r> :<C-u>exe 'Buffers'<cr>
" show history files
inoremap <silent> <C-h> <C-o>:exe 'History'<cr>
vnoremap <silent> <C-h> :<C-u>exe 'History'<cr>
" find in file
inoremap <silent> <C-f> <C-o>:exe 'BLines'<cr>
vnoremap <silent> <C-f> :<C-u>exe 'BLines'<cr>
" find in project files
inoremap <silent> <C-g> <C-o>:exe 'Rg'<cr>
vnoremap <silent> <C-g> :<C-u>exe 'Rg'<cr>
" show errors
inoremap <silent> <M-1> <cmd>CocList diagnostics<cr>
vnoremap <silent> <M-1> <cmd>CocList diagnostics<cr>
" record action
inoremap <M-.> <cmd>call altvim#record()<cr>
noremap <M-.> <cmd>call altvim#record()<cr>
" repeat last action
inoremap <silent> <M-a> <C-o>@a
noremap <silent> <M-a> @a

" Selection
" select line
inoremap <silent> <S-down> <C-o>:norm! V<cr>
noremap <silent> <S-down> :<C-u>norm! V<cr>
" select char
inoremap <silent> <S-right> <C-o>:norm! v<cr>
inoremap <silent> <S-left> <C-o>:norm! v<cr>
noremap <silent> <S-right> :<C-u>norm! v<cr>
noremap <silent> <S-left> :<C-u>norm! v<cr>
" select all
inoremap <silent> <C-a> <C-o>:norm! ggVG<cr>
vnoremap <silent> <C-a> :<C-u>norm! ggVG<cr>
" select word
inoremap <silent> <S-up>w <C-o>:norm vbpOe<cr>
noremap <silent> <S-up>w :<C-u>norm vbpOe<cr>
" select block
inoremap <silent> <S-up>b <C-o>:norm! <C-v><C-v><cr>
noremap <silent> <S-up>b <C-v>
" select last selection
inoremap <silent> <S-up>l <C-o>:norm! gv<cr>
vnoremap <silent> <S-up>l :<C-u>norm! gv<cr>
" select pasted
inoremap <silent> <S-up>p <C-o>:norm! `[v`]<cr>
vnoremap <silent> <S-up>p :<C-u>norm! `[v`]<cr>
" select inside square brackets
inoremap <silent> <S-up>] <C-o>:norm! vi]<cr>
vnoremap <silent> <S-up>] i]
" select square brackets with content
inoremap <silent> <S-up>[ <C-o>:norm! va]<cr>
vnoremap <silent> <S-up>[ a]
" select inside parentheses
inoremap <silent> <S-up>} <C-o>:norm! vi}<cr>
vnoremap <silent> <S-up>} i}
" select parentheses with content
inoremap <silent> <S-up>{ <C-o>:norm! va}<cr>
vnoremap <silent> <S-up>{ a}
" select inside brackets
inoremap <silent> <S-up>) <C-o>:norm! vi)<cr>
vnoremap <silent> <S-up>) i)
" select brackets with content
inoremap <silent> <S-up>( <C-o>:norm! va)<cr>
vnoremap <silent> <S-up>( a)
" select inside angle brackets
inoremap <silent> <S-up>> <C-o>:norm! vi><cr>
vnoremap <silent> <S-up>> i>
" select angle brackets with content
inoremap <silent> <S-up>< <C-o>:norm! va><cr>
vnoremap <silent> <S-up>< a>
" select inside tag
inoremap <silent> <S-up>t <C-o>:norm! vit<cr>
vnoremap <silent> <S-up>t it
" select tag
inoremap <silent> <S-up>T <C-o>:norm! vat<cr>
vnoremap <silent> <S-up>T at
" select quotes
inoremap <silent> <S-up>" <C-o>:norm! vi"<cr>
vnoremap <silent> " i"
" select single quotes
inoremap <silent> <S-up>' <C-o>:norm! vi'<cr>
vnoremap <silent> ' i'
" select backward quotes
inoremap <silent> <S-up>` <C-o>:norm! vi`<cr>
vnoremap <silent> ` i`


" Motions
" to N line
noremap <M-g> G
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
inoremap <silent> <M-n> <cmd>norm! n<cr>
noremap n n
" to prev found
inoremap <silent> <M-p> <cmd>norm! N<cr>
noremap p N
" to word end
inoremap <silent> <M-e> <C-o>/\(\a\\|\d\)\(\A\\|\n\)\\|\(\l\(\u\\|\d\)\)<cr>
noremap <silent> e /\(\a\\|\d\)\(\A\\|\n\)\\|\(\l\(\u\\|\d\)\)<cr>
" to word start
inoremap <silent> <M-b> <C-o>/\(\(\A\\|\n\)\zs\(\a\\|\d\)\)\\|\(\l\zs\(\u\\|\d\)\)<cr>
noremap <silent> b /\(\(\A\\|\n\)\zs\(\a\\|\d\)\)\\|\(\l\zs\(\u\\|\d\)\)<cr>
" to next word
inoremap <silent> <M-right> <C-o>/\(\a\\|\d\)\(\A\\|\n\)\\|\(\l\(\u\\|\d\)\)<cr>
" to prev word
inoremap <silent> <M-left> <C-o>?\(\(\A\\|\n\)\zs\(\a\\|\d\)\)\\|\(\l\zs\(\u\\|\d\)\)<cr>
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
vnoremap <silent> <Tab> >
" indent left 
inoremap <silent> <S-Tab> <cmd>norm! <<<cr>
vnoremap <silent> <S-Tab> <
" comment
inoremap <silent> <C-_> <cmd>Commentary<cr>
vnoremap <silent> <C-_> :<C-u>'<,'>Commentary<cr>
