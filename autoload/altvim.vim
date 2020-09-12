fun! altvim#copy()
    normal! "0y
    
    if system('uname -r') =~ 'microsoft'
        call system('clip.exe', @0)
    endif
endfun

fun! altvim#paste()
    let @0=join(split(@0, "\n"), "\n")
    norm! "0P=']
endfun

fun! altvim#greplace() 
    let l:expr = input("> ")
    exe 'cfdo %s/' . l:expr . '/g'
    exe 'on'
endfun

fun! altvim#replace()
    let l:expr = input(@/ . "/")
    let l:expr = split(l:expr, '/')
    
    if len(expr) > 1
       if l:expr[1] =~ 'a'
        exe '1,$s/' . @/ . '/' . l:expr[0] . '/g'
       endif
    else
        exe 's/' . @/ . '/' . l:expr[0] . '/g'
    endif
endfun

fun! altvim#record()
    let g:altvim_is_recording = get(g:, 'altvim_is_recording', 0)
    
    if g:altvim_is_recording == 0
        let g:altvim_is_recording = 1
        norm! qa
    else
        let g:altvim_is_recording = 0
        norm! q
    endif
endfun

fun! altvim#lsp_status() abort
    let l:info = get(b:, 'coc_diagnostic_info', {})
    if empty(l:info) | return '' | endif
    
    let l:msgs = []
    
    if get(l:info, 'error', 0)
        call add(msgs, 'E' . info['error'])
    endif
    
    if get(l:info, 'warning', 0)
        call add(msgs, 'W' . info['warning'])
    endif
    
    if len(l:msgs) > 0
        let l:msgs = [' ['] + msgs + [']']
    endif
    
    return join(l:msgs, '')
endfun
