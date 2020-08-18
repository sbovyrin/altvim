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
set signcolumn=yes
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
set completeopt=menu,menuone,noinsert,noselect
"set omnifunc=lsc#complete#complete

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
endif

" when vim startup auto install altvim plugins if its were not installed
if len(g:altvim_defined_plugins) != len(g:altvim_installed_plugins)
    nohl | call altvim#install_plugins() | bdelete | source $MYVIMRC
endif

" indent-line
let g:indentLine_fileTypeExclude = ['markdown']

" FZF settings
let g:fzf_layout = {'down': '60%'}

" LSP
let g:coc_data_home = g:altvim_dir . 'deps/lsp'
let g:coc_config_home = g:altvim_dir . 'deps/lsp/config'
if exists("g:altvim_lsp")
    let g:coc_node_path = get(g:altvim_lsp, 'nodejs', 'node')
endif
let b:altvim_coc_user_config = {
            \ "npm.binPath": exists("g:altvim_lsp") ? get(g:altvim_lsp, 'npm', 'npm') : 'npm',
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
            \ "signature.target": "echo",
            \ "emmet.showExpandedAbbreviation": v:false,
            \ "coc.preferences.hoverTarget": "echo",
            \ "coc.preferences.extensionUpdateCheck": "never"
            \ }

" TODO:
" - Select last pasted
" - Go to a block
" - Go to paired %
" - Clone line
" - Replace
" - Remember cursor position
" augroup vimrc-remember-cursor-position
"   autocmd!
"     autocmd BufReadPost * if line("'\"") > 1 && line("'\"") <= line("$")
        "| exe "normal! g`\"" | endif
" augroup END

" Editor
" command prompt
inoremap <A-`> <C-o>:
vnoremap <A-`> :
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
" go to last change
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
" go to next error
inoremap <A-1> <cmd>call CocActionAsync('diagnosticNext')<cr>
vnoremap <A-1> <cmd>call CocActionAsync('diagnosticNext')<cr>
" go to prev error
inoremap <A-!> <cmd>call CocActionAsync('diagnosticPrevious')<cr>
vnoremap <A-!> <cmd>call CocActionAsync('diagnosticPrevious')<cr>


" Selection
" select line
inoremap <A-S> <C-o>:norm! V<cr>
vnoremap <A-S> :<C-u>norm! V<cr>
" select char
inoremap <A-s> <C-o>:norm! v<cr>
vnoremap <A-s> :<C-u>norm! v<cr>
" select all
inoremap <A-s><A-a> <C-o>:norm! ggVG<cr>
vnoremap <A-s><A-a> :<C-u>norm! ggVG<cr>
" select word
inoremap <A-s><A-w> <C-o>:norm vbpOe<cr>
vnoremap <A-s><A-w> n
" select block
inoremap <A-s><A-b> <C-o>:norm! \<C-v><cr>
vnoremap <A-s><A-b> :<C-u>norm! \<C-v><cr>
" select last selection
inoremap <A-s><A-l> <C-o>:norm gv<cr>
vnoremap <A-s><A-l> :<C-u>norm! gv<cr>

" ctrl+O only one command
" ctrl+L command sequence
" visual mode
" - v<count>[<motions...>]<action>

" Motions
" to line begin
inoremap <C-up> <cmd>norm! ^<cr>
noremap <C-up> ^
" to line start
inoremap <C-S-up> <cmd>norm! 0<cr>
noremap <C-S-up> 0
" to line end
inoremap <C-down> <cmd>norm! $<cr>
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
" word end
inoremap <A-e> <C-o>/\(\a\\|\d\)\(\A\\|\n\)\\|\(\l\(\u\\|\d\)\)<cr>
noremap e /\(\a\\|\d\)\(\A\\|\n\)\\|\(\l\(\u\\|\d\)\)<cr>
" word start
inoremap <A-b> <C-o>/\(\(\A\\|\n\)\zs\(\a\\|\d\)\)\\|\(\l\zs\(\u\\|\d\)\)<cr>
noremap b /\(\(\A\\|\n\)\zs\(\a\\|\d\)\)\\|\(\l\zs\(\u\\|\d\)\)<cr>
" next word
inoremap <C-right> <C-o>/\(\a\\|\d\)\(\A\\|\n\)\\|\(\l\(\u\\|\d\)\)<cr>
" prev word
inoremap <C-left> <C-o>?\(\(\A\\|\n\)\zs\(\a\\|\d\)\)\\|\(\l\zs\(\u\\|\d\)\)<cr>

" Operators
" delete
noremap d d
" join
noremap j J
" uppercase
noremap U gU
" lowercase
noremap u gu
" format
noremap f <cmd>call CocActionAsync('formatSelected', visualmode())<cr>

" indent right
inoremap <Tab> <cmd>norm! ><cr>
vnoremap <Tab> >
" indent left
inoremap <S-Tab> <cmd>norm! <<cr>
vnoremap <S-Tab> <
" comment
inoremap <C-_> <cmd>Commentary<cr>
vnoremap <C-_> :<C-u>'<,'>Commentary<cr>
