" [Properties]
let g:altvim#_repeat_number = 1

" [Utils functions]

" -> string
fun! altvim#_listen_keys(number, ...) abort
    let l:input = get(a:, 1, '')
    return a:number == 0 
        \ ? join(map(split(l:input, ','), {k, v -> nr2char(v)}), '')
        \ : altvim#_listen_keys(a:number - 1, l:input .  getchar() . ',')
endfun

" [Cursor functions]
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

" [Selection functions]
fun! altvim#_select() abort
    let g:altvim#is_selection = 1
    normal! v
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
    elseif a:scope == 'word'
        let l:cmd = 'w'
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
    if g:altvim#is_selection
        normal! gv
    else
        call altvim#_select()
    endif
endfun

fun! altvim#select_till_line_end() abort
    call altvim#select_last_selection()
    call altvim#goto_line_end()
endfun

fun! altvim#select_till_line_begin() abort
    call altvim#select_last_selection()
    call altvim#goto_line_begin()
endfun

fun! altvim#select_all() abort
    let g:altvim#is_selection = 1
    normal! ggVGg
endfun

fun! altvim#select_next_line() abort
    let l:cmd = altvim#_count_selected_lines() > 0
        \ ? 'call altvim#_goto_next_line()' : ''
    
    call altvim#goto_line_begin()
    call altvim#select_last_selection()
    exe l:cmd
    call altvim#goto_line_end()
    call altvim#_goto_prev_char()
endfun

fun! altvim#select_prev_line() abort
    let l:cmd = altvim#_count_selected_lines() > 0
        \ ? 'call altvim#_goto_prev_line()' : ''
    call altvim#goto_line_end()
    call altvim#select_last_selection()
    exe l:cmd
    call altvim#goto_line_begin()
endfun

fun! altvim#select_next_char() abort
    let l:cmd = altvim#_count_selected_chars() > 0
        \ ? 'call altvim#_goto_next_char()' : ''
    call altvim#select_last_selection()
    exe l:cmd
endfun

fun! altvim#select_prev_char() abort
    let l:cmd = altvim#_count_selected_chars() > 0
        \ ? 'call altvim#_goto_prev_char()' : ''
    call altvim#select_last_selection()
    exe l:cmd
endfun

fun! altvim#select_word() abort
    call altvim#select_last_selection()
    call altvim#_goto_next_char()
    call altvim#goto_next_word()
    call altvim#_goto_prev_char()
endfun

fun! altvim#backward_select_word() abort
    call altvim#select_last_selection()
    call altvim#goto_prev_word()
endfun

fun! altvim#select_till_char() abort
    call altvim#select_last_selection()
    call altvim#_goto_next_char()
    call altvim#goto_next_place() 
    call altvim#_goto_prev_char()
endfun

fun! altvim#backward_select_till_char() abort
    call altvim#select_last_selection()
    call altvim#goto_prev_place()
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
    call altvim#select_last_selection()
    return line("'<") . ',' . line("'>")
endfun

" [Deleting functions]
fun! altvim#delete() abort
    call altvim#select_last_selection()
    if (col('$') - col('^')) > 1
        normal! "xc
    endif
endfun

fun! altvim#delete_line() abort
    call altvim#delete()
    normal! "xdd
    call altvim#_restore_cursor_pos()
endfun

fun! altvim#clear_line() abort
    call altvim#delete()
    call altvim#_restore_cursor_pos()
endfun

" Text navigation functions
fun! altvim#_goto_next_line() abort
    exe "normal! " . g:altvim#_repeat_number . "j"
endfun

fun! altvim#_goto_prev_line() abort
    exe "normal! " . g:altvim#_repeat_number . "k"
endfun

fun! altvim#_goto_next_char() abort
    exe "normal! " . g:altvim#_repeat_number . "l"
endfun

fun! altvim#_goto_prev_char() abort
    exe "normal! " . g:altvim#_repeat_number . "h"
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

fun! altvim#goto_last_change() abort
    normal! g;
endfun

fun! altvim#goto_line_begin() abort
    normal! ^
endfun

fun! altvim#goto_line_end() abort
    normal! $
endfun

fun! altvim#find_place() abort
    let g:altvim#_place_pattern = altvim#_listen_keys(2)
    call altvim#goto_next_place()
endfun

fun! altvim#goto_next_place() abort
    call altvim#_goto_next_found_char(get(g:, 'altvim#_place_pattern', ''))
    return altvim#_get_cursor_pos()
endfun

fun! altvim#goto_prev_place() abort
    call altvim#_goto_prev_found_char(get(g:, 'altvim#_place_pattern', ''))
    return altvim#_get_cursor_pos()
endfun

fun! altvim#goto_next_problem() abort
    call CocActionAsync('diagnosticNext')
endfun

fun! altvim#goto_prev_problem() abort
    call CocActionAsync('diagnosticPrevious')
endfun

" Format functions
fun! altvim#_format_editor() abort
    call altvim#select_last_selection()
    normal! =
    exe altvim#_get_selected_line_range() . 's/\v(.{80})/\1\r/ge'
endfun

fun! altvim#_format_lang() abort
    if index(g:altvim_installed_plugins, 'coc.nvim') > 0
        call altvim#select_last_selection()
        call CocActionAsync('formatSelected', visualmode())
        normal! "_y
    endif
endfun

fun! altvim#format() abort
    " call altvim#_format_editor()
    call altvim#_format_lang()
    call altvim#_restore_cursor_pos()
endfun

" Copy/Paste/Cut/Undo/Redo/Clone/Replace
fun! altvim#_copy() abort
    let @0 = substitute(@0, '\n\+$', '', '')
    let @0 = substitute(@0, '^\s*', '', '')
    
    if system('uname -r') =~ 'microsoft'
        call system('clip.exe', @0)
    endif

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
    call altvim#select_last_selection()

    normal! "cyO
    let @c = substitute(@c, '\n\+$', '', '')
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
    call altvim#select_last_selection()
    normal! >
    call altvim#select_last_selection()
endfun

fun! altvim#outdent() abort
    call altvim#select_last_selection()
    normal! <
    call altvim#select_last_selection()
endfun

fun! altvim#join_lines() abort
    call altvim#select_last_selection()
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
        \ . ' :<C-u>let g:altvim#_repeat_number = v:count1 \| '
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

""""""
""""""
""""""

fun! altvim#i_go_to_specific_place()
    let l:key = input("Jump to: ")
    
    if str2nr(l:key) != 0
        let l:place = split(l:key, ':')
        call cursor(get(l:place, 0), get(l:place, 1, 1))
        return
    endif
    
    let g:altvim#specific_place = l:key
    call altvim#i_find_specific_place('next')
endfun

fun! altvim#i_find_specific_place(direction)
    call searchpos(
    \   get(g:, 'altvim#specific_place', ''),
    \   (a:direction == 'next' ? '' : 'b')
    \)
endfun

fun! altvim#i_go_to_block(direction)
    call searchpos(
    \   '(\|\[\|<\|{\|`.*\|".*\|' . "'.*",
    \   (a:direction == 'next' ? '' : 'b')
    \)
endfun

fun! altvim#i_go_to_paired()
    normal! %
endfun

fun! altvim#i_go_to_occurrence(direction)
    exe 'normal! ' . (a:direction == 'next' ? '*' : '#')
    exe 'nohl'
endfun

fun! altvim#i_go_to_word(direction)
    let l:pattern_start = '\(\([^a-zA-Z0-9]\|[\n]\)\zs[a-zA-Z0-9]\)\|[a-z]\zs[A-Z0-9]'
    let l:pattern_end = '[a-zA-Z0-9]\ze\([^a-zA-Z0-9]\|[\n]\)'
    
    if getline('.')[col('.') - 1] =~ '\W\|_'
        normal! h
    endif

    let [l:line, l:col] = searchpos(
    \   l:pattern_start . '\|' . l:pattern_end,
    \   (a:direction == 'next' ? '' : 'b')
    \)
    
    if getline(l:line)[l:col] =~ '\W\|_'
        normal! l
    endif
endfun
