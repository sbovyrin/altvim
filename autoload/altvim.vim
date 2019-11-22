function! altvim#format()
    if (line("'>") - line("'<") + 1) > 1
        normal! gv=
    else
        normal! gv=gvgq
    endif
endfunction

function! altvim#get_selection()
    let [line_start, column_start] = getpos("'<")[1:2]
    let [line_end, column_end] = getpos("'>")[1:2]
    let lines = getline(line_start, line_end)
    if len(lines) == 0
        return ''
    endif
    let lines[-1] = lines[-1][: column_end - 2]
    let lines[0] = lines[0][column_start - 1:]
    return join(lines, "\n")
endfunction

function! altvim#select_word()
    let l:currSymbol = getline('.')[col('.') - 1]
    let l:prevSymbol = getline('.')[col('.') - 2]

    let l:condition =  (matchstr(l:prevSymbol, '\w') != '' && matchstr(l:currSymbol, '\w') != '')

    exe 'normal! ' . (l:condition ? 'bv' : 'v') . 'eh'
endfunction

" Replace found results
function! altvim#replace_found(...) abort
    exe "cdo s/" . a:1 . "/ge | :silent nohl | :silent only"
endfunction

function! altvim#cloneline()
    if g:altvim#is_selection
        normal! gv
    else
        normal! ^v$
    endif

    normal! "cyO
    let @c = substitute(@c, '\n\+$', '', '')
    let @c = substitute(@c, '^\s*', '', '')
    normal! "cp==g;
endfunction

" Copy function that implement multiclipboard
function! altvim#_copy() abort
    let @0 = substitute(@0, '\n\+$', '', '')
    let @0 = substitute(@0, '^\s*', '', '')
    let @+ = @0
    " let l:multiclipboard = [@0] + (empty(@e) ? [] : eval(@e))
    " let @e = string(l:multiclipboard[:4])
endfunction

" Improved copy
function! altvim#copy() abort
    normal! gvy
    call altvim#_copy()
endfunction

" Simple paste
function! altvim#paste() abort
    if indent(line('.')) + 1 == col('.')
        exec "normal! i\<space>"
        normal! h
    endif
    normal! p==g;
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
" Params:
"   - opts: {'type': 'line|char|nextline|nextchar|prevline|prevchar', 'isSelected': 1|0}
" Note:
" - input a number N to select N line/s. Default value N = 1
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


" Jump to start of specific char
" Params:
"   - mode: 'next'|'prev'
" Usage:
"   - type "an" to jump first found "an" chars sequence in current file
"   - search next result if passed 'next' as first param
"   - search previous result if passed 'prev' as first param
" Note:
"   - [!] case-insensitive
"   - [!] also works in visual mode until first found
function! altvim#jump_to(...) abort
    let l:mode = get(a:, '1', 'base')

    if l:mode == 'base' | let b:altvimJumpToChar = nr2char(getchar()) . nr2char(getchar()) | endif

    if l:mode == 'prev'
        let l:searchFlag = 'b'
    else
        let l:searchFlag = ''
    endif
    
    let [l:lineNumber, l:pos] = searchpos(get(b:, 'altvimJumpToChar', ''), l:searchFlag)
        
    if g:altvim#is_selection
        if l:mode == 'prev'
            let l:selectionDirection = "'<"
            let l:pos = l:pos + 1
        else
            let l:selectionDirection = "'>"
            let l:pos = l:pos - 1
        endif
        call setpos(l:selectionDirection, [0, l:lineNumber, l:pos, 0])
        normal! gv
    endif
endfunction

" Get all filetypes that vim knows
function! altvim#get_known_filetypes() abort
    return map(split(globpath(&rtp, 'ftplugin/*.vim'), '\n'), 'fnamemodify(v:val, ":t:r")')
endfunction

function! altvim#set_hotkey(...) abort
    let l:args = split(a:1, ' = ')
    let l:key = l:args[0]
    let l:actions = map(split(l:args[1], ','), 'substitute(v:val, "^\s*", "", "")')

    let l:naction = get(l:actions, 0) == '_' ? '' : get(l:actions, 0)
    let l:vaction = get(l:actions, 1)
    
    if len(l:args) < 2
        echoerr "[Error: altvim#set_hotkey] You must pass 2 args (key, action)"
        return
    endif
    
    if l:naction == ':'
        exec 'inoremap ' . l:key . ' <C-o>' . l:naction
        exec 'vnoremap ' . l:key . ' ' . l:naction
    elseif empty(l:naction) && !empty(l:vaction)
        exec 'vnoremap ' . l:key . ' :<C-u>let g:altvim#is_selection=1 \| ' . l:vaction . '<CR>'
    elseif !empty(l:naction) && empty(l:vaction)
        exec 'inoremap ' . l:key . ' <C-o>:let g:altvim#is_selection=0 \| ' . l:naction . '<CR>'
        exec 'vnoremap ' . l:key . ' :<C-u>let g:altvim#is_selection=1 \| ' . l:naction . '<CR>'
    else
        exec 'inoremap ' . l:key . ' <C-o>:let g:altvim#is_selection=0 \| ' . l:naction . '<CR>'
        exec 'vnoremap ' . l:key . ' :<C-u>let g:altvim#is_selection=1 \| ' . l:vaction . '<CR>'
    endif
endfunction

function! altvim#save()
    exec 'w'
endfunction

function! altvim#quit()
    exec 'q!'
endfunction

function! altvim#close_file()
    exec 'bdelete'
endfunction

function! altvim#undo()
    normal! u
endfunction

function! altvim#redo()
    exec 'redo'
endfunction

function! altvim#delete_line()
    if g:altvim#is_selection
        normal! gv
    else
        normal! V
    endif
    
    normal! "_d==g;
endfunction

function! altvim#clear_line()
    normal! gv"xc
    normal! ==g;
    
    if col('.') == 1 && indent(line('.')) + 1 != col('.')
        normal! ^
    endif
endfunction

function! altvim#repeat_last_action()
    normal! .
endfunction
        
function! altvim#indent()
    normal! gv>gv
endfunction

function! altvim#outdent()
    normal! gv<gv
endfunction

function! altvim#join_line()
    normal! J
endfunction

function! altvim#replace()
    let l:input = input('Replace: ')
    if empty(l:input) | return | endif

    exec 'ReplaceFound ' . l:input
endfunction     

function! altvim#goto_last_change()
    normal! g;
endfunction

function! altvim#scroll_page(direction)
    if a:direction == 'up'
        let l:cmd = 'zb'
    elseif a:direction == 'down'
        let l:cmd = 'zt'
    endif
    
    if empty(l:cmd) | return | endif

    exec 'normal! ' . l:cmd
endfunction

function! altvim#select_last_selection()
    normal! gv
endfunction

function! altvim#select_all()
    normal! ggVGg
endfunction

function! altvim#select_content(type, scope)
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
    endif
    
    if empty(l:cmd) | return | endif

    exec 'normal! gv' . a:type . l:cmd
endfunction

function! altvim#select_content_within(scope)
    call altvim#select_content('i', a:scope)
endfunction

function! altvim#select_content_within_included(scope)
   call altvim#select_content('a', a:scope)
endfunction

function! altvim#move_line(direction)
    if g:altvim#is_selection && a:direction == 'up'
        exec "'<,'>move-2"
    elseif g:altvim#is_selection && a:direction == 'down'
        exec "'<,'>move+2"
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

function! altvim#goto_line_begin()
    if g:altvim#is_selection
        normal! gv
    endif

    normal! ^
endfunction

function! altvim#goto_line_end()
    if g:altvim#is_selection
        normal! gv
    endif

    normal! $
endfunction

function! altvim#goto_next_word()
    if g:altvim#is_selection
        normal! gve
    else
        normal! w
    endif
endfunction

function! altvim#goto_prev_word()
    if g:altvim#is_selection
        normal! gv
    endif

    normal! b
endfunction

function! altvim#show_project_symbols()
    exec 'CocList -I symbols'
endfunction

function! altvim#show_file_symbols()
    exec 'CocList outline'
endfunction

function! altvim#format_lang()
    call CocActionAsync('formatSelected', visualmode())
endfunction

function! altvim#show_problems()
    exec 'CocList diagnostics'
endfunction

function! altvim#goto_next_problem()
    call CocActionAsync('diagnosticNext')
endfunction

function! altvim#goto_prev_problem()
    call CocActionAsync('diagnosticPrevious')
endfunction

function! altvim#find_project_files()
    exec 'Files'
endfunction

function! altvim#show_open_files()
    exec 'Buffers'
endfunction

function! altvim#find_in_file()
    exec 'BLines'
endfunction

function! altvim#find_in_project_files()
    exec 'Ag'
endfunction

function! altvim#show_recent_files()
    exec 'History'
endfunction

function! altvim#toggle_comment()
    exec 'Commentary'
endfunction
