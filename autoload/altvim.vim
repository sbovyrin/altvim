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

function! altvim#copy()
    normal! gvy
    let @+ = substitute(@+, '\n\+$', '', '')
    let @+ = substitute(@+, '^\s*', '', '')
endfunction

function! altvim#paste()
    normal! p
endfunction

function! altvim#cut()
    normal! gvd
endfunction

" Jump to start of specific char
" Params:
"   - opts: {'mode': 'next'|'prev', 'isEnabledSelection': true|false}
" Usage:
"   - type "an" to jump first found "an" chars sequence in current file
"   - search next result if passed 'next' as first param
"   - search previous result if passed 'prev' as first param
" Note:
"   - [!] case-insensitive
"   - [!] also works in visual mode until first found
function! altvim#jump_to(opts)
    let l:mode = get(a:opts, 'mode', 'base')
    let l:isEnabledSelection = get(a:opts, 'isEnabledSelection', v:false)

    if l:mode == 'base' | let b:altvimJumpToChar = nr2char(getchar()) . nr2char(getchar()) | endif

    if l:mode == 'prev'
        let l:searchFlag = 'b'
    else
        let l:searchFlag = ''
    endif
    
    let [l:lineNumber, l:pos] = searchpos(get(b:, 'altvimJumpToChar', ''), l:searchFlag)
        
    if l:isEnabledSelection
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

function! altvim#get_known_filetypes()
    return map(split(globpath(&rtp, 'ftplugin/*.vim'), '\n'), 'fnamemodify(v:val, ":t:r")')
endfunction

command! -nargs=* SetAction inoremap <args>
command! -nargs=* SetOperation vnoremap <silent> <args>
command! -nargs=0 OpenInBrowser !google-chrome %
command! -nargs=0 SearchSelectionInFile execute ":BLines '" . altvim#get_selection()
command! -nargs=0 SearchSelectionInRoot execute ":Ag '" . altvim#get_selection()
command! -nargs=1 ReplaceFound call altvim#replace_found(<f-args>)
