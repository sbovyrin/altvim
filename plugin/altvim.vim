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
" disable syntax highlight for long lines
set synmaxcol=300
" faster linting
set updatetime=1000
" hide bakcground buffer
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
set t_Co=256 termguicolors
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
set statusline=%#StatusLineNC#%m%r\ %.60F\ %y\ %{&fenc}%=Col:\ %c\ \|\ Line:\ %l/%L

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

" FZF settings
let g:fzf_layout = {'down': '60%'}

" LSP
if exists("g:plugs") && has_key(g:plugs, "coc.nvim")
    let g:coc_data_home = g:altvim_dir . 'deps/lsp'
    let g:coc_config_home = g:altvim_dir . 'deps/lsp/config'
    
    if exists("g:altvim_lsp")
        let g:coc_node_path = get(g:altvim_lsp, 'nodejs', 'node')
    endif
    
    let g:coc_user_config = {
        \ "npm.binPath": exists("g:altvim_lsp") ? get(g:altvim_lsp, 'npm', 'npm') : 'npm',
        \ "coc.source.buffer.ignoreGitignore": v:false,
        \ "suggest.autoTrigger": "always",
        \ "suggest.floatEnable": v:false,
        \ "suggest.maxCompleteItemCount": 7,
        \ "suggest.preferCompleteThanJumpPlaceholder": v:true,
        \ "suggest.minTriggerInputLength": 3,
        \ "suggest.noselect": v:false,
        \ "suggest.removeDuplicateItems": v:true,
        \ "suggest.snippetIndicator": "",
        \ "signature.target": "echo",
        \ "signature.messageTarget": "echo",
        \ "diagnostic.checkCurrentLine": v:true,
        \ "diagnostic.enableMessage": "jump",
        \ "diagnostic.messageTarget": "echo",
        \ "diagnostic.refreshOnInsertMode": v:true,
        \ "diagnostic.refreshAfterSave": v:true,
        \ "diagnostic.signOffset": 9999999,
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

" function! StatusDiagnostic() abort
"     let info = get(b:, 'coc_diagnostic_info', {})
"     if empty(info) | return '' | endif
"     let msgs = []
"     if get(info, 'error', 0)
"         call add(msgs, 'E' . info['error'])
"     endif
"     if get(info, 'warning', 0)
"         call add(msgs, 'W' . info['warning'])
"     endif
"     return join(msgs, ' '). ' ' . get(g:, 'coc_status', '')
" endfunction
" " Then add %{StatusDiagnostic()} ` to your 'statusline' option.


" Editor
" command prompt
inoremap <A-`> <C-o>:
vnoremap <A-`> :
" temp normal mode for one command
inoremap <Esc> <C-o>
" save
inoremap <C-s> <cmd>w<cr>
vnoremap <C-s> <cmd>w<cr>
" quit
inoremap <C-q> <cmd>q!<cr>
vnoremap <C-q> <cmd>q!<cr>
inoremap <C-w> <cmd>bdelete<cr>
vnoremap <C-w> <cmd>bdelete<cr>
" copy
inoremap <C-c> <cmd>call altvim#copy()<cr>
vnoremap <C-c> <cmd>call altvim#copy()<cr>
" paste
inoremap <C-v> <cmd>call altvim#paste()<cr>
vnoremap <C-v> <cmd>call altvim#paste()<cr>
" cut
inoremap <C-x> <cmd>norm! "0d<cr>
vnoremap <C-x> "0d
" undo
inoremap <C-z> <cmd>undo<cr>
vnoremap <C-z> <cmd>undo<cr>
" redo
inoremap <A-z> <cmd>redo<cr>
vnoremap <A-z> <cmd>redo<cr>
" show last change
inoremap <A-BS> <cmd>norm! g;<cr>
" open a file/s
inoremap <C-e> <C-o>:exe 'ProjectFiles'<cr>
vnoremap <C-e> :<C-u>exe 'ProjectFiles'<cr>
" switch opened files
inoremap <C-r> <C-o>:exe 'Buffers'<cr>
vnoremap <C-r> :<C-u>exe 'Buffers'<cr>
" show history files
inoremap <C-h> <C-o>:exe 'History'<cr>
vnoremap <C-h> :<C-u>exe 'History'<cr>
" find in file
inoremap <C-f> <C-o>:exe 'BLines'<cr>
vnoremap <C-f> :<C-u>exe 'BLines'<cr>
" find in project files
inoremap <C-g> <C-o>:exe 'Rg'<cr>
vnoremap <C-g> :<C-u>exe 'Rg'<cr>
" show errors
inoremap <A-1> <cmd>CocList diagnostics<cr>
vnoremap <A-1> <cmd>CocList diagnostics<cr>
" record action
inoremap <A-.> <cmd>call altvim#record()<cr>
noremap <A-.> <cmd>call altvim#record()<cr>
" repeat last action
inoremap <A-a> <C-o>@a
noremap <A-a> @a

" Selection
" select line
inoremap <S-down> <C-o>:norm! V<cr>
noremap <S-down> :<C-u>norm! V<cr>
" select char
inoremap <S-right> <C-o>:norm! v<cr>
inoremap <S-left> <C-o>:norm! v<cr>
noremap <S-right> :<C-u>norm! v<cr>
noremap <S-left> :<C-u>norm! v<cr>
" select all
inoremap <C-a> <C-o>:norm! ggVG<cr>
vnoremap <C-a> :<C-u>norm! ggVG<cr>
" select word
inoremap <S-up>w <C-o>:norm vbpOe<cr>
noremap <S-up>w :<C-u>norm vbpOe<cr>
" select block
inoremap <S-up>b <C-o>:norm! <C-v><C-v><cr>
noremap <S-up>b <C-v>
" select last selection
inoremap <S-up>l <C-o>:norm! gv<cr>
vnoremap <S-up>l :<C-u>norm! gv<cr>
" select pasted
inoremap <S-up>p <C-o>:norm! `[v`]<cr>
vnoremap <S-up>p :<C-u>norm! `[v`]<cr>
" select inside square brackets
inoremap <S-up>] <C-o>:norm! vi]<cr>
vnoremap <S-up>] i]
" select square brackets with content
inoremap <S-up>[ <C-o>:norm! va]<cr>
vnoremap <S-up>[ a]
" select inside parentheses
inoremap <S-up>} <C-o>:norm! vi}<cr>
vnoremap <S-up>} i}
" select parentheses with content
inoremap <S-up>{ <C-o>:norm! va}<cr>
vnoremap <S-up>{ a}
" select inside brackets
inoremap <S-up>) <C-o>:norm! vi)<cr>
vnoremap <S-up>) i)
" select brackets with content
inoremap <S-up>( <C-o>:norm! va)<cr>
vnoremap <S-up>( a)

" select inside angle brackets
inoremap <S-up>> <C-o>:norm! vi><cr>
vnoremap <S-up>> i>
" select angle brackets with content
inoremap <S-up>< <C-o>:norm! va><cr>
vnoremap <S-up>< a>
" select inside tag
inoremap <S-up>t <C-o>:norm! vit<cr>
vnoremap <S-up>t it
" select tag
inoremap <S-up>T <C-o>:norm! vat<cr>
vnoremap <S-up>T at
" select quotes
inoremap <S-up>" <C-o>:norm! vi"<cr>
vnoremap " i"
" select single quotes
inoremap <S-up>' <C-o>:norm! vi'<cr>
vnoremap ' i'
" select backward quotes
inoremap <S-up>` <C-o>:norm! vi`<cr>
vnoremap ` i`


" Motions
" to N line
noremap <A-g> G
" to line begin
inoremap <C-up> <C-o>:norm! ^<cr>
noremap <C-up> ^
" to line start
inoremap <C-S-up> <C-o>:norm! 0<cr>
noremap <C-S-up> 0
" to line end
inoremap <C-down> <C-o>:norm! $<cr>
noremap <C-down> $
" to char/s
inoremap <A-/> <C-o>/
noremap / /
" to next found
inoremap <A-n> <cmd>norm! n<cr>
noremap n n
" to prev found
inoremap <A-p> <cmd>norm! N<cr>
noremap p N
" to word end
inoremap <A-e> <C-o>/\(\a\\|\d\)\(\A\\|\n\)\\|\(\l\(\u\\|\d\)\)<cr>
noremap e /\(\a\\|\d\)\(\A\\|\n\)\\|\(\l\(\u\\|\d\)\)<cr>
" to word start
inoremap <A-b> <C-o>/\(\(\A\\|\n\)\zs\(\a\\|\d\)\)\\|\(\l\zs\(\u\\|\d\)\)<cr>
noremap b /\(\(\A\\|\n\)\zs\(\a\\|\d\)\)\\|\(\l\zs\(\u\\|\d\)\)<cr>
" to next word
inoremap <C-right> <C-o>/\(\a\\|\d\)\(\A\\|\n\)\\|\(\l\(\u\\|\d\)\)<cr>
" to prev word
inoremap <C-left> <C-o>?\(\(\A\\|\n\)\zs\(\a\\|\d\)\)\\|\(\l\zs\(\u\\|\d\)\)<cr>
" to matched pair
inoremap <A-,> <cmd>norm! %<cr>
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
noremap f <Plug>(coc-format-selected)
" noremap f <cmd>call CocActionAsync('formatSelected', visualmode())<cr>
" clone on new line
noremap c "1y:let @1=join(split(@1, "\n"), "\n")<cr>o<C-o>:norm! "1P<cr>

" indent right
vnoremap <Tab> >
" indent left 
inoremap <S-Tab> <cmd>norm! <<<cr>
vnoremap <S-Tab> <
" comment
inoremap <C-_> <cmd>Commentary<cr>
vnoremap <C-_> :<C-u>'<,'>Commentary<cr>

" nnoremap <silent> K <cmd>call <SID>show_documentation()<cr>
