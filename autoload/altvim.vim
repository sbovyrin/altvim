" lmbd functions
" fun! altvim#_reduce(fn, xs, ...)
"     let l:xs = deepcopy(a:xs)
"     let l:Acc = get(a:, 1, get(l:xs, 0, v:null))
"     let l:xs = type(l:Acc) == type(l:xs[0]) && l:Acc == l:xs[0]
"         \ ? l:xs[1:]
"         \ : l:xs

"     for l:Value in l:xs
"         let l:Acc = a:fn(l:Acc, l:Value)
"     endfor

"     return l:Acc
" endfun

" fun! altvim#_curry(ar, fn, args)
"     let l:ar = a:ar
"     let l:Fn = a:fn
"     let l:args = a:args
    
"     return {
"         \ -> len(l:args + a:000) < l:ar 
"             \ ? altvim#_curry(l:ar, l:Fn, l:args + a:000)
"             \ : call(l:Fn, l:args + a:000)
"     \ }
" endfun

" fun! altvim#curry(ar, fn)
"     return altvim#_curry(a:ar, a:fn, [])
" endfun

" fun! altvim#reduce(...)
"     let l:Reduce = altvim#curry(
"         \ 2,
"         \ function('altvim#_reduce')
"     \ )
    
"     return call(l:Reduce, a:000)
" endfun

" fun! altvim#map(...)
"     let l:Map = altvim#curry(2, function({fn, xs -> map(deepcopy(xs), {k, v -> fn(v)})}))
"     return call(l:Map, a:000)
" endfun

" fun! altvim#filter(...)
"     let l:Filter = altvim#curry(2, function({fn, xs -> filter(deepcopy(xs), {k, v -> fn(k, v)})}))
"     return call(l:Filter, a:000)
" endfun

" fun! altvim#compose(...)
"     let l:fns = reverse(copy(a:000))
"     return {initV -> altvim#reduce({arg, fn -> fn(arg)}, l:fns, initV)}
" endfun

" " Tested functions
" fun! altvim#sum(x, y)
"     return a:x + a:y
" endfun

" fun! altvim#sqr(x)
"     return a:x * a:x
" endfun

" Tests
" " -> [1,4,9]
" echo altvim#map(function('altvim#sqr'), [1,2,3])
" " -> [1,4,9]
" echo altvim#map(function('altvim#sqr'))([1,2,3])
" " -> [3]
" echo altvim#filter(function({k, v -> v > 2}), [1,2,3])
" " -> [3]
" echo altvim#filter(function({k, v -> v > 2}))([1,2,3])
" " -> 6
" echo altvim#reduce(function('altvim#sum'), [1,2,3])
" " -> 8
" echo altvim#reduce(function('altvim#sum'), [1,2,3], 2)
" " -> 6
" echo altvim#reduce(function('altvim#sum'))([1,2,3])
" " -> 6 2 (should be 8)
" echo altvim#reduce(function('altvim#sum'), [1,2,3])(2)
" " -> 6 2 (should be 8)
" echo altvim#reduce(function('altvim#sum'))([1,2,3])(2)
" " -> 13
" echo altvim#compose(
" \   altvim#reduce(function('altvim#sum')),
" \   altvim#filter(function({k, v -> v > 2})),
" \   altvim#map(function('altvim#sqr'))
" \)([1,2,3])




" Utils functions
" -> string
fun! altvim#_listen_keys(number, ...) abort
    let l:input = get(a:, 1, '')
    return a:number == 0 
        \ ? join(map(split(l:input, ','), {k, v -> nr2char(v)}), '')
        \ : altvim#_listen_keys(a:number - 1, l:input .  getchar() . ',')
endfun

" Cursor functions
fun! altvim#_remember_cursor_pos() abort
    let g:altvim#cursor_pos = [line('.'), col('.')] 
endfun

fun! altvim#_set_cursor_pos(line, col) abort
    call setpos('.', [0, a:line, a:col, 0])
endfun

fun! altvim#_restore_cursor_pos() abort
    call altvim#_set_cursor_pos(g:altvim#cursor_pos[0], g:altvim#cursor_pos[1])
endfun

fun! altvim#_get_cursor_pos() abort
    return [line('.'), col('.')]
endfun

" Selection functions
fun! altvim#_select_line() abort
    let g:altvim#is_selection = 1
    normal! V
endfun

fun! altvim#_select_char() abort
    let g:altvim#is_selection = 1
    normal! v
endfun

fun! altvim#_get_lines() abort
    if g:altvim#is_selection
        normal! gv
    else
        call altvim#_select_line()
    endif
endfun

fun! altvim#_get_chars() abort
    if g:altvim#is_selection
        normal! gv
    else
        call altvim#_select_char()
    endif
endfun

fun! altvim#_select_content(type, scope) abort
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

    exe 'normal! gv' . a:type . l:cmd
endfun

fun! altvim#select_content_within(scope) abort
    call altvim#_select_content('i', a:scope)
endfun

fun! altvim#select_content_within_included(scope) abort
    call altvim#_select_content('a', a:scope)
endfun

fun! altvim#select_last_selection() abort
    normal! gv
endfun

fun! altvim#select_till_line_end() abort
    call altvim#_get_chars()
    call altvim#goto_line_end()
endfun

fun! altvim#select_till_line_begin() abort
    call altvim#_get_chars()
    call altvim#goto_line_begin()
endfun

fun! altvim#select_all() abort
    normal! ggVGg
endfun

fun! altvim#select_next_line() abort
    let l:cmd = altvim#_count_selected_lines() > 0
        \ ? 'call altvim#_goto_next_line()' : ''
    call altvim#_get_lines()
    exe l:cmd
endfun

fun! altvim#select_prev_line() abort
    let l:cmd = altvim#_count_selected_lines() > 0
        \ ? 'call altvim#_goto_prev_line()' : ''
    call altvim#_get_lines()
    exe l:cmd
endfun

fun! altvim#select_next_char() abort
    let l:cmd = altvim#_count_selected_chars() > 0
        \ ? 'call altvim#_goto_next_char()' : ''
    call altvim#_get_chars()
    exe l:cmd
endfun

fun! altvim#select_prev_char() abort
    let l:cmd = altvim#_count_selected_chars() > 0
        \ ? 'call altvim#_goto_prev_char()' : ''
    call altvim#_get_chars()
    exe l:cmd
endfun

fun! altvim#select_next_word() abort
    call altvim#_get_chars()
    call altvim#_goto_next_char()
    call altvim#goto_next_word()
    call altvim#_goto_prev_char()
endfun

fun! altvim#select_prev_word() abort
    call altvim#_get_chars()
    call altvim#goto_prev_word()
endfun

" -> number
fun! altvim#_count_selected_lines() abort
    return g:altvim#is_selection ? (line("'>") - line("'<") + 1) : 0
endfun

" -> number
fun! altvim#_count_selected_chars() abort
    return g:altvim#is_selection ? (col("'>") - col("'<") + 1) : 0
endfun

" -> string
fun! altvim#_get_selected_line_range() abort
    call altvim#_get_lines()
    return line("'<") . ',' . line("'>")
endfun

" Deleting functions
fun! altvim#_delete() abort
    call altvim#_get_lines()
    normal! "xc
endfun

fun! altvim#delete_line() abort
    call altvim#_delete()
    normal! "xdd
    call altvim#_restore_cursor_pos()
endfun

fun! altvim#clear_line() abort
    call altvim#_delete()
    call altvim#_restore_cursor_pos()
endfun

" Text navigation functions
fun! altvim#goto_last_change() abort
    normal! g;
endfun

fun! altvim#goto_line_begin() abort
    normal! ^
endfun

fun! altvim#goto_line_end() abort
    normal! $
endfun

fun! altvim#_goto_next_line() abort
    normal! j
endfun

fun! altvim#_goto_prev_line() abort
    normal! k
endfun

fun! altvim#_goto_next_char() abort
    normal! l
endfun

fun! altvim#_goto_prev_char() abort
    normal! h
endfun

fun! altvim#_goto_found_char(char, opts) abort
    call searchpos(a:char, a:opts)
endfun

fun! altvim#_goto_next_found_char(char) abort
    call altvim#_goto_found_char(a:char, '')
endfun

fun! altvim#_goto_prev_found_char(char) abort
    call altvim#_goto_found_char(a:char, 'b')
endfun

fun! altvim#goto_next_word() abort
    let l:pattern = '_[0-9A-zА-яЁё]\|#\|\>'
    call altvim#_goto_next_found_char(l:pattern)
    return altvim#_get_cursor_pos()
endfun

fun! altvim#goto_prev_word() abort
    let l:pattern = '\(_\)\@<=[A-z]\&[^\[\]]\|\(#\)\@<=[A-z]\&[^\[\]]\|\<'
    call altvim#_goto_prev_found_char(l:pattern)
    return altvim#_get_cursor_pos()
endfun

fun! altvim#goto_next_place() abort
    let l:pattern = altvim#_listen_keys(2)
    call altvim#_goto_next_found_char(l:pattern)
    return altvim#_get_cursor_pos()
endfun

fun! altvim#goto_prev_place() abort
    let l:pattern = altvim#_listen_keys(2)
    call altvim#_goto_prev_found_char(l:pattern)
    return altvim#_get_cursor_pos()
endfun

fun! altvim#goto_next_problem() abort
    call CocActionAsync('diagnosticNext')
endfun

fun! altvim#goto_prev_problem() abort
    call CocActionAsync('diagnosticPrevious')
endfun

" Move functions
" fun! altvim#_move_line(direction) abort
"     if g:altvim#is_selection && a:direction == 'up'
"         exe "'<,'>move '<-2"
"     elseif g:altvim#is_selection && a:direction == 'down'
"         exe "'<,'>move '>+"
"     elseif a:direction == 'up'
"         exe 'move-2'
"     elseif a:direction == 'down'
"         exe 'move+'
"     else
"         return
"     endif

"     call altvim#select_last_selection()
"     call altvim#format()
" endfun
fun! altvim#move_line_up() abort
    call altvim#_get_lines()
    exe altvim#_get_selected_line_range() . "move '<-2"
endfun

fun! altvim#move_line_down() abort
    call altvim#_get_lines()
    exe altvim#_get_selected_line_range() . "move '>+"
endfun

" Format functions
fun! altvim#_format_editor() abort
    call altvim#_get_lines()
    normal! =
    exe altvim#_get_selected_line_range() . 's/\v(.{80})/\1\r/ge'
endfun

fun! altvim#_format_lang() abort
    if index(g:altvim_installed_plugins, 'coc.nvim') > 0
        call altvim#_get_lines()
        call CocActionAsync('formatSelected', visualmode())
        normal! "_y
    endif
endfun

fun! altvim#format() abort
    call altvim#_format_editor()
    call altvim#_format_lang()
    call altvim#_restore_cursor_pos()
endfun

" Copy/Paste/Cut/Undo/Redo/Clone/Replace
fun! altvim#_copy() abort
    let @0 = substitute(@0, '\n\+$', '', '')
    let @0 = substitute(@0, '^\s*', '', '')

    let g:altvim#multiclipboard = 
        \ ([@0] + get(g:, 'altvim#multiclipboard', []))[:4]
endfun

fun! altvim#copy() abort
    normal! gvy
    call altvim#_copy()
endfun

fun! altvim#paste() abort
    let l:currCol = getcurpos()[4]
    let l:lastCol = col('$')
    let l:cmd = l:currCol >= l:lastCol ? 'p' : 'P'
    exe 'normal! "0' . l:cmd . '=`]g;'
endfun

fun! altvim#cut() abort
    normal! gv"0d
    call altvim#_copy()
endfun

fun! altvim#multiclipboard() abort
    call fzf#vim#complete(
        \ { 'source': get(g:, 'altvim#multiclipboard', []), 'down': 10 }
    \ )
    normal! `=]
endfun

fun! altvim#clone_line() abort
    call altvim#_get_lines()

    normal! "cyO
    let @c = substitute(@c, '\n\+$', '', '')
    let @c = substitute(@c, '^\s*', '', '')
    normal! "cp==
    let @c = ''

    call altvim#_restore_cursor_pos()
endfun

fun! altvim#_replace_found(...) abort
    exe "cdo s/" . a:1 . "/ge | :silent nohl | :silent only"
endfun

fun! altvim#replace() abort
    let l:input = input('Replace: ')
    if empty(l:input) | return | endif

    exe 'ReplaceFound ' . l:input
endfun

fun! altvim#undo() abort
    normal! u
endfun

fun! altvim#redo() abort
    exe 'redo'
endfun

fun! altvim#indent() abort
    call altvim#_get_lines()
    normal! >
    call altvim#_get_lines()
endfun

fun! altvim#outdent() abort
    call altvim#_get_lines()
    normal! <
    call altvim#_get_lines()
endfun

fun! altvim#join_lines() abort
    call altvim#_get_lines()
    normal! J
    call altvim#_restore_cursor_pos()
endfun


""
""
""
""
"" Get all filetypes that vim knows
fun! altvim#get_known_filetypes() abort
    return map(
        \ split(globpath(&rtp, 'ftplugin/*.vim'), '\n'),
        \ 'fnamemodify(v:val, ":t:r")'
    \ )
endfun

fun! altvim#set_hotkey(...) abort
    let l:args = split(a:1, ' = ')

    if len(l:args) < 2
        echoerr "[Error: altvim#set_hotkey] You must pass 2 args (key, action)"
        return
    endif

    let l:key = l:args[0]
    let l:actions = map(
        \ split(l:args[1], ','),
        \ 'substitute(v:val, "^\s*", "", "")'
    \ )

    let l:naction = get(l:actions, 0) == '_' ? '' : get(l:actions, 0)
    let l:vaction = get(l:actions, 1)

    let l:Ncmd = {key, action -> 
        \ ('inoremap <silent> '
        \ . key . ' <C-o>:let g:altvim#is_selection = 0 \| '
        \ . 'call altvim#_remember_cursor_pos() \| '
        \ . action
        \ . '<CR>')
    \ }
    let l:Vcmd = {key, action -> 
        \ ('vnoremap <silent> '
        \ . key
        \ . ' :<C-u>'
        \ . 'call altvim#_remember_cursor_pos() \| '
        \ . action
        \ . '<CR>')
    \ }
    
    if l:naction == ':' 
        exe 'inoremap ' . l:key . ' <C-o>' . l:naction
        exe 'vnoremap ' . l:key . ' ' . l:naction
    elseif empty(l:naction) && !empty(l:vaction)
        exe l:Vcmd(l:key, l:vaction)
    elseif !empty(l:naction) && empty(l:vaction)
        exe l:Ncmd(l:key, l:naction)
        exe l:Vcmd(l:key, l:naction)
    else
        exe l:Ncmd(l:key, l:naction)
        exe l:Vcmd(l:key, l:vaction)
    endif
endfun

fun! altvim#save() abort
    exe 'w'
endfun

fun! altvim#quit() abort
    exe 'q!'
endfun

fun! altvim#close_file() abort
    exe 'bdelete'
endfun

fun! altvim#scroll_page_up() abort
    normal! zb
endfun

fun! altvim#scroll_page_down() abort
    normal! zt
endfun

fun! altvim#show_project_symbols() abort
    exe 'CocList -I symbols'
endfun

fun! altvim#show_file_symbols() abort
    exe 'CocList outline'
endfun

fun! altvim#show_problems() abort
    exe 'CocList diagnostics'
endfun

fun! altvim#find_project_files() abort
    exe 'Files'
endfun

fun! altvim#show_open_files() abort
    exe 'Buffers'
endfun

fun! altvim#find_in_file() abort
    exe 'BLines'
endfun

fun! altvim#find_in_project_files() abort
    exe 'Ag'
endfun

fun! altvim#show_recent_files() abort
    exe 'History'
endfun

fun! altvim#toggle_comment() abort
    if g:altvim#is_selection
        exe "'<,'>Commentary"
    else
        exe 'Commentary'
    endif
endfun
