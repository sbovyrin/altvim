function! altvim#is_active_plugin(pluginName) abort
    return has_key(g:plugs, a:pluginName) && isdirectory(g:plugs[a:pluginName].dir)
endfunction

function! altvim#format()
    if (line("'>") - line("'<") + 1) > 1
        normal! gv=
    else
        normal! gv=gvgq
    endif
endfunction

function! altvim#replace_found(...)
    exe "cdo s/" . a:1 . "/ge | :silent nohl | :silent only"
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

" Nowhere using
" function! s:getchar(...)
"     let l:chars = a:0 > 0 ? a:1 : {}
"     let l:char = nr2char(getchar())
"     if l:char =~ '\a'
"         let l:chars.operation = l:char
"         return l:chars
"     endif
"     let l:chars.count =  has_key(l:chars, 'count') 
"                 \ ? get(l:chars, 'count') .  l:char
"                 \ : l:char
"     return s:getchar(l:chars)
" endfunction

" Go to a specific char in a line or a specific line
" Usage:
"   - 12d   go to char 'd' in 12 line
"   - 12    go to 12 line
"   - d     go to char 'd' in current line
" Note:
"   - [!] also works in visual mode
function! altvim#go_to(mode)
    let l:searchPattern = input("")
    let l:number = get(split(l:searchPattern, '\D'), 0)
    let l:char = get(split(l:searchPattern, '\d'), 0)

    let l:cmd = ''

    if l:number == 0 && l:char != ''
        let l:cmd = 'f' . l:char
    elseif l:number != 0 && l:char != ''
        let l:cmd = l:number . 'Gf' . l:char
    elseif l:number != 0 && l:char == ''
        let l:cmd = l:number . 'G'
    endif
    let l:cmd = a:mode == 'v' ? 'gv' . l:cmd : l:cmd
    exe 'normal! ' . l:cmd
endfunction

function! altvim#select_word()
    let l:currSymbol = getline('.')[col('.') - 1]
    let l:prevSymbol = getline('.')[col('.') - 2]

    let l:condition =  (matchstr(l:prevSymbol, '\w') != '' && matchstr(l:currSymbol, '\w') != '')

    exe 'normal! ' . (l:condition ? 'bv' : 'v') . 'eh'
endfunction

function! altvim#select_line(type, mode)
    if a:type == 'nextline'
        exe 'normal! ' . (a:mode == 'V' ? 'gv' . v:count1 . 'j' : 'V')
    elseif a:type == 'prevline'
        exe 'normal! ' . (a:mode == 'V' ? 'gv' . v:count1 . 'k' : 'V')
    endif
endfunction


command! -nargs=* SetAction inoremap <args>
command! -nargs=* SetOperation vnoremap <silent> <args>
command! -nargs=0 OpenInBrowser !google-chrome %
command! -nargs=0 SearchSelectionInFile execute ":BLines '" . altvim#get_selection()
command! -nargs=0 SearchSelectionInRoot execute ":Ag '" . altvim#get_selection()
command! -nargs=1 ReplaceFound call altvim#replace_found(<f-args>)
