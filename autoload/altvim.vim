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

fun! altvim#multiclipboard() abort
    call fzf#vim#complete(
        \ { 'source': get(g:, 'altvim#multiclipboard', []), 'down': 10 }
    \ )
    normal! `=]
endfun


" [Core]
fun! altvim#perform_selection_action(action)
    let b:altvim_is_selection = 1
    exe a:action 
endfun

fun! altvim#perform_action(action)
    let b:altvim_is_selection = 0
    exe a:action 
endfun


fun! altvim#set_hotkey(...)
    let l:args = split(a:1, ' = ')

    if len(l:args) < 2
        echoerr "[Error: altvim#set_hotkey] You must pass 2 args (key, action)"
        return
    endif

    let l:key = l:args[0]
    let l:actions = map(
    \   split(l:args[1], ','),
    \   'substitute(v:val, "^\s*", "", "")'
    \)
    
    let l:naction = get(l:actions, 0) == '_' ? '' : get(l:actions, 0)
    let l:vaction = get(l:actions, 1, l:naction)

    let l:Ncmd = {key, action -> 
                \ ('inoremap <silent> '
                \ . key . ' <C-o>:'
                \ . 'call altvim#perform_action("' . action . '")'
                \ . '<CR>')
                \ }
    let l:Vcmd = {key, action -> 
                \ ('vnoremap <silent> '
                \ . key
                \ . ' :<C-u>'
                \ . 'call altvim#perform_selection_action("' . action . '")' 
                \ . '<CR>')
                \ }

    if l:naction == ':' 
        exe 'inoremap ' . l:key . ' <C-o>' . l:naction
        exe 'vnoremap ' . l:key . ' ' . l:naction
    elseif empty(l:naction) && !empty(l:vaction)
        exe l:Vcmd(l:key, l:vaction)
    " elseif !empty(l:naction) && empty(l:vaction)
    "     exe l:Ncmd(l:key, l:naction)
    "     exe l:Vcmd(l:key, l:naction)
    else
        exe l:Ncmd(l:key, l:naction)
        exe l:Vcmd(l:key, l:vaction)
    endif
endfun


" [Editor]
fun! altvim#save()
    exe 'w'
endfun

fun! altvim#quit()
    exe 'q!'
endfun

fun! altvim#close_file()
    exe 'bdelete'
endfun


" [Navigation]
fun! altvim#go_to_specific_place()
    let l:key = input("Jump to: ")
    
    " if input is number
    if str2nr(l:key) != 0
        let l:place = split(l:key, ':')
        call cursor(get(l:place, 0), get(l:place, 1, 1))
        return
    endif
    
    let b:altvim_specific_place = l:key
    call altvim#find_specific_place('next')
endfun

fun! altvim#find_specific_place(direction)
    call searchpos(
    \   get(b:, 'altvim_specific_place', ''),
    \   'W' . (a:direction == 'next' ? '' : 'b')
    \)
endfun

fun! altvim#go_to_block(direction)
    call searchpos(
    \   '(\|\[\|<\|{\|`.*\|".*\|' . "'.*",
    \   'W' . (a:direction == 'next' ? '' : 'b')
    \)
endfun

fun! altvim#go_to_paired()
    normal! %
endfun

fun! altvim#go_to_occurrence(direction)
    exe 'normal! ' . (a:direction == 'next' ? '*' : '#')
    exe 'nohl'
endfun

fun! altvim#go_to_word(direction, ...)
    let l:pattern_start = '\(\([^a-zA-Zа-яА-Я0-9]\|[\n]\)\zs[a-zA-Zа-яА-Я0-9]\)\|[a-z]\zs[A-Z0-9]'
    let l:pattern_end = '[a-zA-Zа-яА-Я0-9]\ze\([^a-zA-Zа-яА-Я0-9]\|[\n]\)'
    
    " perform only for not selection purpose
    if (a:0 < 1) && (getline('.')[col('.') - 1] =~ '\W\|_')
        normal! h
    endif

    let [l:line, l:col] = searchpos(
    \   l:pattern_start . '\|' . l:pattern_end,
    \   'W' . (a:direction == 'next' ? '' : 'b')
    \)
    
    " perform only for not selection purpose
    if (a:0 < 1) && (getline(l:line)[l:col] =~ '\W\|_')
        normal! l
    endif
endfun

fun! altvim#go_to_last_change()
    normal! g;
endfun

fun! altvim#go_to_line(position)
    exe 'normal! ' (a:position == 'begin' ? '^' : '$')
endfun

fun! altvim#go_to_next_problem()
    call CocActionAsync('diagnosticNext')
endfun

fun! altvim#go_to_prev_problem()
    call CocActionAsync('diagnosticPrevious')
endfun


" [Selection]
fun! altvim#select()
    exe 'normal! ' . (b:altvim_is_selection ? 'gv' : 'v')
endfun

fun! altvim#select_rectangular()
   exe "normal! \<C-v>"
endfun

fun! altvim#select_to_word(direction)
    call altvim#select()
    exe 'normal! ' . (a:direction == 'next' ? 'l' : 'h')
    call altvim#go_to_word(a:direction, v:true)
endfun

fun! altvim#select_to_paired()
    call altvim#select()
    call altvim#go_to_paired()
endfun

fun! altvim#select_to_block(direction)
    call altvim#select()
    call altvim#go_to_block(a:direction)
endfun

fun! altvim#select_to_specific_place()
    call altvim#select()
    call altvim#go_to_specific_place()
endfun

fun! altvim#select_to_found_specific_place(direction)
    call altvim#select()
    call altvim#find_specific_place(a:direction)
endfun

fun! altvim#select_char(direction)
    call altvim#select()
    exe 'normal! ' . (a:direction == 'next' ? 'l' : 'h')
endfun

fun! altvim#select_line(direction)
    call altvim#select()
    exe 'normal! ' . (a:direction == 'next' ? 'j' : 'k')
endfun

fun! altvim#select_till_line(position)
    call altvim#select()
    exe 'normal! ' . (a:position == 'begin' ? '^' : '$h')
endfun

fun! altvim#select_last_selection()
    normal! gv
endfun

fun! altvim#select_all()
    normal! ggVG
endfun

fun! altvim#select_scope(scope)
    let l:scopes = {
    \   "parentheses": "(",
    \   "braces": "{",
    \   "square_brackets": "[",
    \   "tag_content": "t",
    \   "tag": "<",
    \   "double_quotes": '"',
    \   "single_quotes": "'",
    \   "back_quotes": "`",
    \   "word": "w"
    \}

    if !has_key(l:scopes, a:scope) | return | endif
    
    exe 'normal! gvi' . get(l:scopes, a:scope)
endfun


" [Editing]
fun! altvim#delete()
    if b:altvim_is_selection
        call altvim#select()
    endif
    normal! "xd
endfun

fun! altvim#delete_line()
    call altvim#delete()
    normal! dd
endfun

fun! altvim#copy()
    call altvim#select()
    normal! y
 
    " windows wsl tweak
    if system('uname -r') =~ 'microsoft'
        call system('clip.exe', @0)
    endif

    " let g:altvim#multiclipboard = 
    "     \ ([@0] + get(g:, 'altvim#multiclipboard', []))[:4]
endfun

fun! altvim#paste() 
    if (getline('.')[col('.')] == '' )
        \ && (getline('.')[col('.') - 1] !~ ')\|]\|}')
        normal! "0p==
    else
        normal! "0P==
    endif
endfun

fun! altvim#cut()
    call altvim#copy()
    normal! gv"xd
endfun

fun! altvim#undo()
    normal! u
endfun

fun! altvim#redo()
    exe 'redo'
endfun

fun! altvim#indent()
    call altvim#select()
    normal! >
    call altvim#select()
endfun

fun! altvim#outdent()
    call altvim#select()
    normal! <
    call altvim#select()
endfun

fun! altvim#join_lines()
    call altvim#select()
    normal! J
endfun

fun! altvim#clone_line()
    if !b:altvim_is_selection
        normal! $v^
    else
        call altvim#select()
    endif
    
    normal! "cyO
    normal! "cp==
endfun

fun! altvim#replace()
    let l:find = input('Find: ')
    let l:val = fzf#vim#buffer_lines(l:find)
    let l:replace = input('Replace: ')
    
    let l:nLines = map(l:val[1:], 'str2nr(v:val)')
    
    for n in l:nLines
        exe n . 's/' . l:find . '/' . l:replace . '/gI'
    endfor
    
    exe 'nohl'
endfun

fun! altvim#replace_all()
    let l:find = input('Find: ')
    let l:replace = input('Replace: ')
    
    exe '%s/' . l:find . '/' . l:replace . '/gI | nohl'
endfun


" [Plugins]
fun! altvim#show_project_symbols()
    exe 'CocList -I symbols'
endfun

fun! altvim#show_file_symbols()
    exe 'CocList outline'
endfun

fun! altvim#show_problems()
    exe 'CocList diagnostics'
endfun

fun! altvim#find_project_files()
    exe 'ProjectFiles'
endfun

fun! altvim#show_open_files()
    exe 'Buffers'
endfun

fun! altvim#find_in_file()
    exe 'BLines'
endfun

fun! altvim#find_in_project_files()
    exe 'Rg'
endfun

fun! altvim#show_recent_files()
    exe 'History'
endfun

fun! altvim#toggle_comment()
    if b:altvim_is_selection
        exe "'<,'>Commentary"
    else
        exe 'Commentary'
    endif
endfun

fun! altvim#format()
    " call altvim#select()
    " normal! gq
    if index(g:altvim_installed_plugins, 'coc.nvim') < 1 | return | endif
    " call altvim#select()
    call CocActionAsync('formatSelected', visualmode())
endfun
