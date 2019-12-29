" lmbd functions 
" fun! altvim#_reduce(fn, xs, ...)
"     let l:xs = deepcopy(a:xs)
"     let l:acc = get(a:, 1, l:xs[0])
    
"     for l:Value in (l:acc == l:xs[0] ? l:xs[1:] : l:xs[0:])
"         let l:acc = a:fn(l:acc, l:Value)
"     endfor
    
"     return l:acc
" endfun

" fun! altvim#reduce(...)
"     let l:Reduce = altvim#curry(3, function('altvim#_reduce'))
"     return function(l:Reduce, a:000)
" endfun

" fun! altvim#map(...)
"     let l:Map = altvim#curry(2, function({fn, xs -> map(deepcopy(xs), {k, v -> fn(v)})}))
"     return function(l:Map, a:000)
" endfun

" fun! altvim#filter(...)
"     let l:Filter = altvim#curry(2, function({fn, xs -> filter(deepcopy(xs), {k, v -> fn(v)})}))
"     return function(l:Filter, a:000)
" endfun

" fun! altvim#_curry(ar, fn, args)
"     let l:ar = a:ar
"     let l:Fn = a:fn
"     let l:args = a:args
    
"     return {-> len(l:args + a:000) < l:ar ? altvim#_curry(l:ar, l:Fn, l:args + a:000) : call(l:Fn, l:args + a:000)}
" endfun

" fun! altvim#curry(ar, fn)
"     return altvim#_curry(a:ar, a:fn, [])
" endfun

" fun! altvim#compose(...)
"     let l:fns = reverse(copy(a:000))
"     return {initV -> altvim#reduce({arg, fn -> fn(arg)}, l:fns, initV)}
" endfun

" fun! altvim#sum(x, y)
"     return a:x + a:y
" endfun

" fun! altvim#sqr(x)
"     return a:x * a:x
" endfun

" echo altvim#curry(2, function('altvim#sum'))(1)(2)
" echo altvim#curry(2, function('altvim#map'))(function('altvim#sqr'))([1,2,3])
" echo altvim#map(function('altvim#sqr'))

" echo altvim#compose(
" \   function('altvim#sqr'), 
" \   altvim#curry(function('altvim#sum'), 3)
" \)(2)

" Utils
fun! altvim#remember_cursor_pos() abort
    let l:cur_pos = getcurpos()
    let @p = l:cur_pos[1] . ':' . l:cur_pos[2]
endfun

fun! altvim#restore_cursor_pos() abort
    let l:cur_pos = split(@p, ':')
    call setpos('.', [0, l:cur_pos[0], l:cur_pos[1], 0])
endfun

fun! altvim#apply_to_range(fn, range) abort
    exe a:range .'g/^/' . a:fn
endfun

" -> number
fun! altvim#count_selected_lines() abort
    return g:altvim#is_selection ? (line("'>") - line("'<") + 1) : 1
endfun

" -> list
fun! altvim#get_selected_line_numbers() abort
    return range(a:firstline, a:firstline + altvim#count_selected_lines() - 1)
endfun

" -> string
fun! altvim#get_selected_line_range() abort
    let l:line_numbers = altvim#get_selected_line_numbers()
    return get(l:line_numbers, 0) . ',' . get(l:line_numbers, -1, '')
endfun

fun! altvim#get_selection() abort
    normal! gv
endfun

" -> string
fun! altvim#get_selected_content() abort
    call altvim#get_selection()
    normal! "xy
    return @x
endfun


" Features

"" Selecting
fun! altvim#select_line() abort
    normal! V
endfun

"" Formatting
fun! altvim#format_editor() abort
    let l:selected_lines = altvim#count_selected_lines()
    if l:selected_lines > 1 
        call altvim#apply_to_range('normal! gqqgv=', altvim#get_selected_line_range())
    else
        normal! gv=gvgq
    endif
endfun

fun! altvim#format_lang() abort
    if index(g:altvim#installed_plugins, 'coc.nvim') > 0
        " if !g:altvim#is_selection
        "     call altvim#select_line()
        " endif

        call CocActionAsync('formatSelected', visualmode())
    endif
endfun

" *
fun! altvim#format() abort
    call altvim#format_editor()
    call altvim#format_lang()
    call altvim#restore_cursor_pos()
endfun

" Deleting
fun! altvim#delete() abort
    normal! "xc
endfun

" *
function! altvim#delete_line() abort
    call altvim#apply_to_range(
        \ 'call altvim#select_line() | call altvim#delete() | normal! dd',
        \ altvim#get_selected_line_range()
    \ )
    call altvim#format()
endfunction

" *
function! altvim#clear_line() abort
    call altvim#get_selection()
    call altvim#delete()
    call altvim#format()
endfunction


""""
function! altvim#select_word() abort
    let l:currSymbol = getline('.')[col('.') - 1]
    let l:prevSymbol = getline('.')[col('.') - 2]

    let l:condition =  (matchstr(l:prevSymbol, '\w') != '' && matchstr(l:currSymbol, '\w') != '')
    let l:condition =  (matchstr(l:prevSymbol, '\w') != '' && matchstr(l:currSymbol, '\w') != '')

    exe 'normal! ' . (l:condition ? 'bv' : 'v') . 'e'
endfunction

" Replace found results
function! altvim#replace_found(...) abort
    exe "cdo s/" . a:1 . "/ge | :silent nohl | :silent only"
endfunction

function! altvim#clone_line() abort
    let l:lineCount = g:altvim#is_selection ? (line("'>") - line("'<") + 1) : 1

    if g:altvim#is_selection
        normal! gv
    else
        normal! ^v$
    endif

    normal! "cyO
    normal! S
    let @c = substitute(@c, '\n\+$', '', '')
    let @c = substitute(@c, '^\s*', '', '')
    normal! "cp==
    call cursor([line('.') + l:lineCount, 0, 0, 0])
    normal! ^
endfunction

" Copy function that implement multiclipboard
function! altvim#_copy() abort
    let @0 = substitute(@0, '\n\+$', '', '')
    let @0 = substitute(@0, '^\s*', '', '')
    let @+ = @0
    
    let l:multiclipboard = [@0] + (empty(@e) ? [] : eval(@e))
    let @e = string(l:multiclipboard[:4])
endfunction

" Improved copy
function! altvim#copy() abort
    normal! gvy
    call altvim#_copy()
endfunction

" Simple paste
function! altvim#paste() abort
    let l:currCol = getcurpos()[4]
    let l:lastCol = col('$')
    
    if l:currCol >= l:lastCol 
        normal! p==g;
    else
        normal! P==g;
    endif
endfunction

" Improved cut
function! altvim#cut() abort
    normal! gv"0d
    call altvim#_copy()
endfunction

" Activate multiclipboard (show last 5 copied items)
function! altvim#multiclipboard() abort
    call fzf#vim#complete({ 'source': (empty(@e) ? [] : eval(@e)), 'down': 10 })
endfunction

" Select a line/char
function! altvim#select(type) abort
    let l:isFirstSelection = line("'>") - line("'<")
    let l:cmd = ''
    let l:direction = ''
    
    if a:type =~ 'line' && !g:altvim#is_selection
        let l:cmd = '^v$'
    elseif a:type =~ 'char' && !g:altvim#is_selection
        let l:cmd = 'v'
    elseif g:altvim#is_selection

        if !l:isFirstSelection && a:type =~ 'line'
            let l:cmd = (a:type =~ 'next' ? '^v$' : '$v^')
        else
            let l:cmd = 'gv'
        endif

        if a:type == 'nextchar'
            let l:direction = 'l'
        elseif a:type == 'prevchar'
            let l:direction = 'h'
        elseif a:type == 'nextline'
            let l:direction = 'j'
        elseif a:type == 'prevline'
            let l:direction = 'k'
        endif

        if l:direction == '' | return | endif

        let l:cmd = l:cmd . v:count1 . l:direction
    endif
    
    if l:cmd == '' | return | endif
    
    exec 'normal! ' . l:cmd
endfunction


" Go to start of specific char
function! altvim#goto_char(mode) abort
    if a:mode == 'first'
        let b:altvimJumpToChar = nr2char(getchar()) . nr2char(getchar())
    endif
    
    let l:searchFlag = a:mode == 'prev' ? 'b' : ''

    let [l:lineNumber, l:pos] = searchpos(get(b:, 'altvimJumpToChar', ''), l:searchFlag)
    
    if g:altvim#is_selection
        call setpos(a:mode == 'prev' ? "'<" : "'>", [0, l:lineNumber, l:pos])
        normal! gv
    endif
endfunction

" Get all filetypes that vim knows
function! altvim#get_known_filetypes() abort
    return map(split(globpath(&rtp, 'ftplugin/*.vim'), '\n'), 'fnamemodify(v:val, ":t:r")')
endfunction

function! altvim#set_hotkey(...) abort
    let l:args = split(a:1, ' = ')

    if len(l:args) < 2
        echoerr "[Error: altvim#set_hotkey] You must pass 2 args (key, action)"
        return
    endif

    let l:key = l:args[0]
    let l:actions = map(split(l:args[1], ','), 'substitute(v:val, "^\s*", "", "")')

    let l:naction = get(l:actions, 0) == '_' ? '' : get(l:actions, 0)
    let l:vaction = get(l:actions, 1)
        
    if l:naction == ':'
        exec 'inoremap ' . l:key . ' <C-o>' . l:naction
        exec 'vnoremap ' . l:key . ' ' . l:naction
    elseif empty(l:naction) && !empty(l:vaction)
        exec 'vnoremap ' . l:key . ' :<C-u>let g:altvim#is_selection=1 \| call altvim#remember_cursor_pos() \| ' . l:vaction . '<CR>'
    elseif !empty(l:naction) && empty(l:vaction)
        exec 'inoremap ' . l:key . ' <C-o>:let g:altvim#is_selection=0 \| call altvim#remember_cursor_pos() \| ' . l:naction . '<CR>'
        exec 'vnoremap ' . l:key . ' :<C-u>let g:altvim#is_selection=1 \| call altvim#remember_cursor_pos() \| ' . l:naction . '<CR>'
    else
        exec 'inoremap ' . l:key . ' <C-o>:let g:altvim#is_selection=0 \| call altvim#remember_cursor_pos() \| ' . l:naction . '<CR>'
        exec 'vnoremap ' . l:key . ' :<C-u>let g:altvim#is_selection=1 \| call altvim#remember_cursor_pos() \| ' . l:vaction . '<CR>'
    endif
endfunction

function! altvim#save() abort
    exec 'w'
endfunction

function! altvim#quit() abort
    exec 'q!'
endfunction

function! altvim#close_file() abort
    exec 'bdelete'
endfunction

function! altvim#undo() abort
    normal! u
endfunction

function! altvim#redo() abort
    exec 'redo'
endfunction

function! altvim#repeat_last_action() abort
    normal! .
endfunction
        
function! altvim#indent() abort
    normal! gv>gv
endfunction

function! altvim#outdent() abort
    normal! gv<gv
endfunction

function! altvim#join_lines() abort
    if g:altvim#is_selection
        call altvim#get_selection()
    endif

    normal! J
endfunction

function! altvim#replace() abort
    let l:input = input('Replace: ')
    if empty(l:input) | return | endif

    exec 'ReplaceFound ' . l:input
endfunction     

function! altvim#goto_last_change() abort
    normal! g;
endfunction

function! altvim#scroll_page(direction) abort
    if a:direction == 'up'
        let l:cmd = 'zb'
    elseif a:direction == 'down'
        let l:cmd = 'zt'
    endif
    
    if empty(l:cmd) | return | endif

    exec 'normal! ' . l:cmd
endfunction

function! altvim#select_last_selection() abort
    normal! gv
endfunction

function! altvim#select_all() abort
    normal! ggVGg
endfunction

function! altvim#select_content(type, scope) abort
    if a:scope == 'parentheses'
        let l:cmd = '('
    elseif a:scope == 'braces'
        let l:cmd = '{'
    elseif a:scope == 'square_brackets'
        let l:cmd = '['
    elseif a:scope == 'tag'
        let l:cmd = 't'
    elseif a:scope == 'lessthan'
        let l:cmd = '<'
    elseif a:scope == 'double_quotes'
        let l:cmd = '"'
    elseif a:scope == 'single_quotes'
        let l:cmd = "'"
    elseif a:scope == 'back_quotes'
        let l:cmd = '`'
    endif
    
    if empty(l:cmd) | return | endif

    exec 'normal! gv' . a:type . l:cmd
endfunction

function! altvim#select_content_within(scope) abort
    call altvim#select_content('i', a:scope)
endfunction

function! altvim#select_content_within_included(scope) abort
   call altvim#select_content('a', a:scope)
endfunction

function! altvim#move_line(direction) abort
    if g:altvim#is_selection && a:direction == 'up'
        exec "'<,'>move '<-2"
    elseif g:altvim#is_selection && a:direction == 'down'
        exec "'<,'>move '>+"
    elseif a:direction == 'up'
        exec 'move-2'
    elseif a:direction == 'down'
        exec 'move+'
    else
        return
    endif

    if g:altvim#is_selection
        normal! gv=gv
    else
        normal! ==
    endif
endfunction

function! altvim#goto_line_begin() abort
    if g:altvim#is_selection
        normal! gv
    endif

    normal! ^
endfunction

function! altvim#goto_line_end() abort
    if g:altvim#is_selection
        normal! gv
    endif

    normal! $
endfunction

function! altvim#goto_next_word() abort
    if g:altvim#is_selection
        normal! gve
    else
        normal! w
    endif
endfunction

function! altvim#goto_prev_word() abort
    if g:altvim#is_selection
        normal! gv
    endif

    normal! b
endfunction

function! altvim#show_project_symbols() abort
    exec 'CocList -I symbols'
endfunction

function! altvim#show_file_symbols() abort
    exec 'CocList outline'
endfunction

function! altvim#show_problems() abort
    exec 'CocList diagnostics'
endfunction

function! altvim#goto_next_problem() abort
    call CocActionAsync('diagnosticNext')
endfunction

function! altvim#goto_prev_problem() abort
    call CocActionAsync('diagnosticPrevious')
endfunction

function! altvim#find_project_files() abort
    exec 'Files'
endfunction

function! altvim#show_open_files() abort
    exec 'Buffers'
endfunction

function! altvim#find_in_file() abort
    exec 'BLines'
endfunction

function! altvim#find_in_project_files() abort
    exec 'Ag'
endfunction

function! altvim#show_recent_files() abort
    exec 'History'
endfunction

function! altvim#toggle_comment() abort
    if g:altvim#is_selection
        exec "'<,'>Commentary"
    else
        exec 'Commentary'
    endif
endfunction
